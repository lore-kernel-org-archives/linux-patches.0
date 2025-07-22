Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD032C9A;
	Tue, 22 Jul 2025 14:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193115; cv=none; b=CywmXcfhQrn8VknOVWkJ1mvt0jr/aAdHvZC4pmasAYCRDdXaj56L6Qef5vIGvUUUSdnkcfmqhXOJceEyjrdXdEaozRuMPFNPfWRXet2ZOsjO8ccp1zopVXUKGhYMIG98EZXGpG632ULcyhvWU1FBR0iVn9+eFXbzoIsr8nSv17M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193115; c=relaxed/simple;
	bh=rQ4thLQjdHWlgERSxutsRKK6mEMGEi5jgGFyS2lfsIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWF7jDvjHZaESV4CT4hNVd3CtvXR+pwBC7DYgeedzjhEhiM+koH4btCxkavaK3Q2vuRGmQvvXdq0R+mM175HQyUf3r2MU5lq2sg9toDM6tEqll5wWjNasbVW4Dx3RSYJUfdibaeMPyHEbyJdYm2ZwkxGyrW6osK/TvT4bXKEN9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNQ5WrMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNQ5WrMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD75C4CEEB;
	Tue, 22 Jul 2025 14:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193115;
	bh=rQ4thLQjdHWlgERSxutsRKK6mEMGEi5jgGFyS2lfsIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNQ5WrMxDIDnMpKiBpy14etxYQS+VLJMm1xQ0tqFm0tZ3TMiRdUClurO7CP/0lj5K
	 wb442qC1QADAXunGiygvuareWcT1nM8WZCzysAyYnzp8RiRRBkSfwu1NZXb7H/k2US
	 +HkdF1cDyZd7R/iFBHODrYNz8J2CxnqJt8j1rUf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	CK Hu <ck.hu@medaitek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/158] drm/mediatek: only announce AFBC if really supported
Date: Tue, 22 Jul 2025 15:45:21 +0200
Message-ID: <20250722134345.835254001@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Icenowy Zheng <uwu@icenowy.me>

[ Upstream commit 8d121a82fa564e0c8bd86ce4ec56b2a43b9b016e ]

Currently even the SoC's OVL does not declare the support of AFBC, AFBC
is still announced to the userspace within the IN_FORMATS blob, which
breaks modern Wayland compositors like KWin Wayland and others.

Gate passing modifiers to drm_universal_plane_init() behind querying the
driver of the hardware block for AFBC support.

Fixes: c410fa9b07c3 ("drm/mediatek: Add AFBC support to Mediatek DRM driver")
Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Reviewed-by: CK Hu <ck.hu@medaitek.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20250531121140.387661-1-uwu@icenowy.me/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_crtc.c     | 3 ++-
 drivers/gpu/drm/mediatek/mtk_ddp_comp.c | 1 +
 drivers/gpu/drm/mediatek/mtk_ddp_comp.h | 9 +++++++++
 drivers/gpu/drm/mediatek/mtk_disp_drv.h | 1 +
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c | 7 +++++++
 drivers/gpu/drm/mediatek/mtk_plane.c    | 7 +++++--
 drivers/gpu/drm/mediatek/mtk_plane.h    | 3 ++-
 7 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_crtc.c b/drivers/gpu/drm/mediatek/mtk_crtc.c
index 6916c8925b412..bc7527542fdc6 100644
--- a/drivers/gpu/drm/mediatek/mtk_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_crtc.c
@@ -963,7 +963,8 @@ static int mtk_crtc_init_comp_planes(struct drm_device *drm_dev,
 				mtk_ddp_comp_supported_rotations(comp),
 				mtk_ddp_comp_get_blend_modes(comp),
 				mtk_ddp_comp_get_formats(comp),
-				mtk_ddp_comp_get_num_formats(comp), i);
+				mtk_ddp_comp_get_num_formats(comp),
+				mtk_ddp_comp_is_afbc_supported(comp), i);
 		if (ret)
 			return ret;
 
