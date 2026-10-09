Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC99F3431F8;
	Fri,  9 Oct 2026 14:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555595; cv=none; b=BE+6s6eNg9Tt9LFamKBwElJBBJOoYpyJNvmflHI+f7GcblApcBK+JL59QWmT8cmwAeSTIhjyQlxYvzJz8sLaO6d764x3RQ/YqKLRNBmK0lwhWXa2rAMtL85Zm51URuBWnNg9i4DwD4/BIMUz3fTbJvL/ioNKp/zdvki4MKyrORM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555595; c=relaxed/simple;
	bh=tACkVjkqsnSV+yAF0x5FQBACN7gHBG7kAM056Cbpms0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uN0MV6f4EKXSyIS6xiuOS71XvZteO6jm8fTqc/w6ZDdl68AyqPZZvxvpFA/xHDUO8XajJSbxZ88+vZrLEavr8qxG9zv9+71SKee1SCueGt33REA0vXOtRrYcoFF1aKuAMnftVgzFVw+mrzMkhO+wFeTup0flZRC4agwkoGYf4pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFeFVBLH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFeFVBLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154471F00893;
	Fri,  9 Oct 2026 14:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555591;
	bh=9kKowbD1/hkigffW+6CjqMUpuO80h3KFhgnlq7TzNvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NFeFVBLHT/dGVuunUD/B07GZOZ2V/bmxOgecY5apcgi4l8rqQifJEf4rFdJbVs1kI
	 xHY+J7DtNYDpG+3urMuMOKyduvwiy4/kAK2EJiA440MsxA/5vKJzZhhMqmMDbD0Vsz
	 6E3WqDvoVG/nZOb06On8euYGcPEdcfzUS7rcgqqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Hu <huhai@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/403] blk-mq: set RQF_USE_SCHED when the operation is known
Date: Fri,  9 Oct 2026 16:07:25 +0200
Message-ID: <20261009140954.057836176@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

[ Upstream commit ab6c756f28c741d704a7c3e04814bfc3adf6f818 ]

The cached requests are allocated for one operation but can be handed
out for another. A passthrough command has RQF_USE_SCHED cleared, so
using those flags for a subsequent read/write bio will insert it into
the scheduler without ->prepare_request() and frees it without
->finish_request(). For kyber, this leaks the domain token acquired at
dispatch and stalls the queue.

Don't set RQF_USE_SCHED based on the first operation the batch happened
to be allocated for. Instead, set it after the request is claimed by an
operation. Introduce a helper function, blk_mq_rq_late_init() for this,
and absorb blk_mq_rq_time_init() since the two run together.

Fixes: 4b6a5d9cea91 ("block: enable batched allocation for blk_mq_alloc_request()")
Link: https://lore.kernel.org/linux-block/20260916151655.2588-1-15815827059@163.com/
Reported-by: Henry Hu <huhai@kylinos.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260922172711.1573186-1-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c      | 59 ++++++++++++++++++++++++++++-----------------
 block/mq-deadline.c |  2 +-
 2 files changed, 38 insertions(+), 23 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d9a7e04ad1794..ba0c48d58e134 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -447,16 +447,6 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 	WRITE_ONCE(rq->deadline, 0);
 	req_ref_set(rq, 1);
 
-	if (rq->rq_flags & RQF_USE_SCHED) {
-		struct elevator_queue *e = data->q->elevator;
-
-		INIT_HLIST_NODE(&rq->hash);
-		RB_CLEAR_NODE(&rq->rb_node);
-
-		if (e->type->ops.prepare_request)
-			e->type->ops.prepare_request(rq);
-	}
-
 	return rq;
 }
 
@@ -493,6 +483,12 @@ __blk_mq_alloc_requests_batch(struct blk_mq_alloc_data *data)
 	return rq_list_pop(data->cached_rqs);
 }
 
