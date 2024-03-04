Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEBC200D4;
	Mon,  4 Mar 2024 21:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588917; cv=none; b=Z1HvWQNHkHe1t+pQ9tVvoMpKm61Qk43NneCiAnRxBVcu0C/uf7xb5yerCvbQcgq/xbaWPcAK8A50PbioJmlg6KV/In55ZjG/EztMQ/pgTq6WIh7SeswzltwScl6NPOiys4L4xeiwSXWethnHJwZEW0/E7OU4Mu8crXQL9C2ZwXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588917; c=relaxed/simple;
	bh=qQniGHr94KYLdfNasvqLPvnmMzsRr70oW0KCdvtsHjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwUNJTTcm1mp+k053Bh/5h9fO2EDaowhnxKXNQWZIErY82pVUvAUFnfSN33JYmyJEeP4BIzL3uNaS28rRJW/Nfuj+cQuMAm5Ur++z8GVXUST6/xLEUnadijGUCsbb8gdveACLLu324YrY4xCtzSkDLsW+g5opAeS4+3XJPaYCXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTLkfbpF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTLkfbpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CDCC433F1;
	Mon,  4 Mar 2024 21:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588917;
	bh=qQniGHr94KYLdfNasvqLPvnmMzsRr70oW0KCdvtsHjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTLkfbpFOnG4PGNWuq7CopT8xawgfZDxcfS7ZP7uRcaAj0R6FZZ1c/iGV2v2g5rmD
	 3LKTfYwTqMu6So5zrd2Bdnf1KpHyIx3GIuNYIYjS9AKcHd3I249xVMW6n+i/5JdLvW
	 W0h2/OPlx+2ggNYY835JOr7ckmdat+jEWeFpf/N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 6.1 134/215] x86/decompressor: Avoid the need for a stack in the 32-bit trampoline
Date: Mon,  4 Mar 2024 21:23:17 +0000
Message-ID: <20240304211601.325857332@linuxfoundation.org>
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

commit bd328aa01ff77a45aeffea5fc4521854291db11f upstream.

The 32-bit trampoline no longer uses the stack for anything except
performing a far return back to long mode, and preserving the caller's
stack pointer value. Currently, the trampoline stack is placed in the
same page that carries the trampoline code, which means this page must
be mapped writable and executable, and the stack is therefore executable
as well.

Replace the far return with a far jump, so that the return address can
be pre-calculated and patched into the code before it is called. This
removes the need for a 32-bit addressable stack entirely, and in a later
patch, this will be taken advantage of by removing writable permissions
from (and adding executable permissions to) the trampoline code page
when booting via the EFI stub.

Note that the value of RSP still needs to be preserved explicitly across
the switch into 32-bit mode, as the register may get truncated to 32
bits.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: https://lore.kernel.org/r/20230807162720.545787-12-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_64.S    |   45 ++++++++++++++++++++--------------
 arch/x86/boot/compressed/pgtable.h    |    4 +--
 arch/x86/boot/compressed/pgtable_64.c |   12 ++++++++-
 3 files changed, 40 insertions(+), 21 deletions(-)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -558,6 +558,7 @@ SYM_FUNC_END(.Lrelocated)
  * trampoline memory. A non-zero second argument (ESI) means that the
  * trampoline needs to enable 5-level paging.
  */
+	.section ".rodata", "a", @progbits
 SYM_CODE_START(trampoline_32bit_src)
 	/*
 	 * Preserve live 64-bit registers on the stack: this is necessary
@@ -568,13 +569,9 @@ SYM_CODE_START(trampoline_32bit_src)
 	pushq	%rbp
 	pushq	%rbx
 
-	/* Set up 32-bit addressable stack and push the old RSP value */
-	leaq	(TRAMPOLINE_32BIT_STACK_END - 8)(%rcx), %rbx
-	movq	%rsp, (%rbx)
-	movq	%rbx, %rsp
-
-	/* Take the address of the trampoline exit code */
-	leaq	.Lret(%rip), %rbx
+	/* Preserve top half of RSP in a legacy mode GPR to avoid truncation */
+	movq	%rsp, %rbx
+	shrq	$32, %rbx
 
 	/* Switch to compatibility mode (CS.L = 0 CS.D = 1) via far return */
 	pushq	$__KERNEL32_CS
@@ -582,9 +579,17 @@ SYM_CODE_START(trampoline_32bit_src)
 	pushq	%rax
 	lretq
 
+	/*
+	 * The 32-bit code below will do a far jump back to long mode and end
+	 * up here after reconfiguring the number of paging levels. First, the
+	 * stack pointer needs to be restored to its full 64-bit value before
+	 * the callee save register contents can be popped from the stack.
+	 */
 .Lret:
