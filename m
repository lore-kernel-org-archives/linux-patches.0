Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2FD3659F2;
	Tue, 16 Dec 2025 12:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887008; cv=none; b=WW9xopW8NN208YOLBQ3XIg+gHcy6uR3PX7049nohTmmTtnz5EdO4Qgm3h3KL3aFC9FckpD4LWJZTYhv+xieYqMh0aYBaAddxQky1+XOfJCTXsrpbyclDx9b9wyXLXKRvQm9P9DMBhObFxjgByLyl4BxeHPWThxyAjEIAmJA4nSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887008; c=relaxed/simple;
	bh=LnrKZNFklXuzNM9aJhmzx3mKvuGubwc5AiKHcJTCya8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICTXkGkbx+DUxExgzKcBmJ1TGQ7AOqzBnoYD+IGfwqSgqsDTxr0yuujprcA+R6nkb0dTqFuNz+L+u1y9fl0tPYSUUB0KI8uKJ5SJ1zJs78q7+69b0DRLDzIIOxQRivPWkKagxZYUYSMhT5SutuLXGfMx+ESiWjPcSQPxBJBSmI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TeIQC0W9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TeIQC0W9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A0EC19422;
	Tue, 16 Dec 2025 12:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887008;
	bh=LnrKZNFklXuzNM9aJhmzx3mKvuGubwc5AiKHcJTCya8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TeIQC0W91eGm+ttM78n6YVOsSpUFvxilDA019+4dfhOmpralHoeTASWmbxGvrGbf0
	 YhB2IiDOE1O6izCO+i+nocbiNswwoVzVBAuDKA+Xc1chst/DuNnkcQG011EwtnNPqr
	 ccbZuNibC2YKGGetQq3GiIgbe4qowD8qUM6/d/zk=
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
Subject: [PATCH 6.18 066/614] block/mq-deadline: Switch back to a single dispatch list
Date: Tue, 16 Dec 2025 12:07:13 +0100
Message-ID: <20251216111403.705908383@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index 647a45f6d9352..3e3719093aec7 100644
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
@@ -332,16 +332,6 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
 
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
@@ -421,7 +411,6 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
 	 */
 	dd->batching++;
 	deadline_move_request(dd, per_prio, rq);
-done:
 	return dd_start_request(dd, data_dir, rq);
 }
 
@@ -469,6 +458,14 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
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
@@ -557,10 +554,10 @@ static int dd_init_sched(struct request_queue *q, struct elevator_queue *eq)
 
 	eq->elevator_data = dd;
 
+	INIT_LIST_HEAD(&dd->dispatch);
 	for (prio = 0; prio <= DD_PRIO_MAX; prio++) {
 		struct dd_per_prio *per_prio = &dd->per_prio[prio];
 
-		INIT_LIST_HEAD(&per_prio->dispatch);
 		INIT_LIST_HEAD(&per_prio->fifo_list[DD_READ]);
 		INIT_LIST_HEAD(&per_prio->fifo_list[DD_WRITE]);
 		per_prio->sort_list[DD_READ] = RB_ROOT;
@@ -664,7 +661,7 @@ static void dd_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 	trace_block_rq_insert(rq);
 
 	if (flags & BLK_MQ_INSERT_AT_HEAD) {
-		list_add(&rq->queuelist, &per_prio->dispatch);
+		list_add(&rq->queuelist, &dd->dispatch);
 		rq->fifo_time = jiffies;
 	} else {
 		deadline_add_rq_rb(per_prio, rq);
@@ -731,8 +728,7 @@ static void dd_finish_request(struct request *rq)
 
 static bool dd_has_work_for_prio(struct dd_per_prio *per_prio)
 {
-	return !list_empty_careful(&per_prio->dispatch) ||
-		!list_empty_careful(&per_prio->fifo_list[DD_READ]) ||
+	return !list_empty_careful(&per_prio->fifo_list[DD_READ]) ||
 		!list_empty_careful(&per_prio->fifo_list[DD_WRITE]);
 }
 
@@ -741,6 +737,9 @@ static bool dd_has_work(struct blk_mq_hw_ctx *hctx)
 	struct deadline_data *dd = hctx->queue->elevator->elevator_data;
 	enum dd_prio prio;
 
+	if (!list_empty_careful(&dd->dispatch))
+		return true;
+
 	for (prio = 0; prio <= DD_PRIO_MAX; prio++)
 		if (dd_has_work_for_prio(&dd->per_prio[prio]))
 			return true;
@@ -949,49 +948,39 @@ static int dd_owned_by_driver_show(void *data, struct seq_file *m)
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
@@ -1014,9 +1003,7 @@ static const struct blk_mq_debugfs_attr deadline_queue_debugfs_attrs[] = {
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



