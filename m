Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028230;
	b=SC/A4lyz7KPSL2NrCxxrAfg4qFRUcrCZIaya9uU49Nx2ZPIQ1nxevCWTtT7deRimB2iz
	 3k2HY8UiZpd1pKkCyYl8p0gxdXwJEMX2yewmh3l+J0anVSbESXpIqCbnBB26nhnP0Ikgh
	 51vXV/IATQ3ab60S5wGgGY1hlBVm1z34YPNqa9DzvsN4x4Vo9I3Or0+5qlvBY2U1DOxUN
	 wJZlZCjUUb9pSykyAg5ictCwLbqPQg++P6+auM5aLpeAPYtMDTD6OTpZFqMrV0n0E1kET
	 YwTF/7T+gviJRog+4OkqxDiBKcn8TZx52efb8nEs5nX7RI0C+KNczQnioVJyr7pE7Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ddlNx2HxDHKtjcOThYSmag9juj07FpcX9QdUf9iCopk=;
	b=JWp5sUIWe6UuU74jg5ppwp5YHkPg6dTaXF4loyMr/9FtCDWAIqgvfnIYj1xpeJysPJEd
	 lj3JxifJ/XoQF76rybTHnruYLUQ/yrYmrUy8j8Bydqv9w6+gba81zUezEcOAIsEUNwjqZ
	 JT3x0aT7vaFcEzRmjKGOijLo/9/DN69cm4Wqt43Z8xJcXd1hqYPNMi0VUOlUjkzNGiE3A
	 xlHX9pVx6Nkwzo/II1mig+fYnGXmpDHbVB5QCkKoG+9p5KSQj4JVUeQYHvchaO5AqFxjg
	 MqBAebb9ddEOo1MOBwEHVenwhLBEtaETs2i5f3PS8EZIKB05Xz9IaPqHpL3t5mOaT0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ioIoYsiy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD03606A31C;
	Wed, 18 Nov 2026 18:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ioIoYsiy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5351B1F000C4;
	Wed, 18 Nov 2026 18:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028229;
	bh=ddlNx2HxDHKtjcOThYSmag9juj07FpcX9QdUf9iCopk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ioIoYsiyBHnNpKWKvORkLR0KiCTDeemKxbOo7HtO5OFuZerSAWj0GKRM1ldSOBiW/
	 GgQOcNazjhmPiwL0CLkHqXbHOxk1lH+4MmYX2UYdRhibtPngO5ECsFdPGrKajB2IDZ
	 Vr5ZOdAAI9tTNSyOnPNAMd57Y40qgl/7k3wzaEJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fengnan Chang <changfengnan@bytedance.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2071/2151] blk-mq: use array manage hctx map instead of xarray
Date: Wed, 18 Nov 2026 16:03:26 +0100
Message-ID: <20261118150237.161151646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fengnan Chang <fengnanchang@gmail.com>

[ Upstream commit d0c98769ee7d5db8d699a270690639cde1766cd4 ]

After commit 4e5cc99e1e48 ("blk-mq: manage hctx map via xarray"), we use
an xarray instead of array to store hctx, but in poll mode, each time
in blk_mq_poll, we need use xa_load to find corresponding hctx, this
introduce some costs. In my test, xa_load may cost 3.8% cpu.

