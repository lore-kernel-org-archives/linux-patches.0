Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E38149C41;
	Tue, 25 Jun 2024 09:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309395; cv=none; b=VcnVwpRy6xOhUeKNwnwlDvyS4Z0iMNYbhWxN1baBIXN7gpSwe8caGmFthRbYXww4ZwXfDqWo0ueoejC4LhnYHaLLn+l/A71zWSpTgHCbwH8LsqhMnD3BoiSz7rn2Of/TYvoKtFAHAe3ryi27iAeW7MZeWvC+z7GGmm8iOG9ych4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309395; c=relaxed/simple;
	bh=AVfbllAF8fH+LM4uW6g6/cnC8pUjdUqxaEFSFqQXUhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbrTt3EDN8wGdj/NXspVECmCBMfCwcoaZNyyXdTiI0HqTEXFzGkjnJn13CkCt8lKc8/c8mSOdaolX8nLCd0AZ8AKXDDydgJaRjJ34IPc1sG8Iy7FN1Ymyv/jrxvi5jKY2ltMRfzxFVXmaGBYP41jeR3YQJhAwNjdjDsIGFe38MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1lSpLHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1lSpLHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7E7C32781;
	Tue, 25 Jun 2024 09:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309395;
	bh=AVfbllAF8fH+LM4uW6g6/cnC8pUjdUqxaEFSFqQXUhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1lSpLHLw6MWJ+rA7aJaQhaXiK5Hsz1yDkePc7BHXYm3ZGMrtuANh0zMFqNDYIpkD
	 +M8DBIU3N5338Lx3S3YENhdl/QhMJDp9qs32m/tBldXrxrPEPIS2V2KP4sloxViYY4
	 0JDmn2sjGYolgRzV/n60B6Axfc9RE6ObYwisLStI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/192] efi: move screen_info into efi init code
Date: Tue, 25 Jun 2024 11:34:16 +0200
Message-ID: <20240625085544.223430280@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b8466fe82b79215b9ae28623a87c9a937ebd4f80 ]

After the vga console no longer relies on global screen_info, there are
only two remaining use cases:

 - on the x86 architecture, it is used for multiple boot methods
   (bzImage, EFI, Xen, kexec) to commucate the initial VGA or framebuffer
   settings to a number of device drivers.

 - on other architectures, it is only used as part of the EFI stub,
   and only for the three sysfb framebuffers (simpledrm, simplefb, efifb).

Remove the duplicate data structure definitions by moving it into the
efi-init.c file that sets it up initially for the EFI case, leaving x86
as an exception that retains its own definition for non-EFI boots.

The added #ifdefs here are optional, I added them to further limit the
reach of screen_info to configurations that have at least one of the
users enabled.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Helge Deller <deller@gmx.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20231017093947.3627976-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: beb2800074c1 ("LoongArch: Fix entry point in kernel image header")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/efi.c                       |  4 ----
 arch/arm64/kernel/image-vars.h                |  2 ++
 arch/loongarch/kernel/efi.c                   |  8 +++++++-
 arch/loongarch/kernel/image-vars.h            |  2 ++
 arch/loongarch/kernel/setup.c                 |  5 -----
 arch/riscv/kernel/image-vars.h                |  2 ++
 arch/riscv/kernel/setup.c                     |  5 -----
 drivers/firmware/efi/efi-init.c               | 14 +++++++++++++-
 drivers/firmware/efi/libstub/efi-stub-entry.c |  8 +++++++-
 9 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 2b478ca356b00..52089f111c8db 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -71,10 +71,6 @@ static __init pteval_t create_mapping_protection(efi_memory_desc_t *md)
 	return pgprot_val(PAGE_KERNEL_EXEC);
 }
 
