Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C3E1A2C20;
	Tue, 30 Jul 2024 15:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355058; cv=none; b=sSEPJpKPaFFaEVicaJ4dMAJJ1zSLVCJ6FvSeh5pdtdEYlkkKdARL5eVs81oUqy1qzNpI30Gvb2goyeo+/FHa+fkJB8pVoOEUbbpwH4AGACzZjJBo/oYp6eqB06QmnRt676Bqp0hXm/leu6xt0BdUZR0DapK8sQpk9S7aCkV4PJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355058; c=relaxed/simple;
	bh=3+DKqSuCRVxKuua71t/lO5RT9cSZ2P+IQPsKPB3fCog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuL9pAfcdfEBObD2a86wPfStrdDjK5IWKppu5YXKXChTb5pxvEt1AdAwfbjd33GUdnf0rpWROj0BDI9X7lcqt6M4hM0z16M2o3MCUF/dCktN6DxwKsRHUSnjxZjnBcWIWvylqB8gWcL14Xk9DxfPKcIJttNJ7464O7DjHHGfMlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2K+2r6kj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2K+2r6kj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DA7C4AF0C;
	Tue, 30 Jul 2024 15:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355057;
	bh=3+DKqSuCRVxKuua71t/lO5RT9cSZ2P+IQPsKPB3fCog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2K+2r6kj/27h/j7OaERL+V3kdJzDQba9/+72pBLk+pBthsk7Us5w/IkdBaOD5cUIh
	 qcmEKEemKmj98xJEjLMx8NgNHn77nll/gNaNdis/eqQGCuzJqPB/Tw59uPjXd5nM1F
	 9X6KiIJop3MwtOJBCqmdzmW4L8Mgzyvzsi+88Dsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/568] drm/meson: fix canvas release in bind function
Date: Tue, 30 Jul 2024 17:42:11 +0200
Message-ID: <20240730151640.778286173@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cb674966e9aca..095f634ff7c79 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -250,29 +250,20 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
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
@@ -288,11 +279,11 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 	 */
 	ret = drm_aperture_remove_framebuffers(&meson_driver);
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
@@ -307,7 +298,7 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 	if (priv->afbcd.ops) {
 		ret = priv->afbcd.ops->init(priv);
 		if (ret)
-			goto free_drm;
+			goto free_canvas_vd1_2;
 	}
 
 	/* Encoder Initialization */
@@ -371,6 +362,14 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
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



