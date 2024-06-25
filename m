Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3D0149E03;
	Tue, 25 Jun 2024 09:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309398; cv=none; b=baZjXRo9+JBD4eFp3vZa1zcfWmLa04vc+HODf637HIA425VjnGRjC8EQhTOtvgFbjWbkR8WrOOiGD/2NgHZgc/vYbexYVJXDvnxhqljN+2Fg5bbhhIWJJaj4t0sQadiSzjBM2+YpXJgHdF0lwx9T5enOglaBnSzeWUu8DHBKfp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309398; c=relaxed/simple;
	bh=2ICTAEuok54FruFRfPNNVeur2VJuo36c5NmQcjXzaww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvweDPrm+OzjfdgPu4+DhoYOX/O1Cbn0rpWUXuQCP2nBdISsZbMIxnho1R+B1dxu9xS/tq+iwmff9ljQPwimEBEOaWLm/iEl2Y2RM68UbFWdNm3CdAMcpSbMXDm/ds8WpcCjnTVCK2NIt5BCI5SKmkO/z+806BfyvuphljZ9U5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ow5kcd5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ow5kcd5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F43C32781;
	Tue, 25 Jun 2024 09:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309397;
	bh=2ICTAEuok54FruFRfPNNVeur2VJuo36c5NmQcjXzaww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ow5kcd5BxkLI7rHWitCf1fZRiTEoHhGKGHx4lAp6QOyWMlDhV2hE7EC0QmASVCijR
	 NY58Y+GasM18fRLTVdtGAU1zImK+uXUe9gYWAw3Acv9FOm2z066atQvyH9FcBaFgZr
	 ez1JYRucKp7N1fd6whGgqB9wxq16ytHqZvwue/jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yao <wangyao@lemote.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/192] efi/loongarch: Directly position the loaded image file
Date: Tue, 25 Jun 2024 11:34:17 +0200
Message-ID: <20240625085544.261673383@linuxfoundation.org>
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

From: Wang Yao <wangyao@lemote.com>

[ Upstream commit 174a0c565cea74a7811ff79fbee1b70247570ade ]

The use of the 'kernel_offset' variable to position the image file that
has been loaded by UEFI or GRUB is unnecessary, because we can directly
position the loaded image file through using the image_base field of the
efi_loaded_image struct provided by UEFI.

Replace kernel_offset with image_base to position the image file that has
been loaded by UEFI or GRUB.

Signed-off-by: Wang Yao <wangyao@lemote.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Stable-dep-of: beb2800074c1 ("LoongArch: Fix entry point in kernel image header")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/efi.h              | 2 --
 arch/loongarch/kernel/head.S                  | 1 -
 arch/loongarch/kernel/image-vars.h            | 1 -
 arch/loongarch/kernel/vmlinux.lds.S           | 1 -
 drivers/firmware/efi/libstub/loongarch-stub.c | 9 +++++----
 drivers/firmware/efi/libstub/loongarch-stub.h | 4 ++++
 drivers/firmware/efi/libstub/loongarch.c      | 6 ++++--
 7 files changed, 13 insertions(+), 11 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/loongarch-stub.h

diff --git a/arch/loongarch/include/asm/efi.h b/arch/loongarch/include/asm/efi.h
index 91d81f9730ab3..eddc8e79b3fae 100644
--- a/arch/loongarch/include/asm/efi.h
+++ b/arch/loongarch/include/asm/efi.h
@@ -32,6 +32,4 @@ static inline unsigned long efi_get_kimg_min_align(void)
 
 #define EFI_KIMG_PREFERRED_ADDRESS	PHYSADDR(VMLINUX_LOAD_ADDRESS)
 
-unsigned long kernel_entry_address(unsigned long kernel_addr);
-
 #endif /* _ASM_LOONGARCH_EFI_H */
diff --git a/arch/loongarch/kernel/head.S b/arch/loongarch/kernel/head.S
index 53b883db07862..0ecab42163928 100644
--- a/arch/loongarch/kernel/head.S
+++ b/arch/loongarch/kernel/head.S
@@ -34,7 +34,6 @@ pe_header:
 
 SYM_DATA(kernel_asize, .long _kernel_asize);
 SYM_DATA(kernel_fsize, .long _kernel_fsize);
-SYM_DATA(kernel_offset, .long _kernel_offset);
 
 #endif
 
diff --git a/arch/loongarch/kernel/image-vars.h b/arch/loongarch/kernel/image-vars.h
index 5087416b9678d..41ddcf56d21c7 100644
--- a/arch/loongarch/kernel/image-vars.h
+++ b/arch/loongarch/kernel/image-vars.h
@@ -11,7 +11,6 @@ __efistub_strcmp		= strcmp;
 __efistub_kernel_entry		= kernel_entry;
 __efistub_kernel_asize		= kernel_asize;
 __efistub_kernel_fsize		= kernel_fsize;
