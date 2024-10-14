Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AE41AB51B;
	Mon, 14 Oct 2024 15:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919852; cv=none; b=b9HaaIQvOaMmgV2Ii6ulFbjfwQ+rtk02uw3A7CUv9Rg0F1P+VvMJDknH4NVeN+RL0M7rTg2/U0eqUYye07gzoY/w6FerYtQzT4Mly79F5FPo7EFDfaOavWFm3JfUEYsWbchV44+0t1IQCa4Ds4UOej7MqpOOr1L9PwA9VJU7MoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919852; c=relaxed/simple;
	bh=x/Q+7xeAWPe0w0hwC40kaVKnNd1pMKar7HBSIjVzvTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgrECPL57L/BWcC6LBjv+wwJ4BSQWlo9NRt/T8m4OeNhW8eY8zNMkDDqgyudf0WoD5aaQ6aH7NBEBBv/J4jdWav1NsXl5bHVZG+1oiIxkO/QpbksjhQwNz98l0oOjE/oJWQrP4nGl6sN7iZkI5TnRlQGS8E2+snP/kmciZI6rsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGy3UGam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGy3UGam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA6AC4CEC3;
	Mon, 14 Oct 2024 15:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919852;
	bh=x/Q+7xeAWPe0w0hwC40kaVKnNd1pMKar7HBSIjVzvTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bGy3UGamiuKz12GkzTHmHCEFHv1vquDrgbpvYg2QhM15+bJE7UBa14lRupRTbSzqw
	 VDpLP9oLBb77Xtc//zC/tpSiCacJ5tM/SCGIjJWIFt2N81N5MRML5gjl5sjHqwqMVX
	 MO/ZFMjKV0EtEKZk/9SZqNaPKe1+nBx3BmMmbfRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 725/798] drm/rockchip: vop: limit maximum resolution to hardware capabilities
Date: Mon, 14 Oct 2024 16:21:19 +0200
Message-ID: <20241014141246.553077242@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 8e140cb60270ee8b5b41e80806323c668d8d4da9 ]

The different VOP variants support different maximum resolutions. Reject
resolutions that are not supported by a specific variant.

This hasn't been a problem in the upstream driver so far as 1920x1080
has been the maximum resolution supported by the HDMI driver and that
resolution is supported by all VOP variants. Now with higher resolutions
supported in the HDMI driver we have to limit the resolutions to the
ones supported by the VOP.

The actual maximum resolutions are taken from the Rockchip downstream
Kernel.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
[dropped the vdisplay > height check after talking to Sascha, as according to
 the vendor code "Actually vop hardware has no output height limit"
 (from vendor commit "drm/rockchip: vop: get rid of max_output.height check")
 and the height-check broke the px30-minievb display]

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230216102447.582905-2-s.hauer@pengutronix.de
Stable-dep-of: 6ed51ba95e27 ("drm/rockchip: vop: enable VOP_FEATURE_INTERNAL_RGB on RK3066")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c  | 12 ++++++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_vop.h  |  6 ++++++
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.h |  5 -----
 drivers/gpu/drm/rockchip/rockchip_vop_reg.c  | 18 ++++++++++++++++++
 4 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index 2a34d5b013430..b2289a523c408 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -1183,6 +1183,17 @@ static void vop_crtc_disable_vblank(struct drm_crtc *crtc)
 	spin_unlock_irqrestore(&vop->irq_lock, flags);
 }
 
+static enum drm_mode_status vop_crtc_mode_valid(struct drm_crtc *crtc,
+						const struct drm_display_mode *mode)
+{
+	struct vop *vop = to_vop(crtc);
+
+	if (vop->data->max_output.width && mode->hdisplay > vop->data->max_output.width)
+		return MODE_BAD_HVALUE;
+
+	return MODE_OK;
+}
+
 static bool vop_crtc_mode_fixup(struct drm_crtc *crtc,
 				const struct drm_display_mode *mode,
 				struct drm_display_mode *adjusted_mode)
