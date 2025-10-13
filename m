Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2869730C635;
	Mon, 13 Oct 2025 15:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369098; cv=none; b=hkNQqRHVue4ZGsjtc08vWxx2Y9D0gRayfHvvnHj26pHv9xa5uvDjpFCBADYLdzfB972FYtb5pOGsP+iaqfRgEXIfHYwb5chjwrrMHL3faVKayazC3hqvsNIuwvLuuPZVkuwm2ninWFrCzbzSsslEGyMUHFaKyIgt6z7k/qzBm8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369098; c=relaxed/simple;
	bh=vxM95Ma6qH5ekYN7tDYiz67cYN9COvSttdbUnV0uZ54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGA0/JbAsigDNrfXU8Bg3TB0pVLUM6FniKoifX3uQgYkUSQ5zbtJi0rn3QiBQLVCAfzXqhiM4Mc62xK5DbUA/ofxO3s/Vqnlb1HzPrrEcMdhm3X/dfRWLahFwH3YrRdy19lstdnxrnB4AGQr3zFWwD95mBJ8kh28Yljy2TYO3Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQ5zDK8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQ5zDK8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9538C4CEE7;
	Mon, 13 Oct 2025 15:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369098;
	bh=vxM95Ma6qH5ekYN7tDYiz67cYN9COvSttdbUnV0uZ54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQ5zDK8y8WQkF2kJoSucZkegwrl7docMkOhPexmikBpb6BQEvu4xjN6+QHbinpzCz
	 nsI7NMPrnK18b7QlyAUlwcJ0NgNElJ3ALnFmjJrKMLgYiUIxHBdizAqRkOWv4txi6G
	 yEfODH949wytOtCtwgUw4aTnn2IsdEGmybwYqluY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Hannes Reinecke <hare@suse.de>,
	Li Nan <linan122@huawei.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 094/563] blk-mq: fix elevator depth_updated method
Date: Mon, 13 Oct 2025 16:39:15 +0200
Message-ID: <20251013144414.701352319@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 7d337eef4affc5e26e0570513168c69ddbc40f92 ]

Current depth_updated has some problems:

1) depth_updated() will be called for each hctx, while all elevators
will update async_depth for the disk level, this is not related to hctx;
2) In blk_mq_update_nr_requests(), if previous hctx update succeed and
this hctx update failed, q->nr_requests will not be updated, while
async_depth is already updated with new nr_reqeuests in previous
depth_updated();
3) All elevators are using q->nr_requests to calculate async_depth now,
however, q->nr_requests is still the old value when depth_updated() is
called from blk_mq_update_nr_requests();

Those problems are first from error path, then mq-deadline, and recently
for bfq and kyber, fix those problems by:

- pass in request_queue instead of hctx;
- move depth_updated() after q->nr_requests is updated in
  blk_mq_update_nr_requests();
- add depth_updated() call inside init_sched() method to initialize
  async_depth;
- remove init_hctx() method for mq-deadline and bfq that is useless now;

Fixes: 77f1e0a52d26 ("bfq: update internal depth state when queue depth changes")
Fixes: 39823b47bbd4 ("block/mq-deadline: Fix the tag reservation code")
Fixes: 42e6c6ce03fd ("lib/sbitmap: convert shallow_depth from one word to the whole sbitmap")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Li Nan <linan122@huawei.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://lore.kernel.org/r/20250821060612.1729939-2-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c   | 22 +++++-----------------
 block/blk-mq-sched.h  | 11 +++++++++++
 block/blk-mq.c        | 23 ++++++++++++-----------
 block/elevator.h      |  2 +-
 block/kyber-iosched.c | 19 +++++++++----------
 block/mq-deadline.c   | 16 +++-------------
 6 files changed, 41 insertions(+), 52 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 50e51047e1fe5..4a8d3d96bfe49 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -7109,9 +7109,10 @@ void bfq_put_async_queues(struct bfq_data *bfqd, struct bfq_group *bfqg)
  * See the comments on bfq_limit_depth for the purpose of
  * the depths set in the function. Return minimum shallow depth we'll use.
  */