This patch revert previous change, eliminates the overhead of xa_load
and can result in a 3% performance improvement.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 24974185999f ("blk-mq: don't trust the cookie in blk_mq_poll()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-tag.c     |  2 +-
 block/blk-mq.c         | 58 +++++++++++++++++++++++++++---------------
 block/blk-mq.h         |  2 +-
 include/linux/blk-mq.h |  3 ++-
 include/linux/blkdev.h |  2 +-
 5 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 496da16f6f4f5..d168c0a080e3c 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -506,7 +506,7 @@ void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_tag_iter_fn *fn,
 	int srcu_idx;
 
 	/*
-	 * __blk_mq_update_nr_hw_queues() updates nr_hw_queues and hctx_table
+	 * __blk_mq_update_nr_hw_queues() updates nr_hw_queues and queue_hw_ctx
 	 * while the queue is frozen. So we can use q_usage_counter to avoid
 	 * racing with it.
 	 */
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 833e70af63b0d..e0dfae0e20d58 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -753,7 +753,7 @@ struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
 	 * If not tell the caller that it should skip this queue.
 	 */
 	ret = -EXDEV;
-	data.hctx = xa_load(&q->hctx_table, hctx_idx);
+	data.hctx = q->queue_hw_ctx[hctx_idx];
 	if (!blk_mq_hw_queue_mapped(data.hctx))
 		goto out_queue_exit;
 	cpu = cpumask_first_and(data.hctx->cpumask, cpu_online_mask);
@@ -3985,8 +3985,6 @@ static void blk_mq_exit_hctx(struct request_queue *q,
 			blk_free_flush_queue_callback);
 	hctx->fq = NULL;
 
-	xa_erase(&q->hctx_table, hctx_idx);
-
 	spin_lock(&q->unused_hctx_lock);
 	list_add(&hctx->hctx_list, &q->unused_hctx_list);
 	spin_unlock(&q->unused_hctx_lock);
@@ -4029,14 +4027,8 @@ static int blk_mq_init_hctx(struct request_queue *q,
 				hctx->numa_node))
 		goto exit_hctx;
 
-	if (xa_insert(&q->hctx_table, hctx_idx, hctx, GFP_KERNEL))
-		goto exit_flush_rq;
-
 	return 0;
 
- exit_flush_rq:
-	if (set->ops->exit_request)
-		set->ops->exit_request(set, hctx->fq->flush_rq, hctx_idx);
  exit_hctx:
 	if (set->ops->exit_hctx)
 		set->ops->exit_hctx(hctx, hctx_idx);
@@ -4424,7 +4416,7 @@ void blk_mq_release(struct request_queue *q)
 		kobject_put(&hctx->kobj);
 	}
 
-	xa_destroy(&q->hctx_table);
+	kfree(q->queue_hw_ctx);
 
 	/*
 	 * release .mq_kobj and sw queue's kobject now because
@@ -4568,26 +4560,44 @@ static struct blk_mq_hw_ctx *blk_mq_alloc_and_init_hctx(
 static void __blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
 				     struct request_queue *q)
 {
-	struct blk_mq_hw_ctx *hctx;
-	unsigned long i, j;
+	int i, j, end;
+	struct blk_mq_hw_ctx **hctxs = q->queue_hw_ctx;
+
+	if (q->nr_hw_queues < set->nr_hw_queues) {
+		struct blk_mq_hw_ctx **new_hctxs;
+
+		new_hctxs = kcalloc_node(set->nr_hw_queues,
+				       sizeof(*new_hctxs), GFP_KERNEL,
+				       set->numa_node);
+		if (!new_hctxs)
+			return;
+		if (hctxs)
+			memcpy(new_hctxs, hctxs, q->nr_hw_queues *
+			       sizeof(*hctxs));
+		q->queue_hw_ctx = new_hctxs;
+		kfree(hctxs);
+		hctxs = new_hctxs;
+	}
 
 	for (i = 0; i < set->nr_hw_queues; i++) {
 		int old_node;
 		int node = blk_mq_get_hctx_node(set, i);
-		struct blk_mq_hw_ctx *old_hctx = xa_load(&q->hctx_table, i);
+		struct blk_mq_hw_ctx *old_hctx = hctxs[i];
 
 		if (old_hctx) {
 			old_node = old_hctx->numa_node;
 			blk_mq_exit_hctx(q, set, old_hctx, i);
 		}
 
-		if (!blk_mq_alloc_and_init_hctx(set, q, i, node)) {
+		hctxs[i] = blk_mq_alloc_and_init_hctx(set, q, i, node);
+		if (!hctxs[i]) {
 			if (!old_hctx)
 				break;
 			pr_warn("Allocate new hctx on node %d fails, fallback to previous one on node %d\n",
 					node, old_node);
-			hctx = blk_mq_alloc_and_init_hctx(set, q, i, old_node);
-			WARN_ON_ONCE(!hctx);
+			hctxs[i] = blk_mq_alloc_and_init_hctx(set, q, i,
+					old_node);
+			WARN_ON_ONCE(!hctxs[i]);
 		}
 	}
 	/*
@@ -4596,13 +4606,21 @@ static void __blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
 	 */
 	if (i != set->nr_hw_queues) {
 		j = q->nr_hw_queues;
+		end = i;
 	} else {
 		j = i;
+		end = q->nr_hw_queues;
 		q->nr_hw_queues = set->nr_hw_queues;
 	}
 