+	shlq	$32, %rbx
+	orq	%rbx, %rsp
+
 	/* Restore the preserved 64-bit registers */
-	movq	(%rsp), %rsp
 	popq	%rbx
 	popq	%rbp
 	popq	%r15
@@ -592,11 +597,6 @@ SYM_CODE_START(trampoline_32bit_src)
 
 	.code32
 0:
-	/* Set up data and stack segments */
-	movl	$__KERNEL_DS, %eax
-	movl	%eax, %ds
-	movl	%eax, %ss
-
 	/* Disable paging */
 	movl	%cr0, %eax
 	btrl	$X86_CR0_PG_BIT, %eax
@@ -651,18 +651,26 @@ SYM_CODE_START(trampoline_32bit_src)
 1:
 	movl	%eax, %cr4
 
-	/* Prepare the stack for far return to Long Mode */
-	pushl	$__KERNEL_CS
-	pushl	%ebx
-
 	/* Enable paging again. */
 	movl	%cr0, %eax
 	btsl	$X86_CR0_PG_BIT, %eax
 	movl	%eax, %cr0
 
-	lret
+	/*
+	 * Return to the 64-bit calling code using LJMP rather than LRET, to
+	 * avoid the need for a 32-bit addressable stack. The destination
+	 * address will be adjusted after the template code is copied into a
+	 * 32-bit addressable buffer.
+	 */
+.Ljmp:	ljmpl	$__KERNEL_CS, $(.Lret - trampoline_32bit_src)
 SYM_CODE_END(trampoline_32bit_src)
 
+/*
+ * This symbol is placed right after trampoline_32bit_src() so its address can
+ * be used to infer the size of the trampoline code.
+ */
+SYM_DATA(trampoline_ljmp_imm_offset, .word  .Ljmp + 1 - trampoline_32bit_src)
+
 	/*
          * The trampoline code has a size limit.
          * Make sure we fail to compile if the trampoline code grows
@@ -670,6 +678,7 @@ SYM_CODE_END(trampoline_32bit_src)
 	 */
 	.org	trampoline_32bit_src + TRAMPOLINE_32BIT_CODE_SIZE
 
+	.text
 SYM_FUNC_START_LOCAL_NOALIGN(.Lno_longmode)
 	/* This isn't an x86-64 CPU, so hang intentionally, we cannot continue */
 1:
--- a/arch/x86/boot/compressed/pgtable.h
+++ b/arch/x86/boot/compressed/pgtable.h
@@ -8,13 +8,13 @@
 #define TRAMPOLINE_32BIT_CODE_OFFSET	PAGE_SIZE
 #define TRAMPOLINE_32BIT_CODE_SIZE	0xA0
 
-#define TRAMPOLINE_32BIT_STACK_END	TRAMPOLINE_32BIT_SIZE
-
 #ifndef __ASSEMBLER__
 
 extern unsigned long *trampoline_32bit;
 
 extern void trampoline_32bit_src(void *trampoline, bool enable_5lvl);
 
+extern const u16 trampoline_ljmp_imm_offset;
+
 #endif /* __ASSEMBLER__ */
 #endif /* BOOT_COMPRESSED_PAGETABLE_H */
--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -109,6 +109,7 @@ static unsigned long find_trampoline_pla
 struct paging_config paging_prepare(void *rmode)
 {
 	struct paging_config paging_config = {};
+	void *tramp_code;
 
 	/* Initialize boot_params. Required for cmdline_find_option_bool(). */
 	boot_params = rmode;
@@ -148,10 +149,19 @@ struct paging_config paging_prepare(void
 	memset(trampoline_32bit, 0, TRAMPOLINE_32BIT_SIZE);
 
 	/* Copy trampoline code in place */
-	memcpy(trampoline_32bit + TRAMPOLINE_32BIT_CODE_OFFSET / sizeof(unsigned long),
+	tramp_code = memcpy(trampoline_32bit +
+			TRAMPOLINE_32BIT_CODE_OFFSET / sizeof(unsigned long),
 			&trampoline_32bit_src, TRAMPOLINE_32BIT_CODE_SIZE);
 
 	/*
+	 * Avoid the need for a stack in the 32-bit trampoline code, by using
+	 * LJMP rather than LRET to return back to long mode. LJMP takes an
+	 * immediate absolute address, which needs to be adjusted based on the
+	 * placement of the trampoline.
+	 */
+	*(u32 *)(tramp_code + trampoline_ljmp_imm_offset) += (unsigned long)tramp_code;
+
+	/*
 	 * The code below prepares page table in trampoline memory.
 	 *
 	 * The new page table will be used by trampoline code for switching


