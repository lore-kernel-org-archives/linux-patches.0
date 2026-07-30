Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7722A3876C5;
	Thu, 30 Jul 2026 16:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428090; cv=none; b=i7PMxn8UB5K0M5PA8kO+TTA7/qFpeReOwTG983DqXTapv2LJfAdH5pxU0jNllKzUK5Gr4TaZMPY7R8F6RaYynjXxHH3IMYc2AR2WLduRGC5sDBN7HJnr1dNQX6455lG/sDW3iJTXsXyjxz/FbUN3fRw1rd6gq8cmd6Y6rm5sKPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428090; c=relaxed/simple;
	bh=CWPCnwX3+5pZyUssmI9jImmEUwZrtDC0g1E7GyNdivc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4t+gq6rAkcYG6FUUTHPUmnSJDgsdJDSSMrGgu6VzaaP6IXVUd7Wp5Dr5/BZC3i2H/d0W8SrThVrPJFFSNkdxsQW0jfgGZcD6xNdiPgj29NV+vYVIcnchAXEieFZfgU7zaFaplBioED/Mz3Wl/c1uTQiqgKGXO1u5iFlB6aatNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVExd4Cx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVExd4Cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE3F1F00A3A;
	Thu, 30 Jul 2026 16:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428087;
	bh=YADKCUNz9e2lXwO2dDuMtzgGWODAmkQr2yzdVtqVmBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tVExd4CxxQqjojroCKGsSjsxOE44JJsTiIVDD+feadgB9oTWkykcfCphrI4dvLJEq
	 4h/DCS1bT6Rftwrubpu2NNLlD39M5iaYPZRwbOrawxfZs97v8er2j74zzHVGiTt4qH
	 gxsfnloKdOYONnY1cBj58IiHxY+ujEu+EV7l7yhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 398/484] ASoC: mediatek: mt8195: Remove afe-dai component and rework codec link
Date: Thu, 30 Jul 2026 16:14:55 +0200
Message-ID: <20260730141432.122005677@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit e70b8dd26711704b1ff1f1b4eb3d048ba69e29da ]

Remove the extra 'mt8195-afe-pcm-dai' component, register the DAI
drivers to the main AFE component, and rework the DAI linking between
the headset codec (RT5682/RT5682S) and the TDM interface in the probe
function to stop assigning name, relying on the of_node of the codec.
Also replace the COMP_DUMMY codec entry with a COMP_EMPTY for the
ETDM2_IN and remove it entirely from ETDM1_OUT to fix the registration
flow for this sound card.

While at it, since we also need to swap the codec init function from
ETDM2_IN to ETDM1_OUT, remove the static assignment of both `ops` and
`init` for both, as we now assign these dynamically during probe.

Fixes: 13f58267cda3 ("ASoC: soc.h: don't create dummy Component via COMP_DUMMY()")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://msgid.link/r/20240110105757.539089-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: e24d5dde56a5 ("ASoC: mediatek: mt8192: Check runtime resume during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c |   33 -----------------------
 sound/soc/mediatek/mt8195/mt8195-mt6359.c  |   41 +++++++++++++++++++----------
 2 files changed, 29 insertions(+), 45 deletions(-)

--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -1795,10 +1795,6 @@ static const struct snd_kcontrol_new mt8
 			    MT8195_AFE_IRQ_28),
 };
 
