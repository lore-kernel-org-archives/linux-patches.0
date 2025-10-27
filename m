Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A192C3749;
	Mon, 27 Oct 2025 19:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592876; cv=none; b=jINjGIeO/OU2eEm/te3o0A9g5mQTrGRhXuyp2MARMh8FrGZnX77+9Hds/nu25nozPYBZf8yqj/2Utzip8Qb/TCkpMpeZDbxcPxQmjfe2tiA1A0vbW6UuPQ6jdgiNr+z594FgZoblDHJqoMjcSKmJMIO9ncdtSlaP3/RMaJFRZ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592876; c=relaxed/simple;
	bh=G8x41RGDCDVWa/xVIHRESfasGhLrEmR0noEZe1ob0eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnfYzI9XloNyM5ElofEa7noJjCuS8IpRNOzLIGTPyO/d//t3/p1Xu560KkRGoLNNXT3rsgQe3RQViQNFT09TVBJj5+67Vp4B4/+djNEOEZZSTYAVxZhHysoknbAfQKhn5WbfIrRe5U0EyBjAJzqo7rXsQLCx5cMfnYMRR1tbLGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MiRAOU1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MiRAOU1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27015C4CEF1;
	Mon, 27 Oct 2025 19:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592875;
	bh=G8x41RGDCDVWa/xVIHRESfasGhLrEmR0noEZe1ob0eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MiRAOU1bjFXZVZ/nUNkqF2f0KL9ojb0VlJGqu9gMkcQfGQ7NqqaZhsGrGqFL/JGx9
	 eG12r8X0TakutQ+zVG4YddX0N9QMRtJkhwPBK4mH8x8BWVKdGZqHvCwdH0G7sgMLq4
	 0fHyMki8KjfkduCsjLSP/z8QZkAYgZ9UBFYSCBlI=
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
Subject: [PATCH 6.12 046/117] dma-debug: dont report false positives with DMA_BOUNCE_UNALIGNED_KMALLOC
Date: Mon, 27 Oct 2025 19:36:12 +0100
Message-ID: <20251027183455.237668376@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


