Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9C237204A;
	Sat, 12 Sep 2026 07:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197078; cv=none; b=V9p6/mdGAUTiABRkETvhxQYZL388gl1iP+xjtRmzBgG7kRSFcTqHt7RkqQYeelqcDDRoZ15ntUft6A1BJ+E7Re1adx16lVl8HwvOMRfYA4tyORxoYDvtIkT3jqaRjKliLfMO4mkEhjy+e4s4p6ovSD9fUKp8qobYgX5Xnj+EG/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197078; c=relaxed/simple;
	bh=SRj/c8zUumOdh7pYpmSHIGVoczQWNii6DN8r53Gu8XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqEO1MxDzoNULriVKSntk0Zsh/ivHQusYeXGsbeA6l2oEYphLI1xiebzLows0xfhnr8O0DsEMTYeZQwnPdIMN1og1aZuADeZh1pTDM6+ihxzwF/HifcXtzrErX0/xtHj8WUFFG2G5cPRD7MqvsWbO68BprmSXOdhU86fi182l5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xk+BZj1S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xk+BZj1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CC61F000FF;
	Sat, 12 Sep 2026 07:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197076;
	bh=eENeNVI1nistmDwEkArbppT8bGjSPyV9ftAs5lD8xhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xk+BZj1SLQmLtn/4cuC5byAqlx9nhdtjuMD8fLo2gDhM5d8aMieBTQLYmSB0vX+/x
	 H6cwFQcpNMGp26wCKTWRiyBJIk5xfkzE8oisPyRkY7uxEeHCAr+UeCVeBug+RUCNrL
	 C2N1ZfM60eC19lJY102SWspPNwli7wVJ8Dmi9c8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0043/1815] drm/rockchip: vop2: Wait for layer cfg done before switching LAYERSEL_REGDONE_SEL
Date: Sat, 12 Sep 2026 08:29:53 +0200
Message-ID: <20260912065650.032698732@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit d1ad644e572c0647ad8428439eafea0aacfccf9e ]

LAYERSEL_REGDONE_SEL mask of RK3568_OVL_CTRL register controls which
Video Port (VP) vsync latches the shared RK3568_OVL_{LAYER|PORT}_SEL
shadow registers into the active configuration.

rk3568_vop2_setup_layer_mixer() overwrites LAYERSEL_REGDONE_SEL to the
current VP ID before waiting for the previous VP layer configuration to
take effect.  As a consequence, the previous VP vsync can no longer
trigger the latch, so the wait polls a value that might never appear.

Move the layer cfg done wait before the RK3568_OVL_CTRL write so the
previous VP vsync can still commit the pending configuration.

Fixes: 3e89a8c68354 ("drm/rockchip: vop2: Fix the update of LAYER/PORT select registers when there are multi display output on rk3588/rk3568")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260504-vop2-layer-cfg-tmout-v1-2-730226a7331e@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_vop2_reg.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c b/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
index fcf73a4327ab1..322a303d3f1a5 100644
--- a/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
+++ b/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
@@ -2288,15 +2288,6 @@ static void rk3568_vop2_setup_layer_mixer(struct vop2_video_port *vp)
 	 *    lead to the configuration of the previous VP being take effect along with the VSYNC
 	 *    of the new VP.
 	 */
-	if (layer_sel != old_layer_sel || port_sel != old_port_sel)
-		ovl_ctrl |= FIELD_PREP(RK3568_OVL_CTRL__LAYERSEL_REGDONE_SEL, vp->id);
-	vop2_writel(vop2, RK3568_OVL_CTRL, ovl_ctrl);
-
-	if (port_sel != old_port_sel) {
-		vop2_writel(vop2, RK3568_OVL_PORT_SEL, port_sel);
-		vop2_cfg_done(vp);
-		rk3568_vop2_wait_for_port_mux_done(vop2);
-	}
 
 	if (layer_sel != old_layer_sel && atv_layer_sel != old_layer_sel) {
 		cfg_done = vop2_readl(vop2, RK3568_REG_CFG_DONE);
@@ -2309,6 +2300,16 @@ static void rk3568_vop2_setup_layer_mixer(struct vop2_video_port *vp)
 			rk3568_vop2_wait_for_layer_cfg_done(vop2, old_layer_sel);
 	}
 
+	if (layer_sel != old_layer_sel || port_sel != old_port_sel)
+		ovl_ctrl |= FIELD_PREP(RK3568_OVL_CTRL__LAYERSEL_REGDONE_SEL, vp->id);
+	vop2_writel(vop2, RK3568_OVL_CTRL, ovl_ctrl);
+
+	if (port_sel != old_port_sel) {
+		vop2_writel(vop2, RK3568_OVL_PORT_SEL, port_sel);
+		vop2_cfg_done(vp);
+		rk3568_vop2_wait_for_port_mux_done(vop2);
+	}
+
 	vop2_writel(vop2, RK3568_OVL_LAYER_SEL, layer_sel);
 	mutex_unlock(&vop2->ovl_lock);
 }
-- 
2.53.0