-__efistub_kernel_offset		= kernel_offset;
 #if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
 __efistub_screen_info		= screen_info;
 #endif
diff --git a/arch/loongarch/kernel/vmlinux.lds.S b/arch/loongarch/kernel/vmlinux.lds.S
index bb2ec86f37a8e..a5d0cd2035da0 100644
--- a/arch/loongarch/kernel/vmlinux.lds.S
+++ b/arch/loongarch/kernel/vmlinux.lds.S
@@ -143,7 +143,6 @@ SECTIONS
 	_kernel_fsize = _edata - _text;
 	_kernel_vsize = _end - __initdata_begin;
 	_kernel_rsize = _edata - __initdata_begin;
-	_kernel_offset = kernel_offset - _text;
 #endif
 
 	.gptab.sdata : {
diff --git a/drivers/firmware/efi/libstub/loongarch-stub.c b/drivers/firmware/efi/libstub/loongarch-stub.c
index d6ec5d4b8dbe0..736b6aae323d3 100644
--- a/drivers/firmware/efi/libstub/loongarch-stub.c
+++ b/drivers/firmware/efi/libstub/loongarch-stub.c
@@ -8,10 +8,10 @@
 #include <asm/efi.h>
 #include <asm/addrspace.h>
 #include "efistub.h"
+#include "loongarch-stub.h"
 
 extern int kernel_asize;
 extern int kernel_fsize;
-extern int kernel_offset;
 extern int kernel_entry;
 
 efi_status_t handle_kernel_image(unsigned long *image_addr,
@@ -24,7 +24,7 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	efi_status_t status;
 	unsigned long kernel_addr = 0;
 
-	kernel_addr = (unsigned long)&kernel_offset - kernel_offset;
+	kernel_addr = (unsigned long)image->image_base;
 
 	status = efi_relocate_kernel(&kernel_addr, kernel_fsize, kernel_asize,
 		     EFI_KIMG_PREFERRED_ADDRESS, efi_get_kimg_min_align(), 0x0);
@@ -35,9 +35,10 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	return status;
 }
 
-unsigned long kernel_entry_address(unsigned long kernel_addr)
+unsigned long kernel_entry_address(unsigned long kernel_addr,
+		efi_loaded_image_t *image)
 {
-	unsigned long base = (unsigned long)&kernel_offset - kernel_offset;
+	unsigned long base = (unsigned long)image->image_base;
 
 	return (unsigned long)&kernel_entry - base + kernel_addr;
 }
diff --git a/drivers/firmware/efi/libstub/loongarch-stub.h b/drivers/firmware/efi/libstub/loongarch-stub.h
new file mode 100644
index 0000000000000..cd015955a0152
--- /dev/null
+++ b/drivers/firmware/efi/libstub/loongarch-stub.h
@@ -0,0 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+unsigned long kernel_entry_address(unsigned long kernel_addr,
+		efi_loaded_image_t *image);
diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmware/efi/libstub/loongarch.c
index 0e0aa6cda73f7..684c9354637c6 100644
--- a/drivers/firmware/efi/libstub/loongarch.c
+++ b/drivers/firmware/efi/libstub/loongarch.c
@@ -8,6 +8,7 @@
 #include <asm/efi.h>
 #include <asm/addrspace.h>
 #include "efistub.h"
+#include "loongarch-stub.h"
 
 typedef void __noreturn (*kernel_entry_t)(bool efi, unsigned long cmdline,
 					  unsigned long systab);
@@ -37,7 +38,8 @@ static efi_status_t exit_boot_func(struct efi_boot_memmap *map, void *priv)
 	return EFI_SUCCESS;
 }
 
-unsigned long __weak kernel_entry_address(unsigned long kernel_addr)
+unsigned long __weak kernel_entry_address(unsigned long kernel_addr,
+		efi_loaded_image_t *image)
 {
 	return *(unsigned long *)(kernel_addr + 8) - VMLINUX_LOAD_ADDRESS + kernel_addr;
 }
@@ -73,7 +75,7 @@ efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
 	csr_write64(CSR_DMW0_INIT, LOONGARCH_CSR_DMWIN0);
 	csr_write64(CSR_DMW1_INIT, LOONGARCH_CSR_DMWIN1);
 
-	real_kernel_entry = (void *)kernel_entry_address(kernel_addr);
+	real_kernel_entry = (void *)kernel_entry_address(kernel_addr, image);
 
 	real_kernel_entry(true, (unsigned long)cmdline_ptr,
 			  (unsigned long)efi_system_table);
-- 
2.43.0



