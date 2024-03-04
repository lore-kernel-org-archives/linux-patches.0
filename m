Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7FE1EB5A;
	Mon,  4 Mar 2024 21:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588839; cv=none; b=HQQxDftdMyGsWQV19MrqZVCMP3L5q8gtal8cL+goseWC4QZ2n53i1UJ+SW3w+F0CQ1CBA0NgPRw0RkoROhGbCL/qEMI18dtycOPY2J/pynuqESEEIEAy7QYiDHNb3HPORsWdXge0e7jdipwBakgtN6hEsGZi2HWvHfnkQdmc7a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588839; c=relaxed/simple;
	bh=CpKEdelIrIfT62pNQjHMRdidHErq0HEOhtA7BloQ80A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLeDW2b9WsNO23nwAl2ynNyDa/1GaLTrm33djETV6G3whpXr9HR3wN7Jeq5F9bfaqBRFXeyRO2P4JFvaHIlHX6/QSXyh7CHNRobg3U2zXjn5OPd7mCT7oHwxrI8V05FCYbUQFKMDz2aA1PrqGorxh1M0OOtjevCll1VWSurT7aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKBnkDYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKBnkDYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53851C433F1;
	Mon,  4 Mar 2024 21:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588839;
	bh=CpKEdelIrIfT62pNQjHMRdidHErq0HEOhtA7BloQ80A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKBnkDYncTfYVvTQF8oiopNtDxVrIYpACFK8RR8mECjnR2JfHykMAfYyrLo+3GqBN
	 GBtc3XtbZPJk7czn44gjPHMG0jaGa9qEihS1V705VwjfFo0sYsL8fNVpREAzOwsT8k
	 0FI3TC1JkYaAju5LteGczUWQL7MT1GxGqXnnp7dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 116/215] x86/boot/compressed, efi: Merge multiple definitions of image_offset into one
Date: Mon,  4 Mar 2024 21:22:59 +0000
Message-ID: <20240304211600.729829780@linuxfoundation.org>
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

commit 4b52016247aeaa55ca3e3bc2e03cd91114c145c2 upstream.

There is no need for head_32.S and head_64.S both declaring a copy of
the global 'image_offset' variable, so drop those and make the extern C
declaration the definition.

When image_offset is moved to the .c file, it needs to be placed
particularly in the .data section because it lands by default in the
.bss section which is cleared too late, in .Lrelocated, before the first
access to it and thus garbage gets read, leading to SEV guests exploding
in early boot.

This happens only when the SEV guest kernel is loaded through grub. If
supplied with qemu's -kernel command line option, that memory is always
cleared upfront by qemu and all is fine there.

  [ bp: Expand commit message with SEV aspect. ]

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221122161017.2426828-8-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_32.S      |    4 ----
 arch/x86/boot/compressed/head_64.S      |    4 ----
 drivers/firmware/efi/libstub/x86-stub.c |    2 +-
 3 files changed, 1 insertion(+), 9 deletions(-)

--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -208,10 +208,6 @@ SYM_DATA_START_LOCAL(gdt)
 	.quad	0x00cf92000000ffff	/* __KERNEL_DS */
 SYM_DATA_END_LABEL(gdt, SYM_L_LOCAL, gdt_end)
 
-#ifdef CONFIG_EFI_STUB
-SYM_DATA(image_offset, .long 0)
-#endif
-
 /*
  * Stack and heap for uncompression
  */
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -734,10 +734,6 @@ SYM_DATA_START(boot32_idt)
 SYM_DATA_END_LABEL(boot32_idt, SYM_L_GLOBAL, boot32_idt_end)
 #endif
 
-#ifdef CONFIG_EFI_STUB
-SYM_DATA(image_offset, .long 0)
-#endif
-
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 	__HEAD
 	.code32
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -23,7 +23,7 @@
 
 const efi_system_table_t *efi_system_table;
 const efi_dxe_services_table_t *efi_dxe_table;
-extern u32 image_offset;
+u32 image_offset __section(".data");
 static efi_loaded_image_t *image = NULL;
 
 static efi_status_t


