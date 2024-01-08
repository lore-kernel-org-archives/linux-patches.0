Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5185380A;
	Mon,  8 Jan 2024 15:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIqsoiUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11183C433C7;
	Mon,  8 Jan 2024 15:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728588;
	bh=yoqJtS7N5Q5/U9ObtR4pzh0YzsvmqDgEl3s+tHQZTsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIqsoiUFAvP8o9HhG5VJVX5laAvUSnQoFkNs80fZnwf+SQR3u5EPf2Aq9Y3nI4JPu
	 Jgw7T3JkR2zlpVuqa9vgkTfEb2E9g78h9NGb1awnSlRHuxaMGP6H2eSyTrHI5ILfCn
	 0Fcq3BVlGT/kPHr877Fj4YevCbxmg9MJPkdh1Pkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/150] blk-mq: make sure active queue usage is held for bio_integrity_prep()
Date: Mon,  8 Jan 2024 16:35:37 +0100
Message-ID: <20240108153515.187120453@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@infradead.org>

[ Upstream commit b0077e269f6c152e807fdac90b58caf012cdbaab ]

blk_integrity_unregister() can come if queue usage counter isn't held
for one bio with integrity prepared, so this request may be completed with
calling profile->complete_fn, then kernel panic.

Another constraint is that bio_integrity_prep() needs to be called
before bio merge.

Fix the issue by:

- call bio_integrity_prep() with one queue usage counter grabbed reliably

- call bio_integrity_prep() before bio merge

Fixes: 900e080752025f00 ("block: move queue enter logic into blk_mq_submit_bio()")
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Link: https://lore.kernel.org/r/20231113035231.2708053-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 75 +++++++++++++++++++++++++-------------------------
 1 file changed, 38 insertions(+), 37 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 100fb0c3114f8..383d94615e502 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2855,11 +2855,8 @@ static struct request *blk_mq_get_new_requests(struct request_queue *q,
 	};
 	struct request *rq;
 
-	if (unlikely(bio_queue_enter(bio)))
-		return NULL;
-
 	if (blk_mq_attempt_bio_merge(q, bio, nsegs))
-		goto queue_exit;
+		return NULL;
 
 	rq_qos_throttle(q, bio);
 
@@ -2875,35 +2872,23 @@ static struct request *blk_mq_get_new_requests(struct request_queue *q,
 	rq_qos_cleanup(q, bio);
 	if (bio->bi_opf & REQ_NOWAIT)
 		bio_wouldblock_error(bio);
-queue_exit:
-	blk_queue_exit(q);
 	return NULL;
 }
 
-static inline struct request *blk_mq_get_cached_request(struct request_queue *q,
-		struct blk_plug *plug, struct bio **bio, unsigned int nsegs)
+/* return true if this @rq can be used for @bio */
+static bool blk_mq_can_use_cached_rq(struct request *rq, struct blk_plug *plug,
+		struct bio *bio)
 {
-	struct request *rq;
-	enum hctx_type type, hctx_type;
+	enum hctx_type type = blk_mq_get_hctx_type(bio->bi_opf);
+	enum hctx_type hctx_type = rq->mq_hctx->type;
 
-	if (!plug)
-		return NULL;
-	rq = rq_list_peek(&plug->cached_rq);
-	if (!rq || rq->q != q)
-		return NULL;
-
-	if (blk_mq_attempt_bio_merge(q, *bio, nsegs)) {
-		*bio = NULL;
-		return NULL;
-	}
+	WARN_ON_ONCE(rq_list_peek(&plug->cached_rq) != rq);
 
-	type = blk_mq_get_hctx_type((*bio)->bi_opf);
-	hctx_type = rq->mq_hctx->type;
 	if (type != hctx_type &&
 	    !(type == HCTX_TYPE_READ && hctx_type == HCTX_TYPE_DEFAULT))
-		return NULL;
-	if (op_is_flush(rq->cmd_flags) != op_is_flush((*bio)->bi_opf))
-		return NULL;
+		return false;
+	if (op_is_flush(rq->cmd_flags) != op_is_flush(bio->bi_opf))
+		return false;
 
 	/*
 	 * If any qos ->throttle() end up blocking, we will have flushed the
@@ -2911,11 +2896,11 @@ static inline struct request *blk_mq_get_cached_request(struct request_queue *q,
 	 * before we throttle.
 	 */
 	plug->cached_rq = rq_list_next(rq);
-	rq_qos_throttle(q, *bio);
+	rq_qos_throttle(rq->q, bio);
 
-	rq->cmd_flags = (*bio)->bi_opf;
+	rq->cmd_flags = bio->bi_opf;
 	INIT_LIST_HEAD(&rq->queuelist);
-	return rq;
+	return true;
 }
 
 static void bio_set_ioprio(struct bio *bio)
@@ -2944,7 +2929,7 @@ void blk_mq_submit_bio(struct bio *bio)
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	struct blk_plug *plug = blk_mq_plug(bio);
 	const int is_sync = op_is_sync(bio->bi_opf);
-	struct request *rq;
+	struct request *rq = NULL;
 	unsigned int nr_segs = 1;
 	blk_status_t ret;
 
@@ -2955,20 +2940,36 @@ void blk_mq_submit_bio(struct bio *bio)
 			return;
 	}
 
-	if (!bio_integrity_prep(bio))
-		return;
-
 	bio_set_ioprio(bio);
 
-	rq = blk_mq_get_cached_request(q, plug, &bio, nr_segs);
-	if (!rq) {
-		if (!bio)
+	if (plug) {
+		rq = rq_list_peek(&plug->cached_rq);
+		if (rq && rq->q != q)
+			rq = NULL;
+	}
+	if (rq) {
+		if (!bio_integrity_prep(bio))
 			return;
-		rq = blk_mq_get_new_requests(q, plug, bio, nr_segs);
-		if (unlikely(!rq))
+		if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
 			return;
+		if (blk_mq_can_use_cached_rq(rq, plug, bio))
+			goto done;
+		percpu_ref_get(&q->q_usage_counter);
+	} else {
+		if (unlikely(bio_queue_enter(bio)))
+			return;
+		if (!bio_integrity_prep(bio))
+			goto fail;
+	}
+
+	rq = blk_mq_get_new_requests(q, plug, bio, nr_segs);
+	if (unlikely(!rq)) {
+fail:
+		blk_queue_exit(q);
+		return;
 	}
 
+done:
 	trace_block_getrq(bio);
 
 	rq_qos_track(q, rq, bio);
-- 
2.43.0



