Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622303;
	b=Yt3qmx6kFKjJNMOWJJDgEYsRk7X0s1Wh5Im2IxvJvAeEmi0agMKeKocbTSIYLEIg7KX/
	 BQ1cyHfKlDV8UhoVxeH42lfAqbr5w5t0r8a7BSPmliB45gex8sh20TANmhfyjD16NTYxL
	 RY+1WCELUDkUk7lCXgn40S3CXD6ixMLPJ+mmtzFpfQpjndSCpapK9F2DcLRHamls6sjd7
	 ICvQFFOMdnGczqmVoi8/roG39UM0fOOVsDg28369yuNrGgy+ULHvbL1bguqM5u8le6T89
	 INEL1Qg+9kVldWsqZTzs2Eec4dogijRIDkEp95LF/IGDV9Fl0Chwa5CZalwGz+Mlt6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Aq0Ys6ihgJKUse3lboK0VNN05wO9NNzmdlGVtmDBYKo=;
	b=jY1er1aKfJZpJ1T4pxHl4NqO+dquIdnEeQ21LntH0D3Xf5wFKmWHfyhJQlsrOBiR7mlI
	 zgUbuaWDPmiNgjwy5Pza9pHZWDf4y0Z6qeXtjVpw54CfLWGjWZr1hx5I+/AwyK7QJAuF4
	 kiLvXGcskyDP2rrARTNb1E0xjOPoIjOs774QjNIXX6603+UAgxhmbUlKmQ1Mb25aev30Q
	 A40BoX1N2KX/GxmGJAVk56Jobn9el9XMhoJQxOprs8K2UfJ7oTU5TKrGbGliiV0wS/Iif
	 ZvWrHl+w5Mv3X+JUGeM1zM9sXyfqId9IpO+hysThmwl0Qha8Yqu1ZDmvV/fut/9VMmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n9tlbYyq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D5F606A31E;
	Wed, 25 Nov 2026 15:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n9tlbYyq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30511F000C6;
	Wed, 25 Nov 2026 15:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622303;
	bh=Aq0Ys6ihgJKUse3lboK0VNN05wO9NNzmdlGVtmDBYKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n9tlbYyqCrwWimCMuKBAUTGEB0CzpQKY1IROjslUwtfvy/EAQDtiF02L5Ya8WNIQb
	 KtP9t2i7cDbSMBFRQMcl2yaErGSeqkEZpaOhCsRbLU03FzGbje0dBfHrQC/O1lqfaL
	 Saiecb5zmsZWDLDuCHXWuoV1RtTagjuFjDIhK1H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 493/990] ublk: let STOP_DEV cancel the servers commands before its release
Date: Wed, 25 Nov 2026 15:31:00 +0100
Message-ID: <20261125143833.642885932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

[ Upstream commit c8b349f9daf6d88ff21033028167d00e819dafb6 ]

STOP_DEV cancels the fetched commands after dropping ub->mutex, so
START_DEV and FETCH can run in between:

  STOP_DEV                          START_DEV / FETCH
  lock ub->mutex
    ublk_stop_dev_unlocked()        (not started: does nothing)
  unlock ub->mutex
                                    START_DEV goes live, schedules scan
                                    FETCH publishes a new command
  cancel_work_sync(scan)            cancels the new disk's scan
  ublk_cancel_dev()                 takes the new command: NULL io->cmd
                                    on a queue which isn't canceling

A START_DEV after STOP_DEV also goes live over the canceled commands.

Hold a reference on the server's /dev/ublkcN while canceling:

  STOP_DEV
  lock ub->mutex
    ublk_stop_dev_unlocked()
    cancel_work_sync(scan)
    server attached: take a reference on its file, set STOPPING
  unlock ub->mutex
  ublk_cancel_dev()
  drop the reference

 - STOPPING makes FETCH and PREP get UBLK_IO_RES_ABORT and START_DEV
   -EBUSY; a START_DEV or END_USER_RECOVERY waiting for the device
   to get ready wakes up too; the reset in the server's release
   clears it
 - the release can't run before the reference is dropped, so no new
   server can attach, and the cancel only meets this server's commands
 - the cancel still runs after the unlock: io_uring_cmd_done() may take
   uring_lock, under which FETCH takes ub->mutex

ublk_ch_open() saves the file in ->ch_file and ublk_ch_release() clears
it, under cancel_mutex. The release runs after the last reference is
gone, so take ours with file_ref_get(). Drop it with __fput_sync(): if
it is the last one, fput() would defer the release to this task, which
DEL_DEV then makes wait for the device to be freed.

