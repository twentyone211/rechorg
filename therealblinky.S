    .global _start
    
    .syntax unified
    .equ GPIOB_BASE,            0x48000400
    .equ RCC,                   0X40021000 
    .equ RCC_AHBENR,            RCC + 0x14
    .equ GPIOB_MODER,           GPIOB_BASE + 0X00
    .equ GPIOB_BIT,             0x40000 
    .equ GPIO_MODER_PIN3O,      0x40
    .equ GPIOB_ODR,             GPIOB_BASE + 0x14
    .equ PIN3_SWITCH,             0x8 
    .equ DELAYLENGTH,           0x40000

Vectors:
    .word 0x20001800
    .word _start + 1



_start:
    ldr     r1, = RCC_AHBENR  // Reset & Clock controller register laden
    ldr     r2, = GPIOB_BIT // GPIOS aktivieren 
    bl      set_bits
    
    ldr     r1, = GPIOB_MODER         
    ldr     r2, = GPIO_MODER_PIN3O //Pin3 auf output modus
    bl      set_bits

.loop:
    ldr     r1, = GPIOB_ODR     
    ldr     r2, = PIN3_SWITCH
    bl      set_bits //Pin 3 auf "High"

    bl      delay
  
    ldr     r1, = GPIOB_ODR    
    ldr     r2, = PIN3_SWITCH
    bl      clear_bits  //Pin 3 auf "LOW"
  
    
    bl      delay
    b       .loop


  
   







    set_bits: 
        ldr R0,[R1]          
        orrs R0,R0,R2       
        str R0,[R1]         
        bx lr  
    
    clear_bits:
        ldr R0,[R1]
        bics R0,R0,R2
        str R0,[R1]
        bx lr
        

    
    delay:
    ldr     r2, = DELAYLENGTH          
1:  subs    r2, r2, #1          // Zaehle bis auf 0
    bne     1b
    bx      lr  

   