-static void bfq_update_depths(struct bfq_data *bfqd, struct sbitmap_queue *bt)
+static void bfq_depth_updated(struct request_queue *q)
 {
-	unsigned int nr_requests = bfqd->queue->nr_requests;
+	struct bfq_data *bfqd = q->elevator->elevator_data;
+	unsigned int nr_requests = q->nr_requests;
 
 	/*
 	 * In-word depths if no bfq_queue is being weight-raised:
@@ -7143,21 +7144,8 @@ static void bfq_update_depths(struct bfq_data *bfqd, struct sbitmap_queue *bt)
 	bfqd->async_depths[1][0] = max((nr_requests * 3) >> 4, 1U);
 	/* no more than ~37% of tags for sync writes (~20% extra tags) */
 	bfqd->async_depths[1][1] = max((nr_requests * 6) >> 4, 1U);
-}
-
-static void bfq_depth_updated(struct blk_mq_hw_ctx *hctx)
-{
-	struct bfq_data *bfqd = hctx->queue->elevator->elevator_data;
-	struct blk_mq_tags *tags = hctx->sched_tags;
 
-	bfq_update_depths(bfqd, &tags->bitmap_tags);
-	sbitmap_queue_min_shallow_depth(&tags->bitmap_tags, 1);
-}
-
-static int bfq_init_hctx(struct blk_mq_hw_ctx *hctx, unsigned int index)
-{
-	bfq_depth_updated(hctx);
-	return 0;
+	blk_mq_set_min_shallow_depth(q, 1);
 }
 
 static void bfq_exit_queue(struct elevator_queue *e)
@@ -7369,6 +7357,7 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_queue *eq)
 		goto out_free;
 	bfq_init_root_group(bfqd->root_group, bfqd);
 	bfq_init_entity(&bfqd->oom_bfqq.entity, bfqd->root_group);
+	bfq_depth_updated(q);
 
 	/* We dispatch from request queue wide instead of hw queue */
 	blk_queue_flag_set(QUEUE_FLAG_SQ_SCHED, q);
@@ -7628,7 +7617,6 @@ static struct elevator_type iosched_bfq_mq = {
 		.request_merged		= bfq_request_merged,
 		.has_work		= bfq_has_work,
 		.depth_updated		= bfq_depth_updated,
-		.init_hctx		= bfq_init_hctx,
 		.init_sched		= bfq_init_queue,
 		.exit_sched		= bfq_exit_queue,
 	},
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index b554e1d559508..fe83187f41db4 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -92,4 +92,15 @@ static inline bool blk_mq_sched_needs_restart(struct blk_mq_hw_ctx *hctx)
 	return test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
 }
 
+static inline void blk_mq_set_min_shallow_depth(struct request_queue *q,
+						unsigned int depth)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned long i;
+
+	queue_for_each_hw_ctx(q, hctx, i)
+		sbitmap_queue_min_shallow_depth(&hctx->sched_tags->bitmap_tags,
+						depth);
+}
+
 #endif
diff --git a/block/blk-mq.c b/block/blk-mq.c
index ba3a4b77f5786..9055cd6247004 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4951,20 +4951,21 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 						      false);
 		}
 		if (ret)
-			break;
-		if (q->elevator && q->elevator->type->ops.depth_updated)
-			q->elevator->type->ops.depth_updated(hctx);
+			goto out;
 	}
