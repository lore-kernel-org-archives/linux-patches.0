Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814F35101A;
	Mon, 11 Dec 2023 18:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMKBIPRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0585AC433C7;
	Mon, 11 Dec 2023 18:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319383;
	bh=7sYjTCsVgvOdDl4cPXfAbabt2kTbzqqo3XUr1wdkprk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMKBIPRJNAyW3+gKR4gpJm1Rs9HAfsL1pVG0KWVOP53XWs+KNimKIJgI5jcCRhxPi
	 0Wh6a2enZeRqFCkO8k+FxeE+dHFOcrjz9c/uZgub4HRmQetULsN8NHXPWWO5kEhIfm
	 LMutbZ4LKm1vwxiASn+OHn5tloIxDu+zY6llrbkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/244] ASoC: fsl_sai: Fix no frame sync clock issue on i.MX8MP
Date: Mon, 11 Dec 2023 19:19:38 +0100
Message-ID: <20231211182049.575424305@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 14e8442e0789598514f3c9de014950de9feda7a4 ]

On i.MX8MP, when the TERE and FSD_MSTR enabled before configuring
the word width, there will be no frame sync clock issue, because
old word width impact the generation of frame sync.

TERE enabled earlier only for i.MX8MP case for the hardware limitation,
So need to disable FSD_MSTR before configuring word width, then enable
FSD_MSTR bit for this specific case.

Fixes: 3e4a82612998 ("ASoC: fsl_sai: MCLK bind with TX/RX enable bit")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1700474735-3863-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 8a9a30dd31e20..3252eefc4bc0e 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -674,6 +674,20 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 			   FSL_SAI_CR3_TRCE_MASK,
 			   FSL_SAI_CR3_TRCE((dl_cfg[dl_cfg_idx].mask[tx] & trce_mask)));
 
+	/*
+	 * When the TERE and FSD_MSTR enabled before configuring the word width
+	 * There will be no frame sync clock issue, because word width impact
+	 * the generation of frame sync clock.
+	 *
+	 * TERE enabled earlier only for i.MX8MP case for the hardware limitation,
+	 * We need to disable FSD_MSTR before configuring word width, then enable
+	 * FSD_MSTR bit for this specific case.
+	 */
+	if (sai->soc_data->mclk_with_tere && sai->mclk_direction_output &&
+	    !sai->is_consumer_mode)
+		regmap_update_bits(sai->regmap, FSL_SAI_xCR4(tx, ofs),
+				   FSL_SAI_CR4_FSD_MSTR, 0);
+
 	regmap_update_bits(sai->regmap, FSL_SAI_xCR4(tx, ofs),
 			   FSL_SAI_CR4_SYWD_MASK | FSL_SAI_CR4_FRSZ_MASK |
 			   FSL_SAI_CR4_CHMOD_MASK,
@@ -681,6 +695,13 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 	regmap_update_bits(sai->regmap, FSL_SAI_xCR5(tx, ofs),
 			   FSL_SAI_CR5_WNW_MASK | FSL_SAI_CR5_W0W_MASK |
 			   FSL_SAI_CR5_FBT_MASK, val_cr5);
+
+	/* Enable FSD_MSTR after configuring word width */
+	if (sai->soc_data->mclk_with_tere && sai->mclk_direction_output &&
+	    !sai->is_consumer_mode)
+		regmap_update_bits(sai->regmap, FSL_SAI_xCR4(tx, ofs),
+				   FSL_SAI_CR4_FSD_MSTR, FSL_SAI_CR4_FSD_MSTR);
+
 	regmap_write(sai->regmap, FSL_SAI_xMR(tx),
 		     ~0UL - ((1 << min(channels, slots)) - 1));
 
-- 
2.42.0



