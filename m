Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3822B9A6;
	Thu,  3 Jul 2025 15:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555067; cv=none; b=mzrrfLWgLeIDoofvd2/DO8YVL2JkA639pGh1vSJmBf1cdMp2suQeRK79Ku1zMIdA6H6O120AFoOxllbIXyn5PqhIzyPawumEIcqdBbatnd5EW72qtHlJBbabjGcZln0DIO6xr5mJP1FrwzBBWuJHWlIAfyv4XCzCx2dIty5kfQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555067; c=relaxed/simple;
	bh=+uu8CrKX2hOaP63MIg6wnGRGAdJOkT0CDLulLfCL82o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F49BlY7IsSDd5sgSM1vw0mFzaGGFVkWBVFVcNihP+gHmyf6cSbTKY6rpphVzOAHENaIFNPJM05chv9yAad7ZJ5qiTvtM2sC5i5Hy65f/rvj4AYn0PrtAgoAe5Mx6WWawHxp8arthBmZtc5w5iSiHFDuQi3J22zvz57YbwLmILY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cawGWZUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cawGWZUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87459C4CEE3;
	Thu,  3 Jul 2025 15:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555066;
	bh=+uu8CrKX2hOaP63MIg6wnGRGAdJOkT0CDLulLfCL82o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cawGWZUYfooV5c3qIOJEsTDfaYNkNtE41ZeAuBGXltR/Y+bmtIJUYqSowPOqs7qJ6
	 QaL92EEHErS1U3gUMPWlE6VQROZO3DKkVI5cP8L9xmtvrnq2dQjxQeMj6vw3GhKiz4
	 W/yGTmCyWO5jZxeScFCWCEWViZtz322KBHCb6b+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Krummenacher <max.krummenacher@toradex.com>,
	Douglas Anderson <dianders@chromium.org>,
	Ernest Van Hoecke <ernest.vanhoecke@toradex.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 167/263] drm/bridge: ti-sn65dsi86: Add HPD for DisplayPort connector type
Date: Thu,  3 Jul 2025 16:41:27 +0200
Message-ID: <20250703144011.054177279@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit 55e8ff842051b1150461d7595d8f1d033c69d66b ]

By default, HPD was disabled on SN65DSI86 bridge. When the driver was
added (commit "a095f15c00e27"), the HPD_DISABLE bit was set in pre-enable
call which was moved to other function calls subsequently.
Later on, commit "c312b0df3b13" added detect utility for DP mode. But with
HPD_DISABLE bit set, all the HPD events are disabled[0] and the debounced
state always return 1 (always connected state).

Set HPD_DISABLE bit conditionally based on display sink's connector type.
Since the HPD_STATE is reflected correctly only after waiting for debounce
time (~100-400ms) and adding this delay in detect() is not feasible
owing to the performace impact (glitches and frame drop), remove runtime
calls in detect() and add hpd_enable()/disable() bridge hooks with runtime
calls, to detect hpd properly without any delay.

[0]: <https://www.ti.com/lit/gpn/SN65DSI86> (Pg. 32)

Fixes: c312b0df3b13 ("drm/bridge: ti-sn65dsi86: Implement bridge connector operations for DP")
Cc: Max Krummenacher <max.krummenacher@toradex.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20250624044835.165708-1-j-choudhary@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 69 +++++++++++++++++++++++----
 1 file changed, 60 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index c1ed1a3d68447..4ea13e5a3a54a 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -330,12 +330,18 @@ static void ti_sn65dsi86_enable_comms(struct ti_sn65dsi86 *pdata)
 	 * 200 ms.  We'll assume that the panel driver will have the hardcoded
 	 * delay in its prepare and always disable HPD.
 	 *
-	 * If HPD somehow makes sense on some future panel we'll have to
-	 * change this to be conditional on someone specifying that HPD should
-	 * be used.
+	 * For DisplayPort bridge type, we need HPD. So we use the bridge type
+	 * to conditionally disable HPD.
+	 * NOTE: The bridge type is set in ti_sn_bridge_probe() but enable_comms()
+	 * can be called before. So for DisplayPort, HPD will be enabled once
+	 * bridge type is set. We are using bridge type instead of "no-hpd"
+	 * property because it is not used properly in devicetree description
+	 * and hence is unreliable.
 	 */
-	regmap_update_bits(pdata->regmap, SN_HPD_DISABLE_REG, HPD_DISABLE,
-			   HPD_DISABLE);
+
+	if (pdata->bridge.type != DRM_MODE_CONNECTOR_DisplayPort)
+		regmap_update_bits(pdata->regmap, SN_HPD_DISABLE_REG, HPD_DISABLE,
+				   HPD_DISABLE);
 
 	pdata->comms_enabled = true;
 
