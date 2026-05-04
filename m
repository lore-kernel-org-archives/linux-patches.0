Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0096C3DE440;
	Mon,  4 May 2026 13:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903113; cv=none; b=N0+YdMR69/9R1/aGU3UA6z37hYYhPwniSmpNPejhCGPtwQsKnk8pZRzXwL+DejktW9eXRuINj7yeBP7B9C8jt+zkpj0RUF3R1s0az+wQjK1iGBbrhXQkpFKCfmVN0w8ZeyS47WU3mIoomojD/Ua28RYfouNhfqrFbfsWE8Lx+No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903113; c=relaxed/simple;
	bh=/Ms+9hPSrdKmX1PaiR5erZV2qZo2YeD/ajxRVKOELU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/5SpHOK9GwiAge1GN4IywACPRBTgw5npqFjK8ZqDEoU0Yu/4DdIAGWAnCoarIAdxczYCo5mr98+W4u4KEuiPaViY7ft4pfTv2xpVQWMKQZj5rFWR8nDc6aDyUM/9CkZTSMN+fldyDo84qa1TwVDbtNWeC92WJFWqwwptqhQHHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=csMEcjWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="csMEcjWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B89EC2BCF7;
	Mon,  4 May 2026 13:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903112;
	bh=/Ms+9hPSrdKmX1PaiR5erZV2qZo2YeD/ajxRVKOELU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csMEcjWuE4lqz+ugn9hyoqnv5D5bA4hnS0dPr2PxOzeWFQU1EW8mvIgPvV62PmcBB
	 Hk+XqVSTwYdptItPJxrWx+YWnCCs9zTSPQKFwibT8r6dQFunxiRwxQ2oSZkdME6MxT
	 rhy32jvSpcJ4kzB6ymtd2p1rSS2RkRTOLGS1HgKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naman Jain <namjain@linux.microsoft.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.0 109/307] block: relax pgmap check in bio_add_page for compatible zone device pages
Date: Mon,  4 May 2026 15:49:54 +0200
Message-ID: <20260504135146.911862051@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naman Jain <namjain@linux.microsoft.com>

commit 41c665aae2b5dbecddddcc8ace344caf630cc7a4 upstream.

bio_add_page() and bio_integrity_add_page() reject pages from different
dev_pagemaps entirely, returning 0 even when those pages have compatible
DMA mapping requirements. This forces callers to start a new bio when
buffers span pgmap boundaries, even though the pages could safely coexist
as separate bvec entries.

This matters for guests where memory is registered through
devm_memremap_pages() with MEMORY_DEVICE_GENERIC in multiple calls,
creating separate dev_pagemaps for each chunk. When a direct I/O buffer
spans two such chunks, bio_add_page() rejects the second page, forcing an
unnecessary bio split or I/O failure.

Introduce zone_device_pages_compatible() in blk.h to check whether two
pages can coexist in the same bio as separate bvec entries. The block DMA
iterator (blk_dma_map_iter_start) caches the P2PDMA mapping state from the
first segment and applies it to all others, so P2PDMA pages from different
pgmaps must not be mixed, and neither must P2PDMA and non-P2PDMA pages.
All other combinations (MEMORY_DEVICE_GENERIC pages from different pgmaps,
or MEMORY_DEVICE_GENERIC with normal RAM) use the same dma_map_phys path
and are safe.

Replace the blanket zone_device_pages_have_same_pgmap() rejection with
zone_device_pages_compatible(), while keeping
zone_device_pages_have_same_pgmap() as a merge guard.
Pages from different pgmaps can be added as separate bvec entries but
must not be coalesced into the same segment, as that would make
it impossible to recover the correct pgmap via page_pgmap().

Fixes: 49580e690755 ("block: add check when merging zone device pages")
Cc: stable@vger.kernel.org
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260410153414.4159050-3-namjain@linux.microsoft.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio-integrity.c |    6 +++---
 block/bio.c           |    6 +++---
 block/blk.h           |   19 +++++++++++++++++++
 3 files changed, 25 insertions(+), 6 deletions(-)

--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -167,10 +167,10 @@ int bio_integrity_add_page(struct bio *b
 	if (bip->bip_vcnt > 0) {
 		struct bio_vec *bv = &bip->bip_vec[bip->bip_vcnt - 1];
 
-		if (!zone_device_pages_have_same_pgmap(bv->bv_page, page))
+		if (!zone_device_pages_compatible(bv->bv_page, page))
 			return 0;
-
-		if (bvec_try_merge_hw_page(q, bv, page, len, offset)) {
+		if (zone_device_pages_have_same_pgmap(bv->bv_page, page) &&
+		    bvec_try_merge_hw_page(q, bv, page, len, offset)) {
 			bip->bip_iter.bi_size += len;
 			return len;
 		}
--- a/block/bio.c
+++ b/block/bio.c
@@ -1070,10 +1070,10 @@ int bio_add_page(struct bio *bio, struct
 	if (bio->bi_vcnt > 0) {
 		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
-		if (!zone_device_pages_have_same_pgmap(bv->bv_page, page))
+		if (!zone_device_pages_compatible(bv->bv_page, page))
 			return 0;
-
-		if (bvec_try_merge_page(bv, page, len, offset)) {
+		if (zone_device_pages_have_same_pgmap(bv->bv_page, page) &&
+		    bvec_try_merge_page(bv, page, len, offset)) {
 			bio->bi_iter.bi_size += len;
 			return len;
 		}
--- a/block/blk.h
+++ b/block/blk.h
@@ -139,6 +139,25 @@ static inline bool biovec_phys_mergeable
 	return true;
 }
 
+/*
+ * Check if two pages from potentially different zone device pgmaps can
+ * coexist as separate bvec entries in the same bio.
+ *
+ * The block DMA iterator (blk_dma_map_iter_start) caches the P2PDMA mapping
+ * state from the first segment and applies it to all subsequent segments, so
+ * P2PDMA pages from different pgmaps must not be mixed in the same bio.
+ *
+ * Other zone device types (FS_DAX, GENERIC) use the same dma_map_phys() path
+ * as normal RAM.  PRIVATE and COHERENT pages never appear in bios.
+ */
+static inline bool zone_device_pages_compatible(const struct page *a,
+						const struct page *b)
+{
+	if (is_pci_p2pdma_page(a) || is_pci_p2pdma_page(b))
+		return zone_device_pages_have_same_pgmap(a, b);
+	return true;
+}
+
 static inline bool __bvec_gap_to_prev(const struct queue_limits *lim,
 		struct bio_vec *bprv, unsigned int offset)
 {


