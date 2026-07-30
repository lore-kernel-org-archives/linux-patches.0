Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE1E1AF0BB;
	Thu, 30 Jul 2026 14:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421499; cv=none; b=h4jKbN3q0vE7+NkG9o53dUoTSfNl+xOaI+QRg594xT38EQDxYRxzojXsMjQAKZ57gAyQxfgIit91y1W6eZ7z9FsqIhbIfXEXNv7c0ZVzCNCvg20LwX+Y5QHrdrPI+7Yw8nK6LJDfDJyQs2+pDU1G/YGdHUYCVOaSZ2tYxLUPc3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421499; c=relaxed/simple;
	bh=BQk1Z6VffeLcrw+dUkES5EfOxC2+K38vT9/xrlvQEZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ammv08TPtasoURiGcKegWMFhw1vqqW+kzE431tzuUTxJaILtLFwzj2t9qjmXk1bNaOvBHlKWL0zWSbOFeReqcAbXGvizGWWOEebHDteZPJ5KRJ63R264teD7Z2pT0+cQ0JvvyeFKfTyR1xvntip7hpLB/bVSgDglA6+dDldtEd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0rKVi6c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0rKVi6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65B31F000E9;
	Thu, 30 Jul 2026 14:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421498;
	bh=fUXjhy9bQACs2MJ+jPQHh56lXgDIapoNZU3rkjKgs5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I0rKVi6c6lmWMiddaQ/B15wnYvKmU4cB6G/QkUyRjl8sntqD7dQXAumKf89rPTQiT
	 ZTs6uPsqSyxl3vr1ceaFI/0eR3ijbV1MoJ0uUJEwG7g69a/VbPJRLmmabDH1R20mjx
	 ItvJii5Ke4qpfJOsBGN9S27qwyY1P4bBoTVQ+4X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Thomas Hellstrom <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 122/744] drm/xe: Assign queue name in time for drm_sched_init
Date: Thu, 30 Jul 2026 16:06:35 +0200
Message-ID: <20260730141446.877058180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit 24f60b8e9f44b10614b43dbc4ba4b029f8ede3b6 ]

Currently the queue name is only assigned after the drm scheduler instance
has been created. This loses information with all logging or debug
workqueue facilities so lets re-order things a bit so the name gets
assigned in time.

To be able to assign a GuC ID early we split the allocation into
reservation and publish phases.

First, with the submission state lock held, we reserve the ID in the GuC
ID manager, which serves as an authoritative source of truth. Then we can
drop the lock and reserve entries in the exec queue lookup XArray. This
can be lockless since the NULL entries are invisible both to the kernel
and userspace. Only after the queue has been fully created we replace the
reserved entries with the queue pointer, which can be done locklessly for
single width queues.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20260523103418.61832-1-tvrtko.ursulin@igalia.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: 299bc6d50b1b ("drm/xe/guc: Keep scheduler timeline name alive")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 72 +++++++++++++++++-------------
 1 file changed, 40 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index 42110e01b7d096..1752039d333f39 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -397,46 +397,43 @@ void xe_guc_submit_disable(struct xe_guc *guc)
 	guc->submission_state.enabled = false;
 }
 
