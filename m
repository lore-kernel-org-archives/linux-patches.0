Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318E21EB5A;
	Mon,  4 Mar 2024 21:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588837; cv=none; b=maqBTM2c4jUYqtJW6QCXBRQKzUxFalCz3YZKcJH/W6wWvfkkoUKLyV6ROx6uSaceLC7hDw4uIDvWnf/5mk69icHtVr/8L3A0vkIpRsm+9R/bMAS64u7UaeDNHp1N3+4bhBlooPzwaVL4UnwAALpMHIzWldsbhacO2D/Q3dRO7WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588837; c=relaxed/simple;
	bh=MP0mlCYyCVmZ9oCNnQ8jw/MKt37Qcmnp65mS7Giz8XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3+r2irMykEIbr1BXKhodjQDYGJk/CfdY0XJ5oH5i6LezYd9yu/D9ZKdFqmT5K3vKkzJJhLswh1T9dKN+ax+PojXIra+0vFScNCU9xshZoLSI8SWtNNqvNvHuKtDvMa7hG09gs1kHU9QOB98S+trYI3QZWFqoM8QIsBGa4xsYWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWOqmksC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWOqmksC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7291C433C7;
	Mon,  4 Mar 2024 21:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588837;
	bh=MP0mlCYyCVmZ9oCNnQ8jw/MKt37Qcmnp65mS7Giz8XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWOqmksCQ2iZbpk/kUUlKFDqbfuM4zVohR2mrxrs6DTbdL36ZmzrS+YjjaN4rScRT
	 QxcWaFPiamuaUZzrZY6wAZzy04afc67EeJfdli2pUY/s3kE6iga40GRe8+5xaVF9MO
	 4S0crecU+GGFsDTDXpCTkRYMqgR/WhzubDxwLt18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 115/215] x86/boot/compressed: Move efi32_pe_entry() out of head_64.S
Date: Mon,  4 Mar 2024 21:22:58 +0000
Message-ID: <20240304211600.694163987@linuxfoundation.org>
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

commit 7f22ca396778fea9332d83ec2359dbe8396e9a06 upstream.

Move the implementation of efi32_pe_entry() into efi-mixed.S, which is a
more suitable location that only gets built if EFI mixed mode is
actually enabled.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221122161017.2426828-7-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/efi_mixed.S |   82 ++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/head_64.S   |   87 -----------------------------------
 2 files changed, 83 insertions(+), 86 deletions(-)

--- a/arch/x86/boot/compressed/efi_mixed.S
+++ b/arch/x86/boot/compressed/efi_mixed.S
@@ -257,6 +257,88 @@ SYM_FUNC_START(efi32_entry)
 	jmp	startup_32
 SYM_FUNC_END(efi32_entry)
 
+#define ST32_boottime		60 // offsetof(efi_system_table_32_t, boottime)
+#define BS32_handle_protocol	88 // offsetof(efi_boot_services_32_t, handle_protocol)
+#define LI32_image_base		32 // offsetof(efi_loaded_image_32_t, image_base)
+
+/*
+ * efi_status_t efi32_pe_entry(efi_handle_t image_handle,
+ *			       efi_system_table_32_t *sys_table)
+ */
+SYM_FUNC_START(efi32_pe_entry)
+	pushl	%ebp
+	movl	%esp, %ebp
+	pushl	%eax				// dummy push to allocate loaded_image
+
+	pushl	%ebx				// save callee-save registers
+	pushl	%edi
+
+	call	verify_cpu			// check for long mode support
+	testl	%eax, %eax
+	movl	$0x80000003, %eax		// EFI_UNSUPPORTED
+	jnz	2f
+
+	call	1f
+1:	pop	%ebx
+
+	/* Get the loaded image protocol pointer from the image handle */
+	leal	-4(%ebp), %eax
+	pushl	%eax				// &loaded_image
+	leal	(loaded_image_proto - 1b)(%ebx), %eax
+	pushl	%eax				// pass the GUID address
+	pushl	8(%ebp)				// pass the image handle
+
+	/*
+	 * Note the alignment of the stack frame.
+	 *   sys_table
+	 *   handle             <-- 16-byte aligned on entry by ABI
+	 *   return address
+	 *   frame pointer
+	 *   loaded_image       <-- local variable
+	 *   saved %ebx		<-- 16-byte aligned here
+	 *   saved %edi
+	 *   &loaded_image
+	 *   &loaded_image_proto
+	 *   handle             <-- 16-byte aligned for call to handle_protocol
+	 */
+
+	movl	12(%ebp), %eax			// sys_table
+	movl	ST32_boottime(%eax), %eax	// sys_table->boottime
+	call	*BS32_handle_protocol(%eax)	// sys_table->boottime->handle_protocol
+	addl	$12, %esp			// restore argument space
+	testl	%eax, %eax
+	jnz	2f
+
+	movl	8(%ebp), %ecx			// image_handle
+	movl	12(%ebp), %edx			// sys_table
+	movl	-4(%ebp), %esi			// loaded_image
+	movl	LI32_image_base(%esi), %esi	// loaded_image->image_base
+	leal	(startup_32 - 1b)(%ebx), %ebp	// runtime address of startup_32
+	/*
+	 * We need to set the image_offset variable here since startup_32() will
+	 * use it before we get to the 64-bit efi_pe_entry() in C code.
+	 */
+	subl	%esi, %ebp			// calculate image_offset
+	movl	%ebp, (image_offset - 1b)(%ebx)	// save image_offset
+	xorl	%esi, %esi
+	jmp	efi32_entry			// pass %ecx, %edx, %esi
+						// no other registers remain live
+
+2:	popl	%edi				// restore callee-save registers
+	popl	%ebx
+	leave
+	RET
+SYM_FUNC_END(efi32_pe_entry)
+
+	.section ".rodata"
+	/* EFI loaded image protocol GUID */
+	.balign 4
+SYM_DATA_START_LOCAL(loaded_image_proto)
+	.long	0x5b1b31a1
+	.word	0x9562, 0x11d2
+	.byte	0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b
+SYM_DATA_END(loaded_image_proto)
+
 	.data
 	.balign	8
 SYM_DATA_START_LOCAL(efi32_boot_gdt)
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -689,6 +689,7 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lno_longmo
 	jmp     1b
 SYM_FUNC_END(.Lno_longmode)
 
