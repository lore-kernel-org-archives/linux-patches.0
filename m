Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A48D1547CC;
	Mon, 22 Sep 2025 19:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570372; cv=none; b=kpyd6dRTvJBpVYfmUnvgGAMHhZ2G0bNR1VGIEdgIH5SxyCm7bXwA7g0nXdhdtyanG2t/2bsuFBlA4HcMDgcCMeLUOvAmabR6OaAQqr93evsj3yOcpxSFoWkxe+2oJqf3kTjvprmiD1xrSxuLmlrTK6jNiN+XC3F6j6069N/YtAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570372; c=relaxed/simple;
	bh=lZI0p8K+1U7KXvX+dw8+nNsdCD0we0iLSXxdcjfSeoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdTle1glRsTiHb+ZdwJ1skyc+GCVA1b++V1VqRWXpq0RNgENN20+KQmKZGC/K7D78Uq6bSks1pgQcjim968SeAoqzVt4jUlwYrhmDZu7cfgMfJZcE0kj2gL5gJAOG7slpP6h4gr4vbSBw/j7YioRY6Z8QoO3bvRbvaCZ67lEZUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wXryW9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wXryW9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72CCC4CEF0;
	Mon, 22 Sep 2025 19:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570372;
	bh=lZI0p8K+1U7KXvX+dw8+nNsdCD0we0iLSXxdcjfSeoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1wXryW9Vt4oxFSJOKkq4T5lFO6vk/IVqXIq8xwbTJqNbPfauIk4NsJ4webah5Z6RB
	 JTDrR0t28YiWm4Gi0Bd1fs1ygMjCdDZrxyQwNhYZLSqGmaPe62w25UhPLkhr6MXc6J
	 TzV0l4PynCFOblR++Tx437V0y0kUw2AFhG3EPLdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 123/149] drm/xe: Fix error handling if PXP fails to start
Date: Mon, 22 Sep 2025 21:30:23 +0200
Message-ID: <20250922192415.975124478@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit ae5fbbda341f92e605a9508a0fb18456155517f0 ]

Since the PXP start comes after __xe_exec_queue_init() has completed,
we need to cleanup what was done in that function in case of a PXP
start error.
__xe_exec_queue_init calls the submission backend init() function,
so we need to introduce an opposite for that. Unfortunately, while
we already have a fini() function pointer, it performs other
operations in addition to cleaning up what was done by the init().
Therefore, for clarity, the existing fini() has been renamed to
destroy(), while a new fini() has been added to only clean up what was
done by the init(), with the latter being called by the former (via
xe_exec_queue_fini).

Fixes: 72d479601d67 ("drm/xe/pxp/uapi: Add userspace and LRC support for PXP-using queues")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://lore.kernel.org/r/20250909221240.3711023-3-daniele.ceraolospurio@intel.com
(cherry picked from commit 626667321deb4c7a294725406faa3dd71c3d445d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec_queue.c           | 22 ++++++---
 drivers/gpu/drm/xe/xe_exec_queue_types.h     |  8 ++-
 drivers/gpu/drm/xe/xe_execlist.c             | 25 ++++++----
 drivers/gpu/drm/xe/xe_execlist_types.h       |  2 +-
 drivers/gpu/drm/xe/xe_guc_exec_queue_types.h |  4 +-
 drivers/gpu/drm/xe/xe_guc_submit.c           | 52 ++++++++++++--------
 6 files changed, 72 insertions(+), 41 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
index fee22358cc09b..e511697596146 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.c
+++ b/drivers/gpu/drm/xe/xe_exec_queue.c
@@ -151,6 +151,16 @@ static int __xe_exec_queue_init(struct xe_exec_queue *q)
 	return err;
 }
 
