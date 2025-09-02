Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D9E32A83F;
	Tue,  2 Sep 2025 13:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819871; cv=none; b=BwoJm4jfLv5zVImD5gqtu9heFgxpbRY0jvmKfzTBgNsIraINNNI8ekqMbfR6vrM7UnnUct2ZQ1vGXSzuwABwNcwM86rxOi1w0pOHNW+pB5JSPltF6hWrrkMJ52MZE9vTkV3Sj2Jj8qDD1C/4CzOI8cFnw362jTrtyCbzbuozKtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819871; c=relaxed/simple;
	bh=d3vL7Cn4V9w+CD8Od9QuEvzylgLDM+A8HL+7RJk+XaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZkN+UlWHtCKJ2eQggOY+3F/ZE6vRrUH74VbbD/33gyA+ln/TPXygxG5fCrx5CeoB52lMy8o00n37nBiBchKoF9TvFAD5N0wv+WFT8s7uPsiaElWeH5EZOJ3YbKmPbXbwfXLCF6XOr9V+DESujsVNBzLJjdqOOkhcaBv04X76GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IPJh8s6l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPJh8s6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374DFC4CEF4;
	Tue,  2 Sep 2025 13:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819870;
	bh=d3vL7Cn4V9w+CD8Od9QuEvzylgLDM+A8HL+7RJk+XaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IPJh8s6lfTMxWj5vU1hN02Taut59yl6BKzkUpKWeyFgpgRNIPxpLRG8gNqRWkCOjZ
	 0/Q7YAPgvTrN4qVjv/yDI/mfrAwf5c+wsqmPh3qUOlYZID1zI8P3rGRTpFMXRR8z4J
	 GYzxlLYnppXTBwvy1nZBv+C0wzcwxy1M7zGbibGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>,
	William Zhang <william.zhang@broadcom.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 21/95] of: reserved_mem: Restructure call site for dma_contiguous_early_fixup()
Date: Tue,  2 Sep 2025 15:19:57 +0200
Message-ID: <20250902131940.426408163@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>

[ Upstream commit 2c223f7239f376a90d71903ec474ba887cf21d94 ]

Restructure the call site for dma_contiguous_early_fixup() to
where the reserved_mem nodes are being parsed from the DT so that
dma_mmu_remap[] is populated before dma_contiguous_remap() is called.

Fixes: 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory regions are processed")
Signed-off-by: Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>
Tested-by: William Zhang <william.zhang@broadcom.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20250806172421.2748302-1-oreoluwa.babatunde@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/of_reserved_mem.c | 16 ++++++++++++----
 include/linux/dma-map-ops.h  |  3 +++
 kernel/dma/contiguous.c      |  2 --
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 45445a1600a96..7b5d6562fe4a0 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -24,6 +24,7 @@
 #include <linux/memblock.h>
 #include <linux/kmemleak.h>
 #include <linux/cma.h>
+#include <linux/dma-map-ops.h>
 
 #include "of_private.h"
 
@@ -128,13 +129,17 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 		base = dt_mem_next_cell(dt_root_addr_cells, &prop);
 		size = dt_mem_next_cell(dt_root_size_cells, &prop);
 
-		if (size &&
-		    early_init_dt_reserve_memory(base, size, nomap) == 0)
+		if (size && early_init_dt_reserve_memory(base, size, nomap) == 0) {
+			/* Architecture specific contiguous memory fixup. */
+			if (of_flat_dt_is_compatible(node, "shared-dma-pool") &&
+			    of_get_flat_dt_prop(node, "reusable", NULL))
+				dma_contiguous_early_fixup(base, size);
 			pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
 				uname, &base, (unsigned long)(size / SZ_1M));
-		else
+		} else {
 			pr_err("Reserved memory: failed to reserve memory for node '%s': base %pa, size %lu MiB\n",
 			       uname, &base, (unsigned long)(size / SZ_1M));
+		}
 
 		len -= t_len;
 	}
@@ -417,7 +422,10 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
 		       uname, (unsigned long)(size / SZ_1M));
 		return -ENOMEM;
 	}
-
+	/* Architecture specific contiguous memory fixup. */
+	if (of_flat_dt_is_compatible(node, "shared-dma-pool") &&
+	    of_get_flat_dt_prop(node, "reusable", NULL))
+		dma_contiguous_early_fixup(base, size);
 	/* Save region in the reserved_mem array */
 	fdt_reserved_mem_save_node(node, uname, base, size);
 	return 0;
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index b7773201414c2..b42408a24ad13 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -153,6 +153,9 @@ static inline void dma_free_contiguous(struct device *dev, struct page *page,
 {
 	__free_pages(page, get_order(size));
 }
+static inline void dma_contiguous_early_fixup(phys_addr_t base, unsigned long size)
+{
+}
 #endif /* CONFIG_DMA_CMA*/
 
 #ifdef CONFIG_DMA_DECLARE_COHERENT
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 8df0dfaaca18e..9e5d63efe7c57 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -480,8 +480,6 @@ static int __init rmem_cma_setup(struct reserved_mem *rmem)
 		pr_err("Reserved memory: unable to setup CMA region\n");
 		return err;
 	}
-	/* Architecture specific contiguous memory fixup. */
-	dma_contiguous_early_fixup(rmem->base, rmem->size);
 
 	if (default_cma)
 		dma_contiguous_default_area = cma;
-- 
2.50.1



