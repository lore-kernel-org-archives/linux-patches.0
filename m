Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A957A244668;
	Tue, 29 Apr 2025 16:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945993; cv=none; b=p+AjUkVQa8Me4lrin28qqXCdk4Jo0FMd8K+pa2FB8iWoDzltEfBiS6nHyX9kIuFONzZoVfmT3WUoRrfvquchJhhwRBGb0tzQt2ttc4lHqCzeeBYt+ATZn9R5IuGNIMNT0AT+oWWxyA/J/mxPeww506Sk//rnEoi8t7/ezNFYXFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945993; c=relaxed/simple;
	bh=lkPhPH64Gmdne1LsJwflveyywA1lulhllSEv4SO3xC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFoKJwLmSMEF5ZoTpJKp0gLVadrhp0Af41+lges37O0Q/09S7fwKBo2NF/lc7uPvwvOf489WGH7jFHPmRU85CLYxfIU1mCZn/8LZXlIJh42R96gzJswep2Cqn2roJkQ3hWf1PwZoTJtNhe1WbxclM0+DdzzhXLt316FvlGOTJc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqHsSTe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqHsSTe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F068C4CEE3;
	Tue, 29 Apr 2025 16:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945993;
	bh=lkPhPH64Gmdne1LsJwflveyywA1lulhllSEv4SO3xC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqHsSTe9hISurPL558m3nhSOHizgqtJkqmnNDNnc2HTLOzsz5nRhjQrwhw1joTQvj
	 nNM/TE3QAOmB8biRrQzOmVT3f0FTzwjAApPNawq5uZu/YklY7QT2pqiV7yrLC98p3y
	 LGGGHbp9hvnwVoDCjG77Y6u8tAfTBKkNtWu5I74Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Shankar <ushankar@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 088/311] ublk: remove io_cmds list in ublk_queue
Date: Tue, 29 Apr 2025 18:38:45 +0200
Message-ID: <20250429161124.652166217@linuxfoundation.org>
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

From: Uday Shankar <ushankar@purestorage.com>

[ Upstream commit 989bcd623a8b0c32b76d9258767d8b37e53419e6 ]

The current I/O dispatch mechanism - queueing I/O by adding it to the
io_cmds list (and poking task_work as needed), then dispatching it in
ublk server task context by reversing io_cmds and completing the
io_uring command associated to each one - was introduced by commit
7d4a93176e014 ("ublk_drv: don't forward io commands in reserve order")
to ensure that the ublk server received I/O in the same order that the
block layer submitted it to ublk_drv. This mechanism was only needed for
the "raw" task_work submission mechanism, since the io_uring task work
wrapper maintains FIFO ordering (using quite a similar mechanism in
fact). The "raw" task_work submission mechanism is no longer supported
in ublk_drv as of commit 29dc5d06613f2 ("ublk: kill queuing request by
task_work_add"), so the explicit llist/reversal is no longer needed - it
just duplicates logic already present in the underlying io_uring APIs.
Remove it.

Signed-off-by: Uday Shankar <ushankar@purestorage.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250318-ublk_io_cmds-v1-1-c1bb74798fef@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d6aa0c178bf8 ("ublk: call ublk_dispatch_req() for handling UBLK_U_IO_NEED_GET_DATA")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 46 ++++++++++------------------------------
 1 file changed, 11 insertions(+), 35 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 971b793dedd03..f615b9bd82f5f 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -73,8 +73,6 @@
 	 UBLK_PARAM_TYPE_DEVT | UBLK_PARAM_TYPE_ZONED)
 
 struct ublk_rq_data {
-	struct llist_node node;
-
 	struct kref ref;
 };
 
@@ -141,8 +139,6 @@ struct ublk_queue {
 	struct task_struct	*ubq_daemon;
 	char *io_cmd_buf;
 
-	struct llist_head	io_cmds;
-
 	unsigned long io_addr;	/* mapped vm address */
 	unsigned int max_io_sz;
 	bool force_abort;
@@ -1114,7 +1110,7 @@ static void ublk_fail_rq_fn(struct kref *ref)
 }
 
 /*
- * Since __ublk_rq_task_work always fails requests immediately during
+ * Since ublk_rq_task_work_cb always fails requests immediately during
  * exiting, __ublk_fail_req() is only called from abort context during
  * exiting. So lock is unnecessary.
  *
@@ -1163,11 +1159,14 @@ static inline void __ublk_abort_rq(struct ublk_queue *ubq,
 		blk_mq_end_request(rq, BLK_STS_IOERR);
 }
 
-static inline void __ublk_rq_task_work(struct request *req,
-				       unsigned issue_flags)
+static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd,
+				 unsigned int issue_flags)
 {
-	struct ublk_queue *ubq = req->mq_hctx->driver_data;
-	int tag = req->tag;
+	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
+	struct ublk_queue *ubq = pdu->ubq;
+	int tag = pdu->tag;
+	struct request *req = blk_mq_tag_to_rq(
+		ubq->dev->tag_set.tags[ubq->q_id], tag);
 	struct ublk_io *io = &ubq->ios[tag];
 	unsigned int mapped_bytes;
 
@@ -1242,34 +1241,11 @@ static inline void __ublk_rq_task_work(struct request *req,
 	ubq_complete_io_cmd(io, UBLK_IO_RES_OK, issue_flags);
 }
 
-static inline void ublk_forward_io_cmds(struct ublk_queue *ubq,
-					unsigned issue_flags)
-{
-	struct llist_node *io_cmds = llist_del_all(&ubq->io_cmds);
-	struct ublk_rq_data *data, *tmp;
-
-	io_cmds = llist_reverse_order(io_cmds);
-	llist_for_each_entry_safe(data, tmp, io_cmds, node)
-		__ublk_rq_task_work(blk_mq_rq_from_pdu(data), issue_flags);
-}
-
-static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd, unsigned issue_flags)
-{
-	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
-	struct ublk_queue *ubq = pdu->ubq;
-
-	ublk_forward_io_cmds(ubq, issue_flags);
-}
-
 static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
 {
-	struct ublk_rq_data *data = blk_mq_rq_to_pdu(rq);
+	struct ublk_io *io = &ubq->ios[rq->tag];
 
-	if (llist_add(&data->node, &ubq->io_cmds)) {
-		struct ublk_io *io = &ubq->ios[rq->tag];
-
-		io_uring_cmd_complete_in_task(io->cmd, ublk_rq_task_work_cb);
-	}
+	io_uring_cmd_complete_in_task(io->cmd, ublk_rq_task_work_cb);
 }
 
 static enum blk_eh_timer_return ublk_timeout(struct request *rq)
@@ -1462,7 +1438,7 @@ static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
 			struct request *rq;
 
 			/*
-			 * Either we fail the request or ublk_rq_task_work_fn
+			 * Either we fail the request or ublk_rq_task_work_cb
 			 * will do it
 			 */
 			rq = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], i);
-- 
2.39.5



