Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327332C861
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYuzBcoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A47C433CA;
	Wed, 15 Nov 2023 19:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076317;
	bh=dDBAR7P5E4dFNqMjFTK18gBUd6Mgb8/leD+Qlbkq/k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYuzBcoPmhT4Q1Hqx8h40+vrlXdQcuBElQw2ICm0i460BgX9x96fqdQb1XOpiiHCE
	 FV354LsBXRMahlqL1/NLHyMJS39ois7W82ibJi5u7OC/R3I9TuDP3YTweHZYs14bRt
	 VlONO4DH8bALsF3iq+14H+RcWtClEQFij8U3RYTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 214/550] drm/bridge: lt8912b: Add missing drm_bridge_attach call
Date: Wed, 15 Nov 2023 14:13:18 -0500
Message-ID: <20231115191615.632319602@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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



