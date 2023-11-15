Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFF343ABE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sVQbjZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCA6C3278D;
	Wed, 15 Nov 2023 20:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081355;
	bh=oQ6VK7932TwP3/20RG34AOKT73Ge7cBt0dL9ZhZmXT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1sVQbjZoAxt8KjbL5TMIrdOufYTl8Rmf8XlN5z11N3rdXOOqrw7JvG8lwtYliaXDe
	 L4t1g2PwXGRFUm2ak9SFlmfOurpfpmvXevPeYl9/tyTDLjt24DKcKQTzVgfDWqo0n9
	 7qhYqpwpnlM5pSBcJppDLPOcwfqWCLY3hhySXwCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Ravnborg <sam@ravnborg.org>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/244] drm/bridge: lt9611uxc: Switch to devm MIPI-DSI helpers
Date: Wed, 15 Nov 2023 15:34:54 -0500
Message-ID: <20231115203554.479135294@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 293ada7b058e536d9d53d0d8840c6ba8c2f718e4 ]

Let's switch to the new devm MIPI-DSI function to register and attach
our secondary device.

Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20211025151536.1048186-10-maxime@cerno.tech
Stable-dep-of: 15fe53be46ea ("drm/bridge: lt9611uxc: fix the race in the error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c | 38 +++++-----------------
 1 file changed, 8 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
index c4454d0f6cad5..b58842f69fff1 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
@@ -258,17 +258,18 @@ static struct mipi_dsi_device *lt9611uxc_attach_dsi(struct lt9611uxc *lt9611uxc,
 	const struct mipi_dsi_device_info info = { "lt9611uxc", 0, NULL };
 	struct mipi_dsi_device *dsi;
 	struct mipi_dsi_host *host;
+	struct device *dev = lt9611uxc->dev;
 	int ret;
 
 	host = of_find_mipi_dsi_host_by_node(dsi_node);
 	if (!host) {
-		dev_err(lt9611uxc->dev, "failed to find dsi host\n");
+		dev_err(dev, "failed to find dsi host\n");
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 
-	dsi = mipi_dsi_device_register_full(host, &info);
+	dsi = devm_mipi_dsi_device_register_full(dev, host, &info);
 	if (IS_ERR(dsi)) {
-		dev_err(lt9611uxc->dev, "failed to create dsi device\n");
+		dev_err(dev, "failed to create dsi device\n");
 		return dsi;
 	}
 
@@ -277,10 +278,9 @@ static struct mipi_dsi_device *lt9611uxc_attach_dsi(struct lt9611uxc *lt9611uxc,
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_SYNC_PULSE |
 			  MIPI_DSI_MODE_VIDEO_HSE;
 
-	ret = mipi_dsi_attach(dsi);
+	ret = devm_mipi_dsi_attach(dev, dsi);
 	if (ret < 0) {
-		dev_err(lt9611uxc->dev, "failed to attach dsi to host\n");
-		mipi_dsi_device_unregister(dsi);
+		dev_err(dev, "failed to attach dsi to host\n");
 		return ERR_PTR(ret);
 	}
 
@@ -355,19 +355,6 @@ static int lt9611uxc_connector_init(struct drm_bridge *bridge, struct lt9611uxc
 	return drm_connector_attach_encoder(&lt9611uxc->connector, bridge->encoder);
 }
 
-static void lt9611uxc_bridge_detach(struct drm_bridge *bridge)
-{
-	struct lt9611uxc *lt9611uxc = bridge_to_lt9611uxc(bridge);
-
-	if (lt9611uxc->dsi1) {
-		mipi_dsi_detach(lt9611uxc->dsi1);
-		mipi_dsi_device_unregister(lt9611uxc->dsi1);
-	}
-
-	mipi_dsi_detach(lt9611uxc->dsi0);
-	mipi_dsi_device_unregister(lt9611uxc->dsi0);
-}
-
 static int lt9611uxc_bridge_attach(struct drm_bridge *bridge,
 				   enum drm_bridge_attach_flags flags)
 {
@@ -388,19 +375,11 @@ static int lt9611uxc_bridge_attach(struct drm_bridge *bridge,
 	/* Attach secondary DSI, if specified */
 	if (lt9611uxc->dsi1_node) {
 		lt9611uxc->dsi1 = lt9611uxc_attach_dsi(lt9611uxc, lt9611uxc->dsi1_node);
-		if (IS_ERR(lt9611uxc->dsi1)) {
-			ret = PTR_ERR(lt9611uxc->dsi1);
-			goto err_unregister_dsi0;
-		}
+		if (IS_ERR(lt9611uxc->dsi1))
+			return PTR_ERR(lt9611uxc->dsi1);
 	}
 
 	return 0;
-
-err_unregister_dsi0:
-	mipi_dsi_detach(lt9611uxc->dsi0);
-	mipi_dsi_device_unregister(lt9611uxc->dsi0);
-
-	return ret;
 }
 
 static enum drm_mode_status
@@ -544,7 +523,6 @@ static struct edid *lt9611uxc_bridge_get_edid(struct drm_bridge *bridge,
 
 static const struct drm_bridge_funcs lt9611uxc_bridge_funcs = {
 	.attach = lt9611uxc_bridge_attach,
-	.detach = lt9611uxc_bridge_detach,
 	.mode_valid = lt9611uxc_bridge_mode_valid,
 	.mode_set = lt9611uxc_bridge_mode_set,
 	.detect = lt9611uxc_bridge_detect,
-- 
2.42.0



