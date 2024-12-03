Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C711F4738;
	Tue,  3 Dec 2024 14:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236531; cv=none; b=boqIzsKSEJ/ovxlTWUHzCEXerwef7NkmnO0Pht+/Z9C76ycDrpQRq+j/adKLBrPfCjaVx6MFxLIjhnJlwJb9n9jFkir2y/t21Ho2tuzbIHkrfJ9QDW748UHjyem4Vuek+7U+xtPMDdMAeawSZVJGZ21gWw8b5iewAiP7Yxetnx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236531; c=relaxed/simple;
	bh=SmovDKHMlC+uKQPHfkGyWXn4LDQfvv57hh6kmIDufFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dH43gjw85eshIQl/AbQrnoQITQ0o8gMoZKChQYOqbFXV0IxRmJmUla28LCL79RG1OYkzGUhbG2ELyX0yf7xDL6Jvj9QeczC41y4MJStrWSFrjjGrYk1gx0T85/hZiidU7tPm9Lu4ocOC5wy/FxrZl1C+CYDxOolI51kmbP2VdS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=akw8DpHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="akw8DpHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E320C4CECF;
	Tue,  3 Dec 2024 14:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236530;
	bh=SmovDKHMlC+uKQPHfkGyWXn4LDQfvv57hh6kmIDufFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=akw8DpHB0rIqyH5j03CyTlOK4dyW/1YpyJFPsyQ5h9xaNCPLNldTe+Ygoi0rlx8q/
	 zQlfw6KobjCgwqLnSR4OqK/GX1H7MSkyPsdVNCrFiA8jcq4rtl3GbuT72VXbhA7IfD
	 ECA0qkB8F+GVtRsafgsM11Uw4uUQtfVcCbQjgjCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 047/138] drm/fsl-dcu: Convert to Linux IRQ interfaces
Date: Tue,  3 Dec 2024 15:31:16 +0100
Message-ID: <20241203141925.359456199@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c | 77 ++++++++++++++---------
 1 file changed, 46 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
index c087ebc0ad4ed..7cc449e206435 100644
--- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
+++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
@@ -53,7 +53,7 @@ static const struct regmap_config fsl_dcu_regmap_config = {
 	.volatile_reg = fsl_dcu_drm_is_volatile_reg,
 };
 
-static void fsl_dcu_irq_uninstall(struct drm_device *dev)
+static void fsl_dcu_irq_reset(struct drm_device *dev)
 {
 	struct fsl_dcu_drm_device *fsl_dev = dev->dev_private;
 
@@ -61,6 +61,45 @@ static void fsl_dcu_irq_uninstall(struct drm_device *dev)
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
@@ -75,13 +114,13 @@ static int fsl_dcu_load(struct drm_device *dev, unsigned long flags)
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
@@ -92,11 +131,11 @@ static int fsl_dcu_load(struct drm_device *dev, unsigned long flags)
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
@@ -108,32 +147,11 @@ static void fsl_dcu_unload(struct drm_device *dev)
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
@@ -141,9 +159,6 @@ static struct drm_driver fsl_dcu_drm_driver = {
 				| DRIVER_PRIME | DRIVER_ATOMIC,
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



