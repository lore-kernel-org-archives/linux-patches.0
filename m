Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7087913AE0
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBEFC433D2;
	Mon,  8 May 2023 10:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543585;
	bh=UZHM4zO+EmMlB23qbAgl/0B8m1ovcquyrbgpi/aU0kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UW3heutlc9KhajNv2djiscpIFklxYgsOVzWTadVhLvXHINcGqJpDJOuimQlPZIZyB
	 TXwA5LiqQqSdq9NyG69bRQpLejAQ6qaSG+iqzey5bpiPHF14NcbRWRGVebGjWZAZB9
	 GFI8tWDGCSSSRIkuJOlcOBUMzA+QNRKWx+aJ9WJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Guenter Roeck <linux@roeck-us.net>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 137/694] ARM: 9293/1: vfp: Pass successful return address via register R3
Date: Mon,  8 May 2023 11:39:32 +0200
Message-Id: <20230508094436.904567494@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

[ Upstream commit 3a2bdad0b46649cc73fb3b3f9e2b91ef97a7fa63 ]

In preparation for reimplementing the do_vfp()->vfp_support_entry()
handover in C code, switch to using R3 to pass the 'success' return
address, rather than R9, as it cannot be used for parameter passing.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Stable-dep-of: c76c6c4ecbec ("ARM: 9294/2: vfp: Fix broken softirq handling with instrumentation enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/vfp/entry.S |  1 +
 arch/arm/vfp/vfphw.S | 14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm/vfp/entry.S b/arch/arm/vfp/entry.S
index cfedc2a3dbd68..6dabb47617781 100644
--- a/arch/arm/vfp/entry.S
+++ b/arch/arm/vfp/entry.S
@@ -23,6 +23,7 @@
 @
 ENTRY(do_vfp)
 	mov	r1, r10
+	mov	r3, r9
  	ldr	r4, .LCvfp
 	ldr	pc, [r4]		@ call VFP entry point
 ENDPROC(do_vfp)
diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
index 6d056d810e486..60acd42e05786 100644
--- a/arch/arm/vfp/vfphw.S
+++ b/arch/arm/vfp/vfphw.S
@@ -7,7 +7,7 @@
  *
  * This code is called from the kernel's undefined instruction trap.
  * r1 holds the thread_info pointer
- * r9 holds the return address for successful handling.
+ * r3 holds the return address for successful handling.
  * lr holds the return address for unrecognised instructions.
  * sp points to a struct pt_regs (as defined in include/asm/proc/ptrace.h)
  */
@@ -71,7 +71,7 @@
 @  r0  = instruction opcode (32-bit ARM or two 16-bit Thumb)
 @  r1  = thread_info pointer
 @  r2  = PC value to resume execution after successful emulation
-@  r9  = normal "successful" return address
+@  r3  = normal "successful" return address
 @  lr  = unrecognised instruction return address
 @  IRQs enabled.
 ENTRY(vfp_support_entry)
@@ -89,9 +89,9 @@ ENTRY(vfp_support_entry)
 	bne	look_for_VFP_exceptions	@ VFP is already enabled
 
 	DBGSTR1 "enable %x", r10
-	ldr	r3, vfp_current_hw_state_address
+	ldr	r9, vfp_current_hw_state_address
 	orr	r1, r1, #FPEXC_EN	@ user FPEXC has the enable bit set
-	ldr	r4, [r3, r11, lsl #2]	@ vfp_current_hw_state pointer
+	ldr	r4, [r9, r11, lsl #2]	@ vfp_current_hw_state pointer
 	bic	r5, r1, #FPEXC_EX	@ make sure exceptions are disabled
 	cmp	r4, r10			@ this thread owns the hw context?
 #ifndef CONFIG_SMP
@@ -150,7 +150,7 @@ vfp_reload_hw:
 #endif
 
 	DBGSTR1	"load state %p", r10
-	str	r10, [r3, r11, lsl #2]	@ update the vfp_current_hw_state pointer
+	str	r10, [r9, r11, lsl #2]	@ update the vfp_current_hw_state pointer
 					@ Load the saved state back into the VFP
 	VFPFLDMIA r10, r5		@ reload the working registers while
 					@ FPEXC is in a safe state
@@ -180,7 +180,7 @@ vfp_hw_state_valid:
 					@ always subtract 4 from the following
 					@ instruction address.
 	local_bh_enable_ti r10, r4
-	ret	r9			@ we think we have handled things
+	ret	r3			@ we think we have handled things
 
 
 look_for_VFP_exceptions:
@@ -210,7 +210,7 @@ skip:
 process_exception:
 	DBGSTR	"bounce"
 	mov	r2, sp			@ nothing stacked - regdump is at TOS
-	mov	lr, r9			@ setup for a return to the user code.
+	mov	lr, r3			@ setup for a return to the user code.
 
 	@ Now call the C code to package up the bounce to the support code
 	@   r0 holds the trigger instruction
-- 
2.39.2



