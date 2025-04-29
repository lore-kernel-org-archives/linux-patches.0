Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5280E242D94;
	Tue, 29 Apr 2025 17:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947512; cv=none; b=AzC2LT7NtoGMtAlPGCltIUy41O881AumJgkGj+GWr/rU2nLAx2BPVQpiO99Tb5eVfOQFwTfl3O9+fg8cb2nzmnU/Dl73U22aNi16iRPy+eZpSUH7iBJA7CoVQkn7UzC5kCFK4dr5JxJhc6Oy7urofronD5VIq6xCa9uzY0vuST4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947512; c=relaxed/simple;
	bh=88FGn4/7g1xrPRFxToKZkIO8a/OG0A1v+d25Mp7NMAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyZeSXnjHPyPfChHmkRZuhxqOC2TyskxW/sSQ4jH1V4GPbVl02A7CX73HkDzKjUXkeNdlqt9DMy1rkTwhQCp4JymMt8LNqVkbjH37SMMVGlX+gD0sbmF5nBn+7a9j/jAK2lfHyz/kCiisxlvrCzveYwktJefbr3vVvyrHgzQPKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbS79tdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbS79tdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE03C4CEE3;
	Tue, 29 Apr 2025 17:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947512;
	bh=88FGn4/7g1xrPRFxToKZkIO8a/OG0A1v+d25Mp7NMAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbS79tdmic4dE+smoOif91MaF0INsWjzn2n5SocGyyqcM/HajwFH/Pa5Lc0vRkotE
	 DcjKUQDqkuWN3GY/C5ydtLrChLtdrarpxlrWZM2OMAwAvELqKuESzTRi/cAWZ0cYrE
	 deZkJc1JGPz/9BaVVkWKHoicJPSCqvXvwiwM3XgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/280] block: remove the ioprio field from struct request
Date: Tue, 29 Apr 2025 18:39:19 +0200
Message-ID: <20250429161115.834220056@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 6975c1a486a40446b5bc77a89d9c520f8296fd08 ]

The request ioprio is only initialized from the first attached bio,
so requests without a bio already never set it.  Directly use the
bio field instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20241112170050.1612998-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: fc0e982b8a3a ("block: make sure ->nr_integrity_segments is cloned in blk_rq_prep_clone")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c            | 10 ++++------
 block/blk-mq.c               |  3 +--
 include/linux/blk-mq.h       |  7 +++----
 include/trace/events/block.h |  6 +++---
 4 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index bc909bd894fae..f575cc1705b3f 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -868,11 +868,10 @@ static struct request *attempt_merge(struct request_queue *q,
 		/* Don't merge requests with different write hints. */
 		if (req->bio->bi_write_hint != next->bio->bi_write_hint)
 			return NULL;
+		if (req->bio->bi_ioprio != next->bio->bi_ioprio)
+			return NULL;
 	}
 
-	if (req->ioprio != next->ioprio)
-		return NULL;
-
 	if (!blk_atomic_write_mergeable_rqs(req, next))
 		return NULL;
 
@@ -1004,11 +1003,10 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 		/* Don't merge requests with different write hints. */
 		if (rq->bio->bi_write_hint != bio->bi_write_hint)
 			return false;
+		if (rq->bio->bi_ioprio != bio->bi_ioprio)
+			return false;
 	}
 
-	if (rq->ioprio != bio_prio(bio))
-		return false;
-
 	if (blk_atomic_write_mergeable_rq_bio(rq, bio) == false)
 		return false;
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index e3a0f521335bb..5e6afda59e7a1 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -870,7 +870,7 @@ static void blk_print_req_error(struct request *req, blk_status_t status)
 		blk_op_str(req_op(req)),
 		(__force u32)(req->cmd_flags & ~REQ_OP_MASK),
 		req->nr_phys_segments,
-		IOPRIO_PRIO_CLASS(req->ioprio));
+		IOPRIO_PRIO_CLASS(req_get_ioprio(req)));
 }
 
 /*
@@ -3306,7 +3306,6 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 		rq->special_vec = rq_src->special_vec;
 	}
 	rq->nr_phys_segments = rq_src->nr_phys_segments;
-	rq->ioprio = rq_src->ioprio;
 
 	if (rq->bio && blk_crypto_rq_bio_prep(rq, rq->bio, gfp_mask) < 0)
 		goto free_and_out;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 07c3934080bad..959f8f82a6509 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -156,8 +156,6 @@ struct request {
 	struct blk_crypto_keyslot *crypt_keyslot;
 #endif
 
-	unsigned short ioprio;
-
 	enum mq_rq_state state;
 	atomic_t ref;
 
@@ -221,7 +219,9 @@ static inline bool blk_rq_is_passthrough(struct request *rq)
 
 static inline unsigned short req_get_ioprio(struct request *req)
 {
-	return req->ioprio;
+	if (req->bio)
+		return req->bio->bi_ioprio;
+	return 0;
 }
 
 #define rq_data_dir(rq)		(op_is_write(req_op(rq)) ? WRITE : READ)
@@ -1009,7 +1009,6 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
 	rq->nr_phys_segments = nr_segs;
 	rq->__data_len = bio->bi_iter.bi_size;
 	rq->bio = rq->biotail = bio;
-	rq->ioprio = bio_prio(bio);
 }
 
 void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 1527d5d45e01a..bd0ea07338eb6 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -99,7 +99,7 @@ TRACE_EVENT(block_rq_requeue,
 		__entry->dev	   = rq->q->disk ? disk_devt(rq->q->disk) : 0;
 		__entry->sector    = blk_rq_trace_sector(rq);
 		__entry->nr_sector = blk_rq_trace_nr_sectors(rq);
-		__entry->ioprio    = rq->ioprio;
+		__entry->ioprio    = req_get_ioprio(rq);
 
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags);
 		__get_str(cmd)[0] = '\0';
@@ -136,7 +136,7 @@ DECLARE_EVENT_CLASS(block_rq_completion,
 		__entry->sector    = blk_rq_pos(rq);
 		__entry->nr_sector = nr_bytes >> 9;
 		__entry->error     = blk_status_to_errno(error);
-		__entry->ioprio    = rq->ioprio;
+		__entry->ioprio    = req_get_ioprio(rq);
 
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags);
 		__get_str(cmd)[0] = '\0';
@@ -209,7 +209,7 @@ DECLARE_EVENT_CLASS(block_rq,
 		__entry->sector    = blk_rq_trace_sector(rq);
 		__entry->nr_sector = blk_rq_trace_nr_sectors(rq);
 		__entry->bytes     = blk_rq_bytes(rq);
-		__entry->ioprio	   = rq->ioprio;
+		__entry->ioprio	   = req_get_ioprio(rq);
 
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags);
 		__get_str(cmd)[0] = '\0';
-- 
2.39.5