+static void __xe_exec_queue_fini(struct xe_exec_queue *q)
+{
+	int i;
+
+	q->ops->fini(q);
+
+	for (i = 0; i < q->width; ++i)
+		xe_lrc_put(q->lrc[i]);
+}
+
 struct xe_exec_queue *xe_exec_queue_create(struct xe_device *xe, struct xe_vm *vm,
 					   u32 logical_mask, u16 width,
 					   struct xe_hw_engine *hwe, u32 flags,
@@ -181,11 +191,13 @@ struct xe_exec_queue *xe_exec_queue_create(struct xe_device *xe, struct xe_vm *v
 	if (xe_exec_queue_uses_pxp(q)) {
 		err = xe_pxp_exec_queue_add(xe->pxp, q);
 		if (err)
-			goto err_post_alloc;
+			goto err_post_init;
 	}
 
 	return q;
 
+err_post_init:
+	__xe_exec_queue_fini(q);
 err_post_alloc:
 	__xe_exec_queue_free(q);
 	return ERR_PTR(err);
@@ -283,13 +295,11 @@ void xe_exec_queue_destroy(struct kref *ref)
 			xe_exec_queue_put(eq);
 	}
 
-	q->ops->fini(q);
+	q->ops->destroy(q);
 }
 
 void xe_exec_queue_fini(struct xe_exec_queue *q)
 {
-	int i;
-
 	/*
 	 * Before releasing our ref to lrc and xef, accumulate our run ticks
 	 * and wakeup any waiters.
@@ -298,9 +308,7 @@ void xe_exec_queue_fini(struct xe_exec_queue *q)
 	if (q->xef && atomic_dec_and_test(&q->xef->exec_queue.pending_removal))
 		wake_up_var(&q->xef->exec_queue.pending_removal);
 
-	for (i = 0; i < q->width; ++i)
-		xe_lrc_put(q->lrc[i]);
-
+	__xe_exec_queue_fini(q);
 	__xe_exec_queue_free(q);
 }
 
diff --git a/drivers/gpu/drm/xe/xe_exec_queue_types.h b/drivers/gpu/drm/xe/xe_exec_queue_types.h
index cc1cffb5c87f1..1c9d03f2a3e5d 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue_types.h
+++ b/drivers/gpu/drm/xe/xe_exec_queue_types.h
@@ -166,8 +166,14 @@ struct xe_exec_queue_ops {
 	int (*init)(struct xe_exec_queue *q);
 	/** @kill: Kill inflight submissions for backend */
 	void (*kill)(struct xe_exec_queue *q);
-	/** @fini: Fini exec queue for submission backend */
+	/** @fini: Undoes the init() for submission backend */
 	void (*fini)(struct xe_exec_queue *q);
+	/**
+	 * @destroy: Destroy exec queue for submission backend. The backend
+	 * function must call xe_exec_queue_fini() (which will in turn call the
+	 * fini() backend function) to ensure the queue is properly cleaned up.
+	 */
+	void (*destroy)(struct xe_exec_queue *q);
 	/** @set_priority: Set priority for exec queue */
 	int (*set_priority)(struct xe_exec_queue *q,
 			    enum xe_exec_queue_priority priority);
diff --git a/drivers/gpu/drm/xe/xe_execlist.c b/drivers/gpu/drm/xe/xe_execlist.c
index 788f56b066b6a..f83d421ac9d3d 100644
--- a/drivers/gpu/drm/xe/xe_execlist.c
+++ b/drivers/gpu/drm/xe/xe_execlist.c
@@ -385,10 +385,20 @@ static int execlist_exec_queue_init(struct xe_exec_queue *q)
 	return err;
 }
 
-static void execlist_exec_queue_fini_async(struct work_struct *w)
+static void execlist_exec_queue_fini(struct xe_exec_queue *q)
+{
+	struct xe_execlist_exec_queue *exl = q->execlist;
+
+	drm_sched_entity_fini(&exl->entity);
+	drm_sched_fini(&exl->sched);
+
+	kfree(exl);
+}
+
+static void execlist_exec_queue_destroy_async(struct work_struct *w)
 {
 	struct xe_execlist_exec_queue *ee =
-		container_of(w, struct xe_execlist_exec_queue, fini_async);
+		container_of(w, struct xe_execlist_exec_queue, destroy_async);
 	struct xe_exec_queue *q = ee->q;
 	struct xe_execlist_exec_queue *exl = q->execlist;
 	struct xe_device *xe = gt_to_xe(q->gt);
@@ -401,10 +411,6 @@ static void execlist_exec_queue_fini_async(struct work_struct *w)
 		list_del(&exl->active_link);
 	spin_unlock_irqrestore(&exl->port->lock, flags);
 
-	drm_sched_entity_fini(&exl->entity);
-	drm_sched_fini(&exl->sched);
-	kfree(exl);
-
 	xe_exec_queue_fini(q);
 }
 
@@ -413,10 +419,10 @@ static void execlist_exec_queue_kill(struct xe_exec_queue *q)
 	/* NIY */
 }
 
