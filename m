Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B655023ABBD;
	Thu,  9 Oct 2025 16:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025655; cv=none; b=ZtgGSWNX+1lfdv5gQ8LMKLbGyfABavvMMOQb+kkHvnjNMtQrq1DIrs3bXbHxzy/QXRqsJsZxxgNyXvHi7NbJ/5wHLFGZqo1mLdyDQp56ezDMQVn4i5WoWjpMq4m9Xo6iVLcO8cRcPY1/ic0hcELHleP77JtnwkKNk0JRCd41pIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025655; c=relaxed/simple;
	bh=0jJsxHPjAHJUlM4jFdpTzq6CmwynweOeApAk3TLqR5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JQzt6UjZsT+GyrG/s/jh5Ke4hbKpLOtbwl0kEJpilu0KxnEV2VQ7Sek7RttIxIs2oVPpYBRSaaRkwIqphVMAhfaTWAyss10+CPYAWcd2oawpaNVOoHItDdm3jlZWqyGBQc4XoTUpZWw+RRLNXBfkn/AI6HJIE15qv2Kus775wWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tp3LIm0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tp3LIm0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F54C4CEE7;
	Thu,  9 Oct 2025 16:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025655;
	bh=0jJsxHPjAHJUlM4jFdpTzq6CmwynweOeApAk3TLqR5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tp3LIm0lx1J3iKFmtIbFKI9fVp4l5crUOsTcI3l1W3/zZAwEiGdpan+9a+vpJy0Qd
	 4qtuVKXBTRqTb8O6wIcoWLCW8A7K1tq3HGzOrwfvUJRUZ70IjOB9/d617gWlpgUx+B
	 azvJD8PGlg/SQ5GiXnDr2dRXfN/3dUknDisdOTbQ7qW/xqe5v2kZrtYc1SAeK2jFAl
	 eJp+SF0sXIRo21v/Pz0PaqCryZ9wUfOgE9g6bdPiywM6g/QE7i/zjkk+jXJM993hND
	 pIcuVeRNCKVPNv5MHdJawJFTLzSW3toQKsQFjZsmuE3ed2gwRsmsEs3osG518f9CHu
	 +wzOLCTPThZ4g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.16] block: check for valid bio while splitting
Date: Thu,  9 Oct 2025 11:56:04 -0400
Message-ID: <20251009155752.773732-98-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit fec2e705729dc93de5399d8b139e4746805c3d81 ]

We're already iterating every segment, so check these for a valid IO
lengths at the same time. Individual segment lengths will not be checked
on passthrough commands. The read/write command segments must be sized
to the dma alignment.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES - Enforcing queue_dma_alignment during bio splitting plugs a real
correctness hole.

- block/blk-merge.c:304-314 now aborts splitting whenever a segment’s
  offset or length violates `rq->q->limits.dma_alignment`, so we stop
  generating tail bios that hardware simply cannot DMA. Today
  `bio_split_rw_at()` only rounds down to the logical block size; on
  controllers whose `max_hw_sectors` isn’t a multiple of the required
  DMA alignment (common with 4 KiB-aligned gear or dm layers that
  inherit large masks), the old code could emit a second bio whose first
  bvec started at an unaligned byte boundary—drivers would then fail the
  map or, worse, hit data corruption.
- The new zero-length guard at block/blk-merge.c:341–343 fixes another
  latent failure where alignment rounding reduced the “bytes that fit”
  to 0, causing us to claim “no split needed” and proceed with an IO
  layout the device cannot use.
- include/linux/blkdev.h:1860-1866 keeps the public helper name but
  funneled read/write callers through the new alignment-aware helper, so
  all filesystem and block callers pick up the fix with no signature
  churn. Passthrough stays untouched via the explicit `len_align_mask =
  0` in block/blk-map.c:446, avoiding false positives on commands that
  manage their own SG formatting.
- The change is tightly scoped (four files), doesn’t relax any limit,
  and only rejects bios that already violate documented queue
  constraints—practical risk is low compared to the hard device failures
  it prevents.

Given the potential for real-world DMA faults and the minimal, targeted
nature of the patch, it’s a solid candidate for stable backport.

 block/blk-map.c        |  2 +-
 block/blk-merge.c      | 21 +++++++++++++++++----
 include/linux/bio.h    |  4 ++--
 include/linux/blkdev.h |  7 +++++++
 4 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 23e5d5ebe59ec..6d1268aa82715 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -443,7 +443,7 @@ int blk_rq_append_bio(struct request *rq, struct bio *bio)
 	int ret;
 
 	/* check that the data layout matches the hardware restrictions */
