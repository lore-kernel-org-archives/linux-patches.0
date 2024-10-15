Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505B01B21AC;
	Tue, 15 Oct 2024 13:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998267; cv=none; b=e3O9AUDPpJmvSA2WLJdUJQIgQmYAeeNWfW74QrSKvAhI8QgjC0H+bwCOQcDSOYhEwaiVCUEUE+U+5SoWdSUhfLo4PzBKJD52nXFL6h+js8PlRniV9W2m/xS+H03FtR4AfMzlmCZ9puHPwqdUnZk6vHi7FSjrGgRgfb+x8/nsv8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998267; c=relaxed/simple;
	bh=OVZHBeQodTa5dyEFOeZ5SsvJg7/nH4l0X/QU2+tv9wY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CBf5lVHkMmklYsujyDyds3/3Czqy4D+CMwJg0yWaUV7ZImXiApoE31CFP3gHQ2uAt2rYhInujhJQjxvvyb2vOuZG5Aaxz3ssy4QE8WY4GOKmFVO04zM2PuJ4779UzYjSZdj2LFyJRkUvzmH0w6xMCvHJnLuV7ljAis37kS/qMlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrBt3qvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrBt3qvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB3FC4CEC6;
	Tue, 15 Oct 2024 13:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998267;
	bh=OVZHBeQodTa5dyEFOeZ5SsvJg7/nH4l0X/QU2+tv9wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wrBt3qvTsnelvmgmCnPmh8Oeb8qBhbG4P9PRWJa7+t5HK/ElTEuWOd8zswm+BbWeo
	 jUA3De9KfgHe4c+7ySAR7jo5jZ1CmOvMLqC/eJfhMgVSlf3cjUUQ03vg12+PeV4M+S
	 o8n4YCGh5n0iIVmDjGJLTE86vDxsT0x8urC3GoGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Cole-Baker <sigmaris@gmail.com>,
	"=?UTF-8?q?Milan=20P . =20Stani=C4=87?=" <mps@arvanta.net>,
	Linus Heckemann <git@sphalerite.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 427/518] drm/rockchip: support gamma control on RK3399
Date: Tue, 15 Oct 2024 14:45:31 +0200
Message-ID: <20241015123933.474119008@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Cole-Baker <sigmaris@gmail.com>

[ Upstream commit 7ae7a6211fe7251543796d5af971acb8c9e2da9e ]

The RK3399 has a 1024-entry gamma LUT with 10 bits per component on its
"big" VOP and a 256-entry, 8 bit per component LUT on the "little" VOP.
Compared to the RK3288, it no longer requires disabling gamma while
updating the LUT. On the RK3399, the LUT can be updated at any time as
the hardware has two LUT buffers, one can be written while the other is
in use. A swap of the buffers is triggered by writing 1 to the
update_gamma_lut register.

