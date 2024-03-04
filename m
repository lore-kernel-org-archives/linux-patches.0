Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2792D1EB5A;
	Mon,  4 Mar 2024 21:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588932; cv=none; b=FI0q03cy9uCxtv0b1lWzsH+0ZuyaeDvhRqCKv5Ak0tvbGE/bKNRUgjESomzlZBLw+9Butb3U0VJjkmylkCLRC8ZhEK4gKBYrjsdjfMOqN/SIb04wGNj1pAkwe82UVVeW3v4lBlWwd+2tUhZ4cfDotSuu2RIRGVPxhZPN6rlL/7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588932; c=relaxed/simple;
	bh=EQIy65j4UDkwaKe3UV5x1GVcj7fljQzP0WOI26hFNc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctdhltjvhwumBUANKRSxQKr+w0Pga7UrbdaIw3mIktWxK2zaXHeQ+giH/1OfYGSIuVhWQ/t37xPQe67cC+q/mrtg2VsYwnDKtgR8OE/vttAZJ5esZ05+fA9sgtaNKkhvhxDn106M+si+Ab1B1GVP+GXXas+KtrwgKnsVBgP9G8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7/98JdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7/98JdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA69C43390;
	Mon,  4 Mar 2024 21:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588932;
	bh=EQIy65j4UDkwaKe3UV5x1GVcj7fljQzP0WOI26hFNc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7/98JdEz+TImdID8KLHvokszJ7PzQUQu+vuYxUCf8w+vQCN5+VL4fPKFwpZuLajh
	 V/uqILKZi/evFDqaSSkhJuVKqmW+QzfGycF1GND9f0a28bBOyiWvihijwrNpNAngFq
	 K0ZloXdHjz2zddkQbHzRDAwSMziIGYOytcOC9qMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 121/215] x86/boot/compressed: Move startup32_load_idt() out of head_64.S
Date: Mon,  4 Mar 2024 21:23:04 +0000
Message-ID: <20240304211600.909620964@linuxfoundation.org>
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

commit 9ea813be3d345dfb8ac5bf6fbb29e6a63647a39d upstream.

Now that startup32_load_idt() has been refactored into an ordinary
callable function, move it into mem-encrypt.S where it belongs.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221122161017.2426828-13-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_64.S     |   72 ---------------------------------
 arch/x86/boot/compressed/mem_encrypt.S |   72 ++++++++++++++++++++++++++++++++-
 2 files changed, 71 insertions(+), 73 deletions(-)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -723,78 +723,6 @@ SYM_DATA_START(boot_idt)
 	.endr
 SYM_DATA_END_LABEL(boot_idt, SYM_L_GLOBAL, boot_idt_end)
 
