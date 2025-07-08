Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938EE225414;
	Tue,  8 Jul 2025 16:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993330; cv=none; b=umIChxND0bJNIqf6mAH1Ph3R/+bYVJ4gtUIi/kwLVXLZSQF9iCi7AwhEc480wzkUpqOd9sGbuHJqIKJTAuzZnXnBlq9J0PkIrbskddb4JTxERPjqK/iPpppaTxp7mJWEwZmszO5ou16KmCsE9sruWAv88DII5Wrl4AO0KgOaiio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993330; c=relaxed/simple;
	bh=6B+DFUHsomSGL1LMyLaxzPp6thSvZYMAqFJFT4y5cQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jWVuSR7nYZ3NvrHFpvbscBTJLI9YvwOVaupC0lQsu/M4EO8mxgVkX3mQLZM1q1nG5vaYmTLkFBhXIRXh2WJWEVuKJncWqtIe9z4YYhF5oA7ZkLI+vkGNR1XSyT2IJY+PcZxUv3aeOO5L7fb4+0/mDu9btr0esMIxcM2RHamJUn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJrNK/yO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJrNK/yO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5499C4CEED;
	Tue,  8 Jul 2025 16:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993330;
	bh=6B+DFUHsomSGL1LMyLaxzPp6thSvZYMAqFJFT4y5cQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJrNK/yOsn9XBCyCxCTSgJQLbDdOMDI97JFOiXFHC1vj7nfsGgPH8eIVQbUoHMx5t
	 hmcMqfgnrRnoRgUDO56WLNtbTSeHW/BTdr0Q2dWmhivn01CK1vvcdLuqlQJG3g//Id
	 APORgXtJf6CTeWwW83YQrbayTiR8wAt6h+onTHNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Wiklander <jens.wiklander@linaro.org>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Forissier?= <jerome.forissier@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 035/178] firmware: arm_ffa: Replace mutex with rwlock to avoid sleep in atomic context
Date: Tue,  8 Jul 2025 18:21:12 +0200
Message-ID: <20250708162237.600422112@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 9ca7a421229bbdfbe2e1e628cff5cfa782720a10 ]

The current use of a mutex to protect the notifier hashtable accesses
can lead to issues in the atomic context. It results in the below
kernel warnings:

  |  BUG: sleeping function called from invalid context at kernel/locking/mutex.c:258
  |  in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 9, name: kworker/0:0
  |  preempt_count: 1, expected: 0
  |  RCU nest depth: 0, expected: 0
  |  CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not tainted 6.14.0 #4
  |  Workqueue: ffa_pcpu_irq_notification notif_pcpu_irq_work_fn
  |  Call trace:
  |   show_stack+0x18/0x24 (C)
  |   dump_stack_lvl+0x78/0x90
  |   dump_stack+0x18/0x24
  |   __might_resched+0x114/0x170
  |   __might_sleep+0x48/0x98
  |   mutex_lock+0x24/0x80
  |   handle_notif_callbacks+0x54/0xe0
  |   notif_get_and_handle+0x40/0x88
  |   generic_exec_single+0x80/0xc0
  |   smp_call_function_single+0xfc/0x1a0
  |   notif_pcpu_irq_work_fn+0x2c/0x38
  |   process_one_work+0x14c/0x2b4
  |   worker_thread+0x2e4/0x3e0
  |   kthread+0x13c/0x210
  |   ret_from_fork+0x10/0x20

To address this, replace the mutex with an rwlock to protect the notifier
hashtable accesses. This ensures that read-side locking does not sleep and
multiple readers can acquire the lock concurrently, avoiding unnecessary
contention and potential deadlocks. Writer access remains exclusive,
preserving correctness.

This change resolves warnings from lockdep about potential sleep in
atomic context.

