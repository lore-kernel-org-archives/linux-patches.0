Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A55439CCE6;
	Sat, 17 Oct 2026 16:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253377; cv=none; b=pQA3cDJo16rn6ZlRUHGUotGBPu/UT2zxyUkBfy8DgUi/EDEeRaoRjKd2U6MISWszIch9XptO5iLt+6b048uX8WQh0V1hjOG1fbB/M5wGUDqOFARCNW2B4MvZIF0umk8rRxuvClvY1QXKaqh1t6C5AhHLwqLC6gO0QFKZJJmeVG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253377; c=relaxed/simple;
	bh=W/Eyz8xvw03w7CtNUte4yIB9R17EitilXEJuV4KpkDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVaRUjchunW3MDu9gLFCCHju4jt82nuP57RpPJQgzyHHU9H/dihk/gz9CbVOTAFmkI+WqjZY/ZNpD45goolvloqtmIOstKANMmbJIq0yrNlzHy/jMO15YATLp/CS1MP2ro8x4gvhDR9eCLutnRlGwCIHMF9ZKZYKPxfMRLa9E/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYFF5ito; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYFF5ito"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77141F000C4;
	Sat, 17 Oct 2026 16:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253376;
	bh=PrObECrG9eyOfG7/JeFEQHr4/NbU86sRcu6SVmjbeY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CYFF5itoLjOza2UtSnkoW3Pl5Zt53Str1mVtWAT7HwS5X6eEN5w8zYJV8zQBNjB+p
	 9eDUayXmSqtuz5Iqr7k9qoicdeIs4R6H//cEJ/tmXfNsf28GVul1nnVPE8auquKUTP
	 tVBVUZKixOribUIdioLTW4kjxinCMQlWGYEiNyQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/869] drm/rockchip: vop2: Consistently use dev_err_probe()
Date: Sat, 17 Oct 2026 17:48:58 +0200
Message-ID: <20261017160039.524498585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit b06d1ef3355571383cdb463cf0195b7a02efdfbf ]

Replace drm_err() calls in vop2_bind() and vop2_create_crtcs() with
dev_err_probe(), to simplify error handling and improve consistency.

Additionally, ensure the already existing dev_err_probe() invocations
pass drm->dev instead of dev as their first argument, so that we get the
actual reason in case of -EPROBE_DEFER errors:

  platform display-subsystem: deferred probe pending: (reason unknown)
    vs.
  platform display-subsystem: deferred probe pending: rockchip-drm: <actual reason>

While at it, add the missing '\n' to some of the message strings.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20250223-vop2-hdmi1-disp-modes-v2-2-f4cec5e06fbe@collabora.com
Stable-dep-of: f9f68bf1d0ef ("drm/rockchip: vop2: fail cleanly if missing a primary plane for a video-port")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 83 +++++++++-----------
 1 file changed, 37 insertions(+), 46 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 42521bd2ac16f..3654e74191adf 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -2806,10 +2806,9 @@ static int vop2_create_crtcs(struct vop2 *vop2)
 
 		snprintf(dclk_name, sizeof(dclk_name), "dclk_vp%d", vp->id);
 		vp->dclk = devm_clk_get(vop2->dev, dclk_name);
-		if (IS_ERR(vp->dclk)) {
-			drm_err(vop2->drm, "failed to get %s\n", dclk_name);
-			return PTR_ERR(vp->dclk);
-		}
+		if (IS_ERR(vp->dclk))
+			return dev_err_probe(drm->dev, PTR_ERR(vp->dclk),
+					     "failed to get %s\n", dclk_name);
 
 		np = of_graph_get_remote_node(dev->of_node, i, -1);
 		if (!np) {
@@ -2819,11 +2818,9 @@ static int vop2_create_crtcs(struct vop2 *vop2)
 		of_node_put(np);
 
 		port = of_graph_get_port_by_id(dev->of_node, i);
-		if (!port) {
-			drm_err(vop2->drm, "no port node found for video_port%d\n", i);
-			return -ENOENT;
-		}
-
+		if (!port)
+			return dev_err_probe(drm->dev, -ENOENT,
+					     "no port node found for video_port%d\n", i);
 		vp->crtc.port = port;
 		nvps++;
 	}
@@ -2863,11 +2860,9 @@ static int vop2_create_crtcs(struct vop2 *vop2)
 			possible_crtcs = (1 << nvps) - 1;
 
 		ret = vop2_plane_init(vop2, win, possible_crtcs);
