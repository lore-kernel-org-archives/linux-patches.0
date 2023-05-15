Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C13FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99510C433D2;
	Mon, 15 May 2023 16:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169797;
	bh=AqZb9YKK/NEGzllIEqzce+eeYg7B0Va1oAX5u4W0uH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ujf4qQ+MuVUvrfxqpsZK8e16VlX9CFP4gSMcvbf1CygjhcwXTo/+WBqNHiB8lo3ns
	 HRrQk74GY1fKkImNi7IHlgcXy4ICg939JJzDcOwhZ04qGx7tg7g3Vct0Q4xoT/ALC5
	 GsKadQYV2l/VebbbAmu3bcgTFKnijPWMH+XYuT2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Craig Tatlor <ctatlor97@gmail.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.3 173/246] drm/msm: fix vram leak on bind errors
Date: Mon, 15 May 2023 18:26:25 +0200
Message-Id: <20230515161727.822245822@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit 60d476af96015891c7959f30838ae7a9749932bf upstream.

Make sure to release the VRAM buffer also in a case a subcomponent fails
to bind.

Fixes: d863f0c7b536 ("drm/msm: Call msm_init_vram before binding the gpu")
Cc: stable@vger.kernel.org      # 5.11
Cc: Craig Tatlor <ctatlor97@gmail.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/525094/
Link: https://lore.kernel.org/r/20230306100722.28485-7-johan+linaro@kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_drv.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -51,6 +51,8 @@
 #define MSM_VERSION_MINOR	10
 #define MSM_VERSION_PATCHLEVEL	0
 
+static void msm_deinit_vram(struct drm_device *ddev);
+
 static const struct drm_mode_config_funcs mode_config_funcs = {
 	.fb_create = msm_framebuffer_create,
 	.output_poll_changed = drm_fb_helper_output_poll_changed,
@@ -260,12 +262,7 @@ static int msm_drm_uninit(struct device
 	if (kms && kms->funcs)
 		kms->funcs->destroy(kms);
 
-	if (priv->vram.paddr) {
-		unsigned long attrs = DMA_ATTR_NO_KERNEL_MAPPING;
-		drm_mm_takedown(&priv->vram.mm);
-		dma_free_attrs(dev, priv->vram.size, NULL,
-			       priv->vram.paddr, attrs);
-	}
+	msm_deinit_vram(ddev);
 
 	component_unbind_all(dev, ddev);
 
@@ -403,6 +400,19 @@ static int msm_init_vram(struct drm_devi
 	return ret;
 }
 
+static void msm_deinit_vram(struct drm_device *ddev)
+{
+	struct msm_drm_private *priv = ddev->dev_private;
+	unsigned long attrs = DMA_ATTR_NO_KERNEL_MAPPING;
+
+	if (!priv->vram.paddr)
+		return;
+
+	drm_mm_takedown(&priv->vram.mm);
+	dma_free_attrs(ddev->dev, priv->vram.size, NULL, priv->vram.paddr,
+			attrs);
+}
+
 static int msm_drm_init(struct device *dev, const struct drm_driver *drv)
 {
 	struct msm_drm_private *priv = dev_get_drvdata(dev);
@@ -449,7 +459,7 @@ static int msm_drm_init(struct device *d
 	/* Bind all our sub-components: */
 	ret = component_bind_all(dev, ddev);
 	if (ret)
-		goto err_put_dev;
+		goto err_deinit_vram;
 
 	dma_set_max_seg_size(dev, UINT_MAX);
 
@@ -547,6 +557,8 @@ err_msm_uninit:
 
 	return ret;
 
+err_deinit_vram:
+	msm_deinit_vram(ddev);
 err_put_dev:
 	drm_dev_put(ddev);
 


