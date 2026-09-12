Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06AE263F5D;
	Sat, 12 Sep 2026 14:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223963; cv=none; b=oI10qPbVQ8kJ1X6d9TEP1JTfzh5GrmbQR4HizNOrczLrwJ2hsWKrg33nDQxbTc0ACStE5Hp8Yhe9XtcW96SZStM7GsByRcgecOzer4cgof/pGbc6D/h5cuH/4oDGN3HZRX2EdLd/af9NmvMh+35ptyi2R7ZwmrvCWOxcn+G2Rl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223963; c=relaxed/simple;
	bh=u+qBMpc0J02T5rkgeH2T5IaJJYci7PfFO4YqUYE5RR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGjRA8R8pejBs4Qb+dJhMTfDxBWYCFCc9pj9j43emV0z9BpRpoZYPycBr8J5WgK2j3M8FfUuZZ4/Upz1s8fAcLOwN2B+nnsGOGXEXln1GRwwyWu0UyXsrCJuIMXcHvUIXBEhxuG99MUz/qu7HCTEcyEgoGhq8a0S43CtcqtTCro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEdylZqZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEdylZqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340BE1F000FF;
	Sat, 12 Sep 2026 14:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223961;
	bh=E5fvdk2eaj5LhzbiFC9LZ3lwusdtjUQUCqotp7FlKD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AEdylZqZ8SjnDlAWW/KLf2+jtCqTQ66nKcCxzze8QmEJvL837gdbi1m06DGkQzG0V
	 zS731DcNuaRJI2fJT1gQPcYQCHsICMsNThFB+muWNmqT0Wp63Uyq8UcXPAp+R2jRFL
	 3oXEDbjDSBKzUgKYUOEGdH/iHcwVZ6SLuBfloT3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Pradnya Dahiwale <pradnya.dahiwale@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0895/1424] remoteproc: Prevent crash handling to race with rproc_del()
Date: Sat, 12 Sep 2026 08:55:27 +0200
Message-ID: <20260912065627.372225323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit 74ee3b2f5767447c57959994341e5b95f1079977 ]

There's no synchronization between rproc_crash_handler_work() and
rproc_del(), as such it's possible for a driver to be removed while
crash-handler work is scheduled, or even executing - resulting in
use-after-free issues.

To avoid this the scheduled work need to be cancelled and synchronized
against before the removal proceeds.

In order to ensure that this doesn't race with the reporting, and
thereby scheduling new work, a "deleting" flag is introduced. This is
similar to the RPROC_DELETE state that was introduced to ensure that
"start" didn't race with rproc_del(), but the existing mechanism can not
be used as it's valid to call rproc_report_crash() in atomic context -
and the "state" is protected by a mutex.

In the event that work is cancelled the pm_stay_awake() is left
unbalanced and need to be unrolled.

The blocking and cancelling of crash-handler work prior to the actual
rproc_shutdown() call does have the explicit side-effect that crashes
resulting from the shutdown process will not enter the crash-handling
path, and as such will not generate devcoredumps etc. Due to the
existing mutual exclusion between these code paths there's no concrete
reduction in functionality, but further work would be needed to handle
this case.

Assisted-by: OpenCode:GPT-5.5
Fixes: 8afd519c3470 ("remoteproc: add rproc_report_crash function to notify rproc crashes")
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Reviewed-by: Pradnya Dahiwale <pradnya.dahiwale@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260723-rproc-rmmod-not-crashing-v1-2-546dfd5de0e6@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c  | 42 +++++++++++++++++++++------
 drivers/remoteproc/remoteproc_sysfs.c |  1 -
 include/linux/remoteproc.h            | 13 +++++----
 3 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 9f0087143af02..44029cec53a88 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1840,6 +1840,11 @@ int rproc_trigger_recovery(struct rproc *rproc)
 	if (ret)
 		return ret;
 
+	if (READ_ONCE(rproc->deleting)) {
+		ret = -ENODEV;
+		goto unlock_mutex;
+	}
+
 	/* State could have changed before we got the mutex */
 	if (rproc->state != RPROC_CRASHED)
 		goto unlock_mutex;
@@ -1872,6 +1877,11 @@ static void rproc_crash_handler_work(struct work_struct *work)
 
 	mutex_lock(&rproc->lock);
 
+	if (READ_ONCE(rproc->deleting)) {
+		mutex_unlock(&rproc->lock);
+		goto out;
+	}
+
 	if (rproc->state == RPROC_CRASHED) {
 		/* handle only the first crash detected */
 		mutex_unlock(&rproc->lock);
@@ -1927,9 +1937,9 @@ int rproc_boot(struct rproc *rproc)
 		return ret;
 	}
 