+static bool blk_op_bypass_sched(blk_opf_t opf)
+{
+	return (opf & REQ_OP_MASK) == REQ_OP_FLUSH ||
+	       blk_op_is_passthrough(opf);
+}
+
 static void blk_mq_limit_depth(struct blk_mq_alloc_data *data)
 {
 	struct elevator_mq_ops *ops;
@@ -513,12 +509,10 @@ static void blk_mq_limit_depth(struct blk_mq_alloc_data *data)
 	 * Flush/passthrough requests are special and go directly to the
 	 * dispatch list, they are not subject to the async_depth limit.
 	 */
-	if ((data->cmd_flags & REQ_OP_MASK) == REQ_OP_FLUSH ||
-	    blk_op_is_passthrough(data->cmd_flags))
+	if (blk_op_bypass_sched(data->cmd_flags))
 		return;
 
 	WARN_ON_ONCE(data->flags & BLK_MQ_REQ_RESERVED);
-	data->rq_flags |= RQF_USE_SCHED;
 
 	/*
 	 * By default, sync requests have no limit, and async requests are
@@ -529,6 +523,29 @@ static void blk_mq_limit_depth(struct blk_mq_alloc_data *data)
 		ops->limit_depth(data->cmd_flags, data);
 }
 
+/*
+ * Finish initializing a request once it has been claimed for an operation.
+ * Cached requests are allocated before that operation is known.
+ */
+static void blk_mq_rq_late_init(struct request *rq, u64 alloc_time_ns)
+{
+	struct elevator_queue *e;
+
+	blk_mq_rq_time_init(rq, alloc_time_ns);
+
+	if (!(rq->rq_flags & RQF_SCHED_TAGS) || (rq->rq_flags & RQF_RESV) ||
+	    blk_op_bypass_sched(rq->cmd_flags))
+		return;
+
+	rq->rq_flags |= RQF_USE_SCHED;
+	INIT_HLIST_NODE(&rq->hash);
+	RB_CLEAR_NODE(&rq->rb_node);
+
+	e = rq->q->elevator;
+	if (e->type->ops.prepare_request)
+		e->type->ops.prepare_request(rq);
+}
+
 static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
 {
 	struct request_queue *q = data->q;
@@ -557,7 +574,7 @@ static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
 	if (data->nr_tags > 1) {
 		rq = __blk_mq_alloc_requests_batch(data);
 		if (rq) {
-			blk_mq_rq_time_init(rq, alloc_time_ns);
+			blk_mq_rq_late_init(rq, alloc_time_ns);
 			return rq;
 		}
 		data->nr_tags = 1;
@@ -585,7 +602,7 @@ static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
 	if (!(data->rq_flags & RQF_SCHED_TAGS))
 		blk_mq_inc_active_requests(data->hctx);
 	rq = blk_mq_rq_ctx_init(data, blk_mq_tags_from_data(data), tag);
-	blk_mq_rq_time_init(rq, alloc_time_ns);
+	blk_mq_rq_late_init(rq, alloc_time_ns);
 	return rq;
 }
 
@@ -632,8 +649,6 @@ static struct request *blk_mq_alloc_cached_request(struct request_queue *q,
 		if (plug->nr_ios == 1)
 			return NULL;
 		rq = blk_mq_rq_cache_fill(q, plug, opf, flags);
-		if (!rq)
-			return NULL;
 	} else {
 		rq = rq_list_peek(&plug->cached_rqs);
 		if (!rq || rq->q != q)
@@ -645,11 +660,11 @@ static struct request *blk_mq_alloc_cached_request(struct request_queue *q,
 			return NULL;
 
 		rq_list_pop(&plug->cached_rqs);
-		blk_mq_rq_time_init(rq, blk_time_get_ns());
+		rq->cmd_flags = opf;
+		INIT_LIST_HEAD(&rq->queuelist);
+		blk_mq_rq_late_init(rq, blk_time_get_ns());
 	}
 
-	rq->cmd_flags = opf;
-	INIT_LIST_HEAD(&rq->queuelist);
 	return rq;
 }
 
@@ -761,7 +776,7 @@ struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
 	if (!(data.rq_flags & RQF_SCHED_TAGS))
 		blk_mq_inc_active_requests(data.hctx);
 	rq = blk_mq_rq_ctx_init(&data, blk_mq_tags_from_data(&data), tag);
-	blk_mq_rq_time_init(rq, alloc_time_ns);
+	blk_mq_rq_late_init(rq, alloc_time_ns);
 	rq->__data_len = 0;
 	rq->phys_gap_bit = 0;
 	rq->__sector = (sector_t) -1;
@@ -3189,9 +3204,9 @@ void blk_mq_submit_bio(struct bio *bio)
 new_request:
 	if (rq) {
 		rq_qos_throttle(rq->q, bio);
-		blk_mq_rq_time_init(rq, blk_time_get_ns());
 		rq->cmd_flags = bio->bi_opf;
 		INIT_LIST_HEAD(&rq->queuelist);
+		blk_mq_rq_late_init(rq, blk_time_get_ns());
 	} else {
 		rq = blk_mq_get_new_requests(q, plug, bio);
 		if (unlikely(!rq)) {
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 29d00221fbea6..555ab81bc12a8 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -704,7 +704,7 @@ static void dd_insert_requests(struct blk_mq_hw_ctx *hctx,
 	blk_mq_free_requests(&free);
 }
 
-/* Callback from inside blk_mq_rq_ctx_init(). */
+/* Callback from inside blk_mq_rq_late_init(). */
 static void dd_prepare_request(struct request *rq)
 {
 	rq->elv.priv[0] = NULL;
-- 
2.53.0



