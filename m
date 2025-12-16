Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0643D349B16;
	Tue, 16 Dec 2025 11:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885175; cv=none; b=slqs8+eQzCLNWTZBi8yu8SCAOZjzzmvaZATpcMbwkUOgl/OWPPlgzX1Pvjr3DkaEESxFjr+fz//VoPPjbJyBo1iTsqEQEBCr2QeF/aNVZzbBnc9KezbLAzFccs9MUlVf+c/S+DyP1QNrcMKYTRB1pm4fz0vRSYo3t6wCkgapnVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885175; c=relaxed/simple;
	bh=o969EbC6k9nk2xrlNsWGr8+H2WKX+Ey6x9EELBysqbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZX4zz/DRzSQGi/ZX8A8QIVg++dApEpIQQeImgA8PXkPK2f5tVLPpvHgsthHeRod81B0IjqPFKCzIU14p6xolpjZyjsyIX6gpoCtIpi2x5j9E3OeelnRucRUFxI4rHRI0EftqxVM9BddjdEFlSGd5R2WjoCoxKddoD34I4fm73TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVpVUq1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVpVUq1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB0AC4CEF1;
	Tue, 16 Dec 2025 11:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885174;
	bh=o969EbC6k9nk2xrlNsWGr8+H2WKX+Ey6x9EELBysqbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVpVUq1jLQSo0zYNM0z9tPHFq08QqMbYbKPyBF+pCIu0hiISELNrhwEcaVxPjQrSO
	 +X8PwuwcyJ2xqf7pO/W6y69Z1uSdvANtKjZUXoqgD5iDnIOMOgg1E1qI851jhDI4It
	 XzNWlWqnLIMd3aIHXJ3IZIx6QIH2yzGc2VfA4nBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai@kernel.org>,
	chengkaitao <chengkaitao@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 059/507] block/mq-deadline: Switch back to a single dispatch list
Date: Tue, 16 Dec 2025 12:08:20 +0100
Message-ID: <20251216111347.680444255@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit d60055cf52703a705b86fb25b9b7931ec7ee399c ]

