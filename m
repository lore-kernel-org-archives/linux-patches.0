Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FC51F6671;
	Tue,  3 Dec 2024 14:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236517; cv=none; b=Hi6ePJ6DRo1+96q0btufw9NOuSLt/HxTfeS8DWzdGDqSGkTuS+nX/+cI8OLU4CZWcr1At6Pmr21PxOsC7TEGoyGsbSshv76IUfr2HVZCqjIzrpD61yQ9JPGub7dMyrMUjBb/K/phF/VClMyIttcPYtSPXIpacjIem1tqulKzKfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236517; c=relaxed/simple;
	bh=cgTmBelcWDh4YlPUIi/LqMqJW9V8/zxRyWZnGkasX3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZE9wtNUM7O+TSks0xxbR7PVu9aHlfLszeDgCsKKzrbT0tI+bFZkmenXH7ie6MP4ONy0FGKQsL+gi1DgZtIqhQzI8dM43UMCAsQupyjK+6glxuF76ZQo/D++u/Vkr0RXzBvzO0PBVmfVsIa+84Y4KRBtglLBCmwEIwk0Hf2ju8Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NC3yO2Sl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NC3yO2Sl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B426C4CED8;
	Tue,  3 Dec 2024 14:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236517;
	bh=cgTmBelcWDh4YlPUIi/LqMqJW9V8/zxRyWZnGkasX3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NC3yO2SlwwFUenKh6SSgfnSaW/BokfHwY6kNPacGawv+bXnizjhR9CdFxDvahXlN/
	 2QPXMfx7pdy/MFAnNL6LXYdQufh8Ys0jVk0CdOLegNoj9K2tGwh5ftiYxHfqmqdzED
	 ntYMbghAqBPrg7+Er0XFDeLcoJTIIW/TOweGN0cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Agner <stefan@agner.ch>,
	Alison Wang <alison.wang@nxp.com>,
	=?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 043/138] drm/fsl-dcu: Use drm_fbdev_generic_setup()
Date: Tue,  3 Dec 2024 15:31:12 +0100
Message-ID: <20241203141925.206441287@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
User-Agent: quilt/0.67
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Noralf Trønnes <noralf@tronnes.org>

[ Upstream commit f4d26fa9136427d3cb2959cee13e0900b8004850 ]

The CMA helper is already using the drm_fb_helper_generic_probe part of
the generic fbdev emulation. This patch makes full use of the generic
fbdev emulation by using its drm_client callbacks. This means that
drm_mode_config_funcs->output_poll_changed and drm_driver->lastclose are
now handled by the emulation code. Additionally fbdev unregister happens
automatically on drm_dev_unregister().

The drm_fbdev_generic_setup() call is put after drm_dev_register() in the
driver. This is done to highlight the fact that fbdev emulation is an
internal client that makes use of the driver, it is not part of the
driver as such. If fbdev setup fails, an error is printed, but the driver
succeeds probing.

Cc: Stefan Agner <stefan@agner.ch>
Cc: Alison Wang <alison.wang@nxp.com>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Stefan Agner <stefan@agner.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20181025201340.34227-3-noralf@tronnes.org
Stable-dep-of: ffcde9e44d3e ("drm: fsl-dcu: enable PIXCLK on LS1021A")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c | 25 +++--------------------
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.h |  1 -
 2 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
index 80232321a244a..15816141e5fbe 100644
--- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
+++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
@@ -26,6 +26,7 @@
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_fb_cma_helper.h>
+#include <drm/drm_fb_helper.h>
 #include <drm/drm_gem_cma_helper.h>
 #include <drm/drm_modeset_helper.h>
 
@@ -89,20 +90,11 @@ static int fsl_dcu_load(struct drm_device *dev, unsigned long flags)
 			"Invalid legacyfb_depth.  Defaulting to 24bpp\n");
 		legacyfb_depth = 24;
 	}
-	fsl_dev->fbdev = drm_fbdev_cma_init(dev, legacyfb_depth, 1);
-	if (IS_ERR(fsl_dev->fbdev)) {
-		ret = PTR_ERR(fsl_dev->fbdev);
-		fsl_dev->fbdev = NULL;
-		goto done;
-	}
 
 	return 0;
 done:
 	drm_kms_helper_poll_fini(dev);
 
-	if (fsl_dev->fbdev)
-		drm_fbdev_cma_fini(fsl_dev->fbdev);
-
 	drm_mode_config_cleanup(dev);
 	drm_irq_uninstall(dev);
 	dev->dev_private = NULL;
@@ -112,14 +104,9 @@ static int fsl_dcu_load(struct drm_device *dev, unsigned long flags)
 
 static void fsl_dcu_unload(struct drm_device *dev)
 {
-	struct fsl_dcu_drm_device *fsl_dev = dev->dev_private;
-
 	drm_atomic_helper_shutdown(dev);
 	drm_kms_helper_poll_fini(dev);
 
-	if (fsl_dev->fbdev)
-		drm_fbdev_cma_fini(fsl_dev->fbdev);
-
 	drm_mode_config_cleanup(dev);
 	drm_irq_uninstall(dev);
 
@@ -147,19 +134,11 @@ static irqreturn_t fsl_dcu_drm_irq(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-static void fsl_dcu_drm_lastclose(struct drm_device *dev)
-{
-	struct fsl_dcu_drm_device *fsl_dev = dev->dev_private;
-
-	drm_fbdev_cma_restore_mode(fsl_dev->fbdev);
-}
-
 DEFINE_DRM_GEM_CMA_FOPS(fsl_dcu_drm_fops);
 
 static struct drm_driver fsl_dcu_drm_driver = {
 	.driver_features	= DRIVER_HAVE_IRQ | DRIVER_GEM | DRIVER_MODESET
 				| DRIVER_PRIME | DRIVER_ATOMIC,
-	.lastclose		= fsl_dcu_drm_lastclose,
 	.load			= fsl_dcu_load,
 	.unload			= fsl_dcu_unload,
 	.irq_handler		= fsl_dcu_drm_irq,
@@ -355,6 +334,8 @@ static int fsl_dcu_drm_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto unref;
 
+	drm_fbdev_generic_setup(drm, legacyfb_depth);
+
 	return 0;
 
 unref:
diff --git a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.h b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.h
index 93bfb98012d46..cb87bb74cb87a 100644
--- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.h
+++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.h
@@ -191,7 +191,6 @@ struct fsl_dcu_drm_device {
 	/*protects hardware register*/
 	spinlock_t irq_lock;
 	struct drm_device *drm;
-	struct drm_fbdev_cma *fbdev;
 	struct drm_crtc crtc;
 	struct drm_encoder encoder;
 	struct fsl_dcu_drm_connector connector;
-- 
2.43.0



