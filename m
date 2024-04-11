Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE60D142624;
	Thu, 11 Apr 2024 10:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832292; cv=none; b=bkAfXvOrbdsksYldeGCkCvUZJSJr30vFb79sxuU8kx+Dm1a59avQPnp56i8oLBe7+P4LggFQL/wS19fUrqOLuJc6Yn9gEgl2SJGCgB3i8LEnn7HatYc7e+Td8Tmr5NpUDiIEX3VTEMb15U5/OdffOWfxfgjqUXhklvQYCXlUItc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832292; c=relaxed/simple;
	bh=lszPvIyZwAIQjhjBa9bVVYcTRWnN9LO+NOeBA3CnhTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6dAfojQ19DVy5eDRqcflwGVJ3X1hwAlBXnRZLcBPjaLZtWbXtPIzEh/WvGSAL5pqyeNYd0pZ03rcy4U7EyIC7YoCuc7v3IfrjagbTBJFpFcDpNJhEFcUnGPgKcqgSQi1dwTAh6dSSUT+7fTFENUfAG0z1cqyxPmmM0KCE8/zD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfLARry6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfLARry6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05232C433F1;
	Thu, 11 Apr 2024 10:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832292;
	bh=lszPvIyZwAIQjhjBa9bVVYcTRWnN9LO+NOeBA3CnhTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfLARry634X2fhzsZj1kt/kxLhZujoJ/LWIqy8rTa8WS71g+RB6Dy24Dl/LufjZYu
	 soNM/HGZ6rZ9AgR3G1i53YJdI7EbqOSKt5TFerscCtq5GDHy1DDhJULLcu/3NyiNAD
	 2vfcgiR9PBWtZl4M2kbjPxxfRP2fIKcmv35Ssm08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Brijesh Singh <brijesh.singh@amd.com>,
	Borislav Petkov <bp@suse.de>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.10 294/294] x86/head/64: Re-enable stack protection
Date: Thu, 11 Apr 2024 11:57:37 +0200
Message-ID: <20240411095444.384835955@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Roth <michael.roth@amd.com>

commit 469693d8f62299709e8ba56d8fb3da9ea990213c upstream.

Due to

  103a4908ad4d ("x86/head/64: Disable stack protection for head$(BITS).o")

kernel/head{32,64}.c are compiled with -fno-stack-protector to allow
a call to set_bringup_idt_handler(), which would otherwise have stack
protection enabled with CONFIG_STACKPROTECTOR_STRONG.

While sufficient for that case, there may still be issues with calls to
any external functions that were compiled with stack protection enabled
that in-turn make stack-protected calls, or if the exception handlers
set up by set_bringup_idt_handler() make calls to stack-protected
functions.

Subsequent patches for SEV-SNP CPUID validation support will introduce
both such cases. Attempting to disable stack protection for everything
in scope to address that is prohibitive since much of the code, like the
SEV-ES #VC handler, is shared code that remains in use after boot and
could benefit from having stack protection enabled. Attempting to inline
calls is brittle and can quickly balloon out to library/helper code
where that's not really an option.

Instead, re-enable stack protection for head32.c/head64.c, and make the
appropriate changes to ensure the segment used for the stack canary is
initialized in advance of any stack-protected C calls.

For head64.c:

- The BSP will enter from startup_64() and call into C code
  (startup_64_setup_env()) shortly after setting up the stack, which
  may result in calls to stack-protected code. Set up %gs early to allow
  for this safely.
- APs will enter from secondary_startup_64*(), and %gs will be set up
  soon after. There is one call to C code prior to %gs being setup
  (__startup_secondary_64()), but it is only to fetch 'sme_me_mask'
  global, so just load 'sme_me_mask' directly instead, and remove the
  now-unused __startup_secondary_64() function.

For head32.c:

- BSPs/APs will set %fs to __BOOT_DS prior to any C calls. In recent
  kernels, the compiler is configured to access the stack canary at
  %fs:__stack_chk_guard [1], which overlaps with the initial per-cpu
  '__stack_chk_guard' variable in the initial/"master" .data..percpu
  area. This is sufficient to allow access to the canary for use
  during initial startup, so no changes are needed there.

[1] 3fb0fdb3bbe7 ("x86/stackprotector/32: Make the canary into a regular percpu variable")

  [ bp: Massage commit message. ]

Suggested-by: Joerg Roedel <jroedel@suse.de> #for 64-bit %gs set up
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20220307213356.2797205-24-brijesh.singh@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/setup.h |    1 -
 arch/x86/kernel/Makefile     |    1 -
 arch/x86/kernel/head64.c     |    9 ---------
 arch/x86/kernel/head_64.S    |   24 +++++++++++++++++++++---
 4 files changed, 21 insertions(+), 14 deletions(-)

--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -49,7 +49,6 @@ extern unsigned long saved_video_mode;
 extern void reserve_standard_io_resources(void);
 extern void i386_reserve_resources(void);
 extern unsigned long __startup_64(unsigned long physaddr, struct boot_params *bp);
-extern unsigned long __startup_secondary_64(void);
 extern void startup_64_setup_env(unsigned long physbase);
 extern void early_setup_idt(void);
 extern void __init do_early_exception(struct pt_regs *regs, int trapnr);
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -49,7 +49,6 @@ endif
 # non-deterministic coverage.
 KCOV_INSTRUMENT		:= n
 
-CFLAGS_head$(BITS).o	+= -fno-stack-protector
 CFLAGS_cc_platform.o	+= -fno-stack-protector
 
 CFLAGS_irq.o := -I $(srctree)/$(src)/../include/asm/trace
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -302,15 +302,6 @@ unsigned long __head __startup_64(unsign
 	return sme_get_me_mask();
 }
 
-unsigned long __startup_secondary_64(void)
-{
-	/*
-	 * Return the SME encryption mask (if SME is active) to be used as a
-	 * modifier for the initial pgdir entry programmed into CR3.
-	 */
-	return sme_get_me_mask();
-}
-
 /* Wipe all early page tables except for the kernel symbol map */
 static void __init reset_early_page_tables(void)
 {
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -74,6 +74,22 @@ SYM_CODE_START_NOALIGN(startup_64)
 	leaq	(__end_init_task - SIZEOF_PTREGS)(%rip), %rsp
 
 	leaq	_text(%rip), %rdi
+
+	/*
+	 * initial_gs points to initial fixed_percpu_data struct with storage for
+	 * the stack protector canary. Global pointer fixups are needed at this
+	 * stage, so apply them as is done in fixup_pointer(), and initialize %gs
+	 * such that the canary can be accessed at %gs:40 for subsequent C calls.
+	 */
+	movl	$MSR_GS_BASE, %ecx
+	movq	initial_gs(%rip), %rax
+	movq	$_text, %rdx
+	subq	%rdx, %rax
+	addq	%rdi, %rax
+	movq	%rax, %rdx
+	shrq	$32,  %rdx
+	wrmsr
+
 	pushq	%rsi
 	call	startup_64_setup_env
 	popq	%rsi
@@ -141,9 +157,11 @@ SYM_INNER_LABEL(secondary_startup_64_no_
 	 * Retrieve the modifier (SME encryption mask if SME is active) to be
 	 * added to the initial pgdir entry that will be programmed into CR3.
 	 */
-	pushq	%rsi
-	call	__startup_secondary_64
-	popq	%rsi
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	movq	sme_me_mask, %rax
+#else
+	xorq	%rax, %rax
+#endif
 
 	/* Form the CR3 value being sure to include the CR3 modifier */
 	addq	$(init_top_pgt - __START_KERNEL_map), %rax


