Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5452284B3B;
	Tue, 17 Feb 2026 20:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361604; cv=none; b=ubbKHrGbM4jNhGqJ509dkWozwGVfGUjs4aPA63q6SEVKkmWB4fYRhBLukbSOGYb8Eg8DiGyl0z/uSRedN8e3erAEwLq6zRu01PU3vTqsC7TgdHyCbUGGnDDGK03BS0p32XkPsADqmC9y6kZs/3Q+wrvFV6dU0243fasRTp6wzOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361604; c=relaxed/simple;
	bh=hXdeKkB1Iscuk5zDDTaUPqmX0mpCTWaUE2ux551ZZto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzrXvsHvqilXhd/3r3CrIa24qY3pKfgrsH/q8JWCYXJ53sqwPHAKyy0MGYnG3nq2l1gpUyCn2+/YmPjkswUzpX+KhK2XtxQWFwYR+EA0cFyeabU+WZxOfAndfcXeGGcUhuyLckd+4IMjR6axfLH+J1MhH5AIJUbq7FDzpgUHAO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DryCeHwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DryCeHwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37963C4CEF7;
	Tue, 17 Feb 2026 20:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361604;
	bh=hXdeKkB1Iscuk5zDDTaUPqmX0mpCTWaUE2ux551ZZto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DryCeHwFPIGlTTofSBd6PZqKWy224r8rAX3aD8Sidj+70Cuk/cZ4iahTImdrNkf/o
	 86uH0fg7KZOEgVUjUJ5nRSGNR46Y+dScWuwBLRsswOos4eyG9AX1OIV53VdP/fg70P
	 mvNpOPu3bOcfRtXZsrY5ySMyAlPkMSa+HcdOpo3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 20/42] ASoC: cs42l43: Correct handling of 3-pole jack load detection
Date: Tue, 17 Feb 2026 21:32:11 +0100
Message-ID: <20260217200006.775771458@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 984a7f470a31f..aa0062f3aa918 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -508,7 +508,23 @@ void cs42l43_bias_sense_timeout(struct work_struct *work)
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
 
@@ -532,6 +548,15 @@ static void cs42l43_start_load_detect(struct cs42l43_codec *priv)
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
@@ -610,7 +635,7 @@ static int cs42l43_run_load_detect(struct cs42l43_codec *priv, bool mic)
 
 	reinit_completion(&priv->load_detect);
 
-	cs42l43_start_load_detect(priv);
+	cs42l43_start_load_detect(priv, mic);
 	time_left = wait_for_completion_timeout(&priv->load_detect,
 						msecs_to_jiffies(CS42L43_LOAD_TIMEOUT_MS));
 	cs42l43_stop_load_detect(priv);
@@ -634,11 +659,11 @@ static int cs42l43_run_load_detect(struct cs42l43_codec *priv, bool mic)
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



