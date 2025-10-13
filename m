Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4320E241695;
	Mon, 13 Oct 2025 15:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369492; cv=none; b=OjhlXnKhaeAszvuloV5ghPiWgC/PKFrRk8yxDCefSUYHRgsSwwaguywJZCUhOq3tKIYVLIuSOlJs6BHeQV3qdJuyvtO1CdEcOwpGDKOofdsuFiK4I0Hk8CMpMtwFNHkSnDY2cY1C64wirnbpN2O1PdU4tZ4En5miwfjCfA9iiTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369492; c=relaxed/simple;
	bh=ygarFU3L1knmBzIpxlmHVBCNoStthkqJGoWrSf4oPJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmqJheJ9tcKn+y1sopABUjcXZ7d2P8N3Tb+3ErIzDI6NdKOCA0njRJoWyvIcFJOVdb6sxJvb+z1jGRvGRF8qgRlscXOxZBfNNAS9RVTM4FiitFas+jqhk6vhKr41hhFUSJw+iMU0oHKX+1OYFTE4yt3BOYH/2/oRCy8cZAP+rg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EArHMOze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EArHMOze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C369AC4CEE7;
	Mon, 13 Oct 2025 15:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369492;
	bh=ygarFU3L1knmBzIpxlmHVBCNoStthkqJGoWrSf4oPJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EArHMOzeXITunhD4DAi9XsECbRPytLDHBZNA91eBo2RcY3nsruzBor4bPbrHCDSEt
	 bZwAQJ3CXvM+31mApeNSkms/pSheZjr2L2GNkHyOdr/OM/HtqZhCaGo4SewHUYHppe
	 HaNhlHEhUHCkTTdQ9OxEEEP0+wU5BV5G49RzCKYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 264/563] drm/panel: Allow powering on panel follower after panel is enabled
Date: Mon, 13 Oct 2025 16:42:05 +0200
Message-ID: <20251013144420.841682604@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit 2eb22214c132374e11e681c44d7879c91f67f614 ]