-	if (!ret) {
-		q->nr_requests = nr;
-		if (blk_mq_is_shared_tags(set->flags)) {
-			if (q->elevator)
-				blk_mq_tag_update_sched_shared_tags(q);
-			else
-				blk_mq_tag_resize_shared_tags(set, nr);
-		}
+
+	q->nr_requests = nr;
+	if (q->elevator && q->elevator->type->ops.depth_updated)
+		q->elevator->type->ops.depth_updated(q);
+
+	if (blk_mq_is_shared_tags(set->flags)) {
+		if (q->elevator)
+			blk_mq_tag_update_sched_shared_tags(q);
+		else
+			blk_mq_tag_resize_shared_tags(set, nr);
 	}
 
+out:
 	blk_mq_unquiesce_queue(q);
 
 	return ret;
diff --git a/block/elevator.h b/block/elevator.h
index adc5c157e17e5..c4d20155065e8 100644
--- a/block/elevator.h
+++ b/block/elevator.h
@@ -37,7 +37,7 @@ struct elevator_mq_ops {
 	void (*exit_sched)(struct elevator_queue *);
 	int (*init_hctx)(struct blk_mq_hw_ctx *, unsigned int);
 	void (*exit_hctx)(struct blk_mq_hw_ctx *, unsigned int);
-	void (*depth_updated)(struct blk_mq_hw_ctx *);
+	void (*depth_updated)(struct request_queue *);
 
 	bool (*allow_merge)(struct request_queue *, struct request *, struct bio *);
 	bool (*bio_merge)(struct request_queue *, struct bio *, unsigned int);
diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index 70cbc7b2deb40..18efd6ef2a2b9 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -399,6 +399,14 @@ static struct kyber_queue_data *kyber_queue_data_alloc(struct request_queue *q)
 	return ERR_PTR(ret);
 }
 
+static void kyber_depth_updated(struct request_queue *q)
+{
+	struct kyber_queue_data *kqd = q->elevator->elevator_data;
+
+	kqd->async_depth = q->nr_requests * KYBER_ASYNC_PERCENT / 100U;
+	blk_mq_set_min_shallow_depth(q, kqd->async_depth);
+}
+
 static int kyber_init_sched(struct request_queue *q, struct elevator_queue *eq)
 {
 	struct kyber_queue_data *kqd;
@@ -413,6 +421,7 @@ static int kyber_init_sched(struct request_queue *q, struct elevator_queue *eq)
 
 	eq->elevator_data = kqd;
 	q->elevator = eq;
+	kyber_depth_updated(q);
 
 	return 0;
 }
@@ -440,15 +449,6 @@ static void kyber_ctx_queue_init(struct kyber_ctx_queue *kcq)
 		INIT_LIST_HEAD(&kcq->rq_list[i]);
 }
 
-static void kyber_depth_updated(struct blk_mq_hw_ctx *hctx)
-{
-	struct kyber_queue_data *kqd = hctx->queue->elevator->elevator_data;
-	struct blk_mq_tags *tags = hctx->sched_tags;
-
-	kqd->async_depth = hctx->queue->nr_requests * KYBER_ASYNC_PERCENT / 100U;
-	sbitmap_queue_min_shallow_depth(&tags->bitmap_tags, kqd->async_depth);
-}
-
 static int kyber_init_hctx(struct blk_mq_hw_ctx *hctx, unsigned int hctx_idx)
 {
 	struct kyber_hctx_data *khd;
@@ -493,7 +493,6 @@ static int kyber_init_hctx(struct blk_mq_hw_ctx *hctx, unsigned int hctx_idx)
 	khd->batching = 0;
 
 	hctx->sched_data = khd;
-	kyber_depth_updated(hctx);
 
 	return 0;
 
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index b9b7cdf1d3c98..2e689b2c40213 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -507,22 +507,12 @@ static void dd_limit_depth(blk_opf_t opf, struct blk_mq_alloc_data *data)
 }
 
 /* Called by blk_mq_update_nr_requests(). */
-static void dd_depth_updated(struct blk_mq_hw_ctx *hctx)
+static void dd_depth_updated(struct request_queue *q)
 {
-	struct request_queue *q = hctx->queue;
 	struct deadline_data *dd = q->elevator->elevator_data;
-	struct blk_mq_tags *tags = hctx->sched_tags;
 
 	dd->async_depth = q->nr_requests;
-
-	sbitmap_queue_min_shallow_depth(&tags->bitmap_tags, 1);
-}
-
-/* Called by blk_mq_init_hctx() and blk_mq_init_sched(). */
-static int dd_init_hctx(struct blk_mq_hw_ctx *hctx, unsigned int hctx_idx)
-{
-	dd_depth_updated(hctx);
-	return 0;
+	blk_mq_set_min_shallow_depth(q, 1);
 }
 
 static void dd_exit_sched(struct elevator_queue *e)
@@ -587,6 +577,7 @@ static int dd_init_sched(struct request_queue *q, struct elevator_queue *eq)
 	blk_queue_flag_set(QUEUE_FLAG_SQ_SCHED, q);
 
 	q->elevator = eq;
+	dd_depth_updated(q);
 	return 0;
 }
 
@@ -1048,7 +1039,6 @@ static struct elevator_type mq_deadline = {
 		.has_work		= dd_has_work,
 		.init_sched		= dd_init_sched,
 		.exit_sched		= dd_exit_sched,
-		.init_hctx		= dd_init_hctx,
 	},
 
 #ifdef CONFIG_BLK_DEBUG_FS
-- 
2.51.0



