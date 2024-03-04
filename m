Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6FE1F92C;
	Mon,  4 Mar 2024 21:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588899; cv=none; b=GtwJlcs9QIwyNcxSDW09ibJ1891U11zpxO122382hRGx/6n9XlE+VlIrKWsXncpR0hEwrPco9uSBYOzYrJBfvaPmGLyKxDa48500FB2058Egv5cQiWBx7vCz1Aq+QEOE1/3TUEpEGj9MJa8KzBS3nY1GLit1imJnROaFEJlOoKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588899; c=relaxed/simple;
	bh=0xWYAJjkJB7jXODKPNci8de/s0k1ap9bTo8VVMwMN34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cH06/2Z479TwEWd0AJhkKmF1m7ENj8DcjAUhM7X45flYtKgwA/ceL81u6TUwYcrjZobEiO3Lxah17U8/hp4ZMtV0JR/5mDA0R5zJ+NVV99F2LLhH99gROT6yubfIu4OwfwdQjtQ48pvHSh8EOIH3gGSL3Mq04RL9VS8n3j8Z/qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDkvhaxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDkvhaxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15096C433C7;
	Mon,  4 Mar 2024 21:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588899;
	bh=0xWYAJjkJB7jXODKPNci8de/s0k1ap9bTo8VVMwMN34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDkvhaxWpwyTNns9tq452ZCwcPZ48O2vhLRLwsKevLxAfKacnNvaDryCRtJwaDn72
	 kHtFbJVP778BmWiUHaO9ioMNV5C58hC4g+21defJUyssbKUI9yHqGRNVL+0G6VIf1y
	 mNEimVE5YB5u0P9c3IyKVthqnF0/jARuElXFQy64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 130/215] x86/decompressor: Store boot_params pointer in callee save register
Date: Mon,  4 Mar 2024 21:23:13 +0000
Message-ID: <20240304211601.203756391@linuxfoundation.org>
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

commit 8b63cba746f86a754d66e302c43209cc9b9b6e39 upstream.

Instead of pushing and popping %RSI several times to preserve the struct
boot_params pointer across the execution of the startup code, move it
into a callee save register before the first call into C, and copy it
back when needed.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230807162720.545787-8-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_64.S |   42 ++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -408,10 +408,14 @@ SYM_CODE_START(startup_64)
 	lretq
 
 .Lon_kernel_cs:
+	/*
+	 * RSI holds a pointer to a boot_params structure provided by the
+	 * loader, and this needs to be preserved across C function calls. So
+	 * move it into a callee saved register.
+	 */
+	movq	%rsi, %r15
 
-	pushq	%rsi
 	call	load_stage1_idt
-	popq	%rsi
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 	/*
@@ -422,12 +426,10 @@ SYM_CODE_START(startup_64)
 	 * CPUID instructions being issued, so go ahead and do that now via
 	 * sev_enable(), which will also handle the rest of the SEV-related
 	 * detection/setup to ensure that has been done in advance of any dependent
-	 * code.
+	 * code. Pass the boot_params pointer as the first argument.
 	 */
-	pushq	%rsi
-	movq	%rsi, %rdi		/* real mode address */
+	movq	%r15, %rdi
 	call	sev_enable
-	popq	%rsi
 #endif
 
 	/*
@@ -440,13 +442,10 @@ SYM_CODE_START(startup_64)
 	 *   - Non zero RDX means trampoline needs to enable 5-level
 	 *     paging.
 	 *
-	 * RSI holds real mode data and needs to be preserved across
-	 * this function call.
+	 * Pass the boot_params pointer as the first argument.
 	 */
-	pushq	%rsi
-	movq	%rsi, %rdi		/* real mode address */
+	movq	%r15, %rdi
 	call	paging_prepare
-	popq	%rsi
 
 	/* Save the trampoline address in RCX */
 	movq	%rax, %rcx
@@ -459,9 +458,9 @@ SYM_CODE_START(startup_64)
 	 * because the architecture does not guarantee that GPRs will retain
 	 * their full 64-bit values across a 32-bit mode switch.
 	 */
+	pushq	%r15
 	pushq	%rbp
 	pushq	%rbx
-	pushq	%rsi
 
 	/*
 	 * Push the 64-bit address of trampoline_return() onto the new stack.
@@ -478,9 +477,9 @@ SYM_CODE_START(startup_64)
 	lretq
 trampoline_return:
 	/* Restore live 64-bit registers */
-	popq	%rsi
 	popq	%rbx
 	popq	%rbp
+	popq	%r15
 
 	/* Restore the stack, the 32-bit trampoline uses its own stack */
 	leaq	rva(boot_stack_end)(%rbx), %rsp
@@ -490,14 +489,9 @@ trampoline_return:
 	 *
 	 * RDI is address of the page table to use instead of page table
 	 * in trampoline memory (if required).
-	 *
-	 * RSI holds real mode data and needs to be preserved across
-	 * this function call.
 	 */
-	pushq	%rsi
 	leaq	rva(top_pgtable)(%rbx), %rdi
 	call	cleanup_trampoline
-	popq	%rsi
 
 	/* Zero EFLAGS */
 	pushq	$0
@@ -507,7 +501,6 @@ trampoline_return:
  * Copy the compressed kernel to the end of our buffer
  * where decompression in place becomes safe.
  */
-	pushq	%rsi
 	leaq	(_bss-8)(%rip), %rsi
 	leaq	rva(_bss-8)(%rbx), %rdi
 	movl	$(_bss - startup_32), %ecx
@@ -515,7 +508,6 @@ trampoline_return:
 	std
 	rep	movsq
 	cld
-	popq	%rsi
 
 	/*
 	 * The GDT may get overwritten either during the copy we just did or
@@ -562,30 +554,28 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated
 	shrq	$3, %rcx
 	rep	stosq
 
-	pushq	%rsi
 	call	load_stage2_idt
 
 	/* Pass boot_params to initialize_identity_maps() */
-	movq	(%rsp), %rdi
+	movq	%r15, %rdi
 	call	initialize_identity_maps
-	popq	%rsi
 
 /*
  * Do the extraction, and jump to the new kernel..
  */
-	pushq	%rsi			/* Save the real mode argument */
-	movq	%rsi, %rdi		/* real mode address */
+	/* pass struct boot_params pointer */
+	movq	%r15, %rdi
 	leaq	boot_heap(%rip), %rsi	/* malloc area for uncompression */
 	leaq	input_data(%rip), %rdx  /* input_data */
 	movl	input_len(%rip), %ecx	/* input_len */
 	movq	%rbp, %r8		/* output target address */
 	movl	output_len(%rip), %r9d	/* decompressed length, end of relocs */
 	call	extract_kernel		/* returns kernel entry point in %rax */
-	popq	%rsi
 
 /*
  * Jump to the decompressed kernel.
  */
+	movq	%r15, %rsi
 	jmp	*%rax
 SYM_FUNC_END(.Lrelocated)
 


