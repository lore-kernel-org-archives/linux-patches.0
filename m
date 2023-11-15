Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A11B3A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idoUUqus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC154C433C8;
	Wed, 15 Nov 2023 19:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077320;
	bh=L6vELtLA7OZsiREdpWgl0PhVtoH1FvHSHA5dHq+E9rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idoUUqus7kElcFIF6p3If46JCpQhIH0O4/qSgsJbFK6lbAi+jGGHclvXqMGjw0pww
	 7zZRb41lYrww3YKh8FAWp4exQMx+c4DRGGpITPmTYMm2Ig2hHYUe8chmAtekmbucMN
	 P+q3M9Z0oI/JlxnMiguhJmjLxlcDGyS5wohTan6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 228/603] drm/bridge: lt8912b: Add missing drm_bridge_attach call
Date: Wed, 15 Nov 2023 14:12:53 -0500
Message-ID: <20231115191628.971946285@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit f45acf7acf75921c0409d452f0165f51a19a74fd ]

The driver does not call drm_bridge_attach(), which causes the next
bridge to not be added to the bridge chain. This causes the pipeline
init to fail when DRM_BRIDGE_ATTACH_NO_CONNECTOR is used.

Add the call to drm_bridge_attach().

Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230804-lt8912b-v1-4-c542692c6a2f@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
index 9ee639e75a1c2..03532efb893bb 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -558,6 +558,13 @@ static int lt8912_bridge_attach(struct drm_bridge *bridge,
 	struct lt8912 *lt = bridge_to_lt8912(bridge);
 	int ret;
 
+	ret = drm_bridge_attach(bridge->encoder, lt->hdmi_port, bridge,
+				DRM_BRIDGE_ATTACH_NO_CONNECTOR);
+	if (ret < 0) {
+		dev_err(lt->dev, "Failed to attach next bridge (%d)\n", ret);
+		return ret;
+	}
+
 	if (!(flags & DRM_BRIDGE_ATTACH_NO_CONNECTOR)) {
 		ret = lt8912_bridge_connector_init(bridge);
 		if (ret) {
-- 
2.42.0



