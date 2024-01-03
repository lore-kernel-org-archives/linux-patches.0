Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B4B1BDFB;
	Wed,  3 Jan 2024 17:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTfwuLLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B9BC433C7;
	Wed,  3 Jan 2024 17:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301936;
	bh=yn4yzaWmK8EBPrnMbSwSn+wKmefQvKIQgA6ukIt5uns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTfwuLLpjIDVnDu1+30ZX1U9x5qAisqziMPG+9UaoOO3B1ARWofibe46JeRKP/v3X
	 nTHJXVoSegv73YDjQlPEt3xs30U4HY76AW2WvSASxW8HLf5AiB4dm0Ib0BpvP+VkNa
	 0zP2QPT8KKWJI1AEyyVd0kztPJwgGFReT0ySPw0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salvatore Bonaccorso <carnil@debian.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 73/75] Revert "MIPS: Loongson64: Enable DMA noncoherent support"
Date: Wed,  3 Jan 2024 17:55:54 +0100
Message-ID: <20240103164853.993425986@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>
References: <20240103164842.953224409@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 3ee7e2faef87594228eb2622f8c25c0495ea50a1 which is
commit edc0378eee00200a5bedf1bb9f00ad390e0d1bd4 upstream.

There are reports of this causing build issues, so revert it from the
5.10.y tree for now.

Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Link: https://lore.kernel.org/r/ZZE1X8m5PXJExffG@eldamar.lan
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/Kconfig                                  |    2 --
 arch/mips/include/asm/mach-loongson64/boot_param.h |    3 +--
 arch/mips/loongson64/env.c                         |   10 +---------
 3 files changed, 2 insertions(+), 13 deletions(-)

--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -468,7 +468,6 @@ config MACH_LOONGSON2EF
 
 config MACH_LOONGSON64
 	bool "Loongson 64-bit family of machines"
-	select ARCH_DMA_DEFAULT_COHERENT
 	select ARCH_SPARSEMEM_ENABLE
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
@@ -1380,7 +1379,6 @@ config CPU_LOONGSON64
 	select CPU_SUPPORTS_MSA
 	select CPU_DIEI_BROKEN if !LOONGSON3_ENHANCEMENT
 	select CPU_MIPSR2_IRQ_VI
-	select DMA_NONCOHERENT
 	select WEAK_ORDERING
 	select WEAK_REORDERING_BEYOND_LLSC
 	select MIPS_ASID_BITS_VARIABLE
--- a/arch/mips/include/asm/mach-loongson64/boot_param.h
+++ b/arch/mips/include/asm/mach-loongson64/boot_param.h
@@ -117,8 +117,7 @@ struct irq_source_routing_table {
 	u64 pci_io_start_addr;
 	u64 pci_io_end_addr;
 	u64 pci_config_addr;
-	u16 dma_mask_bits;
-	u16 dma_noncoherent;
+	u32 dma_mask_bits;
 } __packed;
 
 struct interface_info {
--- a/arch/mips/loongson64/env.c
+++ b/arch/mips/loongson64/env.c
@@ -13,8 +13,6 @@
  * Copyright (C) 2009 Lemote Inc.
  * Author: Wu Zhangjin, wuzhangjin@gmail.com
  */
-
-#include <linux/dma-map-ops.h>
 #include <linux/export.h>
 #include <linux/pci_ids.h>
 #include <asm/bootinfo.h>
@@ -133,14 +131,8 @@ void __init prom_init_env(void)
 	loongson_sysconf.pci_io_base = eirq_source->pci_io_start_addr;
 	loongson_sysconf.dma_mask_bits = eirq_source->dma_mask_bits;
 	if (loongson_sysconf.dma_mask_bits < 32 ||
-			loongson_sysconf.dma_mask_bits > 64) {
+		loongson_sysconf.dma_mask_bits > 64)
 		loongson_sysconf.dma_mask_bits = 32;
-		dma_default_coherent = true;
-	} else {
-		dma_default_coherent = !eirq_source->dma_noncoherent;
-	}
-
-	pr_info("Firmware: Coherent DMA: %s\n", dma_default_coherent ? "on" : "off");
 
 	loongson_sysconf.restart_addr = boot_p->reset_system.ResetWarm;
 	loongson_sysconf.poweroff_addr = boot_p->reset_system.Shutdown;