-static void __release_guc_id(struct xe_guc *guc, struct xe_exec_queue *q, u32 xa_count)
+static void __release_guc_id(struct xe_guc *guc, struct xe_exec_queue *q,
+			     int count)
 {
 	int i;
 
-	lockdep_assert_held(&guc->submission_state.lock);
+	mutex_lock(&guc->submission_state.lock);
 
-	for (i = 0; i < xa_count; ++i)
-		xa_erase(&guc->submission_state.exec_queue_lookup, q->guc->id + i);
+	for (i = 0; i < count; ++i)
+		xa_erase(&guc->submission_state.exec_queue_lookup,
+			 q->guc->id + i);
 
 	xe_guc_id_mgr_release_locked(&guc->submission_state.idm,
 				     q->guc->id, q->width);
 
 	if (xa_empty(&guc->submission_state.exec_queue_lookup))
 		wake_up(&guc->submission_state.fini_wq);
+
+	mutex_unlock(&guc->submission_state.lock);
 }
 
 static int alloc_guc_id(struct xe_guc *guc, struct xe_exec_queue *q)
 {
-	int ret;
-	int i;
-
-	/*
-	 * Must use GFP_NOWAIT as this lock is in the dma fence signalling path,
-	 * worse case user gets -ENOMEM on engine create and has to try again.
-	 *
-	 * FIXME: Have caller pre-alloc or post-alloc /w GFP_KERNEL to prevent
-	 * failure.
-	 */
-	lockdep_assert_held(&guc->submission_state.lock);
+	int ret, i;
 
+	mutex_lock(&guc->submission_state.lock);
 	ret = xe_guc_id_mgr_reserve_locked(&guc->submission_state.idm,
 					   q->width);
+	mutex_unlock(&guc->submission_state.lock);
 	if (ret < 0)
 		return ret;
 
 	q->guc->id = ret;
 
+	/* Reserve empty slots. */
 	for (i = 0; i < q->width; ++i) {
-		ret = xa_err(xa_store(&guc->submission_state.exec_queue_lookup,
-				      q->guc->id + i, q, GFP_NOWAIT));
+		ret = xa_insert(&guc->submission_state.exec_queue_lookup,
+				 q->guc->id + i, NULL, GFP_KERNEL);
 		if (ret)
 			goto err_release;
 	}
@@ -449,11 +446,24 @@ static int alloc_guc_id(struct xe_guc *guc, struct xe_exec_queue *q)
 	return ret;
 }
 
+static void publish_guc_id(struct xe_guc *guc, struct xe_exec_queue *q)
+{
+	int i;
+
+	lockdep_assert_held(&guc->submission_state.lock);
+
+	for (i = 0; i < q->width; ++i) {
+		void *old;
+
+		old = xa_store(&guc->submission_state.exec_queue_lookup,
+			       q->guc->id + i, q, GFP_NOWAIT);
+		XE_WARN_ON(old || xa_is_err(old));
+	}
+}
+
 static void release_guc_id(struct xe_guc *guc, struct xe_exec_queue *q)
 {
-	mutex_lock(&guc->submission_state.lock);
 	__release_guc_id(guc, q, q->width);
-	mutex_unlock(&guc->submission_state.lock);
 }
 
 struct exec_queue_policy {
@@ -1957,6 +1967,12 @@ static int guc_exec_queue_init(struct xe_exec_queue *q)
 	timeout = (q->vm && xe_vm_in_lr_mode(q->vm)) ? MAX_SCHEDULE_TIMEOUT :
 		  msecs_to_jiffies(q->sched_props.job_timeout_ms);
 
+	err = alloc_guc_id(guc, q);
+	if (err)
+		goto err_free;
+
+	xe_exec_queue_assign_name(q, q->guc->id);
+
 	/*
 	 * Use primary queue's submit_wq for all secondary queues of a
 	 * multi queue group. This serialization avoids any locking around
@@ -1973,28 +1989,21 @@ static int guc_exec_queue_init(struct xe_exec_queue *q)
 			    timeout, guc_to_gt(guc)->ordered_wq, NULL,
 			    q->name, gt_to_xe(q->gt)->drm.dev);
 	if (err)
-		goto err_free;
+		goto err_release_id;
 
 	sched = &ge->sched;
 	err = xe_sched_entity_init(&ge->entity, sched);
 	if (err)
 		goto err_sched;
 
-	mutex_lock(&guc->submission_state.lock);
-
-	err = alloc_guc_id(guc, q);
-	if (err)
-		goto err_entity;
-
 	q->entity = &ge->entity;
 
+	mutex_lock(&guc->submission_state.lock);
 	if (xe_guc_read_stopped(guc) || vf_recovery(guc))
 		xe_sched_stop(sched);
-
+	publish_guc_id(guc, q);
 	mutex_unlock(&guc->submission_state.lock);
 
-	xe_exec_queue_assign_name(q, q->guc->id);
-
 	/*
 	 * Maintain secondary queues of the multi queue group in a list
 	 * for handling dependencies across the queues in the group.
@@ -2017,11 +2026,10 @@ static int guc_exec_queue_init(struct xe_exec_queue *q)
 
 	return 0;
 
-err_entity:
-	mutex_unlock(&guc->submission_state.lock);
-	xe_sched_entity_fini(&ge->entity);
 err_sched:
 	xe_sched_fini(&ge->sched);
+err_release_id:
+	release_guc_id(guc, q);
 err_free:
 	kfree(ge);
 
-- 
2.53.0



