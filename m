Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47ECE34FF69;
	Wed, 21 Jan 2026 18:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019978; cv=none; b=KUQOaO3XiySnkcpc1Lm68hN1TXarGFftobHU5CNtW25YCXo48IoiftlEwc48Rt66U5dVzyTrrSspEKicUHty9exJOHSiIrs3nZDThpC+XyFZAM0US/6JGpDUgzKbQjzoMEvu2EBXi/FTZJWw+f5fSSwjYfV2mQHWcsP8+lV0ODQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019978; c=relaxed/simple;
	bh=sVl2ljIYvSu0uoeaz+mBP9JnXgVL5ziQK9X8l9YhWNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBFK5LZdTqSqzBwGMvQBBN8I7Pz8NjjF7+ZQWSWh4yArJaubHIB/8aw8FGLtGLuCkfSuhBMGE1ut4RKlTwnJP5S7ZqQTiRedxSkZ+h2DoRloQpdlkFAOK2pLPhA4D5nNk90DyPGzIOyLCdZ/TviZJPKmc5DMeveLaZMVxxR2bJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2E/zcKKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2E/zcKKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC719C4CEF1;
	Wed, 21 Jan 2026 18:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019978;
	bh=sVl2ljIYvSu0uoeaz+mBP9JnXgVL5ziQK9X8l9YhWNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2E/zcKKfHdURf/DmnXKrwsE0Yp++CEqJKKg/gA3NnyA10vPDbC2i5++qFUyUab+KE
	 6tekIFm1Rg9NXjyobKQO8nvSD+8jD8wIoOtKNLUzKdumz6Gte5VF405pnGAJsY5FlV
	 aCzJTR5mlZxC+YuwmtpH0fowZXwjIxH/cBx9cLdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 023/198] drm/rockchip: vop2: Only wait for changed layer cfg done when there is pending cfgdone bits
Date: Wed, 21 Jan 2026 19:14:11 +0100
Message-ID: <20260121181419.388311082@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit 7f6721b767e219343cfe9a894f5bd869ff5b9d3a ]

The write of cfgdone bits always done at .atomic_flush.
When userspace makes plane zpos changes of two crtc within one commit,
at the .atomic_begin stage, crtcN will never receive the "layer change
cfg done" event of crtcM because crtcM has not yet written "cfgdone".
So only wait when there is pending cfgdone bits to avoid long timeout.

Fixes: 3e89a8c68354 ("drm/rockchip: vop2: Fix the update of LAYER/PORT select registers when there are multi display output on rk3588/rk3568")
Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20250718064120.8811-2-andyshrk@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_vop2_reg.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c b/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
index 855386a6a9f5c..f3950e8476a75 100644
--- a/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
+++ b/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
@@ -2144,6 +2144,7 @@ static void rk3568_vop2_setup_layer_mixer(struct vop2_video_port *vp)
 	u8 layer_sel_id;
 	unsigned int ofs;
 	u32 ovl_ctrl;
+	u32 cfg_done;
 	int i;
 	struct vop2_video_port *vp0 = &vop2->vps[0];
 	struct vop2_video_port *vp1 = &vop2->vps[1];
@@ -2298,8 +2299,16 @@ static void rk3568_vop2_setup_layer_mixer(struct vop2_video_port *vp)
 		rk3568_vop2_wait_for_port_mux_done(vop2);
 	}
 
-	if (layer_sel != old_layer_sel && atv_layer_sel != old_layer_sel)
-		rk3568_vop2_wait_for_layer_cfg_done(vop2, vop2->old_layer_sel);
+	if (layer_sel != old_layer_sel && atv_layer_sel != old_layer_sel) {
+		cfg_done = vop2_readl(vop2, RK3568_REG_CFG_DONE);
+		cfg_done &= (BIT(vop2->data->nr_vps) - 1);
+		cfg_done &= ~BIT(vp->id);
+		/*
+		 * Changes of other VPs' overlays have not taken effect
+		 */
+		if (cfg_done)
+			rk3568_vop2_wait_for_layer_cfg_done(vop2, vop2->old_layer_sel);
+	}
 
 	vop2_writel(vop2, RK3568_OVL_LAYER_SEL, layer_sel);
 	mutex_unlock(&vop2->ovl_lock);
-- 
2.51.0



