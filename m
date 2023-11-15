Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD0E3A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWRW4oUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA62CC433C8;
	Wed, 15 Nov 2023 19:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077311;
	bh=E1xBuSirc7YgSxmLytE7KQgDeuHqJRbYhDVIbuYJ6xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWRW4oUDf7g6lOES3nWwE3HfL/Otk9+bhFkm+UVF3zrLG04O2iHneh/fMFaUdLTQ4
	 qVRmhik2Hr80i7gd5aywiW1QEsch2PbcapmJUnPq3fmerdg14nguIKxkIOck5MMBdu
	 6NmnLQYa87zlijKnhr59zKfIcp1CFw3wVrVch52U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 225/603] drm/bridge: lt8912b: Fix bridge_detach
Date: Wed, 15 Nov 2023 14:12:50 -0500
Message-ID: <20231115191628.781528897@linuxfoundation.org>
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

[ Upstream commit 941882a0e96d245f38116e940912b404b6a93c6f ]

The driver calls lt8912_bridge_detach() from its lt8912_remove()
function. As the DRM core detaches bridges automatically, this leads to
calling lt8912_bridge_detach() twice. The code probably has tried to
manage the double-call with the 'is_attached' variable, but the driver
never sets the variable to false, so its of no help.

Fix the issue by dropping the call to lt8912_bridge_detach() from
lt8912_remove(), as the DRM core will handle the detach call for us,
and also drop the useless is_attached field.

Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230804-lt8912b-v1-1-c542692c6a2f@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
index 4eaea67fb71c2..0e581f6e3c885 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -45,7 +45,6 @@ struct lt8912 {
 
 	u8 data_lanes;
 	bool is_power_on;
-	bool is_attached;
 };
 
 static int lt8912_write_init_config(struct lt8912 *lt)
@@ -575,8 +574,6 @@ static int lt8912_bridge_attach(struct drm_bridge *bridge,
 	if (ret)
 		goto error;
 
-	lt->is_attached = true;
-
 	return 0;
 
 error:
@@ -588,15 +585,13 @@ static void lt8912_bridge_detach(struct drm_bridge *bridge)
 {
 	struct lt8912 *lt = bridge_to_lt8912(bridge);
 
-	if (lt->is_attached) {
-		lt8912_hard_power_off(lt);
+	lt8912_hard_power_off(lt);
 
-		if (lt->hdmi_port->ops & DRM_BRIDGE_OP_HPD)
-			drm_bridge_hpd_disable(lt->hdmi_port);
+	if (lt->hdmi_port->ops & DRM_BRIDGE_OP_HPD)
+		drm_bridge_hpd_disable(lt->hdmi_port);
 
-		drm_connector_unregister(&lt->connector);
-		drm_connector_cleanup(&lt->connector);
-	}
+	drm_connector_unregister(&lt->connector);
+	drm_connector_cleanup(&lt->connector);
 }
 
 static enum drm_connector_status
@@ -750,7 +745,6 @@ static void lt8912_remove(struct i2c_client *client)
 {
 	struct lt8912 *lt = i2c_get_clientdata(client);
 
-	lt8912_bridge_detach(&lt->bridge);
 	drm_bridge_remove(&lt->bridge);
 	lt8912_free_i2c(lt);
 	lt8912_put_dt(lt);
-- 
2.42.0



