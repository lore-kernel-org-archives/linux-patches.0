Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9AA30103C;
	Tue, 11 Nov 2025 01:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824398; cv=none; b=Dpn1tRJ0m1pQw6spIARdSAomz8XLG/RLywfn9BuxlUqkXzi3OYGo4La3+Cm7nKILwf6fLeRiV12kO/ruIlzwy9OOU/7BiBiMrzWTqKoW6mphKr5iJ0hKWrvb1NAUAyLNmfHOZX+DNtBcFHe7O6cYuYxs0KJ18Sdv6zY4b+TnB2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824398; c=relaxed/simple;
	bh=J0rmfD8uOa8neT7MjE04ryRGymDMsWrFeyQASAnklVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2Ry7pVKidCozweHsahdPVd3M6OWsorjdqw1lx2FeJdyNIY8OfQ1tFzuZsDlatzkVwaJOx84qNh5cRL8Jgls19oIZkZxZVCoTgJXho54Z2Ae68vrFk1UuaXJm6bjSt3tYR5hmWUTOFoY8fOo2pKismCaCIZVGoz0V6iVQEVvi2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwGByNTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwGByNTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5977CC113D0;
	Tue, 11 Nov 2025 01:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824398;
	bh=J0rmfD8uOa8neT7MjE04ryRGymDMsWrFeyQASAnklVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BwGByNTUcG0v5RxxpPwDC+7zt7hituY8OvJGgTKGe7GXE6QxosChhBPccaKfkK2pO
	 aBy4xox+fOa+/1Pkm+sL45guQQKCfbAczHipVNuW0FMscKi6N0vTiGbGEECq9rhxwL
	 /m4+CKNag95WLhRaHbOqZwnJVWCGO1nWjsBQY5qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 487/849] drm/bridge: write full Audio InfoFrame
Date: Tue, 11 Nov 2025 09:40:57 +0900
Message-ID: <20251111004548.215037742@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit f0e7f358e72b10b01361787134ebcbd9e9aa72d9 ]

Instead of writing the first byte of the infoframe (and hoping that the
rest is default / zeroes), hook Audio InfoFrame support into the
write_infoframe / clear_infoframes callbacks and use
drm_atomic_helper_connector_hdmi_update_audio_infoframe() to write the
frame.

Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://lore.kernel.org/r/20250903-adv7511-audio-infoframe-v1-2-05b24459b9a4@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/bridge/adv7511/adv7511_audio.c    | 23 +++++--------------
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c  | 18 +++++++++++++++
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
index 766b1c96bc887..87e7e820810a8 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
@@ -12,6 +12,8 @@
 #include <sound/soc.h>
 #include <linux/of_graph.h>
 
+#include <drm/display/drm_hdmi_state_helper.h>
+
 #include "adv7511.h"
 
 static void adv7511_calc_cts_n(unsigned int f_tmds, unsigned int fs,
@@ -155,17 +157,8 @@ int adv7511_hdmi_audio_prepare(struct drm_bridge *bridge,
 	regmap_update_bits(adv7511->regmap, ADV7511_REG_I2C_FREQ_ID_CFG,
 			   ADV7511_I2C_FREQ_ID_CFG_RATE_MASK, rate << 4);
 
-	/* send current Audio infoframe values while updating */
-	regmap_update_bits(adv7511->regmap, ADV7511_REG_INFOFRAME_UPDATE,
-			   BIT(5), BIT(5));
-
-	regmap_write(adv7511->regmap, ADV7511_REG_AUDIO_INFOFRAME(0), 0x1);
-
-	/* use Audio infoframe updated info */
-	regmap_update_bits(adv7511->regmap, ADV7511_REG_INFOFRAME_UPDATE,
-			   BIT(5), 0);
-
-	return 0;
+	return drm_atomic_helper_connector_hdmi_update_audio_infoframe(connector,
+								       &hparms->cea);
 }
 
 int adv7511_hdmi_audio_startup(struct drm_bridge *bridge,
@@ -188,15 +181,9 @@ int adv7511_hdmi_audio_startup(struct drm_bridge *bridge,
 	/* not copyrighted */
 	regmap_update_bits(adv7511->regmap, ADV7511_REG_AUDIO_CFG1,
 				BIT(5), BIT(5));
-	/* enable audio infoframes */
-	regmap_update_bits(adv7511->regmap, ADV7511_REG_PACKET_ENABLE1,
-				BIT(3), BIT(3));
 	/* AV mute disable */
 	regmap_update_bits(adv7511->regmap, ADV7511_REG_GC(0),
 				BIT(7) | BIT(6), BIT(7));
-	/* use Audio infoframe updated info */
-	regmap_update_bits(adv7511->regmap, ADV7511_REG_INFOFRAME_UPDATE,
-				BIT(5), 0);
 
 	/* enable SPDIF receiver */
 	if (adv7511->audio_source == ADV7511_AUDIO_SOURCE_SPDIF)
@@ -214,4 +201,6 @@ void adv7511_hdmi_audio_shutdown(struct drm_bridge *bridge,
 	if (adv7511->audio_source == ADV7511_AUDIO_SOURCE_SPDIF)
 		regmap_update_bits(adv7511->regmap, ADV7511_REG_AUDIO_CONFIG,
 				   BIT(7), 0);
+
+	drm_atomic_helper_connector_hdmi_clear_audio_infoframe(connector);
 }
diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index 00d6417c177b4..9081c09fc136b 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -886,6 +886,9 @@ static int adv7511_bridge_hdmi_clear_infoframe(struct drm_bridge *bridge,
 	struct adv7511 *adv7511 = bridge_to_adv7511(bridge);
 
 	switch (type) {
+	case HDMI_INFOFRAME_TYPE_AUDIO:
+		adv7511_packet_disable(adv7511, ADV7511_PACKET_ENABLE_AUDIO_INFOFRAME);
+		break;
 	case HDMI_INFOFRAME_TYPE_AVI:
 		adv7511_packet_disable(adv7511, ADV7511_PACKET_ENABLE_AVI_INFOFRAME);
 		break;
@@ -906,6 +909,21 @@ static int adv7511_bridge_hdmi_write_infoframe(struct drm_bridge *bridge,
 	adv7511_bridge_hdmi_clear_infoframe(bridge, type);
 
 	switch (type) {
+	case HDMI_INFOFRAME_TYPE_AUDIO:
+		/* send current Audio infoframe values while updating */
+		regmap_update_bits(adv7511->regmap, ADV7511_REG_INFOFRAME_UPDATE,
+				   BIT(5), BIT(5));
+
+		/* The Audio infoframe id is not configurable */
+		regmap_bulk_write(adv7511->regmap, ADV7511_REG_AUDIO_INFOFRAME_VERSION,
+				  buffer + 1, len - 1);
+
+		/* use Audio infoframe updated info */
+		regmap_update_bits(adv7511->regmap, ADV7511_REG_INFOFRAME_UPDATE,
+				   BIT(5), 0);
+
+		adv7511_packet_enable(adv7511, ADV7511_PACKET_ENABLE_AUDIO_INFOFRAME);
+		break;
 	case HDMI_INFOFRAME_TYPE_AVI:
 		/* The AVI infoframe id is not configurable */
 		regmap_bulk_write(adv7511->regmap, ADV7511_REG_AVI_INFOFRAME_VERSION,
-- 
2.51.0



