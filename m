Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31C6171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F945C433EF;
	Mon, 22 May 2023 19:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785248;
	bh=Eh9nn0WxpZKXFoOhSr7aVm4c3aVIPlw1gAmlZ9z53tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0EPZEpzWP/ANSTW4blxovsAojn7qh+S1N8XSGfOWxNPAhO1rnNBIRq6zZMqUxRz7
	 u5/YCPYRM9kTTVHoVDfQNd/Qsb8jQUbpHKCY87xkvprDO6P4ZZWhTmyKbo6c08knPi
	 xKdKIrYMbA+NmAJ5c3d1G4XxFy5oMmDIetkana3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Guenter Roeck <linux@roeck-us.net>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 360/364] ARM: 9294/2: vfp: Fix broken softirq handling with instrumentation enabled
Date: Mon, 22 May 2023 20:11:05 +0100
Message-Id: <20230522190421.775506436@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit c76c6c4ecbec0deb56a4f9e932b26866024a508f ]

Commit 62b95a7b44d1 ("ARM: 9282/1: vfp: Manipulate task VFP state with
softirqs disabled") replaced the en/disable preemption calls inside the
VFP state handling code with en/disabling of soft IRQs, which is
necessary to allow kernel use of the VFP/SIMD unit when handling a soft
IRQ.

Unfortunately, when lockdep is enabled (or other instrumentation that
enables TRACE_IRQFLAGS), the disable path implemented in asm fails to
perform the lockdep and RCU related bookkeeping, resulting in spurious
warnings and other badness.

Set let's rework the VFP entry code a little bit so we can make the
local_bh_disable() call from C, with all the instrumentations that
happen to have been configured. Calling local_bh_enable() can be done
from asm, as it is a simple wrapper around __local_bh_enable_ip(), which
is always a callable function.

Link: https://lore.kernel.org/all/ZBBYCSZUJOWBg1s8@localhost.localdomain/

Fixes: 62b95a7b44d1 ("ARM: 9282/1: vfp: Manipulate task VFP state with softirqs disabled")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/assembler.h | 13 -------------
 arch/arm/vfp/entry.S             | 11 +----------
 arch/arm/vfp/vfphw.S             | 12 ++++++------
 arch/arm/vfp/vfpmodule.c         | 27 ++++++++++++++++++++++-----
 4 files changed, 29 insertions(+), 34 deletions(-)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 06b48ce23e1ca..505a306e0271a 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -244,19 +244,6 @@ THUMB(	fpreg	.req	r7	)
 	.endm
 #endif
 
-	.macro	local_bh_disable, ti, tmp
-	ldr	\tmp, [\ti, #TI_PREEMPT]
-	add	\tmp, \tmp, #SOFTIRQ_DISABLE_OFFSET
-	str	\tmp, [\ti, #TI_PREEMPT]
-	.endm
-
-	.macro	local_bh_enable_ti, ti, tmp
-	get_thread_info \ti
-	ldr	\tmp, [\ti, #TI_PREEMPT]
-	sub	\tmp, \tmp, #SOFTIRQ_DISABLE_OFFSET
-	str	\tmp, [\ti, #TI_PREEMPT]
-	.endm
-
 #define USERL(l, x...)				\
 9999:	x;					\
 	.pushsection __ex_table,"a";		\
diff --git a/arch/arm/vfp/entry.S b/arch/arm/vfp/entry.S
index 6dabb47617781..7483ef8bccda3 100644
--- a/arch/arm/vfp/entry.S
+++ b/arch/arm/vfp/entry.S
@@ -24,14 +24,5 @@
 ENTRY(do_vfp)
 	mov	r1, r10
 	mov	r3, r9
- 	ldr	r4, .LCvfp
-	ldr	pc, [r4]		@ call VFP entry point
+	b	vfp_entry
 ENDPROC(do_vfp)
-
-ENTRY(vfp_null_entry)
-	ret	lr
-ENDPROC(vfp_null_entry)
-
-	.align	2
-.LCvfp:
-	.word	vfp_vector
diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
index 60acd42e05786..4d8478264d82b 100644
--- a/arch/arm/vfp/vfphw.S
+++ b/arch/arm/vfp/vfphw.S
@@ -75,8 +75,6 @@
 @  lr  = unrecognised instruction return address
 @  IRQs enabled.
 ENTRY(vfp_support_entry)
-	local_bh_disable r1, r4
-
 	ldr	r11, [r1, #TI_CPU]	@ CPU number
 	add	r10, r1, #TI_VFPSTATE	@ r10 = workspace
 
@@ -179,9 +177,12 @@ vfp_hw_state_valid:
 					@ else it's one 32-bit instruction, so
 					@ always subtract 4 from the following
 					@ instruction address.
-	local_bh_enable_ti r10, r4
-	ret	r3			@ we think we have handled things
 
+	mov	lr, r3			@ we think we have handled things
+local_bh_enable_and_ret:
+	adr	r0, .
+	mov	r1, #SOFTIRQ_DISABLE_OFFSET
+	b	__local_bh_enable_ip	@ tail call
 
 look_for_VFP_exceptions:
 	@ Check for synchronous or asynchronous exception
@@ -204,8 +205,7 @@ skip:
 	@ not recognised by VFP
 
 	DBGSTR	"not VFP"
-	local_bh_enable_ti r10, r4
-	ret	lr
+	b	local_bh_enable_and_ret
 
 process_exception:
 	DBGSTR	"bounce"
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 01bc48d738478..349dcb944a937 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -32,10 +32,9 @@
 /*
  * Our undef handlers (in entry.S)
  */
-asmlinkage void vfp_support_entry(void);
-asmlinkage void vfp_null_entry(void);
+asmlinkage void vfp_support_entry(u32, void *, u32, u32);
 
-asmlinkage void (*vfp_vector)(void) = vfp_null_entry;
+static bool have_vfp __ro_after_init;
 
 /*
  * Dual-use variable.
@@ -645,6 +644,25 @@ static int vfp_starting_cpu(unsigned int unused)
 	return 0;
 }
 
+/*
+ * Entered with:
+ *
+ *  r0  = instruction opcode (32-bit ARM or two 16-bit Thumb)
+ *  r1  = thread_info pointer
+ *  r2  = PC value to resume execution after successful emulation
+ *  r3  = normal "successful" return address
+ *  lr  = unrecognised instruction return address
+ */
+asmlinkage void vfp_entry(u32 trigger, struct thread_info *ti, u32 resume_pc,
+			  u32 resume_return_address)
+{
+	if (unlikely(!have_vfp))
+		return;
+
+	local_bh_disable();
+	vfp_support_entry(trigger, ti, resume_pc, resume_return_address);
+}
+
 #ifdef CONFIG_KERNEL_MODE_NEON
 
 static int vfp_kmode_exception(struct pt_regs *regs, unsigned int instr)
@@ -798,7 +816,6 @@ static int __init vfp_init(void)
 	vfpsid = fmrx(FPSID);
 	barrier();
 	unregister_undef_hook(&vfp_detect_hook);
-	vfp_vector = vfp_null_entry;
 
 	pr_info("VFP support v0.3: ");
 	if (VFP_arch) {
@@ -883,7 +900,7 @@ static int __init vfp_init(void)
 				  "arm/vfp:starting", vfp_starting_cpu,
 				  vfp_dying_cpu);
 
-	vfp_vector = vfp_support_entry;
+	have_vfp = true;
 
 	thread_register_notifier(&vfp_notifier_block);
 	vfp_pm_init();
-- 
2.39.2



