Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187A61EB5A;
	Mon,  4 Mar 2024 21:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588913; cv=none; b=aAcppEgqOW6YZfgoDzG27s7jBvu2/wzrchUX1NdzbOA/XovS+SrAqSZrulEqJsiJCWyocbd9RkHmGzLcTv74FhrKHOdPi3FqqoJXDr6/yytmG2lfxc34QyUxysWbiS4CUD/qlNq6gJ3PLP+hUOA+BfxfVmpZ4NDt2Z3jHllwHas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588913; c=relaxed/simple;
	bh=uD8xZMOOol1Bth74IPc+LzRg5qA0UcvwNs7l6S9z35Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDWSK0NiAEQSf652UlxPl3M0ikAQ8L6VOMwq0kkA3g2hAV19vGnNgoUyDBYfUtOIRG70l1gcGbpm8UyiyKdY7kproaacnTCHNJIDOfE67BW7d08WVpcZgyFt/LjoJfO8WbyMQ+RnFSbtHU7guGY5Xol1jtrZhpbpyelphbdpKEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDDcXb9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDDcXb9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C493C433F1;
	Mon,  4 Mar 2024 21:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588913;
	bh=uD8xZMOOol1Bth74IPc+LzRg5qA0UcvwNs7l6S9z35Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDDcXb9UlnT8O45CJu/2AW27VVVOx6eTP12C4LCc2vndMtpbSY7y5QvgOY3ub+EwX
	 j/sZDFfI8f0yJCz0hMP79Nm38/0+mcFQ00uP2u3pvzLSQU85yZrJxO0KeJw8kV0nRl
	 WNapAexH2Tr0s2ZnjdNeHRuq8+6pUoLgJAtf8Hqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 6.1 133/215] x86/decompressor: Use standard calling convention for trampoline
Date: Mon,  4 Mar 2024 21:23:16 +0000
Message-ID: <20240304211601.293602314@linuxfoundation.org>
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

commit 918a7a04e71745e99a0efc6753e587439b794b29 upstream.

Update the trampoline code so its arguments are passed via RDI and RSI,
which matches the ordinary SysV calling convention for x86_64. This will
allow this code to be called directly from C.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: https://lore.kernel.org/r/20230807162720.545787-11-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_64.S |   27 +++++++++++++--------------
 arch/x86/boot/compressed/pgtable.h |    2 +-
 2 files changed, 14 insertions(+), 15 deletions(-)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -447,9 +447,9 @@ SYM_CODE_START(startup_64)
 	movq	%r15, %rdi
 	call	paging_prepare
 
-	/* Save the trampoline address in RCX */
-	movq	%rax, %rcx
-
+	/* Pass the trampoline address and boolean flag as args #1 and #2 */
+	movq	%rax, %rdi
+	movq	%rdx, %rsi
 	leaq	TRAMPOLINE_32BIT_CODE_OFFSET(%rax), %rax
 	call	*%rax
 
@@ -549,11 +549,14 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated
 SYM_FUNC_END(.Lrelocated)
 
 /*
- * This is the 32-bit trampoline that will be copied over to low memory.
+ * This is the 32-bit trampoline that will be copied over to low memory. It
+ * will be called using the ordinary 64-bit calling convention from code
+ * running in 64-bit mode.
  *
  * Return address is at the top of the stack (might be above 4G).
- * ECX contains the base address of the trampoline memory.
- * Non zero RDX means trampoline needs to enable 5-level paging.
+ * The first argument (EDI) contains the 32-bit addressable base of the
+ * trampoline memory. A non-zero second argument (ESI) means that the
+ * trampoline needs to enable 5-level paging.
  */
 SYM_CODE_START(trampoline_32bit_src)
 	/*
@@ -600,7 +603,7 @@ SYM_CODE_START(trampoline_32bit_src)
 	movl	%eax, %cr0
 
 	/* Check what paging mode we want to be in after the trampoline */
-	testl	%edx, %edx
+	testl	%esi, %esi
 	jz	1f
 
 	/* We want 5-level paging: don't touch CR3 if it already points to 5-level page tables */
@@ -615,21 +618,17 @@ SYM_CODE_START(trampoline_32bit_src)
 	jz	3f
 2:
 	/* Point CR3 to the trampoline's new top level page table */
-	leal	TRAMPOLINE_32BIT_PGTABLE_OFFSET(%ecx), %eax
+	leal	TRAMPOLINE_32BIT_PGTABLE_OFFSET(%edi), %eax
 	movl	%eax, %cr3
 3:
 	/* Set EFER.LME=1 as a precaution in case hypervsior pulls the rug */
-	pushl	%ecx
-	pushl	%edx
 	movl	$MSR_EFER, %ecx
 	rdmsr
 	btsl	$_EFER_LME, %eax
 	/* Avoid writing EFER if no change was made (for TDX guest) */
 	jc	1f
 	wrmsr
-1:	popl	%edx
-	popl	%ecx
-
+1:
 #ifdef CONFIG_X86_MCE
 	/*
 	 * Preserve CR4.MCE if the kernel will enable #MC support.
@@ -646,7 +645,7 @@ SYM_CODE_START(trampoline_32bit_src)
 
 	/* Enable PAE and LA57 (if required) paging modes */
 	orl	$X86_CR4_PAE, %eax
-	testl	%edx, %edx
+	testl	%esi, %esi
 	jz	1f
 	orl	$X86_CR4_LA57, %eax
 1:
--- a/arch/x86/boot/compressed/pgtable.h
+++ b/arch/x86/boot/compressed/pgtable.h
@@ -14,7 +14,7 @@
 
 extern unsigned long *trampoline_32bit;
 
-extern void trampoline_32bit_src(void *return_ptr);
+extern void trampoline_32bit_src(void *trampoline, bool enable_5lvl);
 
 #endif /* __ASSEMBLER__ */
 #endif /* BOOT_COMPRESSED_PAGETABLE_H */


