Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C927535A3AD;
	Mon,  4 May 2026 14:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903956; cv=none; b=BCPxiQJP6MnyO6+fqFHPlzgz69lI5EzgZ0xYqEzim7vMmuLoxDdQoSPeK/ppq07AXA83utk7vu2p/BkOPKrkH9LlUHZlCZtcI9FWwDMgwmKKT3Ij3/44MIzpfmyzOx9lZYdjAN/X1A9gQFNTiSmmx+fEWWrR1ytOWL2cfpv4o5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903956; c=relaxed/simple;
	bh=r+zlZ4VD3JgVgXyscjqcmPQoBG7csxDqV93jGd0Iaj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oh/Kfi/e2kYxu5wOD/+6VhooxpGGpbrMwxk5Ze4Ed6NBZY7cUtQ7rLmJQyXPN3uLw+WGV5rJZK3T4ZgeDzJ5GYqW4J4+SeT6Gpf/xOHc3PmDDYLXeJVT0Bp3lfRYi0awxmdll9BL2ojvNOyUP046wnQR/K2SjM4awzScdFzaS2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyPdJIBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyPdJIBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8C9C2BCB8;
	Mon,  4 May 2026 14:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903956;
	bh=r+zlZ4VD3JgVgXyscjqcmPQoBG7csxDqV93jGd0Iaj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyPdJIBBuC56FCkxznGnnwkFhwaK2h0KmbeUD8eahftpuBGL40BE92WiW8a6XA3eV
	 zMvRSAYVQgnQIHXF3UndBvzfGBPmgQxghTNAffy1+GTFZGOqEVqT5X1NyUtDtqTHnb
	 FB0yGwWIiZfKdVGNp0XjVm+qlQtjB7Wif/lkj8xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naman Jain <namjain@linux.microsoft.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 095/275] block: relax pgmap check in bio_add_page for compatible zone device pages
Date: Mon,  4 May 2026 15:50:35 +0200
Message-ID: <20260504135146.448361948@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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
@@ -128,10 +128,10 @@ int bio_integrity_add_page(struct bio *b
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
@@ -1030,10 +1030,10 @@ int bio_add_page(struct bio *bio, struct
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