@@ -1598,6 +1609,7 @@ static void vop_crtc_atomic_flush(struct drm_crtc *crtc,
 }
 
 static const struct drm_crtc_helper_funcs vop_crtc_helper_funcs = {
+	.mode_valid = vop_crtc_mode_valid,
 	.mode_fixup = vop_crtc_mode_fixup,
 	.atomic_check = vop_crtc_atomic_check,
 	.atomic_begin = vop_crtc_atomic_begin,
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.h b/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
index 96f9a6b419c2e..c5c716a69171a 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
@@ -42,6 +42,11 @@ enum vop_data_format {
 	VOP_FMT_YUV444SP,
 };
 
+struct vop_rect {
+	int width;
+	int height;
+};
+
 struct vop_reg {
 	uint32_t mask;
 	uint16_t offset;
@@ -226,6 +231,7 @@ struct vop_data {
 	const struct vop_win_data *win;
 	unsigned int win_size;
 	unsigned int lut_size;
+	struct vop_rect max_output;
 
 #define VOP_FEATURE_OUTPUT_RGB10	BIT(0)
 #define VOP_FEATURE_INTERNAL_RGB	BIT(1)
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.h b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.h
index c727093a06d68..f1234a151130f 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.h
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.h
@@ -27,11 +27,6 @@ enum win_dly_mode {
 	VOP2_DLY_MODE_MAX,
 };
 
-struct vop_rect {
-	int width;
-	int height;
-};
-
 enum vop2_scale_up_mode {
 	VOP2_SCALE_UP_NRST_NBOR,
 	VOP2_SCALE_UP_BIL,
diff --git a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
index a084097a33a60..b23c887ff4d45 100644
--- a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
+++ b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
@@ -181,6 +181,7 @@ static const struct vop_data rk3036_vop = {
 	.output = &rk3036_output,
 	.win = rk3036_vop_win_data,
 	.win_size = ARRAY_SIZE(rk3036_vop_win_data),
+	.max_output = { 1920, 1080 },
 };
 
 static const struct vop_win_phy rk3126_win1_data = {
@@ -213,6 +214,7 @@ static const struct vop_data rk3126_vop = {
 	.output = &rk3036_output,
 	.win = rk3126_vop_win_data,
 	.win_size = ARRAY_SIZE(rk3126_vop_win_data),
+	.max_output = { 1920, 1080 },
 };
 
 static const int px30_vop_intrs[] = {
@@ -340,6 +342,7 @@ static const struct vop_data px30_vop_big = {
 	.output = &px30_output,
 	.win = px30_vop_big_win_data,
 	.win_size = ARRAY_SIZE(px30_vop_big_win_data),
+	.max_output = { 1920, 1080 },
 };
 
 static const struct vop_win_data px30_vop_lit_win_data[] = {
@@ -356,6 +359,7 @@ static const struct vop_data px30_vop_lit = {
 	.output = &px30_output,
 	.win = px30_vop_lit_win_data,
 	.win_size = ARRAY_SIZE(px30_vop_lit_win_data),
+	.max_output = { 1920, 1080 },
 };
 
 static const struct vop_scl_regs rk3066_win_scl = {
@@ -480,6 +484,7 @@ static const struct vop_data rk3066_vop = {
 	.output = &rk3066_output,
 	.win = rk3066_vop_win_data,
 	.win_size = ARRAY_SIZE(rk3066_vop_win_data),
+	.max_output = { 1920, 1080 },
 };
 
 static const struct vop_scl_regs rk3188_win_scl = {
@@ -586,6 +591,7 @@ static const struct vop_data rk3188_vop = {
 	.win = rk3188_vop_win_data,
 	.win_size = ARRAY_SIZE(rk3188_vop_win_data),
 	.feature = VOP_FEATURE_INTERNAL_RGB,
+	.max_output = { 2048, 1536 },
 };
 
 static const struct vop_scl_extension rk3288_win_full_scl_ext = {
@@ -733,6 +739,12 @@ static const struct vop_data rk3288_vop = {
 	.win = rk3288_vop_win_data,
 	.win_size = ARRAY_SIZE(rk3288_vop_win_data),
 	.lut_size = 1024,
+	/*
+	 * This is the maximum resolution for the VOPB, the VOPL can only do
+	 * 2560x1600, but we can't distinguish them as they have the same
+	 * compatible.
+	 */
+	.max_output = { 3840, 2160 },
 };
 
 static const int rk3368_vop_intrs[] = {
@@ -834,6 +846,7 @@ static const struct vop_data rk3368_vop = {
 	.misc = &rk3368_misc,
 	.win = rk3368_vop_win_data,
 	.win_size = ARRAY_SIZE(rk3368_vop_win_data),
+	.max_output = { 4096, 2160 },
 };
 
 static const struct vop_intr rk3366_vop_intr = {
@@ -855,6 +868,7 @@ static const struct vop_data rk3366_vop = {
 	.misc = &rk3368_misc,
 	.win = rk3368_vop_win_data,
 	.win_size = ARRAY_SIZE(rk3368_vop_win_data),
+	.max_output = { 4096, 2160 },
 };
 
 static const struct vop_output rk3399_output = {
@@ -985,6 +999,7 @@ static const struct vop_data rk3399_vop_big = {
 	.win_size = ARRAY_SIZE(rk3399_vop_win_data),
 	.win_yuv2yuv = rk3399_vop_big_win_yuv2yuv_data,
 	.lut_size = 1024,
+	.max_output = { 4096, 2160 },
 };
 
 static const struct vop_win_data rk3399_vop_lit_win_data[] = {
@@ -1011,6 +1026,7 @@ static const struct vop_data rk3399_vop_lit = {
 	.win_size = ARRAY_SIZE(rk3399_vop_lit_win_data),
 	.win_yuv2yuv = rk3399_vop_lit_win_yuv2yuv_data,
 	.lut_size = 256,
+	.max_output = { 2560, 1600 },
 };
 
 static const struct vop_win_data rk3228_vop_win_data[] = {
@@ -1030,6 +1046,7 @@ static const struct vop_data rk3228_vop = {
 	.misc = &rk3368_misc,
 	.win = rk3228_vop_win_data,
 	.win_size = ARRAY_SIZE(rk3228_vop_win_data),
+	.max_output = { 4096, 2160 },
 };
 
 static const struct vop_modeset rk3328_modeset = {
@@ -1101,6 +1118,7 @@ static const struct vop_data rk3328_vop = {
 	.misc = &rk3328_misc,
 	.win = rk3328_vop_win_data,
 	.win_size = ARRAY_SIZE(rk3328_vop_win_data),
+	.max_output = { 4096, 2160 },
 };
 
 static const struct of_device_id vop_driver_dt_match[] = {
-- 
2.43.0



