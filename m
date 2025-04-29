Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF25D244668;
	Tue, 29 Apr 2025 16:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945999; cv=none; b=OhH3Q4jQAWJXwPOuIxGIKbqF9UG6iZYxoxWRbAoagxTpc/AIgzkocBE65JDwIdSky7XLL8VBCUx/b17bCWQUEySgrxFiU+rIR8nrTVGXGJdGeWtp67WuQ7BTPl1tDxgGWOEuewoUjcKUo2EeHmNg1cP0ZuMdznT+E5/HPk6P+EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945999; c=relaxed/simple;
	bh=vG7woXdZa2FIvWXd9VlOE/mSDoUmI3zHVbRmCvZ2LR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miC4v0OLzFKdZD7rp4tiOdfSBaDqSBFQB54ofa1FL0OonSf6mC6dy3SZohfJsS1OjSWsVTA3Gy4/QE7qLzhoxwJysBVFcsXN0uYMEODCxiIyEdVfEULHxl/CkQ8uALwWBb41luihbxqZlMH34JDh96lrIPUHSGk5+hpCkQ12ZG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mi6/Kt5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mi6/Kt5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FF1C4CEE3;
	Tue, 29 Apr 2025 16:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945999;
	bh=vG7woXdZa2FIvWXd9VlOE/mSDoUmI3zHVbRmCvZ2LR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mi6/Kt5BvHZPmdC67EvTkmA1eZ44n6213YN67GuGLQdfj2tIy3dzNoEMgFfRUwKKJ
	 s8s+JzqVKMihgT4zq5gNeJ69NgFiSPwc3kDcRrqyni0Ig3fRGc3rdmOp1QH1ZTUflA
	 t2bNHi98qB3lriMRrXbkxbamaW2KNPjRuS/2wb+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Shankar <ushankar@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 090/311] ublk: implement ->queue_rqs()
Date: Tue, 29 Apr 2025 18:38:47 +0200
Message-ID: <20250429161124.733589261@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit d796cea7b9f33b6315362f504b15fcc26d678493 ]

Implement ->queue_rqs() for improving perf in case of MQ.

In this way, we just need to call io_uring_cmd_complete_in_task() once for
whole IO batch, then both io_uring and ublk server can get exact batch from
ublk frontend.

Follows IOPS improvement:

- tests

	tools/testing/selftests/ublk/kublk add -t null -q 2 [-z]

	fio/t/io_uring -p0 /dev/ublkb0

- results:

	more than 10% IOPS boost observed

Pass all ublk selftests, especially the io dispatch order test.

Cc: Uday Shankar <ushankar@purestorage.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250327095123.179113-9-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d6aa0c178bf8 ("ublk: call ublk_dispatch_req() for handling UBLK_U_IO_NEED_GET_DATA")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 131 +++++++++++++++++++++++++++++++++------
 1 file changed, 111 insertions(+), 20 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index fbc397efff175..e1388a9b1e2d1 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -77,6 +77,20 @@ struct ublk_rq_data {
 };
 
 struct ublk_uring_cmd_pdu {
+	/*
+	 * Store requests in same batch temporarily for queuing them to
+	 * daemon context.
+	 *
+	 * It should have been stored to request payload, but we do want
+	 * to avoid extra pre-allocation, and uring_cmd payload is always
+	 * free for us
+	 */
+	struct request *req_list;
+
+	/*
+	 * The following two are valid in this cmd whole lifetime, and
+	 * setup in ublk uring_cmd handler
+	 */
 	struct ublk_queue *ubq;
 	u16 tag;
 };
@@ -1159,14 +1173,12 @@ static inline void __ublk_abort_rq(struct ublk_queue *ubq,
 		blk_mq_end_request(rq, BLK_STS_IOERR);
 }
 
-static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd,
-				 unsigned int issue_flags)
+static void ublk_dispatch_req(struct ublk_queue *ubq,
+			      struct io_uring_cmd *cmd,
+			      struct request *req,
+			      unsigned int issue_flags)
 {
-	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
-	struct ublk_queue *ubq = pdu->ubq;
-	int tag = pdu->tag;
-	struct request *req = blk_mq_tag_to_rq(
-		ubq->dev->tag_set.tags[ubq->q_id], tag);
+	int tag = req->tag;
 	struct ublk_io *io = &ubq->ios[tag];
 	unsigned int mapped_bytes;
 
@@ -1241,6 +1253,18 @@ static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd,
 	ubq_complete_io_cmd(io, UBLK_IO_RES_OK, issue_flags);
 }
 
+static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd,
+				 unsigned int issue_flags)
+{
+	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
+	struct ublk_queue *ubq = pdu->ubq;
+	int tag = pdu->tag;
+	struct request *req = blk_mq_tag_to_rq(
+		ubq->dev->tag_set.tags[ubq->q_id], tag);
+
+	ublk_dispatch_req(ubq, cmd, req, issue_flags);
+}
+
 static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
 {
 	struct ublk_io *io = &ubq->ios[rq->tag];
@@ -1248,6 +1272,35 @@ static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
 	io_uring_cmd_complete_in_task(io->cmd, ublk_rq_task_work_cb);
 }
 
