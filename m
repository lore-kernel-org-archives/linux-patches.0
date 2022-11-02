Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A909629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B7FC433D7;
	Wed,  2 Nov 2022 02:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357455;
	bh=nQmNK7cIDwdp+8LRM131tJovgao5hJz6DQCbmVSzgTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfYbHvrec0VNqRDxZgGvesu19lOBILVujnO4r89JL6pp0u0v7sMWUAHnSGgxvNwpv
	 Ah0zBNpeaJ/V8C0U7lAZhVwkyfvKsn/bZ/72fzIj+I4azN6XHc6MUJL3iZMg2jy0yb
	 m2XlQMXDJTDOTBq4rYwmcb9UKY4StAl8KLYrRdjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 172/240] RISC-V: Fix compilation without RISCV_ISA_ZICBOM
Date: Wed,  2 Nov 2022 03:32:27 +0100
Message-Id: <20221102022115.276745986@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrew Jones <ajones@ventanamicro.com>

[ Upstream commit 5c20a3a9df19811051441214e7f5091cb3546db0 ]

riscv_cbom_block_size and riscv_init_cbom_blocksize() should always
be available and riscv_init_cbom_blocksize() should always be
invoked, even when compiling without RISCV_ISA_ZICBOM enabled. This
is because disabling RISCV_ISA_ZICBOM means "don't use zicbom
instructions in the kernel" not "pretend there isn't zicbom, even
when there is". When zicbom is available, whether the kernel enables
its use with RISCV_ISA_ZICBOM or not, KVM will offer it to guests.
Ensure we can build KVM and that the block size is initialized even
when compiling without RISCV_ISA_ZICBOM.

Fixes: 8f7e001e0325 ("RISC-V: Clean up the Zicbom block size probing")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/cacheflush.h |  8 ------
 arch/riscv/mm/cacheflush.c          | 38 ++++++++++++++++++++++++++
 arch/riscv/mm/dma-noncoherent.c     | 41 -----------------------------
 3 files changed, 38 insertions(+), 49 deletions(-)

diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
index 273ece6b622f..1470e556cdb1 100644
--- a/arch/riscv/include/asm/cacheflush.h
+++ b/arch/riscv/include/asm/cacheflush.h
@@ -42,16 +42,8 @@ void flush_icache_mm(struct mm_struct *mm, bool local);
 
 #endif /* CONFIG_SMP */
 
-/*
- * The T-Head CMO errata internally probe the CBOM block size, but otherwise
- * don't depend on Zicbom.
- */
 extern unsigned int riscv_cbom_block_size;
-#ifdef CONFIG_RISCV_ISA_ZICBOM
 void riscv_init_cbom_blocksize(void);
-#else
-static inline void riscv_init_cbom_blocksize(void) { }
-#endif
 
 #ifdef CONFIG_RISCV_DMA_NONCOHERENT
 void riscv_noncoherent_supported(void);
diff --git a/arch/riscv/mm/cacheflush.c b/arch/riscv/mm/cacheflush.c
index 6cb7d96ad9c7..57b40a350420 100644
--- a/arch/riscv/mm/cacheflush.c
+++ b/arch/riscv/mm/cacheflush.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2017 SiFive
  */
 
+#include <linux/of.h>
 #include <asm/cacheflush.h>
 
 #ifdef CONFIG_SMP
@@ -86,3 +87,40 @@ void flush_icache_pte(pte_t pte)
 		flush_icache_all();
 }
 #endif /* CONFIG_MMU */
+
+unsigned int riscv_cbom_block_size;
+EXPORT_SYMBOL_GPL(riscv_cbom_block_size);
+
+void riscv_init_cbom_blocksize(void)
+{
+	struct device_node *node;
+	unsigned long cbom_hartid;
+	u32 val, probed_block_size;
+	int ret;
+
+	probed_block_size = 0;
+	for_each_of_cpu_node(node) {
+		unsigned long hartid;
+
+		ret = riscv_of_processor_hartid(node, &hartid);
+		if (ret)
+			continue;
+
+		/* set block-size for cbom extension if available */
+		ret = of_property_read_u32(node, "riscv,cbom-block-size", &val);
+		if (ret)
+			continue;
+
+		if (!probed_block_size) {
+			probed_block_size = val;
+			cbom_hartid = hartid;
+		} else {
+			if (probed_block_size != val)
+				pr_warn("cbom-block-size mismatched between harts %lu and %lu\n",
+					cbom_hartid, hartid);
+		}
+	}
+
+	if (probed_block_size)
+		riscv_cbom_block_size = probed_block_size;
+}
diff --git a/arch/riscv/mm/dma-noncoherent.c b/arch/riscv/mm/dma-noncoherent.c
index b0add983530a..d919efab6eba 100644
--- a/arch/riscv/mm/dma-noncoherent.c
+++ b/arch/riscv/mm/dma-noncoherent.c
@@ -8,13 +8,8 @@
 #include <linux/dma-direct.h>
 #include <linux/dma-map-ops.h>
 #include <linux/mm.h>
-#include <linux/of.h>
-#include <linux/of_device.h>
 #include <asm/cacheflush.h>
 
-unsigned int riscv_cbom_block_size;
-EXPORT_SYMBOL_GPL(riscv_cbom_block_size);
-
 static bool noncoherent_supported;
 
 void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
@@ -77,42 +72,6 @@ void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
 	dev->dma_coherent = coherent;
 }
 
-#ifdef CONFIG_RISCV_ISA_ZICBOM
-void riscv_init_cbom_blocksize(void)
-{
-	struct device_node *node;
-	unsigned long cbom_hartid;
-	u32 val, probed_block_size;
-	int ret;
-
-	probed_block_size = 0;
-	for_each_of_cpu_node(node) {
-		unsigned long hartid;
-
-		ret = riscv_of_processor_hartid(node, &hartid);
-		if (ret)
-			continue;
-
-		/* set block-size for cbom extension if available */
-		ret = of_property_read_u32(node, "riscv,cbom-block-size", &val);
-		if (ret)
-			continue;
-
-		if (!probed_block_size) {
-			probed_block_size = val;
-			cbom_hartid = hartid;
-		} else {
-			if (probed_block_size != val)
-				pr_warn("cbom-block-size mismatched between harts %lu and %lu\n",
-					cbom_hartid, hartid);
-		}
-	}
-
-	if (probed_block_size)
-		riscv_cbom_block_size = probed_block_size;
-}
-#endif
-
 void riscv_noncoherent_supported(void)
 {
 	WARN(!riscv_cbom_block_size,
-- 
2.35.1



