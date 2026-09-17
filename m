Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5974FD7A4;
	Thu, 17 Sep 2026 17:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667232; cv=none; b=GBVRP3DPXKyyjB6dYvz/ZlSLuk62knUna+bI0fInFyssk7tnUGYSfSu3aKIUVd72rcr281Oqam2BZzs/zxRdr74fThRBE7EMFkJfDW/bZXNFC/ZDdcVaB8J3otOkocgQhTTx4qABOKNJVk7fcn2YW/tE4TCAvcDE6ChAnuntcpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667232; c=relaxed/simple;
	bh=5GndlTAdgWSVTSaZVrNoyF/e/TnkrsIFMKt63ug8XRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k2DTdfpqGT1cavvIj1QvK3VWA68UO8dEJPu3ZIYx2F6it+ZifyAwEUXL9OOqdEJFlzVoZxJOqxu6iaPB+8GOZVKuHZ6lQxvvKfzHhdxSxpXXJPTyNdJkJVtpNPaaJXE3iUGqbIAroeI+Mby3KiZwzWseb1rX1o6SXOtFBkWECFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zn/ACmii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zn/ACmii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C663C1F000FF;
	Thu, 17 Sep 2026 17:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667231;
	bh=tJvLHZEQRldnMCufzRN4Ar6fDe3m4d1lEQOtW78BXko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zn/ACmiioDOCSKfuUsc5ljsE+4udHH9aNfeQWYWyS4K7vvBgES8s/YhFLboOtryHh
	 3IlhyBYf5tjE5es/mbCQLhQm2oNHT7li3B8JFwLFg7L0VCjGw724m3s8TdEJ/6bvh+
	 QrzyItR6kRFNpuZmjZ51pVv5NVAZnwx8X1POP2/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0024/1102] ASoC: fsl-asoc-card: reduce WM8904 PLL ratio to meet frequency limit
Date: Thu, 17 Sep 2026 15:59:27 +0100
Message-ID: <20260917151540.039051913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5a69f9d255acb..4762e38922d76 100644
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
@@ -215,7 +219,7 @@ static int fsl_asoc_card_hw_params(struct snd_pcm_substream *substream,
 
 		if (codec_priv->pll_id >= 0 && codec_priv->fll_id >= 0) {
 			if (priv->sample_format == SNDRV_PCM_FORMAT_S24_LE)
-				pll_out = priv->sample_rate * 384;
+				pll_out = priv->sample_rate * codec_priv->pll_ratio_s24;
 			else
 				pll_out = priv->sample_rate * 256;
 
@@ -739,6 +743,7 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	for (codec_idx = 0; codec_idx < 2; codec_idx++) {
 		priv->codec_priv[codec_idx].fll_id = -1;
 		priv->codec_priv[codec_idx].pll_id = -1;
+		priv->codec_priv[codec_idx].pll_ratio_s24 = 384;
 	}
 
 	/* Diversify the card configurations */
@@ -830,6 +835,7 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 		priv->codec_priv[0].mclk_id = WM8904_FLL_MCLK;
 		priv->codec_priv[0].fll_id = WM8904_CLK_FLL;
 		priv->codec_priv[0].pll_id = WM8904_FLL_MCLK;
+		priv->codec_priv[0].pll_ratio_s24 = 192;
 		priv->dai_fmt |= SND_SOC_DAIFMT_CBP_CFP;
 	} else if (of_device_is_compatible(np, "fsl,imx-audio-spdif")) {
 		ret = fsl_asoc_card_spdif_init(codec_np, cpu_np, codec_dai_name, priv);
-- 
2.53.0



