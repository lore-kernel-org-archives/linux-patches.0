Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F241B96D;
	Thu, 18 Jan 2024 10:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575282; cv=none; b=MNopbgx1NgQPAtRYiO7WEsfRzMTFM98PqsCyeNpyt5/MsAlh9h1XJy2BF2wdXcrK4JVB7xwtVLjaUTelT8NY9lP3PQq/R35gTYswEmJokFo3ORO4ws7jaHbVKRDPo9ihBkAta4t2B+fNZ5rwQtWi7xMQG5OZC15BW4JgpwkOpDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575282; c=relaxed/simple;
	bh=asnCTIp/Xk5mXYSA8NzGhJnEau7zw90o9zCmNu594oU=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=mPQwlqF2iAkBKclMJSUhYROpbcNdvNkJ2fjQjakSAJkxHOGPByrfE24aKNnw50dht3RzoIbATzXS5lxZnu+qyMFda8JwuVB4x44b8EbNv6dYqJU1XipOqxuxYkq+uxEj1o9cuY8u2h/654SfSKJJnDodKBJoy3WXPh4jHSAxHSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYUSlxQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYUSlxQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE31C433F1;
	Thu, 18 Jan 2024 10:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575282;
	bh=asnCTIp/Xk5mXYSA8NzGhJnEau7zw90o9zCmNu594oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYUSlxQSLL1AjpRK0fxDnIDiEmJDwRkO5IojpAdxkpFvJtJow50TD/gTpj/1Qj0k3
	 LmZZLVqc2wzF64HnySA0sj63K1xmVSAUiNvfh2H9/aPtDYIrkMwM7fXh8csdoANtK8
	 0p24TccKmCFMyZqZpFcjeNi8aCP1ZaEbo2Gl/p9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Wang Yao <wangyao@lemote.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/150] efi/loongarch: Use load address to calculate kernel entry address
Date: Thu, 18 Jan 2024 11:48:19 +0100
Message-ID: <20240118104323.548619459@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Wang Yao <wangyao@lemote.com>

[ Upstream commit 271f2a4a9576b87ed1f8584909d6d270039e52ea ]

The efi_relocate_kernel() may load the PIE kernel to anywhere, the
loaded address may not be equal to link address or
EFI_KIMG_PREFERRED_ADDRESS.

Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Wang Yao <wangyao@lemote.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/efi.h              | 2 +-
 drivers/firmware/efi/libstub/loongarch-stub.c | 4 ++--
 drivers/firmware/efi/libstub/loongarch.c      | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/loongarch/include/asm/efi.h b/arch/loongarch/include/asm/efi.h
index 091897d40b03..91d81f9730ab 100644
--- a/arch/loongarch/include/asm/efi.h
+++ b/arch/loongarch/include/asm/efi.h
@@ -32,6 +32,6 @@ static inline unsigned long efi_get_kimg_min_align(void)
 
 #define EFI_KIMG_PREFERRED_ADDRESS	PHYSADDR(VMLINUX_LOAD_ADDRESS)
 
-unsigned long kernel_entry_address(void);
+unsigned long kernel_entry_address(unsigned long kernel_addr);
 
 #endif /* _ASM_LOONGARCH_EFI_H */
diff --git a/drivers/firmware/efi/libstub/loongarch-stub.c b/drivers/firmware/efi/libstub/loongarch-stub.c
index 72c71ae201f0..d6ec5d4b8dbe 100644
--- a/drivers/firmware/efi/libstub/loongarch-stub.c
+++ b/drivers/firmware/efi/libstub/loongarch-stub.c
@@ -35,9 +35,9 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	return status;
 }
 
-unsigned long kernel_entry_address(void)
+unsigned long kernel_entry_address(unsigned long kernel_addr)
 {
 	unsigned long base = (unsigned long)&kernel_offset - kernel_offset;
 
-	return (unsigned long)&kernel_entry - base + VMLINUX_LOAD_ADDRESS;
+	return (unsigned long)&kernel_entry - base + kernel_addr;
 }
diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmware/efi/libstub/loongarch.c
index 807cba2693fc..0e0aa6cda73f 100644
--- a/drivers/firmware/efi/libstub/loongarch.c
+++ b/drivers/firmware/efi/libstub/loongarch.c
@@ -37,9 +37,9 @@ static efi_status_t exit_boot_func(struct efi_boot_memmap *map, void *priv)
 	return EFI_SUCCESS;
 }
 
-unsigned long __weak kernel_entry_address(void)
+unsigned long __weak kernel_entry_address(unsigned long kernel_addr)
 {
-	return *(unsigned long *)(PHYSADDR(VMLINUX_LOAD_ADDRESS) + 8);
+	return *(unsigned long *)(kernel_addr + 8) - VMLINUX_LOAD_ADDRESS + kernel_addr;
 }
 
 efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
@@ -73,7 +73,7 @@ efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
 	csr_write64(CSR_DMW0_INIT, LOONGARCH_CSR_DMWIN0);
 	csr_write64(CSR_DMW1_INIT, LOONGARCH_CSR_DMWIN1);
 
-	real_kernel_entry = (void *)kernel_entry_address();
+	real_kernel_entry = (void *)kernel_entry_address(kernel_addr);
 
 	real_kernel_entry(true, (unsigned long)cmdline_ptr,
 			  (unsigned long)efi_system_table);
-- 
2.43.0



