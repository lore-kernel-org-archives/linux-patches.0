Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD8630BBA5;
	Wed, 28 Jan 2026 15:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615817; cv=none; b=o6vtmd1XBdklfpgQKuPfJee9JT7T+tQReImOzqp9DrnvjcC1QLvgbPUlfONz02NWxk8GqVTU8e1JcbvcRtv/na9oZqwz2SXS1OQm4eBL5Hz7ndVPjhuUoxIqVS08/Mt3ChS/t1TtBDOMu/6IQ1tc/coWK8K8v0ifyt3m1IhFvwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615817; c=relaxed/simple;
	bh=74KOMKX8jyGrZ+B2ISIABuDpb0q9H2tuJk6hB4QSHNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=omiPrBtf/MwUMo3wo70KHf80sdilrFtajHP26u8bkCtO7oKcpSpkthsfhAr6m9SuQbw7aCLZG5patV7hlTSSaWH99J76RbAnQfVwSdUBQNemFe3E+J6MYfARnIgRrezeFhSYsGDturhbog1FypmNFicL5zGcfdaKLs3RdKMXuaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=up53kUZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="up53kUZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D0DC4CEF1;
	Wed, 28 Jan 2026 15:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615817;
	bh=74KOMKX8jyGrZ+B2ISIABuDpb0q9H2tuJk6hB4QSHNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=up53kUZrBPeWiODowAi9d6Fr7uNeex4OAjCTgBLCcATZBvx9PHe5ZuwCE96HqmWDr
	 KydUb0lkxIzJ6OJb9Pf6wmnEY9okA8D8dffYVPqwqyzobtAjUD9DInayGopBzAt8Ne
	 wMsnbukn5RcGSiravLZcuoIjl2Xy5r8c50thnjEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Laguna <lukasz.laguna@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 122/227] drm/xe: Update wedged.mode only after successful reset policy change
Date: Wed, 28 Jan 2026 16:22:47 +0100
Message-ID: <20260128145348.854929283@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Laguna <lukasz.laguna@intel.com>

[ Upstream commit f262015b9797effdec15e8a81c81b2158ede9578 ]

Previously, the driver's internal wedged.mode state was updated without
verifying whether the corresponding engine reset policy update in GuC
succeeded. This could leave the driver reporting a wedged.mode state
that doesn't match the actual reset behavior programmed in GuC.

With this change, the reset policy is updated first, and the driver's
wedged.mode state is modified only if the policy update succeeds on all
available GTs.

This patch also introduces two functional improvements:

 - The policy is sent to GuC only when a change is required. An update
   is needed only when entering or leaving XE_WEDGED_MODE_UPON_ANY_HANG,
   because only in that case the reset policy changes. For example,
   switching between XE_WEDGED_MODE_UPON_CRITICAL_ERROR and
   XE_WEDGED_MODE_NEVER doesn't affect the reset policy, so there is no
   need to send the same value to GuC.

 - An inconsistent_reset flag is added to track cases where reset policy
   update succeeds only on a subset of GTs. If such inconsistency is
   detected, future wedged mode configuration will force a retry of the
   reset policy update to restore a consistent state across all GTs.

Fixes: 6b8ef44cc0a9 ("drm/xe: Introduce the wedged_mode debugfs")
Signed-off-by: Lukasz Laguna <lukasz.laguna@intel.com>
Link: https://patch.msgid.link/20260107174741.29163-3-lukasz.laguna@intel.com
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 0f13dead4e0385859f5c9c3625a19df116b389d3)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_debugfs.c      | 72 ++++++++++++++++++++++------
 drivers/gpu/drm/xe/xe_device_types.h | 18 +++++++
 drivers/gpu/drm/xe/xe_guc_ads.c      | 14 +++---
 drivers/gpu/drm/xe/xe_guc_ads.h      |  5 +-
 4 files changed, 87 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_debugfs.c b/drivers/gpu/drm/xe/xe_debugfs.c
index cd977dbd1ef63..7b48bf90cab8f 100644
--- a/drivers/gpu/drm/xe/xe_debugfs.c
+++ b/drivers/gpu/drm/xe/xe_debugfs.c
@@ -255,14 +255,64 @@ static ssize_t wedged_mode_show(struct file *f, char __user *ubuf,
 	return simple_read_from_buffer(ubuf, size, pos, buf, len);
 }
 
