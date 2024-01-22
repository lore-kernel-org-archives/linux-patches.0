Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936B642A8D;
	Tue, 23 Jan 2024 00:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968458; cv=none; b=iWBYv/6kfdXya5Y+12fqwyBbymPObjIM5kk5xyGzpIuMDOgx0TIU0BEPJWH/JVbk6WX5DOQ+/p0HBrv2OtWtEXimSBE9bfi1pAwM9kWSDInbQbnnnQQGx+yc5XErPXMMWA9MFnBdJPLVw0RJ3IaUg2tsNupA/Ly9cSuLlU2kkRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968458; c=relaxed/simple;
	bh=POjRZA56w6UvqC9BeCY9jTcD4ZRe+704RqH/jsUb4V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vf6o/wK6JRIM8GIuk6U1p14KHhCDwTqtB5vq9cV8xKYbrcmDc79BaJTat2aklg/OdjHuXrxkWU6oYo5xKqnK5PigELKfoFYGbwWh/6dtxd84PgaFy22t04iJCuNn+JpqADmBjovzQItAfpQjP4LbuaDI4esrOtC5OvifhjXWiPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GA91k/B9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GA91k/B9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE1AC43390;
	Tue, 23 Jan 2024 00:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968458;
	bh=POjRZA56w6UvqC9BeCY9jTcD4ZRe+704RqH/jsUb4V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GA91k/B94ZH/TVt54YSW0NbKoPzzxdNXLa7BXhcXrYcs9orA+Jaxgqxfn5yWNxvlI
	 KXxhWPQzMj3f4vZHESwmwH/6gke1Kj44lUV5OEmdKHW4gf99NAFh/kZcbO50e7N/+j
	 u8O9kHB5WVYuFec6EdYQJAsmdTPszQGXhbQAcSc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/148] Revert "ASoC: atmel: Remove system clock tree configuration for at91sam9g20ek"
Date: Mon, 22 Jan 2024 15:57:50 -0800
Message-ID: <20240122235717.083755528@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 6eb9b4a36d08da0230e6a7712b17eafdfd996991 which is
commit c775cbf62ed4911e4f0f23880f01815753123690 upstream.

It is reported to cause problems, so drop it from the 5.15.y tree for now.

Link: https://lore.kernel.org/r/845b3053-d47b-4717-9665-79b120da133b@sirena.org.uk
Reported-by: Mark Brown <broonie@kernel.org>
Cc: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/atmel/sam9g20_wm8731.c |   61 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

--- a/sound/soc/atmel/sam9g20_wm8731.c
+++ b/sound/soc/atmel/sam9g20_wm8731.c
@@ -59,6 +59,35 @@
  */
 #undef ENABLE_MIC_INPUT
 
+static struct clk *mclk;
+
+static int at91sam9g20ek_set_bias_level(struct snd_soc_card *card,
+					struct snd_soc_dapm_context *dapm,
+					enum snd_soc_bias_level level)
+{
+	static int mclk_on;
+	int ret = 0;
+
+	switch (level) {
+	case SND_SOC_BIAS_ON:
+	case SND_SOC_BIAS_PREPARE:
+		if (!mclk_on)
+			ret = clk_enable(mclk);
+		if (ret == 0)
+			mclk_on = 1;
+		break;
+
+	case SND_SOC_BIAS_OFF:
+	case SND_SOC_BIAS_STANDBY:
+		if (mclk_on)
+			clk_disable(mclk);
+		mclk_on = 0;
+		break;
+	}
+
+	return ret;
+}
+
 static const struct snd_soc_dapm_widget at91sam9g20ek_dapm_widgets[] = {
 	SND_SOC_DAPM_MIC("Int Mic", NULL),
 	SND_SOC_DAPM_SPK("Ext Spk", NULL),
@@ -117,6 +146,7 @@ static struct snd_soc_card snd_soc_at91s
 	.owner = THIS_MODULE,
 	.dai_link = &at91sam9g20ek_dai,
 	.num_links = 1,
+	.set_bias_level = at91sam9g20ek_set_bias_level,
 
 	.dapm_widgets = at91sam9g20ek_dapm_widgets,
 	.num_dapm_widgets = ARRAY_SIZE(at91sam9g20ek_dapm_widgets),
@@ -129,6 +159,7 @@ static int at91sam9g20ek_audio_probe(str
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *codec_np, *cpu_np;
+	struct clk *pllb;
 	struct snd_soc_card *card = &snd_soc_at91sam9g20ek;
 	int ret;
 
@@ -142,6 +173,31 @@ static int at91sam9g20ek_audio_probe(str
 		return -EINVAL;
 	}
 
+	/*
+	 * Codec MCLK is supplied by PCK0 - set it up.
+	 */
+	mclk = clk_get(NULL, "pck0");
+	if (IS_ERR(mclk)) {
+		dev_err(&pdev->dev, "Failed to get MCLK\n");
+		ret = PTR_ERR(mclk);
+		goto err;
+	}
+
+	pllb = clk_get(NULL, "pllb");
+	if (IS_ERR(pllb)) {
+		dev_err(&pdev->dev, "Failed to get PLLB\n");
+		ret = PTR_ERR(pllb);
+		goto err_mclk;
+	}
+	ret = clk_set_parent(mclk, pllb);
+	clk_put(pllb);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "Failed to set MCLK parent\n");
+		goto err_mclk;
+	}
+
+	clk_set_rate(mclk, MCLK_RATE);
+
 	card->dev = &pdev->dev;
 
 	/* Parse device node info */
@@ -185,6 +241,9 @@ static int at91sam9g20ek_audio_probe(str
 
 	return ret;
 
+err_mclk:
+	clk_put(mclk);
+	mclk = NULL;
 err:
 	atmel_ssc_put_audio(0);
 	return ret;
@@ -194,6 +253,8 @@ static int at91sam9g20ek_audio_remove(st
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
 
+	clk_disable(mclk);
+	mclk = NULL;
 	snd_soc_unregister_card(card);
 	atmel_ssc_put_audio(0);
 


