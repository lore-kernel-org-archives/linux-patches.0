Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B952120F079;
	Tue,  6 Jan 2026 18:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722518; cv=none; b=gOXX1niGTafl2ddA3/AO0GMRH08NJXtspavG6RpJOVSW1Vdfe+Le46mQBa1iJNdpA58lkslB9pzQG/7Yb7UVj7aIlSPxwf1piQHApTV5fuX+rk7k7FbYBvWv+8ScCbajHsJ8xd0sFniRm8hLoj0Envu5MZBNdbdSf/65GGaGHD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722518; c=relaxed/simple;
	bh=Q2j6lBnvHS3YvIq0MvRmnzLqUQ5M9TYjaIZ2KsGTfig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8fI71YSRt5s+O+gfGQvL5YXmxb+/5UPfvuL23m1J0flr7ll4gVvohnfA+v0YLuwiQAkOer5rvyPMtwTac/M1hFKpyh2aw5RLA8xRiDrU09txwZw9TCs6t/FoImgGRvYvsBT/+EYSuMDVdRv3oDngk4TgrEL6pQ47DNmkpU6jgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUDRQwrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUDRQwrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3496DC116C6;
	Tue,  6 Jan 2026 18:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722518;
	bh=Q2j6lBnvHS3YvIq0MvRmnzLqUQ5M9TYjaIZ2KsGTfig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUDRQwrEeUJekJCvU4Xp9SKQmlnT/vSkN/p85159irdcZ/9TWUtsHVU4hm+1I6yC8
	 QhGVC5eX72V58Sg1WoaF9uS9vmFaOmEjftHnI1bc8jUQa26vtsn/Bf7SKbfU6YKk83
	 oJc4fhbYaIUOLHDdMKI8BlvCKUszAbS+MfYZnT48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kory Maincent (TI.com)" <kory.maincent@bootlin.com>,
	Douglas Anderson <dianders@chromium.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.18 288/312] drm/tilcdc: Fix removal actions in case of failed probe
Date: Tue,  6 Jan 2026 18:06:02 +0100
Message-ID: <20260106170558.273244146@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent (TI.com) <kory.maincent@bootlin.com>

commit a585c7ef9cabda58088916baedc6573e9a5cd2a7 upstream.

The drm_kms_helper_poll_fini() and drm_atomic_helper_shutdown() helpers
should only be called when the device has been successfully registered.
Currently, these functions are called unconditionally in tilcdc_fini(),
which causes warnings during probe deferral scenarios.

[    7.972317] WARNING: CPU: 0 PID: 23 at drivers/gpu/drm/drm_atomic_state_helper.c:175 drm_atomic_helper_crtc_duplicate_state+0x60/0x68
...
[    8.005820]  drm_atomic_helper_crtc_duplicate_state from drm_atomic_get_crtc_state+0x68/0x108
[    8.005858]  drm_atomic_get_crtc_state from drm_atomic_helper_disable_all+0x90/0x1c8
[    8.005885]  drm_atomic_helper_disable_all from drm_atomic_helper_shutdown+0x90/0x144
[    8.005911]  drm_atomic_helper_shutdown from tilcdc_fini+0x68/0xf8 [tilcdc]
[    8.005957]  tilcdc_fini [tilcdc] from tilcdc_pdev_probe+0xb0/0x6d4 [tilcdc]

Fix this by rewriting the failed probe cleanup path using the standard
goto error handling pattern, which ensures that cleanup functions are
only called on successfully initialized resources. Additionally, remove
the now-unnecessary is_registered flag.

Cc: stable@vger.kernel.org
Fixes: 3c4babae3c4a ("drm: Call drm_atomic_helper_shutdown() at shutdown/remove time for misc drivers")
Signed-off-by: Kory Maincent (TI.com) <kory.maincent@bootlin.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20251125090546.137193-1-kory.maincent@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c |    2 -
 drivers/gpu/drm/tilcdc/tilcdc_drv.c  |   53 +++++++++++++++++++++++------------
 drivers/gpu/drm/tilcdc/tilcdc_drv.h  |    2 -
 3 files changed, 37 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
@@ -586,7 +586,7 @@ out:
 	drm_modeset_unlock(&crtc->mutex);
 }
 
