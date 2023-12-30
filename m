Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D2E79CD;
	Sat, 30 Dec 2023 12:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQsrjsMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34826C433C7;
	Sat, 30 Dec 2023 12:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938277;
	bh=0t1Z4poAobnJg/JXKdNXMgueY7zEYvdi7mh7dcSEWVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQsrjsMNyK1dj7ped2GkibMXZGgueEaGfUMoDyNlZ0iPRNpyStekpmuz3mcmIB+kg
	 vwUg+mWcbJTecfasrqo7HFywEalHxLza48A30K+7Ecj1R00Om+TJwvbss+8H26RHg+
	 UkxfKMHbz4ybeG8plNgoK+gNgGIxNlwO5Xv2vzkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/112] ublk: move ublk_cancel_dev() out of ub->mutex
Date: Sat, 30 Dec 2023 12:00:07 +0000
Message-ID: <20231230115809.831305626@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 85248d670b71d9edda9459ee14fdc85c8e9632c0 ]

ublk_cancel_dev() just calls ublk_cancel_queue() to cancel all pending
io commands after ublk request queue is idle. The only protection is just
the read & write of ubq->nr_io_ready and avoid duplicated command cancel,
so add one per-queue lock with cancel flag for providing this protection,
meantime move ublk_cancel_dev() out of ub->mutex.

Then we needn't to call io_uring_cmd_complete_in_task() to cancel
pending command. And the same cancel logic will be re-used for
cancelable uring command.

This patch basically reverts commit ac5902f84bb5 ("ublk: fix AB-BA lockdep warning").

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20231009093324.957829-4-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index c2f0f74193f0e..3fa74051f31b4 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -103,6 +103,9 @@ struct ublk_uring_cmd_pdu {
  */
 #define UBLK_IO_FLAG_NEED_GET_DATA 0x08
 
+/* atomic RW with ubq->cancel_lock */
+#define UBLK_IO_FLAG_CANCELED	0x80000000
+
 struct ublk_io {
 	/* userspace buffer address from io cmd */
 	__u64	addr;
@@ -126,6 +129,7 @@ struct ublk_queue {
 	unsigned int max_io_sz;
 	bool force_abort;
 	unsigned short nr_io_ready;	/* how many ios setup */
+	spinlock_t		cancel_lock;
 	struct ublk_device *dev;
 	struct ublk_io ios[];
 };
@@ -1045,28 +1049,28 @@ static inline bool ublk_queue_ready(struct ublk_queue *ubq)
 	return ubq->nr_io_ready == ubq->q_depth;
 }
 
-static void ublk_cmd_cancel_cb(struct io_uring_cmd *cmd, unsigned issue_flags)
-{
-	io_uring_cmd_done(cmd, UBLK_IO_RES_ABORT, 0, issue_flags);
-}
-
 static void ublk_cancel_queue(struct ublk_queue *ubq)
 {
 	int i;
 
-	if (!ublk_queue_ready(ubq))
-		return;
-
 	for (i = 0; i < ubq->q_depth; i++) {
 		struct ublk_io *io = &ubq->ios[i];
 
-		if (io->flags & UBLK_IO_FLAG_ACTIVE)
-			io_uring_cmd_complete_in_task(io->cmd,
-						      ublk_cmd_cancel_cb);
-	}
+		if (io->flags & UBLK_IO_FLAG_ACTIVE) {
+			bool done;
 
-	/* all io commands are canceled */
-	ubq->nr_io_ready = 0;
+			spin_lock(&ubq->cancel_lock);
+			done = !!(io->flags & UBLK_IO_FLAG_CANCELED);
+			if (!done)
+				io->flags |= UBLK_IO_FLAG_CANCELED;
+			spin_unlock(&ubq->cancel_lock);
+
+			if (!done)
+				io_uring_cmd_done(io->cmd,
+						UBLK_IO_RES_ABORT, 0,
+						IO_URING_F_UNLOCKED);
+		}
+	}
 }
 
 /* Cancel all pending commands, must be called after del_gendisk() returns */
@@ -1113,7 +1117,6 @@ static void __ublk_quiesce_dev(struct ublk_device *ub)
 	blk_mq_quiesce_queue(ub->ub_disk->queue);
 	ublk_wait_tagset_rqs_idle(ub);
 	ub->dev_info.state = UBLK_S_DEV_QUIESCED;
-	ublk_cancel_dev(ub);
 	/* we are going to release task_struct of ubq_daemon and resets
 	 * ->ubq_daemon to NULL. So in monitor_work, check on ubq_daemon causes UAF.
 	 * Besides, monitor_work is not necessary in QUIESCED state since we have
@@ -1136,6 +1139,7 @@ static void ublk_quiesce_work_fn(struct work_struct *work)
 	__ublk_quiesce_dev(ub);
  unlock:
 	mutex_unlock(&ub->mutex);
+	ublk_cancel_dev(ub);
 }
 
 static void ublk_unquiesce_dev(struct ublk_device *ub)
@@ -1175,8 +1179,8 @@ static void ublk_stop_dev(struct ublk_device *ub)
 	put_disk(ub->ub_disk);
 	ub->ub_disk = NULL;
  unlock:
-	ublk_cancel_dev(ub);
 	mutex_unlock(&ub->mutex);
+	ublk_cancel_dev(ub);
 	cancel_delayed_work_sync(&ub->monitor_work);
 }
 
@@ -1353,6 +1357,7 @@ static int ublk_init_queue(struct ublk_device *ub, int q_id)
 	void *ptr;
 	int size;
 
+	spin_lock_init(&ubq->cancel_lock);
 	ubq->flags = ub->dev_info.flags;
 	ubq->q_id = q_id;
 	ubq->q_depth = ub->dev_info.queue_depth;
@@ -1882,8 +1887,9 @@ static void ublk_queue_reinit(struct ublk_device *ub, struct ublk_queue *ubq)
 	int i;
 
 	WARN_ON_ONCE(!(ubq->ubq_daemon && ubq_daemon_is_dying(ubq)));
+
 	/* All old ioucmds have to be completed */
-	WARN_ON_ONCE(ubq->nr_io_ready);
+	ubq->nr_io_ready = 0;
 	/* old daemon is PF_EXITING, put it now */
 	put_task_struct(ubq->ubq_daemon);
 	/* We have to reset it to NULL, otherwise ub won't accept new FETCH_REQ */
-- 
2.43.0



