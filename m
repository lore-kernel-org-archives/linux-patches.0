Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DC5198A39;
	Thu,  6 Jun 2024 14:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683068; cv=none; b=mEHWOVEc4dhqACSe8qg27zVMuaZdgEVMFrxYX0/dQbdf/CFAJoNILviksQ263AqrB4yTXlHw5pAaLalYI8rm50VOp3zzM8zsv9ARH2zKNGvbnfyFcVryzzyv1R5Y/UZxO/ZWF8LVOsAX8+G8+pbZNEOfNnsrcUdSLWn/jOSo5Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683068; c=relaxed/simple;
	bh=z+OqOnG4Y5wIKcPx66OdzDs66SjaacF0x4eewWFnjug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2An2fr25kxsDcVCHBwmSvGwJyD5w9Tk3uzt6bfT298mg9lXChFQxPvFnL5JETf8uDBdG+hDM/TwGnKWydQkUZwhv37t4lBi+8p/pyjE7QH9aOeelaSOEpSv4JV2+WtQTn4tCTE3WqIwzzgIt8v0p0quYw+gc3YuQz7nmfrB/YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5JW5ZZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5JW5ZZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5F1C2BD10;
	Thu,  6 Jun 2024 14:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683068;
	bh=z+OqOnG4Y5wIKcPx66OdzDs66SjaacF0x4eewWFnjug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5JW5ZZlEFiuXdT4YR9A6mNvzsmxECwooM0WmivZ+UZJBAJy66Q3mqeqrFGbV/7zS
	 wW6KRqxohZg/XEDIC30uQmnLQc50CkY8t6vhQBaA+xswdnHTke7JA5jYJcjbK2/K/s
	 qac7HjpyX/GVfwNOVFWyCgZwCm2mLf0XRplL2q5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riana Tauro <riana.tauro@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 327/374] drm/xe: check pcode init status only on root gt of root tile
Date: Thu,  6 Jun 2024 16:05:06 +0200
Message-ID: <20240606131702.812396532@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Riana Tauro <riana.tauro@intel.com>

[ Upstream commit 933fd5ffaf87a60a019992d48e3a96b5c3403d9f ]

The root tile indicates the pcode initialization is complete
when all tiles have completed their initialization.
So the mailbox can be polled only on the root tile.
Check pcode init status only on root tile and move it to
device probe early as root tile is initialized there.
Also make similar changes in resume paths.

v2: add lock/unlocked version of pcode_mailbox_rw
    to allow pcode init to be called in device
    early probe (Rodrigo)

v3: add code description about using root tile
    change function names to xe_pcode_probe_early
    and xe_pcode_init (Rodrigo)

Signed-off-by: Riana Tauro <riana.tauro@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240410085005.1126343-2-riana.tauro@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: 77b79df0268b ("drm/xe: Change pcode timeout to 50msec while polling again")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c |  21 ++++--
 drivers/gpu/drm/xe/xe_pcode.c  | 115 ++++++++++++++++++++-------------
 drivers/gpu/drm/xe/xe_pcode.h  |   6 +-
 drivers/gpu/drm/xe/xe_pm.c     |  16 ++---
 4 files changed, 94 insertions(+), 64 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index d32ff3857e658..b3b37ed832ca0 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -389,8 +389,14 @@ static int xe_set_dma_info(struct xe_device *xe)
 	return err;
 }
 
