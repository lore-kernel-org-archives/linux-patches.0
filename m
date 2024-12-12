Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2604F218;
	Thu, 12 Dec 2024 17:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023999; cv=none; b=eBCw+WhToPLAVS2chUvltlrsC5dKMQtpn8w8NOvuIr5weokQ734lMTbdFCV7mSjExPxz8weJrE33zMQPlbsBAfE9ixe7V1rhkY+WsoY/UVxS+qEIE/srZOBeXOgGZbNHc8UJtkMTduCyZxRENqHJsfH1d7f670H2FTVj/w6IBUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023999; c=relaxed/simple;
	bh=wER+7Ap+Zgf+ID5c+Bo+Y7erjgvIZC5eqFBr3I7sSSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfuqdU5QZP21+cmfsJA86hhdXK91ZhyYbtI+UFgAaz2BnXUtUk/gWWbg1LS/xNNPSYcSBhGvB+8SBoIEpgDXyIhj86XwQcjuntGwZiFjnZqPxupgM6eTqEbNV+zwRoTRVUlb6FHlvGzix71mXEEPhKaPK5ViQyXnpHFxE0SKQ2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QucwxiBP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QucwxiBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24C7C4CECE;
	Thu, 12 Dec 2024 17:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023999;
	bh=wER+7Ap+Zgf+ID5c+Bo+Y7erjgvIZC5eqFBr3I7sSSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QucwxiBPH0NGAwmBs+Fg2ppt6DvIXbJa6YamVfteEbASvILOGvzp9hGf8V3SQWxAy
	 4ENXH9TOg7Ke6bnOyNqgGmY95IPi4kG90WTVJHZ2FA0uZyzlmXsYXMLNfrXbfkxXK8
	 TYAkz4JmXTgHhYSckVRKRe+AA2/SvGuB+NgAIAY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/459] drm/fsl-dcu: Convert to Linux IRQ interfaces
Date: Thu, 12 Dec 2024 15:57:41 +0100
Message-ID: <20241212144258.367259360@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 03ac16e584e496230903ba20f2b4bbfd942a16b4 ]

Drop the DRM IRQ midlayer in favor of Linux IRQ interfaces. DRM's
IRQ helpers are mostly useful for UMS drivers. Modern KMS drivers
don't benefit from using it. DRM IRQ callbacks are now being called
directly or inlined.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210803090704.32152-5-tzimmermann@suse.de
Stable-dep-of: ffcde9e44d3e ("drm: fsl-dcu: enable PIXCLK on LS1021A")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c | 78 +++++++++++++----------
 1 file changed, 46 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
index abbc1ddbf27f0..11b4a81bacc68 100644
--- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
+++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
@@ -23,7 +23,6 @@
 #include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_fb_helper.h>
 #include <drm/drm_gem_cma_helper.h>
-#include <drm/drm_irq.h>
 #include <drm/drm_modeset_helper.h>
 #include <drm/drm_probe_helper.h>
 #include <drm/drm_vblank.h>
@@ -51,7 +50,7 @@ static const struct regmap_config fsl_dcu_regmap_config = {
 	.volatile_reg = fsl_dcu_drm_is_volatile_reg,
 };
 
-static void fsl_dcu_irq_uninstall(struct drm_device *dev)
+static void fsl_dcu_irq_reset(struct drm_device *dev)
 {
 	struct fsl_dcu_drm_device *fsl_dev = dev->dev_private;
 
@@ -59,6 +58,45 @@ static void fsl_dcu_irq_uninstall(struct drm_device *dev)
 	regmap_write(fsl_dev->regmap, DCU_INT_MASK, ~0);
 }
 
