Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D992324CEEA;
	Sat, 12 Sep 2026 11:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210876; cv=none; b=Do1RibRXVILhpifeD0Iw/7gspTelG84ECtmmjiuN+sILukk0p2267MJnJLMDotYnTh2dSjsrPCx90cdH2cR4Ic/ZgNNAX6fVaiwEY6wvfmPqf7Wyl7bhwsBjBTUSHEKOz56V7GQ+hUK++0zOXyPU1H6SFI8BPLaAOUVjvBYrhFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210876; c=relaxed/simple;
	bh=KXE4gsty4NnSc/soT5ZTxHux+EcpL8BcIPK5zBD1yWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZKKjm7YOhSnIO8NIk/b3+skNfdxoyCqOGblYUxDaQtMgMVo/7ZrxFwU0m3iWGV8HuvhVf6svdidA2d1YDrunW51uxUBxKLfQ8ZM41hmeD6syoWwy563x0pZcUtT372TPKTJfl3nkoPVr90PiJFZtaTLS5tHevG/wC/c+NFpYLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pjncHUEM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjncHUEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BC81F000FF;
	Sat, 12 Sep 2026 11:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210874;
	bh=q1w3pMRdrx0Sq2U/PLkDhj5bZs5sI4P+Wz7SeIi1eT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pjncHUEMyIV9fPDG11zOdaDics4q7Qt73VuDNMWN3LtBz2PQQ68RCtJLtl2q8BZbC
	 zLZPt9o2YFGIydLXCsPSs/utNsVZz4vEJhlwOKteHz35Zh6vS63YiPk0t7N+4hPULu
	 ohajU8ioWuvjaPrLUIK7rPHp0R2En4In7+ZGUzoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1116/1518] block: accumulate memory segment gaps per bio
Date: Sat, 12 Sep 2026 08:54:45 +0200
Message-ID: <20260912065648.698241319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 2f6b2565d43cdb5087cac23d530cca84aa3d897e ]

The blk-mq dma iterator has an optimization for requests that align to
the device's iommu merge boundary. This boundary may be larger than the
device's virtual boundary, but the code had been depending on that queue
limit to know ahead of time if the request is guaranteed to align to
that optimization.

