Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A523514F136;
	Wed,  5 Feb 2025 13:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763416; cv=none; b=iaAeeOI/nF5nVmBYudEKPlS7Sl1Cz8bgYWqtDvqF06CBMA5Y3XZgrnHFbrS+Nk02h2i2FtnBa/UZnASrlnJ/Dkd9BQ4qNDkj1wGYemIql8gxE8WMfn8aiiPioxTAb8OtA9P7/v5uv1GOaYI9Xjrrnfa7OaGGdiijlJjznYPTC0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763416; c=relaxed/simple;
	bh=SUDjy7bID0l3kfwnKxQ57/Un+L7Ery41Ln+ca9ZBy00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEqgqLzQqinONHSluZGtxyfwujVCj2IakKqGZ6mz15rokFT7DTuw/Vwozk26Ty2a0jh1nBWx8+ZNFXpSx8XSf/YtwpqAAnzHQkL4l8C9fHzXFWarCboe199RF5uq+JQYq7hHxRig6LB2+vpYDxaFzUl1KxIe2b9fRN1In+iPVhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7kD7ELA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7kD7ELA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B261C4CED6;
	Wed,  5 Feb 2025 13:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763416;
	bh=SUDjy7bID0l3kfwnKxQ57/Un+L7Ery41Ln+ca9ZBy00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7kD7ELASWN8EvLzdUaiQ2qrB8xbsOhsBHBeAQBuhXp+OGwV3TadPdnhbFTAuSb0o
	 W9X2QTBKBfMyz/TLjWn0xzZcLJMWRpTJZb+B8goWBUBpWIhKto9bCieMlBkqHxufqA
	 Rz6m6vwrsgpwJJaqx6dsnjb5Vp8rdddmL/P1JWxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/393] drm/rockchip: vop2: set bg dly and prescan dly at vop2_post_config
Date: Wed,  5 Feb 2025 14:39:09 +0100
Message-ID: <20250205134421.456976108@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit 075a5b3969becb1ebc2f1d4fa1a1fe9163679273 ]

We need to setup background delay cycle and prescan
delay cycle when a mode is enable to avoid trigger
POST_BUF_EMPTY irq on rk3588.

Note: RK356x has no such requirement.

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20231211115815.1785131-1-andyshrk@163.com
Stable-dep-of: 0ca953ac226e ("drm/rockchip: vop2: Fix the windows switch between different layers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 26 ++++++++------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 2504e2f762358..1295aaffe868a 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -1397,8 +1397,18 @@ static void vop2_post_config(struct drm_crtc *crtc)
 	u32 top_margin = 100, bottom_margin = 100;
 	u16 hsize = hdisplay * (left_margin + right_margin) / 200;
 	u16 vsize = vdisplay * (top_margin + bottom_margin) / 200;
+	u16 hsync_len = mode->crtc_hsync_end - mode->crtc_hsync_start;
 	u16 hact_end, vact_end;
 	u32 val;
+	u32 bg_dly;
+	u32 pre_scan_dly;
+
+	bg_dly = vp->data->pre_scan_max_dly[3];
+	vop2_writel(vp->vop2, RK3568_VP_BG_MIX_CTRL(vp->id),
+		    FIELD_PREP(RK3568_VP_BG_MIX_CTRL__BG_DLY, bg_dly));
+
+	pre_scan_dly = ((bg_dly + (hdisplay >> 1) - 1) << 16) | hsync_len;
+	vop2_vp_write(vp, RK3568_VP_PRE_SCAN_HTIMING, pre_scan_dly);
 
 	vsize = rounddown(vsize, 2);
 	hsize = rounddown(hsize, 2);
@@ -1915,11 +1925,6 @@ static void vop2_setup_layer_mixer(struct vop2_video_port *vp)
 	u32 layer_sel = 0;
 	u32 port_sel;
 	unsigned int nlayer, ofs;
-	struct drm_display_mode *adjusted_mode;
-	u16 hsync_len;
-	u16 hdisplay;
-	u32 bg_dly;
-	u32 pre_scan_dly;
 	u32 ovl_ctrl;
 	int i;
 	struct vop2_video_port *vp0 = &vop2->vps[0];
@@ -1927,17 +1932,6 @@ static void vop2_setup_layer_mixer(struct vop2_video_port *vp)
 	struct vop2_video_port *vp2 = &vop2->vps[2];
 	struct rockchip_crtc_state *vcstate = to_rockchip_crtc_state(vp->crtc.state);
 
-	adjusted_mode = &vp->crtc.state->adjusted_mode;
-	hsync_len = adjusted_mode->crtc_hsync_end - adjusted_mode->crtc_hsync_start;
-	hdisplay = adjusted_mode->crtc_hdisplay;
-
-	bg_dly = vp->data->pre_scan_max_dly[3];
-	vop2_writel(vop2, RK3568_VP_BG_MIX_CTRL(vp->id),
-		    FIELD_PREP(RK3568_VP_BG_MIX_CTRL__BG_DLY, bg_dly));
-
-	pre_scan_dly = ((bg_dly + (hdisplay >> 1) - 1) << 16) | hsync_len;
-	vop2_vp_write(vp, RK3568_VP_PRE_SCAN_HTIMING, pre_scan_dly);
-
 	ovl_ctrl = vop2_readl(vop2, RK3568_OVL_CTRL);
 	ovl_ctrl |= RK3568_OVL_CTRL__LAYERSEL_REGDONE_IMD;
 	if (vcstate->yuv_overlay)
-- 
2.39.5