Signed-off-by: Hugh Cole-Baker <sigmaris@gmail.com>
Tested-by: "Milan P. Stanić" <mps@arvanta.net>
Tested-by: Linus Heckemann <git@sphalerite.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20211019215843.42718-3-sigmaris@gmail.com
Stable-dep-of: 6b44aa559d6c ("drm/rockchip: vop: clear DMA stop bit on RK3066")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c | 105 +++++++++++++-------
 1 file changed, 71 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index d4a3170d1678c..18ee781ddb79e 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -9,6 +9,7 @@
 #include <linux/delay.h>
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
+#include <linux/log2.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -65,6 +66,9 @@
 #define VOP_REG_SET(vop, group, name, v) \
 		    vop_reg_set(vop, &vop->data->group->name, 0, ~0, v, #name)
 
+#define VOP_HAS_REG(vop, group, name) \
+		(!!(vop->data->group->name.mask))
+
 #define VOP_INTR_SET_TYPE(vop, name, type, v) \
 	do { \
 		int i, reg = 0, mask = 0; \
@@ -1200,17 +1204,22 @@ static bool vop_dsp_lut_is_enabled(struct vop *vop)
 	return vop_read_reg(vop, 0, &vop->data->common->dsp_lut_en);
 }
 
+static u32 vop_lut_buffer_index(struct vop *vop)
+{
+	return vop_read_reg(vop, 0, &vop->data->common->lut_buffer_index);
+}
+
 static void vop_crtc_write_gamma_lut(struct vop *vop, struct drm_crtc *crtc)
 {
 	struct drm_color_lut *lut = crtc->state->gamma_lut->data;
-	unsigned int i;
+	unsigned int i, bpc = ilog2(vop->data->lut_size);
 
 	for (i = 0; i < crtc->gamma_size; i++) {
 		u32 word;
 
-		word = (drm_color_lut_extract(lut[i].red, 10) << 20) |
-		       (drm_color_lut_extract(lut[i].green, 10) << 10) |
-			drm_color_lut_extract(lut[i].blue, 10);
+		word = (drm_color_lut_extract(lut[i].red, bpc) << (2 * bpc)) |
+		       (drm_color_lut_extract(lut[i].green, bpc) << bpc) |
+			drm_color_lut_extract(lut[i].blue, bpc);
 		writel(word, vop->lut_regs + i * 4);
 	}
 }
@@ -1220,38 +1229,66 @@ static void vop_crtc_gamma_set(struct vop *vop, struct drm_crtc *crtc,
 {
 	struct drm_crtc_state *state = crtc->state;
 	unsigned int idle;
+	u32 lut_idx, old_idx;
 	int ret;
 
 	if (!vop->lut_regs)
 		return;
-	/*
-	 * To disable gamma (gamma_lut is null) or to write
-	 * an update to the LUT, clear dsp_lut_en.
-	 */
-	spin_lock(&vop->reg_lock);
-	VOP_REG_SET(vop, common, dsp_lut_en, 0);
-	vop_cfg_done(vop);
-	spin_unlock(&vop->reg_lock);
 
-	/*
-	 * In order to write the LUT to the internal memory,
-	 * we need to first make sure the dsp_lut_en bit is cleared.
-	 */
-	ret = readx_poll_timeout(vop_dsp_lut_is_enabled, vop,
-				 idle, !idle, 5, 30 * 1000);
-	if (ret) {
-		DRM_DEV_ERROR(vop->dev, "display LUT RAM enable timeout!\n");
-		return;
-	}
+	if (!state->gamma_lut || !VOP_HAS_REG(vop, common, update_gamma_lut)) {
+		/*
+		 * To disable gamma (gamma_lut is null) or to write
+		 * an update to the LUT, clear dsp_lut_en.
+		 */
+		spin_lock(&vop->reg_lock);
+		VOP_REG_SET(vop, common, dsp_lut_en, 0);
+		vop_cfg_done(vop);
+		spin_unlock(&vop->reg_lock);
 
-	if (!state->gamma_lut)
-		return;
+		/*
+		 * In order to write the LUT to the internal memory,
+		 * we need to first make sure the dsp_lut_en bit is cleared.
+		 */
+		ret = readx_poll_timeout(vop_dsp_lut_is_enabled, vop,
+					 idle, !idle, 5, 30 * 1000);
+		if (ret) {
+			DRM_DEV_ERROR(vop->dev, "display LUT RAM enable timeout!\n");
+			return;
+		}
+
+		if (!state->gamma_lut)
+			return;
+	} else {
+		/*
+		 * On RK3399 the gamma LUT can updated without clearing dsp_lut_en,
+		 * by setting update_gamma_lut then waiting for lut_buffer_index change
+		 */
+		old_idx = vop_lut_buffer_index(vop);
+	}
 
 	spin_lock(&vop->reg_lock);
 	vop_crtc_write_gamma_lut(vop, crtc);
 	VOP_REG_SET(vop, common, dsp_lut_en, 1);
+	VOP_REG_SET(vop, common, update_gamma_lut, 1);
 	vop_cfg_done(vop);
 	spin_unlock(&vop->reg_lock);
+
+	if (VOP_HAS_REG(vop, common, update_gamma_lut)) {
+		ret = readx_poll_timeout(vop_lut_buffer_index, vop,
+					 lut_idx, lut_idx != old_idx, 5, 30 * 1000);
+		if (ret) {
+			DRM_DEV_ERROR(vop->dev, "gamma LUT update timeout!\n");
+			return;
+		}
+
+		/*
+		 * update_gamma_lut is auto cleared by HW, but write 0 to clear the bit
+		 * in our backup of the regs.
+		 */
+		spin_lock(&vop->reg_lock);
+		VOP_REG_SET(vop, common, update_gamma_lut, 0);
+		spin_unlock(&vop->reg_lock);
+	}
 }
 
 static void vop_crtc_atomic_begin(struct drm_crtc *crtc,
@@ -1295,14 +1332,6 @@ static void vop_crtc_atomic_enable(struct drm_crtc *crtc,
 		return;
 	}
 
-	/*
-	 * If we have a GAMMA LUT in the state, then let's make sure
-	 * it's updated. We might be coming out of suspend,
-	 * which means the LUT internal memory needs to be re-written.
-	 */
-	if (crtc->state->gamma_lut)
-		vop_crtc_gamma_set(vop, crtc, old_state);
-
 	mutex_lock(&vop->vop_lock);
 
 	WARN_ON(vop->event);
@@ -1393,6 +1422,14 @@ static void vop_crtc_atomic_enable(struct drm_crtc *crtc,
 
 	VOP_REG_SET(vop, common, standby, 0);
 	mutex_unlock(&vop->vop_lock);
+
+	/*
+	 * If we have a GAMMA LUT in the state, then let's make sure
+	 * it's updated. We might be coming out of suspend,
+	 * which means the LUT internal memory needs to be re-written.
+	 */
+	if (crtc->state->gamma_lut)
+		vop_crtc_gamma_set(vop, crtc, old_state);
 }
 
 static bool vop_fs_irq_is_pending(struct vop *vop)
@@ -2119,8 +2156,8 @@ static int vop_bind(struct device *dev, struct device *master, void *data)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (res) {
-		if (!vop_data->lut_size) {
-			DRM_DEV_ERROR(dev, "no gamma LUT size defined\n");
+		if (vop_data->lut_size != 1024 && vop_data->lut_size != 256) {
+			DRM_DEV_ERROR(dev, "unsupported gamma LUT size %d\n", vop_data->lut_size);
 			return -EINVAL;
 		}
 		vop->lut_regs = devm_ioremap_resource(dev, res);
-- 
2.43.0



