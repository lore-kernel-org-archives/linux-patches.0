Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7FE39FF7;
	Fri, 24 Nov 2023 18:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aAH3NGuq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B82C433C8;
	Fri, 24 Nov 2023 18:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849421;
	bh=Him7LNA3/3ib5EY7TvAFUzgFuyLfW5PJyZuWYPCl8qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aAH3NGuq3MHQF4xOdGX5GlTjy5pIOQY5/4tMnvrRtEe2mm9tXDIuTD4sC2DON/QRB
	 lxWYH0EUQM+AnwZ16fpluiE8uKwGkXwvA1L8Mc4WVcsgUVO5hibzqiMmpUh6fE9ctF
	 0B0eQyzlk8UNCTVrHebtx9dnRushWhmtGVZYN9n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Conor Dooley <conor.dooley@microchip.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/530] riscv: split cache ops out of dma-noncoherent.c
Date: Fri, 24 Nov 2023 17:45:41 +0000
Message-ID: <20231124172033.401804603@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 946bb33d330251966223f770f64885c79448b1a1 ]

The cache ops are also used by the pmem code which is unconditionally
built into the kernel.  Move them into a separate file that is built
based on the correct config option.

Fixes: fd962781270e ("riscv: RISCV_NONSTANDARD_CACHE_OPS shouldn't depend on RISCV_DMA_NONCOHERENT")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com> #
Link: https://lore.kernel.org/r/20231028155101.1039049-1-hch@lst.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/Makefile          |  1 +
 arch/riscv/mm/cache-ops.c       | 17 +++++++++++++++++
 arch/riscv/mm/dma-noncoherent.c | 15 ---------------
 3 files changed, 18 insertions(+), 15 deletions(-)
 create mode 100644 arch/riscv/mm/cache-ops.c

diff --git a/arch/riscv/mm/Makefile b/arch/riscv/mm/Makefile
index 9c454f90fd3da..3a4dfc8babcf8 100644
--- a/arch/riscv/mm/Makefile
+++ b/arch/riscv/mm/Makefile
@@ -36,3 +36,4 @@ endif
 
 obj-$(CONFIG_DEBUG_VIRTUAL) += physaddr.o
 obj-$(CONFIG_RISCV_DMA_NONCOHERENT) += dma-noncoherent.o
+obj-$(CONFIG_RISCV_NONSTANDARD_CACHE_OPS) += cache-ops.o
diff --git a/arch/riscv/mm/cache-ops.c b/arch/riscv/mm/cache-ops.c
new file mode 100644
index 0000000000000..a993ad11d0eca
--- /dev/null
+++ b/arch/riscv/mm/cache-ops.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021 Western Digital Corporation or its affiliates.
+ */
+
+#include <asm/dma-noncoherent.h>
+
+struct riscv_nonstd_cache_ops noncoherent_cache_ops __ro_after_init;
+
+void
+riscv_noncoherent_register_cache_ops(const struct riscv_nonstd_cache_ops *ops)
+{
+	if (!ops)
+		return;
+	noncoherent_cache_ops = *ops;
+}
+EXPORT_SYMBOL_GPL(riscv_noncoherent_register_cache_ops);
diff --git a/arch/riscv/mm/dma-noncoherent.c b/arch/riscv/mm/dma-noncoherent.c
index b76e7e192eb18..341bd6706b4c5 100644
--- a/arch/riscv/mm/dma-noncoherent.c
+++ b/arch/riscv/mm/dma-noncoherent.c
@@ -15,12 +15,6 @@ static bool noncoherent_supported __ro_after_init;
 int dma_cache_alignment __ro_after_init = ARCH_DMA_MINALIGN;
 EXPORT_SYMBOL_GPL(dma_cache_alignment);
 
-struct riscv_nonstd_cache_ops noncoherent_cache_ops __ro_after_init = {
-	.wback = NULL,
-	.inv = NULL,
-	.wback_inv = NULL,
-};
-
 static inline void arch_dma_cache_wback(phys_addr_t paddr, size_t size)
 {
 	void *vaddr = phys_to_virt(paddr);
@@ -162,12 +156,3 @@ void __init riscv_set_dma_cache_alignment(void)
 	if (!noncoherent_supported)
 		dma_cache_alignment = 1;
 }
-
-void riscv_noncoherent_register_cache_ops(const struct riscv_nonstd_cache_ops *ops)
-{
-	if (!ops)
-		return;
-
-	noncoherent_cache_ops = *ops;
-}
-EXPORT_SYMBOL_GPL(riscv_noncoherent_register_cache_ops);
-- 
2.42.0



