Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E681358D27;
	Thu, 17 Sep 2026 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659069; cv=none; b=tobwzw2gusurmzZgjX8UVZm+tYBFR82Ngja8ErmHTpqkIMye8inC5q3WHndgnOO3FClmk+fZoXhALiioDsDCove8/XEgeu5PPR926ju1/hew9pc0P7mvhoLZQiyaRO3fq+C8eut6DjCKyyfn1JTWGgUC0W/DfzJtrFoiottTn7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659069; c=relaxed/simple;
	bh=m2sf+MraGahiQrToxjV0SsiLscXMBfRffRkhbTBG26U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/sfDhvqelyFgrqJJUdwpcgZVdWa6Cypbnj+vTyA6wjXaEwLAFz+1B7RRVrZdo/hrtvDqutgkjyS5oTx+1NNELxtu9l49VFB+YaqiSdyJDFtonVSpvUI6Lty4Lj1w+W/54cA6uLousPqQRyQXhtxSbMzHGb6Ek6lr3/A8qMMKlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+y4B2Hq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+y4B2Hq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772F61F00899;
	Thu, 17 Sep 2026 15:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659052;
	bh=rf/AnUcVG/Anmzn3h+TfrDbR87ztqXvIrMf88Dba79M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+y4B2Hqt9yw4YPzaWg0wSwGgLnVxOk2zNQgUEsA8yHsCnUE+Enxh7HECyO/fi3MZ
	 imCPkyRqy0q/91ufBpzL9QabtO25Wg4AyPIYDQ80caFG0rxYc/ibhzTuKYId4VMf+2
	 AvK7Rnax66lrfbLbknXF1zItKcDuEDpK9IXdNA3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 120/733] ASoC: ab8500: Validate and program TDM slots correctly
Date: Thu, 17 Sep 2026 16:07:08 +0100
Message-ID: <20260917151353.994907569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 85cef7e2004ef5c1a715feaddb55d3f3d27bac0a ]

The interface clock ratio is selected from the slot count alone, ffs()
and fls() produce one-based hardware slot numbers, eight-channel mode
does not program any mappings, and all register errors are ignored.
Invalid masks can also leave a partially programmed interface.

Validate the complete configuration first, derive the supported BCLK
ratio from slots times slot width, use zero-based slot indices, program
deterministic eight-channel maps, and propagate register failures.

