Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8506156C5E;
	Mon,  6 Jan 2025 15:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177712; cv=none; b=a/BJKy6cGrCzTZ7CohS5Ow567VBJw+0CYKcSO2Wd2sVTztD67NsWMRh3KdMQAEmbAsd07BSRQKoPBgJ9yhUbh/0WDKE45bButiImvaDG1JA7MzI/q9EPggzBLvmPZqzU1TfXSV90/A/paMv5FEkNY3OWu5iQbVq58XNTzs55+L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177712; c=relaxed/simple;
	bh=bQHIWGTOf10DSctQyPd6Q5LWEOOavA+msEQd4G/kp5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exCF1G8ftVXfMSAVMuY9gB7iXzMwkLuet+dkfO1KNKkmHhS/iaciueltQVEX4AZl/nK5ED4uax7JIQA4QCanpTj5LpPUL9G1XD50k6+OX6aPFnXCsJ2ZlfezU93+fzRYRYa4Ac5oAZ248uc029ZUpH4/iLdzJKa0K/fQHYaGsAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFwow7mP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFwow7mP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F122AC4CED2;
	Mon,  6 Jan 2025 15:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177712;
	bh=bQHIWGTOf10DSctQyPd6Q5LWEOOavA+msEQd4G/kp5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFwow7mPgbHlCPI9nIWmfA7kYDqF+jUdiXaHJ0/E17Ru/bFwNsdgSXqVh4On3efMi
	 2FyhUNiU7aDchk2E2nBtInNd2jV944Db+BmlvzCizaFWB+XCuMOrM6oNj7Pl/gLLMQ
	 u6fXbOY4irW2eAW1TBRU6mtpf33/AEV7NmkjX6Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Stefan Ekenberg <stefan.ekenberg@axis.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/156] drm/bridge: adv7511_audio: Update Audio InfoFrame properly
Date: Mon,  6 Jan 2025 16:15:18 +0100
Message-ID: <20250106151142.947968882@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 61f4a38e7d2b..8f786592143b 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
@@ -153,7 +153,16 @@ static int adv7511_hdmi_hw_params(struct device *dev, void *data,
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
@@ -184,8 +193,9 @@ static int audio_startup(struct device *dev, void *data)
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



