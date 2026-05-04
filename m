Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720793DE455;
	Mon,  4 May 2026 14:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904840; cv=none; b=k8BBtBRb2pgibdQphlUamatbuTr3+PWQAdrg0XjMLdxBUdHzc1xIYVHM2wrA9WLXxjzlEW05v+DFARX/Bhf2NEn9XLlaDD5wIapu8YShOB3oNdxy4BFJN3y808j6kggK8vHClm/tZd8rBOmk5u9ZmB3LPgmim05midQoH/26R+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904840; c=relaxed/simple;
	bh=isGQm+2E2eheTHL4idGJikztvhQETCrvOuxZb9S7tzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVShUrjbhmuwBW7Zp7lQqIKFGbn8x5Ni7s1BIpH6uX9qKnllQwzFAkZ9ZL9V9l6K5MPr1+G43ZNFyPxXH+NbsB0LaRDE6Ml1BLxnAwswdozs/6w7EsWXWmH65mYUvHiLy8SS8WuxlimuNVVDGE5c3npt0EIKP0hOOTWZvzjp3ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOUgQYFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOUgQYFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094B4C2BCB8;
	Mon,  4 May 2026 14:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904840;
	bh=isGQm+2E2eheTHL4idGJikztvhQETCrvOuxZb9S7tzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOUgQYFC9PNwDfbtx2ghqwYNBkRTJ73noVASvKy3K6mZ+RyeBnMuVPVRjGkiww/C3
	 xAFmpLj5VdrvM9e+iCsGbd++FsVsoUc0xdxDu32phqC9bstFaO3dgqlqmL5dA4W9yA
	 kzk1/VmsO2zNDLVD85pSqg8FzAKj7Gmwx/Dx+el8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naman Jain <namjain@linux.microsoft.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 194/215] block: relax pgmap check in bio_add_page for compatible zone device pages
Date: Mon,  4 May 2026 15:53:33 +0200
Message-ID: <20260504135137.536906280@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Naman Jain <namjain@linux.microsoft.com>

[ Upstream commit 41c665aae2b5dbecddddcc8ace344caf630cc7a4 ]

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
[ restructured combined `if` into explicit `bv` block ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio-integrity.c |    2 ++
 block/bio.c           |   14 +++++++++-----
 block/blk.h           |   19 +++++++++++++++++++
 3 files changed, 30 insertions(+), 5 deletions(-)

--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -167,6 +167,8 @@ int bio_integrity_add_page(struct bio *b
 		struct bio_vec *bv = &bip->bip_vec[bip->bip_vcnt - 1];
 		bool same_page = false;
 
+		if (!zone_device_pages_compatible(bv->bv_page, page))
+			return 0;
 		if (bvec_try_merge_hw_page(q, bv, page, len, offset,
 					   &same_page)) {
 			bip->bip_iter.bi_size += len;
--- a/block/bio.c
+++ b/block/bio.c
@@ -1155,11 +1155,15 @@ int bio_add_page(struct bio *bio, struct
 	if (bio->bi_iter.bi_size > UINT_MAX - len)
 		return 0;
 
-	if (bio->bi_vcnt > 0 &&
-	    bvec_try_merge_page(&bio->bi_io_vec[bio->bi_vcnt - 1],
-				page, len, offset, &same_page)) {
-		bio->bi_iter.bi_size += len;
-		return len;
+	if (bio->bi_vcnt > 0) {
+		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
+
+		if (!zone_device_pages_compatible(bv->bv_page, page))
+			return 0;
+		if (bvec_try_merge_page(bv, page, len, offset, &same_page)) {
+			bio->bi_iter.bi_size += len;
+			return len;
+		}
 	}
 
 	if (bio->bi_vcnt >= bio->bi_max_vecs)
--- a/block/blk.h
+++ b/block/blk.h
@@ -124,6 +124,25 @@ static inline bool biovec_phys_mergeable
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