A server which opened the device but hasn't fetched is stopped too.
Document what a server sees after STOP_DEV in ublk.rst.

Fixes: 85248d670b71 ("ublk: move ublk_cancel_dev() out of ub->mutex")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Closes: https://lore.kernel.org/linux-block/20260928-b4-ublk-cancel-stop-v1-0-4a4360232a46@toxicpanda.com/
Tested-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261011063555.1142277-8-tom.leiming@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ sashal: Adapted the counter from nr_queue_ready to nr_io_ready, moved the STOPPING check into ublk_fetch(), and dropped the batch-I/O (PREP) path, which this tree lacks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/block/ublk.rst |  7 +++
 drivers/block/ublk_drv.c     | 82 ++++++++++++++++++++++++++++++++----
 2 files changed, 81 insertions(+), 8 deletions(-)

diff --git a/Documentation/block/ublk.rst b/Documentation/block/ublk.rst
index 8c4030bcabb63..e14200c8dc254 100644
--- a/Documentation/block/ublk.rst
+++ b/Documentation/block/ublk.rst
@@ -126,6 +126,13 @@ managing and controlling ublk devices with help of several control commands:
   ublk server will release resources (such as destroying I/O handler threads &
   io_uring).
 
+  If a server has ``/dev/ublkc*`` open, its fetched I/O commands complete with
+  ``UBLK_IO_RES_ABORT``. Until it closes ``/dev/ublkc*``, new
+  ``UBLK_IO_FETCH_REQ`` and ``UBLK_U_IO_PREP_IO_CMDS`` commands complete with
+  ``UBLK_IO_RES_ABORT`` too, and ``UBLK_CMD_START_DEV`` fails with ``-EBUSY``,
+  even if the server hadn't fetched anything. The device can be started again
+  by a server that opens ``/dev/ublkc*`` after that.
+
 - ``UBLK_CMD_DEL_DEV``
 
   Remove ``/dev/ublkc*``. When this command returns, the allocated ublk device
diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 60bc10ca5ef2b..a955a3ea471d3 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -220,6 +220,8 @@ struct ublk_device {
 #define UB_STATE_OPEN		0
 #define UB_STATE_USED		1
 #define UB_STATE_DELETED	2
+/* STOP_DEV canceled the server's commands, until its release */
+#define UB_STATE_STOPPING	3
 	unsigned long		state;
 	int			ub_number;
 
@@ -233,6 +235,8 @@ struct ublk_device {
 	u32			nr_io_ready;
 	bool 			unprivileged_daemons;
 	struct mutex cancel_mutex;
+	/* the open /dev/ublkcN, protected by cancel_mutex */
+	struct file *ch_file;
 	/*
 	 * A cancel started in this FETCH round. Set by ublk_set_canceling(),
 	 * cleared only by ublk_reset_ch_dev() when a new round starts. While
@@ -1632,6 +1636,9 @@ static int ublk_ch_open(struct inode *inode, struct file *filp)
 		return -EBUSY;
 	filp->private_data = ub;
 	ub->ublksrv_tgid = current->tgid;
+	mutex_lock(&ub->cancel_mutex);
+	ub->ch_file = filp;
+	mutex_unlock(&ub->cancel_mutex);
 	return 0;
 }
 
@@ -1652,6 +1659,7 @@ static void ublk_reset_ch_dev(struct ublk_device *ub)
 	ub->nr_io_ready = 0;
 	ub->unprivileged_daemons = false;
 	ub->ublksrv_tgid = -1;
+	clear_bit(UB_STATE_STOPPING, &ub->state);
 }
 
 static struct gendisk *ublk_get_disk(struct ublk_device *ub)
@@ -1856,6 +1864,9 @@ static int ublk_ch_release(struct inode *inode, struct file *filp)
 {
 	struct ublk_device *ub = filp->private_data;
 
+	mutex_lock(&ub->cancel_mutex);
+	ub->ch_file = NULL;
+	mutex_unlock(&ub->cancel_mutex);
 	/*
 	 * Grab ublk device reference, so it won't be gone until we are
 	 * really released from work function.
@@ -2151,13 +2162,54 @@ static void ublk_stop_dev_unlocked(struct ublk_device *ub)
 	put_disk(disk);
 }
 
+static struct file *ublk_get_ch_file(struct ublk_device *ub)
+{
+	struct file *file;
+
+	mutex_lock(&ub->cancel_mutex);
+	file = ub->ch_file;
+	if (file && !file_ref_get(&file->f_ref))
+		file = NULL;
+	mutex_unlock(&ub->cancel_mutex);
+	return file;
+}
+
 static void ublk_stop_dev(struct ublk_device *ub)
 {
+	struct file *file;
+
+	/*
+	 * FETCH, PREP and START_DEV take ub->mutex. If a server has
+	 * /dev/ublkcN open, set STOPPING, which turns it away, and hold a
+	 * reference on the file: the server's release, whose reset clears
+	 * STOPPING and lets a new server attach, can't run before we drop it.
+	 * So the cancel can run after the unlock and only meets this server's
+	 * commands; it has to: io_uring_cmd_done() may take uring_lock, under
+	 * which FETCH takes ub->mutex.
+	 */
 	mutex_lock(&ub->mutex);
 	ublk_stop_dev_unlocked(ub);
-	mutex_unlock(&ub->mutex);
 	cancel_work_sync(&ub->partition_scan_work);
+	file = ublk_get_ch_file(ub);
+	if (file) {
+		/*
+		 * The server has to close /dev/ublkcN before this device can
+		 * be started again: the reset in its release clears STOPPING.
+		 */
+		set_bit(UB_STATE_STOPPING, &ub->state);
+		/* for wake_up_var() below, see wake_up_bit() */
+		smp_mb__after_atomic();
+	}
+	mutex_unlock(&ub->mutex);
+
+	/* no server: nothing to cancel */
+	if (!file)
+		return;
+
+	/* wake a START_DEV waiting for the device to get ready */
+	wake_up_var(&ub->nr_io_ready);
 	ublk_cancel_dev(ub);
+	__fput_sync(file);
 }
 
 /* reset ublk io_uring queue & io flags */
@@ -2417,6 +2469,11 @@ static int ublk_fetch(struct io_uring_cmd *cmd, struct ublk_device *ub,
 	if (ret)
 		goto out;
 
+	if (test_bit(UB_STATE_STOPPING, &ub->state)) {
+		ret = UBLK_IO_RES_ABORT;
+		goto out;
+	}
+
 	/* UBLK_IO_FETCH_REQ is only allowed before dev is setup */
 	if (ublk_dev_ready(ub)) {
 		ret = -EBUSY;
@@ -3046,22 +3103,27 @@ static bool ublk_validate_user_pid(struct ublk_device *ub, pid_t ublksrv_pid)
 	return ub->ublksrv_tgid == ublksrv_pid;
 }
 
+static bool ublk_dev_ready_or_stopping(const struct ublk_device *ub)
+{
+	return ublk_dev_ready(ub) || test_bit(UB_STATE_STOPPING, &ub->state);
+}
+
 /*
- * Wait until all queues have fetched their I/O commands, and return with
- * ub->mutex held and readiness guaranteed. The queues stay canceling if
- * this round saw a cancel, see ublk_reset_io_flags(). Ready may regress
- * between wakeup and mutex_lock() (daemon death), so re-check it under
- * the mutex and wait again.
+ * Wait until all queues have fetched their I/O commands, or STOP_DEV set
+ * UB_STATE_STOPPING, and return with ub->mutex held. The queues stay
+ * canceling if this round saw a cancel, see ublk_reset_io_flags(). Ready
+ * may regress between wakeup and mutex_lock() (daemon death), so re-check
+ * it under the mutex and wait again.
  */
 static int ublk_wait_dev_ready_and_lock(struct ublk_device *ub)
 {
 	while (true) {
 		if (wait_var_event_interruptible(&ub->nr_io_ready,
-						 ublk_dev_ready(ub)))
+						 ublk_dev_ready_or_stopping(ub)))
 			return -EINTR;
 
 		mutex_lock(&ub->mutex);
-		if (ublk_dev_ready(ub))
+		if (ublk_dev_ready_or_stopping(ub))
 			return 0;
 		mutex_unlock(&ub->mutex);
 	}
@@ -3144,6 +3206,10 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub,
 		ret = -EEXIST;
 		goto out_unlock;
 	}
+	if (test_bit(UB_STATE_STOPPING, &ub->state)) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
 
 	disk = blk_mq_alloc_disk(&ub->tag_set, &lim, NULL);
 	if (IS_ERR(disk)) {
-- 
2.53.0



