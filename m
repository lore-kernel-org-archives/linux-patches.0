Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC47A3D96E
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQo+01XA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BD8C433C8;
	Wed, 15 Nov 2023 19:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078118;
	bh=mmQ06+a//aV1NeAZtA8gnwyTOlt8eYqIqxyAwZTe4xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQo+01XADFShW5qLLNTtJO5OfCJVEH2TkAnKvTPFs7sPlPqgE5iQ5/JtZIbdiVKJb
	 itn5Ke/tWs9ah43MZIWwu+NYQwTIvN5K1R64suX9FQhMVoFCB7M7blVDZWIhdVZg7r
	 l9TypkZnUxO/UxePsXVzd3pSU6RGGYQ36G7YB98c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Adrien Grassein <adrien.grassein@gmail.com>,
	Robert Foss <robert.foss@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/379] drm/bridge: lt8912b: Add hot plug detection
Date: Wed, 15 Nov 2023 14:23:16 -0500
Message-ID: <20231115192652.280581643@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

[ Upstream commit 3b0a01a6a5224ed9b3f69f44edaa889b2e2b9779 ]

Enable hot plug detection when it is available on the HDMI port.
Without this connecting to a different monitor with incompatible timing
before the 10 seconds poll period will lead to a broken display output.

Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Adrien Grassein <adrien.grassein@gmail.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221128112320.25708-1-francesco@dolcini.it
Stable-dep-of: 941882a0e96d ("drm/bridge: lt8912b: Fix bridge_detach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
index 5e419934d2a39..8d2785a305b39 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -516,14 +516,27 @@ static int lt8912_attach_dsi(struct lt8912 *lt)
 	return 0;
 }
 
+static void lt8912_bridge_hpd_cb(void *data, enum drm_connector_status status)
+{
+	struct lt8912 *lt = data;
+
+	if (lt->bridge.dev)
+		drm_helper_hpd_irq_event(lt->bridge.dev);
+}
+
 static int lt8912_bridge_connector_init(struct drm_bridge *bridge)
 {
 	int ret;
 	struct lt8912 *lt = bridge_to_lt8912(bridge);
 	struct drm_connector *connector = &lt->connector;
 
-	connector->polled = DRM_CONNECTOR_POLL_CONNECT |
-			    DRM_CONNECTOR_POLL_DISCONNECT;
+	if (lt->hdmi_port->ops & DRM_BRIDGE_OP_HPD) {
+		drm_bridge_hpd_enable(lt->hdmi_port, lt8912_bridge_hpd_cb, lt);
+		connector->polled = DRM_CONNECTOR_POLL_HPD;
+	} else {
+		connector->polled = DRM_CONNECTOR_POLL_CONNECT |
+				    DRM_CONNECTOR_POLL_DISCONNECT;
+	}
 
 	ret = drm_connector_init(bridge->dev, connector,
 				 &lt8912_connector_funcs,
@@ -577,6 +590,10 @@ static void lt8912_bridge_detach(struct drm_bridge *bridge)
 
 	if (lt->is_attached) {
 		lt8912_hard_power_off(lt);
+
+		if (lt->hdmi_port->ops & DRM_BRIDGE_OP_HPD)
+			drm_bridge_hpd_disable(lt->hdmi_port);
+
 		drm_connector_unregister(&lt->connector);
 		drm_connector_cleanup(&lt->connector);
 	}
-- 
2.42.0



