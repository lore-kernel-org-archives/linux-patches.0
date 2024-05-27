Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3F717727;
	Mon, 27 May 2024 19:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838488; cv=none; b=DXspZewZYLWINcEDV7qGLN2G3b7ux1vzcWw1QJqDmCiDEStptrddSGlFq/KA5ZdavcOUKvaEIi/35I+nmKtdqyq6jtDmEdcmzzdsIoLodmQD8uAMq5cVm0UYJyuimalp7izcdxJRF3IOFjSA/MqAJvIJFoHvjItCq/xuKcDx81U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838488; c=relaxed/simple;
	bh=jwb4LYiBq9kt/QKRSsOKNBFsocf9qcil9FSp77YFa2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDwrociIsRTT1ZPZBtXcbvcO4/pDBRKTH18rXPrzpGn7CniTF/Va/7t/cWkzjpbTYuCeRfNMDl+CtBbWhlCVBlHGpMC5JoLUj3+iJCEX33Q5CreZ1YDHTsCs4gUOiLyMRm3EnoJyPcWaIdh2k+GiBsLegKz/OxDXyp2uge3BpgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuWYPuL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuWYPuL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E74AC2BBFC;
	Mon, 27 May 2024 19:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838488;
	bh=jwb4LYiBq9kt/QKRSsOKNBFsocf9qcil9FSp77YFa2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uuWYPuL903uMibOjCCWkT85gKWBvnNo6mq5OjASNcs0ca7U8pVL4gkysujqKdYpxv
	 0WfdapgNWfj1GDF0ZNP4gT7AVQALn1kWk377hBGMklF+GyGHMrxPDkvcd97W7am+OC
	 +QibzEfDtcine+QEvdVaEismSqnIV8KRJVd1J3J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 412/493] drm/bridge: anx7625: Update audio status while detecting
Date: Mon, 27 May 2024 20:56:54 +0200
Message-ID: <20240527185643.778681793@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