+	.globl	verify_cpu
 #include "../../kernel/verify_cpu.S"
 
 	.data
@@ -736,92 +737,6 @@ SYM_DATA_END_LABEL(boot32_idt, SYM_L_GLO
 #ifdef CONFIG_EFI_STUB
 SYM_DATA(image_offset, .long 0)
 #endif
-#ifdef CONFIG_EFI_MIXED
-#define ST32_boottime		60 // offsetof(efi_system_table_32_t, boottime)
-#define BS32_handle_protocol	88 // offsetof(efi_boot_services_32_t, handle_protocol)
-#define LI32_image_base		32 // offsetof(efi_loaded_image_32_t, image_base)
-
-	.text
-	.code32
-SYM_FUNC_START(efi32_pe_entry)
-/*
- * efi_status_t efi32_pe_entry(efi_handle_t image_handle,
- *			       efi_system_table_32_t *sys_table)
- */
-
-	pushl	%ebp
-	movl	%esp, %ebp
-	pushl	%eax				// dummy push to allocate loaded_image
-
-	pushl	%ebx				// save callee-save registers
-	pushl	%edi
-
-	call	verify_cpu			// check for long mode support
-	testl	%eax, %eax
-	movl	$0x80000003, %eax		// EFI_UNSUPPORTED
-	jnz	2f
-
-	call	1f
-1:	pop	%ebx
-
-	/* Get the loaded image protocol pointer from the image handle */
-	leal	-4(%ebp), %eax
-	pushl	%eax				// &loaded_image
-	leal	(loaded_image_proto - 1b)(%ebx), %eax
-	pushl	%eax				// pass the GUID address
-	pushl	8(%ebp)				// pass the image handle
-
-	/*
-	 * Note the alignment of the stack frame.
-	 *   sys_table
-	 *   handle             <-- 16-byte aligned on entry by ABI
-	 *   return address
-	 *   frame pointer
-	 *   loaded_image       <-- local variable
-	 *   saved %ebx		<-- 16-byte aligned here
-	 *   saved %edi
-	 *   &loaded_image
-	 *   &loaded_image_proto
-	 *   handle             <-- 16-byte aligned for call to handle_protocol
-	 */
-
-	movl	12(%ebp), %eax			// sys_table
-	movl	ST32_boottime(%eax), %eax	// sys_table->boottime
-	call	*BS32_handle_protocol(%eax)	// sys_table->boottime->handle_protocol
-	addl	$12, %esp			// restore argument space
-	testl	%eax, %eax
-	jnz	2f
-
-	movl	8(%ebp), %ecx			// image_handle
-	movl	12(%ebp), %edx			// sys_table
-	movl	-4(%ebp), %esi			// loaded_image
-	movl	LI32_image_base(%esi), %esi	// loaded_image->image_base
-	leal	(startup_32 - 1b)(%ebx), %ebp	// runtime address of startup_32
-	/*
-	 * We need to set the image_offset variable here since startup_32() will
-	 * use it before we get to the 64-bit efi_pe_entry() in C code.
-	 */
-	subl	%esi, %ebp			// calculate image_offset
-	movl	%ebp, (image_offset - 1b)(%ebx)	// save image_offset
-	xorl	%esi, %esi
-	jmp	efi32_entry			// pass %ecx, %edx, %esi
-						// no other registers remain live
-
-2:	popl	%edi				// restore callee-save registers
-	popl	%ebx
-	leave
-	RET
-SYM_FUNC_END(efi32_pe_entry)
-
-	.section ".rodata"
-	/* EFI loaded image protocol GUID */
-	.balign 4
-SYM_DATA_START_LOCAL(loaded_image_proto)
-	.long	0x5b1b31a1
-	.word	0x9562, 0x11d2
-	.byte	0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b
-SYM_DATA_END(loaded_image_proto)
-#endif
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 	__HEAD


