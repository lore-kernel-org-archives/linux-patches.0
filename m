Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202E21FC4;
	Tue, 23 Jan 2024 01:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972158; cv=none; b=ms2Xj1ZRHK3hsaCqyc5HwwVRu9PYOEp5FBHJ3iszyDyMfMi8JdlEKCUotlB0c4ghnoN56CRyh2bUY6njq4xZ8iUdQ9X/6+6HHRiaWmyce2Ftqv9zvrkhtfV4uYfFIcyp2SOSx1PFqzsdlbgoFWbEQPzp0Uq4cIPQ5SZ5adWFQpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972158; c=relaxed/simple;
	bh=tXsqFnF8Zkpm6vVatkPQnao1X/WvAKXXwAX59x/+Wtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9a66Zi2CTf35N1tXJxSYZSWuP0AxqWXcJxy7eYCtT2TfdAoOYujKQY2fkWgohVAbCEJghAmgvf8YtcMxOIGNmH+ZJEgjH+fENtgxE/tCzZkjnVmKxUs4JRU9wzjpACyjpRh2wmfCbxQO8zBVgXsEkbm6Y+b6mGdfya7uQ66ZIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYMPCyNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYMPCyNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F26C43394;
	Tue, 23 Jan 2024 01:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972158;
	bh=tXsqFnF8Zkpm6vVatkPQnao1X/WvAKXXwAX59x/+Wtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yYMPCyNfvLMkbud2ZREnWMq1y0khyrieqh7x1DpaRVY2YyCtrLQzYpjX7ySoo7yo0
	 FVyHflUmDRfRTlEVh8UPNnfwLLV0zK756DGj+BUB48B+s6t5Vt7PnjHltYAGSddBpc
	 insup7V493K5NtIS8mGe1z7vqLnojywX205cbGsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/374] Revert "ASoC: atmel: Remove system clock tree configuration for at91sam9g20ek"
Date: Mon, 22 Jan 2024 15:55:07 -0800
Message-ID: <20240122235746.375559321@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit bc7d0133181e5f33ac33ca4f6bb2bce876c8ad88 which is
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
@@ -46,6 +46,35 @@
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
@@ -106,6 +135,7 @@ static struct snd_soc_card snd_soc_at91s
 	.owner = THIS_MODULE,
 	.dai_link = &at91sam9g20ek_dai,
 	.num_links = 1,
+	.set_bias_level = at91sam9g20ek_set_bias_level,
 
 	.dapm_widgets = at91sam9g20ek_dapm_widgets,
 	.num_dapm_widgets = ARRAY_SIZE(at91sam9g20ek_dapm_widgets),
@@ -118,6 +148,7 @@ static int at91sam9g20ek_audio_probe(str
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *codec_np, *cpu_np;
+	struct clk *pllb;
 	struct snd_soc_card *card = &snd_soc_at91sam9g20ek;
 	int ret;
 
@@ -131,6 +162,31 @@ static int at91sam9g20ek_audio_probe(str
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
@@ -174,6 +230,9 @@ static int at91sam9g20ek_audio_probe(str
 
 	return ret;
 
+err_mclk:
+	clk_put(mclk);
+	mclk = NULL;
 err:
 	atmel_ssc_put_audio(0);
 	return ret;
@@ -183,6 +242,8 @@ static int at91sam9g20ek_audio_remove(st
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
 
+	clk_disable(mclk);
+	mclk = NULL;
 	snd_soc_unregister_card(card);
 	atmel_ssc_put_audio(0);
 


