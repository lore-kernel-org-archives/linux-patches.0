Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D357482F5;
	Wed, 20 Dec 2023 16:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLvj5ST9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78FCC433C7;
	Wed, 20 Dec 2023 16:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703089086;
	bh=Xpjakkb6Uy28Hg43RiOWSRScBhV2X3sNNm+IOJm9lBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLvj5ST9/byqoxR9e8bvCHErPD32zXPKPcvhSsRgfF3yJ1ps5YFNoWbctrZhRrjuW
	 3wY76WGA2yCQjLzn5598HOoYV2sg6qO4xgVk1MA7A2o68lpV7TbMJy6NsSI/UQ2Ftf
	 sX1Ap8xF0gpEn3Va5LwsHj6e+PQS1VQDDMu0goiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 5.15 157/159] Revert "drm/bridge: lt9611uxc: Switch to devm MIPI-DSI helpers"
Date: Wed, 20 Dec 2023 17:10:22 +0100
Message-ID: <20231220160938.625005168@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Pundir <amit.pundir@linaro.org>

This reverts commit f53a045793289483b3c2930007fc52c7f1f642d5.

This and the dependent fixes broke display on RB5.

Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c |   38 ++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
@@ -258,18 +258,17 @@ static struct mipi_dsi_device *lt9611uxc
 	const struct mipi_dsi_device_info info = { "lt9611uxc", 0, NULL };
 	struct mipi_dsi_device *dsi;
 	struct mipi_dsi_host *host;
-	struct device *dev = lt9611uxc->dev;
 	int ret;
 
 	host = of_find_mipi_dsi_host_by_node(dsi_node);
 	if (!host) {
-		dev_err(dev, "failed to find dsi host\n");
+		dev_err(lt9611uxc->dev, "failed to find dsi host\n");
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 
-	dsi = devm_mipi_dsi_device_register_full(dev, host, &info);
+	dsi = mipi_dsi_device_register_full(host, &info);
 	if (IS_ERR(dsi)) {
-		dev_err(dev, "failed to create dsi device\n");
+		dev_err(lt9611uxc->dev, "failed to create dsi device\n");
 		return dsi;
 	}
 
@@ -278,9 +277,10 @@ static struct mipi_dsi_device *lt9611uxc
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_SYNC_PULSE |
 			  MIPI_DSI_MODE_VIDEO_HSE;
 
-	ret = devm_mipi_dsi_attach(dev, dsi);
+	ret = mipi_dsi_attach(dsi);
 	if (ret < 0) {
-		dev_err(dev, "failed to attach dsi to host\n");
+		dev_err(lt9611uxc->dev, "failed to attach dsi to host\n");
+		mipi_dsi_device_unregister(dsi);
 		return ERR_PTR(ret);
 	}
 
@@ -355,6 +355,19 @@ static int lt9611uxc_connector_init(stru
 	return drm_connector_attach_encoder(&lt9611uxc->connector, bridge->encoder);
 }
 
+static void lt9611uxc_bridge_detach(struct drm_bridge *bridge)
+{
+	struct lt9611uxc *lt9611uxc = bridge_to_lt9611uxc(bridge);
+
+	if (lt9611uxc->dsi1) {
+		mipi_dsi_detach(lt9611uxc->dsi1);
+		mipi_dsi_device_unregister(lt9611uxc->dsi1);
+	}
+
+	mipi_dsi_detach(lt9611uxc->dsi0);
+	mipi_dsi_device_unregister(lt9611uxc->dsi0);
+}
+
 static int lt9611uxc_bridge_attach(struct drm_bridge *bridge,
 				   enum drm_bridge_attach_flags flags)
 {
@@ -375,11 +388,19 @@ static int lt9611uxc_bridge_attach(struc
 	/* Attach secondary DSI, if specified */
 	if (lt9611uxc->dsi1_node) {
 		lt9611uxc->dsi1 = lt9611uxc_attach_dsi(lt9611uxc, lt9611uxc->dsi1_node);
-		if (IS_ERR(lt9611uxc->dsi1))
-			return PTR_ERR(lt9611uxc->dsi1);
+		if (IS_ERR(lt9611uxc->dsi1)) {
+			ret = PTR_ERR(lt9611uxc->dsi1);
+			goto err_unregister_dsi0;
+		}
 	}
 
 	return 0;
+
+err_unregister_dsi0:
+	mipi_dsi_detach(lt9611uxc->dsi0);
+	mipi_dsi_device_unregister(lt9611uxc->dsi0);
+
+	return ret;
 }
 
 static enum drm_mode_status
@@ -523,6 +544,7 @@ static struct edid *lt9611uxc_bridge_get
 
 static const struct drm_bridge_funcs lt9611uxc_bridge_funcs = {
 	.attach = lt9611uxc_bridge_attach,
+	.detach = lt9611uxc_bridge_detach,
 	.mode_valid = lt9611uxc_bridge_mode_valid,
 	.mode_set = lt9611uxc_bridge_mode_set,
 	.detect = lt9611uxc_bridge_detect,


