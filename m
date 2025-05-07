Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478621CF5C6;
	Wed,  7 May 2025 18:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644214; cv=none; b=EZsxSJ8T2OxXaCc1H4iJgxikoACk//QlsifOOy02QbI92dvyq20Ib2LSwFD1plagIdX/D/b4Uc+ZKlN+7aNxYBqs29LZsB23oLw1sxlKHQ2ds7e8QMjXqbYxeyzew6KJj8HSpSk+blnOAQWy6EDpQrALKy2GPIZJPQfQOWQ7W40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644214; c=relaxed/simple;
	bh=Y5KPcrtoPHecYw1fEiBwdm5+3DROZM0xZoocZIhNU5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTDFK0SMr7i6hlVgkaNPi//inzvsc9fEPRCfXbQaw1uYqJnA/6xarJkTT+IZ5uDAL7iYiJLvc+rzmHoNM5M4S03gq2GwTG6ItrAncHTy+4orVKgqliEyVu7rnIEhPprfg6QjNARbWjGBstnF7LAYHVNFNADNuxV7iZE9BVWyjnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qw+agzX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qw+agzX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC93C4CEE2;
	Wed,  7 May 2025 18:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644214;
	bh=Y5KPcrtoPHecYw1fEiBwdm5+3DROZM0xZoocZIhNU5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qw+agzX96Rpo7U+dToK2zCVEOWFJXLceraFLD1kz73tsSzPqLomi8OOAzVqbu1uNL
	 ORXKeaWSqyggS+uNgM+6tnsnZR8k9h1YI+p2eDVZOaAl/bHZ+FKOc1NIHoH7b1xbf/
	 T83fXgHybsPW53hQP/GWbGsyAe1jNvFd/nuuyLNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.14 156/183] ublk: move device reset into ublk_ch_release()
Date: Wed,  7 May 2025 20:40:01 +0200
Message-ID: <20250507183831.181369030@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

[ Upstream commit 728cbac5fe219d3b8a21a0688a08f2b7f8aeda2b ]

ublk_ch_release() is called after ublk char device is closed, when all
uring_cmd are done, so it is perfect fine to move ublk device reset to
ublk_ch_release() from ublk_ctrl_start_recovery().

This way can avoid to grab the exiting daemon task_struct too long.

However, reset of the following ublk IO flags has to be moved until ublk
io_uring queues are ready:

- ubq->canceling

For requeuing IO in case of ublk_nosrv_dev_should_queue_io() before device
is recovered

- ubq->fail_io

For failing IO in case of UBLK_F_USER_RECOVERY_FAIL_IO before device is
recovered

- ublk_io->flags

For preventing using io->cmd

With this way, recovery is simplified a lot.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250416035444.99569-5-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c |  121 +++++++++++++++++++++++++++--------------------
 1 file changed, 72 insertions(+), 49 deletions(-)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1043,7 +1043,7 @@ static inline struct ublk_uring_cmd_pdu
 
 static inline bool ubq_daemon_is_dying(struct ublk_queue *ubq)
 {
-	return ubq->ubq_daemon->flags & PF_EXITING;
+	return !ubq->ubq_daemon || ubq->ubq_daemon->flags & PF_EXITING;
 }
 
 /* todo: handle partial completion */
@@ -1440,6 +1440,37 @@ static const struct blk_mq_ops ublk_mq_o
 	.timeout	= ublk_timeout,
 };
 
+static void ublk_queue_reinit(struct ublk_device *ub, struct ublk_queue *ubq)
+{
+	int i;
+
+	/* All old ioucmds have to be completed */
+	ubq->nr_io_ready = 0;
+
+	/*
+	 * old daemon is PF_EXITING, put it now
+	 *
+	 * It could be NULL in case of closing one quisced device.
+	 */
+	if (ubq->ubq_daemon)
+		put_task_struct(ubq->ubq_daemon);
+	/* We have to reset it to NULL, otherwise ub won't accept new FETCH_REQ */
+	ubq->ubq_daemon = NULL;
+	ubq->timeout = false;
+
+	for (i = 0; i < ubq->q_depth; i++) {
+		struct ublk_io *io = &ubq->ios[i];
+
+		/*
+		 * UBLK_IO_FLAG_CANCELED is kept for avoiding to touch
+		 * io->cmd
+		 */
+		io->flags &= UBLK_IO_FLAG_CANCELED;
+		io->cmd = NULL;
+		io->addr = 0;
+	}
+}
+
 static int ublk_ch_open(struct inode *inode, struct file *filp)
 {
 	struct ublk_device *ub = container_of(inode->i_cdev,
@@ -1451,10 +1482,26 @@ static int ublk_ch_open(struct inode *in
 	return 0;
 }
 
+static void ublk_reset_ch_dev(struct ublk_device *ub)
+{
+	int i;
+
+	for (i = 0; i < ub->dev_info.nr_hw_queues; i++)
+		ublk_queue_reinit(ub, ublk_get_queue(ub, i));
+
+	/* set to NULL, otherwise new ubq_daemon cannot mmap the io_cmd_buf */
+	ub->mm = NULL;
+	ub->nr_queues_ready = 0;
+	ub->nr_privileged_daemon = 0;
+}
+
 static int ublk_ch_release(struct inode *inode, struct file *filp)
 {
 	struct ublk_device *ub = filp->private_data;
 
+	/* all uring_cmd has been done now, reset device & ubq */
+	ublk_reset_ch_dev(ub);
+
 	clear_bit(UB_STATE_OPEN, &ub->state);
 	return 0;
 }
@@ -1801,6 +1848,24 @@ static void ublk_nosrv_work(struct work_
 	ublk_cancel_dev(ub);
 }
 
+/* reset ublk io_uring queue & io flags */
+static void ublk_reset_io_flags(struct ublk_device *ub)
+{
+	int i, j;
+
+	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
+		struct ublk_queue *ubq = ublk_get_queue(ub, i);
+
+		/* UBLK_IO_FLAG_CANCELED can be cleared now */
+		spin_lock(&ubq->cancel_lock);
+		for (j = 0; j < ubq->q_depth; j++)
+			ubq->ios[j].flags &= ~UBLK_IO_FLAG_CANCELED;
+		spin_unlock(&ubq->cancel_lock);
+		ubq->canceling = false;
+		ubq->fail_io = false;
+	}
+}
+
 /* device can only be started after all IOs are ready */
 static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
 	__must_hold(&ub->mutex)
@@ -1814,8 +1879,12 @@ static void ublk_mark_io_ready(struct ub
 		if (capable(CAP_SYS_ADMIN))
 			ub->nr_privileged_daemon++;
 	}
-	if (ub->nr_queues_ready == ub->dev_info.nr_hw_queues)
+
+	if (ub->nr_queues_ready == ub->dev_info.nr_hw_queues) {
+		/* now we are ready for handling ublk io request */
+		ublk_reset_io_flags(ub);
 		complete_all(&ub->completion);
+	}
 }
 
 static inline int ublk_check_cmd_op(u32 cmd_op)
