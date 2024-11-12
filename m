Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BA62144C3;
	Tue, 12 Nov 2024 10:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408480; cv=none; b=K27bstA+x0eNXY9pqV3tZxd7s0etmQAOkfIg4UhZT5O4kF26rlVrHZa9H+nUyx/DFfEWaSToCR3QI++gPifokwDD9QohtjA3paW5H2MQuU6kDPrMrwJ/CRiSseXioMYrj9k6L3zMhPkDjEZ+4jLMHJMAiIL96xhRycUQx5Crd1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408480; c=relaxed/simple;
	bh=eWlcfspPV1VOk9oGm/kLOhJf5vVeZwQcxo+gkLzeiAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMN5WVMsynkoxJxlEmqsq0RKsUk3QxMseZEO12Couamp5aax0NPxMAs46uI9zLFiY6QDH/v0D1AgN0ISDm+GG5yDExwaVLMCnzcolthkm7jbI4uPGGCeNU9KofS1MqEflMuuDUznyshPaEJERGSk3+WB5NKlrlF/yBQuzwpzbEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFT+dRyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFT+dRyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42534C4CECD;
	Tue, 12 Nov 2024 10:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408480;
	bh=eWlcfspPV1VOk9oGm/kLOhJf5vVeZwQcxo+gkLzeiAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFT+dRydIhlfjBHKgwtJb8z8l/Mq6LmYUPfS9bC+1rY5N/S4ZIzN1gk3iQZRZkUh6
	 l56vGB43cW0XzjEHt98mCpvruLoHhFK4rnlApwQol1/1aCS6PFWluKm00kRnfPdgV4
	 q08JYEGnobh/CTl0tPgsKsoWxOOBy/2yUNK+2RXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 176/184] block: fix queue limits checks in blk_rq_map_user_bvec for real
Date: Tue, 12 Nov 2024 11:22:14 +0100
Message-ID: <20241112101907.617772721@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit be0e822bb3f5259c7f9424ba97e8175211288813 ]

blk_rq_map_user_bvec currently only has ad-hoc checks for queue limits,
and the last fix to it enabled valid NVMe I/O to pass, but also allowed
invalid one for drivers that set a max_segment_size or seg_boundary
limit.

Fix it once for all by using the bio_split_rw_at helper from the I/O
path that indicates if and where a bio would be have to be split to
adhere to the queue limits, and it returns a positive value, turn that
into -EREMOTEIO to retry using the copy path.

Fixes: 2ff949441802 ("block: fix sanity checks in blk_rq_map_user_bvec")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241028090840.446180-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-map.c | 56 +++++++++++++++----------------------------------
 1 file changed, 17 insertions(+), 39 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 6ef2ec1f7d78b..b5fd1d8574615 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -561,55 +561,33 @@ EXPORT_SYMBOL(blk_rq_append_bio);
 /* Prepare bio for passthrough IO given ITER_BVEC iter */
 static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter)
 {
-	struct request_queue *q = rq->q;
-	size_t nr_iter = iov_iter_count(iter);
-	size_t nr_segs = iter->nr_segs;
-	struct bio_vec *bvecs, *bvprvp = NULL;
-	const struct queue_limits *lim = &q->limits;
-	unsigned int nsegs = 0, bytes = 0;
+	const struct queue_limits *lim = &rq->q->limits;
+	unsigned int max_bytes = lim->max_hw_sectors << SECTOR_SHIFT;
+	unsigned int nsegs;
 	struct bio *bio;
-	size_t i;
+	int ret;
 
-	if (!nr_iter || (nr_iter >> SECTOR_SHIFT) > queue_max_hw_sectors(q))
-		return -EINVAL;
-	if (nr_segs > queue_max_segments(q))
+	if (!iov_iter_count(iter) || iov_iter_count(iter) > max_bytes)
 		return -EINVAL;
 
-	/* no iovecs to alloc, as we already have a BVEC iterator */
+	/* reuse the bvecs from the iterator instead of allocating new ones */
 	bio = blk_rq_map_bio_alloc(rq, 0, GFP_KERNEL);
-	if (bio == NULL)
+	if (!bio)
 		return -ENOMEM;
-
 	bio_iov_bvec_set(bio, (struct iov_iter *)iter);
-	blk_rq_bio_prep(rq, bio, nr_segs);
-
-	/* loop to perform a bunch of sanity checks */
-	bvecs = (struct bio_vec *)iter->bvec;
-	for (i = 0; i < nr_segs; i++) {
-		struct bio_vec *bv = &bvecs[i];
-
-		/*
-		 * If the queue doesn't support SG gaps and adding this
-		 * offset would create a gap, fallback to copy.
-		 */
-		if (bvprvp && bvec_gap_to_prev(lim, bvprvp, bv->bv_offset)) {
-			blk_mq_map_bio_put(bio);
-			return -EREMOTEIO;
-		}
-		/* check full condition */
-		if (nsegs >= nr_segs || bytes > UINT_MAX - bv->bv_len)
-			goto put_bio;
-		if (bytes + bv->bv_len > nr_iter)
-			break;
 
-		nsegs++;
-		bytes += bv->bv_len;
-		bvprvp = bv;
+	/* check that the data layout matches the hardware restrictions */
+	ret = bio_split_rw_at(bio, lim, &nsegs, max_bytes);
+	if (ret) {
+		/* if we would have to split the bio, copy instead */
+		if (ret > 0)
+			ret = -EREMOTEIO;
+		blk_mq_map_bio_put(bio);
+		return ret;
 	}
+
+	blk_rq_bio_prep(rq, bio, nsegs);
 	return 0;
-put_bio:
-	blk_mq_map_bio_put(bio);
-	return -EINVAL;
 }
 
 /**
-- 
2.43.0



