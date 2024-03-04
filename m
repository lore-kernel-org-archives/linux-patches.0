Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20DD1F92C;
	Mon,  4 Mar 2024 21:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588909; cv=none; b=SJAnmWURVDVUSW2WjLd8JaKJ7bTARpyiXkcllqKIyj/A1MNHhL1PIZZyRDWwLSJ04zMAcffp6B1bwynj1vZaAMG8yMCWxifKj8gphQFcVHJSbHSMUBRioi+uCTE1M2la+Qff7ElJEgYL+X9+6isOVqSEqcsK5dYHc2KghqXhoYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588909; c=relaxed/simple;
	bh=V5X4X/M6MjY62hoBRjzJufBSKvjc/Vrj4KkfLwT1lNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGClIPMlSlF6Juw88ye+Ye5TTAH9q/6YU0UnGROHJFR+bAUL3y/435Qx4x6wzFs+ksHAaArPqHi41tKJiF8Fa7C1QqNZB71DvE3SgLzUgwboRG5YVMnT7/kdP9m4I6poaU3DGFlnecffiUJQP3THZZ6+5nX46KN8zGsyLXnLqQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxJORduy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxJORduy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D25C433C7;
	Mon,  4 Mar 2024 21:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588908;
	bh=V5X4X/M6MjY62hoBRjzJufBSKvjc/Vrj4KkfLwT1lNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxJORduyMpGX6CO3NHQmb6VmJJLWCtVK4j09wFEtkuB+TLpJgqBoGuchCOhYn5g4G
	 fI+OmD5GQ6yNiJIPQJhe91QDv3IQpOs+WFSTL3MH7D2pDiPFcxBNT7uIMAjcfPMSQF
	 nsvKmRbQmjFzaBMtEd6cZv8IruRwZB02IQnwjVm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 6.1 132/215] x86/decompressor: Call trampoline as a normal function
Date: Mon,  4 Mar 2024 21:23:15 +0000
Message-ID: <20240304211601.265958810@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit e8972a76aa90c05a0078043413f806c02fcb3487 upstream.

Move the long return to switch to 32-bit mode into the trampoline code
so it can be called as an ordinary function. This will allow it to be
called directly from C code in a subsequent patch.

While at it, reorganize the code somewhat to keep the prologue and
epilogue of the function together, making the code a bit easier to
follow. Also, given that the trampoline is now entered in 64-bit mode, a
simple RIP-relative reference can be used to take the address of the
exit point.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: https://lore.kernel.org/r/20230807162720.545787-10-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_64.S |   79 ++++++++++++++++---------------------
 arch/x86/boot/compressed/pgtable.h |    2 
 2 files changed, 36 insertions(+), 45 deletions(-)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -450,39 +450,8 @@ SYM_CODE_START(startup_64)
 	/* Save the trampoline address in RCX */
 	movq	%rax, %rcx
 
-	/* Set up 32-bit addressable stack */
-	leaq	TRAMPOLINE_32BIT_STACK_END(%rcx), %rsp
-
-	/*
-	 * Preserve live 64-bit registers on the stack: this is necessary
-	 * because the architecture does not guarantee that GPRs will retain
-	 * their full 64-bit values across a 32-bit mode switch.
-	 */
-	pushq	%r15
-	pushq	%rbp
-	pushq	%rbx
-
-	/*
-	 * Push the 64-bit address of trampoline_return() onto the new stack.
-	 * It will be used by the trampoline to return to the main code. Due to
-	 * the 32-bit mode switch, it cannot be kept it in a register either.
-	 */
-	leaq	trampoline_return(%rip), %rdi
-	pushq	%rdi
-
-	/* Switch to compatibility mode (CS.L = 0 CS.D = 1) via far return */
-	pushq	$__KERNEL32_CS
 	leaq	TRAMPOLINE_32BIT_CODE_OFFSET(%rax), %rax
