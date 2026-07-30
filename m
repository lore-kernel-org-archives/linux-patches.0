Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F123447809;
	Thu, 30 Jul 2026 15:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425037; cv=none; b=CH7nYoZiGN6ZELaohd5eRUALvgraCuiCZRjY93kzcQZ5Z23bec46rPoFm60+XaZ1+N2jinjeMIKbHQ+MmEPz4YoPtLGRPUFV/3hfMBJdhD3D9DEQeH88YHYDtiGDCl5/InIg3M5CQBmoJ2BKCk4yc0Re3PeavXdKpMu8ErQGh2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425037; c=relaxed/simple;
	bh=m8CdCy/8CEDi92nNcf45G6zrwzzJOx9DH5yj1iihpAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ri56eDYFdpnV0N6sBlIN6v8BXELCt3Gx92aD2VqYDXOQsxoZGvLXHzSjUihODKZIzx6MlIKriM7VTokKCbHr1kL9osSVS9a2ckvcl/GNzdkzjdH87AnCmB+7x4Xm+PhUVn5iIIq0ZdkuP9cWWrByAzEdg36IcXbKzDHXdnAYtK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGDilXv5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGDilXv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80511F00A3A;
	Thu, 30 Jul 2026 15:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425036;
	bh=tQfcXSYB485TXPzn0bJNKPCFYLH86vSq5pUw3Ej8evc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EGDilXv5Ld4aiHQ31D4Y/BctM2dKtPjzWbBo88p4UVIAKBYKCxqlVVYyM/nXZVM2m
	 IMeMJC/fvzILGEJPDc8IbLxUkNlCBsXOEFTYwAIia8ap7DUllElhupe/K0QwAW0ynP
	 pakcxrWAtX7dIWYjkf4i9S19VTCC77hhL+r2aVI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Salisbury <gsalisbury@apnic.net>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 597/675] ublk: wait on ublk_dev_ready() instead of ub->completion
Date: Thu, 30 Jul 2026 16:15:27 +0200
Message-ID: <20260730141457.808425912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Ming Lei <tom.leiming@gmail.com>

commit 432a9b2780c0a01caf547bd1fc2fcf28aeb8d173 upstream.

ub->completion is only re-armed by a successful START_USER_RECOVERY. If
the ublk server sends END_USER_RECOVERY without one - e.g. its START
failed with -EBUSY and the error was ignored - the wait is satisfied by
the stale completion of the previous recovery cycle, and the device is
marked LIVE and the requeue list kicked while the FETCH stream is still
running and ubq->canceling is still set. The kick redispatches a
previously requeued request, __ublk_queue_rq_common() sees ->canceling
and parks it again via __ublk_abort_rq(), and after the last FETCH
clears ->canceling nothing ever kicks the requeue list again: the
request is stranded there while holding its tag. If it is the flush
machinery's flush_rq, every subsequent fsync piles up in uninterruptible
sleep and teardown hangs on tag draining. This matches a report of a
lost PREFLUSH with ext4 on top of ublk after daemon crash recovery.

ub->completion is an edge-triggered latch used as a proxy for the level
condition "every queue has fetched all I/O commands", which can regress
(F_BATCH's UNPREP, daemon death) and whose re-arm can be skipped. Drop
it and wait on the real condition instead: the new helper
ublk_wait_dev_ready_and_lock() waits on ublk_dev_ready() via
wait_var_event_interruptible(), woken from ublk_mark_io_ready(), then
re-checks it under ub->mutex, waiting again on regression, and returns
with the mutex held and readiness guaranteed.

Readiness becomes true in the same ub->mutex critical section that
clears the last queue's ->canceling, so END_USER_RECOVERY marks the
device LIVE and kicks the requeue list strictly after ->canceling
clears. The wait stays interruptible, so a server whose daemon died can
still be signalled out. For ublk_ctrl_start_dev() this replaces the
fail-fast -EINVAL on an F_BATCH ready->UNPREP regression with waiting
until the device is ready again.

Reported-by: George Salisbury <gsalisbury@apnic.net>
Fixes: 728cbac5fe21 ("ublk: move device reset into ublk_ch_release()")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20260719134540.120269-1-tom.leiming@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

[ 6.18.y tracks readiness per fetched I/O command in ->nr_io_ready rather
  than per queue in ->nr_queue_ready, so wait and wake on that counter;
  ->canceling is cleared by ublk_reset_io_flags(), which stays in
  ublk_mark_io_ready(). UBLK_F_BATCH_IO does not exist here, so
  ublk_ctrl_start_dev() has no F_BATCH readiness re-check to replace, and
  readiness can only regress via ublk_reset_ch_dev() on daemon death. ]

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 52 ++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index c339222513b03c..cb31e96f01cdd6 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -19,6 +19,7 @@
 #include <linux/errno.h>
 #include <linux/major.h>
 #include <linux/wait.h>
+#include <linux/wait_bit.h>
 #include <linux/blkdev.h>
 #include <linux/init.h>
 #include <linux/swap.h>
@@ -26,7 +27,6 @@
 #include <linux/compat.h>
 #include <linux/mutex.h>
 #include <linux/writeback.h>
-#include <linux/completion.h>
 #include <linux/highmem.h>
 #include <linux/sysfs.h>
 #include <linux/miscdevice.h>
@@ -230,7 +230,6 @@ struct ublk_device {
 
 	struct ublk_params	params;
 
-	struct completion	completion;
 	u32			nr_io_ready;
 	bool 			unprivileged_daemons;
 	struct mutex cancel_mutex;
@@ -2150,9 +2149,13 @@ static void ublk_mark_io_ready(struct ublk_device *ub)
 
 	ub->nr_io_ready++;
 	if (ublk_dev_ready(ub)) {
-		/* now we are ready for handling ublk io request */
+		/*
+		 * now we are ready for handling ublk io request, clear
+		 * device-level canceling flag and wake ublk_dev_ready()
+		 * waiters
+		 */
 		ublk_reset_io_flags(ub);
-		complete_all(&ub->completion);
+		wake_up_var(&ub->nr_io_ready);
 	}
 }
 
@@ -2829,7 +2832,6 @@ static int ublk_init_queues(struct ublk_device *ub)
 			goto fail;
 	}
 