@@ -1172,9 +1178,14 @@ static enum drm_connector_status ti_sn_bridge_detect(struct drm_bridge *bridge)
 	struct ti_sn65dsi86 *pdata = bridge_to_ti_sn65dsi86(bridge);
 	int val = 0;
 
-	pm_runtime_get_sync(pdata->dev);
+	/*
+	 * Runtime reference is grabbed in ti_sn_bridge_hpd_enable()
+	 * as the chip won't report HPD just after being powered on.
+	 * HPD_DEBOUNCED_STATE reflects correct state only after the
+	 * debounce time (~100-400 ms).
+	 */
+
 	regmap_read(pdata->regmap, SN_HPD_DISABLE_REG, &val);
-	pm_runtime_put_autosuspend(pdata->dev);
 
 	return val & HPD_DEBOUNCED_STATE ? connector_status_connected
 					 : connector_status_disconnected;
@@ -1197,6 +1208,26 @@ static void ti_sn65dsi86_debugfs_init(struct drm_bridge *bridge, struct dentry *
 	debugfs_create_file("status", 0600, debugfs, pdata, &status_fops);
 }
 
+static void ti_sn_bridge_hpd_enable(struct drm_bridge *bridge)
+{
+	struct ti_sn65dsi86 *pdata = bridge_to_ti_sn65dsi86(bridge);
+
+	/*
+	 * Device needs to be powered on before reading the HPD state
+	 * for reliable hpd detection in ti_sn_bridge_detect() due to
+	 * the high debounce time.
+	 */
+
+	pm_runtime_get_sync(pdata->dev);
+}
+
+static void ti_sn_bridge_hpd_disable(struct drm_bridge *bridge)
+{
+	struct ti_sn65dsi86 *pdata = bridge_to_ti_sn65dsi86(bridge);
+
+	pm_runtime_put_autosuspend(pdata->dev);
+}
+
 static const struct drm_bridge_funcs ti_sn_bridge_funcs = {
 	.attach = ti_sn_bridge_attach,
 	.detach = ti_sn_bridge_detach,
@@ -1211,6 +1242,8 @@ static const struct drm_bridge_funcs ti_sn_bridge_funcs = {
 	.atomic_duplicate_state = drm_atomic_helper_bridge_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_bridge_destroy_state,
 	.debugfs_init = ti_sn65dsi86_debugfs_init,
+	.hpd_enable = ti_sn_bridge_hpd_enable,
+	.hpd_disable = ti_sn_bridge_hpd_disable,
 };
 
 static void ti_sn_bridge_parse_lanes(struct ti_sn65dsi86 *pdata,
@@ -1299,8 +1332,26 @@ static int ti_sn_bridge_probe(struct auxiliary_device *adev,
 	pdata->bridge.type = pdata->next_bridge->type == DRM_MODE_CONNECTOR_DisplayPort
 			   ? DRM_MODE_CONNECTOR_DisplayPort : DRM_MODE_CONNECTOR_eDP;
 
-	if (pdata->bridge.type == DRM_MODE_CONNECTOR_DisplayPort)
-		pdata->bridge.ops = DRM_BRIDGE_OP_EDID | DRM_BRIDGE_OP_DETECT;
+	if (pdata->bridge.type == DRM_MODE_CONNECTOR_DisplayPort) {
+		pdata->bridge.ops = DRM_BRIDGE_OP_EDID | DRM_BRIDGE_OP_DETECT |
+				    DRM_BRIDGE_OP_HPD;
+		/*
+		 * If comms were already enabled they would have been enabled
+		 * with the wrong value of HPD_DISABLE. Update it now. Comms
+		 * could be enabled if anyone is holding a pm_runtime reference
+		 * (like if a GPIO is in use). Note that in most cases nobody
+		 * is doing AUX channel xfers before the bridge is added so
+		 * HPD doesn't _really_ matter then. The only exception is in
+		 * the eDP case where the panel wants to read the EDID before
+		 * the bridge is added. We always consistently have HPD disabled
+		 * for eDP.
+		 */
+		mutex_lock(&pdata->comms_mutex);
+		if (pdata->comms_enabled)
+			regmap_update_bits(pdata->regmap, SN_HPD_DISABLE_REG,
+					   HPD_DISABLE, 0);
+		mutex_unlock(&pdata->comms_mutex);
+	};
 
 	drm_bridge_add(&pdata->bridge);
 
-- 
2.39.5