+static int __wedged_mode_set_reset_policy(struct xe_gt *gt, enum xe_wedged_mode mode)
+{
+	bool enable_engine_reset;
+	int ret;
+
+	enable_engine_reset = (mode != XE_WEDGED_MODE_UPON_ANY_HANG_NO_RESET);
+	ret = xe_guc_ads_scheduler_policy_toggle_reset(&gt->uc.guc.ads,
+						       enable_engine_reset);
+	if (ret)
+		xe_gt_err(gt, "Failed to update GuC ADS scheduler policy (%pe)\n", ERR_PTR(ret));
+
+	return ret;
+}
+
+static int wedged_mode_set_reset_policy(struct xe_device *xe, enum xe_wedged_mode mode)
+{
+	struct xe_gt *gt;
+	int ret;
+	u8 id;
+
+	guard(xe_pm_runtime)(xe);
+	for_each_gt(gt, xe, id) {
+		ret = __wedged_mode_set_reset_policy(gt, mode);
+		if (ret) {
+			if (id > 0) {
+				xe->wedged.inconsistent_reset = true;
+				drm_err(&xe->drm, "Inconsistent reset policy state between GTs\n");
+			}
+			return ret;
+		}
+	}
+
+	xe->wedged.inconsistent_reset = false;
+
+	return 0;
+}
+
+static bool wedged_mode_needs_policy_update(struct xe_device *xe, enum xe_wedged_mode mode)
+{
+	if (xe->wedged.inconsistent_reset)
+		return true;
+
+	if (xe->wedged.mode == mode)
+		return false;
+
+	if (xe->wedged.mode == XE_WEDGED_MODE_UPON_ANY_HANG_NO_RESET ||
+	    mode == XE_WEDGED_MODE_UPON_ANY_HANG_NO_RESET)
+		return true;
+
+	return false;
+}
+
 static ssize_t wedged_mode_set(struct file *f, const char __user *ubuf,
 			       size_t size, loff_t *pos)
 {
 	struct xe_device *xe = file_inode(f)->i_private;
-	struct xe_gt *gt;
 	u32 wedged_mode;
 	ssize_t ret;
-	u8 id;
 
 	ret = kstrtouint_from_user(ubuf, size, 0, &wedged_mode);
 	if (ret)
@@ -271,22 +321,14 @@ static ssize_t wedged_mode_set(struct file *f, const char __user *ubuf,
 	if (wedged_mode > 2)
 		return -EINVAL;
 
-	if (xe->wedged.mode == wedged_mode)
-		return size;
+	if (wedged_mode_needs_policy_update(xe, wedged_mode)) {
+		ret = wedged_mode_set_reset_policy(xe, wedged_mode);
+		if (ret)
+			return ret;
+	}
 
 	xe->wedged.mode = wedged_mode;
 
-	xe_pm_runtime_get(xe);
-	for_each_gt(gt, xe, id) {
-		ret = xe_guc_ads_scheduler_policy_toggle_reset(&gt->uc.guc.ads);
-		if (ret) {
-			xe_gt_err(gt, "Failed to update GuC ADS scheduler policy. GuC may still cause engine reset even with wedged_mode=2\n");
-			xe_pm_runtime_put(xe);
-			return -EIO;
-		}
-	}
-	xe_pm_runtime_put(xe);
-
 	return size;
 }
 
diff --git a/drivers/gpu/drm/xe/xe_device_types.h b/drivers/gpu/drm/xe/xe_device_types.h
index 74d7af830b85d..0e80f2940c996 100644
--- a/drivers/gpu/drm/xe/xe_device_types.h
+++ b/drivers/gpu/drm/xe/xe_device_types.h
@@ -42,6 +42,22 @@ struct xe_pat_ops;
 struct xe_pxp;
 struct xe_vram_region;
 
+/**
+ * enum xe_wedged_mode - possible wedged modes
+ * @XE_WEDGED_MODE_NEVER: Device will never be declared wedged.
+ * @XE_WEDGED_MODE_UPON_CRITICAL_ERROR: Device will be declared wedged only
+ *	when critical error occurs like GT reset failure or firmware failure.
+ *	This is the default mode.
+ * @XE_WEDGED_MODE_UPON_ANY_HANG_NO_RESET: Device will be declared wedged on
+ *	any hang. In this mode, engine resets are disabled to avoid automatic
+ *	recovery attempts. This mode is primarily intended for debugging hangs.
+ */
+enum xe_wedged_mode {
+	XE_WEDGED_MODE_NEVER = 0,
+	XE_WEDGED_MODE_UPON_CRITICAL_ERROR = 1,
+	XE_WEDGED_MODE_UPON_ANY_HANG_NO_RESET = 2,
+};
+
 #define XE_BO_INVALID_OFFSET	LONG_MAX
 
 #define GRAPHICS_VER(xe) ((xe)->info.graphics_verx100 / 100)
@@ -556,6 +572,8 @@ struct xe_device {
 		int mode;
 		/** @wedged.method: Recovery method to be sent in the drm device wedged uevent */
 		unsigned long method;
+		/** @wedged.inconsistent_reset: Inconsistent reset policy state between GTs */
+		bool inconsistent_reset;
 	} wedged;
 
 	/** @bo_device: Struct to control async free of BOs */
diff --git a/drivers/gpu/drm/xe/xe_guc_ads.c b/drivers/gpu/drm/xe/xe_guc_ads.c
index 58e0b0294a5bc..0e2bece1d8b83 100644
--- a/drivers/gpu/drm/xe/xe_guc_ads.c
+++ b/drivers/gpu/drm/xe/xe_guc_ads.c
@@ -979,16 +979,17 @@ static int guc_ads_action_update_policies(struct xe_guc_ads *ads, u32 policy_off
 /**
  * xe_guc_ads_scheduler_policy_toggle_reset - Toggle reset policy
  * @ads: Additional data structures object
+ * @enable_engine_reset: true to enable engine resets, false otherwise
  *
- * This function update the GuC's engine reset policy based on wedged.mode.
+ * This function update the GuC's engine reset policy.
  *
  * Return: 0 on success, and negative error code otherwise.
  */
-int xe_guc_ads_scheduler_policy_toggle_reset(struct xe_guc_ads *ads)
+int xe_guc_ads_scheduler_policy_toggle_reset(struct xe_guc_ads *ads,
+					     bool enable_engine_reset)
 {
 	struct guc_policies *policies;
 	struct xe_guc *guc = ads_to_guc(ads);
-	struct xe_device *xe = ads_to_xe(ads);
 	CLASS(xe_guc_buf, buf)(&guc->buf, sizeof(*policies));
 
 	if (!xe_guc_buf_is_valid(buf))
@@ -1000,10 +1001,11 @@ int xe_guc_ads_scheduler_policy_toggle_reset(struct xe_guc_ads *ads)
 	policies->dpc_promote_time = ads_blob_read(ads, policies.dpc_promote_time);
 	policies->max_num_work_items = ads_blob_read(ads, policies.max_num_work_items);
 	policies->is_valid = 1;
-	if (xe->wedged.mode == 2)
-		policies->global_flags |= GLOBAL_POLICY_DISABLE_ENGINE_RESET;
-	else
+
+	if (enable_engine_reset)
 		policies->global_flags &= ~GLOBAL_POLICY_DISABLE_ENGINE_RESET;
+	else
+		policies->global_flags |= GLOBAL_POLICY_DISABLE_ENGINE_RESET;
 
 	return guc_ads_action_update_policies(ads, xe_guc_buf_flush(buf));
 }
diff --git a/drivers/gpu/drm/xe/xe_guc_ads.h b/drivers/gpu/drm/xe/xe_guc_ads.h
index 2e6674c760ff9..7a39f361cb17d 100644
--- a/drivers/gpu/drm/xe/xe_guc_ads.h
+++ b/drivers/gpu/drm/xe/xe_guc_ads.h
@@ -6,6 +6,8 @@
 #ifndef _XE_GUC_ADS_H_
 #define _XE_GUC_ADS_H_
 
+#include <linux/types.h>
+
 struct xe_guc_ads;
 
 int xe_guc_ads_init(struct xe_guc_ads *ads);
@@ -13,6 +15,7 @@ int xe_guc_ads_init_post_hwconfig(struct xe_guc_ads *ads);
 void xe_guc_ads_populate(struct xe_guc_ads *ads);
 void xe_guc_ads_populate_minimal(struct xe_guc_ads *ads);
 void xe_guc_ads_populate_post_load(struct xe_guc_ads *ads);
-int xe_guc_ads_scheduler_policy_toggle_reset(struct xe_guc_ads *ads);
+int xe_guc_ads_scheduler_policy_toggle_reset(struct xe_guc_ads *ads,
+					     bool enable_engine_reset);
 
 #endif
-- 
2.51.0