-/*
- * Initialize MMIO resources that don't require any knowledge about tile count.
+/**
+ * xe_device_probe_early: Device early probe
+ * @xe: xe device instance
+ *
+ * Initialize MMIO resources that don't require any
+ * knowledge about tile count. Also initialize pcode
+ *
+ * Return: 0 on success, error code on failure
  */
 int xe_device_probe_early(struct xe_device *xe)
 {
@@ -404,6 +410,10 @@ int xe_device_probe_early(struct xe_device *xe)
 	if (err)
 		return err;
 
+	err = xe_pcode_probe_early(xe);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -482,11 +492,8 @@ int xe_device_probe(struct xe_device *xe)
 	if (err)
 		return err;
 
-	for_each_gt(gt, xe, id) {
-		err = xe_pcode_probe(gt);
-		if (err)
-			return err;
-	}
+	for_each_gt(gt, xe, id)
+		xe_pcode_init(gt);
 
 	err = xe_display_init_noirq(xe);
 	if (err)
diff --git a/drivers/gpu/drm/xe/xe_pcode.c b/drivers/gpu/drm/xe/xe_pcode.c
index b324dc2a5debe..c674c87c7f40b 100644
--- a/drivers/gpu/drm/xe/xe_pcode.c
+++ b/drivers/gpu/drm/xe/xe_pcode.c
@@ -10,6 +10,7 @@
 
 #include <drm/drm_managed.h>
 
+#include "xe_device.h"
 #include "xe_gt.h"
 #include "xe_mmio.h"
 #include "xe_pcode_api.h"
@@ -43,8 +44,6 @@ static int pcode_mailbox_status(struct xe_gt *gt)
 		[PCODE_ERROR_MASK] = {-EPROTO, "Unknown"},
 	};
 
