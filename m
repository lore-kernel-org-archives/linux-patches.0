Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E54190663;
	Tue,  8 Oct 2024 12:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390989; cv=none; b=CFeShZUfByIrJl7LA0oMMWg9F9JDeQoJJbMyZJOsxuVjB8cLvhR6ks8PwbcSMGAKAnAJBy2Efuc8XCJgW7ZYlYJY06CiWwWhbS0Ew95Ncy5bscFfEjt9L0OsClANoJudMWVaA6HBwZ2kx8VJOddoSWnl1DzgCLXo0qFrvyKq50o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390989; c=relaxed/simple;
	bh=VaFJKPl9spYSFXVs14CSlD77LJaBNQSLRaIrf+OBFFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbIMt9zyR6mKclNnNTGktKLmxtCbLkJOOlI4YRSDnyGFYheaO/KyZpjBbqhaxZNFBFg6FJe27zJ59W6tIqkvBmgMcAWLdqLBB0lDqlWHc9FNAliHTM3tpWnYg3QqcyCg110f19NaNDne4LR13ma6JscO594k/8gBpXGZkKvXMMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCdur05F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCdur05F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0683EC4CEC7;
	Tue,  8 Oct 2024 12:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390989;
	bh=VaFJKPl9spYSFXVs14CSlD77LJaBNQSLRaIrf+OBFFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCdur05FhCJ5B8OIXsNrjGxreWPhfwo2CWH2L54huUT5m4U30NGvAQum26D5hWa3f
	 k6CEde9thYhHkCbWn8vSEZHsHl2VLdWhR/4sLvJiGCxu2UxbqA2NeTipXXwAhwcMWC
	 mLG8JxqaO/Uw94UOPX/NLGU7foMd83cgdHSwaZKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 456/482] drm/xe: fix UAF around queue destruction
Date: Tue,  8 Oct 2024 14:08:39 +0200
Message-ID: <20241008115706.460797135@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 2d2be279f1ca9e7288282d4214f16eea8a727cdb ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c       |  6 +++++-
 drivers/gpu/drm/xe/xe_device_types.h |  3 +++
 drivers/gpu/drm/xe/xe_guc_submit.c   | 26 +++++++++++++++++++++++++-
 drivers/gpu/drm/xe/xe_guc_types.h    |  2 ++
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index a1cbdafbff75e..599bf7f9e8c5c 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -231,6 +231,9 @@ static void xe_device_destroy(struct drm_device *dev, void *dummy)
 	if (xe->unordered_wq)
 		destroy_workqueue(xe->unordered_wq);
 
+	if (xe->destroy_wq)
+		destroy_workqueue(xe->destroy_wq);
+
 	ttm_device_fini(&xe->ttm);
 }
 
@@ -293,8 +296,9 @@ struct xe_device *xe_device_create(struct pci_dev *pdev,
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
diff --git a/drivers/gpu/drm/xe/xe_device_types.h b/drivers/gpu/drm/xe/xe_device_types.h
index 2e62450d86e18..f671300e0c9bd 100644
--- a/drivers/gpu/drm/xe/xe_device_types.h
+++ b/drivers/gpu/drm/xe/xe_device_types.h
@@ -376,6 +376,9 @@ struct xe_device {
 	/** @unordered_wq: used to serialize unordered work, mostly display */
 	struct workqueue_struct *unordered_wq;
 
+	/** @destroy_wq: used to serialize user destroy work, like queue */
+	struct workqueue_struct *destroy_wq;
+
 	/** @tiles: device tiles */
 	struct xe_tile tiles[XE_MAX_TILES_PER_DEVICE];
 
diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index a40287a7c3de8..a0f8299488030 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -233,10 +233,26 @@ static struct workqueue_struct *get_submit_wq(struct xe_guc *guc)
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
@@ -278,6 +294,8 @@ int xe_guc_submit_init(struct xe_guc *guc)
 
 	xa_init(&guc->submission_state.exec_queue_lookup);
 
+	init_waitqueue_head(&guc->submission_state.fini_wq);
+
 	primelockdep(guc);
 
 	return drmm_add_action_or_reset(&xe->drm, guc_submit_fini, guc);
@@ -294,6 +312,9 @@ static void __release_guc_id(struct xe_guc *guc, struct xe_exec_queue *q, u32 xa
 
 	xe_guc_id_mgr_release_locked(&guc->submission_state.idm,
 				     q->guc->id, q->width);
+
+	if (xa_empty(&guc->submission_state.exec_queue_lookup))
+		wake_up(&guc->submission_state.fini_wq);
 }
 
 static int alloc_guc_id(struct xe_guc *guc, struct xe_exec_queue *q)
@@ -1025,13 +1046,16 @@ static void __guc_exec_queue_fini_async(struct work_struct *w)
 
 static void guc_exec_queue_fini_async(struct xe_exec_queue *q)
 {
+	struct xe_guc *guc = exec_queue_to_guc(q);
+	struct xe_device *xe = guc_to_xe(guc);
+
 	INIT_WORK(&q->guc->fini_async, __guc_exec_queue_fini_async);
 
 	/* We must block on kernel engines so slabs are empty on driver unload */
 	if (q->flags & EXEC_QUEUE_FLAG_PERMANENT)
 		__guc_exec_queue_fini_async(&q->guc->fini_async);
 	else
-		queue_work(system_wq, &q->guc->fini_async);
+		queue_work(xe->destroy_wq, &q->guc->fini_async);
 }
 
 static void __guc_exec_queue_fini(struct xe_guc *guc, struct xe_exec_queue *q)
diff --git a/drivers/gpu/drm/xe/xe_guc_types.h b/drivers/gpu/drm/xe/xe_guc_types.h
index 546ac6350a31f..69046f6982717 100644
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
-- 
2.43.0



