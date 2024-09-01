Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBFE537FF;
	Sun,  1 Sep 2024 16:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208314; cv=none; b=E0H90WUGQioVJVjrtm3+qqBRT4ELt7kd6bpTjckAfdEttPKWscFSghuP2fqju5waPvdVk72Ct7AJYoBzw+roVHcu8gaTu7qtlVFrT2npGIGX7Xou4MnFDFPtKo1xB2IBjyUU+NQ6kBX3DGVZWZmPvO007YcvItSDiQlMbQB8y+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208314; c=relaxed/simple;
	bh=MC4Lhd0NDaQPLEY8vIAA4wk+/MVB4GUCsm12SZ/ffs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dg2TTvZnH4HcTHcIYMAvqo0gjsQpX+uprOoX7RxwU59UbTF7ncu4FAth6rKp7gjZOirwKJeL8JGfqzvIHfBznLfh0xOO5e/zqKnppryjuER7EDG5tmdml0kqSYVX3nkrz4QdBGUcc/5C4RwjDnLIRY9z0w1/t1lZa7bE54oYbKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EIYnp4qX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EIYnp4qX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4290AC4CEC3;
	Sun,  1 Sep 2024 16:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208314;
	bh=MC4Lhd0NDaQPLEY8vIAA4wk+/MVB4GUCsm12SZ/ffs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EIYnp4qX84Mf3giB1chvVdq5TjwgWbGdBPf7eNkM3JYu9p4bmFSz7TJyAdRbVXIJI
	 mk1mC2rU8Vg68OhR0Iich68AsLp522b29fqSAA4NgPTAviZcLyKJblcBNfnU33Vb0f
	 BvyYGrXsFVC5WERqVO9qIJViFdd2aO/vG/T7/YH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshuman Gupta <anshuman.gupta@intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 044/149] drm/xe: Prepare display for D3Cold
Date: Sun,  1 Sep 2024 18:15:55 +0200
Message-ID: <20240901160819.122974223@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

[ Upstream commit e7b180b22022f52e3f5fca695cc75d63bddc5a1c ]

Prepare power-well and DC handling for a full power
lost during D3Cold, then sanitize it upon D3->D0.
Otherwise we get a bunch of state mismatch.

Ideally we could leave DC9 enabled and wouldn't need
to move DC9->DC0 on every runtime resume, however,
the disable_DC is part of the power-well checks and
intrinsic to the dc_off power well. In the future that
can be detangled so we can have even bigger power savings.
But for now, let's focus on getting a D3Cold, which saves
much more power by itself.

v2: create new functions to avoid full-suspend-resume path,
which would result in a deadlock between xe_gem_fault and the
modeset-ioctl.

v3: Only avoid the full modeset to avoid the race, for a more
robust suspend-resume.

Cc: Anshuman Gupta <anshuman.gupta@intel.com>
Cc: Uma Shankar <uma.shankar@intel.com>
Tested-by: Francois Dugast <francois.dugast@intel.com>
Reviewed-by: Anshuman Gupta <anshuman.gupta@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240522170105.327472-5-rodrigo.vivi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: ddf6492e0e50 ("drm/xe/display: Make display suspend/resume work on discrete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/xe_display.c | 10 ++++++----
 drivers/gpu/drm/xe/display/xe_display.h |  8 ++++----
 drivers/gpu/drm/xe/xe_pm.c              | 15 ++++++++++++---
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/xe/display/xe_display.c b/drivers/gpu/drm/xe/display/xe_display.c
index 7cdc03dc40ed9..79d33d592093c 100644
--- a/drivers/gpu/drm/xe/display/xe_display.c
+++ b/drivers/gpu/drm/xe/display/xe_display.c
@@ -302,7 +302,7 @@ static bool suspend_to_idle(void)
 	return false;
 }
 
-void xe_display_pm_suspend(struct xe_device *xe)
+void xe_display_pm_suspend(struct xe_device *xe, bool runtime)
 {
 	bool s2idle = suspend_to_idle();
 	if (!xe->info.enable_display)
@@ -316,7 +316,8 @@ void xe_display_pm_suspend(struct xe_device *xe)
 	if (has_display(xe))
 		drm_kms_helper_poll_disable(&xe->drm);
 
-	intel_display_driver_suspend(xe);
+	if (!runtime)
+		intel_display_driver_suspend(xe);
 
 	intel_dp_mst_suspend(xe);
 
@@ -352,7 +353,7 @@ void xe_display_pm_resume_early(struct xe_device *xe)
 	intel_power_domains_resume(xe);
 }
 
