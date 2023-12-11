Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D97BE548;
	Mon, 11 Dec 2023 19:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkUkEOC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7310C433C8;
	Mon, 11 Dec 2023 19:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321205;
	bh=+g3Ye6y+PUYVlLKm8g2Lg/x1Y9iLGoXuT1IBP+g1qbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vkUkEOC3s5oiAuAywNix4Fb/FLp5OBNHq1UMyGgTBWcOP0tLFHwO5EDDWgSh3nus4
	 GvahllQMUVXzhuIBUQ+2OG7ZxHVJfCCDTibLDE+4wP3WGjgQawK/h5t/ezC1mgnaXk
	 9DE1dbtQx1mLv99ge0eoZhNyW/DNAzpJJNVkOYRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 136/141] MIPS: Loongson64: Enable DMA noncoherent support
Date: Mon, 11 Dec 2023 19:23:15 +0100
Message-ID: <20231211182032.502433104@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit edc0378eee00200a5bedf1bb9f00ad390e0d1bd4 upstream.

There are some Loongson64 systems come with broken coherent DMA
support, firmware will set a bit in boot_param and pass nocoherentio
in cmdline.

However nonconherent support was missed out when spin off Loongson-2EF
form Loongson64, and that boot_param change never made itself into
upstream.

Support DMA noncoherent properly to get those systems working.

Cc: stable@vger.kernel.org
Fixes: 71e2f4dd5a65 ("MIPS: Fork loongson2ef from loongson64")
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/Kconfig                                  |    2 ++
 arch/mips/include/asm/mach-loongson64/boot_param.h |    3 ++-
 arch/mips/loongson64/env.c                         |   10 +++++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -480,6 +480,7 @@ config MACH_LOONGSON2EF
 
 config MACH_LOONGSON64
 	bool "Loongson 64-bit family of machines"
+	select ARCH_DMA_DEFAULT_COHERENT
 	select ARCH_SPARSEMEM_ENABLE
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
@@ -1379,6 +1380,7 @@ config CPU_LOONGSON64
 	select CPU_SUPPORTS_MSA
 	select CPU_DIEI_BROKEN if !LOONGSON3_ENHANCEMENT
 	select CPU_MIPSR2_IRQ_VI
+	select DMA_NONCOHERENT
 	select WEAK_ORDERING
 	select WEAK_REORDERING_BEYOND_LLSC
 	select MIPS_ASID_BITS_VARIABLE
--- a/arch/mips/include/asm/mach-loongson64/boot_param.h
+++ b/arch/mips/include/asm/mach-loongson64/boot_param.h
@@ -117,7 +117,8 @@ struct irq_source_routing_table {
 	u64 pci_io_start_addr;
 	u64 pci_io_end_addr;
 	u64 pci_config_addr;
-	u32 dma_mask_bits;
+	u16 dma_mask_bits;
+	u16 dma_noncoherent;
 } __packed;
 
 struct interface_info {
--- a/arch/mips/loongson64/env.c
+++ b/arch/mips/loongson64/env.c
@@ -13,6 +13,8 @@
  * Copyright (C) 2009 Lemote Inc.
  * Author: Wu Zhangjin, wuzhangjin@gmail.com
  */
+
+#include <linux/dma-map-ops.h>
 #include <linux/export.h>
 #include <linux/pci_ids.h>
 #include <asm/bootinfo.h>
@@ -147,8 +149,14 @@ void __init prom_lefi_init_env(void)
 
 	loongson_sysconf.dma_mask_bits = eirq_source->dma_mask_bits;
 	if (loongson_sysconf.dma_mask_bits < 32 ||
-		loongson_sysconf.dma_mask_bits > 64)
+			loongson_sysconf.dma_mask_bits > 64) {
 		loongson_sysconf.dma_mask_bits = 32;
+		dma_default_coherent = true;
+	} else {
+		dma_default_coherent = !eirq_source->dma_noncoherent;
+	}
+
+	pr_info("Firmware: Coherent DMA: %s\n", dma_default_coherent ? "on" : "off");
 
 	loongson_sysconf.restart_addr = boot_p->reset_system.ResetWarm;
 	loongson_sysconf.poweroff_addr = boot_p->reset_system.Shutdown;


