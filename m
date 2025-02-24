Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5542714012;
	Mon, 24 Feb 2025 14:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408970; cv=none; b=MxrnpGEWy8xTNeketLFd2LRSzsMig05U5/qnn7f70b2+K7mWA7/js/0JLXGBaGiCUYdt2r0CcsluZ4T7AiILWCuu2OmnJOTYxPEE6ntToOP5EGEE8a/8tG1ujCbkusJYVxwlO4s9vudD+N/7IIKEuZ3fQYsfCTGPYE4hnPyoOw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408970; c=relaxed/simple;
	bh=9orwN6EYBfEioVWRQS/dptKUIMBvpqjp5cq1KFKAfTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPG+ZLn3iE80blwFl6evTWEoEYYqKCjuVx06EGU+v3rnssCB8XN/P+fNtZ7jh8O1oJPiRDzZaqfnyKGl1dczxpBwSlHtGn6Doccc6eWGIm+ZdKGCHLFAyYDmFaQzF4/tQFWBrtk/MBACraTI876EwtVDPHG0zNn6tS0mOwngQWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AL50cZM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AL50cZM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C9BC4CED6;
	Mon, 24 Feb 2025 14:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408969;
	bh=9orwN6EYBfEioVWRQS/dptKUIMBvpqjp5cq1KFKAfTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AL50cZM+9EVSHc+JtK/AYmtMr7TKmk51DRRPzn+jnIu261fLjqHSGMk5G2ZCXir7g
	 /7JGNJMf9LjoMHFdMuIMm1mf1tA59Tm7cljFsEnLiPMMMBYiZ77REoLa1xlTHRTs69
	 9Zd9kPhGn4F5tckM4MZbLU5t071Ys94vaGEBylg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 026/138] ASoC: imx-audmix: remove cpu_mclk which is from cpu dai device
Date: Mon, 24 Feb 2025 15:34:16 +0100
Message-ID: <20250224142605.498877239@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 231400661c906..50ecc5f51100e 100644
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
@@ -323,13 +299,6 @@ static int imx_audmix_probe(struct platform_device *pdev)
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



