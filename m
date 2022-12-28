Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940E21863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19525C433D2;
	Wed, 28 Dec 2022 15:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240927;
	bh=+JSkrY5qRzZ4jTK0wCeoTUHJxkbwBCPYvU/9LC3D+IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5P0uc1ay9V3Hy2ucPYOiuRuqHVLv/p4FPXiwMVTbqzhV6QwD50rfYU94BRLQOPUs
	 vN4Y1cyfft4mv9UT6Vq1F6i3KckTWefX9+NWYydcPTuar7KkhN+5c/PyAueuhlIwJ+
	 ESR5i9RDLeU1lm0CbOEnDYbp+VNase50YMt9PcOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Robert Foss <robert.foss@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0220/1073] drm/bridge: it6505: Initialize AUX channel in it6505_i2c_probe
Date: Wed, 28 Dec 2022 15:30:08 +0100
Message-Id: <20221228144333.993025822@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit e577d4b13064c337b83fe7edecb3f34e87144821 ]

During device boot, the HPD interrupt could be triggered before the DRM
subsystem registers it6505 as a DRM bridge. In such cases, the driver
tries to access AUX channel and causes NULL pointer dereference.
Initializing the AUX channel earlier to prevent such error.

Fixes: b5c84a9edcd4 ("drm/bridge: add it6505 driver")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221013110411.1674359-2-treapking@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index a09d1a39ab0a..711f403afe7c 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2854,10 +2854,7 @@ static int it6505_bridge_attach(struct drm_bridge *bridge,
 	}
 
 	/* Register aux channel */
-	it6505->aux.name = "DP-AUX";
-	it6505->aux.dev = dev;
 	it6505->aux.drm_dev = bridge->dev;
-	it6505->aux.transfer = it6505_aux_transfer;
 
 	ret = drm_dp_aux_register(&it6505->aux);
 
@@ -3310,6 +3307,11 @@ static int it6505_i2c_probe(struct i2c_client *client,
 	DRM_DEV_DEBUG_DRIVER(dev, "it6505 device name: %s", dev_name(dev));
 	debugfs_init(it6505);
 
+	it6505->aux.name = "DP-AUX";
+	it6505->aux.dev = dev;
+	it6505->aux.transfer = it6505_aux_transfer;
+	drm_dp_aux_init(&it6505->aux);
+
 	it6505->bridge.funcs = &it6505_bridge_funcs;
 	it6505->bridge.type = DRM_MODE_CONNECTOR_DisplayPort;
 	it6505->bridge.ops = DRM_BRIDGE_OP_DETECT | DRM_BRIDGE_OP_EDID |
-- 
2.35.1



