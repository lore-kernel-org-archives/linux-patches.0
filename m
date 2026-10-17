Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42183A5E70;
	Sat, 17 Oct 2026 16:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253244; cv=none; b=c210hl5BA75r81jvKcgSh45LfyeKaMvmw1OP6g57HtGrz6fM0yJ2v1HWIFkVxTm+LlH8Kpj9aW+eyNO5ONMHDa0cCH7qzNLBzlT17bkpNeGVCRfk8FQfJI+oUMyFgm+VzOJId78KJsuLZELUOG1yIz7T8dYoWuIpRlFsXzg9WxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253244; c=relaxed/simple;
	bh=zmdplJa77v8nWW1iPVr0y8TpPGmwUmpOb6MzZl3eU2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qdDM7Vtx0HaTLtJ+voWY+ThxDM5NFDyTXlNwXUPGy5UgA3kbI9IhGW2aKFvi2V17vxAGO15gDd6TU+re/TMirjAOs6YZz7pPwr0IA8iE6IkfWD3/qGgdInVyvJAMgkKGgorQSPtvuRxKNheolq6alHjYbcLiPxHkULycfo5PWQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7DtNeOc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7DtNeOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D665D1F000C5;
	Sat, 17 Oct 2026 16:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253242;
	bh=4oV4+CryxlNgWxtjcGGaOKfx24AOKXJqGO7a7dcMiNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7DtNeOc6/Y3Kl/e/b24GLvz3nq2+gnsV10g0cwBjgs1cBUL/fsVav4AU5nl2LyDf
	 GJ/ss6B5lpoZ0EJaqOoacdCZ1+QvmQmgf3T/Y6XpOVUmAN1wvHxOSeSbVtBMlQISF7
	 lrBN51G9c6JB7EOQLGrc6td4j8NYcEPmvEDvOPaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/869] drm/i915/vga: Convert VGA code to intel_display
Date: Sat, 17 Oct 2026 17:48:15 +0200
Message-ID: <20261017160038.405766203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 4b6e05c43b7542e9baaf70a0064b9198fe495fd2 ]

struct intel_display will replace struct drm_i915_private as
the main thing for display code. Convert the VGA code to
use it (as much as possible at this stage).

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240906143306.15937-5-ville.syrjala@linux.intel.com
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: dc3806d9eb66 ("drm/i915: Grab intel_display from the encoder to avoid potential oopsies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/i915/display/intel_display_driver.c   | 11 ++---
 .../i915/display/intel_display_power_well.c   |  6 ++-
 drivers/gpu/drm/i915/display/intel_vga.c      | 45 ++++++++++---------
 drivers/gpu/drm/i915/display/intel_vga.h      | 14 +++---
 drivers/gpu/drm/i915/i915_suspend.c           |  3 +-
 5 files changed, 43 insertions(+), 36 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_driver.c b/drivers/gpu/drm/i915/display/intel_display_driver.c
index e7670774ecd08..c189ce08a950a 100644
--- a/drivers/gpu/drm/i915/display/intel_display_driver.c
+++ b/drivers/gpu/drm/i915/display/intel_display_driver.c
@@ -220,7 +220,7 @@ int intel_display_driver_probe_noirq(struct drm_i915_private *i915)
 
 	intel_bios_init(display);
 
-	ret = intel_vga_register(i915);
+	ret = intel_vga_register(display);
 	if (ret)
 		goto cleanup_bios;
 
@@ -274,7 +274,7 @@ int intel_display_driver_probe_noirq(struct drm_i915_private *i915)
 	intel_dmc_fini(i915);
 	intel_power_domains_driver_remove(i915);
 cleanup_vga:
-	intel_vga_unregister(i915);
+	intel_vga_unregister(display);
 cleanup_bios:
 	intel_bios_driver_remove(display);
 
@@ -457,7 +457,7 @@ int intel_display_driver_probe_nogem(struct drm_i915_private *i915)
 	intel_hti_init(display);
 
 	/* Just disable it once at startup */
-	intel_vga_disable(i915);
+	intel_vga_disable(display);
 	intel_setup_outputs(i915);
 
 	ret = intel_dp_tunnel_mgr_init(display);
@@ -624,7 +624,7 @@ void intel_display_driver_remove_nogem(struct drm_i915_private *i915)
 
 	intel_power_domains_driver_remove(i915);
 
-	intel_vga_unregister(i915);
+	intel_vga_unregister(display);
 
 	intel_bios_driver_remove(display);
 }