-#ifdef CONFIG_AMD_MEM_ENCRYPT
-SYM_DATA_START(boot32_idt_desc)
-	.word   boot32_idt_end - boot32_idt - 1
-	.long   0
-SYM_DATA_END(boot32_idt_desc)
-	.balign 8
-SYM_DATA_START(boot32_idt)
-	.rept 32
-	.quad 0
-	.endr
-SYM_DATA_END_LABEL(boot32_idt, SYM_L_GLOBAL, boot32_idt_end)
-
-	.text
-	.code32
-/*
- * Write an IDT entry into boot32_idt
- *
- * Parameters:
- *
- * %eax:	Handler address
- * %edx:	Vector number
- * %ecx:	IDT address
- */
-SYM_FUNC_START_LOCAL(startup32_set_idt_entry)
-	/* IDT entry address to %ecx */
-	leal	(%ecx, %edx, 8), %ecx
-
-	/* Build IDT entry, lower 4 bytes */
-	movl    %eax, %edx
-	andl    $0x0000ffff, %edx		# Target code segment offset [15:0]
-	orl	$(__KERNEL32_CS << 16), %edx	# Target code segment selector
-
-	/* Store lower 4 bytes to IDT */
-	movl    %edx, (%ecx)
-
-	/* Build IDT entry, upper 4 bytes */
-	movl    %eax, %edx
-	andl    $0xffff0000, %edx	# Target code segment offset [31:16]
-	orl     $0x00008e00, %edx	# Present, Type 32-bit Interrupt Gate
-
-	/* Store upper 4 bytes to IDT */
-	movl    %edx, 4(%ecx)
-
-	RET
-SYM_FUNC_END(startup32_set_idt_entry)
-
-SYM_FUNC_START(startup32_load_idt)
-	push	%ebp
-	push	%ebx
-
-	call	1f
-1:	pop	%ebp
-
-	leal    (boot32_idt - 1b)(%ebp), %ebx
-
-	/* #VC handler */
-	leal    (startup32_vc_handler - 1b)(%ebp), %eax
-	movl    $X86_TRAP_VC, %edx
-	movl	%ebx, %ecx
-	call    startup32_set_idt_entry
-
-	/* Load IDT */
-	leal	(boot32_idt_desc - 1b)(%ebp), %ecx
-	movl	%ebx, 2(%ecx)
-	lidt    (%ecx)
-
-	pop	%ebx
-	pop	%ebp
-	RET
-SYM_FUNC_END(startup32_load_idt)
-#endif
-
 /*
  * Check for the correct C-bit position when the startup_32 boot-path is used.
  *
--- a/arch/x86/boot/compressed/mem_encrypt.S
+++ b/arch/x86/boot/compressed/mem_encrypt.S
@@ -12,6 +12,8 @@
 #include <asm/processor-flags.h>
 #include <asm/msr.h>
 #include <asm/asm-offsets.h>
+#include <asm/segment.h>
+#include <asm/trapnr.h>
 
 	.text
 	.code32
@@ -98,7 +100,7 @@ SYM_CODE_START_LOCAL(sev_es_req_cpuid)
 	jmp	1b
 SYM_CODE_END(sev_es_req_cpuid)
 
-SYM_CODE_START(startup32_vc_handler)
+SYM_CODE_START_LOCAL(startup32_vc_handler)
 	pushl	%eax
 	pushl	%ebx
 	pushl	%ecx
@@ -184,6 +186,63 @@ SYM_CODE_START(startup32_vc_handler)
 	jmp .Lfail
 SYM_CODE_END(startup32_vc_handler)
 
+/*
+ * Write an IDT entry into boot32_idt
+ *
+ * Parameters:
+ *
+ * %eax:	Handler address
+ * %edx:	Vector number
+ * %ecx:	IDT address
+ */
+SYM_FUNC_START_LOCAL(startup32_set_idt_entry)
+	/* IDT entry address to %ecx */
+	leal	(%ecx, %edx, 8), %ecx
+
+	/* Build IDT entry, lower 4 bytes */
+	movl    %eax, %edx
+	andl    $0x0000ffff, %edx		# Target code segment offset [15:0]
+	orl	$(__KERNEL32_CS << 16), %edx	# Target code segment selector
+
+	/* Store lower 4 bytes to IDT */
+	movl    %edx, (%ecx)
+
+	/* Build IDT entry, upper 4 bytes */
+	movl    %eax, %edx
+	andl    $0xffff0000, %edx	# Target code segment offset [31:16]
+	orl     $0x00008e00, %edx	# Present, Type 32-bit Interrupt Gate
+
+	/* Store upper 4 bytes to IDT */
+	movl    %edx, 4(%ecx)
+
+	RET
+SYM_FUNC_END(startup32_set_idt_entry)
+
+SYM_FUNC_START(startup32_load_idt)
+	push	%ebp
+	push	%ebx
+
+	call	1f
+1:	pop	%ebp
+
+	leal    (boot32_idt - 1b)(%ebp), %ebx
+
+	/* #VC handler */
+	leal    (startup32_vc_handler - 1b)(%ebp), %eax
+	movl    $X86_TRAP_VC, %edx
+	movl	%ebx, %ecx
+	call    startup32_set_idt_entry
+
+	/* Load IDT */
+	leal	(boot32_idt_desc - 1b)(%ebp), %ecx
+	movl	%ebx, 2(%ecx)
+	lidt    (%ecx)
+
+	pop	%ebx
+	pop	%ebp
+	RET
+SYM_FUNC_END(startup32_load_idt)
+
 	.code64
 
 #include "../../kernel/sev_verify_cbit.S"
@@ -195,4 +254,15 @@ SYM_CODE_END(startup32_vc_handler)
 SYM_DATA(sme_me_mask,		.quad 0)
 SYM_DATA(sev_status,		.quad 0)
 SYM_DATA(sev_check_data,	.quad 0)
+
+SYM_DATA_START_LOCAL(boot32_idt)
+	.rept	32
+	.quad	0
+	.endr
+SYM_DATA_END(boot32_idt)
+
+SYM_DATA_START_LOCAL(boot32_idt_desc)
+	.word	. - boot32_idt - 1
+	.long	0
+SYM_DATA_END(boot32_idt_desc)
 #endif


