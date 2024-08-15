Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927A219DF60;
	Thu, 15 Aug 2024 13:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729175; cv=none; b=TZPSWTCtdNzGWRdyYBg1+iYF8NYmiJcFCoH8JoUKlldyTeYS77P6EazDdqLqIa2G7Ds+qr/Gc4eGYJwx/C1KB19v+7DsnClADGFo52PHyUHELM6aANoTMBDCziWL5FAh/jaKO0aW+LxMXsqH5tGzygfBqqIxoPZACYOjbPjOG+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729175; c=relaxed/simple;
	bh=sJPhu1bp7K5g14E8uZ13EW78Pcj5a/cfc1lryM+QRh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2d6YtQ4HU34Cqjp/onLooS2DHOdLiUtfh+EghwRGNDaCCJ8iYctNBMgNL62WoKKmVzB7hGrea6V7IFVFj4CozrrpWhuW5oJPL7FxmuPRcyfD/kX8QhkhXVQ1MV4/lGGd6V3q8xZk1dvacG+pDyNXcm67kw1wfUnLXmIneEzI14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHZqSq6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHZqSq6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0181FC32786;
	Thu, 15 Aug 2024 13:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729175;
	bh=sJPhu1bp7K5g14E8uZ13EW78Pcj5a/cfc1lryM+QRh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHZqSq6yVUIVgiC2dWLbJuUHaOMAMGckdNSyH1p5lTxP7VqbucDGd3pk1VDC8/mJM
	 3qvVzi4FMVZFmToLtGepMl7tYpQg5Vuxx22+0fmmPLKJMTCL7kx5lrFDSc3aCCtlBI
	 kYxwYRRRxhdIl08L/LSL/1RKcr6lsojiPCefr1YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/484] drm/meson: fix canvas release in bind function
Date: Thu, 15 Aug 2024 15:17:53 +0200
Message-ID: <20240815131941.858589866@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

[ Upstream commit a695949b2e9bb6b6700a764c704731a306c4bebf ]

Allocated canvases may not be released on the error exit path of
meson_drv_bind_master(), leading to resource leaking. Rewrite exit path
to release canvases on error.

Fixes: 2bf6b5b0e374 ("drm/meson: exclusively use the canvas provider module")
Signed-off-by: Yao Zi <ziyao@disroot.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240703155826.10385-2-ziyao@disroot.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240703155826.10385-2-ziyao@disroot.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_drv.c | 37 +++++++++++++++----------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index 207b309a21c07..829aadc1258a1 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -248,29 +248,20 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 	if (ret)
 		goto free_drm;
 	ret = meson_canvas_alloc(priv->canvas, &priv->canvas_id_vd1_0);
-	if (ret) {
-		meson_canvas_free(priv->canvas, priv->canvas_id_osd1);
-		goto free_drm;
-	}
+	if (ret)
+		goto free_canvas_osd1;
 	ret = meson_canvas_alloc(priv->canvas, &priv->canvas_id_vd1_1);
-	if (ret) {
-		meson_canvas_free(priv->canvas, priv->canvas_id_osd1);
-		meson_canvas_free(priv->canvas, priv->canvas_id_vd1_0);
-		goto free_drm;
-	}
+	if (ret)
+		goto free_canvas_vd1_0;
 	ret = meson_canvas_alloc(priv->canvas, &priv->canvas_id_vd1_2);
-	if (ret) {
-		meson_canvas_free(priv->canvas, priv->canvas_id_osd1);
-		meson_canvas_free(priv->canvas, priv->canvas_id_vd1_0);
-		meson_canvas_free(priv->canvas, priv->canvas_id_vd1_1);
-		goto free_drm;
-	}
+	if (ret)
+		goto free_canvas_vd1_1;
 
 	priv->vsync_irq = platform_get_irq(pdev, 0);
 
 	ret = drm_vblank_init(drm, 1);
 	if (ret)
-		goto free_drm;
+		goto free_canvas_vd1_2;
 
 	/* Assign limits per soc revision/package */
 	for (i = 0 ; i < ARRAY_SIZE(meson_drm_soc_attrs) ; ++i) {
@@ -286,11 +277,11 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 	 */
 	ret = drm_aperture_remove_framebuffers(false, &meson_driver);
 	if (ret)
-		goto free_drm;
+		goto free_canvas_vd1_2;
 
 	ret = drmm_mode_config_init(drm);
 	if (ret)
-		goto free_drm;
+		goto free_canvas_vd1_2;
 	drm->mode_config.max_width = 3840;
 	drm->mode_config.max_height = 2160;
 	drm->mode_config.funcs = &meson_mode_config_funcs;
@@ -305,7 +296,7 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 	if (priv->afbcd.ops) {
 		ret = priv->afbcd.ops->init(priv);
 		if (ret)
-			goto free_drm;
+			goto free_canvas_vd1_2;
 	}
 
 	/* Encoder Initialization */
@@ -364,6 +355,14 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 exit_afbcd:
 	if (priv->afbcd.ops)
 		priv->afbcd.ops->exit(priv);
+free_canvas_vd1_2:
+	meson_canvas_free(priv->canvas, priv->canvas_id_vd1_2);
+free_canvas_vd1_1:
+	meson_canvas_free(priv->canvas, priv->canvas_id_vd1_1);
+free_canvas_vd1_0:
+	meson_canvas_free(priv->canvas, priv->canvas_id_vd1_0);
+free_canvas_osd1:
+	meson_canvas_free(priv->canvas, priv->canvas_id_osd1);
 free_drm:
 	drm_dev_put(drm);
 
-- 
2.43.0



