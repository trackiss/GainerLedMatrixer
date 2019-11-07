//import processing.gainer.*;

//-----guiの座標、だいたい8*8のスイッチが基準-----
int gui_x = 60;
int gui_y = 60;
int gui_size = 20;

//-----入力用配列
boolean[][][] Scr_1 = new boolean[8][8][8];

int Scene = 0;

//-----gui周りの処理用変数-----
boolean[] button = new boolean[9];
boolean[] Player = new boolean[2];
boolean[] Time = new boolean[2];
boolean Delete = false;

//-----それぞれアノード、カソード、出力用の16進数を格納する配列-----
String[][] Out_A = new String[8][8];
String[][] Out_C = new String[8][8];
String[][] Out_H = new String[8][8];

//-----waitingの初期値-----
long WaitTime = 30;
long AnimeTime = 500;

void setup(){
  
  frameRate(60);
  size(240, 240);
  background(255);
  stroke(0);
  strokeWeight(1);
  fill(255);
  noSmooth();
  
  //-----フォント周りの準備-----
  PFont font_MSGo = loadFont("MS-Gothic-12.vlw");
  textFont(font_MSGo, 12);
  textAlign(CENTER, CENTER);
  
  //-----一部変数の初期値-----
  button[0] = true;
  Player[1] = true;
  Time[0] = true;
  
  //-----カソード格納用配列の初期化
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
      Out_C[i][j] = "00000000";
    }
  }
  
//-----gainer周りの準備-----
//  Gainer gainer = new Gainer(this, "COM4", Gainer.MODE6);
//  gainer.turnOnLED();
//  int t = getSeconds();
  
}