@@ -682,12 +682,13 @@ __intel_display_driver_resume(struct drm_i915_private *i915,
 			      struct drm_atomic_state *state,
 			      struct drm_modeset_acquire_ctx *ctx)
 {
+	struct intel_display *display = &i915->display;
 	struct drm_crtc_state *crtc_state;
 	struct drm_crtc *crtc;
 	int ret, i;
 
 	intel_modeset_setup_hw_state(i915, ctx);
-	intel_vga_redisable(i915);
+	intel_vga_redisable(display);
 
 	if (!state)
 		return 0;
diff --git a/drivers/gpu/drm/i915/display/intel_display_power_well.c b/drivers/gpu/drm/i915/display/intel_display_power_well.c
index 46e9eff12c234..3c1a211e7b96d 100644
--- a/drivers/gpu/drm/i915/display/intel_display_power_well.c
+++ b/drivers/gpu/drm/i915/display/intel_display_power_well.c
@@ -187,8 +187,10 @@ int intel_power_well_refcount(struct i915_power_well *power_well)
 static void hsw_power_well_post_enable(struct drm_i915_private *dev_priv,
 				       u8 irq_pipe_mask, bool has_vga)
 {
+	struct intel_display *display = &dev_priv->display;
+
 	if (has_vga)
-		intel_vga_reset_io_mem(dev_priv);
+		intel_vga_reset_io_mem(display);
 
 	if (irq_pipe_mask)
 		gen8_irq_power_well_post_enable(dev_priv, irq_pipe_mask);
@@ -1232,7 +1234,7 @@ static void vlv_display_power_well_init(struct drm_i915_private *dev_priv)
 			intel_crt_reset(&encoder->base);
 	}
 
-	intel_vga_redisable_power_on(dev_priv);
+	intel_vga_redisable_power_on(display);
 
 	intel_pps_unlock_regs_wa(display);
 }
diff --git a/drivers/gpu/drm/i915/display/intel_vga.c b/drivers/gpu/drm/i915/display/intel_vga.c
index 0b5916c15307e..2c76a0176a357 100644
--- a/drivers/gpu/drm/i915/display/intel_vga.c
+++ b/drivers/gpu/drm/i915/display/intel_vga.c
@@ -14,24 +14,26 @@
 #include "intel_de.h"
 #include "intel_vga.h"
 
-static i915_reg_t intel_vga_cntrl_reg(struct drm_i915_private *i915)
+static i915_reg_t intel_vga_cntrl_reg(struct intel_display *display)
 {
+	struct drm_i915_private *i915 = to_i915(display->drm);
+
 	if (IS_VALLEYVIEW(i915) || IS_CHERRYVIEW(i915))
 		return VLV_VGACNTRL;
-	else if (DISPLAY_VER(i915) >= 5)
+	else if (DISPLAY_VER(display) >= 5)
 		return CPU_VGACNTRL;
 	else
 		return VGACNTRL;
 }
 
 /* Disable the VGA plane that we never use */
-void intel_vga_disable(struct drm_i915_private *dev_priv)
+void intel_vga_disable(struct intel_display *display)
 {
-	struct pci_dev *pdev = to_pci_dev(dev_priv->drm.dev);
-	i915_reg_t vga_reg = intel_vga_cntrl_reg(dev_priv);
+	struct pci_dev *pdev = to_pci_dev(display->drm->dev);
+	i915_reg_t vga_reg = intel_vga_cntrl_reg(display);
 	u8 sr1;
 
-	if (intel_de_read(dev_priv, vga_reg) & VGA_DISP_DISABLE)
+	if (intel_de_read(display, vga_reg) & VGA_DISP_DISABLE)
 		return;
 
 	/* WaEnableVGAAccessThroughIOPort:ctg,elk,ilk,snb,ivb,vlv,hsw */
@@ -42,23 +44,24 @@ void intel_vga_disable(struct drm_i915_private *dev_priv)
 	vga_put(pdev, VGA_RSRC_LEGACY_IO);
 	udelay(300);
 
-	intel_de_write(dev_priv, vga_reg, VGA_DISP_DISABLE);
-	intel_de_posting_read(dev_priv, vga_reg);
+	intel_de_write(display, vga_reg, VGA_DISP_DISABLE);
+	intel_de_posting_read(display, vga_reg);
 }
 
