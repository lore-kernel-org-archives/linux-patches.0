Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76F0183CB8;
	Tue,  8 Oct 2024 12:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391874; cv=none; b=hYlcp7Ir4FOgLar/hxo18h4QDkvVnpEvseTXVtvN/KqKDqIFrvOChtIAMmN22jQEg1MukC3vD0HgBx5yEtgtQBmVJJQKaTeyzf76qBJQvx2fIzPZE+GsuKrdh1o5tm1nlrzaJZVbqQePZsZDcXP054Qdcl2iMlh+Gc9wLy6jATU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391874; c=relaxed/simple;
	bh=r2Ms1JhGRvS/VzTHonLsJkZL7xi7zd5tojEi7OBbC20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6o6VPeXwNgYckmHNiwI35E4v7wKKqYICrVGK0594pJrJQTuFrY7MQZWjLvPHZui3vAPswFhz4P3coMEc2+ovKUHsKIVdwyPm9GKe2AoC76RkSCrP1ZViL1ltv91qJTyzAcpPIT8dJro0FJ03XEIQtk4wo9L2KY1PiCqFkkHypE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAJUzI8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAJUzI8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF56C4CEC7;
	Tue,  8 Oct 2024 12:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391874;
	bh=r2Ms1JhGRvS/VzTHonLsJkZL7xi7zd5tojEi7OBbC20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EAJUzI8GL1mhaaf8KW+XrgCSqpEzZpWSkMcxl1mk6JlKVTUpjHfooWElvgenKuVuG
	 AVkTIXyfcermOq4kZJmdo2XqkNNzCXmhmU9IxsQL98vZDvQqlgCa22gVbYvOSUANGU
	 nkoaK8kFv2f+m5x4I47owSBd43AhnY+k2Dd3Fc0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 249/558] drm/xe: Add timeout to preempt fences
Date: Tue,  8 Oct 2024 14:04:39 +0200
Message-ID: <20241008115712.136878374@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 627c961d672d3304564455ba471f5e4405170eec ]

To adhere to dma fencing rules that fences must signal within a
reasonable amount of time, add a 5 second timeout to preempt fences. If
this timeout occurs, kill the associated VM as this fatal to the VM.

v2:
 - Add comment for smp_wmb (Checkpatch)
 - Fix kernel doc typo (Inspection)
 - Add comment for killed check (Niranjana)
v3:
 - Drop smp_wmb (Matthew Auld)
 - Don't take vm->lock in preempt fence worker (Matthew Auld)
 - Drop RB given changes to patch
v4:
 - Add WRITE/READ_ONCE (Niranjana)
 - Don't export xe_vm_kill (Niranjana)

Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Tested-by: Stuart Summers <stuart.summers@intel.com>
Reviewed-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240626004137.4060806-1-matthew.brost@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec_queue_types.h |  6 ++--
 drivers/gpu/drm/xe/xe_execlist.c         |  3 +-
 drivers/gpu/drm/xe/xe_guc_submit.c       | 39 ++++++++++++++++++++----
 drivers/gpu/drm/xe/xe_preempt_fence.c    | 12 ++++++--
 drivers/gpu/drm/xe/xe_vm.c               | 12 +++++++-
 5 files changed, 59 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_exec_queue_types.h b/drivers/gpu/drm/xe/xe_exec_queue_types.h
index f6ee0ae80fd63..fc2a1a20b7e4b 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue_types.h
+++ b/drivers/gpu/drm/xe/xe_exec_queue_types.h
@@ -169,9 +169,11 @@ struct xe_exec_queue_ops {
 	int (*suspend)(struct xe_exec_queue *q);
 	/**
 	 * @suspend_wait: Wait for an exec queue to suspend executing, should be
-	 * call after suspend.
+	 * call after suspend. In dma-fencing path thus must return within a
+	 * reasonable amount of time. -ETIME return shall indicate an error
+	 * waiting for suspend resulting in associated VM getting killed.
 	 */
-	void (*suspend_wait)(struct xe_exec_queue *q);
+	int (*suspend_wait)(struct xe_exec_queue *q);
 	/**
 	 * @resume: Resume exec queue execution, exec queue must be in a suspended
 	 * state and dma fence returned from most recent suspend call must be
diff --git a/drivers/gpu/drm/xe/xe_execlist.c b/drivers/gpu/drm/xe/xe_execlist.c
index db906117db6d6..7502e3486eafa 100644
--- a/drivers/gpu/drm/xe/xe_execlist.c
+++ b/drivers/gpu/drm/xe/xe_execlist.c
@@ -422,10 +422,11 @@ static int execlist_exec_queue_suspend(struct xe_exec_queue *q)
 	return 0;
 }
 
-static void execlist_exec_queue_suspend_wait(struct xe_exec_queue *q)
+static int execlist_exec_queue_suspend_wait(struct xe_exec_queue *q)
 
 {
 	/* NIY */
+	return 0;
 }
 
 static void execlist_exec_queue_resume(struct xe_exec_queue *q)
diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index 64b3a7848f4ab..fd4ac3899edd2 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1318,6 +1318,15 @@ static void __guc_exec_queue_process_msg_set_sched_props(struct xe_sched_msg *ms
 	kfree(msg);
 }
 
+static void __suspend_fence_signal(struct xe_exec_queue *q)
+{
+	if (!q->guc->suspend_pending)
+		return;
+
+	WRITE_ONCE(q->guc->suspend_pending, false);
+	wake_up(&q->guc->suspend_wait);
+}
+
 static void suspend_fence_signal(struct xe_exec_queue *q)
 {
 	struct xe_guc *guc = exec_queue_to_guc(q);
@@ -1327,9 +1336,7 @@ static void suspend_fence_signal(struct xe_exec_queue *q)
 		  guc_read_stopped(guc));
 	xe_assert(xe, q->guc->suspend_pending);
 
-	q->guc->suspend_pending = false;
-	smp_wmb();
-	wake_up(&q->guc->suspend_wait);
+	__suspend_fence_signal(q);
 }
 
 static void __guc_exec_queue_process_msg_suspend(struct xe_sched_msg *msg)
@@ -1486,6 +1493,7 @@ static void guc_exec_queue_kill(struct xe_exec_queue *q)
 {
 	trace_xe_exec_queue_kill(q);
 	set_exec_queue_killed(q);
+	__suspend_fence_signal(q);
 	xe_guc_exec_queue_trigger_cleanup(q);
 }
 
@@ -1584,12 +1592,31 @@ static int guc_exec_queue_suspend(struct xe_exec_queue *q)
 	return 0;
 }
 
-static void guc_exec_queue_suspend_wait(struct xe_exec_queue *q)
+static int guc_exec_queue_suspend_wait(struct xe_exec_queue *q)
 {
 	struct xe_guc *guc = exec_queue_to_guc(q);
+	int ret;
+
+	/*
+	 * Likely don't need to check exec_queue_killed() as we clear
+	 * suspend_pending upon kill but to be paranoid but races in which
+	 * suspend_pending is set after kill also check kill here.
+	 */
+	ret = wait_event_timeout(q->guc->suspend_wait,
+				 !READ_ONCE(q->guc->suspend_pending) ||
+				 exec_queue_killed(q) ||
+				 guc_read_stopped(guc),
+				 HZ * 5);
 
-	wait_event(q->guc->suspend_wait, !q->guc->suspend_pending ||
-		   guc_read_stopped(guc));
+	if (!ret) {
+		xe_gt_warn(guc_to_gt(guc),
+			   "Suspend fence, guc_id=%d, failed to respond",
+			   q->guc->id);
+		/* XXX: Trigger GT reset? */
+		return -ETIME;
+	}
+
+	return 0;
 }
 
 static void guc_exec_queue_resume(struct xe_exec_queue *q)
diff --git a/drivers/gpu/drm/xe/xe_preempt_fence.c b/drivers/gpu/drm/xe/xe_preempt_fence.c
index c453f45328b1c..83fbeea5aa201 100644
--- a/drivers/gpu/drm/xe/xe_preempt_fence.c
+++ b/drivers/gpu/drm/xe/xe_preempt_fence.c
@@ -17,10 +17,16 @@ static void preempt_fence_work_func(struct work_struct *w)
 		container_of(w, typeof(*pfence), preempt_work);
 	struct xe_exec_queue *q = pfence->q;
 
-	if (pfence->error)
+	if (pfence->error) {
 		dma_fence_set_error(&pfence->base, pfence->error);
-	else
-		q->ops->suspend_wait(q);
+	} else if (!q->ops->reset_status(q)) {
+		int err = q->ops->suspend_wait(q);
+
+		if (err)
+			dma_fence_set_error(&pfence->base, err);
+	} else {
+		dma_fence_set_error(&pfence->base, -ENOENT);
+	}
 
 	dma_fence_signal(&pfence->base);
 	/*
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index b49bee0dfac5d..743c8d79d79d2 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -133,8 +133,10 @@ static int wait_for_existing_preempt_fences(struct xe_vm *vm)
 		if (q->lr.pfence) {
 			long timeout = dma_fence_wait(q->lr.pfence, false);
 
-			if (timeout < 0)
+			/* Only -ETIME on fence indicates VM needs to be killed */
+			if (timeout < 0 || q->lr.pfence->error == -ETIME)
 				return -ETIME;
+
 			dma_fence_put(q->lr.pfence);
 			q->lr.pfence = NULL;
 		}
@@ -311,6 +313,14 @@ int __xe_vm_userptr_needs_repin(struct xe_vm *vm)
 
 #define XE_VM_REBIND_RETRY_TIMEOUT_MS 1000
 
+/*
+ * xe_vm_kill() - VM Kill
+ * @vm: The VM.
+ * @unlocked: Flag indicates the VM's dma-resv is not held
+ *
+ * Kill the VM by setting banned flag indicated VM is no longer available for
+ * use. If in preempt fence mode, also kill all exec queue attached to the VM.
+ */
 static void xe_vm_kill(struct xe_vm *vm, bool unlocked)
 {
 	struct xe_exec_queue *q;
-- 
2.43.0