-	if (rproc->state == RPROC_DELETED) {
+	if (READ_ONCE(rproc->deleting)) {
 		ret = -ENODEV;
-		dev_err(dev, "can't boot deleted rproc %s\n", rproc->name);
+		dev_err(dev, "can't boot deleting rproc %s\n", rproc->name);
 		goto unlock_mutex;
 	}
 
@@ -2502,8 +2512,9 @@ struct rproc *rproc_alloc(struct device *dev, const char *name,
 	INIT_LIST_HEAD(&rproc->subdevs);
 	INIT_LIST_HEAD(&rproc->dump_segments);
 
-	INIT_WORK(&rproc->crash_handler, rproc_crash_handler_work);
 	INIT_WORK(&rproc->attach_work, rproc_attach_work);
+	INIT_WORK(&rproc->crash_handler, rproc_crash_handler_work);
+	spin_lock_init(&rproc->crash_handler_lock);
 
 	rproc->state = RPROC_OFFLINE;
 
@@ -2563,16 +2574,21 @@ EXPORT_SYMBOL(rproc_put);
  */
 int rproc_del(struct rproc *rproc)
 {
+	unsigned long flags;
+
 	if (!rproc)
 		return -EINVAL;
 
+	spin_lock_irqsave(&rproc->crash_handler_lock, flags);
+	WRITE_ONCE(rproc->deleting, true);
+	spin_unlock_irqrestore(&rproc->crash_handler_lock, flags);
+
+	if (cancel_work_sync(&rproc->crash_handler))
+		pm_relax(rproc->dev.parent);
+
 	/* TODO: make sure this works with rproc->power > 1 */
 	rproc_shutdown(rproc);
 
-	mutex_lock(&rproc->lock);
-	rproc->state = RPROC_DELETED;
-	mutex_unlock(&rproc->lock);
-
 	rproc_delete_debug_dir(rproc);
 
 	/* the rproc is downref'ed as soon as it's removed from the klist */
@@ -2684,18 +2700,26 @@ EXPORT_SYMBOL(rproc_get_by_child);
  */
 void rproc_report_crash(struct rproc *rproc, enum rproc_crash_type type)
 {
+	unsigned long flags;
+
 	if (!rproc) {
 		pr_err("NULL rproc pointer\n");
 		return;
 	}
 
+	spin_lock_irqsave(&rproc->crash_handler_lock, flags);
+	if (READ_ONCE(rproc->deleting)) {
+		spin_unlock_irqrestore(&rproc->crash_handler_lock, flags);
+		return;
+	}
+
 	/* Prevent suspend while the remoteproc is being recovered */
 	pm_stay_awake(rproc->dev.parent);
+	queue_work(rproc_recovery_wq, &rproc->crash_handler);
+	spin_unlock_irqrestore(&rproc->crash_handler_lock, flags);
 
 	dev_err(&rproc->dev, "crash detected in %s: type %s\n",
 		rproc->name, rproc_crash_to_string(type));
-
-	queue_work(rproc_recovery_wq, &rproc->crash_handler);
 }
 EXPORT_SYMBOL(rproc_report_crash);
 
diff --git a/drivers/remoteproc/remoteproc_sysfs.c b/drivers/remoteproc/remoteproc_sysfs.c
index 8c7ea89226388..23de0490ba161 100644
--- a/drivers/remoteproc/remoteproc_sysfs.c
+++ b/drivers/remoteproc/remoteproc_sysfs.c
@@ -168,7 +168,6 @@ static const char * const rproc_state_string[] = {
 	[RPROC_SUSPENDED]	= "suspended",
 	[RPROC_RUNNING]		= "running",
 	[RPROC_CRASHED]		= "crashed",
-	[RPROC_DELETED]		= "deleted",
 	[RPROC_ATTACHED]	= "attached",
 	[RPROC_DETACHED]	= "detached",
 	[RPROC_LAST]		= "invalid",
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 580d324a1e8ff..023fa91bd2a48 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -37,6 +37,7 @@
 
 #include <linux/types.h>
 #include <linux/mutex.h>
+#include <linux/spinlock.h>
 #include <linux/virtio.h>
 #include <linux/cdev.h>
 #include <linux/completion.h>
@@ -412,7 +413,6 @@ struct rproc_ops {
  *			a message.
  * @RPROC_RUNNING:	device is up and running
  * @RPROC_CRASHED:	device has crashed; need to start recovery
- * @RPROC_DELETED:	device is deleted
  * @RPROC_ATTACHED:	device has been booted by another entity and the core
  *			has attached to it
  * @RPROC_DETACHED:	device has been booted by another entity and waiting
@@ -430,10 +430,9 @@ enum rproc_state {
 	RPROC_SUSPENDED	= 1,
 	RPROC_RUNNING	= 2,
 	RPROC_CRASHED	= 3,
-	RPROC_DELETED	= 4,
-	RPROC_ATTACHED	= 5,
-	RPROC_DETACHED	= 6,
-	RPROC_LAST	= 7,
+	RPROC_ATTACHED	= 4,
+	RPROC_DETACHED	= 5,
+	RPROC_LAST	= 6,
 };
 
 /**
@@ -528,6 +527,8 @@ enum rproc_features {
  * @index: index of this rproc device
  * @attach_work: workqueue for attaching rproc
  * @crash_handler: workqueue for handling a crash
+ * @crash_handler_lock: serializes crash handler queueing and deletion
+ * @deleting: remoteproc deletion has begun
  * @crash_cnt: crash counter
  * @recovery_disabled: flag that state if recovery was disabled
  * @max_notifyid: largest allocated notify id.
@@ -571,6 +572,8 @@ struct rproc {
 	int index;
 	struct work_struct attach_work;
 	struct work_struct crash_handler;
+	spinlock_t crash_handler_lock;
+	bool deleting;
 	unsigned int crash_cnt;
 	bool recovery_disabled;
 	int max_notifyid;
-- 
2.53.0



