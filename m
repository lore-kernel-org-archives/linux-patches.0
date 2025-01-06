Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9DA1DE4C7;
	Mon,  6 Jan 2025 15:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178397; cv=none; b=dgAmIBgD2cSEgWlvUVhgoUr/VU/j9e1tKmuoUQdV33ltjwZfhsB6WjP4flD0sqP5sAmTZ/M8To4cfKWDm046Vyic0omjd3m00KHuZtFLGa7bKW/tL3vxtORhM90EwbM0medkW43wxImu4diy6nVyPirlSu8NiMm1w4CkvJHDNG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178397; c=relaxed/simple;
	bh=kQtMKtAYsY1FZ2rh9tM0mfLa6s+Ra8FRAHcBPhuhJTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3Jz6eGtiec0YtH68hGd9QAi41+KA6sTgq9zEoUFaIA2lBz7DZp8XiFhWoPaUGg+7jqr2JnxxM7Fyt6we+YxQWvYZWB7tGgpGFOxhzH247mx2+3oCsVqcLGP4efowwE5WUizQK2Kj4ccAxClNT9TGOtFCam4lgHkC72Qk8LhKKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OIEzxvCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OIEzxvCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64D2C4CED6;
	Mon,  6 Jan 2025 15:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178397;
	bh=kQtMKtAYsY1FZ2rh9tM0mfLa6s+Ra8FRAHcBPhuhJTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OIEzxvCE3rQMMEb9Kj8PWeE8yy8zJ5FqSTAh2ur8SMr8qwqdoSJpMye6AUuFXB/Cf
	 gcN3DvnKQQDJ/C3UAVovdsIJT17Aef9ZwoYtuXDdw7o+pFVec9QYnalSGaSN6/7JAa
	 1xhVyQP5g/cmFyrpEzGlivNUorcjA9MzE64vIATg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Stefan Ekenberg <stefan.ekenberg@axis.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/138] drm/bridge: adv7511_audio: Update Audio InfoFrame properly
Date: Mon,  6 Jan 2025 16:17:09 +0100
Message-ID: <20250106151137.206501408@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Ekenberg <stefan.ekenberg@axis.com>

[ Upstream commit 902806baf3c1e8383c1fe3ff0b6042b8cb5c2707 ]

AUDIO_UPDATE bit (Bit 5 of MAIN register 0x4A) needs to be set to 1
while updating Audio InfoFrame information and then set to 0 when done.
Otherwise partially updated Audio InfoFrames could be sent out. Two
cases where this rule were not followed are fixed:
 - In adv7511_hdmi_hw_params() make sure AUDIO_UPDATE bit is updated
   before/after setting ADV7511_REG_AUDIO_INFOFRAME.
 - In audio_startup() use the correct register for clearing
   AUDIO_UPDATE bit.

The problem with corrupted audio infoframes were discovered by letting
a HDMI logic analyser check the output of ADV7535.

Note that this patchs replaces writing REG_GC(1) with
REG_INFOFRAME_UPDATE. Bit 5 of REG_GC(1) is positioned within field
GC_PP[3:0] and that field doesn't control audio infoframe and is read-
only. My conclusion therefore was that the author if this code meant to
clear bit 5 of REG_INFOFRAME_UPDATE from the very beginning.

Tested-by: Biju Das <biju.das.jz@bp.renesas.com>
Fixes: 53c515befe28 ("drm/bridge: adv7511: Add Audio support")
Signed-off-by: Stefan Ekenberg <stefan.ekenberg@axis.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241119-adv7511-audio-info-frame-v4-1-4ae68e76c89c@axis.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
index f101dd2819b5..0a1ac11e2e4f 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
@@ -147,7 +147,16 @@ int adv7511_hdmi_hw_params(struct device *dev, void *data,
 			   ADV7511_AUDIO_CFG3_LEN_MASK, len);
 	regmap_update_bits(adv7511->regmap, ADV7511_REG_I2C_FREQ_ID_CFG,
 			   ADV7511_I2C_FREQ_ID_CFG_RATE_MASK, rate << 4);
-	regmap_write(adv7511->regmap, 0x73, 0x1);
+
+	/* send current Audio infoframe values while updating */
+	regmap_update_bits(adv7511->regmap, ADV7511_REG_INFOFRAME_UPDATE,
+			   BIT(5), BIT(5));
+
+	regmap_write(adv7511->regmap, ADV7511_REG_AUDIO_INFOFRAME(0), 0x1);
+
+	/* use Audio infoframe updated info */
+	regmap_update_bits(adv7511->regmap, ADV7511_REG_INFOFRAME_UPDATE,
+			   BIT(5), 0);
 
 	return 0;
 }
@@ -178,8 +187,9 @@ static int audio_startup(struct device *dev, void *data)
 	regmap_update_bits(adv7511->regmap, ADV7511_REG_GC(0),
 				BIT(7) | BIT(6), BIT(7));
 	/* use Audio infoframe updated info */
-	regmap_update_bits(adv7511->regmap, ADV7511_REG_GC(1),
+	regmap_update_bits(adv7511->regmap, ADV7511_REG_INFOFRAME_UPDATE,
 				BIT(5), 0);
+
 	/* enable SPDIF receiver */
 	if (adv7511->audio_source == ADV7511_AUDIO_SOURCE_SPDIF)
 		regmap_update_bits(adv7511->regmap, ADV7511_REG_AUDIO_CONFIG,
-- 
2.39.5