-		if (ret) {
-			drm_err(vop2->drm, "failed to init plane %s: %d\n",
-				win->data->name, ret);
-			return ret;
-		}
+		if (ret)
+			return dev_err_probe(drm->dev, ret, "failed to init plane %s\n",
+					     win->data->name);
 	}
 
 	for (i = 0; i < vop2_data->nr_vps; i++) {
@@ -2881,10 +2876,9 @@ static int vop2_create_crtcs(struct vop2 *vop2)
 		ret = drm_crtc_init_with_planes(drm, &vp->crtc, plane, NULL,
 						&vop2_crtc_funcs,
 						"video_port%d", vp->id);
-		if (ret) {
-			drm_err(vop2->drm, "crtc init for video_port%d failed\n", i);
-			return ret;
-		}
+		if (ret)
+			return dev_err_probe(drm->dev, ret,
+					     "crtc init for video_port%d failed\n", i);
 
 		drm_crtc_helper_add(&vp->crtc, &vop2_crtc_helper_funcs);
 
@@ -3206,10 +3200,9 @@ static int vop2_bind(struct device *dev, struct device *master, void *data)
 	dev_set_drvdata(dev, vop2);
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vop");
-	if (!res) {
-		drm_err(vop2->drm, "failed to get vop2 register byname\n");
-		return -EINVAL;
-	}
+	if (!res)
+		return dev_err_probe(drm->dev, -EINVAL,
+				     "failed to get vop2 register byname\n");
 
 	vop2->regs = devm_ioremap_resource(dev, res);
 	if (IS_ERR(vop2->regs))
@@ -3233,56 +3226,54 @@ static int vop2_bind(struct device *dev, struct device *master, void *data)
 	if (vop2_data->feature & VOP2_FEATURE_HAS_SYS_GRF) {
 		vop2->sys_grf = syscon_regmap_lookup_by_phandle(dev->of_node, "rockchip,grf");
 		if (IS_ERR(vop2->sys_grf))
-			return dev_err_probe(dev, PTR_ERR(vop2->sys_grf), "cannot get sys_grf");
+			return dev_err_probe(drm->dev, PTR_ERR(vop2->sys_grf),
+					     "cannot get sys_grf\n");
 	}
 
 	if (vop2_data->feature & VOP2_FEATURE_HAS_VOP_GRF) {
 		vop2->vop_grf = syscon_regmap_lookup_by_phandle(dev->of_node, "rockchip,vop-grf");
 		if (IS_ERR(vop2->vop_grf))
-			return dev_err_probe(dev, PTR_ERR(vop2->vop_grf), "cannot get vop_grf");
+			return dev_err_probe(drm->dev, PTR_ERR(vop2->vop_grf),
+					     "cannot get vop_grf\n");
 	}
 
 	if (vop2_data->feature & VOP2_FEATURE_HAS_VO1_GRF) {
 		vop2->vo1_grf = syscon_regmap_lookup_by_phandle(dev->of_node, "rockchip,vo1-grf");
 		if (IS_ERR(vop2->vo1_grf))
-			return dev_err_probe(dev, PTR_ERR(vop2->vo1_grf), "cannot get vo1_grf");
+			return dev_err_probe(drm->dev, PTR_ERR(vop2->vo1_grf),
+					     "cannot get vo1_grf\n");
 	}
 
 	if (vop2_data->feature & VOP2_FEATURE_HAS_SYS_PMU) {
 		vop2->sys_pmu = syscon_regmap_lookup_by_phandle(dev->of_node, "rockchip,pmu");
 		if (IS_ERR(vop2->sys_pmu))
-			return dev_err_probe(dev, PTR_ERR(vop2->sys_pmu), "cannot get sys_pmu");
+			return dev_err_probe(drm->dev, PTR_ERR(vop2->sys_pmu),
+					     "cannot get sys_pmu\n");
 	}
 
 	vop2->hclk = devm_clk_get(vop2->dev, "hclk");
-	if (IS_ERR(vop2->hclk)) {
-		drm_err(vop2->drm, "failed to get hclk source\n");
-		return PTR_ERR(vop2->hclk);
-	}
+	if (IS_ERR(vop2->hclk))
+		return dev_err_probe(drm->dev, PTR_ERR(vop2->hclk),
+				     "failed to get hclk source\n");
 
 	vop2->aclk = devm_clk_get(vop2->dev, "aclk");
-	if (IS_ERR(vop2->aclk)) {
-		drm_err(vop2->drm, "failed to get aclk source\n");
-		return PTR_ERR(vop2->aclk);
-	}
+	if (IS_ERR(vop2->aclk))
+		return dev_err_probe(drm->dev, PTR_ERR(vop2->aclk),
+				     "failed to get aclk source\n");
 
 	vop2->pclk = devm_clk_get_optional(vop2->dev, "pclk_vop");
-	if (IS_ERR(vop2->pclk)) {
-		drm_err(vop2->drm, "failed to get pclk source\n");
-		return PTR_ERR(vop2->pclk);
-	}
+	if (IS_ERR(vop2->pclk))
+		return dev_err_probe(drm->dev, PTR_ERR(vop2->pclk),
+				     "failed to get pclk source\n");
 
 	vop2->pll_hdmiphy0 = devm_clk_get_optional(vop2->dev, "pll_hdmiphy0");
-	if (IS_ERR(vop2->pll_hdmiphy0)) {
-		drm_err(vop2->drm, "failed to get pll_hdmiphy0\n");
-		return PTR_ERR(vop2->pll_hdmiphy0);
-	}
+	if (IS_ERR(vop2->pll_hdmiphy0))
+		return dev_err_probe(drm->dev, PTR_ERR(vop2->pll_hdmiphy0),
+				     "failed to get pll_hdmiphy0\n");
 
 	vop2->irq = platform_get_irq(pdev, 0);
-	if (vop2->irq < 0) {
-		drm_err(vop2->drm, "cannot find irq for vop2\n");
-		return vop2->irq;
-	}
+	if (vop2->irq < 0)
+		return dev_err_probe(drm->dev, vop2->irq, "cannot find irq for vop2\n");
 
 	mutex_init(&vop2->vop2_lock);
 
-- 
2.53.0