Some touch controllers have to be powered on after the panel's backlight
is enabled. To support these controllers, introduce .panel_enabled() and
.panel_disabling() to panel_follower_funcs and use them to power on the
device after the panel and its backlight are enabled.

Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20250818115015.2909525-1-treapking@chromium.org
Stable-dep-of: cbdd16b818ee ("HID: i2c-hid: Make elan touch controllers power on after panel is enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel.c | 73 +++++++++++++++++++++++++++++++------
 include/drm/drm_panel.h     | 14 +++++++
 2 files changed, 76 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_panel.c b/drivers/gpu/drm/drm_panel.c
index c8bb28dccdc1b..d1e6598ea3bc0 100644
--- a/drivers/gpu/drm/drm_panel.c
+++ b/drivers/gpu/drm/drm_panel.c
@@ -134,6 +134,9 @@ void drm_panel_prepare(struct drm_panel *panel)
 	panel->prepared = true;
 
 	list_for_each_entry(follower, &panel->followers, list) {
+		if (!follower->funcs->panel_prepared)
+			continue;
+
 		ret = follower->funcs->panel_prepared(follower);
 		if (ret < 0)
 			dev_info(panel->dev, "%ps failed: %d\n",
@@ -179,6 +182,9 @@ void drm_panel_unprepare(struct drm_panel *panel)
 	mutex_lock(&panel->follower_lock);
 
 	list_for_each_entry(follower, &panel->followers, list) {
+		if (!follower->funcs->panel_unpreparing)
+			continue;
+
 		ret = follower->funcs->panel_unpreparing(follower);
 		if (ret < 0)
 			dev_info(panel->dev, "%ps failed: %d\n",
@@ -209,6 +215,7 @@ EXPORT_SYMBOL(drm_panel_unprepare);
  */
 void drm_panel_enable(struct drm_panel *panel)
 {
+	struct drm_panel_follower *follower;
 	int ret;
 
 	if (!panel)
@@ -219,10 +226,12 @@ void drm_panel_enable(struct drm_panel *panel)
 		return;
 	}
 
+	mutex_lock(&panel->follower_lock);
+
 	if (panel->funcs && panel->funcs->enable) {
 		ret = panel->funcs->enable(panel);
 		if (ret < 0)
-			return;
+			goto exit;
 	}
 	panel->enabled = true;
 
@@ -230,6 +239,19 @@ void drm_panel_enable(struct drm_panel *panel)
 	if (ret < 0)
 		DRM_DEV_INFO(panel->dev, "failed to enable backlight: %d\n",
 			     ret);
+
+	list_for_each_entry(follower, &panel->followers, list) {
+		if (!follower->funcs->panel_enabled)
+			continue;
+
+		ret = follower->funcs->panel_enabled(follower);
+		if (ret < 0)
+			dev_info(panel->dev, "%ps failed: %d\n",
+				 follower->funcs->panel_enabled, ret);
+	}
+
+exit:
+	mutex_unlock(&panel->follower_lock);
 }
 EXPORT_SYMBOL(drm_panel_enable);
 
@@ -243,6 +265,7 @@ EXPORT_SYMBOL(drm_panel_enable);
  */
 void drm_panel_disable(struct drm_panel *panel)
 {
+	struct drm_panel_follower *follower;
 	int ret;
 
 	if (!panel)
@@ -262,6 +285,18 @@ void drm_panel_disable(struct drm_panel *panel)
 		return;
 	}
 
+	mutex_lock(&panel->follower_lock);
+
+	list_for_each_entry(follower, &panel->followers, list) {
+		if (!follower->funcs->panel_disabling)
+			continue;
+
+		ret = follower->funcs->panel_disabling(follower);
+		if (ret < 0)
+			dev_info(panel->dev, "%ps failed: %d\n",
+				 follower->funcs->panel_disabling, ret);
+	}
+
 	ret = backlight_disable(panel->backlight);
 	if (ret < 0)
 		DRM_DEV_INFO(panel->dev, "failed to disable backlight: %d\n",
@@ -270,9 +305,12 @@ void drm_panel_disable(struct drm_panel *panel)
 	if (panel->funcs && panel->funcs->disable) {
 		ret = panel->funcs->disable(panel);
 		if (ret < 0)
-			return;
+			goto exit;
 	}
 	panel->enabled = false;
+
+exit:
+	mutex_unlock(&panel->follower_lock);
 }
 EXPORT_SYMBOL(drm_panel_disable);
 
@@ -539,13 +577,13 @@ EXPORT_SYMBOL(drm_is_panel_follower);
  * @follower_dev: The 'struct device' for the follower.
  * @follower:     The panel follower descriptor for the follower.
  *
- * A panel follower is called right after preparing the panel and right before
- * unpreparing the panel. It's primary intention is to power on an associated
- * touchscreen, though it could be used for any similar devices. Multiple
- * devices are allowed the follow the same panel.
+ * A panel follower is called right after preparing/enabling the panel and right
+ * before unpreparing/disabling the panel. It's primary intention is to power on
+ * an associated touchscreen, though it could be used for any similar devices.
+ * Multiple devices are allowed the follow the same panel.
  *
- * If a follower is added to a panel that's already been turned on, the
- * follower's prepare callback is called right away.
+ * If a follower is added to a panel that's already been prepared/enabled, the
+ * follower's prepared/enabled callback is called right away.
  *
  * The "panel" property of the follower points to the panel to be followed.
  *
@@ -569,12 +607,18 @@ int drm_panel_add_follower(struct device *follower_dev,
 	mutex_lock(&panel->follower_lock);
 
 	list_add_tail(&follower->list, &panel->followers);
-	if (panel->prepared) {
+	if (panel->prepared && follower->funcs->panel_prepared) {
 		ret = follower->funcs->panel_prepared(follower);
 		if (ret < 0)
 			dev_info(panel->dev, "%ps failed: %d\n",
 				 follower->funcs->panel_prepared, ret);
 	}
+	if (panel->enabled && follower->funcs->panel_enabled) {
+		ret = follower->funcs->panel_enabled(follower);
+		if (ret < 0)
+			dev_info(panel->dev, "%ps failed: %d\n",
+				 follower->funcs->panel_enabled, ret);
+	}
 
 	mutex_unlock(&panel->follower_lock);
 
@@ -587,7 +631,8 @@ EXPORT_SYMBOL(drm_panel_add_follower);
  * @follower:     The panel follower descriptor for the follower.
  *
  * Undo drm_panel_add_follower(). This includes calling the follower's
- * unprepare function if we're removed from a panel that's currently prepared.
+ * unpreparing/disabling function if we're removed from a panel that's currently
+ * prepared/enabled.
  *
  * Return: 0 or an error code.
  */
@@ -598,7 +643,13 @@ void drm_panel_remove_follower(struct drm_panel_follower *follower)
 
 	mutex_lock(&panel->follower_lock);
 
-	if (panel->prepared) {
+	if (panel->enabled && follower->funcs->panel_disabling) {
+		ret = follower->funcs->panel_disabling(follower);
+		if (ret < 0)
+			dev_info(panel->dev, "%ps failed: %d\n",
+				 follower->funcs->panel_disabling, ret);
+	}
+	if (panel->prepared && follower->funcs->panel_unpreparing) {
 		ret = follower->funcs->panel_unpreparing(follower);
 		if (ret < 0)
 			dev_info(panel->dev, "%ps failed: %d\n",
diff --git a/include/drm/drm_panel.h b/include/drm/drm_panel.h
index 843fb756a2950..2407bfa60236f 100644
--- a/include/drm/drm_panel.h
+++ b/include/drm/drm_panel.h
@@ -160,6 +160,20 @@ struct drm_panel_follower_funcs {
 	 * Called before the panel is powered off.
 	 */
 	int (*panel_unpreparing)(struct drm_panel_follower *follower);
+
+	/**
+	 * @panel_enabled:
+	 *
+	 * Called after the panel and the backlight have been enabled.
+	 */
+	int (*panel_enabled)(struct drm_panel_follower *follower);
+
+	/**
+	 * @panel_disabling:
+	 *
+	 * Called before the panel and the backlight are disabled.
+	 */
+	int (*panel_disabling)(struct drm_panel_follower *follower);
 };
 
 struct drm_panel_follower {
-- 
2.51.0



