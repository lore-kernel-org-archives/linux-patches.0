Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CE930FC17;
	Wed, 28 Jan 2026 15:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615834; cv=none; b=Nz0gunUVVHUahWNo97Fal8ABxg6ATzFjO5QWWfkvy+WnejMUXe2NYRtgz+shGd7dH5L3cqAFxNQecgHmIHsz1F0gUg65JKncUjJYviU0uVepaJpWvTtWkSRwNIjfrKHZEjR3j3p+5wTwTsYkr8mE+IRY2UBXl1LjThd+stSGXg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615834; c=relaxed/simple;
	bh=CSNp1zTmgK8V/4Y6uq4sOal7b0eCMdtin9+yjEc8sCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rp9T0cMpnOF83DQDW3JGwBgzFdsUF/ooOWi3673FSIVbirwu5fBbrbbyHPgQr0WxU9Iu1iiYGpeozUgJ2CasDZMnnKvDkZe+/ZbQbkXa+mZG+Do4msFKLjPOVJ6NRBIylBnKyhYIllLkvUspMHV3zAV6DBK91RsKlrBG/+SThwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Km1jxJWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Km1jxJWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D44C4CEF1;
	Wed, 28 Jan 2026 15:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615834;
	bh=CSNp1zTmgK8V/4Y6uq4sOal7b0eCMdtin9+yjEc8sCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Km1jxJWGCoYlzbQmpcrdmjoeH5JC7kdkZs961N51vNns45+Ebm3kTpt22SQHyApk8
	 VENqHxlRhsC/AFFoBB7W1MJGAi4D+wjw1/g/igzdfklmE8ZEpGCPKPM76nQ5+16oHI
	 X0A5ET6oNGh0AznFm7REIJNQoNenp541c9Ff3e0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 100/227] drm/mediatek: dpi: Find next bridge during probe
Date: Wed, 28 Jan 2026 16:22:25 +0100
Message-ID: <20260128145348.064441840@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 21465e73400dc69a5f732ae7bcc2a58bad673cd1 ]

Trying to find the next bridge and deferring probe in the bridge attach
callback is much too late. At this point the driver has already finished
probing and is now running the component bind code path. What's even
worse is that in the specific case of the DSI host being the last
component to be added as part of the dsi_host_attach callback, the code
path that this is in:

 -> devm_drm_of_get_bridge()
    mtk_dpi_bridge_attach()
    drm_bridge_attach()
    mtk_dpi_bind()
    ...
    component_add()
    mtk_dsi_host_attach()
    anx7625_attach_dsi()
    anx7625_link_bridge()
	- done_probing callback for of_dp_aux_populate_bus()
    of_dp_aux_populate_bus()
    anx7625_i2c_probe()

_cannot_ return probe defer:

    anx7625 4-0058: [drm:anx7625_bridge_attach] drm attach
    mediatek-drm mediatek-drm.15.auto: bound 14014000.dsi
	(ops mtk_dsi_component_ops)
    mediatek-drm mediatek-drm.15.auto: error -EPROBE_DEFER:
	failed to attach bridge /soc/dpi@14015000 to encoder TMDS-37
    [drm:mtk_dsi_host_attach] *ERROR* failed to add dsi_host
	component: -517
    anx7625 4-0058: [drm:anx7625_link_bridge] *ERROR* fail to attach dsi
	to host.
    panel-simple-dp-aux aux-4-0058: DP AUX done_probing() can't defer
    panel-simple-dp-aux aux-4-0058: probe with driver panel-simple-dp-aux
	failed with error -22
    anx7625 4-0058: [drm:anx7625_i2c_probe] probe done

This results in the whole display driver failing to probe.

Perhaps this was an attempt to mirror the structure in the DSI driver;
but in the DSI driver the next bridge is retrieved in the DSI attach
callback, not the bridge attach callback.

Move the code finding the next bridge back to the probe function so that
deferred probing works correctly. Also rework the fallback to the old OF
graph endpoint numbering scheme so that deferred probing logs in both
cases.

This issue was found on an MT8183 Jacuzzi device with an extra patch
enabling the DPI-based external display pipeline. Also tested on an
MT8192 Hayato device with both DSI and DPI display pipelines enabled.

Fixes: 4c932840db1d ("drm/mediatek: Implement OF graphs support for display paths")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20260114092243.3914836-1-wenst@chromium.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dpi.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dpi.c b/drivers/gpu/drm/mediatek/mtk_dpi.c
index 61cab32e213af..53360b5d12ba5 100644
--- a/drivers/gpu/drm/mediatek/mtk_dpi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dpi.c
@@ -836,20 +836,6 @@ static int mtk_dpi_bridge_attach(struct drm_bridge *bridge,
 				 enum drm_bridge_attach_flags flags)
 {
 	struct mtk_dpi *dpi = bridge_to_dpi(bridge);
-	int ret;
-
-	dpi->next_bridge = devm_drm_of_get_bridge(dpi->dev, dpi->dev->of_node, 1, -1);
-	if (IS_ERR(dpi->next_bridge)) {
-		ret = PTR_ERR(dpi->next_bridge);
-		if (ret == -EPROBE_DEFER)
-			return ret;
-
-		/* Old devicetree has only one endpoint */
-		dpi->next_bridge = devm_drm_of_get_bridge(dpi->dev, dpi->dev->of_node, 0, 0);
-		if (IS_ERR(dpi->next_bridge))
-			return dev_err_probe(dpi->dev, PTR_ERR(dpi->next_bridge),
-					     "Failed to get bridge\n");
-	}
 
 	return drm_bridge_attach(encoder, dpi->next_bridge,
 				 &dpi->bridge, flags);
@@ -1319,6 +1305,15 @@ static int mtk_dpi_probe(struct platform_device *pdev)
 	if (dpi->irq < 0)
 		return dpi->irq;
 
+	dpi->next_bridge = devm_drm_of_get_bridge(dpi->dev, dpi->dev->of_node, 1, -1);
+	if (IS_ERR(dpi->next_bridge) && PTR_ERR(dpi->next_bridge) == -ENODEV) {
+		/* Old devicetree has only one endpoint */
+		dpi->next_bridge = devm_drm_of_get_bridge(dpi->dev, dpi->dev->of_node, 0, 0);
+	}
+	if (IS_ERR(dpi->next_bridge))
+		return dev_err_probe(dpi->dev, PTR_ERR(dpi->next_bridge),
+				     "Failed to get bridge\n");
+
 	platform_set_drvdata(pdev, dpi);
 
 	dpi->bridge.of_node = dev->of_node;
-- 
2.51.0



