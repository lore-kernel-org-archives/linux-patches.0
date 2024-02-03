Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0766F171C7;
	Sat,  3 Feb 2024 04:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933917; cv=none; b=hqieQO3X2P7b7WUbFGYNX5c2DD9f53Lwypjl9BtBYpHp09MUnNHG8xDxk7hPHpTXHlOtc68laNBXv1OOGrX7tdsqyr0O36SnwK5UolsRJpEubUP79PpJslPT1kqTSTkHJoT0FM23p0WM2BJ6tKNLrHwjV+W2sESbadjkmpqQPGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933917; c=relaxed/simple;
	bh=QPoHZ/LjydwDjx0HOkmegV0LzpOgXg5MLE7I+UobN+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/0UFmXBa8y+ScwphBNm/6eg39pR0vo+WAtlnRkd+3gZc1XDS02fcUgOuu06V3Vv5KlE5bfDMuPR/q+eQh5Q3T1O4RCEGaB2MMXK8ndagNgPirrOZif24IXS60Q/xSdx39EfgwjFJ8g5wPVr5GocqQ11VwEkZeiumOgmUuXsYtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9CH5Brk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9CH5Brk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D94C433C7;
	Sat,  3 Feb 2024 04:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933916;
	bh=QPoHZ/LjydwDjx0HOkmegV0LzpOgXg5MLE7I+UobN+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9CH5Brk7ZJbKvh9OTmo+/PaNY3oomodOeOv5/7JjdEYTSuBpzxT28UfYgnmHASrl
	 FWNI0y6XjBqdHS8HUVo1ZXig7NoIa/6tOgl12KCqoLR32FlWN8avDbdEi6wWZP3q4z
	 k0e+Tv1xQTNUUDOGpTgPtTstXk6qWmJlI6sVJW/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChiYuan Huang <cy_huang@richtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 271/353] ASoC: codecs: rtq9128: Fix TDM enable and DAI format control flow
Date: Fri,  2 Feb 2024 20:06:29 -0800
Message-ID: <20240203035412.333100000@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChiYuan Huang <cy_huang@richtek.com>

[ Upstream commit 415d10ccef712f3ec73cd880c1fef3eb48601c3a ]

To enable TDM mode, the current control flow limits the function
calling order should be 'set_tdm_slot->set_dai_fmt'. But not all
platform sound card like as simeple card to follow this design.
To bypass this limit, adjust the DAI format setting in runtime
'hw_param' callback.

Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://msgid.link/r/c4c8df00d8d179b8b5b39a8521de3a85325c57e8.1703813842.git.cy_huang@richtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rtq9128.c | 67 ++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 31 deletions(-)

diff --git a/sound/soc/codecs/rtq9128.c b/sound/soc/codecs/rtq9128.c
index bda64f9eeb62..aa3eadecd974 100644
--- a/sound/soc/codecs/rtq9128.c
+++ b/sound/soc/codecs/rtq9128.c
@@ -59,6 +59,7 @@
 
 struct rtq9128_data {
 	struct gpio_desc *enable;
+	unsigned int daifmt;
 	int tdm_slots;
 	int tdm_slot_width;
 	bool tdm_input_data2_select;
@@ -441,10 +442,7 @@ static const struct snd_soc_component_driver rtq9128_comp_driver = {
 static int rtq9128_dai_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 {
 	struct rtq9128_data *data = snd_soc_dai_get_drvdata(dai);
-	struct snd_soc_component *comp = dai->component;
 	struct device *dev = dai->dev;
-	unsigned int audfmt, fmtval;
-	int ret;
 
 	dev_dbg(dev, "%s: fmt 0x%8x\n", __func__, fmt);
 
@@ -454,35 +452,10 @@ static int rtq9128_dai_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 		return -EINVAL;
 	}
 
-	fmtval = fmt & SND_SOC_DAIFMT_FORMAT_MASK;
-	if (data->tdm_slots && fmtval != SND_SOC_DAIFMT_DSP_A && fmtval != SND_SOC_DAIFMT_DSP_B) {
-		dev_err(dev, "TDM is used, format only support DSP_A or DSP_B\n");
-		return -EINVAL;
-	}
+	/* Store here and will be used in runtime hw_params for DAI format setting */
+	data->daifmt = fmt;
 
-	switch (fmtval) {
-	case SND_SOC_DAIFMT_I2S:
-		audfmt = 8;
-		break;
-	case SND_SOC_DAIFMT_LEFT_J:
-		audfmt = 9;
-		break;
-	case SND_SOC_DAIFMT_RIGHT_J:
-		audfmt = 10;
-		break;
-	case SND_SOC_DAIFMT_DSP_A:
-		audfmt = data->tdm_slots ? 12 : 11;
-		break;
-	case SND_SOC_DAIFMT_DSP_B:
-		audfmt = data->tdm_slots ? 4 : 3;
-		break;
-	default:
-		dev_err(dev, "Unsupported format 0x%8x\n", fmt);
-		return -EINVAL;
-	}
-
-	ret = snd_soc_component_write_field(comp, RTQ9128_REG_I2S_OPT, RTQ9128_AUDFMT_MASK, audfmt);
-	return ret < 0 ? ret : 0;
+	return 0;
 }
 
 static int rtq9128_dai_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
@@ -558,10 +531,38 @@ static int rtq9128_dai_hw_params(struct snd_pcm_substream *stream, struct snd_pc
 	unsigned int width, slot_width, bitrate, audbit, dolen;
 	struct snd_soc_component *comp = dai->component;
 	struct device *dev = dai->dev;
+	unsigned int fmtval, audfmt;
 	int ret;
 
 	dev_dbg(dev, "%s: width %d\n", __func__, params_width(param));
 
+	fmtval = FIELD_GET(SND_SOC_DAIFMT_FORMAT_MASK, data->daifmt);
+	if (data->tdm_slots && fmtval != SND_SOC_DAIFMT_DSP_A && fmtval != SND_SOC_DAIFMT_DSP_B) {
+		dev_err(dev, "TDM is used, format only support DSP_A or DSP_B\n");
+		return -EINVAL;
+	}
+
+	switch (fmtval) {
+	case SND_SOC_DAIFMT_I2S:
+		audfmt = 8;
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		audfmt = 9;
+		break;
+	case SND_SOC_DAIFMT_RIGHT_J:
+		audfmt = 10;
+		break;
+	case SND_SOC_DAIFMT_DSP_A:
+		audfmt = data->tdm_slots ? 12 : 11;
+		break;
+	case SND_SOC_DAIFMT_DSP_B:
+		audfmt = data->tdm_slots ? 4 : 3;
+		break;
+	default:
+		dev_err(dev, "Unsupported format 0x%8x\n", fmtval);
+		return -EINVAL;
+	}
+
 	switch (width = params_width(param)) {
 	case 16:
 		audbit = 0;
@@ -615,6 +616,10 @@ static int rtq9128_dai_hw_params(struct snd_pcm_substream *stream, struct snd_pc
 		return -EINVAL;
 	}
 
+	ret = snd_soc_component_write_field(comp, RTQ9128_REG_I2S_OPT, RTQ9128_AUDFMT_MASK, audfmt);
+	if (ret < 0)
+		return ret;
+
 	ret = snd_soc_component_write_field(comp, RTQ9128_REG_I2S_OPT, RTQ9128_AUDBIT_MASK, audbit);
 	if (ret < 0)
 		return ret;
-- 
2.43.0



