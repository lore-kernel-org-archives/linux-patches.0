Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2701EB5A;
	Mon,  4 Mar 2024 21:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588834; cv=none; b=azHIy/cAUi416iIjHQ/kp8XW/6uo3TKyFAhLb1458ZHb9lPlH1Npax6/CU9vfqBOZjYnwIFF5edbwNTkp5Cu7RZQzs1QIqWmwjEfqWoIUoFlskZdKeP7Y1ppjoy11Vxfytfvf0i3EKPt1ZdZdH752Ic4770lDo331oRyGqJu9Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588834; c=relaxed/simple;
	bh=ptbw0RnhEqYhe/lEyeYytxKmnRVdG/VV4Yqz1jelRFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eypwqqNpAEcEP6dCA434Koyr6dCZjFy8NPZDx4CjwFcMUSYhfJT0l7osxUdx4iy1w5abCEkUuHBJ4ozPZV0ZTBlP8sV60DBc67+SihmWts2Zmv+XjPIdoZnycQlSMmM4cP6vzENFd3n4tFyAZRaUAcCRVtBFEPSdpLmo3xYXFWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hf/kEH1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hf/kEH1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C935C433F1;
	Mon,  4 Mar 2024 21:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588834;
	bh=ptbw0RnhEqYhe/lEyeYytxKmnRVdG/VV4Yqz1jelRFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hf/kEH1JitQhE8jNdmgJutX3Lc4KaFxo7fA+XOC/rFNj19ttt3qzadg1BzK5pD9f5
	 OvTxrh6+KgmkvkIrR4svzbBUtpH5skua/o7tWgiOpZvJVdgiChEFEsr2fET/BPiaJ0
	 0zgfZumDtGEEHSeITRlLw2zDeEulVQv5RdDqCbYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 114/215] x86/boot/compressed: Move efi32_entry out of head_64.S
Date: Mon,  4 Mar 2024 21:22:57 +0000
Message-ID: <20240304211600.661884232@linuxfoundation.org>
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

commit 73a6dec80e2acedaef3ca603d4b5799049f6e9f8 upstream.

Move the efi32_entry() routine out of head_64.S and into efi-mixed.S,
which reduces clutter in the complicated startup routines. It also
permits linkage of some symbols used by code to be made local.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221122161017.2426828-6-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/efi_mixed.S |   57 ++++++++++++++++++++++++++++-------
 arch/x86/boot/compressed/head_64.S   |   45 ---------------------------
 2 files changed, 47 insertions(+), 55 deletions(-)

--- a/arch/x86/boot/compressed/efi_mixed.S
+++ b/arch/x86/boot/compressed/efi_mixed.S
@@ -105,7 +105,7 @@ SYM_FUNC_START(__efi64_thunk)
 	/*
 	 * Switch to IDT and GDT with 32-bit segments. This is the firmware GDT
 	 * and IDT that was installed when the kernel started executing. The
-	 * pointers were saved at the EFI stub entry point in head_64.S.
+	 * pointers were saved by the efi32_entry() routine below.
 	 *
 	 * Pass the saved DS selector to the 32-bit code, and use far return to
 	 * restore the saved CS selector.
@@ -217,22 +217,59 @@ SYM_FUNC_START_LOCAL(efi_enter32)
 	lret
 SYM_FUNC_END(efi_enter32)
 
+/*
+ * This is the common EFI stub entry point for mixed mode.
+ *
+ * Arguments:	%ecx	image handle
+ * 		%edx	EFI system table pointer
+ *		%esi	struct bootparams pointer (or NULL when not using
+ *			the EFI handover protocol)
+ *
+ * Since this is the point of no return for ordinary execution, no registers
+ * are considered live except for the function parameters. [Note that the EFI
+ * stub may still exit and return to the firmware using the Exit() EFI boot
+ * service.]
+ */
+SYM_FUNC_START(efi32_entry)
+	call	1f
+1:	pop	%ebx
+
+	/* Save firmware GDTR and code/data selectors */
+	sgdtl	(efi32_boot_gdt - 1b)(%ebx)
+	movw	%cs, (efi32_boot_cs - 1b)(%ebx)
+	movw	%ds, (efi32_boot_ds - 1b)(%ebx)
+
+	/* Store firmware IDT descriptor */
+	sidtl	(efi32_boot_idt - 1b)(%ebx)
+
+	/* Store boot arguments */
+	leal	(efi32_boot_args - 1b)(%ebx), %ebx
+	movl	%ecx, 0(%ebx)
+	movl	%edx, 4(%ebx)
+	movl	%esi, 8(%ebx)
+	movb	$0x0, 12(%ebx)          // efi_is64
+
+	/* Disable paging */
+	movl	%cr0, %eax
+	btrl	$X86_CR0_PG_BIT, %eax
+	movl	%eax, %cr0
+
+	jmp	startup_32
+SYM_FUNC_END(efi32_entry)
+
 	.data
 	.balign	8