Commit c807ab520fc3 ("block/mq-deadline: Add I/O priority support")
modified the behavior of request flag BLK_MQ_INSERT_AT_HEAD from
dispatching a request before other requests into dispatching a request
before other requests with the same I/O priority. This is not correct since
BLK_MQ_INSERT_AT_HEAD is used when requeuing requests and also when a flush
request is inserted.  Both types of requests should be dispatched as soon
as possible. Hence, make the mq-deadline I/O scheduler again ignore the I/O
priority for BLK_MQ_INSERT_AT_HEAD requests.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Yu Kuai <yukuai@kernel.org>
Reported-by: chengkaitao <chengkaitao@kylinos.cn>
Closes: https://lore.kernel.org/linux-block/20251009155253.14611-1-pilgrimtao@gmail.com/
Fixes: c807ab520fc3 ("block/mq-deadline: Add I/O priority support")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moalv <dlemoal@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/mq-deadline.c | 107 +++++++++++++++++++-------------------------
 1 file changed, 47 insertions(+), 60 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 9d449503613d6..77250fcecb545 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -71,7 +71,6 @@ struct io_stats_per_prio {
  * present on both sort_list[] and fifo_list[].
  */
 struct dd_per_prio {
-	struct list_head dispatch;
 	struct rb_root sort_list[DD_DIR_COUNT];
 	struct list_head fifo_list[DD_DIR_COUNT];
 	/* Position of the most recently dispatched request. */
@@ -84,6 +83,7 @@ struct deadline_data {
 	 * run time data
 	 */
 
+	struct list_head dispatch;
 	struct dd_per_prio per_prio[DD_PRIO_COUNT];
 
 	/* Data direction of latest dispatched request. */
@@ -336,16 +336,6 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
 
 	lockdep_assert_held(&dd->lock);
 
-	if (!list_empty(&per_prio->dispatch)) {
-		rq = list_first_entry(&per_prio->dispatch, struct request,
-				      queuelist);
-		if (started_after(dd, rq, latest_start))
-			return NULL;
-		list_del_init(&rq->queuelist);
-		data_dir = rq_data_dir(rq);
-		goto done;
-	}
-
 	/*
 	 * batches are currently reads XOR writes
 	 */
@@ -425,7 +415,6 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
 	 */
 	dd->batching++;
 	deadline_move_request(dd, per_prio, rq);
-done:
 	return dd_start_request(dd, data_dir, rq);
 }
 
@@ -473,6 +462,14 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	enum dd_prio prio;
 
 	spin_lock(&dd->lock);
+
+	if (!list_empty(&dd->dispatch)) {
+		rq = list_first_entry(&dd->dispatch, struct request, queuelist);
+		list_del_init(&rq->queuelist);
+		dd_start_request(dd, rq_data_dir(rq), rq);
+		goto unlock;
+	}
+
 	rq = dd_dispatch_prio_aged_requests(dd, now);
 	if (rq)
 		goto unlock;
@@ -561,10 +558,10 @@ static int dd_init_sched(struct request_queue *q, struct elevator_queue *eq)
 
 	eq->elevator_data = dd;
 
+	INIT_LIST_HEAD(&dd->dispatch);
 	for (prio = 0; prio <= DD_PRIO_MAX; prio++) {
 		struct dd_per_prio *per_prio = &dd->per_prio[prio];
 
-		INIT_LIST_HEAD(&per_prio->dispatch);
 		INIT_LIST_HEAD(&per_prio->fifo_list[DD_READ]);
 		INIT_LIST_HEAD(&per_prio->fifo_list[DD_WRITE]);
 		per_prio->sort_list[DD_READ] = RB_ROOT;
@@ -668,7 +665,7 @@ static void dd_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 	trace_block_rq_insert(rq);
 
 	if (flags & BLK_MQ_INSERT_AT_HEAD) {
-		list_add(&rq->queuelist, &per_prio->dispatch);
+		list_add(&rq->queuelist, &dd->dispatch);
 		rq->fifo_time = jiffies;
 	} else {
 		deadline_add_rq_rb(per_prio, rq);
@@ -735,8 +732,7 @@ static void dd_finish_request(struct request *rq)
 
 static bool dd_has_work_for_prio(struct dd_per_prio *per_prio)
 {
-	return !list_empty_careful(&per_prio->dispatch) ||
-		!list_empty_careful(&per_prio->fifo_list[DD_READ]) ||
+	return !list_empty_careful(&per_prio->fifo_list[DD_READ]) ||
 		!list_empty_careful(&per_prio->fifo_list[DD_WRITE]);
 }
 
@@ -745,6 +741,9 @@ static bool dd_has_work(struct blk_mq_hw_ctx *hctx)
 	struct deadline_data *dd = hctx->queue->elevator->elevator_data;
 	enum dd_prio prio;
 
+	if (!list_empty_careful(&dd->dispatch))
+		return true;
+
 	for (prio = 0; prio <= DD_PRIO_MAX; prio++)
 		if (dd_has_work_for_prio(&dd->per_prio[prio]))
 			return true;
@@ -953,49 +952,39 @@ static int dd_owned_by_driver_show(void *data, struct seq_file *m)
 	return 0;
 }
 
-#define DEADLINE_DISPATCH_ATTR(prio)					\
-static void *deadline_dispatch##prio##_start(struct seq_file *m,	\
-					     loff_t *pos)		\
-	__acquires(&dd->lock)						\
-{									\
-	struct request_queue *q = m->private;				\
-	struct deadline_data *dd = q->elevator->elevator_data;		\
-	struct dd_per_prio *per_prio = &dd->per_prio[prio];		\
-									\
-	spin_lock(&dd->lock);						\
-	return seq_list_start(&per_prio->dispatch, *pos);		\
-}									\
-									\
-static void *deadline_dispatch##prio##_next(struct seq_file *m,		\
-					    void *v, loff_t *pos)	\
-{									\
-	struct request_queue *q = m->private;				\
-	struct deadline_data *dd = q->elevator->elevator_data;		\
-	struct dd_per_prio *per_prio = &dd->per_prio[prio];		\
-									\
-	return seq_list_next(v, &per_prio->dispatch, pos);		\
-}									\
-									\
-static void deadline_dispatch##prio##_stop(struct seq_file *m, void *v)	\
-	__releases(&dd->lock)						\
-{									\
-	struct request_queue *q = m->private;				\
-	struct deadline_data *dd = q->elevator->elevator_data;		\
-									\
-	spin_unlock(&dd->lock);						\
-}									\
-									\
-static const struct seq_operations deadline_dispatch##prio##_seq_ops = { \
-	.start	= deadline_dispatch##prio##_start,			\
-	.next	= deadline_dispatch##prio##_next,			\
-	.stop	= deadline_dispatch##prio##_stop,			\
-	.show	= blk_mq_debugfs_rq_show,				\
+static void *deadline_dispatch_start(struct seq_file *m, loff_t *pos)
+	__acquires(&dd->lock)
+{
+	struct request_queue *q = m->private;
+	struct deadline_data *dd = q->elevator->elevator_data;
+
+	spin_lock(&dd->lock);
+	return seq_list_start(&dd->dispatch, *pos);
 }
 
-DEADLINE_DISPATCH_ATTR(0);
-DEADLINE_DISPATCH_ATTR(1);
-DEADLINE_DISPATCH_ATTR(2);
-#undef DEADLINE_DISPATCH_ATTR
+static void *deadline_dispatch_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct request_queue *q = m->private;
+	struct deadline_data *dd = q->elevator->elevator_data;
+
+	return seq_list_next(v, &dd->dispatch, pos);
+}
+
+static void deadline_dispatch_stop(struct seq_file *m, void *v)
+	__releases(&dd->lock)
+{
+	struct request_queue *q = m->private;
+	struct deadline_data *dd = q->elevator->elevator_data;
+
+	spin_unlock(&dd->lock);
+}
+
+static const struct seq_operations deadline_dispatch_seq_ops = {
+	.start	= deadline_dispatch_start,
+	.next	= deadline_dispatch_next,
+	.stop	= deadline_dispatch_stop,
+	.show	= blk_mq_debugfs_rq_show,
+};
 
 #define DEADLINE_QUEUE_DDIR_ATTRS(name)					\
 	{#name "_fifo_list", 0400,					\
@@ -1018,9 +1007,7 @@ static const struct blk_mq_debugfs_attr deadline_queue_debugfs_attrs[] = {
 	{"batching", 0400, deadline_batching_show},
 	{"starved", 0400, deadline_starved_show},
 	{"async_depth", 0400, dd_async_depth_show},
-	{"dispatch0", 0400, .seq_ops = &deadline_dispatch0_seq_ops},
-	{"dispatch1", 0400, .seq_ops = &deadline_dispatch1_seq_ops},
-	{"dispatch2", 0400, .seq_ops = &deadline_dispatch2_seq_ops},
+	{"dispatch", 0400, .seq_ops = &deadline_dispatch_seq_ops},
 	{"owned_by_driver", 0400, dd_owned_by_driver_show},
 	{"queued", 0400, dd_queued_show},
 	{},
-- 
2.51.0



