Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE8D13CA99;
	Thu, 13 Jun 2024 11:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279496; cv=none; b=JWTVtwhCAMm64li1LBM7QRrvOW9m2nOmbKZ6tC2A8lK4HNQHLkP4mC7k6aqjcwVu6dQgmjgCgz9JYp9uBZwxrGbGjBDhVc55V7tjQA4+qlgc33X0MuRCsziAnc7ERZjjKImS9NzEa5BIp/gUjAhNW1yigxVN2ZxbVu2QDpvrRCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279496; c=relaxed/simple;
	bh=cdK/exRxckjihbZo+0Mw9MWrfYjq6uE1HzNGJ0kNPvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfie/mzpoCrzbBZAd7Ro9ex2FAxlh3eCMouQheBDYAzcf06l6A1exsDkc7IuUbMHfGTFFoLqC6O96uH0jk/Usnv+a1Ldr4QygReDWv0d1uWi8zKa7oAluns0beTHrgQ+z0RJRNEf1MXvcyxKJ4t0VLMYVf7xR0TqSMj9qBd9ZTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atVELERW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atVELERW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F62C32786;
	Thu, 13 Jun 2024 11:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279495;
	bh=cdK/exRxckjihbZo+0Mw9MWrfYjq6uE1HzNGJ0kNPvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atVELERWYp9U05PNUin3j84N4jnlJwQt9Pq3eBSExX5uAHqq+qzBCU925F4B0ydyQ
	 L+GSVK8QqbMk4atfPp13U/w+nYweZY4KQF03IS/fda6wyUSimFbEYr6SCJGb7gz3xu
	 lbQwCJwWorwVXDrMdRMQBoSxQUQ1/Ty5Mg2ukiKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.9 064/157] LoongArch: Fix entry point in kernel image header
Date: Thu, 13 Jun 2024 13:33:09 +0200
Message-ID: <20240613113229.900217341@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit beb2800074c15362cf9f6c7301120910046d6556 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/head.S             |    2 +-
 arch/loongarch/kernel/vmlinux.lds.S      |   10 ++++++----
 drivers/firmware/efi/libstub/loongarch.c |    2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

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
--- a/arch/loongarch/kernel/vmlinux.lds.S
+++ b/arch/loongarch/kernel/vmlinux.lds.S
@@ -6,6 +6,7 @@
 
 #define PAGE_SIZE _PAGE_SIZE
 #define RO_EXCEPTION_TABLE_ALIGN	4
+#define PHYSADDR_MASK			0xffffffffffff /* 48-bit */
 
 /*
  * Put .bss..swapper_pg_dir as the first thing in .bss. This will
@@ -142,10 +143,11 @@ SECTIONS
 
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
--- a/drivers/firmware/efi/libstub/loongarch.c
+++ b/drivers/firmware/efi/libstub/loongarch.c
@@ -41,7 +41,7 @@ static efi_status_t exit_boot_func(struc
 unsigned long __weak kernel_entry_address(unsigned long kernel_addr,
 		efi_loaded_image_t *image)
 {
-	return *(unsigned long *)(kernel_addr + 8) - VMLINUX_LOAD_ADDRESS + kernel_addr;
+	return *(unsigned long *)(kernel_addr + 8) - PHYSADDR(VMLINUX_LOAD_ADDRESS) + kernel_addr;
 }
 
 efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,


