Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBEC234994;
	Sun,  7 Jun 2026 10:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826840; cv=none; b=Rs0wkDONZS16KsXMhrW6ATCQVZzVKhTDg5E40fLByBnKd9DKtJEXbIJNCavjhxHGigwZecKP6uvzABEr7BPHV4vQc5yGOSy4xVbbw2/+MY+FkuOECiz8QywaeOqqKJUnWLIGdIX+CCS52Ljhv6LlcMAn+qxKkipXPncHnqMa8ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826840; c=relaxed/simple;
	bh=ZbbotknhWcylVXe8sNN7jpS1lkiwVUj2xG5xrTtJMFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O8i4vsulkIsTgBegXKY6UFNwRP27PkFqv8vhFs51l5EbBcEn9sIGQAarUhQlARfjP9h3hryZCy0oa/gKDPUijRhvFJnQWMTCdlTVnNd6qwOQDwwTCNm1h9sDu2or+vDrjfscRxOEJ1k5NBkWO7jgrR50PfeUyqLQ1fU1/CY/fwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnagz0ZA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnagz0ZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8781F00893;
	Sun,  7 Jun 2026 10:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826839;
	bh=Ty25WKT8XsLbvQ//0KlOqYSav23lSOz+L55OS3rJ/+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wnagz0ZAVmPAnmgRTwuEXwpNHS2DyOTzdTpC/hFHTflaZu9nyeIzqapSjQbcxRKt7
	 Tv+Kf53TcbuIeVbLKLpWtB53+NdgRLSg/tdJ0u2rhPfyzIHVubmZhZu+N4GoyUaOQk
	 ZWEcVezA69TAHw9seDCZ5XdgWH+OdmA3SY/y+fZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 034/332] ASoC: Intel: bytcht_es8316: Fix MCLK leak on init errors
Date: Sun,  7 Jun 2026 11:56:43 +0200
Message-ID: <20260607095729.348996909@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit afb2a3a9d8369d18122a0d7cd294eba9a98259c6 ]

byt_cht_es8316_init() enables MCLK before configuring the codec sysclk
and creating the headset jack. If either of those later steps fails, the
function returns without disabling MCLK, leaving the clock enabled after
card registration fails.

Track whether this driver enabled MCLK and disable it on the init error
paths. Add the matching DAI link exit callback so the same clock enable
is also balanced when ASoC cleans up a successfully initialized link.

Fixes: a03bdaa565cb ("ASoC: Intel: add machine driver for BYT/CHT + ES8316")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260519-asoc-bytcht-es8316-mclk-leak-v1-1-b4a11cdc2afd@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcht_es8316.c | 29 ++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/boards/bytcht_es8316.c b/sound/soc/intel/boards/bytcht_es8316.c
index 192e2a394ff3d0..ea387dc7427382 100644
--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -40,6 +40,7 @@ struct byt_cht_es8316_private {
 	struct gpio_desc *speaker_en_gpio;
 	struct device *codec_dev;
 	bool speaker_en;
+	bool mclk_enabled;
 };
 
 enum {
@@ -170,6 +171,15 @@ static struct snd_soc_jack_pin byt_cht_es8316_jack_pins[] = {
 	},
 };
 
+static void byt_cht_es8316_disable_mclk(struct byt_cht_es8316_private *priv)
+{
+	if (!priv->mclk_enabled)
+		return;
+
+	clk_disable_unprepare(priv->mclk);
+	priv->mclk_enabled = false;
+}
+
 static int byt_cht_es8316_init(struct snd_soc_pcm_runtime *runtime)
 {
 	struct snd_soc_component *codec = snd_soc_rtd_to_codec(runtime, 0)->component;
@@ -227,12 +237,14 @@ static int byt_cht_es8316_init(struct snd_soc_pcm_runtime *runtime)
 	ret = clk_prepare_enable(priv->mclk);
 	if (ret)
 		dev_err(card->dev, "unable to enable MCLK\n");
+	else
+		priv->mclk_enabled = true;
 
 	ret = snd_soc_dai_set_sysclk(snd_soc_rtd_to_codec(runtime, 0), 0, 19200000,
 				     SND_SOC_CLOCK_IN);
 	if (ret < 0) {
 		dev_err(card->dev, "can't set codec clock %d\n", ret);
-		return ret;
+		goto err_disable_mclk;
 	}
 
 	ret = snd_soc_card_jack_new_pins(card, "Headset",
@@ -241,13 +253,25 @@ static int byt_cht_es8316_init(struct snd_soc_pcm_runtime *runtime)
 					 ARRAY_SIZE(byt_cht_es8316_jack_pins));
 	if (ret) {
 		dev_err(card->dev, "jack creation failed %d\n", ret);
-		return ret;
+		goto err_disable_mclk;
 	}
 
 	snd_jack_set_key(priv->jack.jack, SND_JACK_BTN_0, KEY_PLAYPAUSE);
 	snd_soc_component_set_jack(codec, &priv->jack, NULL);
 
 	return 0;
+
+err_disable_mclk:
+	byt_cht_es8316_disable_mclk(priv);
+	return ret;
+}
+
+static void byt_cht_es8316_exit(struct snd_soc_pcm_runtime *runtime)
+{
+	struct snd_soc_card *card = runtime->card;
+	struct byt_cht_es8316_private *priv = snd_soc_card_get_drvdata(card);
+
+	byt_cht_es8316_disable_mclk(priv);
 }
 
 static int byt_cht_es8316_codec_fixup(struct snd_soc_pcm_runtime *rtd,
@@ -353,6 +377,7 @@ static struct snd_soc_dai_link byt_cht_es8316_dais[] = {
 						| SND_SOC_DAIFMT_CBC_CFC,
 		.be_hw_params_fixup = byt_cht_es8316_codec_fixup,
 		.init = byt_cht_es8316_init,
+		.exit = byt_cht_es8316_exit,
 		SND_SOC_DAILINK_REG(ssp2_port, ssp2_codec, platform),
 	},
 };
-- 
2.53.0



