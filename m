Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C25F3242BE;
	Sat, 30 May 2026 16:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159770; cv=none; b=oaDWxL0JpkaIXbxs4YuWbEn60wq8w7vmopALdXdq6E7GhCWBDaqI61lDjgzrj7zPGAphKXf46km1BxYfn47C2whNI4Ba9sGZiz2rIytnx54Qh08b2eQ5jsXu9h8bqo7w6ctYczGPLBhvuKjn/7nuM7ToWu1IpZb0INWBNJp9xJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159770; c=relaxed/simple;
	bh=Bxm9gaIBzJzkTJY1pGJQiEbE5Ii8GoEUpAaj9yWjrsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugy5j9kqa2mT8/gvh59jZVoToxp6wPH6s5iOjoGC34x21QpVriZxdQYy4pSoA5CWYNoQfa5TWktx8AlsYY35YoCxiuv7TjXFcYjh1ZnrcAr0/8YbB+6VR5tXxc04MGLrwIKclM9ntSoprENMXbUABzHDvMq399S5aLrwDOLpI1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/IDyiyf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/IDyiyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5BE1F00893;
	Sat, 30 May 2026 16:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159768;
	bh=YMYMC3AKAhNG8NJBzbOUPyo7kMiGwKwLbs4Tkw+yODs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/IDyiyfAuAmnRA6x376juYur1uIMylJOZWLFjeflTG5bFlyx7Tt5dvcRdw4Gm2J6
	 JLUSKtfcI1JsMqJSh70+ghQIc5BqX2ol4+aEDwl52pLznk/cVAWS/U8hfX4c4lmgHn
	 Iz1qE3lr7Coni/xX0b/30dCCYjrc4NWJbuf4kzy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Ruohan Lan <ruohanlan@aliyun.com>
Subject: [PATCH 6.1 129/969] ublk: fix deadlock when reading partition table
Date: Sat, 30 May 2026 17:54:13 +0200
Message-ID: <20260530160304.135563374@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit c258f5c4502c9667bccf5d76fa731ab9c96687c1 ]

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
doesn't exist in 6.1. ]
Signed-off-by: Ruohan Lan <ruohanlan@aliyun.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -603,12 +603,20 @@ static inline bool ubq_daemon_is_dying(s
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
 static void ublk_complete_rq(struct request *req)
 {
 	struct ublk_queue *ubq = req->mq_hctx->driver_data;
 	struct ublk_io *io = &ubq->ios[req->tag];
 	unsigned int unmapped_bytes;
+	bool requeue;
 
 	/* failed read IO if nothing is read */
 	if (!io->res && req_op(req) == REQ_OP_READ)
@@ -641,7 +649,23 @@ static void ublk_complete_rq(struct requ
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
@@ -694,7 +718,7 @@ static inline void __ublk_abort_rq(struc
 	if (ublk_queue_can_use_recovery(ubq))
 		blk_mq_requeue_request(rq, false);
 	else
-		blk_mq_end_request(rq, BLK_STS_IOERR);
+		ublk_end_request(rq, BLK_STS_IOERR);
 
 	mod_delayed_work(system_wq, &ubq->dev->monitor_work, 0);
 }


