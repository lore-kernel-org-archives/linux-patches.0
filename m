Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283FC202963;
	Mon, 27 Oct 2025 19:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593239; cv=none; b=UnFf5zZn7FvEC8swGLCoBYBjdRuok6u2CkZWchm9XULaehKwS8R070j1QRwx/zoLz73kY/t9gvbdELXO8m7NwyD0FHjlrC2RdBxl7SdSxxOy5DdOtoi8BmxEhuF4bFjUkb90Leu+M5Ir8qZBy/7MIN1p92y1n+S8pWTDxa8skhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593239; c=relaxed/simple;
	bh=Q7ZYnV4XwCsD1ZYTUHyyYkVboR579iof9wzHNOIPNnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLOktADhB3WdqwrZzeEdDg8XLP9v6stLAWlGW29ZqegWJjaCDoTp3m2UWzll98DZO+LxEcz9fBMDXIC1BVGCajTN0Y+M/M1ieTT8wD4DsXXeSa6+ZVxMZ0JICqO1S/Id47HMDaU8D/QVjjcEsnYF/zY94M1YWSLObMfzPEuBu/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJUQzknP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJUQzknP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF137C4CEF1;
	Mon, 27 Oct 2025 19:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593239;
	bh=Q7ZYnV4XwCsD1ZYTUHyyYkVboR579iof9wzHNOIPNnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJUQzknPp9DF2lJel+o3264XopAaNqU5vROIVp0bMJs3Thgw1lIEWaq5Cr+OM8yZ2
	 GjxoUA3nQpnSyIwFR52nReDeowuKA7AjZwp1OIn4XiShZJpoeDGYh/wyGhwfam2GaV
	 cLYGBR2UrfjYyaofqxY1UYYtPGPdtfFg5+GmaFUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christoph Hellwig <hch@lst.de>,
	Robin Murohy <robin.murphy@arm.com>,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 065/184] dma-debug: dont report false positives with DMA_BOUNCE_UNALIGNED_KMALLOC
Date: Mon, 27 Oct 2025 19:35:47 +0100
Message-ID: <20251027183516.642365477@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 03521c892bb8d0712c23e158ae9bdf8705897df8 upstream.

Commit 370645f41e6e ("dma-mapping: force bouncing if the kmalloc() size is
not cache-line-aligned") introduced DMA_BOUNCE_UNALIGNED_KMALLOC feature
and permitted architecture specific code configure kmalloc slabs with
sizes smaller than the value of dma_get_cache_alignment().

When that feature is enabled, the physical address of some small
kmalloc()-ed buffers might be not aligned to the CPU cachelines, thus not
really suitable for typical DMA.  To properly handle that case a SWIOTLB
buffer bouncing is used, so no CPU cache corruption occurs.  When that
happens, there is no point reporting a false-positive DMA-API warning that
the buffer is not properly aligned, as this is not a client driver fault.

[m.szyprowski@samsung.com: replace is_swiotlb_allocated() with is_swiotlb_active(), per Catalin]
  Link: https://lkml.kernel.org/r/20251010173009.3916215-1-m.szyprowski@samsung.com
Link: https://lkml.kernel.org/r/20251009141508.2342138-1-m.szyprowski@samsung.com
Fixes: 370645f41e6e ("dma-mapping: force bouncing if the kmalloc() size is not cache-line-aligned")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Inki Dae <m.szyprowski@samsung.com>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/debug.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -23,6 +23,7 @@
 #include <linux/ctype.h>
 #include <linux/list.h>
 #include <linux/slab.h>
+#include <linux/swiotlb.h>
 #include <asm/sections.h>
 #include "debug.h"
 
@@ -594,7 +595,9 @@ static void add_dma_entry(struct dma_deb
 	if (rc == -ENOMEM) {
 		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
 		global_disable = true;
-	} else if (rc == -EEXIST && !(attrs & DMA_ATTR_SKIP_CPU_SYNC)) {
+	} else if (rc == -EEXIST && !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
+		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
+		     is_swiotlb_active(entry->dev))) {
 		err_printk(entry->dev, entry,
 			"cacheline tracking EEXIST, overlapping mappings aren't supported\n");
 	}


