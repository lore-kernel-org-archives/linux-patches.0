Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8D217F4FF;
	Tue,  8 Oct 2024 13:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392466; cv=none; b=h7B+ssdkSp+D7lBZp7NWvl6WEp/gnbHZUOnv4p9/rSHYppNOt6Dvr4wAeOWgiqK5Wpd5boj0/Y3EOMyv8ykqcIa0rQKoshJVG15yTktmEie2dR1HwyuJZzgRbT4bEqQexlMXTRhHVBsvfboXZsYn3zLPG8D8nhA4t+yEvA12ADc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392466; c=relaxed/simple;
	bh=NeqRBHiVGLM6mklId9sC7RMOLNmnmHygG4Ymo44DNQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJhCYMZ/V01KDt8O2mBb45pcXt2HeqIaQ5ew06axrBfWYsOQHXZcvIlH0LNS6BMPzKFD3k2NJSzGW99z+7xxCU33TBdVFFT0qb+sLxwKuUqSW3sdAIRUNYA6NYjNbBZSEcsTzhuVPTj+RZdG1UDzC4FDgazqwRnAEKASwz1rL1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlgxMPYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlgxMPYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24339C4CECD;
	Tue,  8 Oct 2024 13:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392466;
	bh=NeqRBHiVGLM6mklId9sC7RMOLNmnmHygG4Ymo44DNQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlgxMPYV4uZ/0EUlKtIF8N8Rtpfn7+AU4Hq40yYQfLXNO/i2tUxUkHMxe/t6aOPtw
	 5Vb/OJ3AEF2PQBxOJJr9THY83+4H64ukXlFEoK+NnTLAIOoC5ZFYhlKuxordSu0CPq
	 xfIPnbxlMxZs7AVZTeJDGTg2pS1yaShGw4zU0QMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 424/558] drm/xe: fix UAF around queue destruction
Date: Tue,  8 Oct 2024 14:07:34 +0200
Message-ID: <20241008115718.958980290@linuxfoundation.org>
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

From: Matthew Auld <matthew.auld@intel.com>

commit 2d2be279f1ca9e7288282d4214f16eea8a727cdb upstream.

We currently do stuff like queuing the final destruction step on a
random system wq, which will outlive the driver instance. With bad
timing we can teardown the driver with one or more work workqueue still
being alive leading to various UAF splats. Add a fini step to ensure
user queues are properly torn down. At this point GuC should already be
nuked so queue itself should no longer be referenced from hw pov.

v2 (Matt B)
 - Looks much safer to use a waitqueue and then just wait for the
   xa_array to become empty before triggering the drain.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/2317
Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240923145647.77707-2-matthew.auld@intel.com
(cherry picked from commit 861108666cc0e999cffeab6aff17b662e68774e3)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_device.c       |    6 +++++-
 drivers/gpu/drm/xe/xe_device_types.h |    3 +++
 drivers/gpu/drm/xe/xe_guc_submit.c   |   26 +++++++++++++++++++++++++-
 drivers/gpu/drm/xe/xe_guc_types.h    |    2 ++
 4 files changed, 35 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -285,6 +285,9 @@ static void xe_device_destroy(struct drm
 	if (xe->unordered_wq)
 		destroy_workqueue(xe->unordered_wq);
 
+	if (xe->destroy_wq)
+		destroy_workqueue(xe->destroy_wq);
+
 	ttm_device_fini(&xe->ttm);
 }
 
