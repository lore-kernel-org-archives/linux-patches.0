Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731D62192EC;
	Mon, 23 Jun 2025 22:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717443; cv=none; b=DkYfBzyZ/tvFW0N2to1+UcmyhlLMapjATVI/YZh22y/Xi1glwCmS8+AuFzmvG7UJshjKpwQzC4Yy3hs2t+tAKylvwwbm1EDrpjMb0y6gxnAnrCVFXSbAhNT3OuHiACLPwyXMJSmeelf7b1ISRPlGmVbBZVT1x6xQEcNuzUKRjLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717443; c=relaxed/simple;
	bh=EE0OltR5gzMSUy/N21p/y+idEdYnqjBgT3x0Vg6H04I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d97C2ciFn917L3tQd9VcBHYtShhgGnu6qM0HXYHlzq8/rApdG8SRdlAAQbP6hx8WAS//ZkxXCg18xJdVprpjhNTNxGhJdupcta16id+a6EtOzQhktb8lutrnGW15JV9kPf/zviD5GMzr7tCxvrMkCfNAh9LXi55vcOBBYrZMd2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dF/UK9po; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dF/UK9po"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0ADC4CEED;
	Mon, 23 Jun 2025 22:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717443;
	bh=EE0OltR5gzMSUy/N21p/y+idEdYnqjBgT3x0Vg6H04I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dF/UK9poT616RkD0h3aWZMNyzhIfL/HjFwx+5ND+LUpwkFrFDB5s6LMeVKXC4mvXe
	 myKm1hfQggJAExAp65w1k1+mDsiaUt44QiZIG3LjYB1Og/RqIwQXPZcdD2F5v+/wVt
	 BeBTPpmbBm3y6VqMbnPTabFShWiZp9kmS8zaKNdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 388/414] drm/xe: Wire up device shutdown handler
Date: Mon, 23 Jun 2025 15:08:45 +0200
Message-ID: <20250623130651.645124773@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

[ Upstream commit 501d799a47e2b83b4e41d5306c2266ea5c100a08 ]

The system is turning off, and we should probably put the device
in a safe power state. We don't need to evict VRAM or suspend running
jobs to a safe state, as the device is rebooted anyway.

This does not imply the system is necessarily reset, as we can
kexec into a new kernel. Without shutting down, things like
USB Type-C may mysteriously start failing.

References: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/3500
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
[mlankhorst: Add !xe_driver_flr_disabled assert]
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240905150052.174895-4-maarten.lankhorst@linux.intel.com
Stable-dep-of: 16c1241b0875 ("drm/xe/bmg: Update Wa_16023588340")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/xe_display.c | 43 +++++++++++++++++++++++++
 drivers/gpu/drm/xe/display/xe_display.h |  4 +++
 drivers/gpu/drm/xe/xe_device.c          | 40 +++++++++++++++++++----
 drivers/gpu/drm/xe/xe_gt.c              |  7 ++++
 drivers/gpu/drm/xe/xe_gt.h              |  1 +
 5 files changed, 89 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/xe/display/xe_display.c b/drivers/gpu/drm/xe/display/xe_display.c
index c6e0c8d77a70f..a1928cedc7ddf 100644
--- a/drivers/gpu/drm/xe/display/xe_display.c
+++ b/drivers/gpu/drm/xe/display/xe_display.c
@@ -352,6 +352,36 @@ void xe_display_pm_suspend(struct xe_device *xe)
 	__xe_display_pm_suspend(xe, false);
 }
 
+void xe_display_pm_shutdown(struct xe_device *xe)
+{
+	struct intel_display *display = &xe->display;
+
+	if (!xe->info.probe_display)
+		return;
+
+	intel_power_domains_disable(xe);
+	intel_fbdev_set_suspend(&xe->drm, FBINFO_STATE_SUSPENDED, true);
+	if (has_display(xe)) {
+		drm_kms_helper_poll_disable(&xe->drm);
+		intel_display_driver_disable_user_access(xe);
+		intel_display_driver_suspend(xe);
+	}
+
+	xe_display_flush_cleanup_work(xe);
+	intel_dp_mst_suspend(xe);
+	intel_hpd_cancel_work(xe);
+
+	if (has_display(xe))
+		intel_display_driver_suspend_access(xe);
+
+	intel_encoder_suspend_all(display);
+	intel_encoder_shutdown_all(display);
+
+	intel_opregion_suspend(display, PCI_D3cold);
+
+	intel_dmc_suspend(xe);
+}
+
 void xe_display_pm_runtime_suspend(struct xe_device *xe)
 {
 	if (!xe->info.probe_display)
@@ -376,6 +406,19 @@ void xe_display_pm_suspend_late(struct xe_device *xe)
 	intel_display_power_suspend_late(xe);
 }
 
