Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA881312817;
	Mon, 13 Oct 2025 15:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369201; cv=none; b=CN21PXVGXuxztr0gp3XDv/HsoyCHuEs1aDqaSZQAFQV7t/F/O1i/IO8NVP71OJWJQTSYVgAiJQHs2g+feMJS29hX3EZ1sA17hf2qvVTew5oT7krq2YilyMFdE64dU8eJFIfxCFbZKNiq9YRl7wE5pjtv/ajDL+n4SZ2jM8Hj9Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369201; c=relaxed/simple;
	bh=dp+w5aHiI/7jsKmb50cYn+QAbGqGgqj2iC34Zd/sqPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scaQGdWj431ky4p4d+LIRaSN7IzBzM67daWLptV2fN/nuuvwIWG1iBEFZqd6jXIMMp2NSJa1dh2FJ0f12VWfXYLTdkPAOBR3bZBvLMXKB/N5d00hDyWOZw5Fm0DzqsQtAYap6MQYd4zszjnSGklFKTPlVoncweO3YhDKW01U1uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hxq7Q0NW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hxq7Q0NW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A0AC4CEE7;
	Mon, 13 Oct 2025 15:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369201;
	bh=dp+w5aHiI/7jsKmb50cYn+QAbGqGgqj2iC34Zd/sqPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hxq7Q0NW4VquXBW5wrNNOIluIBppX0HUyuibIGatibTiqOAbF0XPOF6XyyhYcSWFj
	 cGwAA6UzBuuL2/S+4NcJhGksNlyT3IWADwbar2W4aUVJ2aV3dfH17VQ1laI1a+9S1T
	 XTeItODRMr7eoBc6uANtqTudIcM73SKWk8DiJvEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 130/563] blk-mq-sched: add new parameter nr_requests in blk_mq_alloc_sched_tags()
Date: Mon, 13 Oct 2025 16:39:51 +0200
Message-ID: <20251013144416.003922747@linuxfoundation.org>
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

[ Upstream commit 6293e336f6d7d3f3415346ce34993b3398846166 ]

This helper only support to allocate the default number of requests,
add a new parameter to support specific number of requests.

Prepare to fix potential deadlock in the case nr_requests grow.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: b86433721f46 ("blk-mq: fix potential deadlock while nr_requests grown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-sched.c | 14 +++++---------
 block/blk-mq-sched.h |  2 +-
 block/blk-mq.h       | 11 +++++++++++
 block/elevator.c     |  3 ++-
 4 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index e2ce4a28e6c9e..d06bb137a7437 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -454,7 +454,7 @@ void blk_mq_free_sched_tags_batch(struct xarray *et_table,
 }
 
 struct elevator_tags *blk_mq_alloc_sched_tags(struct blk_mq_tag_set *set,
-		unsigned int nr_hw_queues)
+		unsigned int nr_hw_queues, unsigned int nr_requests)
 {
 	unsigned int nr_tags;
 	int i;
@@ -470,13 +470,8 @@ struct elevator_tags *blk_mq_alloc_sched_tags(struct blk_mq_tag_set *set,
 			nr_tags * sizeof(struct blk_mq_tags *), gfp);
 	if (!et)
 		return NULL;
-	/*
-	 * Default to double of smaller one between hw queue_depth and
-	 * 128, since we don't split into sync/async like the old code
-	 * did. Additionally, this is a per-hw queue depth.
-	 */
-	et->nr_requests = 2 * min_t(unsigned int, set->queue_depth,
-			BLKDEV_DEFAULT_RQ);
+
+	et->nr_requests = nr_requests;
 	et->nr_hw_queues = nr_hw_queues;
 
 	if (blk_mq_is_shared_tags(set->flags)) {
@@ -521,7 +516,8 @@ int blk_mq_alloc_sched_tags_batch(struct xarray *et_table,
 		 * concurrently.
 		 */
 		if (q->elevator) {
-			et = blk_mq_alloc_sched_tags(set, nr_hw_queues);
+			et = blk_mq_alloc_sched_tags(set, nr_hw_queues,
+					blk_mq_default_nr_requests(set));
 			if (!et)
 				goto out_unwind;
 			if (xa_insert(et_table, q->id, et, gfp))
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index fe83187f41db4..8e21a6b1415d9 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -24,7 +24,7 @@ void blk_mq_exit_sched(struct request_queue *q, struct elevator_queue *e);
 void blk_mq_sched_free_rqs(struct request_queue *q);
 
 struct elevator_tags *blk_mq_alloc_sched_tags(struct blk_mq_tag_set *set,
-		unsigned int nr_hw_queues);
+		unsigned int nr_hw_queues, unsigned int nr_requests);
 int blk_mq_alloc_sched_tags_batch(struct xarray *et_table,
 		struct blk_mq_tag_set *set, unsigned int nr_hw_queues);
 void blk_mq_free_sched_tags(struct elevator_tags *et,
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 2b3ade60c90b2..731f4578d9a84 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -109,6 +109,17 @@ static inline struct blk_mq_hw_ctx *blk_mq_map_queue(blk_opf_t opf,
 	return ctx->hctxs[blk_mq_get_hctx_type(opf)];
 }
 
+/*
+ * Default to double of smaller one between hw queue_depth and
+ * 128, since we don't split into sync/async like the old code
+ * did. Additionally, this is a per-hw queue depth.
+ */
+static inline unsigned int blk_mq_default_nr_requests(
+		struct blk_mq_tag_set *set)
+{
+	return 2 * min_t(unsigned int, set->queue_depth, BLKDEV_DEFAULT_RQ);
+}
+
 /*
  * sysfs helpers
  */
diff --git a/block/elevator.c b/block/elevator.c
index fe96c6f4753ca..e2ebfbf107b3a 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -669,7 +669,8 @@ static int elevator_change(struct request_queue *q, struct elv_change_ctx *ctx)
 	lockdep_assert_held(&set->update_nr_hwq_lock);
 
 	if (strncmp(ctx->name, "none", 4)) {
-		ctx->et = blk_mq_alloc_sched_tags(set, set->nr_hw_queues);
+		ctx->et = blk_mq_alloc_sched_tags(set, set->nr_hw_queues,
+				blk_mq_default_nr_requests(set));
 		if (!ctx->et)
 			return -ENOMEM;
 	}
-- 
2.51.0