+static irqreturn_t fsl_dcu_drm_irq(int irq, void *arg)
+{
+	struct drm_device *dev = arg;
+	struct fsl_dcu_drm_device *fsl_dev = dev->dev_private;
+	unsigned int int_status;
+	int ret;
+
+	ret = regmap_read(fsl_dev->regmap, DCU_INT_STATUS, &int_status);
+	if (ret) {
+		dev_err(dev->dev, "read DCU_INT_STATUS failed\n");
+		return IRQ_NONE;
+	}
+
+	if (int_status & DCU_INT_STATUS_VBLANK)
+		drm_handle_vblank(dev, 0);
+
+	regmap_write(fsl_dev->regmap, DCU_INT_STATUS, int_status);
+
+	return IRQ_HANDLED;
+}
+
+static int fsl_dcu_irq_install(struct drm_device *dev, unsigned int irq)
+{
+	if (irq == IRQ_NOTCONNECTED)
+		return -ENOTCONN;
+
+	fsl_dcu_irq_reset(dev);
+
+	return request_irq(irq, fsl_dcu_drm_irq, 0, dev->driver->name, dev);
+}
+
+static void fsl_dcu_irq_uninstall(struct drm_device *dev)
+{
+	struct fsl_dcu_drm_device *fsl_dev = dev->dev_private;
+
+	fsl_dcu_irq_reset(dev);
+	free_irq(fsl_dev->irq, dev);
+}
+
 static int fsl_dcu_load(struct drm_device *dev, unsigned long flags)
 {
 	struct fsl_dcu_drm_device *fsl_dev = dev->dev_private;
@@ -73,13 +111,13 @@ static int fsl_dcu_load(struct drm_device *dev, unsigned long flags)
 	ret = drm_vblank_init(dev, dev->mode_config.num_crtc);
 	if (ret < 0) {
 		dev_err(dev->dev, "failed to initialize vblank\n");
-		goto done;
+		goto done_vblank;
 	}
 
-	ret = drm_irq_install(dev, fsl_dev->irq);
+	ret = fsl_dcu_irq_install(dev, fsl_dev->irq);
 	if (ret < 0) {
 		dev_err(dev->dev, "failed to install IRQ handler\n");
-		goto done;
+		goto done_irq;
 	}
 
 	if (legacyfb_depth != 16 && legacyfb_depth != 24 &&
@@ -90,11 +128,11 @@ static int fsl_dcu_load(struct drm_device *dev, unsigned long flags)
 	}
 
 	return 0;
-done:
+done_irq:
 	drm_kms_helper_poll_fini(dev);
 
 	drm_mode_config_cleanup(dev);
-	drm_irq_uninstall(dev);
+done_vblank:
 	dev->dev_private = NULL;
 
 	return ret;
@@ -106,41 +144,17 @@ static void fsl_dcu_unload(struct drm_device *dev)
 	drm_kms_helper_poll_fini(dev);
 
 	drm_mode_config_cleanup(dev);
-	drm_irq_uninstall(dev);
+	fsl_dcu_irq_uninstall(dev);
 
 	dev->dev_private = NULL;
 }
 
-static irqreturn_t fsl_dcu_drm_irq(int irq, void *arg)
-{
-	struct drm_device *dev = arg;
-	struct fsl_dcu_drm_device *fsl_dev = dev->dev_private;
-	unsigned int int_status;
-	int ret;
-
-	ret = regmap_read(fsl_dev->regmap, DCU_INT_STATUS, &int_status);
-	if (ret) {
-		dev_err(dev->dev, "read DCU_INT_STATUS failed\n");
-		return IRQ_NONE;
-	}
-
-	if (int_status & DCU_INT_STATUS_VBLANK)
-		drm_handle_vblank(dev, 0);
-
-	regmap_write(fsl_dev->regmap, DCU_INT_STATUS, int_status);
-
-	return IRQ_HANDLED;
-}
-
 DEFINE_DRM_GEM_CMA_FOPS(fsl_dcu_drm_fops);
 
 static struct drm_driver fsl_dcu_drm_driver = {
 	.driver_features	= DRIVER_GEM | DRIVER_MODESET | DRIVER_ATOMIC,
 	.load			= fsl_dcu_load,
 	.unload			= fsl_dcu_unload,
-	.irq_handler		= fsl_dcu_drm_irq,
-	.irq_preinstall		= fsl_dcu_irq_uninstall,
-	.irq_uninstall		= fsl_dcu_irq_uninstall,
 	DRM_GEM_CMA_DRIVER_OPS,
 	.fops			= &fsl_dcu_drm_fops,
 	.name			= "fsl-dcu-drm",
-- 
2.43.0