diff --git a/drivers/gpu/drm/mediatek/mtk_ddp_comp.c b/drivers/gpu/drm/mediatek/mtk_ddp_comp.c
index edc6417639e64..ac6620e10262e 100644
--- a/drivers/gpu/drm/mediatek/mtk_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_ddp_comp.c
@@ -366,6 +366,7 @@ static const struct mtk_ddp_comp_funcs ddp_ovl = {
 	.get_blend_modes = mtk_ovl_get_blend_modes,
 	.get_formats = mtk_ovl_get_formats,
 	.get_num_formats = mtk_ovl_get_num_formats,
+	.is_afbc_supported = mtk_ovl_is_afbc_supported,
 };
 
 static const struct mtk_ddp_comp_funcs ddp_postmask = {
diff --git a/drivers/gpu/drm/mediatek/mtk_ddp_comp.h b/drivers/gpu/drm/mediatek/mtk_ddp_comp.h
index 39720b27f4e9e..7289b3dcf22f2 100644
--- a/drivers/gpu/drm/mediatek/mtk_ddp_comp.h
+++ b/drivers/gpu/drm/mediatek/mtk_ddp_comp.h
@@ -83,6 +83,7 @@ struct mtk_ddp_comp_funcs {
 	u32 (*get_blend_modes)(struct device *dev);
 	const u32 *(*get_formats)(struct device *dev);
 	size_t (*get_num_formats)(struct device *dev);
+	bool (*is_afbc_supported)(struct device *dev);
 	void (*connect)(struct device *dev, struct device *mmsys_dev, unsigned int next);
 	void (*disconnect)(struct device *dev, struct device *mmsys_dev, unsigned int next);
 	void (*add)(struct device *dev, struct mtk_mutex *mutex);
@@ -294,6 +295,14 @@ size_t mtk_ddp_comp_get_num_formats(struct mtk_ddp_comp *comp)
 	return 0;
 }
 
+static inline bool mtk_ddp_comp_is_afbc_supported(struct mtk_ddp_comp *comp)
+{
+	if (comp->funcs && comp->funcs->is_afbc_supported)
+		return comp->funcs->is_afbc_supported(comp->dev);
+
+	return false;
+}
+
 static inline bool mtk_ddp_comp_add(struct mtk_ddp_comp *comp, struct mtk_mutex *mutex)
 {
 	if (comp->funcs && comp->funcs->add) {
diff --git a/drivers/gpu/drm/mediatek/mtk_disp_drv.h b/drivers/gpu/drm/mediatek/mtk_disp_drv.h
index 04154db9085c0..c0f7f77e05746 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_drv.h
+++ b/drivers/gpu/drm/mediatek/mtk_disp_drv.h
@@ -106,6 +106,7 @@ void mtk_ovl_disable_vblank(struct device *dev);
 u32 mtk_ovl_get_blend_modes(struct device *dev);
 const u32 *mtk_ovl_get_formats(struct device *dev);
 size_t mtk_ovl_get_num_formats(struct device *dev);
+bool mtk_ovl_is_afbc_supported(struct device *dev);
 
 void mtk_ovl_adaptor_add_comp(struct device *dev, struct mtk_mutex *mutex);
 void mtk_ovl_adaptor_remove_comp(struct device *dev, struct mtk_mutex *mutex);
diff --git a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
index 19b0d50839819..ca4a9a60b8904 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
@@ -236,6 +236,13 @@ size_t mtk_ovl_get_num_formats(struct device *dev)
 	return ovl->data->num_formats;
 }
 
+bool mtk_ovl_is_afbc_supported(struct device *dev)
+{
+	struct mtk_disp_ovl *ovl = dev_get_drvdata(dev);
+
+	return ovl->data->supports_afbc;
+}
+
 int mtk_ovl_clk_enable(struct device *dev)
 {
 	struct mtk_disp_ovl *ovl = dev_get_drvdata(dev);
diff --git a/drivers/gpu/drm/mediatek/mtk_plane.c b/drivers/gpu/drm/mediatek/mtk_plane.c
index 1a855a75367a1..74c2704efb664 100644
--- a/drivers/gpu/drm/mediatek/mtk_plane.c
+++ b/drivers/gpu/drm/mediatek/mtk_plane.c
@@ -326,7 +326,8 @@ static const struct drm_plane_helper_funcs mtk_plane_helper_funcs = {
 int mtk_plane_init(struct drm_device *dev, struct drm_plane *plane,
 		   unsigned long possible_crtcs, enum drm_plane_type type,
 		   unsigned int supported_rotations, const u32 blend_modes,
-		   const u32 *formats, size_t num_formats, unsigned int plane_idx)
+		   const u32 *formats, size_t num_formats,
+		   bool supports_afbc, unsigned int plane_idx)
 {
 	int err;
 
@@ -337,7 +338,9 @@ int mtk_plane_init(struct drm_device *dev, struct drm_plane *plane,
 
 	err = drm_universal_plane_init(dev, plane, possible_crtcs,
 				       &mtk_plane_funcs, formats,
-				       num_formats, modifiers, type, NULL);
+				       num_formats,
+				       supports_afbc ? modifiers : NULL,
+				       type, NULL);
 	if (err) {
 		DRM_ERROR("failed to initialize plane\n");
 		return err;
diff --git a/drivers/gpu/drm/mediatek/mtk_plane.h b/drivers/gpu/drm/mediatek/mtk_plane.h
index 3b13b89989c7e..95c5fa5295d8a 100644
--- a/drivers/gpu/drm/mediatek/mtk_plane.h
+++ b/drivers/gpu/drm/mediatek/mtk_plane.h
@@ -49,5 +49,6 @@ to_mtk_plane_state(struct drm_plane_state *state)
 int mtk_plane_init(struct drm_device *dev, struct drm_plane *plane,
 		   unsigned long possible_crtcs, enum drm_plane_type type,
 		   unsigned int supported_rotations, const u32 blend_modes,
-		   const u32 *formats, size_t num_formats, unsigned int plane_idx);
+		   const u32 *formats, size_t num_formats,
+		   bool supports_afbc, unsigned int plane_idx);
 #endif
-- 
2.39.5