+void xe_display_pm_shutdown_late(struct xe_device *xe)
+{
+	if (!xe->info.probe_display)
+		return;
+
+	/*
+	 * The only requirement is to reboot with display DC states disabled,
+	 * for now leaving all display power wells in the INIT power domain
+	 * enabled.
+	 */
+	intel_power_domains_driver_remove(xe);
+}
+
 void xe_display_pm_resume_early(struct xe_device *xe)
 {
 	if (!xe->info.probe_display)
diff --git a/drivers/gpu/drm/xe/display/xe_display.h b/drivers/gpu/drm/xe/display/xe_display.h
index bed55fd26f304..17afa537aee50 100644
--- a/drivers/gpu/drm/xe/display/xe_display.h
+++ b/drivers/gpu/drm/xe/display/xe_display.h
@@ -35,7 +35,9 @@ void xe_display_irq_reset(struct xe_device *xe);
 void xe_display_irq_postinstall(struct xe_device *xe, struct xe_gt *gt);
 
 void xe_display_pm_suspend(struct xe_device *xe);
+void xe_display_pm_shutdown(struct xe_device *xe);
 void xe_display_pm_suspend_late(struct xe_device *xe);
+void xe_display_pm_shutdown_late(struct xe_device *xe);
 void xe_display_pm_resume_early(struct xe_device *xe);
 void xe_display_pm_resume(struct xe_device *xe);
 void xe_display_pm_runtime_suspend(struct xe_device *xe);
@@ -66,7 +68,9 @@ static inline void xe_display_irq_reset(struct xe_device *xe) {}
 static inline void xe_display_irq_postinstall(struct xe_device *xe, struct xe_gt *gt) {}
 
 static inline void xe_display_pm_suspend(struct xe_device *xe) {}
+static inline void xe_display_pm_shutdown(struct xe_device *xe) {}
 static inline void xe_display_pm_suspend_late(struct xe_device *xe) {}
+static inline void xe_display_pm_shutdown_late(struct xe_device *xe) {}
 static inline void xe_display_pm_resume_early(struct xe_device *xe) {}
 static inline void xe_display_pm_resume(struct xe_device *xe) {}
 static inline void xe_display_pm_runtime_suspend(struct xe_device *xe) {}
diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 23e02372a49db..0c3db53b93d8a 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -374,6 +374,11 @@ struct xe_device *xe_device_create(struct pci_dev *pdev,
 	return ERR_PTR(err);
 }
 
+static bool xe_driver_flr_disabled(struct xe_device *xe)
+{
+	return xe_mmio_read32(xe_root_mmio_gt(xe), GU_CNTL_PROTECTED) & DRIVERINT_FLR_DIS;
+}
+
 /*
  * The driver-initiated FLR is the highest level of reset that we can trigger
  * from within the driver. It is different from the PCI FLR in that it doesn't
@@ -387,17 +392,12 @@ struct xe_device *xe_device_create(struct pci_dev *pdev,
  * if/when a new instance of i915 is bound to the device it will do a full
  * re-init anyway.
  */
-static void xe_driver_flr(struct xe_device *xe)
+static void __xe_driver_flr(struct xe_device *xe)
 {
 	const unsigned int flr_timeout = 3 * MICRO; /* specs recommend a 3s wait */
 	struct xe_gt *gt = xe_root_mmio_gt(xe);
 	int ret;
 
-	if (xe_mmio_read32(gt, GU_CNTL_PROTECTED) & DRIVERINT_FLR_DIS) {
-		drm_info_once(&xe->drm, "BIOS Disabled Driver-FLR\n");
-		return;
-	}
-
 	drm_dbg(&xe->drm, "Triggering Driver-FLR\n");
 
 	/*
@@ -438,6 +438,16 @@ static void xe_driver_flr(struct xe_device *xe)
 	xe_mmio_write32(gt, GU_DEBUG, DRIVERFLR_STATUS);
 }
 
+static void xe_driver_flr(struct xe_device *xe)
+{
+	if (xe_driver_flr_disabled(xe)) {
+		drm_info_once(&xe->drm, "BIOS Disabled Driver-FLR\n");
+		return;
+	}
+
+	__xe_driver_flr(xe);
+}
+
 static void xe_driver_flr_fini(void *arg)
 {
 	struct xe_device *xe = arg;
@@ -797,6 +807,24 @@ void xe_device_remove(struct xe_device *xe)
 
 void xe_device_shutdown(struct xe_device *xe)
 {
+	struct xe_gt *gt;
+	u8 id;
+
+	drm_dbg(&xe->drm, "Shutting down device\n");
+
+	if (xe_driver_flr_disabled(xe)) {
+		xe_display_pm_shutdown(xe);
+
+		xe_irq_suspend(xe);
+
+		for_each_gt(gt, xe, id)
+			xe_gt_shutdown(gt);
+
+		xe_display_pm_shutdown_late(xe);
+	} else {
+		/* BOOM! */
+		__xe_driver_flr(xe);
+	}
 }
 
 /**
diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index 3a7628fb5ad32..258a6d6715679 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -865,6 +865,13 @@ int xe_gt_suspend(struct xe_gt *gt)
 	return err;
 }
 
+void xe_gt_shutdown(struct xe_gt *gt)
+{
+	xe_force_wake_get(gt_to_fw(gt), XE_FORCEWAKE_ALL);
+	do_gt_reset(gt);
+	xe_force_wake_put(gt_to_fw(gt), XE_FORCEWAKE_ALL);
+}
+
 /**
  * xe_gt_sanitize_freq() - Restore saved frequencies if necessary.
  * @gt: the GT object
diff --git a/drivers/gpu/drm/xe/xe_gt.h b/drivers/gpu/drm/xe/xe_gt.h
index ee138e9768a23..881f1cbc2c491 100644
--- a/drivers/gpu/drm/xe/xe_gt.h
+++ b/drivers/gpu/drm/xe/xe_gt.h
@@ -48,6 +48,7 @@ void xe_gt_record_user_engines(struct xe_gt *gt);
 
 void xe_gt_suspend_prepare(struct xe_gt *gt);
 int xe_gt_suspend(struct xe_gt *gt);
+void xe_gt_shutdown(struct xe_gt *gt);
 int xe_gt_resume(struct xe_gt *gt);
 void xe_gt_reset_async(struct xe_gt *gt);
 void xe_gt_sanitize(struct xe_gt *gt);
-- 
2.39.5