void draw(){
  
  //gainerに出力している間は、停止処理を除く全ての処理をスキップ
  //-----gainer未出力時のスタンダードな処理↓-----
  if(!Player[0]){
    
  strokeWeight(1);
  
  background(0xffefd5);
  
  int k = 7;
  
  fill(255);
  
  //-----waiting、Delete、シーン切り替え周りの描画↓-----
  
  rect(gui_x, -1, gui_size, gui_size+1);
  rect(gui_x, gui_size, gui_size, gui_size);
  rect(gui_x+gui_size*4, -1, gui_size, gui_size+1);
  rect(gui_x+gui_size*4, gui_size, gui_size, gui_size);
  rect(gui_x+gui_size*5, -1, gui_size, gui_size*2+1);
  rect(gui_x+gui_size*7, -1, gui_size, gui_size*2+1);
  
  fill(255,99,71);
  
  rect(gui_x+gui_size*8, -1, gui_size, gui_size*2);
    
  fill(0);
  
  text("+10", gui_x+gui_size/2+1, gui_size/2);
  text("+1", gui_x+gui_size/2+1, gui_size*3/2);
  text("-10", gui_x+gui_size*9/2+1, gui_size/2);
  text("-1", gui_x+gui_size*9/2+1, gui_size*3/2);
  text("<<", gui_x+gui_size*11/2+1, gui_size);
  text(Scene+1, gui_x+gui_size*13/2+1, gui_size);
  text(">>", gui_x+gui_size*15/2+1, gui_size);
  text("×", gui_x+gui_size*17/2+1, gui_size);
  
  //-----waiting、Delete周りの描画↑-----
  
  for(int i=0;i<9;i++){
    
    //-----再生・停止周りの描画↓-----
    
    if(i<2){
      if(!Player[i]){
        fill(224);
      }else{
        fill(192);
      }
      
      if(i==0){
        rect(-1, -1, gui_x/2, gui_y-gui_size);
      }else{
        rect(gui_x/2-1, -1, gui_x/2+1, gui_y-gui_size);
      }
      
      if(!Time[i]){
        fill(224);
      }else{
        fill(192);
      }
      
      //-----waiting周りの描画↓-----
      if(i==0){
        rect(gui_x+gui_size, -1, gui_size*3, gui_size+1);
      }else{
        rect(gui_x+gui_size, gui_size, gui_size*3, gui_size);
      }
      
      fill(0);
      
      text("Wait:" + int(WaitTime), gui_x+gui_size*5/2+1, gui_size/2);
      text("Anim:" + int(AnimeTime), gui_x+gui_size*5/2+1, gui_size*3/2);
      //-----waiting周りの描画↑-----
    }
    
    //-----正三角形の描画↓-----
    
    fill(0);
    
    pushMatrix();
    translate(gui_x/4-3, (gui_y-gui_size)/2);
    
    beginShape();
    for(int j=0;j<3;j++){
      vertex(10*cos(radians(360*j/3)), 10*sin(radians(360*j/3)));
    }
    endShape(CLOSE);
    popMatrix();
    
    //-----正三角形の描画↑-----
    
    rect(36, 12, 16, 16);
    
    //-----再生・停止周りの描画↑-----
    
    //-----ページ切り替え周りの描画↓-----
    
    if(!button[i]){
      fill(224);
    }else{
      fill(192);
    }
    
    rect(-1, i*gui_size+gui_y, gui_x+1, i*gui_size+gui_y);
    
    fill(0);
    
    if(i == 0){  
      text("Master", (gui_x+1)/2,i*gui_size+gui_y+gui_size/2);
    }else{
      text(i, (gui_x+1)/2,i*gui_size+gui_y+gui_size/2);
    }
    
    fill(0);
    
    //-----ページ切り替え周りの描画↑-----
    
    int l = 7;
    
    for(int j=0;j<9;j++){
      
      ConverttoOut();
      
      fill(255);
      
      if(i<8 && j<8){
        
        //-----Deleteが押されたら入力用配列を全初期化-----
        if(Delete){
          Scr_1[Scene][i][j] = false;
        }
        
        //-----8*8スイッチ周りの描画↓-----
        
        //-----各々のページに対応する列以外の枠組みを暗くする-----
        if(!button[0] && !button[j+1]){
          fill(224);
        }
        
        //-----8*8スイッチ枠組み-----
        rect(l*gui_size+gui_x+gui_size, k*gui_size+gui_y, gui_size, gui_size); //8*8の枠組み
        
        //-----各々のページに対応する列以外の円をやや明るくする-----
        if(Scr_1[Scene][j][i]){
          if(button[0] || button[j+1]){
            fill(0);
          }else{
            stroke(128);
            fill(128);
          }
          
          ellipse(l*gui_size+gui_x+gui_size/2+gui_size, k*gui_size+gui_y+gui_size/2, gui_size-2, gui_size-2);
        }
        //-----8*8スイッチ周りの描画↑-----
        
        //-----アノード、カソード、出力用16進数 周りの描画↓-----
        fill(0);
        if(button[i+1]){
          
          //-----アノード、カソードの行列表示-----
          text(Out_C[Scene][i].charAt(j), l*gui_size+gui_x+gui_size/2+gui_size, gui_y+gui_size*8+gui_size/2);
          text(Out_A[Scene][i].charAt(j),gui_size+gui_x-gui_size*1/3,(l+1)*gui_size+gui_y-gui_size/2);
          
          //-----バイナリ表示-----
          text("(",11,gui_y-gui_size/2);
          text(")",144,gui_y-gui_size/2);
          text("2",150,gui_y-gui_size*2/5);
          text(Out_C[Scene][i].charAt(j), j*gui_size*2/5+gui_x*2/5-6, gui_y-gui_size/2);
          text(Out_A[Scene][i].charAt(j), j*gui_size*2/5+gui_x*7/5-2, gui_y-gui_size/2);
          
          //-----16進数表示-----
          if(j == 0){
            text("0x" + Out_H[Scene][i], gui_size*7+gui_x+1, gui_y-gui_size/2);  
          }
        }
        //-----アノード、カソード、出力用16進数 周りの描画↑-----
      }
      
      stroke(0);
      
      l--;
    }
    
    k--;
  }
  
  //-----Deleteを一回でストップさせる-----
  Delete = false;
  
  //-----強調枠線の描画-----
  strokeWeight(2);
  line(0, gui_y-gui_size, 240, gui_y-gui_size);
  line(0, gui_y, 240, gui_y);
  line(gui_x+gui_size*5, 0, gui_x+gui_size*5, gui_y);
  line(gui_x, 0, gui_x, gui_y-gui_size);
  line(gui_x, gui_y, gui_x, 240);
  
  //-----gainer未出力時のスタンダードな処理↑-----
  
  //-----gainer出力中の処理 出力と停止の処理のみ↓-----
  }else{
    for(int i=0;i<8;i++){
      for(int j=0;j<8;j++){
        //gainer.digitalOutput(Integer.parseInt(Out_H[j][i], 16));
        waiting(WaitTime);
      }
      waiting(AnimeTime);
    }
    
    println("test");
    
    fill(192);
    strokeWeight(1);
    rect(-1, -1, gui_x/2, gui_y-gui_size);
    
    fill(224);
    rect(gui_x/2-1, -1, gui_x/2+1, gui_y-gui_size);
    
    fill(0);
    
    pushMatrix();
    translate(gui_x/4-3, (gui_y-gui_size)/2);
    
    beginShape();
    for(int j=0;j<3;j++){
      vertex(10*cos(radians(360*j/3)), 10*sin(radians(360*j/3)));
    }
    endShape(CLOSE);
    popMatrix();
    
    rect(36, 12, 16, 16);
    
  }
  //-----gainer出力中の処理 出力と停止の処理のみ↑-----
  
}