-	lockdep_assert_held(&gt->pcode.lock);
-
 	err = xe_mmio_read32(gt, PCODE_MAILBOX) & PCODE_ERROR_MASK;
 	if (err) {
 		drm_err(&gt_to_xe(gt)->drm, "PCODE Mailbox failed: %d %s", err,
@@ -55,17 +54,15 @@ static int pcode_mailbox_status(struct xe_gt *gt)
 	return 0;
 }
 
-static int pcode_mailbox_rw(struct xe_gt *gt, u32 mbox, u32 *data0, u32 *data1,
-			    unsigned int timeout_ms, bool return_data,
-			    bool atomic)
+static int __pcode_mailbox_rw(struct xe_gt *gt, u32 mbox, u32 *data0, u32 *data1,
+			      unsigned int timeout_ms, bool return_data,
+			      bool atomic)
 {
 	int err;
 
 	if (gt_to_xe(gt)->info.skip_pcode)
 		return 0;
 
-	lockdep_assert_held(&gt->pcode.lock);
-
 	if ((xe_mmio_read32(gt, PCODE_MAILBOX) & PCODE_READY) != 0)
 		return -EAGAIN;
 
@@ -87,6 +84,18 @@ static int pcode_mailbox_rw(struct xe_gt *gt, u32 mbox, u32 *data0, u32 *data1,
 	return pcode_mailbox_status(gt);
 }
 
+static int pcode_mailbox_rw(struct xe_gt *gt, u32 mbox, u32 *data0, u32 *data1,
+			    unsigned int timeout_ms, bool return_data,
+			    bool atomic)
+{
+	if (gt_to_xe(gt)->info.skip_pcode)
+		return 0;
+
+	lockdep_assert_held(&gt->pcode.lock);
+
+	return __pcode_mailbox_rw(gt, mbox, data0, data1, timeout_ms, return_data, atomic);
+}
+
 int xe_pcode_write_timeout(struct xe_gt *gt, u32 mbox, u32 data, int timeout)
 {
 	int err;
@@ -109,15 +118,19 @@ int xe_pcode_read(struct xe_gt *gt, u32 mbox, u32 *val, u32 *val1)
 	return err;
 }
 
-static int xe_pcode_try_request(struct xe_gt *gt, u32 mbox,
-				u32 request, u32 reply_mask, u32 reply,
-				u32 *status, bool atomic, int timeout_us)
+static int pcode_try_request(struct xe_gt *gt, u32 mbox,
+			     u32 request, u32 reply_mask, u32 reply,
+			     u32 *status, bool atomic, int timeout_us, bool locked)
 {
 	int slept, wait = 10;
 
 	for (slept = 0; slept < timeout_us; slept += wait) {
-		*status = pcode_mailbox_rw(gt, mbox, &request, NULL, 1, true,
-					   atomic);
+		if (locked)
+			*status = pcode_mailbox_rw(gt, mbox, &request, NULL, 1, true,
+						   atomic);
+		else
+			*status = __pcode_mailbox_rw(gt, mbox, &request, NULL, 1, true,
+						     atomic);
 		if ((*status == 0) && ((request & reply_mask) == reply))
 			return 0;
 
@@ -158,8 +171,8 @@ int xe_pcode_request(struct xe_gt *gt, u32 mbox, u32 request,
 
 	mutex_lock(&gt->pcode.lock);
 
-	ret = xe_pcode_try_request(gt, mbox, request, reply_mask, reply, &status,
-				   false, timeout_base_ms * 1000);
+	ret = pcode_try_request(gt, mbox, request, reply_mask, reply, &status,
+				false, timeout_base_ms * 1000, true);
 	if (!ret)
 		goto out;
 
@@ -177,8 +190,8 @@ int xe_pcode_request(struct xe_gt *gt, u32 mbox, u32 request,
 		"PCODE timeout, retrying with preemption disabled\n");
 	drm_WARN_ON_ONCE(&gt_to_xe(gt)->drm, timeout_base_ms > 1);
 	preempt_disable();
-	ret = xe_pcode_try_request(gt, mbox, request, reply_mask, reply, &status,
-				   true, timeout_base_ms * 1000);
+	ret = pcode_try_request(gt, mbox, request, reply_mask, reply, &status,
+				true, timeout_base_ms * 1000, true);
 	preempt_enable();
 
 out:
@@ -238,59 +251,71 @@ int xe_pcode_init_min_freq_table(struct xe_gt *gt, u32 min_gt_freq,
 }
 
 /**
- * xe_pcode_init - Ensure PCODE is initialized
- * @gt: gt instance
+ * xe_pcode_ready - Ensure PCODE is initialized
+ * @xe: xe instance
+ * @locked: true if lock held, false otherwise
  *
- * This function ensures that PCODE is properly initialized. To be called during
- * probe and resume paths.
+ * PCODE init mailbox is polled only on root gt of root tile
+ * as the root tile provides the initialization is complete only
+ * after all the tiles have completed the initialization.
+ * Called only on early probe without locks and with locks in
+ * resume path.
  *
- * It returns 0 on success, and -error number on failure.
+ * Returns 0 on success, and -error number on failure.
  */
-int xe_pcode_init(struct xe_gt *gt)
+int xe_pcode_ready(struct xe_device *xe, bool locked)
 {
 	u32 status, request = DGFX_GET_INIT_STATUS;
+	struct xe_gt *gt = xe_root_mmio_gt(xe);
 	int timeout_us = 180000000; /* 3 min */
 	int ret;
 
-	if (gt_to_xe(gt)->info.skip_pcode)
+	if (xe->info.skip_pcode)
 		return 0;
 
-	if (!IS_DGFX(gt_to_xe(gt)))
+	if (!IS_DGFX(xe))
 		return 0;
 
-	mutex_lock(&gt->pcode.lock);
-	ret = xe_pcode_try_request(gt, DGFX_PCODE_STATUS, request,
-				   DGFX_INIT_STATUS_COMPLETE,
-				   DGFX_INIT_STATUS_COMPLETE,
-				   &status, false, timeout_us);
-	mutex_unlock(&gt->pcode.lock);
+	if (locked)
+		mutex_lock(&gt->pcode.lock);
+
+	ret = pcode_try_request(gt, DGFX_PCODE_STATUS, request,
+				DGFX_INIT_STATUS_COMPLETE,
+				DGFX_INIT_STATUS_COMPLETE,
+				&status, false, timeout_us, locked);
+
+	if (locked)
+		mutex_unlock(&gt->pcode.lock);
 
 	if (ret)
-		drm_err(&gt_to_xe(gt)->drm,
+		drm_err(&xe->drm,
 			"PCODE initialization timedout after: 3 min\n");
 
 	return ret;
 }
 
 /**
- * xe_pcode_probe - Prepare xe_pcode and also ensure PCODE is initialized.
+ * xe_pcode_init: initialize components of PCODE
  * @gt: gt instance
  *
- * This function initializes the xe_pcode component, and when needed, it ensures
- * that PCODE has properly performed its initialization and it is really ready
- * to go. To be called once only during probe.
- *
- * It returns 0 on success, and -error number on failure.
+ * This function initializes the xe_pcode component.
+ * To be called once only during probe.
  */
-int xe_pcode_probe(struct xe_gt *gt)
+void xe_pcode_init(struct xe_gt *gt)
 {
 	drmm_mutex_init(&gt_to_xe(gt)->drm, &gt->pcode.lock);
+}
 
-	if (gt_to_xe(gt)->info.skip_pcode)
-		return 0;
-
-	if (!IS_DGFX(gt_to_xe(gt)))
-		return 0;
-
-	return xe_pcode_init(gt);
+/**
+ * xe_pcode_probe_early: initializes PCODE
+ * @xe: xe instance
+ *
+ * This function checks the initialization status of PCODE
+ * To be called once only during early probe without locks.
+ *
+ * Returns 0 on success, error code otherwise
+ */
+int xe_pcode_probe_early(struct xe_device *xe)
+{
+	return xe_pcode_ready(xe, false);
 }
diff --git a/drivers/gpu/drm/xe/xe_pcode.h b/drivers/gpu/drm/xe/xe_pcode.h
index 08cb1d047cba2..3f54c6d2a57d2 100644
--- a/drivers/gpu/drm/xe/xe_pcode.h
+++ b/drivers/gpu/drm/xe/xe_pcode.h
@@ -8,9 +8,11 @@
 
 #include <linux/types.h>
 struct xe_gt;
+struct xe_device;
 
-int xe_pcode_probe(struct xe_gt *gt);
-int xe_pcode_init(struct xe_gt *gt);
+void xe_pcode_init(struct xe_gt *gt);
+int xe_pcode_probe_early(struct xe_device *xe);
+int xe_pcode_ready(struct xe_device *xe, bool locked);
 int xe_pcode_init_min_freq_table(struct xe_gt *gt, u32 min_gt_freq,
 				 u32 max_gt_freq);
 int xe_pcode_read(struct xe_gt *gt, u32 mbox, u32 *val, u32 *val1);
diff --git a/drivers/gpu/drm/xe/xe_pm.c b/drivers/gpu/drm/xe/xe_pm.c
index 669b626c06c22..944cf4d76099e 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -103,11 +103,9 @@ int xe_pm_resume(struct xe_device *xe)
 	for_each_tile(tile, xe, id)
 		xe_wa_apply_tile_workarounds(tile);
 
-	for_each_gt(gt, xe, id) {
-		err = xe_pcode_init(gt);
-		if (err)
-			goto err;
-	}
+	err = xe_pcode_ready(xe, true);
+	if (err)
+		return err;
 
 	xe_display_pm_resume_early(xe);
 
@@ -322,11 +320,9 @@ int xe_pm_runtime_resume(struct xe_device *xe)
 	xe->d3cold.power_lost = xe_guc_in_reset(&gt->uc.guc);
 
 	if (xe->d3cold.allowed && xe->d3cold.power_lost) {
-		for_each_gt(gt, xe, id) {
-			err = xe_pcode_init(gt);
-			if (err)
-				goto out;
-		}
+		err = xe_pcode_ready(xe, true);
+		if (err)
+			goto out;
 
 		/*
 		 * This only restores pinned memory which is the memory
-- 
2.43.0



