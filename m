Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438533F870F;
	Thu, 28 May 2026 20:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999236; cv=none; b=OiCz4Cyrp8UjMb5/Ttbrgi28SFajq8+lV9Xkg6PaUMShq8PtWX91xzTGwobhdczv5L3zMpc7S+fveFBz/YpobD2fH4KewHDR8CWieB/u1irP89rHnRoOjEJD1crGngVML6tQ53XrigaDYHUvDcKOLiekgXrEbNTg5Fe4XwBBm6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999236; c=relaxed/simple;
	bh=ngInX+KIqJqll69DnHj8cDeEJKi8BC2FovLZ0rBzsCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDDlG+fPWL1C6fU//6rYsLUjcl7QNgARyLqtSXNxiNDwFicRStTCokeh5EtbZJB665RFmUqH+JrXnA7etYRpIPPTQtECdjmgwtkT66BVPdkvumv8c/3mp5GAWO8IHQ4/HfxFN9ILMpAMFD6VK+SDOSUK3O+t+1o6Bwi7Q5s+Ns4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/910fkR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/910fkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FD01F00A3A;
	Thu, 28 May 2026 20:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999235;
	bh=PZcsUrMuP3YKgCQ+0gc2M3VHOqmBu43NdDSFplx2YEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/910fkR5R59LrJC/3vky4PnEOkq6i4oB5vI8FcHgPOg7X5VM5+7OwBDSatnU2SsW
	 +ltY8U1vTxdnfwjFwKr6i/EqiwuVOgKMUJgwb/4s/ClRu7CVmH5BDOQdw/1FZLW9RD
	 FXYevtATHlUoLdfPCmlmn+26RWogaq6Y2aLBppyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 456/461] blk-mq: pop cached request if it is usable
Date: Thu, 28 May 2026 21:49:45 +0200
Message-ID: <20260528194700.739653674@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit dc278e9bf2b9513a763353e6b9cc21e0f532954e ]

When submitting a bio to blk-mq, if the task should sleep after peeking
a cached request, but before it pops it, the plug flushes and calls
blk_mq_free_plug_rqs, freeing the cached_rqs. This creates a
use-after-free bug. Fix this by popping the cached request before any
possible blocking calls if it is suitable for use.

Popping this request first holds a queue reference, so avoid any
serialization races with queue freezes and can safely proceed with
dispatching that request to the driver. This potentially increases a
timing window from when a driver wants to freeze its queue to when
requests stop being dispatched. That scenario is off the fast path
though, and drivers need to appropriately handle requests during a
freeze request anyway.

The downside is the popped element needs to be individually freed when
we performed a bio plug merge. The cached request would have had to be
freed later anyway, but this patch does it inline with building the plug
list instead of after flushing it.

Fixes: b0077e269f6c1 ("blk-mq: make sure active queue usage is held for bio_integrity_prep()")
Fixes: 7b4f36cd22a65 ("block: ensure we hold a queue reference when using queue limits")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Link: https://patch.msgid.link/20260521190253.242065-1-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7a7d8d536841d..39986a742b981 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3077,7 +3077,7 @@ static struct request *blk_mq_get_new_requests(struct request_queue *q,
 /*
  * Check if there is a suitable cached request and return it.
  */
-static struct request *blk_mq_peek_cached_request(struct blk_plug *plug,
+static struct request *blk_mq_get_cached_request(struct blk_plug *plug,
 		struct request_queue *q, blk_opf_t opf)
 {
 	enum hctx_type type = blk_mq_get_hctx_type(opf);
@@ -3093,27 +3093,10 @@ static struct request *blk_mq_peek_cached_request(struct blk_plug *plug,
 		return NULL;
 	if (op_is_flush(rq->cmd_flags) != op_is_flush(opf))
 		return NULL;
+	rq_list_pop(&plug->cached_rqs);
 	return rq;
 }
 
-static void blk_mq_use_cached_rq(struct request *rq, struct blk_plug *plug,
-		struct bio *bio)
-{
-	if (rq_list_pop(&plug->cached_rqs) != rq)
-		WARN_ON_ONCE(1);
-
-	/*
-	 * If any qos ->throttle() end up blocking, we will have flushed the
-	 * plug and hence killed the cached_rq list as well. Pop this entry
-	 * before we throttle.
-	 */
-	rq_qos_throttle(rq->q, bio);
-
-	blk_mq_rq_time_init(rq, blk_time_get_ns());
-	rq->cmd_flags = bio->bi_opf;
-	INIT_LIST_HEAD(&rq->queuelist);
-}
-
 static bool bio_unaligned(const struct bio *bio, struct request_queue *q)
 {
 	unsigned int bs_mask = queue_logical_block_size(q) - 1;
@@ -3151,7 +3134,7 @@ void blk_mq_submit_bio(struct bio *bio)
 	/*
 	 * If the plug has a cached request for this queue, try to use it.
 	 */
-	rq = blk_mq_peek_cached_request(plug, q, bio->bi_opf);
+	rq = blk_mq_get_cached_request(plug, q, bio->bi_opf);
 
 	/*
 	 * A BIO that was released from a zone write plug has already been
@@ -3209,7 +3192,10 @@ void blk_mq_submit_bio(struct bio *bio)
 
 new_request:
 	if (rq) {
-		blk_mq_use_cached_rq(rq, plug, bio);
+		rq_qos_throttle(rq->q, bio);
+		blk_mq_rq_time_init(rq, blk_time_get_ns());
+		rq->cmd_flags = bio->bi_opf;
+		INIT_LIST_HEAD(&rq->queuelist);
 	} else {
 		rq = blk_mq_get_new_requests(q, plug, bio);
 		if (unlikely(!rq)) {
@@ -3255,12 +3241,10 @@ void blk_mq_submit_bio(struct bio *bio)
 	return;
 
 queue_exit:
-	/*
-	 * Don't drop the queue reference if we were trying to use a cached
-	 * request and thus didn't acquire one.
-	 */
 	if (!rq)
 		blk_queue_exit(q);
+	else
+		blk_mq_free_request(rq);
 }
 
 #ifdef CONFIG_BLK_MQ_STACKING
-- 
2.53.0



