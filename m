Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8203810A35;
	Mon,  4 Mar 2024 21:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588570; cv=none; b=Egev1EgnEcOSAytMREOrjmg0OdxavyGzy7TMfqdLX6DiY5urtDM+ZLR4eAc0Q8O8cZffY+EGbD3b50zo/jyYEUtjskobdCR98BwawatHEyMEzhefvvrAqhWLgRa+bDDw1+uDE21JhWiDzr0x47LOPinSH81i3KYL5Sz3IZlrbFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588570; c=relaxed/simple;
	bh=9gOys2KrK11OG7N9TMv48oCI5NofaklaiJSX6dLbnXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vjq7RAvenUYu+k9y37ZPYrUjbjX93BJrjIaVs4URSK0cZZGpN2v93jbWS/GCEoONVJDtnmac3gmZ5WNUFBWdnUE0jolv+PJ7r5KsX1zRfTkhBaL1Qn+F1gBV3xgHDHetdbOrjkkZMu+ywjg0r1UrNYSPZz86aomX0zCFa4RiOFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xm9RkAA4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xm9RkAA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EA6C433C7;
	Mon,  4 Mar 2024 21:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588570;
	bh=9gOys2KrK11OG7N9TMv48oCI5NofaklaiJSX6dLbnXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xm9RkAA4EcpTat1rTEPpD0vwmZkrvEV6MC4A4MriZhYKxBHVLgCPe5J5Rs81cZSwc
	 IpM2uPOCk3bNzwImeaSq2/2rgCcJeHU+2VQfk8MJa9BrbM89o9a0MYzj1Ab1UhvOZh
	 F8Z7ya62nALiTl5LM1nELHI5imNov9fVXHpvtrBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Morvai <stevemorvai@hotmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/215] drm/meson: Dont remove bridges which are created by other drivers
Date: Mon,  4 Mar 2024 21:21:06 +0000
Message-ID: <20240304211557.107735910@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit bd915ae73a2d78559b376ad2caf5e4ef51de2455 ]

Stop calling drm_bridge_remove() for bridges allocated/managed by other
drivers in the remove paths of meson_encoder_{cvbs,dsi,hdmi}.
drm_bridge_remove() unregisters the bridge so it cannot be used
anymore. Doing so for bridges we don't own can lead to the video
pipeline not being able to come up after -EPROBE_DEFER of the VPU
because we're unregistering a bridge that's managed by another driver.
The other driver doesn't know that we have unregistered it's bridge
and on subsequent .probe() we're not able to find those bridges anymore
(since nobody re-creates them).

This fixes probe errors on Meson8b boards with the CVBS outputs enabled.

Fixes: 09847723c12f ("drm/meson: remove drm bridges at aggregate driver unbind time")
Fixes: 42dcf15f901c ("drm/meson: add DSI encoder")
Cc:  <stable@vger.kernel.org>
Reported-by: Steve Morvai <stevemorvai@hotmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Tested-by: Steve Morvai <stevemorvai@hotmail.com>
Link: https://lore.kernel.org/r/20240215220442.1343152-1-martin.blumenstingl@googlemail.com
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240215220442.1343152-1-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_encoder_cvbs.c | 1 -
 drivers/gpu/drm/meson/meson_encoder_hdmi.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_encoder_cvbs.c b/drivers/gpu/drm/meson/meson_encoder_cvbs.c
index 3f73b211fa8e3..3407450435e20 100644
--- a/drivers/gpu/drm/meson/meson_encoder_cvbs.c
+++ b/drivers/gpu/drm/meson/meson_encoder_cvbs.c
@@ -294,6 +294,5 @@ void meson_encoder_cvbs_remove(struct meson_drm *priv)
 	if (priv->encoders[MESON_ENC_CVBS]) {
 		meson_encoder_cvbs = priv->encoders[MESON_ENC_CVBS];
 		drm_bridge_remove(&meson_encoder_cvbs->bridge);
-		drm_bridge_remove(meson_encoder_cvbs->next_bridge);
 	}
 }
diff --git a/drivers/gpu/drm/meson/meson_encoder_hdmi.c b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
index b14e6e507c61b..03062e7a02b64 100644
--- a/drivers/gpu/drm/meson/meson_encoder_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
@@ -472,6 +472,5 @@ void meson_encoder_hdmi_remove(struct meson_drm *priv)
 	if (priv->encoders[MESON_ENC_HDMI]) {
 		meson_encoder_hdmi = priv->encoders[MESON_ENC_HDMI];
 		drm_bridge_remove(&meson_encoder_hdmi->bridge);
-		drm_bridge_remove(meson_encoder_hdmi->next_bridge);
 	}
 }
-- 
2.43.0



