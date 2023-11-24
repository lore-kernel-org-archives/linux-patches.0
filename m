Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2D5381D6;
	Fri, 24 Nov 2023 18:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ox2T1yuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC204C433C7;
	Fri, 24 Nov 2023 18:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850530;
	bh=qWj+78c81RM/PgsQesplk1Cd9H1UE7dVChmu5LuKANI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ox2T1yuKWeL5f3sZ0ia0bZcAHLK6sqp4j6q6QYUXpL+H+OIYOgxJKPn5SljmoEZ7+
	 DFRVEkJt/XcXbEUIw+cFLx0ipmSK2RyHIy0E1ssdjqeRZa1OAwOhdeC/htak9CdjLV
	 KCzA+gF313fk/opL/BTiQY5rLZTBpSKAQJGUDgpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Wu <trevor.wu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 078/491] ASoC: mediatek: mt8188-mt6359: support dynamic pinctrl
Date: Fri, 24 Nov 2023 17:45:14 +0000
Message-ID: <20231124172026.971044088@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trevor Wu <trevor.wu@mediatek.com>

[ Upstream commit d601bb78f06b9e3cbb52e6b87b88add9920a11b6 ]

To avoid power leakage, it is recommended to replace the default pinctrl
state with dynamic pinctrl since certain audio pinmux functions can
remain in a HIGH state even when audio is disabled. Linking pinctrl with
DAPM using SND_SOC_DAPM_PINCTRL will ensure that audio pins remain in
GPIO mode by default and only switch to an audio function when necessary.

Signed-off-by: Trevor Wu <trevor.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230825024935.10878-2-trevor.wu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-mt6359.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/sound/soc/mediatek/mt8188/mt8188-mt6359.c b/sound/soc/mediatek/mt8188/mt8188-mt6359.c
index ac69c23e0da1c..7048ff52ab86a 100644
--- a/sound/soc/mediatek/mt8188/mt8188-mt6359.c
+++ b/sound/soc/mediatek/mt8188/mt8188-mt6359.c
@@ -246,6 +246,11 @@ static const struct snd_soc_dapm_widget mt8188_mt6359_widgets[] = {
 	SND_SOC_DAPM_MIC("Headset Mic", NULL),
 	SND_SOC_DAPM_SINK("HDMI"),
 	SND_SOC_DAPM_SINK("DP"),
+
+	/* dynamic pinctrl */
+	SND_SOC_DAPM_PINCTRL("ETDM_SPK_PIN", "aud_etdm_spk_on", "aud_etdm_spk_off"),
+	SND_SOC_DAPM_PINCTRL("ETDM_HP_PIN", "aud_etdm_hp_on", "aud_etdm_hp_off"),
+	SND_SOC_DAPM_PINCTRL("MTKAIF_PIN", "aud_mtkaif_on", "aud_mtkaif_off"),
 };
 
 static const struct snd_kcontrol_new mt8188_mt6359_controls[] = {
@@ -267,6 +272,7 @@ static int mt8188_mt6359_mtkaif_calibration(struct snd_soc_pcm_runtime *rtd)
 		snd_soc_rtdcom_lookup(rtd, AFE_PCM_NAME);
 	struct snd_soc_component *cmpnt_codec =
 		asoc_rtd_to_codec(rtd, 0)->component;
+	struct snd_soc_dapm_widget *pin_w = NULL, *w;
 	struct mtk_base_afe *afe;
 	struct mt8188_afe_private *afe_priv;
 	struct mtkaif_param *param;
@@ -306,6 +312,18 @@ static int mt8188_mt6359_mtkaif_calibration(struct snd_soc_pcm_runtime *rtd)
 		return 0;
 	}
 
+	for_each_card_widgets(rtd->card, w) {
+		if (!strcmp(w->name, "MTKAIF_PIN")) {
+			pin_w = w;
+			break;
+		}
+	}
+
+	if (pin_w)
+		dapm_pinctrl_event(pin_w, NULL, SND_SOC_DAPM_PRE_PMU);
+	else
+		dev_dbg(afe->dev, "%s(), no pinmux widget, please check if default on\n", __func__);
+
 	pm_runtime_get_sync(afe->dev);
 	mt6359_mtkaif_calibration_enable(cmpnt_codec);
 
@@ -403,6 +421,9 @@ static int mt8188_mt6359_mtkaif_calibration(struct snd_soc_pcm_runtime *rtd)
 	for (i = 0; i < MT8188_MTKAIF_MISO_NUM; i++)
 		param->mtkaif_phase_cycle[i] = mtkaif_phase_cycle[i];
 
+	if (pin_w)
+		dapm_pinctrl_event(pin_w, NULL, SND_SOC_DAPM_POST_PMD);
+
 	dev_dbg(afe->dev, "%s(), end, calibration ok %d\n",
 		__func__, param->mtkaif_calibration_ok);
 
-- 
2.42.0