-/* we will fill this structure from the stub, so don't put it in .bss */
-struct screen_info screen_info __section(".data");
-EXPORT_SYMBOL(screen_info);
-
 int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 {
 	pteval_t prot_val = create_mapping_protection(md);
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 35f3c79595137..5e4dc72ab1bda 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -27,7 +27,9 @@ PROVIDE(__efistub__text			= _text);
 PROVIDE(__efistub__end			= _end);
 PROVIDE(__efistub___inittext_end       	= __inittext_end);
 PROVIDE(__efistub__edata		= _edata);
+#if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
 PROVIDE(__efistub_screen_info		= screen_info);
+#endif
 PROVIDE(__efistub__ctype		= _ctype);
 
 PROVIDE(__pi___memcpy			= __pi_memcpy);
diff --git a/arch/loongarch/kernel/efi.c b/arch/loongarch/kernel/efi.c
index 9fc10cea21e10..acb5d3385675c 100644
--- a/arch/loongarch/kernel/efi.c
+++ b/arch/loongarch/kernel/efi.c
@@ -68,6 +68,11 @@ void __init efi_runtime_init(void)
 
 unsigned long __initdata screen_info_table = EFI_INVALID_TABLE_ADDR;
 
+#if defined(CONFIG_SYSFB) || defined(CONFIG_EFI_EARLYCON)
+struct screen_info screen_info __section(".data");
+EXPORT_SYMBOL_GPL(screen_info);
+#endif
+
 static void __init init_screen_info(void)
 {
 	struct screen_info *si;
@@ -115,7 +120,8 @@ void __init efi_init(void)
 
 	set_bit(EFI_CONFIG_TABLES, &efi.flags);
 
-	init_screen_info();
+	if (IS_ENABLED(CONFIG_EFI_EARLYCON) || IS_ENABLED(CONFIG_SYSFB))
+		init_screen_info();
 
 	if (boot_memmap == EFI_INVALID_TABLE_ADDR)
 		return;
diff --git a/arch/loongarch/kernel/image-vars.h b/arch/loongarch/kernel/image-vars.h
index e561989d02de9..5087416b9678d 100644
--- a/arch/loongarch/kernel/image-vars.h
+++ b/arch/loongarch/kernel/image-vars.h
@@ -12,7 +12,9 @@ __efistub_kernel_entry		= kernel_entry;
 __efistub_kernel_asize		= kernel_asize;
 __efistub_kernel_fsize		= kernel_fsize;
 __efistub_kernel_offset		= kernel_offset;
+#if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
 __efistub_screen_info		= screen_info;
+#endif
 
 #endif
 
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 6748d7f3f2219..6464e1eac4cbd 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -16,7 +16,6 @@
 #include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/export.h>
-#include <linux/screen_info.h>
 #include <linux/memblock.h>
 #include <linux/initrd.h>
 #include <linux/ioport.h>
@@ -57,10 +56,6 @@
 #define SMBIOS_CORE_PACKAGE_OFFSET	0x23
 #define LOONGSON_EFI_ENABLE		(1 << 3)
 
-#ifdef CONFIG_EFI
-struct screen_info screen_info __section(".data");
-#endif
-
 unsigned long fw_arg0, fw_arg1, fw_arg2;
 DEFINE_PER_CPU(unsigned long, kernelsp);
 struct cpuinfo_loongarch cpu_data[NR_CPUS] __read_mostly;
diff --git a/arch/riscv/kernel/image-vars.h b/arch/riscv/kernel/image-vars.h
index ea1a10355ce90..3df30dd1c458b 100644
--- a/arch/riscv/kernel/image-vars.h
+++ b/arch/riscv/kernel/image-vars.h
@@ -28,7 +28,9 @@ __efistub__start_kernel		= _start_kernel;
 __efistub__end			= _end;
 __efistub__edata		= _edata;
 __efistub___init_text_end	= __init_text_end;
+#if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
 __efistub_screen_info		= screen_info;
+#endif
 
 #endif
 
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index ddadee6621f0d..1befd73a12505 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -15,7 +15,6 @@
 #include <linux/memblock.h>
 #include <linux/sched.h>
 #include <linux/console.h>
-#include <linux/screen_info.h>
 #include <linux/of_fdt.h>
 #include <linux/sched/task.h>
 #include <linux/smp.h>
@@ -40,10 +39,6 @@
 
 #include "head.h"
 
-#if defined(CONFIG_EFI)
-struct screen_info screen_info __section(".data");
-#endif
-
 /*
  * The lucky hart to first increment this variable will boot the other cores.
  * This is used before the kernel initializes the BSS so it can't be in the
diff --git a/drivers/firmware/efi/efi-init.c b/drivers/firmware/efi/efi-init.c
index 59b0d7197b685..a00e07b853f22 100644
--- a/drivers/firmware/efi/efi-init.c
+++ b/drivers/firmware/efi/efi-init.c
@@ -55,6 +55,15 @@ static phys_addr_t __init efi_to_phys(unsigned long addr)
 
 extern __weak const efi_config_table_type_t efi_arch_tables[];
 
+/*
+ * x86 defines its own screen_info and uses it even without EFI,
+ * everything else can get it from here.
+ */
+#if !defined(CONFIG_X86) && (defined(CONFIG_SYSFB) || defined(CONFIG_EFI_EARLYCON))
+struct screen_info screen_info __section(".data");
+EXPORT_SYMBOL_GPL(screen_info);
+#endif
+
 static void __init init_screen_info(void)
 {
 	struct screen_info *si;
@@ -241,5 +250,8 @@ void __init efi_init(void)
 	memblock_reserve(data.phys_map & PAGE_MASK,
 			 PAGE_ALIGN(data.size + (data.phys_map & ~PAGE_MASK)));
 
-	init_screen_info();
+	if (IS_ENABLED(CONFIG_X86) ||
+	    IS_ENABLED(CONFIG_SYSFB) ||
+	    IS_ENABLED(CONFIG_EFI_EARLYCON))
+		init_screen_info();
 }
diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
index 2f1902e5d4075..a6c0498351905 100644
--- a/drivers/firmware/efi/libstub/efi-stub-entry.c
+++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
@@ -13,7 +13,13 @@ struct screen_info *alloc_screen_info(void)
 {
 	if (IS_ENABLED(CONFIG_ARM))
 		return __alloc_screen_info();
-	return (void *)&screen_info + screen_info_offset;
+
+	if (IS_ENABLED(CONFIG_X86) ||
+	    IS_ENABLED(CONFIG_EFI_EARLYCON) ||
+	    IS_ENABLED(CONFIG_SYSFB))
+		return (void *)&screen_info + screen_info_offset;
+
+	return NULL;
 }
 
 /*
-- 
2.43.0