-	pushq	%rax
-	lretq
-trampoline_return:
-	/* Restore live 64-bit registers */
-	popq	%rbx
-	popq	%rbp
-	popq	%r15
-
-	/* Restore the stack, the 32-bit trampoline uses its own stack */
-	leaq	rva(boot_stack_end)(%rbx), %rsp
+	call	*%rax
 
 	/*
 	 * cleanup_trampoline() would restore trampoline memory.
@@ -579,7 +548,6 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated
 	jmp	*%rax
 SYM_FUNC_END(.Lrelocated)
 
-	.code32
 /*
  * This is the 32-bit trampoline that will be copied over to low memory.
  *
@@ -588,6 +556,39 @@ SYM_FUNC_END(.Lrelocated)
  * Non zero RDX means trampoline needs to enable 5-level paging.
  */
 SYM_CODE_START(trampoline_32bit_src)
+	/*
+	 * Preserve live 64-bit registers on the stack: this is necessary
+	 * because the architecture does not guarantee that GPRs will retain
+	 * their full 64-bit values across a 32-bit mode switch.
+	 */
+	pushq	%r15
+	pushq	%rbp
+	pushq	%rbx
+
+	/* Set up 32-bit addressable stack and push the old RSP value */
+	leaq	(TRAMPOLINE_32BIT_STACK_END - 8)(%rcx), %rbx
+	movq	%rsp, (%rbx)
+	movq	%rbx, %rsp
+
+	/* Take the address of the trampoline exit code */
+	leaq	.Lret(%rip), %rbx
+
+	/* Switch to compatibility mode (CS.L = 0 CS.D = 1) via far return */
+	pushq	$__KERNEL32_CS
+	leaq	0f(%rip), %rax
+	pushq	%rax
+	lretq
+
+.Lret:
+	/* Restore the preserved 64-bit registers */
+	movq	(%rsp), %rsp
+	popq	%rbx
+	popq	%rbp
+	popq	%r15
+	retq
+
+	.code32
+0:
 	/* Set up data and stack segments */
 	movl	$__KERNEL_DS, %eax
 	movl	%eax, %ds
@@ -651,12 +652,9 @@ SYM_CODE_START(trampoline_32bit_src)
 1:
 	movl	%eax, %cr4
 
-	/* Calculate address of paging_enabled() once we are executing in the trampoline */
-	leal	.Lpaging_enabled - trampoline_32bit_src + TRAMPOLINE_32BIT_CODE_OFFSET(%ecx), %eax
-
 	/* Prepare the stack for far return to Long Mode */
 	pushl	$__KERNEL_CS
-	pushl	%eax
+	pushl	%ebx
 
 	/* Enable paging again. */
 	movl	%cr0, %eax
@@ -666,12 +664,6 @@ SYM_CODE_START(trampoline_32bit_src)
 	lret
 SYM_CODE_END(trampoline_32bit_src)
 
-	.code64
-SYM_FUNC_START_LOCAL_NOALIGN(.Lpaging_enabled)
-	/* Return from the trampoline */
-	retq
-SYM_FUNC_END(.Lpaging_enabled)
-
 	/*
          * The trampoline code has a size limit.
          * Make sure we fail to compile if the trampoline code grows
@@ -679,7 +671,6 @@ SYM_FUNC_END(.Lpaging_enabled)
 	 */
 	.org	trampoline_32bit_src + TRAMPOLINE_32BIT_CODE_SIZE
 
-	.code32
 SYM_FUNC_START_LOCAL_NOALIGN(.Lno_longmode)
 	/* This isn't an x86-64 CPU, so hang intentionally, we cannot continue */
 1:
--- a/arch/x86/boot/compressed/pgtable.h
+++ b/arch/x86/boot/compressed/pgtable.h
@@ -6,7 +6,7 @@
 #define TRAMPOLINE_32BIT_PGTABLE_OFFSET	0
 
 #define TRAMPOLINE_32BIT_CODE_OFFSET	PAGE_SIZE
-#define TRAMPOLINE_32BIT_CODE_SIZE	0x80
+#define TRAMPOLINE_32BIT_CODE_SIZE	0xA0
 
 #define TRAMPOLINE_32BIT_STACK_END	TRAMPOLINE_32BIT_SIZE
 


