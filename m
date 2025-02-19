Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6833E1DF96C;
	Wed, 19 Feb 2025 09:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955972; cv=none; b=oKD9lCv1uVY7qvJ+3hhbs6ZsE54IbGLHG63TU0drFXfyTXIguIy21NtvxNR53ESu2ZrErQV1Q7s4kHh8lSGRQ091rsRp/E7+xZZzbkxGdnTTPJIA15SxmEXiPvJ5FDA0XhavNTwJMfyUoS2Z7OrtjxPoZIU1+i4R4Gc6/TFxSPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955972; c=relaxed/simple;
	bh=DvN2WS5Iy/Hnm7pcUdGjkbQ3BPn6STwfPoOqbognmVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uj02InjKdg1SQpySYi2Z+EYbSZnLBStIHysqDC/8em6Kq6Wh6pWa4PXP9V2uQpPbvXwtqo/RupWUBu8VeVt4fEHoWKHwPQBeRYztVBx0gDfb+ffzzJAVqyavbn1wzu46UNqYn4KJfr7oYN/1eSOJhBhYHR7KF2NgwDdUZPFtmd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pL79z9IG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pL79z9IG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1AEC4CEEC;
	Wed, 19 Feb 2025 09:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955971;
	bh=DvN2WS5Iy/Hnm7pcUdGjkbQ3BPn6STwfPoOqbognmVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pL79z9IGaCW05z6nvqscoRZo1tafCQ68OIJLWDIt6HUKzCmi3yFmyUn4SeoNmle8Z
	 MtGgiS8ggrzW2B74l+TQEZ1XAt3VryNC/Spa5PJtI5PW6NIFORUyPT7dfo0z2LNfOG
	 62kLHv46UB/LtDw6hYDDtrQokWQWF2PyMEzwwItU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/578] drm/rockchip: vop2: set bg dly and prescan dly at vop2_post_config
Date: Wed, 19 Feb 2025 09:20:26 +0100
Message-ID: <20250219082653.764032603@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f14a3f033953f..1068f391b3e64 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -1395,8 +1395,18 @@ static void vop2_post_config(struct drm_crtc *crtc)
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
@@ -1911,11 +1921,6 @@ static void vop2_setup_layer_mixer(struct vop2_video_port *vp)
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
@@ -1923,17 +1928,6 @@ static void vop2_setup_layer_mixer(struct vop2_video_port *vp)
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