//-----入力されているスイッチを、出力用に纏める関数-----
private void ConverttoOut(){
  
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
      if(Scr_1[Scene][i][j]){  //アノードは0と1を反転する
        if(j==0){
          Out_A[Scene][i] = "0";
        }else{
          Out_A[Scene][i] += "0";
        }
      }else{
        if(j==0){
          Out_A[Scene][i] = "1";
        }else{
          Out_A[Scene][i] += "1";
        }
      }
    }
    
    StringBuilder BuffSB = new StringBuilder(Out_C[Scene][i]);
    
    if(Integer.parseInt(Out_A[Scene][i], 2) < 255){
      BuffSB.setCharAt(i, '1');
      Out_C[Scene][i] = BuffSB.toString();
    }else{
      Out_C[Scene][i] = "00000000";
      Out_A[Scene][i] = "00000000";  //アノードが11111111の時は00000000へ
    }
    
    Out_H[Scene][i] = Integer.toHexString(Integer.parseInt(Out_C[Scene][i], 2)) + Integer.toHexString(Integer.parseInt(Out_A[Scene][i], 2));
    
    BuffSB = new StringBuilder(Out_H[Scene][i]);
    
    switch(BuffSB.length()){
      case 2:
        Out_H[Scene][i] = "0000";
        break;
      case 3:
        BuffSB.insert(0, "0");
        Out_H[Scene][i] = BuffSB.toString();
    }
  }
  
}
  
public static void waiting(long t){
  try{
    Thread.sleep(t);
  }
  catch(InterruptedException e){
  }
}

