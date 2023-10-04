Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129C91D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F06CC433CA;
	Wed,  4 Oct 2023 18:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443182;
	bh=rTIbxPCd63oFyXmEwNCZaZsNIcV01NMFh3p+URhi62w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1c7jfsWtQe3CSHIy7U6KYC0PgZCyNW1ez68dmstgDtGwOLs6aLO/7eSnCN6kyLPn
	 knoB5ZfMSQ59Ygsq5dWE8fOXgQjx2RB8+1FXDts9QlIya5DV5Ms47C85YenB2nnw2P
	 764XqUTNUncU/Z+jjEOJ4XpR38iqH2Mi7W/KcALU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/259] ASoC: meson: spdifin: start hw on dai probe
Date: Wed,  4 Oct 2023 19:53:30 +0200
Message-ID: <20231004175219.136922728@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit aedf323b66b2b875137422ecb7d2525179759076 ]

For spdif input to report the locked rate correctly, even when no capture
is running, the HW and reference clock must be started as soon as
the dai is probed.

Fixes: 5ce5658375e6 ("ASoC: meson: add axg spdif input")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20230907090504.12700-1-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-spdifin.c | 49 ++++++++++++-----------------------
 1 file changed, 17 insertions(+), 32 deletions(-)

diff --git a/sound/soc/meson/axg-spdifin.c b/sound/soc/meson/axg-spdifin.c
index e2cc4c4be7586..97e81ec4a78ce 100644
--- a/sound/soc/meson/axg-spdifin.c
+++ b/sound/soc/meson/axg-spdifin.c
@@ -112,34 +112,6 @@ static int axg_spdifin_prepare(struct snd_pcm_substream *substream,
 	return 0;
 }
 
-static int axg_spdifin_startup(struct snd_pcm_substream *substream,
-			       struct snd_soc_dai *dai)
-{
-	struct axg_spdifin *priv = snd_soc_dai_get_drvdata(dai);
-	int ret;
-
-	ret = clk_prepare_enable(priv->refclk);
-	if (ret) {
-		dev_err(dai->dev,
-			"failed to enable spdifin reference clock\n");
-		return ret;
-	}
-
-	regmap_update_bits(priv->map, SPDIFIN_CTRL0, SPDIFIN_CTRL0_EN,
-			   SPDIFIN_CTRL0_EN);
-
-	return 0;
-}
-
-static void axg_spdifin_shutdown(struct snd_pcm_substream *substream,
-				 struct snd_soc_dai *dai)
-{
-	struct axg_spdifin *priv = snd_soc_dai_get_drvdata(dai);
-
-	regmap_update_bits(priv->map, SPDIFIN_CTRL0, SPDIFIN_CTRL0_EN, 0);
-	clk_disable_unprepare(priv->refclk);
-}
-
 static void axg_spdifin_write_mode_param(struct regmap *map, int mode,
 					 unsigned int val,
 					 unsigned int num_per_reg,
@@ -251,25 +223,38 @@ static int axg_spdifin_dai_probe(struct snd_soc_dai *dai)
 	ret = axg_spdifin_sample_mode_config(dai, priv);
 	if (ret) {
 		dev_err(dai->dev, "mode configuration failed\n");
-		clk_disable_unprepare(priv->pclk);
-		return ret;
+		goto pclk_err;
 	}
 
+	ret = clk_prepare_enable(priv->refclk);
+	if (ret) {
+		dev_err(dai->dev,
+			"failed to enable spdifin reference clock\n");
+		goto pclk_err;
+	}
+
+	regmap_update_bits(priv->map, SPDIFIN_CTRL0, SPDIFIN_CTRL0_EN,
+			   SPDIFIN_CTRL0_EN);
+
 	return 0;
+
+pclk_err:
+	clk_disable_unprepare(priv->pclk);
+	return ret;
 }
 
 static int axg_spdifin_dai_remove(struct snd_soc_dai *dai)
 {
 	struct axg_spdifin *priv = snd_soc_dai_get_drvdata(dai);
 
+	regmap_update_bits(priv->map, SPDIFIN_CTRL0, SPDIFIN_CTRL0_EN, 0);
+	clk_disable_unprepare(priv->refclk);
 	clk_disable_unprepare(priv->pclk);
 	return 0;
 }
 
 static const struct snd_soc_dai_ops axg_spdifin_ops = {
 	.prepare	= axg_spdifin_prepare,
-	.startup	= axg_spdifin_startup,
-	.shutdown	= axg_spdifin_shutdown,
 };
 
 static int axg_spdifin_iec958_info(struct snd_kcontrol *kcontrol,
-- 
2.40.1



