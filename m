Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F08320CD9;
	Tue, 17 Feb 2026 20:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360797; cv=none; b=A4sHvNShJpeTJCJZ316YTYo6zUS112rLURCW10ViDq1YDoJ+cLc+ScHC7q1jdDBzT2b2CaRwoq0Gr5rjKW3omfgh+vfvdZ5xHYj8/6l3AcOWKNcJIqnvl5i/dxIZztX6lpzCsTs3gyPucKEf2V1026kW/8ENcx/P1krtPPnBLDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360797; c=relaxed/simple;
	bh=vH+3UCbYcgHAJUGqhwg6CO60WTste+s9By89lqg7aqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7PRnAJB1RriTSias4xnXxJkgoUZLpGMZiGUEFGqHjnYzY8NQ0N/HZ0xtxDtxlQi79na9I1eaHl963lVpspAZiDYdZ+z4DeemLs1435s7evH9qI0pkK+y4aJYKVz/6DPx4VIkvvVNHEQiBsHG/BYep0H9JP29P1SNt6TtiOgp6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cE+cWztx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cE+cWztx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF39C4CEF7;
	Tue, 17 Feb 2026 20:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360797;
	bh=vH+3UCbYcgHAJUGqhwg6CO60WTste+s9By89lqg7aqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cE+cWztxncsEbhuZgFfYukWnBAv8fdyMt5a6VcRaT6/IOgc4QA6kTA3PC8OnB7+8m
	 Ht1mPKCUYOIqFiZZ1B5nJ87qeRW1a7Hos82KrP+P5VGPhplRL1mTGo0fW1p/BD+5Wz
	 OKXBFgjydHVb0J64BJRm2Kmt6zSD3LF6uf1HW5/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 18/39] ASoC: cs42l43: Correct handling of 3-pole jack load detection
Date: Tue, 17 Feb 2026 21:30:40 +0100
Message-ID: <20260217200004.921095438@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit e77a4081d7e324dfa876a9560b2a78969446ba82 ]

The load detection process for 3-pole jacks requires slightly
updated reference values to ensure an accurate result. Update
the code to apply different tunings for the 3-pole and 4-pole
cases. This also updates the thresholds overall so update the
relevant comments to match.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260130150927.2964664-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l43-jack.c | 37 +++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/cs42l43-jack.c b/sound/soc/codecs/cs42l43-jack.c
index 6d8455c1bee6d..f58d55d77693f 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -496,7 +496,23 @@ void cs42l43_bias_sense_timeout(struct work_struct *work)
 	pm_runtime_put_autosuspend(priv->dev);
 }
 
-static void cs42l43_start_load_detect(struct cs42l43_codec *priv)
+static const struct reg_sequence cs42l43_3pole_patch[] = {
+	{ 0x4000,	0x00000055 },
+	{ 0x4000,	0x000000AA },
+	{ 0x17420,	0x8500F300 },
+	{ 0x17424,	0x36003E00 },
+	{ 0x4000,	0x00000000 },
+};
+
+static const struct reg_sequence cs42l43_4pole_patch[] = {
+	{ 0x4000,	0x00000055 },
+	{ 0x4000,	0x000000AA },
+	{ 0x17420,	0x7800E600 },
+	{ 0x17424,	0x36003800 },
+	{ 0x4000,	0x00000000 },
+};
+
+static void cs42l43_start_load_detect(struct cs42l43_codec *priv, bool mic)
 {
 	struct cs42l43 *cs42l43 = priv->core;
 
@@ -520,6 +536,15 @@ static void cs42l43_start_load_detect(struct cs42l43_codec *priv)
 			dev_err(priv->dev, "Load detect HP power down timed out\n");
 	}
 
+	if (mic)
+		regmap_multi_reg_write_bypassed(cs42l43->regmap,
+						cs42l43_4pole_patch,
+						ARRAY_SIZE(cs42l43_4pole_patch));
+	else
+		regmap_multi_reg_write_bypassed(cs42l43->regmap,
+						cs42l43_3pole_patch,
+						ARRAY_SIZE(cs42l43_3pole_patch));
+
 	regmap_update_bits(cs42l43->regmap, CS42L43_BLOCK_EN3,
 			   CS42L43_ADC1_EN_MASK | CS42L43_ADC2_EN_MASK, 0);
 	regmap_update_bits(cs42l43->regmap, CS42L43_DACCNFG2, CS42L43_HP_HPF_EN_MASK, 0);
@@ -598,7 +623,7 @@ static int cs42l43_run_load_detect(struct cs42l43_codec *priv, bool mic)
 
 	reinit_completion(&priv->load_detect);
 
-	cs42l43_start_load_detect(priv);
+	cs42l43_start_load_detect(priv, mic);
 	time_left = wait_for_completion_timeout(&priv->load_detect,
 						msecs_to_jiffies(CS42L43_LOAD_TIMEOUT_MS));
 	cs42l43_stop_load_detect(priv);
@@ -622,11 +647,11 @@ static int cs42l43_run_load_detect(struct cs42l43_codec *priv, bool mic)
 	}
 
 	switch (val & CS42L43_AMP3_RES_DET_MASK) {
-	case 0x0: // low impedance
-	case 0x1: // high impedance
+	case 0x0: // < 22 Ohm impedance
+	case 0x1: // < 150 Ohm impedance
+	case 0x2: // < 1000 Ohm impedance
 		return CS42L43_JACK_HEADPHONE;
-	case 0x2: // lineout
-	case 0x3: // Open circuit
+	case 0x3: // > 1000 Ohm impedance
 		return CS42L43_JACK_LINEOUT;
 	default:
 		return -EINVAL;
-- 
2.51.0