public void mousePressed(){
  
  for(int i=0;i<2;i++){
      if(i<2 && mouseX >= i*gui_x/2 && mouseX <= (i+1)*gui_x/2 && mouseY >= 0 && mouseY <= gui_y-gui_size){
        if(!Player[i]){
          Player[i] = true;
          if(i==0){
            println("Run.");
          }else{
//            gainer.turnOffLED();
//            gainer.digitalOutput(0xffff);
            println("Stopped.");
          }
        }
      }
    }
  
  if(!Player[0]){
    
    int k = 7;
    
    if(mouseX >= 0 && mouseX <= gui_x/2 && mouseY >= 0 && mouseY <= gui_y-gui_size){
      Player[0] = true;
      Player[1] = false;
      println("Run");
    }
    
    if(mouseX >= gui_x+gui_size*5 && mouseX <= gui_x+gui_size*6 && mouseY >= 0 && mouseY <= gui_size*2){
      if(Scene > 0){
        Scene--;
      }else{
        Scene = 7;
      }
    }
    
    if(mouseX >= gui_x+gui_size*7 && mouseX <= gui_x+gui_size*8 && mouseY >= 0 && mouseY <= gui_size*2){
      if(Scene < 7){
        Scene++;
      }else{
        Scene = 0;
      }
    }
    
      //waitingの判定
    if(mouseX >= gui_x && mouseX <= gui_x+gui_size && mouseY >= 0 && mouseY <= gui_size){
      if(Time[0]){
        if(WaitTime <= 990){
          WaitTime += 10;
        }else{
          WaitTime = 1000;
        }
      }else{
        if(AnimeTime <= 4990){
          AnimeTime += 10;
        }else{
          WaitTime = 5000;
        }
      }
    }else if(mouseX >= gui_x && mouseX <= gui_x+gui_size && mouseY >= gui_size && mouseY <= gui_size*2){
      if(Time[0]){
        if(WaitTime < 1000){
          WaitTime++;
        }
      }else{
        if(AnimeTime < 5000){
          AnimeTime++;
        }
      }
    }else if(mouseX >= gui_x+gui_size*4 && mouseX <= gui_x+gui_size*5 && mouseY >= 0 && mouseY <= gui_size){
      if(Time[0]){
        if(WaitTime >= 10){
          WaitTime -= 10;
        }else{
          WaitTime = 0;
        }
      }else{
        if(AnimeTime >= 10){
          AnimeTime -= 10;
        }else{
          AnimeTime = 0;
        }
      }
    }else if(mouseX >= gui_x+gui_size*4 && mouseX <= gui_x+gui_size*5 && mouseY >= gui_size && mouseY <= gui_size*2){
      if(Time[0]){
        if(WaitTime > 0){
          WaitTime--;
        }
      }else{
        if(AnimeTime > 0){
          AnimeTime--;
        }
      }
    }
  
    if(mouseX >= gui_x+gui_size*8 && mouseX <= gui_x+gui_size*9 && mouseY >= 0 && mouseY <= gui_size*2){
      Delete = true;
    }
    
    for(int i=0;i<9;i++){
      
      if(mouseX >= 0 && mouseX <= gui_x-1 && mouseY >= i*gui_size+gui_y && mouseY <= i*gui_size+gui_y+gui_size-1){
        if(!button[i]){
          button[i] = true;
        }
      }
      
      if(i<2 && mouseX >= gui_x+gui_size && mouseX <= gui_x+gui_size*4 && mouseY >= i*gui_size && mouseY <= (i+2)*gui_size){
        if(!Time[i]){
          Time[i] = true;
        }
      }
    
      int l = 7;
      
      for(int j=0;j<9;j++){
        if(button[i] && i != j){
          button[j] = false;
        }
        
        if(i<2 && j<2 && Time[i] && i != j){
          Time[j] = false;
        }
        
        if(i<8 && j<8 && button[0]){
          if(mouseX >= j*gui_size+gui_x+gui_size && mouseX <= j*gui_size+gui_x+(gui_size*2)-1 && mouseY >= i*gui_size+gui_y && mouseY <= i*gui_size+gui_y+gui_size-1){
            if(Scr_1[Scene][l][k]){
              Scr_1[Scene][l][k] = false;
            }else{
              Scr_1[Scene][l][k] = true;
            }
          }
        }
        l--;
      }
      k--;
    }
  }else{
    if(mouseX >= gui_x/2 && mouseX <= gui_x && mouseY >= 0 && mouseY <= gui_y-gui_size){
      Player[0] = false;
      Player[1] = true;
//      gainer.turnOffLED();
//      gainer.digitalOutput(0xffff);
      println("Stopped.");
    }
  }
  
}