-static void execlist_exec_queue_fini(struct xe_exec_queue *q)
+static void execlist_exec_queue_destroy(struct xe_exec_queue *q)
 {
-	INIT_WORK(&q->execlist->fini_async, execlist_exec_queue_fini_async);
-	queue_work(system_unbound_wq, &q->execlist->fini_async);
+	INIT_WORK(&q->execlist->destroy_async, execlist_exec_queue_destroy_async);
+	queue_work(system_unbound_wq, &q->execlist->destroy_async);
 }
 
 static int execlist_exec_queue_set_priority(struct xe_exec_queue *q,
@@ -467,6 +473,7 @@ static const struct xe_exec_queue_ops execlist_exec_queue_ops = {
 	.init = execlist_exec_queue_init,
 	.kill = execlist_exec_queue_kill,
 	.fini = execlist_exec_queue_fini,
+	.destroy = execlist_exec_queue_destroy,
 	.set_priority = execlist_exec_queue_set_priority,
 	.set_timeslice = execlist_exec_queue_set_timeslice,
 	.set_preempt_timeout = execlist_exec_queue_set_preempt_timeout,
diff --git a/drivers/gpu/drm/xe/xe_execlist_types.h b/drivers/gpu/drm/xe/xe_execlist_types.h
index 415140936f11d..92c4ba52db0cb 100644
--- a/drivers/gpu/drm/xe/xe_execlist_types.h
+++ b/drivers/gpu/drm/xe/xe_execlist_types.h
@@ -42,7 +42,7 @@ struct xe_execlist_exec_queue {
 
 	bool has_run;
 
-	struct work_struct fini_async;
+	struct work_struct destroy_async;
 
 	enum xe_exec_queue_priority active_priority;
 	struct list_head active_link;
diff --git a/drivers/gpu/drm/xe/xe_guc_exec_queue_types.h b/drivers/gpu/drm/xe/xe_guc_exec_queue_types.h
index a3f421e2adc03..c30c0e3ccbbb9 100644
--- a/drivers/gpu/drm/xe/xe_guc_exec_queue_types.h
+++ b/drivers/gpu/drm/xe/xe_guc_exec_queue_types.h
@@ -35,8 +35,8 @@ struct xe_guc_exec_queue {
 	struct xe_sched_msg static_msgs[MAX_STATIC_MSG_TYPE];
 	/** @lr_tdr: long running TDR worker */
 	struct work_struct lr_tdr;
-	/** @fini_async: do final fini async from this worker */
-	struct work_struct fini_async;
+	/** @destroy_async: do final destroy async from this worker */
+	struct work_struct destroy_async;
 	/** @resume_time: time of last resume */
 	u64 resume_time;
 	/** @state: GuC specific state for this xe_exec_queue */
diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index ef3e9e1588f7c..45a21af126927 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1269,48 +1269,57 @@ guc_exec_queue_timedout_job(struct drm_sched_job *drm_job)
 	return DRM_GPU_SCHED_STAT_NOMINAL;
 }
 
-static void __guc_exec_queue_fini_async(struct work_struct *w)
+static void guc_exec_queue_fini(struct xe_exec_queue *q)
+{
+	struct xe_guc_exec_queue *ge = q->guc;
+	struct xe_guc *guc = exec_queue_to_guc(q);
+
+	release_guc_id(guc, q);
+	xe_sched_entity_fini(&ge->entity);
+	xe_sched_fini(&ge->sched);
+
+	/*
+	 * RCU free due sched being exported via DRM scheduler fences
+	 * (timeline name).
+	 */
+	kfree_rcu(ge, rcu);
+}
+
+static void __guc_exec_queue_destroy_async(struct work_struct *w)
 {
 	struct xe_guc_exec_queue *ge =
-		container_of(w, struct xe_guc_exec_queue, fini_async);
+		container_of(w, struct xe_guc_exec_queue, destroy_async);
 	struct xe_exec_queue *q = ge->q;
 	struct xe_guc *guc = exec_queue_to_guc(q);
 
 	xe_pm_runtime_get(guc_to_xe(guc));
 	trace_xe_exec_queue_destroy(q);
 
-	release_guc_id(guc, q);
 	if (xe_exec_queue_is_lr(q))
 		cancel_work_sync(&ge->lr_tdr);
 	/* Confirm no work left behind accessing device structures */
 	cancel_delayed_work_sync(&ge->sched.base.work_tdr);
-	xe_sched_entity_fini(&ge->entity);
-	xe_sched_fini(&ge->sched);
 
-	/*
-	 * RCU free due sched being exported via DRM scheduler fences
-	 * (timeline name).
-	 */
-	kfree_rcu(ge, rcu);
 	xe_exec_queue_fini(q);
+
 	xe_pm_runtime_put(guc_to_xe(guc));
 }
 
-static void guc_exec_queue_fini_async(struct xe_exec_queue *q)
+static void guc_exec_queue_destroy_async(struct xe_exec_queue *q)
 {
 	struct xe_guc *guc = exec_queue_to_guc(q);
 	struct xe_device *xe = guc_to_xe(guc);
 
-	INIT_WORK(&q->guc->fini_async, __guc_exec_queue_fini_async);
+	INIT_WORK(&q->guc->destroy_async, __guc_exec_queue_destroy_async);
 
 	/* We must block on kernel engines so slabs are empty on driver unload */
 	if (q->flags & EXEC_QUEUE_FLAG_PERMANENT || exec_queue_wedged(q))
-		__guc_exec_queue_fini_async(&q->guc->fini_async);
+		__guc_exec_queue_destroy_async(&q->guc->destroy_async);
 	else
-		queue_work(xe->destroy_wq, &q->guc->fini_async);
+		queue_work(xe->destroy_wq, &q->guc->destroy_async);
 }
 
-static void __guc_exec_queue_fini(struct xe_guc *guc, struct xe_exec_queue *q)
+static void __guc_exec_queue_destroy(struct xe_guc *guc, struct xe_exec_queue *q)
 {
 	/*
 	 * Might be done from within the GPU scheduler, need to do async as we
@@ -1319,7 +1328,7 @@ static void __guc_exec_queue_fini(struct xe_guc *guc, struct xe_exec_queue *q)
 	 * this we and don't really care when everything is fini'd, just that it
 	 * is.
 	 */
-	guc_exec_queue_fini_async(q);
+	guc_exec_queue_destroy_async(q);
 }
 
 static void __guc_exec_queue_process_msg_cleanup(struct xe_sched_msg *msg)
@@ -1333,7 +1342,7 @@ static void __guc_exec_queue_process_msg_cleanup(struct xe_sched_msg *msg)
 	if (exec_queue_registered(q))
 		disable_scheduling_deregister(guc, q);
 	else
-		__guc_exec_queue_fini(guc, q);
+		__guc_exec_queue_destroy(guc, q);
 }
 
 static bool guc_exec_queue_allowed_to_change_state(struct xe_exec_queue *q)
@@ -1566,14 +1575,14 @@ static bool guc_exec_queue_try_add_msg(struct xe_exec_queue *q,
 #define STATIC_MSG_CLEANUP	0
 #define STATIC_MSG_SUSPEND	1
 #define STATIC_MSG_RESUME	2
-static void guc_exec_queue_fini(struct xe_exec_queue *q)
+static void guc_exec_queue_destroy(struct xe_exec_queue *q)
 {
 	struct xe_sched_msg *msg = q->guc->static_msgs + STATIC_MSG_CLEANUP;
 
 	if (!(q->flags & EXEC_QUEUE_FLAG_PERMANENT) && !exec_queue_wedged(q))
 		guc_exec_queue_add_msg(q, msg, CLEANUP);
 	else
-		__guc_exec_queue_fini(exec_queue_to_guc(q), q);
+		__guc_exec_queue_destroy(exec_queue_to_guc(q), q);
 }
 
 static int guc_exec_queue_set_priority(struct xe_exec_queue *q,
@@ -1703,6 +1712,7 @@ static const struct xe_exec_queue_ops guc_exec_queue_ops = {
 	.init = guc_exec_queue_init,
 	.kill = guc_exec_queue_kill,
 	.fini = guc_exec_queue_fini,
+	.destroy = guc_exec_queue_destroy,
 	.set_priority = guc_exec_queue_set_priority,
 	.set_timeslice = guc_exec_queue_set_timeslice,
 	.set_preempt_timeout = guc_exec_queue_set_preempt_timeout,
@@ -1724,7 +1734,7 @@ static void guc_exec_queue_stop(struct xe_guc *guc, struct xe_exec_queue *q)
 		if (exec_queue_extra_ref(q) || xe_exec_queue_is_lr(q))
 			xe_exec_queue_put(q);
 		else if (exec_queue_destroyed(q))
-			__guc_exec_queue_fini(guc, q);
+			__guc_exec_queue_destroy(guc, q);
 	}
 	if (q->guc->suspend_pending) {
 		set_exec_queue_suspended(q);
@@ -1981,7 +1991,7 @@ static void handle_deregister_done(struct xe_guc *guc, struct xe_exec_queue *q)
 	if (exec_queue_extra_ref(q) || xe_exec_queue_is_lr(q))
 		xe_exec_queue_put(q);
 	else
-		__guc_exec_queue_fini(guc, q);
+		__guc_exec_queue_destroy(guc, q);
 }
 
 int xe_guc_deregister_done_handler(struct xe_guc *guc, u32 *msg, u32 len)
-- 
2.51.0



