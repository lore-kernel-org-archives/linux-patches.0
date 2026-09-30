Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C184E36F1;
	Wed, 30 Sep 2026 18:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791878; cv=none; b=GKsBGjZl0qHDBaL1bOPmPG+A3Te8F2VR+duUATQiejniLjxDKuec4h4cLwPv7M3Uha0izWddSGc+Ke0y2ti6VRQsC06HIJvUpW6RUuseRzPy3zpQA+DS6aOYkqQxgcmXhLX01R0BZS79FKBBorE2tZp02xht9KOpdsqFy0NUQiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791878; c=relaxed/simple;
	bh=WsdWwchSsY08CHv7B1N19GYbmsDodPf800gUULImvKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGBiqZC1cpq/O5mgNNW+ho4Z9yDnmLHQA8WLtqVkJCCIaXOnthl15n4M88ke5Pi9hMrkGB20c+aMBEJwRwlIdvIOKr4vHCwvOFiTeTKoKBBlF2v7riT0iGceekQRVnrxnhwAbURI8VvGzKeUdz19bp+kOlTtkVxJt0A65MTYh7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1SKAf5n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1SKAf5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5CB1F00898;
	Wed, 30 Sep 2026 18:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791877;
	bh=QcHnIVjK/aet6TICTRMaY08+awzHKB7MjgLBiXgD59c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b1SKAf5nSIrWkaYznl0zoYHe6FZSPX6nKDGYHWqDDDqg2fDopnG9Ph37sFxB5/IdR
	 2mXLepiyu3EuvnzaexcAr5G56aZ9FZ226hsT8kLnoVr98JlV6d0mPy9EguZMTMChWF
	 tFW0hg6Os96/90nVBP3yrAoHL4mN7G4atH0I2kx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 455/752] IB/isert: wait for deferred control PDU completions before releasing the connection
Date: Wed, 30 Sep 2026 17:25:25 +0200
Message-ID: <20260930152408.122436761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit a8fe3dfce8c0d8a76dc3d8486a5bff5feebe156f ]

isert_send_done() hands ISTATE_SEND_TASKMGTRSP, ISTATE_SEND_REJECT and
ISTATE_SEND_TEXTRSP completions off to isert_comp_wq and returns.  The work
item then runs isert_completion_put() -> isert_put_cmd(), which reads
isert_conn->conn and takes conn->cmd_lock.

Nothing orders that work item against teardown.  isert_wait_conn() queues
isert_release_work, which frees isert_conn, and iscsit_close_connection()
frees the iscsit_conn right after it returns, so the queued work can run
against freed memory.

Count the deferred control PDU completions per connection and let
isert_wait_conn() wait for them before the release work is queued.

ISTATE_SEND_LOGOUTRSP is deliberately not counted: that branch runs
iscsit_logout_post_handler(), which ends up waiting for
conn->conn_wait_comp, and that completion is only sent by
iscsit_close_connection() after it has called iscsit_wait_conn().
Waiting for it here would deadlock.  Its wait stays the existing
isert_wait4logout().

The splat below is from a kernel with tracing printk()s and an msleep(200)
injected into isert_do_control_comp() to widen the window:

  BUG: KASAN: slab-use-after-free in isert_put_cmd+0x53d/0x620
  Read of size 8 at addr ffff8881054f1038 by task kworker/u17:1/182

  CPU: 0 UID: 0 PID: 182 Comm: kworker/u17:1 Tainted: G    B               7.2.0-rc5-TWIDE-gb8babf08acc7 #1 PREEMPT(lazy)
  Tainted: [B]=BAD_PAGE
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Workqueue: isert_comp_wq isert_do_control_comp
  Call Trace:
   <TASK>
   dump_stack_lvl+0x53/0x70
   print_report+0xd0/0x630
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? _raw_spin_unlock_irqrestore+0x3e/0x70
   ? isert_put_cmd+0x53d/0x620
   kasan_report+0xce/0x100
   ? isert_put_cmd+0x53d/0x620
   isert_put_cmd+0x53d/0x620
   ? isert_completion_put+0x305/0x330
   ? isert_do_control_comp+0x2ef/0x310
   process_one_work+0x633/0x1030
   ? assign_work+0x11d/0x370
   worker_thread+0x45b/0xd10
   ? __pfx_worker_thread+0x10/0x10
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x2c6/0x3b0
   ? recalc_sigpending+0x15c/0x1e0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x36e/0x5a0
   ? __pfx_ret_from_fork+0x10/0x10
   ? __switch_to+0x572/0xdd0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>

  Allocated by task 48:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   __kasan_kmalloc+0x8f/0xa0
   __kmalloc_cache_noprof+0x158/0x370
   isert_cma_handler+0x1e3/0x2ae0
   cma_cm_event_handler+0x3e/0x240
   cma_ib_req_handler+0x17d9/0x4490
   cm_process_work+0x41/0x330
   cm_work_handler+0x5727/0xc160
   process_one_work+0x633/0x1030
   worker_thread+0x45b/0xd10
   kthread+0x2c6/0x3b0
   ret_from_fork+0x36e/0x5a0
   ret_from_fork_asm+0x1a/0x30

  Freed by task 184:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   kasan_save_free_info+0x3b/0x60
   __kasan_slab_free+0x43/0x70
   kfree+0x121/0x380
   iscsit_close_connection+0x7cf/0x1e60
   iscsit_take_action_for_connection_exit+0x1b6/0x360
   iscsi_target_tx_thread+0x472/0x690
   kthread+0x2c6/0x3b0
   ret_from_fork+0x36e/0x5a0
   ret_from_fork_asm+0x1a/0x30

Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Link: https://patch.msgid.link/20260821080620.1694119-1-yhlee@isslab.korea.ac.kr
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 22 ++++++++++++++++++++++
 drivers/infiniband/ulp/isert/ib_isert.h |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 2ab17b0aab191..6325d1f65b369 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -21,6 +21,7 @@
 #include <target/target_core_fabric.h>
 #include <target/iscsi/iscsi_transport.h>
 #include <linux/semaphore.h>