-	xa_for_each_start(&q->hctx_table, j, hctx, j)
-		blk_mq_exit_hctx(q, set, hctx, j);
+	for (; j < end; j++) {
+		struct blk_mq_hw_ctx *hctx = hctxs[j];
+
+		if (hctx) {
+			blk_mq_exit_hctx(q, set, hctx, j);
+			hctxs[j] = NULL;
+		}
+	}
 }
 
 static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
@@ -4638,8 +4656,6 @@ int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	INIT_LIST_HEAD(&q->unused_hctx_list);
 	spin_lock_init(&q->unused_hctx_lock);
 
-	xa_init(&q->hctx_table);
-
 	blk_mq_realloc_hw_ctxs(set, q);
 	if (!q->nr_hw_queues)
 		goto err_hctxs;
@@ -5234,7 +5250,7 @@ int blk_mq_poll(struct request_queue *q, blk_qc_t cookie,
 {
 	if (!blk_mq_can_poll(q))
 		return 0;
-	return blk_hctx_poll(q, xa_load(&q->hctx_table, cookie), iob, flags);
+	return blk_hctx_poll(q, q->queue_hw_ctx[cookie], iob, flags);
 }
 
 int blk_rq_poll(struct request *rq, struct io_comp_batch *iob,
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 01d8ef8a4d460..ba1b43e7c54d6 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -84,7 +84,7 @@ static inline struct blk_mq_hw_ctx *blk_mq_map_queue_type(struct request_queue *
 							  enum hctx_type type,
 							  unsigned int cpu)
 {
-	return xa_load(&q->hctx_table, q->tag_set->map[type].mq_map[cpu]);
+	return q->queue_hw_ctx[q->tag_set->map[type].mq_map[cpu]];
 }
 
 static inline enum hctx_type blk_mq_get_hctx_type(blk_opf_t opf)
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index dffc1e3ceb8f1..0a1d40b8472e0 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -1013,7 +1013,8 @@ static inline void *blk_mq_rq_to_pdu(struct request *rq)
 }
 
 #define queue_for_each_hw_ctx(q, hctx, i)				\
-	xa_for_each(&(q)->hctx_table, (i), (hctx))
+	for ((i) = 0; (i) < (q)->nr_hw_queues &&			\
+	     ({ hctx = (q)->queue_hw_ctx[i]; 1; }); (i)++)
 
 #define hctx_for_each_ctx(hctx, ctx, i)					\
 	for ((i) = 0; (i) < (hctx)->nr_ctx &&				\
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bc07637aef4bb..0299d62886ed1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -497,7 +497,7 @@ struct request_queue {
 
 	/* hw dispatch queues */
 	unsigned int		nr_hw_queues;
-	struct xarray		hctx_table;
+	struct blk_mq_hw_ctx	**queue_hw_ctx;
 
 	struct percpu_ref	q_usage_counter;
 	struct lock_class_key	io_lock_cls_key;
-- 
2.53.0



