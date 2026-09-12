Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5413B47D5;
	Sat, 12 Sep 2026 09:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205921; cv=none; b=cgTjqxT96Z2b+COf30sqK0I4c2p3gciVm4FpyHe3Ajelh/7M/BdpjR8saaxse71ALQHU5Dyt1w+Y2ZHqfGS2oP+vCt7FZNbhjxC//0PD7kvtHonP3GLPwwx0Aj542nV/eAT7cPVvpo4Ot4V4w4POzRD+0Nh0fTts06i40KOBgXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205921; c=relaxed/simple;
	bh=yj/8+5cEZ1/YJuPkZKL4eq7fX7vfk1puqFbqPBPtdxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U21fiRoONBumaRNOlHRpny2JtiXDcBOc10gb+I0DHJ4ryoNPNy8NLHzUxAScHbk546s7wSqf+1GkMeABRpuOHkaKzxZWijIzHFtOvqTsBrhJbtZ7CPbcscAeCxYT4EopiWWlmDKAk5UnbKia67BFqOK7lqYmZDTzsa/EgQHGU0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJq/2N+u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJq/2N+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E595C1F000FF;
	Sat, 12 Sep 2026 09:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205920;
	bh=BkG/0Lqov9GcjOr9rxxSGB5zaHvlCPYuFGIYBWk5xQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJq/2N+uLLC0K/74YFAzxjms1IWP8e72GzRAuO5sTDpW+fnA9PgffKZ46HxidSkvh
	 TYC2Pvzi7xklNv5IdZxmHzcz+8d1kVmnd1eDD3BqYtd4TEqwqpipNsidytzc4J37V9
	 3Xm5/aYcQ1yYKT0fjXhlrsjQj5Uu7XdXPbJHizbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0101/1518] drm/rockchip: vop2: Wait for layer cfg done before switching LAYERSEL_REGDONE_SEL
Date: Sat, 12 Sep 2026 08:37:50 +0200
Message-ID: <20260912065625.764247630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 3fcb0a2c29942..7cac271704c10 100644
--- a/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
+++ b/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
@@ -2289,15 +2289,6 @@ static void rk3568_vop2_setup_layer_mixer(struct vop2_video_port *vp)
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
@@ -2310,6 +2301,16 @@ static void rk3568_vop2_setup_layer_mixer(struct vop2_video_port *vp)
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



