Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA9E3D45CB;
	Tue, 16 Jun 2026 18:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633310; cv=none; b=AafaB4Aj6nFxUZPoXSqmT+lOGs417W3rBTgAKg4z4AJWpEe1Kf2vQ6/bQSYzcqVWudBKtVeSdDoHYtOxs/Q9G5SKMf+W2jzvCgA6Gp1HRlLl0Nd6S8aQWz7oIwm9m+i0JWYdrOOtufStL5npfm9HhxP8JJ3E5DB7gsmidsPEU1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633310; c=relaxed/simple;
	bh=rAqgg9p3bl6+O11kxvp30IxSpJK/Ny9C42v4DWe9Wpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nI9K/uYhGlkZmQmN0w0aZESXaZ6A3u2+oh+Sz9Tqb/+CSQ8UIMAd//u44C4F/yGXMZUoPvjAzyBKEGx52Ig/uKk4peU1dJoDb/6xY1I8vS5mCfPxBUuHI7D1XDbzDkBJcXz1zUiYLaC6N1+4gsLPHmLzUHG8J848PnPNwaymopo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0aXNyXkA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0aXNyXkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCF01F000E9;
	Tue, 16 Jun 2026 18:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633309;
	bh=gqfC3SyspXqVH/5Prohhx4dXUiP5ljFT4LiIKvbCMBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0aXNyXkA6HWdBfOL77A4fKDQgErc0IwJYvLX55jzTnVtgKme6X1sZWseS9UVjLkFS
	 yuDEWQvv16/7BtMnd0OR0jexe6RtswQ6S0HUut8fFSclcZW6jMRTzWX5+7vmEb/ll5
	 lfq7lNTWKoHu/XMymr1gAeEFpQzDem5wiqlf4X4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/411] ASoC: Intel: bytcht_es8316: Fix MCLK leak on init errors
Date: Tue, 16 Jun 2026 20:24:19 +0530
Message-ID: <20260616145101.508642845@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 923e69c7695c29..d54bc667175f50 100644
--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -39,6 +39,7 @@ struct byt_cht_es8316_private {
 	struct gpio_desc *speaker_en_gpio;
 	struct device *codec_dev;
 	bool speaker_en;
+	bool mclk_enabled;
 };
 
 enum {
@@ -169,6 +170,15 @@ static struct snd_soc_jack_pin byt_cht_es8316_jack_pins[] = {
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
 	struct snd_soc_component *codec = asoc_rtd_to_codec(runtime, 0)->component;
@@ -225,12 +235,14 @@ static int byt_cht_es8316_init(struct snd_soc_pcm_runtime *runtime)
 	ret = clk_prepare_enable(priv->mclk);
 	if (ret)
 		dev_err(card->dev, "unable to enable MCLK\n");
+	else
+		priv->mclk_enabled = true;
 
 	ret = snd_soc_dai_set_sysclk(asoc_rtd_to_codec(runtime, 0), 0, 19200000,
 				     SND_SOC_CLOCK_IN);
 	if (ret < 0) {
 		dev_err(card->dev, "can't set codec clock %d\n", ret);
-		return ret;
+		goto err_disable_mclk;
 	}
 
 	ret = snd_soc_card_jack_new(card, "Headset",
@@ -239,13 +251,25 @@ static int byt_cht_es8316_init(struct snd_soc_pcm_runtime *runtime)
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
@@ -355,6 +379,7 @@ static struct snd_soc_dai_link byt_cht_es8316_dais[] = {
 		.dpcm_playback = 1,
 		.dpcm_capture = 1,
 		.init = byt_cht_es8316_init,
+		.exit = byt_cht_es8316_exit,
 		SND_SOC_DAILINK_REG(ssp2_port, ssp2_codec, platform),
 	},
 };
-- 
2.53.0