Cc: Jens Wiklander <jens.wiklander@linaro.org>
Reported-by: Jérôme Forissier <jerome.forissier@linaro.org>
Closes: https://github.com/OP-TEE/optee_os/issues/7394
Fixes: e0573444edbf ("firmware: arm_ffa: Add interfaces to request notification callbacks")
Message-Id: <20250528-ffa_notif_fix-v1-3-5ed7bc7f8437@arm.com>
Reviewed-by: Jens Wiklander <jens.wiklander@linaro.org>
Tested-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 44eecb786e67b..37eb2e6c2f9f4 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -110,7 +110,7 @@ struct ffa_drv_info {
 	struct work_struct sched_recv_irq_work;
 	struct xarray partition_info;
 	DECLARE_HASHTABLE(notifier_hash, ilog2(FFA_MAX_NOTIFICATIONS));
-	struct mutex notify_lock; /* lock to protect notifier hashtable  */
+	rwlock_t notify_lock; /* lock to protect notifier hashtable  */
 };
 
 static struct ffa_drv_info *drv_info;
@@ -1289,19 +1289,19 @@ static int __ffa_notify_relinquish(struct ffa_device *dev, int notify_id,
 	if (notify_id >= FFA_MAX_NOTIFICATIONS)
 		return -EINVAL;
 
-	mutex_lock(&drv_info->notify_lock);
+	write_lock(&drv_info->notify_lock);
 
 	rc = update_notifier_cb(dev, notify_id, NULL, is_framework);
 	if (rc) {
 		pr_err("Could not unregister notification callback\n");
-		mutex_unlock(&drv_info->notify_lock);
+		write_unlock(&drv_info->notify_lock);
 		return rc;
 	}
 
 	if (!is_framework)
 		rc = ffa_notification_unbind(dev->vm_id, BIT(notify_id));
 
-	mutex_unlock(&drv_info->notify_lock);
+	write_unlock(&drv_info->notify_lock);
 
 	return rc;
 }
@@ -1341,7 +1341,7 @@ static int __ffa_notify_request(struct ffa_device *dev, bool is_per_vcpu,
 	else
 		cb_info->cb = cb;
 
-	mutex_lock(&drv_info->notify_lock);
+	write_lock(&drv_info->notify_lock);
 
 	if (!is_framework) {
 		if (is_per_vcpu)
@@ -1361,7 +1361,7 @@ static int __ffa_notify_request(struct ffa_device *dev, bool is_per_vcpu,
 	}
 
 out_unlock_free:
-	mutex_unlock(&drv_info->notify_lock);
+	write_unlock(&drv_info->notify_lock);
 	if (rc)
 		kfree(cb_info);
 
@@ -1407,9 +1407,9 @@ static void handle_notif_callbacks(u64 bitmap, enum notify_type type)
 		if (!(bitmap & 1))
 			continue;
 
-		mutex_lock(&drv_info->notify_lock);
+		read_lock(&drv_info->notify_lock);
 		cb_info = notifier_hnode_get_by_type(notify_id, type);
-		mutex_unlock(&drv_info->notify_lock);
+		read_unlock(&drv_info->notify_lock);
 
 		if (cb_info && cb_info->cb)
 			cb_info->cb(notify_id, cb_info->cb_data);
@@ -1447,9 +1447,9 @@ static void handle_fwk_notif_callbacks(u32 bitmap)
 
 	ffa_rx_release();
 
-	mutex_lock(&drv_info->notify_lock);
+	read_lock(&drv_info->notify_lock);
 	cb_info = notifier_hnode_get_by_vmid_uuid(notify_id, target, &uuid);
-	mutex_unlock(&drv_info->notify_lock);
+	read_unlock(&drv_info->notify_lock);
 
 	if (cb_info && cb_info->fwk_cb)
 		cb_info->fwk_cb(notify_id, cb_info->cb_data, buf);
@@ -1974,7 +1974,7 @@ static void ffa_notifications_setup(void)
 		goto cleanup;
 
 	hash_init(drv_info->notifier_hash);
-	mutex_init(&drv_info->notify_lock);
+	rwlock_init(&drv_info->notify_lock);
 
 	drv_info->notif_enabled = true;
 	return;
-- 
2.39.5



