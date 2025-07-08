Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D88BBE46;
	Tue,  8 Jul 2025 16:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993699; cv=none; b=nXebc6O+tvFqyzKtdGHmgPvC6kUVYLYToNUeklSQn3YljvbzD5bDuDre9zaaPtLyiyU/de0t7T5nMMJ3/RZdLhNLwKUa8RA0o6bYiviNlpHj2XYHNQKZKy4d3739M3Y8MxUW5OsXgSNRctNPrHp+muoPbQADh9ph/lVlH1enkUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993699; c=relaxed/simple;
	bh=HLF1272x8uxMcZDCwco3yHD04lbYT95XkEDTojwuGNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iORUV3D7FIEle4l5iwTxBYTTWtvlkvufxREIaylaEmj1V5Z3Yr55DXYwdjGr3D0WYf7KEOXw8dFrrXYISAP8gnMM4fpti1MyoH81uSAz+SaJN0h55my2fU7KIS2zAXYez9ZqQJi1+mrqmgnevlix5n8YM1sO1Eh2tKPNaW7hNHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=siyD4y6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="siyD4y6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1664C4CEED;
	Tue,  8 Jul 2025 16:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993699;
	bh=HLF1272x8uxMcZDCwco3yHD04lbYT95XkEDTojwuGNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=siyD4y6hy2CAyvlT+m/g1+C/bCAuK7O77Mxqp+We8BpsGwX6XxmGWCnVckDzMbken
	 jrDnZRxxoYs/Th+vpdVBWN5PqlWvVOs2SJPmOg/1Z+eWzI9J3KHOGuWdH8m10K2GMt
	 FHPz7Xw7ue7c98hk5qVvATnn2O2ztNX4zE6z8NJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 6.15 163/178] optee: ffa: fix sleep in atomic context
Date: Tue,  8 Jul 2025 18:23:20 +0200
Message-ID: <20250708162240.738106061@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Wiklander <jens.wiklander@linaro.org>

commit 312d02adb959ea199372f375ada06e0186f651e4 upstream.

The OP-TEE driver registers the function notif_callback() for FF-A
notifications. However, this function is called in an atomic context
leading to errors like this when processing asynchronous notifications:

 | BUG: sleeping function called from invalid context at kernel/locking/mutex.c:258
 | in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 9, name: kworker/0:0
 | preempt_count: 1, expected: 0
 | RCU nest depth: 0, expected: 0
 | CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not tainted 6.14.0-00019-g657536ebe0aa #13
 | Hardware name: linux,dummy-virt (DT)
 | Workqueue: ffa_pcpu_irq_notification notif_pcpu_irq_work_fn
 | Call trace:
 |  show_stack+0x18/0x24 (C)
 |  dump_stack_lvl+0x78/0x90
 |  dump_stack+0x18/0x24
 |  __might_resched+0x114/0x170
 |  __might_sleep+0x48/0x98
 |  mutex_lock+0x24/0x80
 |  optee_get_msg_arg+0x7c/0x21c
 |  simple_call_with_arg+0x50/0xc0
 |  optee_do_bottom_half+0x14/0x20
 |  notif_callback+0x3c/0x48
 |  handle_notif_callbacks+0x9c/0xe0
 |  notif_get_and_handle+0x40/0x88
 |  generic_exec_single+0x80/0xc0
 |  smp_call_function_single+0xfc/0x1a0
 |  notif_pcpu_irq_work_fn+0x2c/0x38
 |  process_one_work+0x14c/0x2b4
 |  worker_thread+0x2e4/0x3e0
 |  kthread+0x13c/0x210
 |  ret_from_fork+0x10/0x20

Fix this by adding work queue to process the notification in a
non-atomic context.

Fixes: d0476a59de06 ("optee: ffa_abi: add asynchronous notifications")
Cc: stable@vger.kernel.org
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Tested-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://lore.kernel.org/r/20250602120452.2507084-1-jens.wiklander@linaro.org
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/optee/ffa_abi.c       |   41 +++++++++++++++++++++++++++++---------
 drivers/tee/optee/optee_private.h |    2 +
 2 files changed, 34 insertions(+), 9 deletions(-)

--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -728,12 +728,21 @@ static bool optee_ffa_exchange_caps(stru
 	return true;
 }
 
+static void notif_work_fn(struct work_struct *work)
+{
+	struct optee_ffa *optee_ffa = container_of(work, struct optee_ffa,
+						   notif_work);
+	struct optee *optee = container_of(optee_ffa, struct optee, ffa);
+
+	optee_do_bottom_half(optee->ctx);
+}
+
 static void notif_callback(int notify_id, void *cb_data)
 {
 	struct optee *optee = cb_data;
 
 	if (notify_id == optee->ffa.bottom_half_value)
-		optee_do_bottom_half(optee->ctx);
+		queue_work(optee->ffa.notif_wq, &optee->ffa.notif_work);
 	else
 		optee_notif_send(optee, notify_id);
 }
@@ -817,9 +826,11 @@ static void optee_ffa_remove(struct ffa_
 	struct optee *optee = ffa_dev_get_drvdata(ffa_dev);
 	u32 bottom_half_id = optee->ffa.bottom_half_value;
 
-	if (bottom_half_id != U32_MAX)
+	if (bottom_half_id != U32_MAX) {
 		ffa_dev->ops->notifier_ops->notify_relinquish(ffa_dev,
 							      bottom_half_id);
+		destroy_workqueue(optee->ffa.notif_wq);
+	}
 	optee_remove_common(optee);
 
 	mutex_destroy(&optee->ffa.mutex);
@@ -835,6 +846,13 @@ static int optee_ffa_async_notif_init(st
 	u32 notif_id = 0;
 	int rc;
 
+	INIT_WORK(&optee->ffa.notif_work, notif_work_fn);
+	optee->ffa.notif_wq = create_workqueue("optee_notification");
+	if (!optee->ffa.notif_wq) {
+		rc = -EINVAL;
+		goto err;
+	}
+
 	while (true) {
 		rc = ffa_dev->ops->notifier_ops->notify_request(ffa_dev,
 								is_per_vcpu,
@@ -851,19 +869,24 @@ static int optee_ffa_async_notif_init(st
 		 * notifications in that case.
 		 */
 		if (rc != -EACCES)
-			return rc;
+			goto err_wq;
 		notif_id++;
 		if (notif_id >= OPTEE_FFA_MAX_ASYNC_NOTIF_VALUE)
-			return rc;
+			goto err_wq;
 	}
 	optee->ffa.bottom_half_value = notif_id;
 
 	rc = enable_async_notif(optee);
-	if (rc < 0) {
-		ffa_dev->ops->notifier_ops->notify_relinquish(ffa_dev,
-							      notif_id);
-		optee->ffa.bottom_half_value = U32_MAX;
-	}
+	if (rc < 0)
+		goto err_rel;
+
+	return 0;
+err_rel:
+	ffa_dev->ops->notifier_ops->notify_relinquish(ffa_dev, notif_id);
+err_wq:
+	destroy_workqueue(optee->ffa.notif_wq);
+err:
+	optee->ffa.bottom_half_value = U32_MAX;
 
 	return rc;
 }
--- a/drivers/tee/optee/optee_private.h
+++ b/drivers/tee/optee/optee_private.h
@@ -165,6 +165,8 @@ struct optee_ffa {
 	/* Serializes access to @global_ids */
 	struct mutex mutex;
 	struct rhashtable global_ids;
+	struct workqueue_struct *notif_wq;
+	struct work_struct notif_work;
 };
 
 struct optee;