+static void ublk_cmd_list_tw_cb(struct io_uring_cmd *cmd,
+		unsigned int issue_flags)
+{
+	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
+	struct request *rq = pdu->req_list;
+	struct ublk_queue *ubq = rq->mq_hctx->driver_data;
+	struct request *next;
+
+	while (rq) {
+		struct ublk_io *io = &ubq->ios[rq->tag];
+
+		next = rq->rq_next;
+		rq->rq_next = NULL;
+		ublk_dispatch_req(ubq, io->cmd, rq, issue_flags);
+		rq = next;
+	}
+}
+
+static void ublk_queue_cmd_list(struct ublk_queue *ubq, struct rq_list *l)
+{
+	struct request *rq = rq_list_peek(l);
+	struct ublk_io *io = &ubq->ios[rq->tag];
+	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(io->cmd);
+
+	pdu->req_list = rq;
+	rq_list_init(l);
+	io_uring_cmd_complete_in_task(io->cmd, ublk_cmd_list_tw_cb);
+}
+
 static enum blk_eh_timer_return ublk_timeout(struct request *rq)
 {
 	struct ublk_queue *ubq = rq->mq_hctx->driver_data;
@@ -1286,21 +1339,12 @@ static enum blk_eh_timer_return ublk_timeout(struct request *rq)
 	return BLK_EH_RESET_TIMER;
 }
 
-static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
-		const struct blk_mq_queue_data *bd)
+static blk_status_t ublk_prep_req(struct ublk_queue *ubq, struct request *rq)
 {
-	struct ublk_queue *ubq = hctx->driver_data;
-	struct request *rq = bd->rq;
 	blk_status_t res;
 
-	if (unlikely(ubq->fail_io)) {
+	if (unlikely(ubq->fail_io))
 		return BLK_STS_TARGET;
-	}
-
-	/* fill iod to slot in io cmd buffer */
-	res = ublk_setup_iod(ubq, rq);
-	if (unlikely(res != BLK_STS_OK))
-		return BLK_STS_IOERR;
 
 	/* With recovery feature enabled, force_abort is set in
 	 * ublk_stop_dev() before calling del_gendisk(). We have to
@@ -1314,6 +1358,29 @@ static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (ublk_nosrv_should_queue_io(ubq) && unlikely(ubq->force_abort))
 		return BLK_STS_IOERR;
 
+	if (unlikely(ubq->canceling))
+		return BLK_STS_IOERR;
+
+	/* fill iod to slot in io cmd buffer */
+	res = ublk_setup_iod(ubq, rq);
+	if (unlikely(res != BLK_STS_OK))
+		return BLK_STS_IOERR;
+
+	blk_mq_start_request(rq);
+	return BLK_STS_OK;
+}
+
+static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
+		const struct blk_mq_queue_data *bd)
+{
+	struct ublk_queue *ubq = hctx->driver_data;
+	struct request *rq = bd->rq;
+	blk_status_t res;
+
+	res = ublk_prep_req(ubq, rq);
+	if (res != BLK_STS_OK)
+		return res;
+
 	/*
 	 * ->canceling has to be handled after ->force_abort and ->fail_io
 	 * is dealt with, otherwise this request may not be failed in case
@@ -1324,12 +1391,35 @@ static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
 		return BLK_STS_OK;
 	}
 
-	blk_mq_start_request(bd->rq);
 	ublk_queue_cmd(ubq, rq);
-
 	return BLK_STS_OK;
 }
 
+static void ublk_queue_rqs(struct rq_list *rqlist)
+{
+	struct rq_list requeue_list = { };
+	struct rq_list submit_list = { };
+	struct ublk_queue *ubq = NULL;
+	struct request *req;
+
+	while ((req = rq_list_pop(rqlist))) {
+		struct ublk_queue *this_q = req->mq_hctx->driver_data;
+
+		if (ubq && ubq != this_q && !rq_list_empty(&submit_list))
+			ublk_queue_cmd_list(ubq, &submit_list);
+		ubq = this_q;
+
+		if (ublk_prep_req(ubq, req) == BLK_STS_OK)
+			rq_list_add_tail(&submit_list, req);
+		else
+			rq_list_add_tail(&requeue_list, req);
+	}
+
+	if (ubq && !rq_list_empty(&submit_list))
+		ublk_queue_cmd_list(ubq, &submit_list);
+	*rqlist = requeue_list;
+}
+
 static int ublk_init_hctx(struct blk_mq_hw_ctx *hctx, void *driver_data,
 		unsigned int hctx_idx)
 {
@@ -1342,6 +1432,7 @@ static int ublk_init_hctx(struct blk_mq_hw_ctx *hctx, void *driver_data,
 
 static const struct blk_mq_ops ublk_mq_ops = {
 	.queue_rq       = ublk_queue_rq,
+	.queue_rqs      = ublk_queue_rqs,
 	.init_hctx	= ublk_init_hctx,
 	.timeout	= ublk_timeout,
 };
-- 
2.39.5



