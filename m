Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB3425DB1C;
	Mon,  9 Feb 2026 14:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648362; cv=none; b=k7dKe8wTAllqny4iFdaUQuMQmakIJYerJDMooAewHkLLXq8SaVQ+gtD/YMhdH3mdm2MR1eFF6ze4uf7cdlErHl/NCK90ZEVsfYt/6jsXscfYI2aInT1Zt/wMNN+MRhqatI3otwGjUcW48ekGRB41jk5o4Mxy8wlIlDF4VzbclC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648362; c=relaxed/simple;
	bh=0NQ11y3Z39pde/rbwZphjcrPBQgrgTYuKGqbLWRocBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gB+duIMABSqnGzLi4+hUQKwXkFMLoG2k0AUEegDgyLmvXvLDIjgXqVzBaeJjQdBLRU+jQ/6e5jQ1WwJRhJ9uZ3HJZYw+XZXWHVtzH4MJnASNG70TtGF2PtWYdTyfyA3FnJPYq5ktpaQrXOs49brYwbJI6u8djUeX7+7AqIfwfrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBPOfp8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBPOfp8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1DBC116C6;
	Mon,  9 Feb 2026 14:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648361;
	bh=0NQ11y3Z39pde/rbwZphjcrPBQgrgTYuKGqbLWRocBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBPOfp8tIhSAFtuR83dE5P5jWbM2fmLroQQtSL+8xCr2fdJEjxpxblT9ZN+DBiUpn
	 V5yhRNcfjzZ1r1ZmStsJmkUaIvHdMOiImkY/50ajM+baI66pTxO/5+DHjSFvzFo6Ih
	 3HetKjecpCFBbqdpPONJgIAKtzP1DvMkEmoYlmN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.6 15/86] ublk: fix deadlock when reading partition table
Date: Mon,  9 Feb 2026 15:23:38 +0100
Message-ID: <20260209142305.326528634@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit c258f5c4502c9667bccf5d76fa731ab9c96687c1 upstream.

When one process(such as udev) opens ublk block device (e.g., to read
the partition table via bdev_open()), a deadlock[1] can occur:

1. bdev_open() grabs disk->open_mutex
2. The process issues read I/O to ublk backend to read partition table
3. In __ublk_complete_rq(), blk_update_request() or blk_mq_end_request()
   runs bio->bi_end_io() callbacks
4. If this triggers fput() on file descriptor of ublk block device, the
   work may be deferred to current task's task work (see fput() implementation)
5. This eventually calls blkdev_release() from the same context
6. blkdev_release() tries to grab disk->open_mutex again
7. Deadlock: same task waiting for a mutex it already holds

The fix is to run blk_update_request() and blk_mq_end_request() with bottom
halves disabled. This forces blkdev_release() to run in kernel work-queue
context instead of current task work context, and allows ublk server to make
forward progress, and avoids the deadlock.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Link: https://github.com/ublk-org/ublksrv/issues/170 [1]
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
[axboe: rewrite comment in ublk]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ The fix omits the change in __ublk_do_auto_buf_reg() since this function
  doesn't exist in Linux 6.6. ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1050,6 +1050,13 @@ static inline bool ubq_daemon_is_dying(s
 	return ubq->ubq_daemon->flags & PF_EXITING;
 }
 
+static void ublk_end_request(struct request *req, blk_status_t error)
+{
+	local_bh_disable();
+	blk_mq_end_request(req, error);
+	local_bh_enable();
+}
+
 /* todo: handle partial completion */
 static inline void __ublk_complete_rq(struct request *req)
 {
@@ -1057,6 +1064,7 @@ static inline void __ublk_complete_rq(st
 	struct ublk_io *io = &ubq->ios[req->tag];
 	unsigned int unmapped_bytes;
 	blk_status_t res = BLK_STS_OK;
+	bool requeue;
 
 	/* called from ublk_abort_queue() code path */
 	if (io->flags & UBLK_IO_FLAG_ABORTED) {
@@ -1094,14 +1102,30 @@ static inline void __ublk_complete_rq(st
 	if (unlikely(unmapped_bytes < io->res))
 		io->res = unmapped_bytes;
 
-	if (blk_update_request(req, BLK_STS_OK, io->res))
+	/*
+	 * Run bio->bi_end_io() with softirqs disabled. If the final fput
+	 * happens off this path, then that will prevent ublk's blkdev_release()
+	 * from being called on current's task work, see fput() implementation.
+	 *
+	 * Otherwise, ublk server may not provide forward progress in case of
+	 * reading the partition table from bdev_open() with disk->open_mutex
+	 * held, and causes dead lock as we could already be holding
+	 * disk->open_mutex here.
+	 *
+	 * Preferably we would not be doing IO with a mutex held that is also
+	 * used for release, but this work-around will suffice for now.
+	 */
+	local_bh_disable();
+	requeue = blk_update_request(req, BLK_STS_OK, io->res);
+	local_bh_enable();
+	if (requeue)
 		blk_mq_requeue_request(req, true);
 	else
 		__blk_mq_end_request(req, BLK_STS_OK);
 
 	return;
 exit:
-	blk_mq_end_request(req, res);
+	ublk_end_request(req, res);
 }
 
 static void ublk_complete_rq(struct kref *ref)
@@ -1160,7 +1184,7 @@ static inline void __ublk_abort_rq(struc
 	if (ublk_queue_can_use_recovery(ubq))
 		blk_mq_requeue_request(rq, false);
 	else
-		blk_mq_end_request(rq, BLK_STS_IOERR);
+		ublk_end_request(rq, BLK_STS_IOERR);
 
 	mod_delayed_work(system_wq, &ubq->dev->monitor_work, 0);
 }


