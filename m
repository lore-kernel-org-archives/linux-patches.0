Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308371F92C;
	Mon,  4 Mar 2024 21:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588937; cv=none; b=blcKO1PdBb519HLKuFjFAks9a4omgeuZXG+YDB9c0n95b+uW8UubTXuJq1+yKFsaCuUG7EDrbZpqXvL06UJf32KKRPZdlvKx8ytfPWG7yshK/egfb/Riwe/rFohTsrJ1KlB4WcmVZ/LtgK4QkVdW1vt8MAlVhVeQfiAQDTPNV5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588937; c=relaxed/simple;
	bh=boNzhSxrAYRX/Je6P+VM9+jwoc97vOmUZ49MRi24/OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmZtEkcUNcXcnK8OuJMGWdTyLEFP5UkrAPLWdoXTRNKU4iuWYeppLq+6ylZg7j2iX6DpaU0nZ3rLTu+peWeOrR4rA+Mqvm1f/Wht47A9zxWjKgNTEzHjAcFWWZjF5J53B3ZnCYYLoagVrsC8BjQdj8tIPGz9HYOh+AEw4Tb2dnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=etLEgYgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="etLEgYgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B69C433F1;
	Mon,  4 Mar 2024 21:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588937;
	bh=boNzhSxrAYRX/Je6P+VM9+jwoc97vOmUZ49MRi24/OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=etLEgYgB4/R22QuefOSGlQOxXSquV32kQIRYKEZcDhGeGnhihEqhw2er/ExhMWSlX
	 u+IPRcDOTRIwQ4PhtsRbmDAQPD+kvMRbuXLqLhDdohpKDlkLwFX7wCVT3LG59tF1Mx
	 ULP3kwSIwDRW8z+zEqRCUg/vsfkaiIXOluCnvjGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 139/215] x86/decompressor: Move global symbol references to C code
Date: Mon,  4 Mar 2024 21:23:22 +0000
Message-ID: <20240304211601.474458638@linuxfoundation.org>
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

commit 24388292e2d7fae79a0d4183cc91716b851299cf upstream.

It is no longer necessary to be cautious when referring to global
variables in the position independent decompressor code, now that it is
built using PIE codegen and makes an assertion in the linker script that
no GOT entries exist (which would require adjustment for the actual
runtime load address of the decompressor binary).

This means global variables can be referenced directly from C code,
instead of having to pass their runtime addresses into C routines from
asm code, which needs to happen at each call site. Do so for the code
that will be called directly from the EFI stub after a subsequent patch,
and avoid the need to duplicate this logic a third time.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230807162720.545787-20-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_32.S |    8 --------
 arch/x86/boot/compressed/head_64.S |   10 ++--------
 arch/x86/boot/compressed/misc.c    |   16 +++++++++-------
 3 files changed, 11 insertions(+), 23 deletions(-)

--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -179,13 +179,7 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated
  */
 	/* push arguments for extract_kernel: */
 
-	pushl	output_len@GOTOFF(%ebx)	/* decompressed length, end of relocs */
 	pushl	%ebp			/* output address */
-	pushl	input_len@GOTOFF(%ebx)	/* input_len */
-	leal	input_data@GOTOFF(%ebx), %eax
-	pushl	%eax			/* input_data */
-	leal	boot_heap@GOTOFF(%ebx), %eax
-	pushl	%eax			/* heap area */
 	pushl	%esi			/* real mode pointer */
 	call	extract_kernel		/* returns kernel entry point in %eax */
 	addl	$24, %esp
@@ -213,8 +207,6 @@ SYM_DATA_END_LABEL(gdt, SYM_L_LOCAL, gdt
  */
 	.bss
 	.balign 4
-boot_heap:
-	.fill BOOT_HEAP_SIZE, 1, 0
 boot_stack:
 	.fill BOOT_STACK_SIZE, 1, 0
 boot_stack_end:
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -511,13 +511,9 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated
 /*
  * Do the extraction, and jump to the new kernel..
  */
-	/* pass struct boot_params pointer */
+	/* pass struct boot_params pointer and output target address */
 	movq	%r15, %rdi
-	leaq	boot_heap(%rip), %rsi	/* malloc area for uncompression */
-	leaq	input_data(%rip), %rdx  /* input_data */
-	movl	input_len(%rip), %ecx	/* input_len */
-	movq	%rbp, %r8		/* output target address */
-	movl	output_len(%rip), %r9d	/* decompressed length, end of relocs */
+	movq	%rbp, %rsi
 	call	extract_kernel		/* returns kernel entry point in %rax */
 
 /*
@@ -675,8 +671,6 @@ SYM_DATA_END_LABEL(boot_idt, SYM_L_GLOBA
  */
 	.bss
 	.balign 4
-SYM_DATA_LOCAL(boot_heap,	.fill BOOT_HEAP_SIZE, 1, 0)
-
 SYM_DATA_START_LOCAL(boot_stack)
 	.fill BOOT_STACK_SIZE, 1, 0
 	.balign 16
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -330,6 +330,11 @@ static size_t parse_elf(void *output)
 	return ehdr.e_entry - LOAD_PHYSICAL_ADDR;
 }
 
+static u8 boot_heap[BOOT_HEAP_SIZE] __aligned(4);
+
+extern unsigned char input_data[];
+extern unsigned int input_len, output_len;
+
 /*
  * The compressed kernel image (ZO), has been moved so that its position
  * is against the end of the buffer used to hold the uncompressed kernel
@@ -347,14 +352,11 @@ static size_t parse_elf(void *output)
  *             |-------uncompressed kernel image---------|
  *
  */
-asmlinkage __visible void *extract_kernel(void *rmode, memptr heap,
-				  unsigned char *input_data,
-				  unsigned long input_len,
-				  unsigned char *output,
-				  unsigned long output_len)
+asmlinkage __visible void *extract_kernel(void *rmode, unsigned char *output)
 {
 	const unsigned long kernel_total_size = VO__end - VO__text;
 	unsigned long virt_addr = LOAD_PHYSICAL_ADDR;
+	memptr heap = (memptr)boot_heap;
 	unsigned long needed_size;
 	size_t entry_offset;
 
@@ -412,7 +414,7 @@ asmlinkage __visible void *extract_kerne
 	 * entries. This ensures the full mapped area is usable RAM
 	 * and doesn't include any reserved areas.
 	 */
-	needed_size = max(output_len, kernel_total_size);
+	needed_size = max_t(unsigned long, output_len, kernel_total_size);
 #ifdef CONFIG_X86_64
 	needed_size = ALIGN(needed_size, MIN_KERNEL_ALIGN);
 #endif
@@ -443,7 +445,7 @@ asmlinkage __visible void *extract_kerne
 #ifdef CONFIG_X86_64
 	if (heap > 0x3fffffffffffUL)
 		error("Destination address too large");
-	if (virt_addr + max(output_len, kernel_total_size) > KERNEL_IMAGE_SIZE)
+	if (virt_addr + needed_size > KERNEL_IMAGE_SIZE)
 		error("Destination virtual address is beyond the kernel mapping area");
 #else
 	if (heap > ((-__PAGE_OFFSET-(128<<20)-1) & 0x7fffffff))