@@ -2866,42 +2935,15 @@ static int ublk_ctrl_set_params(struct u
 	return ret;
 }
 
-static void ublk_queue_reinit(struct ublk_device *ub, struct ublk_queue *ubq)
-{
-	int i;
-
-	WARN_ON_ONCE(!(ubq->ubq_daemon && ubq_daemon_is_dying(ubq)));
-
-	/* All old ioucmds have to be completed */
-	ubq->nr_io_ready = 0;
-	/* old daemon is PF_EXITING, put it now */
-	put_task_struct(ubq->ubq_daemon);
-	/* We have to reset it to NULL, otherwise ub won't accept new FETCH_REQ */
-	ubq->ubq_daemon = NULL;
-	ubq->timeout = false;
-
-	for (i = 0; i < ubq->q_depth; i++) {
-		struct ublk_io *io = &ubq->ios[i];
-
-		/* forget everything now and be ready for new FETCH_REQ */
-		io->flags = 0;
-		io->cmd = NULL;
-		io->addr = 0;
-	}
-}
-
 static int ublk_ctrl_start_recovery(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
 	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
 	int ret = -EINVAL;
-	int i;
 
 	mutex_lock(&ub->mutex);
 	if (ublk_nosrv_should_stop_dev(ub))
 		goto out_unlock;
-	if (!ub->nr_queues_ready)
-		goto out_unlock;
 	/*
 	 * START_RECOVERY is only allowd after:
 	 *
@@ -2925,12 +2967,6 @@ static int ublk_ctrl_start_recovery(stru
 		goto out_unlock;
 	}
 	pr_devel("%s: start recovery for dev id %d.\n", __func__, header->dev_id);
-	for (i = 0; i < ub->dev_info.nr_hw_queues; i++)
-		ublk_queue_reinit(ub, ublk_get_queue(ub, i));
-	/* set to NULL, otherwise new ubq_daemon cannot mmap the io_cmd_buf */
-	ub->mm = NULL;
-	ub->nr_queues_ready = 0;
-	ub->nr_privileged_daemon = 0;
 	init_completion(&ub->completion);
 	ret = 0;
  out_unlock:
@@ -2944,7 +2980,6 @@ static int ublk_ctrl_end_recovery(struct
 	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
 	int ublksrv_pid = (int)header->data[0];
 	int ret = -EINVAL;
-	int i;
 
 	pr_devel("%s: Waiting for new ubq_daemons(nr: %d) are ready, dev id %d...\n",
 			__func__, ub->dev_info.nr_hw_queues, header->dev_id);
@@ -2964,22 +2999,10 @@ static int ublk_ctrl_end_recovery(struct
 		goto out_unlock;
 	}
 	ub->dev_info.ublksrv_pid = ublksrv_pid;
+	ub->dev_info.state = UBLK_S_DEV_LIVE;
 	pr_devel("%s: new ublksrv_pid %d, dev id %d\n",
 			__func__, ublksrv_pid, header->dev_id);
-
-	blk_mq_quiesce_queue(ub->ub_disk->queue);
-	ub->dev_info.state = UBLK_S_DEV_LIVE;
-	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
-		struct ublk_queue *ubq = ublk_get_queue(ub, i);
-
-		ubq->canceling = false;
-		ubq->fail_io = false;
-	}
-	blk_mq_unquiesce_queue(ub->ub_disk->queue);
-	pr_devel("%s: queue unquiesced, dev id %d.\n",
-			__func__, header->dev_id);
 	blk_mq_kick_requeue_list(ub->ub_disk->queue);
-
 	ret = 0;
  out_unlock:
 	mutex_unlock(&ub->mutex);


