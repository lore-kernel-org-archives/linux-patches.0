Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA571A6192;
	Tue, 30 Jul 2024 16:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357236; cv=none; b=Y1TtqbZA0PO6eLKlLd8+bZ8b2P9O/kBAaU7OHzxzKXcpTtXD7nNYwZqg+path75oO4KebCxo+Kb0QOGxRItiyXB36gFec8xZI66pVQuRosEhIJOD8mw83XabhqCP/ne0nDNjcr1pdwI92q8AoguEVXJuTItw/iuyvaKM6W0alX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357236; c=relaxed/simple;
	bh=ECCxSbS0eXW1EwuYGuT5JMmr1IxOTA0jYP2TNCLWtLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGxUfNYJ+sJKpPsgBLnwKr+GgKOLdn6MaBJK645x20idXHavqcUp+dY0iWgYf983A7vi6eBYNuOqYW8hU+pJZifK+wfG/VpCHssKimftKKGQmgS6IxH1CbY7tW95UF/Kgr7u/yozt/ci+Kp1Am64nQawwDhdF953pT4upq9ZvOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbhEHOKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbhEHOKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E96C32782;
	Tue, 30 Jul 2024 16:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357236;
	bh=ECCxSbS0eXW1EwuYGuT5JMmr1IxOTA0jYP2TNCLWtLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dbhEHOKVbY0UcsVniDMa6achWs/jW2s5WqMOF4z57E7iOVBCScZrvjHGpMM/VifBV
	 LOw1aVsMDib8lddHnWMdipLH+CTXwmZJ2U63iAoZTwJcFVwAD0u/nRR8Z/S01i9r6i
	 Q9/tJhrMYIiFloNPFe0oEUDRoZ25mPzhzB61nR5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 232/568] drm/mediatek/dp: switch to ->edid_read callback
Date: Tue, 30 Jul 2024 17:45:39 +0200
Message-ID: <20240730151648.948528136@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 0c13bd9bf444b0dfb2e9ea0d26915f310cc8ad6a ]

Prefer using the struct drm_edid based callback and functions.

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/3d783478e25e71f12f66c2caedb1f9205d4d8a44.1706038510.git.jani.nikula@intel.com
Stable-dep-of: 8ad49a92cff4 ("drm/mediatek/dp: Fix spurious kfree()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dp.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dp.c b/drivers/gpu/drm/mediatek/mtk_dp.c
index af03a22772fed..ff8436fb6e0d8 100644
--- a/drivers/gpu/drm/mediatek/mtk_dp.c
+++ b/drivers/gpu/drm/mediatek/mtk_dp.c
@@ -2027,12 +2027,12 @@ static enum drm_connector_status mtk_dp_bdg_detect(struct drm_bridge *bridge)
 	return ret;
 }
 
-static struct edid *mtk_dp_get_edid(struct drm_bridge *bridge,
-				    struct drm_connector *connector)
+static const struct drm_edid *mtk_dp_edid_read(struct drm_bridge *bridge,
+					       struct drm_connector *connector)
 {
 	struct mtk_dp *mtk_dp = mtk_dp_from_bridge(bridge);
 	bool enabled = mtk_dp->enabled;
-	struct edid *new_edid = NULL;
+	const struct drm_edid *drm_edid;
 	struct mtk_dp_audio_cfg *audio_caps = &mtk_dp->info.audio_cur_cfg;
 
 	if (!enabled) {
@@ -2040,7 +2040,7 @@ static struct edid *mtk_dp_get_edid(struct drm_bridge *bridge,
 		mtk_dp_aux_panel_poweron(mtk_dp, true);
 	}
 
-	new_edid = drm_get_edid(connector, &mtk_dp->aux.ddc);
+	drm_edid = drm_edid_read_ddc(connector, &mtk_dp->aux.ddc);
 
 	/*
 	 * Parse capability here to let atomic_get_input_bus_fmts and
@@ -2048,17 +2048,26 @@ static struct edid *mtk_dp_get_edid(struct drm_bridge *bridge,
 	 */
 	if (mtk_dp_parse_capabilities(mtk_dp)) {
 		drm_err(mtk_dp->drm_dev, "Can't parse capabilities\n");
-		kfree(new_edid);
-		new_edid = NULL;
+		drm_edid_free(drm_edid);
+		drm_edid = NULL;
 	}
 
-	if (new_edid) {
+	if (drm_edid) {
+		/*
+		 * FIXME: get rid of drm_edid_raw()
+		 */
+		const struct edid *edid = drm_edid_raw(drm_edid);
 		struct cea_sad *sads;
 
-		audio_caps->sad_count = drm_edid_to_sad(new_edid, &sads);
+		audio_caps->sad_count = drm_edid_to_sad(edid, &sads);
 		kfree(sads);
 
-		audio_caps->detect_monitor = drm_detect_monitor_audio(new_edid);
+		/*
+		 * FIXME: This should use connector->display_info.has_audio from
+		 * a path that has read the EDID and called
+		 * drm_edid_connector_update().
+		 */
+		audio_caps->detect_monitor = drm_detect_monitor_audio(edid);
 	}
 
 	if (!enabled) {
@@ -2066,7 +2075,7 @@ static struct edid *mtk_dp_get_edid(struct drm_bridge *bridge,
 		drm_atomic_bridge_chain_post_disable(bridge, connector->state->state);
 	}
 
-	return new_edid;
+	return drm_edid;
 }
 
 static ssize_t mtk_dp_aux_transfer(struct drm_dp_aux *mtk_aux,
@@ -2418,7 +2427,7 @@ static const struct drm_bridge_funcs mtk_dp_bridge_funcs = {
 	.atomic_enable = mtk_dp_bridge_atomic_enable,
 	.atomic_disable = mtk_dp_bridge_atomic_disable,
 	.mode_valid = mtk_dp_bridge_mode_valid,
-	.get_edid = mtk_dp_get_edid,
+	.edid_read = mtk_dp_edid_read,
 	.detect = mtk_dp_bdg_detect,
 };
 
-- 
2.43.0