+#include <linux/wait_bit.h>
 
 #include "ib_isert.h"
 
@@ -313,6 +314,7 @@ isert_init_conn(struct isert_conn *isert_conn)
 	init_completion(&isert_conn->login_req_comp);
 	init_waitqueue_head(&isert_conn->rem_wait);
 	kref_init(&isert_conn->kref);
+	atomic_set(&isert_conn->ctrl_comp_cnt, 0);
 	mutex_init(&isert_conn->mutex);
 	INIT_WORK(&isert_conn->release_work, isert_release_work);
 }
@@ -1700,6 +1702,8 @@ isert_do_control_comp(struct work_struct *work)
 	struct isert_conn *isert_conn = isert_cmd->conn;
 	struct ib_device *ib_dev = isert_conn->cm_id->device;
 	struct iscsit_cmd *cmd = isert_cmd->iscsit_cmd;
+	/* The switch below may free isert_cmd. */
+	bool counted = isert_cmd->ctrl_counted;
 
 	isert_dbg("Cmd %p i_state %d\n", isert_cmd, cmd->i_state);
 
@@ -1721,6 +1725,14 @@ isert_do_control_comp(struct work_struct *work)
 		dump_stack();
 		break;
 	}
+
+	/*
+	 * The count is what keeps isert_conn alive, so drop it last.  The wait
+	 * queue lives in the global hash table, not in isert_conn, so this is
+	 * safe even if the waiter has already freed the connection.
+	 */
+	if (counted && atomic_dec_and_test(&isert_conn->ctrl_comp_cnt))
+		wake_up_var(&isert_conn->ctrl_comp_cnt);
 }
 
 static void
@@ -1764,6 +1776,12 @@ isert_send_done(struct ib_cq *cq, struct ib_wc *wc)
 	case ISTATE_SEND_TEXTRSP:
 		isert_unmap_tx_desc(tx_desc, ib_dev);
 
+		/* Paired with the wait in isert_wait_conn(). */
+		isert_cmd->ctrl_counted =
+			isert_cmd->iscsit_cmd->i_state != ISTATE_SEND_LOGOUTRSP;
+		if (isert_cmd->ctrl_counted)
+			atomic_inc(&isert_conn->ctrl_comp_cnt);
+
 		INIT_WORK(&isert_cmd->comp_work, isert_do_control_comp);
 		queue_work(isert_comp_wq, &isert_cmd->comp_work);
 		return;
@@ -2608,6 +2626,10 @@ static void isert_wait_conn(struct iscsi_conn *conn)
 	isert_wait4cmds(conn);
 	isert_wait4logout(isert_conn);
 
+	/* Paired with the count taken in isert_send_done(). */
+	wait_var_event(&isert_conn->ctrl_comp_cnt,
+		       !atomic_read(&isert_conn->ctrl_comp_cnt));
+
 	queue_work(isert_release_wq, &isert_conn->release_work);
 }
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index cc315fbb70e75..83fbfb8dbf32e 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -153,6 +153,7 @@ struct isert_cmd {
 	struct work_struct	comp_work;
 	struct scatterlist	sg;
 	bool			ctx_init_done;
+	bool			ctrl_counted;
 };
 
 static inline struct isert_cmd *tx_desc_to_cmd(struct iser_tx_desc *desc)
@@ -187,6 +188,7 @@ struct isert_conn {
 	struct mutex		mutex;
 	struct kref		kref;
 	struct work_struct	release_work;
+	atomic_t		ctrl_comp_cnt;
 	bool                    logout_posted;
 	bool                    snd_w_inv;
 	wait_queue_head_t	rem_wait;
-- 
2.53.0



