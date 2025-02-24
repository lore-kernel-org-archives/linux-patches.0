Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86EE14D28C;
	Mon, 24 Feb 2025 14:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408416; cv=none; b=drrWRQn6UlmQhPTWhh7XOzjMZsoRixli8I5o/7aGeXSKGKDVuFAVWO8vQTjbrHfQeZuYuG0WwHbi/5+dBBGmY2hbRO++UbRR5EOS4TL1q9PvNtK72Ar5eV9qDm+vunAR+C76RiUDF8NJpPk29bBWgbMtii3cmn0LAcWvyvg77Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408416; c=relaxed/simple;
	bh=abl0tGNIxkHxTXa5n+yilEG/4rkXCOG+iMy8X4axm4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckrWRXpfaBx5Rtqw46xL3uQ7tF/l8I6j1Ne2OiBd4T1wD8gZz3WxaRlwOuEJsu4/LsbFg7sHW8wAl8eeY5HsZ7XEF1sCzld0rEspCRTvUGHtcr1n2MtayUSgs5qEEceGpZjKkrYTZO6zzechC76eidysqQeH84R5vAyp9ma/lbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bmVyeAUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bmVyeAUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8877C4CED6;
	Mon, 24 Feb 2025 14:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408415;
	bh=abl0tGNIxkHxTXa5n+yilEG/4rkXCOG+iMy8X4axm4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bmVyeAUCqkFb3MJzojurNKqPYokLd/7CPVWJ9njMm7IUivFLcXlaeGJ/PMBRFDG0J
	 Bro6gtvfWrSCZrClw8aBkPdDs4JUDYqq4ikFP+isgKYPALJEZQUVbgW/LwF42mW6mQ
	 WaOcSa3lZLZvWfS5SPVFbB8zqXHL4FPvNxaAFVJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/154] ASoC: imx-audmix: remove cpu_mclk which is from cpu dai device
Date: Mon, 24 Feb 2025 15:34:09 +0100
Message-ID: <20250224142609.052553291@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 571b69f2f9b1ec7cf7d0e9b79e52115a87a869c4 ]

When defer probe happens, there may be below error:

platform 59820000.sai: Resources present before probing

The cpu_mclk clock is from the cpu dai device, if it is not released,
then the cpu dai device probe will fail for the second time.

The cpu_mclk is used to get rate for rate constraint, rate constraint
may be specific for each platform, which is not necessary for machine
driver, so remove it.

Fixes: b86ef5367761 ("ASoC: fsl: Add Audio Mixer machine driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20250213070518.547375-1-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-audmix.c | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/sound/soc/fsl/imx-audmix.c b/sound/soc/fsl/imx-audmix.c
index 8e7b75cf64db4..ff3671226306b 100644
--- a/sound/soc/fsl/imx-audmix.c
+++ b/sound/soc/fsl/imx-audmix.c
@@ -23,7 +23,6 @@ struct imx_audmix {
 	struct snd_soc_card card;
 	struct platform_device *audmix_pdev;
 	struct platform_device *out_pdev;
-	struct clk *cpu_mclk;
 	int num_dai;
 	struct snd_soc_dai_link *dai;
 	int num_dai_conf;
@@ -32,34 +31,11 @@ struct imx_audmix {
 	struct snd_soc_dapm_route *dapm_routes;
 };
 
-static const u32 imx_audmix_rates[] = {
-	8000, 12000, 16000, 24000, 32000, 48000, 64000, 96000,
-};
-
-static const struct snd_pcm_hw_constraint_list imx_audmix_rate_constraints = {
-	.count = ARRAY_SIZE(imx_audmix_rates),
-	.list = imx_audmix_rates,
-};
-
 static int imx_audmix_fe_startup(struct snd_pcm_substream *substream)
 {
-	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
-	struct imx_audmix *priv = snd_soc_card_get_drvdata(rtd->card);
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct device *dev = rtd->card->dev;
-	unsigned long clk_rate = clk_get_rate(priv->cpu_mclk);
 	int ret;
 
-	if (clk_rate % 24576000 == 0) {
-		ret = snd_pcm_hw_constraint_list(runtime, 0,
-						 SNDRV_PCM_HW_PARAM_RATE,
-						 &imx_audmix_rate_constraints);
-		if (ret < 0)
-			return ret;
-	} else {
-		dev_warn(dev, "mclk may be not supported %lu\n", clk_rate);
-	}
-
 	ret = snd_pcm_hw_constraint_minmax(runtime, SNDRV_PCM_HW_PARAM_CHANNELS,
 					   1, 8);
 	if (ret < 0)
@@ -325,13 +301,6 @@ static int imx_audmix_probe(struct platform_device *pdev)
 	}
 	put_device(&cpu_pdev->dev);
 
-	priv->cpu_mclk = devm_clk_get(&cpu_pdev->dev, "mclk1");
-	if (IS_ERR(priv->cpu_mclk)) {
-		ret = PTR_ERR(priv->cpu_mclk);
-		dev_err(&cpu_pdev->dev, "failed to get DAI mclk1: %d\n", ret);
-		return ret;
-	}
-
 	priv->audmix_pdev = audmix_pdev;
 	priv->out_pdev  = cpu_pdev;
 
-- 
2.39.5