-void xe_display_pm_resume(struct xe_device *xe)
+void xe_display_pm_resume(struct xe_device *xe, bool runtime)
 {
 	if (!xe->info.enable_display)
 		return;
@@ -367,7 +368,8 @@ void xe_display_pm_resume(struct xe_device *xe)
 
 	/* MST sideband requires HPD interrupts enabled */
 	intel_dp_mst_resume(xe);
-	intel_display_driver_resume(xe);
+	if (!runtime)
+		intel_display_driver_resume(xe);
 
 	intel_hpd_poll_disable(xe);
 	if (has_display(xe))
diff --git a/drivers/gpu/drm/xe/display/xe_display.h b/drivers/gpu/drm/xe/display/xe_display.h
index 710e56180b52d..93d1f779b9788 100644
--- a/drivers/gpu/drm/xe/display/xe_display.h
+++ b/drivers/gpu/drm/xe/display/xe_display.h
@@ -34,10 +34,10 @@ void xe_display_irq_enable(struct xe_device *xe, u32 gu_misc_iir);
 void xe_display_irq_reset(struct xe_device *xe);
 void xe_display_irq_postinstall(struct xe_device *xe, struct xe_gt *gt);
 
-void xe_display_pm_suspend(struct xe_device *xe);
+void xe_display_pm_suspend(struct xe_device *xe, bool runtime);
 void xe_display_pm_suspend_late(struct xe_device *xe);
 void xe_display_pm_resume_early(struct xe_device *xe);
-void xe_display_pm_resume(struct xe_device *xe);
+void xe_display_pm_resume(struct xe_device *xe, bool runtime);
 
 #else
 
@@ -63,10 +63,10 @@ static inline void xe_display_irq_enable(struct xe_device *xe, u32 gu_misc_iir)
 static inline void xe_display_irq_reset(struct xe_device *xe) {}
 static inline void xe_display_irq_postinstall(struct xe_device *xe, struct xe_gt *gt) {}
 
-static inline void xe_display_pm_suspend(struct xe_device *xe) {}
+static inline void xe_display_pm_suspend(struct xe_device *xe, bool runtime) {}
 static inline void xe_display_pm_suspend_late(struct xe_device *xe) {}
 static inline void xe_display_pm_resume_early(struct xe_device *xe) {}
-static inline void xe_display_pm_resume(struct xe_device *xe) {}
+static inline void xe_display_pm_resume(struct xe_device *xe, bool runtime) {}
 
 #endif /* CONFIG_DRM_XE_DISPLAY */
 #endif /* _XE_DISPLAY_H_ */
diff --git a/drivers/gpu/drm/xe/xe_pm.c b/drivers/gpu/drm/xe/xe_pm.c
index 37fbeda12d3bd..07615acd2c299 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -96,12 +96,12 @@ int xe_pm_suspend(struct xe_device *xe)
 	if (err)
 		goto err;
 
-	xe_display_pm_suspend(xe);
+	xe_display_pm_suspend(xe, false);
 
 	for_each_gt(gt, xe, id) {
 		err = xe_gt_suspend(gt);
 		if (err) {
-			xe_display_pm_resume(xe);
+			xe_display_pm_resume(xe, false);
 			goto err;
 		}
 	}
@@ -151,7 +151,7 @@ int xe_pm_resume(struct xe_device *xe)
 
 	xe_irq_resume(xe);
 
-	xe_display_pm_resume(xe);
+	xe_display_pm_resume(xe, false);
 
 	for_each_gt(gt, xe, id)
 		xe_gt_resume(gt);
@@ -366,6 +366,7 @@ int xe_pm_runtime_suspend(struct xe_device *xe)
 		err = xe_bo_evict_all(xe);
 		if (err)
 			goto out;
+		xe_display_pm_suspend(xe, true);
 	}
 
 	for_each_gt(gt, xe, id) {
@@ -375,7 +376,12 @@ int xe_pm_runtime_suspend(struct xe_device *xe)
 	}
 
 	xe_irq_suspend(xe);
+
+	if (xe->d3cold.allowed)
+		xe_display_pm_suspend_late(xe);
 out:
+	if (err)
+		xe_display_pm_resume(xe, true);
 	lock_map_release(&xe_pm_runtime_lockdep_map);
 	xe_pm_write_callback_task(xe, NULL);
 	return err;
@@ -411,6 +417,8 @@ int xe_pm_runtime_resume(struct xe_device *xe)
 		if (err)
 			goto out;
 
+		xe_display_pm_resume_early(xe);
+
 		/*
 		 * This only restores pinned memory which is the memory
 		 * required for the GT(s) to resume.
@@ -426,6 +434,7 @@ int xe_pm_runtime_resume(struct xe_device *xe)
 		xe_gt_resume(gt);
 
 	if (xe->d3cold.allowed && xe->d3cold.power_lost) {
+		xe_display_pm_resume(xe, true);
 		err = xe_bo_restore_user(xe);
 		if (err)
 			goto out;
-- 
2.43.0