Fixes: 679d7abdc754 ("ASoC: codecs: Add AB8500 codec-driver")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260831-ab8500-codec-fixes-v1-4-f85024e717e3@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ab8500-codec.c | 216 ++++++++++++++++++--------------
 1 file changed, 123 insertions(+), 93 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 7d2c07419f3d8..63b0d57341396 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -1882,23 +1882,27 @@ static int ab8500_codec_set_dai_tdm_slot(struct snd_soc_dai *dai,
 		int slots, int slot_width)
 {
 	struct snd_soc_component *component = dai->component;
-	unsigned int val, mask, slot, slots_active;
+	unsigned int active_mask, clock_ratio, slot, value, ad_out, reg;
+	unsigned int tx_active, rx_active;
+	unsigned int conf1_val, conf2_val;
+	unsigned int mask;
+	int channel, ret;
 
 	mask = BIT(AB8500_DIGIFCONF2_IF0WL0) |
 		BIT(AB8500_DIGIFCONF2_IF0WL1);
-	val = 0;
+	conf2_val = 0;
 
 	switch (slot_width) {
 	case 16:
 		break;
 	case 20:
-		val |= BIT(AB8500_DIGIFCONF2_IF0WL0);
+		conf2_val |= BIT(AB8500_DIGIFCONF2_IF0WL0);
 		break;
 	case 24:
-		val |= BIT(AB8500_DIGIFCONF2_IF0WL1);
+		conf2_val |= BIT(AB8500_DIGIFCONF2_IF0WL1);
 		break;
 	case 32:
-		val |= BIT(AB8500_DIGIFCONF2_IF0WL1) |
+		conf2_val |= BIT(AB8500_DIGIFCONF2_IF0WL1) |
 			BIT(AB8500_DIGIFCONF2_IF0WL0);
 		break;
 	default:
@@ -1907,27 +1911,11 @@ static int ab8500_codec_set_dai_tdm_slot(struct snd_soc_dai *dai,
 		return -EINVAL;
 	}
 
-	dev_dbg(dai->component->dev, "%s: IF0 slot-width: %d bits.\n",
-		__func__, slot_width);
-	snd_soc_component_update_bits(component, AB8500_DIGIFCONF2, mask, val);
-
-	/* Setup TDM clocking according to slot count */
-	dev_dbg(dai->component->dev, "%s: Slots, total: %d\n", __func__, slots);
-	mask = BIT(AB8500_DIGIFCONF1_IF0BITCLKOS0) |
-			BIT(AB8500_DIGIFCONF1_IF0BITCLKOS1);
 	switch (slots) {
 	case 2:
-		val = AB8500_MASK_NONE;
-		break;
 	case 4:
-		val = BIT(AB8500_DIGIFCONF1_IF0BITCLKOS0);
-		break;
 	case 8:
-		val = BIT(AB8500_DIGIFCONF1_IF0BITCLKOS1);
-		break;
 	case 16:
-		val = BIT(AB8500_DIGIFCONF1_IF0BITCLKOS0) |
-			BIT(AB8500_DIGIFCONF1_IF0BITCLKOS1);
 		break;
 	default:
 		dev_err(dai->component->dev,
@@ -1935,92 +1923,134 @@ static int ab8500_codec_set_dai_tdm_slot(struct snd_soc_dai *dai,
 			__func__, slots);
 		return -EINVAL;
 	}
-	snd_soc_component_update_bits(component, AB8500_DIGIFCONF1, mask, val);
-
-	/* Setup TDM DA according to active tx slots */
 
-	if (tx_mask & ~0xff)
-		return -EINVAL;
-
-	mask = AB8500_DASLOTCONFX_SLTODAX_MASK;
-	tx_mask = tx_mask << AB8500_DA_DATA0_OFFSET;
-	slots_active = hweight32(tx_mask);
-
-	dev_dbg(dai->component->dev, "%s: Slots, active, TX: %d\n", __func__,
-		slots_active);
-
-	switch (slots_active) {
-	case 0:
+	clock_ratio = slots * slot_width;
+	switch (clock_ratio) {
+	case 32:
+		conf1_val = 0;
 		break;
-	case 1:
-		slot = ffs(tx_mask);
-		snd_soc_component_update_bits(component, AB8500_DASLOTCONF1, mask, slot);
-		snd_soc_component_update_bits(component, AB8500_DASLOTCONF3, mask, slot);
-		snd_soc_component_update_bits(component, AB8500_DASLOTCONF2, mask, slot);
-		snd_soc_component_update_bits(component, AB8500_DASLOTCONF4, mask, slot);
+	case 64:
+		conf1_val = BIT(AB8500_DIGIFCONF1_IF0BITCLKOS0);
 		break;
-	case 2:
-		slot = ffs(tx_mask);
-		snd_soc_component_update_bits(component, AB8500_DASLOTCONF1, mask, slot);
-		snd_soc_component_update_bits(component, AB8500_DASLOTCONF3, mask, slot);
-		slot = fls(tx_mask);
-		snd_soc_component_update_bits(component, AB8500_DASLOTCONF2, mask, slot);
-		snd_soc_component_update_bits(component, AB8500_DASLOTCONF4, mask, slot);
+	case 128:
+		conf1_val = BIT(AB8500_DIGIFCONF1_IF0BITCLKOS1);
 		break;
-	case 8:
-		dev_dbg(dai->component->dev,
-			"%s: In 8-channel mode DA-from-slot mapping is set manually.",
-			__func__);
+	case 256:
+		conf1_val = BIT(AB8500_DIGIFCONF1_IF0BITCLKOS0) |
+			    BIT(AB8500_DIGIFCONF1_IF0BITCLKOS1);
 		break;
 	default:
-		dev_err(dai->component->dev,
-			"%s: Unsupported number of active TX-slots (%d)!\n",
-			__func__, slots_active);
+		dev_err(component->dev, "%s: Unsupported BCLK ratio (%u)!\n",
+			__func__, clock_ratio);
 		return -EINVAL;
 	}
 
-	/* Setup TDM AD according to active RX-slots */
+	active_mask = GENMASK(min(slots, 8) - 1, 0);
+	if ((tx_mask | rx_mask) & ~active_mask) {
+		dev_err(component->dev, "%s: Slot mask exceeds slot count\n",
+			__func__);
+		return -EINVAL;
+	}
 
-	if (rx_mask & ~0xff)
+	tx_active = hweight32(tx_mask);
+	rx_active = hweight32(rx_mask);
+	if (tx_active != 0 && tx_active != 1 && tx_active != 2 &&
+	    tx_active != 8) {
+		dev_err(component->dev, "%s: Unsupported active TX slots (%u)!\n",
+			__func__, tx_active);
+		return -EINVAL;
+	}
+	if (rx_active != 0 && rx_active != 1 && rx_active != 2 &&
+	    rx_active != 8) {
+		dev_err(component->dev, "%s: Unsupported active RX slots (%u)!\n",
+			__func__, rx_active);
 		return -EINVAL;
+	}
+
+	dev_dbg(component->dev,
+		"%s: %d slots of %d bits, TX active: %u, RX active: %u\n",
+		__func__, slots, slot_width, tx_active, rx_active);
 
-	rx_mask = rx_mask << AB8500_AD_DATA0_OFFSET;
-	slots_active = hweight32(rx_mask);
+	ret = snd_soc_component_update_bits(component, AB8500_DIGIFCONF2,
+					    mask, conf2_val);
+	if (ret < 0)
+		return ret;
 
-	dev_dbg(dai->component->dev, "%s: Slots, active, RX: %d\n", __func__,
-		slots_active);
+	mask = BIT(AB8500_DIGIFCONF1_IF0BITCLKOS0) |
+	       BIT(AB8500_DIGIFCONF1_IF0BITCLKOS1);
+	ret = snd_soc_component_update_bits(component, AB8500_DIGIFCONF1,
+					    mask, conf1_val);
+	if (ret < 0)
+		return ret;
 
-	switch (slots_active) {
-	case 0:
-		break;
-	case 1:
-		slot = ffs(rx_mask);
-		snd_soc_component_update_bits(component, AB8500_ADSLOTSEL(slot),
-				AB8500_MASK_SLOT(slot),
-				AB8500_ADSLOTSELX_AD_OUT_TO_SLOT(AB8500_AD_OUT3, slot));
-		break;
-	case 2:
-		slot = ffs(rx_mask);
-		snd_soc_component_update_bits(component,
-				AB8500_ADSLOTSEL(slot),
-				AB8500_MASK_SLOT(slot),
-				AB8500_ADSLOTSELX_AD_OUT_TO_SLOT(AB8500_AD_OUT3, slot));
-		slot = fls(rx_mask);
-		snd_soc_component_update_bits(component,
-				AB8500_ADSLOTSEL(slot),
-				AB8500_MASK_SLOT(slot),
-				AB8500_ADSLOTSELX_AD_OUT_TO_SLOT(AB8500_AD_OUT2, slot));
-		break;
-	case 8:
-		dev_dbg(dai->component->dev,
-			"%s: In 8-channel mode AD-to-slot mapping is set manually.",
-			__func__);
-		break;
-	default:
-		dev_err(dai->component->dev,
-			"%s: Unsupported number of active RX-slots (%d)!\n",
-			__func__, slots_active);
-		return -EINVAL;
+	mask = AB8500_DASLOTCONFX_SLTODAX_MASK;
+	if (tx_active == 1 || tx_active == 2) {
+		slot = __ffs(tx_mask) + AB8500_DA_DATA0_OFFSET;
+		reg = AB8500_DASLOTCONF1;
+		ret = snd_soc_component_update_bits(component, reg, mask, slot);
+		if (ret < 0)
+			return ret;
+		reg = AB8500_DASLOTCONF3;
+		ret = snd_soc_component_update_bits(component, reg, mask, slot);
+		if (ret < 0)
+			return ret;
+
+		if (tx_active == 2)
+			slot = __fls(tx_mask) + AB8500_DA_DATA0_OFFSET;
+		reg = AB8500_DASLOTCONF2;
+		ret = snd_soc_component_update_bits(component, reg, mask, slot);
+		if (ret < 0)
+			return ret;
+		reg = AB8500_DASLOTCONF4;
+		ret = snd_soc_component_update_bits(component, reg, mask, slot);
+		if (ret < 0)
+			return ret;
+	} else if (tx_active == 8) {
+		channel = 0;
+		for (slot = 0; slot < 8; slot++) {
+			if (!(tx_mask & BIT(slot)))
+				continue;
+			reg = AB8500_DASLOTCONF1 + channel++;
+			value = slot + AB8500_DA_DATA0_OFFSET;
+			ret = snd_soc_component_update_bits(component, reg, mask, value);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	if (rx_active == 1 || rx_active == 2) {
+		slot = __ffs(rx_mask) + AB8500_AD_DATA0_OFFSET;
+		value = AB8500_ADSLOTSELX_AD_OUT_TO_SLOT(AB8500_AD_OUT3,
+							 slot);
+		reg = AB8500_ADSLOTSEL(slot);
+		mask = AB8500_MASK_SLOT(slot);
+		ret = snd_soc_component_update_bits(component, reg, mask, value);
+		if (ret < 0)
+			return ret;
+
+		if (rx_active == 2) {
+			slot = __fls(rx_mask) + AB8500_AD_DATA0_OFFSET;
+			value = AB8500_ADSLOTSELX_AD_OUT_TO_SLOT(AB8500_AD_OUT2,
+								 slot);
+			reg = AB8500_ADSLOTSEL(slot);
+			mask = AB8500_MASK_SLOT(slot);
+			ret = snd_soc_component_update_bits(component, reg, mask, value);
+			if (ret < 0)
+				return ret;
+		}
+	} else if (rx_active == 8) {
+		channel = 0;
+		for (slot = 0; slot < 8; slot++) {
+			if (!(rx_mask & BIT(slot)))
+				continue;
+			ad_out = AB8500_AD_OUT1 + channel++;
+			value = AB8500_ADSLOTSELX_AD_OUT_TO_SLOT(ad_out, slot);
+			reg = AB8500_ADSLOTSEL(slot);
+			mask = AB8500_MASK_SLOT(slot);
+			ret = snd_soc_component_update_bits(component, reg, mask, value);
+			if (ret < 0)
+				return ret;
+		}
 	}
 
 	return 0;
-- 
2.53.0