-static const struct snd_soc_component_driver mt8195_afe_pcm_dai_component = {
-	.name = "mt8195-afe-pcm-dai",
-};
-
 static const struct mtk_base_memif_data memif_data[MT8195_AFE_MEMIF_NUM] = {
 	[MT8195_AFE_MEMIF_DL2] = {
 		.name = "DL2",
@@ -3037,7 +3033,6 @@ static int mt8195_afe_pcm_dev_probe(stru
 	struct device *dev = &pdev->dev;
 	struct reset_control *rstc;
 	int i, irq_id, ret;
-	struct snd_soc_component *component;
 
 	ret = of_reserved_mem_device_init(dev);
 	if (ret)
@@ -3170,36 +3165,12 @@ static int mt8195_afe_pcm_dev_probe(stru
 
 	/* register component */
 	ret = devm_snd_soc_register_component(dev, &mt8195_afe_component,
-					      NULL, 0);
+					      afe->dai_drivers, afe->num_dai_drivers);
 	if (ret) {
 		dev_warn(dev, "err_platform\n");
 		goto err_pm_put;
 	}
 
-	component = devm_kzalloc(dev, sizeof(*component), GFP_KERNEL);
-	if (!component) {
-		ret = -ENOMEM;
-		goto err_pm_put;
-	}
-
-	ret = snd_soc_component_initialize(component,
-					   &mt8195_afe_pcm_dai_component,
-					   dev);
-	if (ret)
-		goto err_pm_put;
-
-#ifdef CONFIG_DEBUG_FS
-	component->debugfs_prefix = "pcm";
-#endif
-
-	ret = snd_soc_add_component(component,
-				    afe->dai_drivers,
-				    afe->num_dai_drivers);
-	if (ret) {
-		dev_warn(dev, "err_dai_component\n");
-		goto err_pm_put;
-	}
-
 	ret = regmap_multi_reg_write(afe->regmap, mt8195_afe_reg_defaults,
 				     ARRAY_SIZE(mt8195_afe_reg_defaults));
 	if (ret)
@@ -3224,8 +3195,6 @@ err_pm_put:
 
 static void mt8195_afe_pcm_dev_remove(struct platform_device *pdev)
 {
-	snd_soc_unregister_component(&pdev->dev);
-
 	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		mt8195_afe_runtime_suspend(&pdev->dev);
--- a/sound/soc/mediatek/mt8195/mt8195-mt6359.c
+++ b/sound/soc/mediatek/mt8195/mt8195-mt6359.c
@@ -934,12 +934,11 @@ SND_SOC_DAILINK_DEFS(ETDM1_IN_BE,
 
 SND_SOC_DAILINK_DEFS(ETDM2_IN_BE,
 		     DAILINK_COMP_ARRAY(COMP_CPU("ETDM2_IN")),
-		     DAILINK_COMP_ARRAY(COMP_DUMMY()),
+		     DAILINK_COMP_ARRAY(COMP_EMPTY()),
 		     DAILINK_COMP_ARRAY(COMP_EMPTY()));
 
 SND_SOC_DAILINK_DEFS(ETDM1_OUT_BE,
 		     DAILINK_COMP_ARRAY(COMP_CPU("ETDM1_OUT")),
-		     DAILINK_COMP_ARRAY(COMP_DUMMY()),
 		     DAILINK_COMP_ARRAY(COMP_EMPTY()));
 
 SND_SOC_DAILINK_DEFS(ETDM2_OUT_BE,
@@ -1237,8 +1236,6 @@ static struct snd_soc_dai_link mt8195_mt
 			SND_SOC_DAIFMT_NB_NF |
 			SND_SOC_DAIFMT_CBS_CFS,
 		.dpcm_capture = 1,
-		.init = mt8195_rt5682_init,
-		.ops = &mt8195_rt5682_etdm_ops,
 		.be_hw_params_fixup = mt8195_etdm_hw_params_fixup,
 		SND_SOC_DAILINK_REG(ETDM2_IN_BE),
 	},
@@ -1249,7 +1246,6 @@ static struct snd_soc_dai_link mt8195_mt
 			SND_SOC_DAIFMT_NB_NF |
 			SND_SOC_DAIFMT_CBS_CFS,
 		.dpcm_playback = 1,
-		.ops = &mt8195_rt5682_etdm_ops,
 		.be_hw_params_fixup = mt8195_etdm_hw_params_fixup,
 		SND_SOC_DAILINK_REG(ETDM1_OUT_BE),
 	},
@@ -1381,7 +1377,7 @@ static int mt8195_mt6359_dev_probe(struc
 	struct snd_soc_dai_link *dai_link;
 	struct mtk_soc_card_data *soc_card_data;
 	struct mt8195_mt6359_priv *mach_priv;
-	struct device_node *platform_node, *adsp_node, *dp_node, *hdmi_node;
+	struct device_node *platform_node, *adsp_node, *codec_node, *dp_node, *hdmi_node;
 	struct mt8195_card_data *card_data;
 	int is5682s = 0;
 	int init6359 = 0;
@@ -1401,8 +1397,12 @@ static int mt8195_mt6359_dev_probe(struc
 	if (!card->name)
 		card->name = card_data->name;
 
-	if (strstr(card->name, "_5682s"))
+	if (strstr(card->name, "_5682s")) {
+		codec_node = of_find_compatible_node(NULL, NULL, "realtek,rt5682s");
 		is5682s = 1;
+	} else
+		codec_node = of_find_compatible_node(NULL, NULL, "realtek,rt5682i");
+
 	soc_card_data = devm_kzalloc(&pdev->dev, sizeof(*card_data), GFP_KERNEL);
 	if (!soc_card_data)
 		return -ENOMEM;
@@ -1488,12 +1488,27 @@ static int mt8195_mt6359_dev_probe(struc
 				dai_link->codecs->dai_name = "i2s-hifi";
 				dai_link->init = mt8195_hdmi_codec_init;
 			}
-		} else if (strcmp(dai_link->name, "ETDM1_OUT_BE") == 0 ||
-			   strcmp(dai_link->name, "ETDM2_IN_BE") == 0) {
-			dai_link->codecs->name =
-				is5682s ? RT5682S_DEV0_NAME : RT5682_DEV0_NAME;
-			dai_link->codecs->dai_name =
-				is5682s ? RT5682S_CODEC_DAI : RT5682_CODEC_DAI;
+		} else if (strcmp(dai_link->name, "ETDM1_OUT_BE") == 0) {
+			if (!codec_node) {
+				dev_err(&pdev->dev, "Codec not found!\n");
+			} else {
+				dai_link->codecs->of_node = codec_node;
+				dai_link->codecs->name = NULL;
+				dai_link->codecs->dai_name =
+					is5682s ? RT5682S_CODEC_DAI : RT5682_CODEC_DAI;
+				dai_link->init = mt8195_rt5682_init;
+				dai_link->ops = &mt8195_rt5682_etdm_ops;
+			}
+		} else if (strcmp(dai_link->name, "ETDM2_IN_BE") == 0) {
+			if (!codec_node) {
+				dev_err(&pdev->dev, "Codec not found!\n");
+			} else {
+				dai_link->codecs->of_node = codec_node;
+				dai_link->codecs->name = NULL;
+				dai_link->codecs->dai_name =
+					is5682s ? RT5682S_CODEC_DAI : RT5682_CODEC_DAI;
+				dai_link->ops = &mt8195_rt5682_etdm_ops;
+			}
 		} else if (strcmp(dai_link->name, "DL_SRC_BE") == 0 ||
 			   strcmp(dai_link->name, "UL_SRC1_BE") == 0 ||
 			   strcmp(dai_link->name, "UL_SRC2_BE") == 0) {