Rather than rely on that queue limit, which many devices may not report,
save the lowest set bit of any boundary gap between each segment in the
bio while checking the segments. The request stores the value for
merging and quickly checking per io if the request can use iova
optimizations.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: ea2160c7b781 ("nvme-apple: Require page aligned buffers on the admin queue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c               |  1 +
 block/blk-map.c           |  3 +++
 block/blk-merge.c         | 39 ++++++++++++++++++++++++++++++++++++---
 block/blk-mq-dma.c        |  3 +--
 block/blk-mq.c            |  6 ++++++
 include/linux/bio.h       |  2 ++
 include/linux/blk-mq.h    | 16 ++++++++++++++++
 include/linux/blk_types.h | 12 ++++++++++++
 8 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index b184f0a3fcb2b..5d1861dbe4c8b 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -253,6 +253,7 @@ void bio_init(struct bio *bio, struct block_device *bdev, struct bio_vec *table,
 	bio->bi_write_hint = 0;
 	bio->bi_write_stream = 0;
 	bio->bi_status = 0;
+	bio->bi_bvec_gap_bit = 0;
 	bio->bi_iter.bi_sector = 0;
 	bio->bi_iter.bi_size = 0;
 	bio->bi_iter.bi_idx = 0;
diff --git a/block/blk-map.c b/block/blk-map.c
index 60faf036fb6e4..17a1dc2886786 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -459,6 +459,8 @@ int blk_rq_append_bio(struct request *rq, struct bio *bio)
 	if (rq->bio) {
 		if (!ll_back_merge_fn(rq, bio, nr_segs))
 			return -EINVAL;
+		rq->phys_gap_bit = bio_seg_gap(rq->q, rq->biotail, bio,
+					       rq->phys_gap_bit);
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
 		rq->__data_len += bio->bi_iter.bi_size;
@@ -469,6 +471,7 @@ int blk_rq_append_bio(struct request *rq, struct bio *bio)
 	rq->nr_phys_segments = nr_segs;
 	rq->bio = rq->biotail = bio;
 	rq->__data_len = bio->bi_iter.bi_size;
+	rq->phys_gap_bit = bio->bi_bvec_gap_bit;
 	return 0;
 }
 EXPORT_SYMBOL(blk_rq_append_bio);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 7b984e01f7be7..c2f47522be856 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -313,6 +313,12 @@ static unsigned int bio_split_alignment(struct bio *bio,
 	return lim->logical_block_size;
 }
 
+static inline unsigned int bvec_seg_gap(struct bio_vec *bvprv,
+					struct bio_vec *bv)
+{
+	return bv->bv_offset | (bvprv->bv_offset + bvprv->bv_len);
+}
+
 /**
  * bio_split_io_at - check if and where to split a bio
  * @bio:  [in] bio to be split
@@ -330,8 +336,8 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 		unsigned *segs, unsigned max_bytes, unsigned len_align_mask)
 {
 	struct bio_vec bv, bvprv, *bvprvp = NULL;
+	unsigned nsegs = 0, bytes = 0, gaps = 0;
 	struct bvec_iter iter;
-	unsigned nsegs = 0, bytes = 0;
 
 	bio_for_each_bvec(bv, bio, iter) {
 		if (bv.bv_offset & lim->dma_alignment ||
@@ -342,8 +348,11 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 		 * If the queue doesn't support SG gaps and adding this
 		 * offset would create a gap, disallow it.
 		 */
-		if (bvprvp && bvec_gap_to_prev(lim, bvprvp, bv.bv_offset))
-			goto split;
+		if (bvprvp) {
+			if (bvec_gap_to_prev(lim, bvprvp, bv.bv_offset))
+				goto split;
+			gaps |= bvec_seg_gap(bvprvp, &bv);
+		}
 
 		if (nsegs < lim->max_segments &&
 		    bytes + bv.bv_len <= max_bytes &&
@@ -361,6 +370,7 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 	}
 
 	*segs = nsegs;
+	bio->bi_bvec_gap_bit = ffs(gaps);
 	return 0;
 split:
 	if (bio->bi_opf & REQ_ATOMIC)
@@ -396,6 +406,7 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 	 * big IO can be trival, disable iopoll when split needed.
 	 */
 	bio_clear_polled(bio);
+	bio->bi_bvec_gap_bit = ffs(gaps);
 	return bytes >> SECTOR_SHIFT;
 }
 EXPORT_SYMBOL_GPL(bio_split_io_at);
@@ -732,6 +743,21 @@ static bool blk_atomic_write_mergeable_rqs(struct request *rq,
 	return (rq->cmd_flags & REQ_ATOMIC) == (next->cmd_flags & REQ_ATOMIC);
 }
 
+u8 bio_seg_gap(struct request_queue *q, struct bio *prev, struct bio *next,
+	       u8 gaps_bit)
+{
+	struct bio_vec pb, nb;
+
+	gaps_bit = min_not_zero(gaps_bit, prev->bi_bvec_gap_bit);
+	gaps_bit = min_not_zero(gaps_bit, next->bi_bvec_gap_bit);
+
+	bio_get_last_bvec(prev, &pb);
+	bio_get_first_bvec(next, &nb);
+	if (!biovec_phys_mergeable(q, &pb, &nb))
+		gaps_bit = min_not_zero(gaps_bit, ffs(bvec_seg_gap(&pb, &nb)));
+	return gaps_bit;
+}
+
 /*
  * For non-mq, this has to be called with the request spinlock acquired.
  * For mq with scheduling, the appropriate queue wide lock should be held.
@@ -796,6 +822,9 @@ static struct request *attempt_merge(struct request_queue *q,
 	if (next->start_time_ns < req->start_time_ns)
 		req->start_time_ns = next->start_time_ns;
 
+	req->phys_gap_bit = bio_seg_gap(req->q, req->biotail, next->bio,
+					min_not_zero(next->phys_gap_bit,
+						     req->phys_gap_bit));
 	req->biotail->bi_next = next->bio;
 	req->biotail = next->biotail;
 
@@ -919,6 +948,8 @@ enum bio_merge_status bio_attempt_back_merge(struct request *req,
 	if (req->rq_flags & RQF_ZONE_WRITE_PLUGGING)
 		blk_zone_write_plug_bio_merged(bio);
 
+	req->phys_gap_bit = bio_seg_gap(req->q, req->biotail, bio,
+					req->phys_gap_bit);
 	req->biotail->bi_next = bio;
 	req->biotail = bio;
 	req->__data_len += bio->bi_iter.bi_size;
@@ -953,6 +984,8 @@ static enum bio_merge_status bio_attempt_front_merge(struct request *req,
 
 	blk_update_mixed_merge(req, bio, true);
 
+	req->phys_gap_bit = bio_seg_gap(req->q, bio, req->bio,
+					req->phys_gap_bit);
 	bio->bi_next = req->bio;
 	req->bio = bio;
 
diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index 449950029872a..94d3461b5bc8e 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -79,8 +79,7 @@ static bool blk_map_iter_next(struct request *req, struct blk_map_iter *iter,
 static inline bool blk_can_dma_map_iova(struct request *req,
 		struct device *dma_dev)
 {
-	return !((queue_virt_boundary(req->q) + 1) &
-		dma_get_merge_boundary(dma_dev));
+	return !(req_phys_gap_mask(req) & dma_get_merge_boundary(dma_dev));
 }
 
 static bool blk_dma_map_bus(struct blk_dma_iter *iter, struct phys_vec *vec)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6b4643a279dbf..e050ea631cdac 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -377,6 +377,7 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	INIT_LIST_HEAD(&rq->queuelist);
 	rq->q = q;
 	rq->__sector = (sector_t) -1;
+	rq->phys_gap_bit = 0;
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
 	rq->tag = BLK_MQ_NO_TAG;
@@ -669,6 +670,7 @@ struct request *blk_mq_alloc_request(struct request_queue *q, blk_opf_t opf,
 			goto out_queue_exit;
 	}
 	rq->__data_len = 0;
+	rq->phys_gap_bit = 0;
 	rq->__sector = (sector_t) -1;
 	rq->bio = rq->biotail = NULL;
 	return rq;
@@ -749,6 +751,7 @@ struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
 	rq = blk_mq_rq_ctx_init(&data, blk_mq_tags_from_data(&data), tag);
 	blk_mq_rq_time_init(rq, alloc_time_ns);
 	rq->__data_len = 0;
+	rq->phys_gap_bit = 0;
 	rq->__sector = (sector_t) -1;
 	rq->bio = rq->biotail = NULL;
 	return rq;
@@ -2675,6 +2678,8 @@ static void blk_mq_bio_to_request(struct request *rq, struct bio *bio,
 	rq->bio = rq->biotail = bio;
 	rq->__sector = bio->bi_iter.bi_sector;
 	rq->__data_len = bio->bi_iter.bi_size;
+	rq->phys_gap_bit = bio->bi_bvec_gap_bit;
+
 	rq->nr_phys_segments = nr_segs;
 	if (bio_integrity(bio))
 		rq->nr_integrity_segments = blk_rq_count_integrity_sg(rq->q,
@@ -3382,6 +3387,7 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 	}
 	rq->nr_phys_segments = rq_src->nr_phys_segments;
 	rq->nr_integrity_segments = rq_src->nr_integrity_segments;
+	rq->phys_gap_bit = rq_src->phys_gap_bit;
 
 	if (rq->bio && blk_crypto_rq_bio_prep(rq, rq->bio, gfp_mask) < 0)
 		goto free_and_out;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index eb60727fd21e8..3a9dd300b5eef 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -324,6 +324,8 @@ extern struct bio *bio_split(struct bio *bio, int sectors,
 			     gfp_t gfp, struct bio_set *bs);
 int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 		unsigned *segs, unsigned max_bytes, unsigned len_align);
+u8 bio_seg_gap(struct request_queue *q, struct bio *prev, struct bio *next,
+		u8 gaps_bit);
 
 /**
  * bio_next_split - get next @sectors from a bio, splitting if necessary
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index b25d12545f46d..b54506b3b76d9 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -152,6 +152,14 @@ struct request {
 	unsigned short nr_phys_segments;
 	unsigned short nr_integrity_segments;
 
+	/*
+	 * The lowest set bit for address gaps between physical segments. This
+	 * provides information necessary for dma optimization opprotunities,
+	 * like for testing if the segments can be coalesced against the
+	 * device's iommu granule.
+	 */
+	unsigned char phys_gap_bit;
+
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
 	struct bio_crypt_ctx *crypt_ctx;
 	struct blk_crypto_keyslot *crypt_keyslot;
@@ -208,6 +216,14 @@ struct request {
 	void *end_io_data;
 };
 
+/*
+ * Returns a mask with all bits starting at req->phys_gap_bit set to 1.
+ */
+static inline unsigned long req_phys_gap_mask(const struct request *req)
+{
+	return ~(((1 << req->phys_gap_bit) >> 1) - 1);
+}
+
 static inline enum req_op req_op(const struct request *req)
 {
 	return req->cmd_flags & REQ_OP_MASK;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4e2e3aed32f5f..47fe5631d9e2a 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -218,6 +218,18 @@ struct bio {
 	enum rw_hint		bi_write_hint;
 	u8			bi_write_stream;
 	blk_status_t		bi_status;
+
+	/*
+	 * The bvec gap bit indicates the lowest set bit in any address offset
+	 * between all bi_io_vecs. This field is initialized only after the bio
+	 * is split to the hardware limits (see bio_split_io_at()). The value
+	 * may be used to consider DMA optimization when performing that
+	 * mapping. The value is compared to a power of two mask where the
+	 * result depends on any bit set within the mask, so saving the lowest
+	 * bit is sufficient to know if any segment gap collides with the mask.
+	 */
+	u8			bi_bvec_gap_bit;
+
 	atomic_t		__bi_remaining;
 
 	struct bvec_iter	bi_iter;
-- 
2.53.0



