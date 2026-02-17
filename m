Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0C329A1;
	Tue, 17 Feb 2026 20:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361445; cv=none; b=E2PG6yo8P2BhuaX8QwV6Xfbv3wZAjzknKIQaGYkkP1gy7N4fHwR+bT/oXKxjY89F9yPmrRxSkIxIU2xnBZdUWatR1EyF2OVs22BLnTPu9PCkhKAj9759Q8w6VCG5PFUcL+tPatS03+oFZwQJxqFmUNPgBAYDvXMmCuMEHsp8DLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361445; c=relaxed/simple;
	bh=uROoIfET2fK7HuYXibIUhLvRcMdBeVf7WXOytRwfQlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRSXPwDFPZesYEYW2yF0ahTj4bVYU/WjNq20oHjeDrYG0tadkHWuR2awW+V8nmadqIUCwrXTi3gNOjWNWoxbPfMLnZHhZfoRMm5jiqXpaUBLfWwXmQCtcvxO1EpjrtPtnSaP9tuAc3XhPeTMT+sp4hfFserxA1kzy4yTook08pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iW5QP2Tv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iW5QP2Tv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1367BC4CEF7;
	Tue, 17 Feb 2026 20:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361445;
	bh=uROoIfET2fK7HuYXibIUhLvRcMdBeVf7WXOytRwfQlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iW5QP2TvI2/gQedbwv8x+zY3la57ggDBkwdXRhoGDKX4VwKVHskKMTnhdJPAiVwth
	 LL5srxeiJkPG9D/q0K99oD5or9CdlqmArH4LS9SgAM4wxju5DErvsAjMxzSuZWj1hY
	 WSiGYYDxT3z5GhMR3RZHD1YA5xTl2HhF8ykJ6HW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 19/43] ASoC: cs42l43: Correct handling of 3-pole jack load detection
Date: Tue, 17 Feb 2026 21:31:59 +0100
Message-ID: <20260217200007.204425917@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 867e23d4fb8d8..744488f371ea4 100644
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



