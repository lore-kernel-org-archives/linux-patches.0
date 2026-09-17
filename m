Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5B04ABBD4;
	Thu, 17 Sep 2026 16:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661096; cv=none; b=Ldx40l9dzUqkWNvUFCtL+vecM86ldrINEbFYwBMJGAh6A2+6+Ngl6kD+3+3m5dcedSbM//boFpwszcl0j/lsSP2jsPWMAG5vy2B8xqmGfzaKyet1NZThSWvYU1TVhGZ6do+0isUXYTgxoorPr690ce42DZRvHkdNe53TiP48xPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661096; c=relaxed/simple;
	bh=9GfUT5cmf4qP1rTIW4SiQ5rJe1N4lBf8dxu1DDy3leg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jF8DlUJEGdVA/tdFHyb0nrdRg9HKenJOn9fTXwVcCLjunE/C1EgUJZ0Hh2h6nS5Q6WXM8/GKrV0uAic90e9ZxbPmn2LMUaIhnisFF8Nl34ZFrTMU24EhSppM5/NM0NOSHmtFgO50XEpVAa9TGJO3O2ZD4TzGtteTTYdkP4226ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZL1UaFio; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZL1UaFio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D171F000FF;
	Thu, 17 Sep 2026 16:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661095;
	bh=EIrXIernIu/rAF30sLyXxlrzWo/eLiFk+30Th8NEF7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZL1UaFio0y138JwcM9BnusYRUMzH9Q6if5cPEvUuVuPxvtfje3Tjopl1T+vs/bEVF
	 cGGr6PngsqkrIyYj/A++PQjXDJZuWkO+DzXRYSO13ayVJ31Id8ID8Tztlr5Nl2Cs5e
	 h+TF2qTTRXaIudC9qAgFg7S811mWyL72aCFW+cyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0040/1250] ASoC: fsl-asoc-card: reduce WM8904 PLL ratio to meet frequency limit
Date: Thu, 17 Sep 2026 15:57:15 +0100
Message-ID: <20260917151553.021192071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 99b5316f08f390a5e1ea2239ecca8e2b4ef70ac6 ]

WM8904 has a 27 MHz PLL frequency limit. The current S24_LE PLL ratio
of 384 exceeds this at high sample rates (96 kHz × 384 = 36.864 MHz).

Reduce the ratio to 192 for WM8904, keeping PLL within limits at all
supported rates (96 kHz × 192 = 18.432 MHz).

Add codec-specific pll_ratio_s24 field, default 384, override to 192
for WM8904.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260429100028.2739711-6-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl-asoc-card.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl-asoc-card.c b/sound/soc/fsl/fsl-asoc-card.c
index f660eeb8e5451..6cf5047eb9551 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -48,6 +48,9 @@
  * @mclk_id: MCLK (or main clock) id for set_sysclk()
  * @fll_id: FLL (or secordary clock) id for set_sysclk()
  * @pll_id: PLL id for set_pll()
+ * @pll_ratio_s24: PLL output ratio for S24_LE format (PLL_freq = sample_rate × ratio)
+ *                 Default is 384, but some codecs (e.g., WM8904) require lower values
+ *                 to stay within PLL frequency limits
  */
 struct codec_priv {
 	struct clk *mclk;
@@ -56,6 +59,7 @@ struct codec_priv {
 	u32 mclk_id;
 	int fll_id;
 	int pll_id;
+	int pll_ratio_s24;
 };
 
 /**
@@ -222,7 +226,7 @@ static int fsl_asoc_card_hw_params(struct snd_pcm_substream *substream,
 
 		if (codec_priv->pll_id >= 0 && codec_priv->fll_id >= 0) {
 			if (priv->sample_format == SNDRV_PCM_FORMAT_S24_LE)
-				pll_out = priv->sample_rate * 384;
+				pll_out = priv->sample_rate * codec_priv->pll_ratio_s24;
 			else
 				pll_out = priv->sample_rate * 256;
 
@@ -742,6 +746,7 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	for (codec_idx = 0; codec_idx < 2; codec_idx++) {
 		priv->codec_priv[codec_idx].fll_id = -1;
 		priv->codec_priv[codec_idx].pll_id = -1;
+		priv->codec_priv[codec_idx].pll_ratio_s24 = 384;
 	}
 
 	/* Diversify the card configurations */
@@ -835,6 +840,7 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 		priv->codec_priv[0].mclk_id = WM8904_FLL_MCLK;
 		priv->codec_priv[0].fll_id = WM8904_CLK_FLL;
 		priv->codec_priv[0].pll_id = WM8904_FLL_MCLK;
+		priv->codec_priv[0].pll_ratio_s24 = 192;
 		priv->dai_fmt |= SND_SOC_DAIFMT_CBP_CFP;
 	} else if (of_device_is_compatible(np, "fsl,imx-audio-spdif")) {
 		ret = fsl_asoc_card_spdif_init(codec_np, cpu_np, codec_dai_name, priv);
-- 
2.53.0