-	init_completion(&ub->completion);
 	return 0;
 
  fail:
@@ -2966,6 +2968,26 @@ static bool ublk_validate_user_pid(struct ublk_device *ub, pid_t ublksrv_pid)
 	return ub->ublksrv_tgid == ublksrv_pid;
 }
 
+/*
+ * Wait until all queues have fetched their I/O commands, and return with
+ * ub->mutex held and readiness guaranteed: then every queue's ->canceling
+ * is cleared. Ready may regress between wakeup and mutex_lock() (daemon
+ * death), so re-check it under the mutex and wait again.
+ */
+static int ublk_wait_dev_ready_and_lock(struct ublk_device *ub)
+{
+	while (true) {
+		if (wait_var_event_interruptible(&ub->nr_io_ready,
+						 ublk_dev_ready(ub)))
+			return -EINTR;
+
+		mutex_lock(&ub->mutex);
+		if (ublk_dev_ready(ub))
+			return 0;
+		mutex_unlock(&ub->mutex);
+	}
+}
+
 static int ublk_ctrl_start_dev(struct ublk_device *ub,
 		const struct ublksrv_ctrl_cmd *header)
 {
@@ -3031,13 +3053,13 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub,
 		lim.max_segments = ub->params.seg.max_segments;
 	}
 
-	if (wait_for_completion_interruptible(&ub->completion) != 0)
+	if (ublk_wait_dev_ready_and_lock(ub))
 		return -EINTR;
 
-	if (!ublk_validate_user_pid(ub, ublksrv_pid))
-		return -EINVAL;
-
-	mutex_lock(&ub->mutex);
+	if (!ublk_validate_user_pid(ub, ublksrv_pid)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
 	if (ub->dev_info.state == UBLK_S_DEV_LIVE ||
 	    test_bit(UB_STATE_USED, &ub->state)) {
 		ret = -EEXIST;
@@ -3549,7 +3571,6 @@ static int ublk_ctrl_start_recovery(struct ublk_device *ub,
 		goto out_unlock;
 	}
 	pr_devel("%s: start recovery for dev id %d.\n", __func__, header->dev_id);
-	init_completion(&ub->completion);
 	ret = 0;
  out_unlock:
 	mutex_unlock(&ub->mutex);
@@ -3565,16 +3586,17 @@ static int ublk_ctrl_end_recovery(struct ublk_device *ub,
 	pr_devel("%s: Waiting for all FETCH_REQs, dev id %d...\n", __func__,
 		 header->dev_id);
 
-	if (wait_for_completion_interruptible(&ub->completion))
+	if (ublk_wait_dev_ready_and_lock(ub))
 		return -EINTR;
 
 	pr_devel("%s: All FETCH_REQs received, dev id %d\n", __func__,
 		 header->dev_id);
 
-	if (!ublk_validate_user_pid(ub, ublksrv_pid))
-		return -EINVAL;
+	if (!ublk_validate_user_pid(ub, ublksrv_pid)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
 
-	mutex_lock(&ub->mutex);
 	if (ublk_nosrv_should_stop_dev(ub))
 		goto out_unlock;
 
-- 
2.53.0



