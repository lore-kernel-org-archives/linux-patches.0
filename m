Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E684149E0A;
	Tue, 25 Jun 2024 09:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309401; cv=none; b=avvxym1SB9NM5wu0uIZAKcV0fTeNPUii3PXO6U82p2Drj6rpOeGZ1dQrckLnCargXTHZnbaEBGlhL88mk2mv0qt9jCcETLowyc7L8jlB148UINia0Q+8M5Gv4/CqB0YwVNEYLSHpTqgOBk4eMmCY6lP6JkGrzwFKRoJTx3xm/gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309401; c=relaxed/simple;
	bh=RPe3OCFF9Avf2chir2KkVylTTQIhVwA3VBl6dx6aeMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1gYpBoK7K85cnB94M2wgi+74tlnaaJhbU/DS5OWnyEWHw/yyxp2wWbfHasRr3g8ASx+Gyp4oQy/niQhRFOTUODlDMLzjOxaACYGdRIL0DwR3cMg7BZtK/uqPEMhgHTrUV0d5vavaXIkO0tfmvhkjzl2PokzBDEW1bDlhesO50c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JlKvQMcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JlKvQMcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0B9C32781;
	Tue, 25 Jun 2024 09:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309400;
	bh=RPe3OCFF9Avf2chir2KkVylTTQIhVwA3VBl6dx6aeMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JlKvQMcf8mxKaWapccUNJh1T4+ca3UciLMJuoGtD+hoyu/Q7P6Q9pEh/Mjmq8PdM3
	 QPmu/kex3ui/wiJ7FGQMPrxuQufwi3yvw94a85x95SZG+ZjtU3IekWoUlvf51xi3Re
	 9+NDHN5WHi0JyKGWkvAhjk6Qu+Xw3fbsNuYJXq0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 186/192] LoongArch: Fix entry point in kernel image header
Date: Tue, 25 Jun 2024 11:34:18 +0200
Message-ID: <20240625085544.299912946@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit beb2800074c15362cf9f6c7301120910046d6556 ]

Currently kernel entry in head.S is in DMW address range, firmware is
instructed to jump to this address after loading the kernel image.

However kernel should not make any assumption on firmware's DMW
setting, thus the entry point should be a physical address falls into
direct translation region.

Fix by converting entry address to physical and amend entry calculation
logic in libstub accordingly.

BTW, use ABSOLUTE() to calculate variables to make Clang/LLVM happy.

Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/head.S             |  2 +-
 arch/loongarch/kernel/vmlinux.lds.S      | 10 ++++++----
 drivers/firmware/efi/libstub/loongarch.c |  2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/loongarch/kernel/head.S b/arch/loongarch/kernel/head.S
index 0ecab42163928..e336fbc4eb967 100644
--- a/arch/loongarch/kernel/head.S
+++ b/arch/loongarch/kernel/head.S
@@ -22,7 +22,7 @@
 _head:
 	.word	MZ_MAGIC		/* "MZ", MS-DOS header */
 	.org	0x8
-	.dword	kernel_entry		/* Kernel entry point */
+	.dword	_kernel_entry		/* Kernel entry point (physical address) */
 	.dword	_kernel_asize		/* Kernel image effective size */
 	.quad	PHYS_LINK_KADDR		/* Kernel image load offset from start of RAM */
 	.org	0x38			/* 0x20 ~ 0x37 reserved */
diff --git a/arch/loongarch/kernel/vmlinux.lds.S b/arch/loongarch/kernel/vmlinux.lds.S
index a5d0cd2035da0..d5afd0c80a499 100644
--- a/arch/loongarch/kernel/vmlinux.lds.S
+++ b/arch/loongarch/kernel/vmlinux.lds.S
@@ -5,6 +5,7 @@
 
 #define PAGE_SIZE _PAGE_SIZE
 #define RO_EXCEPTION_TABLE_ALIGN	4
+#define PHYSADDR_MASK			0xffffffffffff /* 48-bit */
 
 /*
  * Put .bss..swapper_pg_dir as the first thing in .bss. This will
@@ -139,10 +140,11 @@ SECTIONS
 
 #ifdef CONFIG_EFI_STUB
 	/* header symbols */
-	_kernel_asize = _end - _text;
-	_kernel_fsize = _edata - _text;
-	_kernel_vsize = _end - __initdata_begin;
-	_kernel_rsize = _edata - __initdata_begin;
+	_kernel_entry = ABSOLUTE(kernel_entry & PHYSADDR_MASK);
+	_kernel_asize = ABSOLUTE(_end - _text);
+	_kernel_fsize = ABSOLUTE(_edata - _text);
+	_kernel_vsize = ABSOLUTE(_end - __initdata_begin);
+	_kernel_rsize = ABSOLUTE(_edata - __initdata_begin);
 #endif
 
 	.gptab.sdata : {
diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmware/efi/libstub/loongarch.c
index 684c9354637c6..d0ef93551c44f 100644
--- a/drivers/firmware/efi/libstub/loongarch.c
+++ b/drivers/firmware/efi/libstub/loongarch.c
@@ -41,7 +41,7 @@ static efi_status_t exit_boot_func(struct efi_boot_memmap *map, void *priv)
 unsigned long __weak kernel_entry_address(unsigned long kernel_addr,
 		efi_loaded_image_t *image)
 {
-	return *(unsigned long *)(kernel_addr + 8) - VMLINUX_LOAD_ADDRESS + kernel_addr;
+	return *(unsigned long *)(kernel_addr + 8) - PHYSADDR(VMLINUX_LOAD_ADDRESS) + kernel_addr;
 }
 
 efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
-- 
2.43.0



