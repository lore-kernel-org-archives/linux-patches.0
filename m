Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FEF364B3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CLTG6UDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BC4C3277D;
	Wed, 15 Nov 2023 20:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081331;
	bh=/ehhWsY2bO6BpWO4x1KBnKKznbIVeDeJ7NXKiIisz0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CLTG6UDI1h61zajeqob4ztT79R70w7aFJ8mzoMYTLcFPPSbGy3Oj54EjjCS85LCQH
	 iwUw1qeXN1oIjWrJ7CxjHtbaBn4VstRds+i2UD4Ua1jmiqk8lwqvkIV+43zkRHZ1qO
	 E5MKjv9JluXWamSJSdl6oDeoyXFJP9NJVPue1NZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Ravnborg <sam@ravnborg.org>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/244] drm/bridge: lt8912b: Switch to devm MIPI-DSI helpers
Date: Wed, 15 Nov 2023 15:34:40 -0500
Message-ID: <20231115203553.638111418@linuxfoundation.org>
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

[ Upstream commit 1fdbf66e3d40257902b4c5cdf872730dae24004f ]

Let's switch to the new devm MIPI-DSI function to register and attach
our secondary device.

Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20211025151536.1048186-6-maxime@cerno.tech
Stable-dep-of: 941882a0e96d ("drm/bridge: lt8912b: Fix bridge_detach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
index d3fd76a0a34ae..24ca22b0b9f56 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -481,11 +481,11 @@ static int lt8912_attach_dsi(struct lt8912 *lt)
 		return -EPROBE_DEFER;
 	}
 
-	dsi = mipi_dsi_device_register_full(host, &info);
+	dsi = devm_mipi_dsi_device_register_full(dev, host, &info);
 	if (IS_ERR(dsi)) {
 		ret = PTR_ERR(dsi);
 		dev_err(dev, "failed to create dsi device (%d)\n", ret);
-		goto err_dsi_device;
+		return ret;
 	}
 
 	lt->dsi = dsi;
@@ -497,24 +497,13 @@ static int lt8912_attach_dsi(struct lt8912 *lt)
 			  MIPI_DSI_MODE_LPM |
 			  MIPI_DSI_MODE_NO_EOT_PACKET;
 
-	ret = mipi_dsi_attach(dsi);
+	ret = devm_mipi_dsi_attach(dev, dsi);
 	if (ret < 0) {
 		dev_err(dev, "failed to attach dsi to host\n");
-		goto err_dsi_attach;
+		return ret;
 	}
 
 	return 0;
-
-err_dsi_attach:
-	mipi_dsi_device_unregister(dsi);
-err_dsi_device:
-	return ret;
-}
-
-static void lt8912_detach_dsi(struct lt8912 *lt)
-{
-	mipi_dsi_detach(lt->dsi);
-	mipi_dsi_device_unregister(lt->dsi);
 }
 
 static int lt8912_bridge_connector_init(struct drm_bridge *bridge)
@@ -581,7 +570,6 @@ static void lt8912_bridge_detach(struct drm_bridge *bridge)
 	struct lt8912 *lt = bridge_to_lt8912(bridge);
 
 	if (lt->is_attached) {
-		lt8912_detach_dsi(lt);
 		lt8912_hard_power_off(lt);
 		drm_connector_unregister(&lt->connector);
 		drm_connector_cleanup(&lt->connector);
-- 
2.42.0



