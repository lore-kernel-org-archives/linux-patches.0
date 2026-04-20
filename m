Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C75F2FE56A;
	Mon, 20 Apr 2026 15:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700731; cv=none; b=qb7lF6vCxTGW7CFc6QZYJjSXDM9zxfCeMh3cDeCPFQBTbcD61XuW+RdfhKHrM6rLiJZvafZzvyy1xEPvR0XZr2pOQyr94jeshimmL+JSinO4VmR9mSoylbMZjt64I9KFJ/8AXiaR3U0XzTlETRcGE8gHqb9G0IFukTc+js/dRbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700731; c=relaxed/simple;
	bh=YlHJMY4eQQhW08Qj9i2gSgbXQDuHARQ3e3sNR7DFXm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxqLK4Gm8ecdwt60p3uqEfXKQ7iyrhBlWdwd5pMbBFnNpHZhWg+j9KAoK/ejkaJqaVl77MGEbGsnH+sjD6TuRd4HpQxToW5tdQ8ekAR2veLSsZVnCcFp8ThlLNH6S5+olRCppSFFDf75KjfTj17iSlLlkR72XdQs/bu/7K/4mjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0H7dP0F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0H7dP0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDAEC19425;
	Mon, 20 Apr 2026 15:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700731;
	bh=YlHJMY4eQQhW08Qj9i2gSgbXQDuHARQ3e3sNR7DFXm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0H7dP0FjZowPevNP1bmVuSrUsYM+rXRhNJTuayOaHCqfbUEh2+5rwBTRRheW9Tqb
	 37PCTGsWfCp612i7ZF9h36Y9f51Dsflqc3GOQX0PQc8WOXFb7tOQ2/lcHHtLc1EH8b
	 /OuS2x0kZmzyo7bSX4SFZXroGHX/9aSXfoguqNU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Yoo <harry@kernel.org>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 064/198] dma-debug: suppress cacheline overlap warning when arch has no DMA alignment requirement
Date: Mon, 20 Apr 2026 17:40:43 +0200
Message-ID: <20260420153937.918177142@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

[ Upstream commit 3d48c9fd78dd0b1809669ec49c4d0997b8127512 ]

When CONFIG_DMA_API_DEBUG is enabled, the DMA debug infrastructure
tracks active mappings per cacheline and warns if two different DMA
mappings share the same cacheline ("cacheline tracking EEXIST,
overlapping mappings aren't supported").

On x86_64, ARCH_KMALLOC_MINALIGN defaults to 8, so small kmalloc
allocations (e.g. the 8-byte hub->buffer and hub->status in the USB
hub driver) frequently land in the same 64-byte cacheline.  When both
are DMA-mapped, this triggers a false positive warning.

This has been reported repeatedly since v5.14 (when the EEXIST check
was added) across various USB host controllers and devices including
xhci_hcd with USB hubs, USB audio devices, and USB ethernet adapters.

The cacheline overlap is only a real concern on architectures that
require DMA buffer alignment to cacheline boundaries (i.e. where
ARCH_DMA_MINALIGN >= L1_CACHE_BYTES).  On architectures like x86_64
where dma_get_cache_alignment() returns 1, the hardware is
cache-coherent and overlapping cacheline mappings are harmless.

Suppress the EEXIST warning when dma_get_cache_alignment() is less
than L1_CACHE_BYTES, indicating the architecture does not require
cacheline-aligned DMA buffers.

Verified with a kernel module reproducer that performs two kmalloc(8)
allocations back-to-back and DMA-maps both:

  Before: allocations share a cacheline, EEXIST fires within ~50 pairs
  After:  same cacheline pair found, but no warning emitted

Fixes: 2b4bbc6231d7 ("dma-debug: report -EEXIST errors in add_dma_entry")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215740
Suggested-by: Harry Yoo <harry@kernel.org>
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20260327124156.24820-1-mikhail.v.gavrilov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 43d6a996d7a78..596ea7abbda15 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -614,6 +614,7 @@ static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
 	} else if (rc == -EEXIST &&
 		   !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
 		   !(entry->is_cache_clean && overlap_cache_clean) &&
+		   dma_get_cache_alignment() >= L1_CACHE_BYTES &&
 		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
 		     is_swiotlb_active(entry->dev))) {
 		err_printk(entry->dev, entry,
-- 
2.53.0