-void intel_vga_redisable_power_on(struct drm_i915_private *dev_priv)
+void intel_vga_redisable_power_on(struct intel_display *display)
 {
-	i915_reg_t vga_reg = intel_vga_cntrl_reg(dev_priv);
+	i915_reg_t vga_reg = intel_vga_cntrl_reg(display);
 
-	if (!(intel_de_read(dev_priv, vga_reg) & VGA_DISP_DISABLE)) {
-		drm_dbg_kms(&dev_priv->drm,
+	if (!(intel_de_read(display, vga_reg) & VGA_DISP_DISABLE)) {
+		drm_dbg_kms(display->drm,
 			    "Something enabled VGA plane, disabling it\n");
-		intel_vga_disable(dev_priv);
+		intel_vga_disable(display);
 	}
 }
 
-void intel_vga_redisable(struct drm_i915_private *i915)
+void intel_vga_redisable(struct intel_display *display)
 {
+	struct drm_i915_private *i915 = to_i915(display->drm);
 	intel_wakeref_t wakeref;
 
 	/*
@@ -74,14 +77,14 @@ void intel_vga_redisable(struct drm_i915_private *i915)
 	if (!wakeref)
 		return;
 
-	intel_vga_redisable_power_on(i915);
+	intel_vga_redisable_power_on(display);
 
 	intel_display_power_put(i915, POWER_DOMAIN_VGA, wakeref);
 }
 
-void intel_vga_reset_io_mem(struct drm_i915_private *i915)
+void intel_vga_reset_io_mem(struct intel_display *display)
 {
-	struct pci_dev *pdev = to_pci_dev(i915->drm.dev);
+	struct pci_dev *pdev = to_pci_dev(display->drm->dev);
 
 	/*
 	 * After we re-enable the power well, if we touch VGA register 0x3d5
@@ -98,10 +101,10 @@ void intel_vga_reset_io_mem(struct drm_i915_private *i915)
 	vga_put(pdev, VGA_RSRC_LEGACY_IO);
 }
 
-int intel_vga_register(struct drm_i915_private *i915)
+int intel_vga_register(struct intel_display *display)
 {
 
-	struct pci_dev *pdev = to_pci_dev(i915->drm.dev);
+	struct pci_dev *pdev = to_pci_dev(display->drm->dev);
 	int ret;
 
 	/*
@@ -119,9 +122,9 @@ int intel_vga_register(struct drm_i915_private *i915)
 	return 0;
 }
 
-void intel_vga_unregister(struct drm_i915_private *i915)
+void intel_vga_unregister(struct intel_display *display)
 {
-	struct pci_dev *pdev = to_pci_dev(i915->drm.dev);
+	struct pci_dev *pdev = to_pci_dev(display->drm->dev);
 
 	vga_client_unregister(pdev);
 }
diff --git a/drivers/gpu/drm/i915/display/intel_vga.h b/drivers/gpu/drm/i915/display/intel_vga.h
index ba5b55b917f08..824dfc32a1992 100644
--- a/drivers/gpu/drm/i915/display/intel_vga.h
+++ b/drivers/gpu/drm/i915/display/intel_vga.h
@@ -6,13 +6,13 @@
 #ifndef __INTEL_VGA_H__
 #define __INTEL_VGA_H__
 
-struct drm_i915_private;
+struct intel_display;
 
-void intel_vga_reset_io_mem(struct drm_i915_private *i915);
-void intel_vga_disable(struct drm_i915_private *i915);
-void intel_vga_redisable(struct drm_i915_private *i915);
-void intel_vga_redisable_power_on(struct drm_i915_private *i915);
-int intel_vga_register(struct drm_i915_private *i915);
-void intel_vga_unregister(struct drm_i915_private *i915);
+void intel_vga_reset_io_mem(struct intel_display *display);
+void intel_vga_disable(struct intel_display *display);
+void intel_vga_redisable(struct intel_display *display);
+void intel_vga_redisable_power_on(struct intel_display *display);
+int intel_vga_register(struct intel_display *display);
+void intel_vga_unregister(struct intel_display *display);
 
 #endif /* __INTEL_VGA_H__ */
diff --git a/drivers/gpu/drm/i915/i915_suspend.c b/drivers/gpu/drm/i915/i915_suspend.c
index f8373a461f176..9d3d9b9830320 100644
--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -118,6 +118,7 @@ void i915_save_display(struct drm_i915_private *dev_priv)
 
 void i915_restore_display(struct drm_i915_private *dev_priv)
 {
+	struct intel_display *display = &dev_priv->display;
 	struct pci_dev *pdev = to_pci_dev(dev_priv->drm.dev);
 
 	if (!HAS_DISPLAY(dev_priv))
@@ -134,7 +135,7 @@ void i915_restore_display(struct drm_i915_private *dev_priv)
 		intel_de_write(dev_priv, DSPARB(dev_priv),
 			       dev_priv->regfile.saveDSPARB);
 
-	intel_vga_redisable(dev_priv);
+	intel_vga_redisable(display);
 
 	intel_gmbus_reset(dev_priv);
 }
-- 
2.53.0



