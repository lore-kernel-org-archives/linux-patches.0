Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6431F13AA2F;
	Tue, 27 Feb 2024 13:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041994; cv=none; b=EfB7sfUgsN0JkQvPKKoybtZDJQB5XMoZOKW5GP3E9T5O/e2bo9uLcZdsUFGqCIBLn71kpglPmaIjOa0+mUXaklddsOO53wHRbI4YJD8gyNMUz+uZf0SjJiLDaqYvBJtkIeUIW/9mqY1uc91sOdqYGzM00BrxNVFHhS2Qgssam+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041994; c=relaxed/simple;
	bh=8HFGIwpnrN3EuyznFBkLuu2TwlaF1It+VWB+Z2TM9Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sj5y4+KkzaB0ghR/WCSjRs2Zp3EI2Ul/JxMR2wlNJA+dwXxNtz0ilhVgOldQWyTdGkwi+wOlpJPqOxF6cKqj6qd1/Lso5qzzhWgk4ZbieMPvc4ME0bjqQu0kvA+BeBqlFXboRy2+wPvjwbG0pOIcgTBtM4txFzOH7QvIW9x4PKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdPaIXL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdPaIXL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EAAC433F1;
	Tue, 27 Feb 2024 13:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041994;
	bh=8HFGIwpnrN3EuyznFBkLuu2TwlaF1It+VWB+Z2TM9Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NdPaIXL/plDg9buUjRtyBwk0+f/ZR2qvbjLVoJXn5dUcaAfdivHYQm2Xn10ABr5QN
	 6zD+s2j6bsRw7Wej858vWsyHyKGX1/qvs32/W+c6VfVFMSBfPFTEb/kqS+bPYClHQL
	 b8MQP2bhFequkTnHHAWdEKylqIcAhbiPi6tWtum0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Morvai <stevemorvai@hotmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.6 141/299] drm/meson: Dont remove bridges which are created by other drivers
Date: Tue, 27 Feb 2024 14:24:12 +0100
Message-ID: <20240227131630.393243437@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

commit bd915ae73a2d78559b376ad2caf5e4ef51de2455 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/meson/meson_encoder_cvbs.c |    1 -
 drivers/gpu/drm/meson/meson_encoder_dsi.c  |    1 -
 drivers/gpu/drm/meson/meson_encoder_hdmi.c |    1 -
 3 files changed, 3 deletions(-)

--- a/drivers/gpu/drm/meson/meson_encoder_cvbs.c
+++ b/drivers/gpu/drm/meson/meson_encoder_cvbs.c
@@ -294,6 +294,5 @@ void meson_encoder_cvbs_remove(struct me
 	if (priv->encoders[MESON_ENC_CVBS]) {
 		meson_encoder_cvbs = priv->encoders[MESON_ENC_CVBS];
 		drm_bridge_remove(&meson_encoder_cvbs->bridge);
-		drm_bridge_remove(meson_encoder_cvbs->next_bridge);
 	}
 }
--- a/drivers/gpu/drm/meson/meson_encoder_dsi.c
+++ b/drivers/gpu/drm/meson/meson_encoder_dsi.c
@@ -168,6 +168,5 @@ void meson_encoder_dsi_remove(struct mes
 	if (priv->encoders[MESON_ENC_DSI]) {
 		meson_encoder_dsi = priv->encoders[MESON_ENC_DSI];
 		drm_bridge_remove(&meson_encoder_dsi->bridge);
-		drm_bridge_remove(meson_encoder_dsi->next_bridge);
 	}
 }
--- a/drivers/gpu/drm/meson/meson_encoder_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
@@ -474,6 +474,5 @@ void meson_encoder_hdmi_remove(struct me
 	if (priv->encoders[MESON_ENC_HDMI]) {
 		meson_encoder_hdmi = priv->encoders[MESON_ENC_HDMI];
 		drm_bridge_remove(&meson_encoder_hdmi->bridge);
-		drm_bridge_remove(meson_encoder_hdmi->next_bridge);
 	}
 }