-SYM_DATA_START(efi32_boot_gdt)
+SYM_DATA_START_LOCAL(efi32_boot_gdt)
 	.word	0
 	.quad	0
 SYM_DATA_END(efi32_boot_gdt)
 
-SYM_DATA_START(efi32_boot_idt)
+SYM_DATA_START_LOCAL(efi32_boot_idt)
 	.word	0
 	.quad	0
 SYM_DATA_END(efi32_boot_idt)
 
-SYM_DATA_START(efi32_boot_cs)
-	.word	0
-SYM_DATA_END(efi32_boot_cs)
-
-SYM_DATA_START(efi32_boot_ds)
-	.word	0
-SYM_DATA_END(efi32_boot_ds)
+SYM_DATA_LOCAL(efi32_boot_cs, .word 0)
+SYM_DATA_LOCAL(efi32_boot_ds, .word 0)
+SYM_DATA_LOCAL(efi32_boot_args, .long 0, 0, 0)
+SYM_DATA(efi_is64, .byte 1)
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -289,48 +289,6 @@ SYM_FUNC_START(efi32_stub_entry)
 	popl	%esi
 	jmp	efi32_entry
 SYM_FUNC_END(efi32_stub_entry)
-
-	.text
-/*
- * This is the common EFI stub entry point for mixed mode.
- *
- * Arguments:	%ecx	image handle
- * 		%edx	EFI system table pointer
- *		%esi	struct bootparams pointer (or NULL when not using
- *			the EFI handover protocol)
- *
- * Since this is the point of no return for ordinary execution, no registers
- * are considered live except for the function parameters. [Note that the EFI
- * stub may still exit and return to the firmware using the Exit() EFI boot
- * service.]
- */
-SYM_FUNC_START_LOCAL(efi32_entry)
-	call	1f
-1:	pop	%ebx
-
-	/* Save firmware GDTR and code/data selectors */
-	sgdtl	(efi32_boot_gdt - 1b)(%ebx)
-	movw	%cs, (efi32_boot_cs - 1b)(%ebx)
-	movw	%ds, (efi32_boot_ds - 1b)(%ebx)
-
-	/* Store firmware IDT descriptor */
-	sidtl	(efi32_boot_idt - 1b)(%ebx)
-
-	/* Store boot arguments */
-	leal	(efi32_boot_args - 1b)(%ebx), %ebx
-	movl	%ecx, 0(%ebx)
-	movl	%edx, 4(%ebx)
-	movl	%esi, 8(%ebx)
-	movb	$0x0, 12(%ebx)          // efi_is64
-
-	/* Disable paging */
-	movl	%cr0, %eax
-	btrl	$X86_CR0_PG_BIT, %eax
-	movl	%eax, %cr0
-
-	jmp	startup_32
-SYM_FUNC_END(efi32_entry)
-	__HEAD
 #endif
 
 	.code64
@@ -779,9 +737,6 @@ SYM_DATA_END_LABEL(boot32_idt, SYM_L_GLO
 SYM_DATA(image_offset, .long 0)
 #endif
 #ifdef CONFIG_EFI_MIXED
-SYM_DATA(efi32_boot_args, .long 0, 0, 0)
-SYM_DATA(efi_is64, .byte 1)
-
 #define ST32_boottime		60 // offsetof(efi_system_table_32_t, boottime)
 #define BS32_handle_protocol	88 // offsetof(efi_boot_services_32_t, handle_protocol)
 #define LI32_image_base		32 // offsetof(efi_loaded_image_32_t, image_base)


