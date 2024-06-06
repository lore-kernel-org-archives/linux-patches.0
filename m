Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BE71B1434;
	Thu,  6 Jun 2024 14:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683386; cv=none; b=R04IW2uTMQk9rRlnF+tbCP3UKg/LNFdp8ZrGLizVhjXrujqAeEJ2xhJ+8EslBqXwP5aBqePdHlJleptYBoks5619EFTs4rvp26QPteA1sNnl0yod0W/9y43+2I6h4pUURDHW+wW4VbP5CETdYHqJJmBB8bzwsWXUPvmbDJhCfuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683386; c=relaxed/simple;
	bh=yjxjfu2Dmw2QiNmp8IAKKTboVJBPqNiTzyHohj+z35Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIhTQMn7eu68legK0NmbPPKHVHn+Z8mVgeIJjCTztuOcZbPBRVw+RE8WpviAImkGAk+/QrF24mfa/nMvmIb87v9pdD9hmR2CbNjT7oSOe7qzWQqfRK3ztNa7FIalO6dyawE+mzZN+0QtB93ACb5L//QiPwpxF/e1GBu11rE1LDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHUSXnpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHUSXnpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D848CC2BD10;
	Thu,  6 Jun 2024 14:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683385;
	bh=yjxjfu2Dmw2QiNmp8IAKKTboVJBPqNiTzyHohj+z35Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHUSXnpE+iuommYl63bWZDtr1e28AhZRaO7iGx2HPU3bB8f8bONbLViPl6K9PAWeD
	 ypPz/X28/XkJAU/CzMtsZKLlZeyJn1qNno301+6RRcRuQcXd1OL9eC1Qf4k6E+fIEw
	 mp7hu9CeSqT3PZ9t7rDj3uo68omI+4m7cnGbSI+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 327/744] drm/bridge: anx7625: Update audio status while detecting
Date: Thu,  6 Jun 2024 15:59:59 +0200
Message-ID: <20240606131742.924974471@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit a665b4e60369867cddf50f37f16169a3e2f434ad ]

Previously, the audio status was not updated during detection, leading
to a persistent audio despite hot plugging events. To resolve this
issue, update the audio status during detection.

Fixes: 566fef1226c1 ("drm/bridge: anx7625: add HDMI audio function")
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240416-anx7625-v3-1-f916ae31bdd7@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 4ee5614a26236..c1191ef5e8e67 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2479,15 +2479,22 @@ static void anx7625_bridge_atomic_disable(struct drm_bridge *bridge,
 	mutex_unlock(&ctx->aux_lock);
 }
 
+static void
+anx7625_audio_update_connector_status(struct anx7625_data *ctx,
+				      enum drm_connector_status status);
+
 static enum drm_connector_status
 anx7625_bridge_detect(struct drm_bridge *bridge)
 {
 	struct anx7625_data *ctx = bridge_to_anx7625(bridge);
 	struct device *dev = ctx->dev;
+	enum drm_connector_status status;
 
 	DRM_DEV_DEBUG_DRIVER(dev, "drm bridge detect\n");
 
-	return anx7625_sink_detect(ctx);
+	status = anx7625_sink_detect(ctx);
+	anx7625_audio_update_connector_status(ctx, status);
+	return status;
 }
 
 static struct edid *anx7625_bridge_get_edid(struct drm_bridge *bridge,
-- 
2.43.0