-static void tilcdc_crtc_destroy(struct drm_crtc *crtc)
+void tilcdc_crtc_destroy(struct drm_crtc *crtc)
 {
 	struct tilcdc_drm_private *priv = crtc->dev->dev_private;
 
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -172,8 +172,7 @@ static void tilcdc_fini(struct drm_devic
 	if (priv->crtc)
 		tilcdc_crtc_shutdown(priv->crtc);
 
-	if (priv->is_registered)
-		drm_dev_unregister(dev);
+	drm_dev_unregister(dev);
 
 	drm_kms_helper_poll_fini(dev);
 	drm_atomic_helper_shutdown(dev);
@@ -220,21 +219,21 @@ static int tilcdc_init(const struct drm_
 	priv->wq = alloc_ordered_workqueue("tilcdc", 0);
 	if (!priv->wq) {
 		ret = -ENOMEM;
-		goto init_failed;
+		goto put_drm;
 	}
 
 	priv->mmio = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->mmio)) {
 		dev_err(dev, "failed to request / ioremap\n");
 		ret = PTR_ERR(priv->mmio);
-		goto init_failed;
+		goto free_wq;
 	}
 
 	priv->clk = clk_get(dev, "fck");
 	if (IS_ERR(priv->clk)) {
 		dev_err(dev, "failed to get functional clock\n");
 		ret = -ENODEV;
-		goto init_failed;
+		goto free_wq;
 	}
 
 	pm_runtime_enable(dev);
@@ -313,7 +312,7 @@ static int tilcdc_init(const struct drm_
 	ret = tilcdc_crtc_create(ddev);
 	if (ret < 0) {
 		dev_err(dev, "failed to create crtc\n");
-		goto init_failed;
+		goto disable_pm;
 	}
 	modeset_init(ddev);
 
@@ -324,46 +323,46 @@ static int tilcdc_init(const struct drm_
 	if (ret) {
 		dev_err(dev, "failed to register cpufreq notifier\n");
 		priv->freq_transition.notifier_call = NULL;
-		goto init_failed;
+		goto destroy_crtc;
 	}
 #endif
 
 	if (priv->is_componentized) {
 		ret = component_bind_all(dev, ddev);
 		if (ret < 0)
-			goto init_failed;
+			goto unregister_cpufreq_notif;
 
 		ret = tilcdc_add_component_encoder(ddev);
 		if (ret < 0)
-			goto init_failed;
+			goto unbind_component;
 	} else {
 		ret = tilcdc_attach_external_device(ddev);
 		if (ret)
-			goto init_failed;
+			goto unregister_cpufreq_notif;
 	}
 
 	if (!priv->external_connector &&
 	    ((priv->num_encoders == 0) || (priv->num_connectors == 0))) {
 		dev_err(dev, "no encoders/connectors found\n");
 		ret = -EPROBE_DEFER;
-		goto init_failed;
+		goto unbind_component;
 	}
 
 	ret = drm_vblank_init(ddev, 1);
 	if (ret < 0) {
 		dev_err(dev, "failed to initialize vblank\n");
-		goto init_failed;
+		goto unbind_component;
 	}
 
 	ret = platform_get_irq(pdev, 0);
 	if (ret < 0)
-		goto init_failed;
+		goto unbind_component;
 	priv->irq = ret;
 
 	ret = tilcdc_irq_install(ddev, priv->irq);
 	if (ret < 0) {
 		dev_err(dev, "failed to install IRQ handler\n");
-		goto init_failed;
+		goto unbind_component;
 	}
 
 	drm_mode_config_reset(ddev);
@@ -372,16 +371,34 @@ static int tilcdc_init(const struct drm_
 
 	ret = drm_dev_register(ddev, 0);
 	if (ret)
-		goto init_failed;
-	priv->is_registered = true;
+		goto stop_poll;
 
 	drm_client_setup_with_color_mode(ddev, bpp);
 
 	return 0;
 
-init_failed:
-	tilcdc_fini(ddev);
+stop_poll:
+	drm_kms_helper_poll_fini(ddev);
+	tilcdc_irq_uninstall(ddev);
+unbind_component:
+	if (priv->is_componentized)
+		component_unbind_all(dev, ddev);
+unregister_cpufreq_notif:
+#ifdef CONFIG_CPU_FREQ
+	cpufreq_unregister_notifier(&priv->freq_transition,
+				    CPUFREQ_TRANSITION_NOTIFIER);
+destroy_crtc:
+#endif
+	tilcdc_crtc_destroy(priv->crtc);
+disable_pm:
+	pm_runtime_disable(dev);
+	clk_put(priv->clk);
+free_wq:
+	destroy_workqueue(priv->wq);
+put_drm:
 	platform_set_drvdata(pdev, NULL);
+	ddev->dev_private = NULL;
+	drm_dev_put(ddev);
 
 	return ret;
 }
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.h
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.h
@@ -82,7 +82,6 @@ struct tilcdc_drm_private {
 	struct drm_encoder *external_encoder;
 	struct drm_connector *external_connector;
 
-	bool is_registered;
 	bool is_componentized;
 	bool irq_enabled;
 };
@@ -164,6 +163,7 @@ void tilcdc_crtc_set_panel_info(struct d
 void tilcdc_crtc_set_simulate_vesa_sync(struct drm_crtc *crtc,
 					bool simulate_vesa_sync);
 void tilcdc_crtc_shutdown(struct drm_crtc *crtc);
+void tilcdc_crtc_destroy(struct drm_crtc *crtc);
 int tilcdc_crtc_update_fb(struct drm_crtc *crtc,
 		struct drm_framebuffer *fb,
 		struct drm_pending_vblank_event *event);


