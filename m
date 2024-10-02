Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105FA1974F4;
	Wed,  2 Oct 2024 14:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879145; cv=none; b=WH5aCmwQkQPKT74TJFwBu5C7PZdCGv1sQAaguuUKHz2Rr+a7DEsH3iKkjHEXx3gOX2Z8nB2JBiUPrKckXTaR64IMhrFSnhpltwSUXC5RIbgln+II9elQp4ZciASZv6D5APdScIgOEY/icsNI3B09R+c3On+siaHA7r7CKsJfAjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879145; c=relaxed/simple;
	bh=DhKr/qX1I2AoGHY5/p+7tORx/+ygpDWBincZb00TJ2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsvXKkrm6NMGKM8k9rdRW3wcBV0jqj9yLLmcq350G5iaB+/4JXiL06aHaZLJjHJnyLk/Tm4ih9bXvn6SNAyrui1zN71K9LS4YBcfUr/PfSSREjXWmT05aiqqhgbM5RWzPL6dwe1xFsA87TDzWFBco+HRnKdexdITNN65N2VTmQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWJbfpRP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWJbfpRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE71C4CEC2;
	Wed,  2 Oct 2024 14:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879144;
	bh=DhKr/qX1I2AoGHY5/p+7tORx/+ygpDWBincZb00TJ2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWJbfpRPaRrcIe+lzoGqb50wFo7mQkZMQUBGFZmVyIjWcHMF2rUynndPKAOIE2TCZ
	 L2gY1DWmKRrrYRw+r6I7SjDxjOoRqK6RCNbrnqRgeYRK5qJofQCHAMQNtShcEY4A27
	 eE5aiGADUUAh8/KilEuopQY3cDFLa4I19ll8ZNes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Owens <calvin@wbinvd.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/538] ARM: 9410/1: vfp: Use asm volatile in fmrx/fmxr macros
Date: Wed,  2 Oct 2024 14:54:18 +0200
Message-ID: <20241002125752.767300687@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Calvin Owens <calvin@wbinvd.org>

[ Upstream commit 89a906dfa8c3b21b3e5360f73c49234ac1eb885b ]

