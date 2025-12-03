Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FBE31960B;
	Wed,  3 Dec 2025 15:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776867; cv=none; b=mLcZMkCcl3Bp/SdOKTV76zx98wnvDTlyu1iEzTFoMAtaGihdQbGgUxwu3sOHM7inV19rOVHPll1UVm7+0Z3LnBgv3WCjGZJLyg1uZAXmTWhMJZyE5GJQMRR2wgxu9KZl7f9ta0JkhTOXhuPimxcFV4Bd7Wv4p5aYyNvOU/UfDcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776867; c=relaxed/simple;
	bh=QimqsfUzCweCEqCq9rhLXicdPISupUGqItdAZAIGcg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbPo04JTkZ1AVpIGrltVhDoKxf/4ANJH8k9ORJDDx6b2dFuOMa0KznIa5Bqp3nn3tRLL7K67GMhl3m7JyHMzdOKxqjgssl2pX/oI3OvKB3VBxEraRJHDN9OOVcqe+7GJt0+PgP7Kui0ajV844SXFrt/TUkaViMtG4APuqmI0Uao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LcJyLRdz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LcJyLRdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89498C4CEF5;
	Wed,  3 Dec 2025 15:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776867;
	bh=QimqsfUzCweCEqCq9rhLXicdPISupUGqItdAZAIGcg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LcJyLRdz5DhIVOAF0wAdiZRHRJQigYkhqqq98B+52JYXOReR+6SDx5Dn4ssrZetKl
	 UQUcaGohAGQsqF19YTXVlxmwE31er3FyehiuN2gbdOpYNiCMwiBIk/0S2PF3IuIpJs
	 PIKvQCirlcyRxafyIIDbFERHvVNnOE4hOL6zfEVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devarsh Thakkar <devarsht@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 011/146] drm/bridge: sii902x: Fix HDMI detection with DRM_BRIDGE_ATTACH_NO_CONNECTOR
Date: Wed,  3 Dec 2025 16:26:29 +0100
Message-ID: <20251203152346.878014361@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devarsh Thakkar <devarsht@ti.com>

[ Upstream commit d6732ef4ab252e5753be7acad87b0a91cfd06953 ]

The sii902x driver was caching HDMI detection state in a sink_is_hdmi field
and checking it in mode_set() to determine whether to set HDMI or DVI
output mode. This approach had two problems:

1. With DRM_BRIDGE_ATTACH_NO_CONNECTOR (used by modern display drivers like
TIDSS), the bridge's get_modes() is never called. Instead, the
drm_bridge_connector helper calls the bridge's edid_read() and updates the
connector itself. This meant sink_is_hdmi was never populated, causing the
driver to default to DVI mode and breaking HDMI audio.

2. The mode_set() callback doesn't receive atomic state or connector
pointer, making it impossible to check connector->display_info.is_hdmi
directly at that point.

Fix this by moving the HDMI vs DVI decision from mode_set() to
atomic_enable(), where we can access the connector via
drm_atomic_get_new_connector_for_encoder(). This works for both connector
models:

- With DRM_BRIDGE_ATTACH_NO_CONNECTOR: Returns the drm_bridge_connector
  created by the display driver, which has already been updated by the
helper's call to drm_edid_connector_update()

- Without DRM_BRIDGE_ATTACH_NO_CONNECTOR (legacy): Returns the connector
  embedded in sii902x struct, which gets updated by the bridge's own
get_modes()

Fixes: 3de47e1309c2 ("drm/bridge: sii902x: use display info is_hdmi")
Signed-off-by: Devarsh Thakkar <devarsht@ti.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20251030151635.3019864-1-devarsht@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/sii902x.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/bridge/sii902x.c b/drivers/gpu/drm/bridge/sii902x.c
index d537b1d036fb0..1f0aba28ad1e1 100644
--- a/drivers/gpu/drm/bridge/sii902x.c
+++ b/drivers/gpu/drm/bridge/sii902x.c
@@ -179,7 +179,6 @@ struct sii902x {
 	struct drm_connector connector;
 	struct gpio_desc *reset_gpio;
 	struct i2c_mux_core *i2cmux;
-	bool sink_is_hdmi;
 	u32 bus_width;
 
 	/*
@@ -315,8 +314,6 @@ static int sii902x_get_modes(struct drm_connector *connector)
 		drm_edid_free(drm_edid);
 	}
 
-	sii902x->sink_is_hdmi = connector->display_info.is_hdmi;
-
 	return num;
 }
 
@@ -342,9 +339,17 @@ static void sii902x_bridge_atomic_enable(struct drm_bridge *bridge,
 					 struct drm_atomic_state *state)
 {
 	struct sii902x *sii902x = bridge_to_sii902x(bridge);
+	struct drm_connector *connector;
+	u8 output_mode = SII902X_SYS_CTRL_OUTPUT_DVI;
+
+	connector = drm_atomic_get_new_connector_for_encoder(state, bridge->encoder);
+	if (connector && connector->display_info.is_hdmi)
+		output_mode = SII902X_SYS_CTRL_OUTPUT_HDMI;
 
 	mutex_lock(&sii902x->mutex);
 
+	regmap_update_bits(sii902x->regmap, SII902X_SYS_CTRL_DATA,
+			   SII902X_SYS_CTRL_OUTPUT_MODE, output_mode);
 	regmap_update_bits(sii902x->regmap, SII902X_PWR_STATE_CTRL,
 			   SII902X_AVI_POWER_STATE_MSK,
 			   SII902X_AVI_POWER_STATE_D(0));
@@ -359,16 +364,12 @@ static void sii902x_bridge_mode_set(struct drm_bridge *bridge,
 				    const struct drm_display_mode *adj)
 {
 	struct sii902x *sii902x = bridge_to_sii902x(bridge);
-	u8 output_mode = SII902X_SYS_CTRL_OUTPUT_DVI;
 	struct regmap *regmap = sii902x->regmap;
 	u8 buf[HDMI_INFOFRAME_SIZE(AVI)];
 	struct hdmi_avi_infoframe frame;
 	u16 pixel_clock_10kHz = adj->clock / 10;
 	int ret;
 
-	if (sii902x->sink_is_hdmi)
-		output_mode = SII902X_SYS_CTRL_OUTPUT_HDMI;
-
 	buf[0] = pixel_clock_10kHz & 0xff;
 	buf[1] = pixel_clock_10kHz >> 8;
 	buf[2] = drm_mode_vrefresh(adj);
@@ -384,11 +385,6 @@ static void sii902x_bridge_mode_set(struct drm_bridge *bridge,
 
 	mutex_lock(&sii902x->mutex);
 
-	ret = regmap_update_bits(sii902x->regmap, SII902X_SYS_CTRL_DATA,
-				 SII902X_SYS_CTRL_OUTPUT_MODE, output_mode);
-	if (ret)
-		goto out;
-
 	ret = regmap_bulk_write(regmap, SII902X_TPI_VIDEO_DATA, buf, 10);
 	if (ret)
 		goto out;
-- 
2.51.0



