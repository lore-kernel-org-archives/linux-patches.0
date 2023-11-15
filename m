Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EB243AC2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPRrK6hc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7B5C32784;
	Wed, 15 Nov 2023 20:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081340;
	bh=sSiaIz+1VujwsqJlX7qo7CFXGyzAD4UNknW/t2nIZWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPRrK6hcU0S7iJPv3iDAtC6CHAsagwr8N0hz/J61coE4I7BRY5hOp/VNivMDJRIzf
	 0HV356ZTIgVfIxTLGUrmjI0rFKk+jrIIOwb9LHj3L7eaEJ8SK6IvB/x2Zfg7tbfl60
	 0JtO2kvWZ5nflI8rGlYYhgKrUVjQyIrV8bxnQy6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/244] drm/bridge: lt8912b: Add missing drm_bridge_attach call
Date: Wed, 15 Nov 2023 15:34:46 -0500
Message-ID: <20231115203553.994423678@linuxfoundation.org>
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
index 73b6fcae6dca8..6891863ed5104 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -548,6 +548,13 @@ static int lt8912_bridge_attach(struct drm_bridge *bridge,
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