Floating point instructions in userspace can crash some arm kernels
built with clang/LLD 17.0.6:

    BUG: unsupported FP instruction in kernel mode
    FPEXC == 0xc0000780
    Internal error: Oops - undefined instruction: 0 [#1] ARM
    CPU: 0 PID: 196 Comm: vfp-reproducer Not tainted 6.10.0 #1
    Hardware name: BCM2835
    PC is at vfp_support_entry+0xc8/0x2cc
    LR is at do_undefinstr+0xa8/0x250
    pc : [<c0101d50>]    lr : [<c010a80c>]    psr: a0000013
    sp : dc8d1f68  ip : 60000013  fp : bedea19c
    r10: ec532b17  r9 : 00000010  r8 : 0044766c
    r7 : c0000780  r6 : ec532b17  r5 : c1c13800  r4 : dc8d1fb0
    r3 : c10072c4  r2 : c0101c88  r1 : ec532b17  r0 : 0044766c
    Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
    Control: 00c5387d  Table: 0251c008  DAC: 00000051
    Register r0 information: non-paged memory
    Register r1 information: vmalloc memory
    Register r2 information: non-slab/vmalloc memory
    Register r3 information: non-slab/vmalloc memory
    Register r4 information: 2-page vmalloc region
    Register r5 information: slab kmalloc-cg-2k
    Register r6 information: vmalloc memory
    Register r7 information: non-slab/vmalloc memory
    Register r8 information: non-paged memory
    Register r9 information: zero-size pointer
    Register r10 information: vmalloc memory
    Register r11 information: non-paged memory
    Register r12 information: non-paged memory
    Process vfp-reproducer (pid: 196, stack limit = 0x61aaaf8b)
    Stack: (0xdc8d1f68 to 0xdc8d2000)
    1f60:                   0000081f b6f69300 0000000f c10073f4 c10072c4 dc8d1fb0
    1f80: ec532b17 0c532b17 0044766c b6f9ccd8 00000000 c010a80c 00447670 60000010
    1fa0: ffffffff c1c13800 00c5387d c0100f10 b6f68af8 00448fc0 00000000 bedea188
    1fc0: bedea314 00000001 00448ebc b6f9d000 00447608 b6f9ccd8 00000000 bedea19c
    1fe0: bede9198 bedea188 b6e1061c 0044766c 60000010 ffffffff 00000000 00000000
    Call trace:
    [<c0101d50>] (vfp_support_entry) from [<c010a80c>] (do_undefinstr+0xa8/0x250)
    [<c010a80c>] (do_undefinstr) from [<c0100f10>] (__und_usr+0x70/0x80)
    Exception stack(0xdc8d1fb0 to 0xdc8d1ff8)
    1fa0:                                     b6f68af8 00448fc0 00000000 bedea188
    1fc0: bedea314 00000001 00448ebc b6f9d000 00447608 b6f9ccd8 00000000 bedea19c
    1fe0: bede9198 bedea188 b6e1061c 0044766c 60000010 ffffffff
    Code: 0a000061 e3877202 e594003c e3a09010 (eef16a10)
    ---[ end trace 0000000000000000 ]---
    Kernel panic - not syncing: Fatal exception in interrupt
    ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

This is a minimal userspace reproducer on a Raspberry Pi Zero W:

    #include <stdio.h>
    #include <math.h>

    int main(void)
    {
            double v = 1.0;
            printf("%fn", NAN + *(volatile double *)&v);
            return 0;
    }

Another way to consistently trigger the oops is:

    calvin@raspberry-pi-zero-w ~$ python -c "import json"

The bug reproduces only when the kernel is built with DYNAMIC_DEBUG=n,
because the pr_debug() calls act as barriers even when not activated.

This is the output from the same kernel source built with the same
compiler and DYNAMIC_DEBUG=y, where the userspace reproducer works as
expected:

    VFP: bounce: trigger ec532b17 fpexc c0000780
    VFP: emulate: INST=0xee377b06 SCR=0x00000000
    VFP: bounce: trigger eef1fa10 fpexc c0000780
    VFP: emulate: INST=0xeeb40b40 SCR=0x00000000
    VFP: raising exceptions 30000000

    calvin@raspberry-pi-zero-w ~$ ./vfp-reproducer
    nan

Crudely grepping for vmsr/vmrs instructions in the otherwise nearly
idential text for vfp_support_entry() makes the problem obvious:

    vmlinux.llvm.good [0xc0101cb8] <+48>:  vmrs   r7, fpexc
    vmlinux.llvm.good [0xc0101cd8] <+80>:  vmsr   fpexc, r0
    vmlinux.llvm.good [0xc0101d20] <+152>: vmsr   fpexc, r7
    vmlinux.llvm.good [0xc0101d38] <+176>: vmrs   r4, fpexc
    vmlinux.llvm.good [0xc0101d6c] <+228>: vmrs   r0, fpscr
    vmlinux.llvm.good [0xc0101dc4] <+316>: vmsr   fpexc, r0
    vmlinux.llvm.good [0xc0101dc8] <+320>: vmrs   r0, fpsid
    vmlinux.llvm.good [0xc0101dcc] <+324>: vmrs   r6, fpscr
    vmlinux.llvm.good [0xc0101e10] <+392>: vmrs   r10, fpinst
    vmlinux.llvm.good [0xc0101eb8] <+560>: vmrs   r10, fpinst2

    vmlinux.llvm.bad  [0xc0101cb8] <+48>:  vmrs   r7, fpexc
    vmlinux.llvm.bad  [0xc0101cd8] <+80>:  vmsr   fpexc, r0
    vmlinux.llvm.bad  [0xc0101d20] <+152>: vmsr   fpexc, r7
    vmlinux.llvm.bad  [0xc0101d30] <+168>: vmrs   r0, fpscr
    vmlinux.llvm.bad  [0xc0101d50] <+200>: vmrs   r6, fpscr  <== BOOM!
    vmlinux.llvm.bad  [0xc0101d6c] <+228>: vmsr   fpexc, r0
    vmlinux.llvm.bad  [0xc0101d70] <+232>: vmrs   r0, fpsid
    vmlinux.llvm.bad  [0xc0101da4] <+284>: vmrs   r10, fpinst
    vmlinux.llvm.bad  [0xc0101df8] <+368>: vmrs   r4, fpexc
    vmlinux.llvm.bad  [0xc0101e5c] <+468>: vmrs   r10, fpinst2

I think LLVM's reordering is valid as the code is currently written: the
compiler doesn't know the instructions have side effects in hardware.

Fix by using "asm volatile" in fmxr() and fmrx(), so they cannot be
reordered with respect to each other. The original compiler now produces
working kernels on my hardware with DYNAMIC_DEBUG=n.

This is the relevant piece of the diff of the vfp_support_entry() text,
from the original oopsing kernel to a working kernel with this patch:

         vmrs r0, fpscr
         tst r0, #4096
         bne 0xc0101d48
         tst r0, #458752
         beq 0xc0101ecc
         orr r7, r7, #536870912
         ldr r0, [r4, #0x3c]
         mov r9, #16
        -vmrs r6, fpscr
         orr r9, r9, #251658240
         add r0, r0, #4
         str r0, [r4, #0x3c]
         mvn r0, #159
         sub r0, r0, #-1207959552
         and r0, r7, r0
         vmsr fpexc, r0
         vmrs r0, fpsid
        +vmrs r6, fpscr
         and r0, r0, #983040
         cmp r0, #65536
         bne 0xc0101d88

Fixes: 4708fb041346 ("ARM: vfp: Reimplement VFP exception entry in C code")
Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/vfp/vfpinstr.h | 48 ++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/arch/arm/vfp/vfpinstr.h b/arch/arm/vfp/vfpinstr.h
index 3c7938fd40aad..32090b0fb250b 100644
--- a/arch/arm/vfp/vfpinstr.h
+++ b/arch/arm/vfp/vfpinstr.h
@@ -64,33 +64,37 @@
 
 #ifdef CONFIG_AS_VFP_VMRS_FPINST
 
-#define fmrx(_vfp_) ({			\
-	u32 __v;			\
-	asm(".fpu	vfpv2\n"	\
-	    "vmrs	%0, " #_vfp_	\
-	    : "=r" (__v) : : "cc");	\
-	__v;				\
- })
-
-#define fmxr(_vfp_,_var_)		\
-	asm(".fpu	vfpv2\n"	\
-	    "vmsr	" #_vfp_ ", %0"	\
-	   : : "r" (_var_) : "cc")
+#define fmrx(_vfp_) ({				\
+	u32 __v;				\
+	asm volatile (".fpu	vfpv2\n"	\
+		      "vmrs	%0, " #_vfp_	\
+		     : "=r" (__v) : : "cc");	\
+	__v;					\
+})
+
+#define fmxr(_vfp_, _var_) ({			\
+	asm volatile (".fpu	vfpv2\n"	\
+		      "vmsr	" #_vfp_ ", %0"	\
+		     : : "r" (_var_) : "cc");	\
+})
 
 #else
 
 #define vfpreg(_vfp_) #_vfp_
 
-#define fmrx(_vfp_) ({			\
-	u32 __v;			\
-	asm("mrc p10, 7, %0, " vfpreg(_vfp_) ", cr0, 0 @ fmrx	%0, " #_vfp_	\
-	    : "=r" (__v) : : "cc");	\
-	__v;				\
- })
-
-#define fmxr(_vfp_,_var_)		\
-	asm("mcr p10, 7, %0, " vfpreg(_vfp_) ", cr0, 0 @ fmxr	" #_vfp_ ", %0"	\
-	   : : "r" (_var_) : "cc")
+#define fmrx(_vfp_) ({						\
+	u32 __v;						\
+	asm volatile ("mrc p10, 7, %0, " vfpreg(_vfp_) ","	\
+		      "cr0, 0 @ fmrx	%0, " #_vfp_		\
+		     : "=r" (__v) : : "cc");			\
+	__v;							\
+})
+
+#define fmxr(_vfp_, _var_) ({					\
+	asm volatile ("mcr p10, 7, %0, " vfpreg(_vfp_) ","	\
+		      "cr0, 0 @ fmxr	" #_vfp_ ", %0"		\
+		     : : "r" (_var_) : "cc");			\
+})
 
 #endif
 
-- 
2.43.0



