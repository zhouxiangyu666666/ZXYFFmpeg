//
//  ViewController.m
//  FFmpegDemo
//
//  Created by Jeremy on 2017/12/12.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ViewController.h"
#import "ffmpeg.h"
#define DocumentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define DocumentPath(res) [DocumentDir stringByAppendingPathComponent:res]

#define TempDir NSTemporaryDirectory()
#define TempPath(res) [TempDir stringByAppendingPathComponent:res]
#define BundlePath(res) [[NSBundle mainBundle] pathForResource:res ofType:nil]
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)compose:(UIButton *)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        char *inputPic = (char *)[DocumentPath(@"%d.jpg") UTF8String];
        char *movie = (char *)[[self returnPathMovieName:@"myMovie2"] UTF8String];
        char *inputPicChar = (char *)[@"1" UTF8String];
        char *outputPicChar = (char *)[@"5" UTF8String];
        printf("%s", inputPic);
        printf("%s", movie);
        char* a[] = {
            "ffmpeg",
            "-r",
            inputPicChar,
            "-i", 
            inputPic,
            "-vcodec",
            "mpeg4",
            "-r",
            outputPicChar,
            movie
        };
        ffmpeg_main(sizeof(a)/sizeof(*a), a);
    });
}
- (IBAction)slice:(UIButton *)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        char *movie = (char *)[[self returnPathMovieName:@"myMovie2"] UTF8String];
        char *outPic = (char *)[TempPath(@"%d.jpg") UTF8String];
        
        char *a[]={
              "ffmpeg",
              "-i",
              movie,
              "-r",
              "1",
              outPic
        };
        NSLog(@"%s",outPic);
        ffmpeg_main(sizeof(a)/sizeof(*a), a);
    });
}
- (IBAction)addText:(UIButton *)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        char *movie = (char *)[[self returnPathMovieName:@"myMovie2"] UTF8String];
        char *outPic = (char *)[TempPath(@"myMovie3.mp4") UTF8String];
        char logo[1024];
        
        WaterMarkPosition position = LeftUp;
        char *ffmpegPosition;
        
        switch (position) {
            case LeftUp:{
                //overlay是指水印的位置，冒号前面是横坐标，后面是纵坐标，main_h、overlay_h分别指的是视频的高度和所添加图片的高度
                ffmpegPosition = "movie=%s [logo]; [in][logo] overlay=20:20 [out]";
                break;
            }
            case LeftDown:{
                ffmpegPosition = "movie=%s [logo]; [in][logo] overlay=20:main_h-overlay_h [out]";
                break;
            }
            case RightUp:{
                ffmpegPosition = "movie=%s [logo]; [in][logo] overlay=main_w-overlay_w-20:20 [out]";
                break;
            }
            case RightDown:{
                ffmpegPosition = "movie=%s [logo]; [in][logo] overlay=main_w-overlay_w-20:main_h-overlay_h-20 [out]";
                break;
            }
            case Center:{
                ffmpegPosition = "movie=%s [logo]; [in][logo] overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2 [out]";
                break;
            }
        }
        sprintf(logo,ffmpegPosition,[BundlePath(@"ff.jpg") UTF8String]);
        
        char *a[]={
           "ffmpeg",
            "-i",
            movie,
            "-vf",
            logo,
            outPic
        };
        
        ffmpeg_main(sizeof(a)/sizeof(*a), a);
    });
}
- (IBAction)addMedia:(UIButton *)sender {
    char *movie = (char *)[[self returnPathMovieName:@"myMovie2"] UTF8String];
    char *music = (char *)[BundlePath(@"asd.aac") UTF8String];
    char *output = (char *)[TempPath(@"myMovie4.mp4") UTF8String];
    char *time = (char *)[@"0:0:10" UTF8String];

    char *a[] = {
          "ffmpeg",
          "-i",
          movie,
          "-i",
          music,
          "-t",
          time,
          output
    };
    ffmpeg_main(sizeof(a)/sizeof(*a), a);
}
- (IBAction)switchFormat:(UIButton *)sender {
    
    char *inPut = (char *)[[self returnPathMovieName:@"myMovie2"] UTF8String];
    char *outPut = (char *)[TempPath(@"myMovie5.avi") UTF8String];
    
    char *a[]={
          "ffmpeg",
          "-i",
          inPut,
          outPut
    };
    ffmpeg_main(sizeof(a)/sizeof(*a), a);
}


-(NSString *)returnPathMovieName:(NSString *)movieName
{
    return DocumentPath([movieName stringByAppendingString:@".mp4"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
