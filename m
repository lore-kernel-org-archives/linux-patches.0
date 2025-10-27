Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43A22D5A14;
	Mon, 27 Oct 2025 19:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592696; cv=none; b=dRbq39feY9gF/i9MPyWVsJGgisdRwUmTL5rKdm0kZ62AL6sqzfvijSXNayPKQYWbAC/Cqv8svAT/IOBYrnyvP9rOIW2iqWXqBOpQXgcj04qVu9bG+QDALi0EiDWtPr9HbPs19C4Y9WKETjSfFSPJ82oozi6MiyDcLP5rFthmtCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592696; c=relaxed/simple;
	bh=9O7qHmvV2bRIFwwAdku3QP+JQ6CQOy7+daJgLucuRpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r83IcspnqulgfX4y88EnuSP9e7QOIYgXK119Da2cxj272fIkgRotHcJFgLkVL7D31anllK4oSDWZTqEIlpBkJOYWWsx/OCdWz3sO8bDbQPDAp1gpXW6eQwIi8Ko50ZgQO82Auez9ocD5CfBxokq8in5hBiQjPmS3l6ST/Piyzas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyNkgsXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyNkgsXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E29C4CEF1;
	Mon, 27 Oct 2025 19:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592696;
	bh=9O7qHmvV2bRIFwwAdku3QP+JQ6CQOy7+daJgLucuRpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyNkgsXpx0sfr9hFAmpLkaoDNmuLksbOYJ7pJx9XZWzmZxWfFDgIw8y2Qw+8MQxP5
	 r+G14gRYXmAlainy4h3gWk6WK0iCh2jlMpi8Cdy+nTzZMQKUweH4r9YfPxxir8pWtr
	 6x3XZfnS0AXPi9gp6eckoMvaxqNwVYweZA+H/y4Y=
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
Subject: [PATCH 6.6 32/84] dma-debug: dont report false positives with DMA_BOUNCE_UNALIGNED_KMALLOC
Date: Mon, 27 Oct 2025 19:36:21 +0100
Message-ID: <20251027183439.676910418@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -601,7 +602,9 @@ static void add_dma_entry(struct dma_deb
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