-	ret = bio_split_rw_at(bio, lim, &nr_segs, max_bytes);
+	ret = bio_split_io_at(bio, lim, &nr_segs, max_bytes, 0);
 	if (ret) {
 		/* if we would have to split the bio, copy instead */
 		if (ret > 0)
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 70d704615be52..cffc0fe48d8a3 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -279,25 +279,30 @@ static unsigned int bio_split_alignment(struct bio *bio,
 }
 
 /**
- * bio_split_rw_at - check if and where to split a read/write bio
+ * bio_split_io_at - check if and where to split a bio
  * @bio:  [in] bio to be split
  * @lim:  [in] queue limits to split based on
  * @segs: [out] number of segments in the bio with the first half of the sectors
  * @max_bytes: [in] maximum number of bytes per bio
+ * @len_align_mask: [in] length alignment mask for each vector
  *
  * Find out if @bio needs to be split to fit the queue limits in @lim and a
  * maximum size of @max_bytes.  Returns a negative error number if @bio can't be
  * split, 0 if the bio doesn't have to be split, or a positive sector offset if
  * @bio needs to be split.
  */
-int bio_split_rw_at(struct bio *bio, const struct queue_limits *lim,
-		unsigned *segs, unsigned max_bytes)
+int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
+		unsigned *segs, unsigned max_bytes, unsigned len_align_mask)
 {
 	struct bio_vec bv, bvprv, *bvprvp = NULL;
 	struct bvec_iter iter;
 	unsigned nsegs = 0, bytes = 0;
 
 	bio_for_each_bvec(bv, bio, iter) {
+		if (bv.bv_offset & lim->dma_alignment ||
+		    bv.bv_len & len_align_mask)
+			return -EINVAL;
+
 		/*
 		 * If the queue doesn't support SG gaps and adding this
 		 * offset would create a gap, disallow it.
@@ -339,8 +344,16 @@ int bio_split_rw_at(struct bio *bio, const struct queue_limits *lim,
 	 * Individual bvecs might not be logical block aligned. Round down the
 	 * split size so that each bio is properly block size aligned, even if
 	 * we do not use the full hardware limits.
+	 *
+	 * It is possible to submit a bio that can't be split into a valid io:
+	 * there may either be too many discontiguous vectors for the max
+	 * segments limit, or contain virtual boundary gaps without having a
+	 * valid block sized split. A zero byte result means one of those
+	 * conditions occured.
 	 */
 	bytes = ALIGN_DOWN(bytes, bio_split_alignment(bio, lim));
+	if (!bytes)
+		return -EINVAL;
 
 	/*
 	 * Bio splitting may cause subtle trouble such as hang when doing sync
@@ -350,7 +363,7 @@ int bio_split_rw_at(struct bio *bio, const struct queue_limits *lim,
 	bio_clear_polled(bio);
 	return bytes >> SECTOR_SHIFT;
 }
-EXPORT_SYMBOL_GPL(bio_split_rw_at);
+EXPORT_SYMBOL_GPL(bio_split_io_at);
 
 struct bio *bio_split_rw(struct bio *bio, const struct queue_limits *lim,
 		unsigned *nr_segs)
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 46ffac5caab78..519a1d59805f8 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -322,8 +322,8 @@ static inline void bio_next_folio(struct folio_iter *fi, struct bio *bio)
 void bio_trim(struct bio *bio, sector_t offset, sector_t size);
 extern struct bio *bio_split(struct bio *bio, int sectors,
 			     gfp_t gfp, struct bio_set *bs);
-int bio_split_rw_at(struct bio *bio, const struct queue_limits *lim,
-		unsigned *segs, unsigned max_bytes);
+int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
+		unsigned *segs, unsigned max_bytes, unsigned len_align);
 
 /**
  * bio_next_split - get next @sectors from a bio, splitting if necessary
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index fe1797bbec420..d75c77eb8cb97 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1870,6 +1870,13 @@ bdev_atomic_write_unit_max_bytes(struct block_device *bdev)
 	return queue_atomic_write_unit_max_bytes(bdev_get_queue(bdev));
 }
 
+static inline int bio_split_rw_at(struct bio *bio,
+		const struct queue_limits *lim,
+		unsigned *segs, unsigned max_bytes)
+{
+	return bio_split_io_at(bio, lim, segs, max_bytes, lim->dma_alignment);
+}
+
 #define DEFINE_IO_COMP_BATCH(name)	struct io_comp_batch name = { }
 
 #endif /* _LINUX_BLKDEV_H */
-- 
2.51.0