@@ -350,8 +353,9 @@ struct xe_device *xe_device_create(struc
 	xe->preempt_fence_wq = alloc_ordered_workqueue("xe-preempt-fence-wq", 0);
 	xe->ordered_wq = alloc_ordered_workqueue("xe-ordered-wq", 0);
 	xe->unordered_wq = alloc_workqueue("xe-unordered-wq", 0, 0);
+	xe->destroy_wq = alloc_workqueue("xe-destroy-wq", 0, 0);
 	if (!xe->ordered_wq || !xe->unordered_wq ||
-	    !xe->preempt_fence_wq) {
+	    !xe->preempt_fence_wq || !xe->destroy_wq) {
 		/*
 		 * Cleanup done in xe_device_destroy via
 		 * drmm_add_action_or_reset register above
--- a/drivers/gpu/drm/xe/xe_device_types.h
+++ b/drivers/gpu/drm/xe/xe_device_types.h
@@ -392,6 +392,9 @@ struct xe_device {
 	/** @unordered_wq: used to serialize unordered work, mostly display */
 	struct workqueue_struct *unordered_wq;
 
+	/** @destroy_wq: used to serialize user destroy work, like queue */
+	struct workqueue_struct *destroy_wq;
+
 	/** @tiles: device tiles */
 	struct xe_tile tiles[XE_MAX_TILES_PER_DEVICE];
 
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -276,10 +276,26 @@ static struct workqueue_struct *get_subm
 }
 #endif
 
+static void xe_guc_submit_fini(struct xe_guc *guc)
+{
+	struct xe_device *xe = guc_to_xe(guc);
+	struct xe_gt *gt = guc_to_gt(guc);
+	int ret;
+
+	ret = wait_event_timeout(guc->submission_state.fini_wq,
+				 xa_empty(&guc->submission_state.exec_queue_lookup),
+				 HZ * 5);
+
+	drain_workqueue(xe->destroy_wq);
+
+	xe_gt_assert(gt, ret);
+}
+
 static void guc_submit_fini(struct drm_device *drm, void *arg)
 {
 	struct xe_guc *guc = arg;
 
+	xe_guc_submit_fini(guc);
 	xa_destroy(&guc->submission_state.exec_queue_lookup);
 	free_submit_wq(guc);
 }
@@ -351,6 +367,8 @@ int xe_guc_submit_init(struct xe_guc *gu
 
 	xa_init(&guc->submission_state.exec_queue_lookup);
 
+	init_waitqueue_head(&guc->submission_state.fini_wq);
+
 	primelockdep(guc);
 
 	return drmm_add_action_or_reset(&xe->drm, guc_submit_fini, guc);
@@ -367,6 +385,9 @@ static void __release_guc_id(struct xe_g
 
 	xe_guc_id_mgr_release_locked(&guc->submission_state.idm,
 				     q->guc->id, q->width);
+
+	if (xa_empty(&guc->submission_state.exec_queue_lookup))
+		wake_up(&guc->submission_state.fini_wq);
 }
 
 static int alloc_guc_id(struct xe_guc *guc, struct xe_exec_queue *q)
@@ -1267,13 +1288,16 @@ static void __guc_exec_queue_fini_async(
 
 static void guc_exec_queue_fini_async(struct xe_exec_queue *q)
 {
+	struct xe_guc *guc = exec_queue_to_guc(q);
+	struct xe_device *xe = guc_to_xe(guc);
+
 	INIT_WORK(&q->guc->fini_async, __guc_exec_queue_fini_async);
 
 	/* We must block on kernel engines so slabs are empty on driver unload */
 	if (q->flags & EXEC_QUEUE_FLAG_PERMANENT || exec_queue_wedged(q))
 		__guc_exec_queue_fini_async(&q->guc->fini_async);
 	else
-		queue_work(system_wq, &q->guc->fini_async);
+		queue_work(xe->destroy_wq, &q->guc->fini_async);
 }
 
 static void __guc_exec_queue_fini(struct xe_guc *guc, struct xe_exec_queue *q)
--- a/drivers/gpu/drm/xe/xe_guc_types.h
+++ b/drivers/gpu/drm/xe/xe_guc_types.h
@@ -81,6 +81,8 @@ struct xe_guc {
 #endif
 		/** @submission_state.enabled: submission is enabled */
 		bool enabled;
+		/** @submission_state.fini_wq: submit fini wait queue */
+		wait_queue_head_t fini_wq;
 	} submission_state;
 	/** @hwconfig: Hardware config state */
 	struct {


