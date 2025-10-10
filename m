Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17C02F39B3;
	Fri, 10 Oct 2025 13:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102433; cv=none; b=UMYyM4mgIg/aQPT6lNcffDU82ylNoe4ugJt8nZ1kWnsC+4Apniv1WiavMaNCES2GHM3DgT+J0l/s2l+q1qea8wYoVXdfYZi4Ap4PSghIGsbYN5zIOxrGURsokINc6lVD/Z2PX2AwqgV+4mQDcOi+CL5niSkBgy0ysBtnbGzBkCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102433; c=relaxed/simple;
	bh=8BaAOu7aqbczaMdwoHMdp72KC5OlvFFrp8k95C673Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNdYtkslTQ77tXjIrEY2P0J53aQM7U9Pwq/KShV3dOHEg+l55YpL1rDbQAe9jyBY8pKwcMGsLU9r+7047vPXjsz/FVxgFzeyJoQsn8dkaEbadcK/Moo8M0jnBusEIDZuCoUlmcJ7nO7+gbN2iCRwFWF1KrYSVAerziWENOj7XZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mE/tMu6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mE/tMu6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B59C4CEF1;
	Fri, 10 Oct 2025 13:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102433;
	bh=8BaAOu7aqbczaMdwoHMdp72KC5OlvFFrp8k95C673Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mE/tMu6uZuU2Lcx5ers/wYicbpPpZ40TXQkOz/j98iUtBGVkWgFLbHXh72qzcxV7i
	 wWSnbiEjGmQexEtCwZJYPPTtz25qh8sFSI32vCKb6bLsCQ5J1AjqDhfp9UP1BEnwfh
	 Azk+mig/ZtU01whjxRTwSXwbAKcEOAtS4ZezEteA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 13/35] ASoC: rt5682s: Adjust SAR ADC button mode to fix noise issue
Date: Fri, 10 Oct 2025 15:16:15 +0200
Message-ID: <20251010131332.273286780@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit 1dd28fd86c3fa4e395031dd6f2ba920242107010 ]

Adjust register settings for SAR adc button detection mode
to fix noise issue in headset.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://patch.msgid.link/766cd1d2dd7a403ba65bb4cc44845f71@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682s.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/rt5682s.c b/sound/soc/codecs/rt5682s.c
index ce2e88e066f3e..d773c96e2543c 100644
--- a/sound/soc/codecs/rt5682s.c
+++ b/sound/soc/codecs/rt5682s.c
@@ -653,14 +653,15 @@ static void rt5682s_sar_power_mode(struct snd_soc_component *component, int mode
 	switch (mode) {
 	case SAR_PWR_SAVING:
 		snd_soc_component_update_bits(component, RT5682S_CBJ_CTRL_3,
-			RT5682S_CBJ_IN_BUF_MASK, RT5682S_CBJ_IN_BUF_DIS);
+			RT5682S_CBJ_IN_BUF_MASK, RT5682S_CBJ_IN_BUF_EN);
 		snd_soc_component_update_bits(component, RT5682S_CBJ_CTRL_1,
-			RT5682S_MB1_PATH_MASK | RT5682S_MB2_PATH_MASK,
-			RT5682S_CTRL_MB1_REG | RT5682S_CTRL_MB2_REG);
+			RT5682S_MB1_PATH_MASK | RT5682S_MB2_PATH_MASK |
+			RT5682S_VREF_POW_MASK, RT5682S_CTRL_MB1_FSM |
+			RT5682S_CTRL_MB2_FSM | RT5682S_VREF_POW_FSM);
 		snd_soc_component_update_bits(component, RT5682S_SAR_IL_CMD_1,
 			RT5682S_SAR_BUTDET_MASK | RT5682S_SAR_BUTDET_POW_MASK |
 			RT5682S_SAR_SEL_MB1_2_CTL_MASK, RT5682S_SAR_BUTDET_DIS |
-			RT5682S_SAR_BUTDET_POW_SAV | RT5682S_SAR_SEL_MB1_2_MANU);
+			RT5682S_SAR_BUTDET_POW_NORM | RT5682S_SAR_SEL_MB1_2_MANU);
 		usleep_range(5000, 5500);
 		snd_soc_component_update_bits(component, RT5682S_SAR_IL_CMD_1,
 			RT5682S_SAR_BUTDET_MASK, RT5682S_SAR_BUTDET_EN);
@@ -688,7 +689,7 @@ static void rt5682s_sar_power_mode(struct snd_soc_component *component, int mode
 		snd_soc_component_update_bits(component, RT5682S_SAR_IL_CMD_1,
 			RT5682S_SAR_BUTDET_MASK | RT5682S_SAR_BUTDET_POW_MASK |
 			RT5682S_SAR_SEL_MB1_2_CTL_MASK, RT5682S_SAR_BUTDET_DIS |
-			RT5682S_SAR_BUTDET_POW_SAV | RT5682S_SAR_SEL_MB1_2_MANU);
+			RT5682S_SAR_BUTDET_POW_NORM | RT5682S_SAR_SEL_MB1_2_MANU);
 		break;
 	default:
 		dev_err(component->dev, "Invalid SAR Power mode: %d\n", mode);
@@ -725,7 +726,7 @@ static void rt5682s_disable_push_button_irq(struct snd_soc_component *component)
 	snd_soc_component_update_bits(component, RT5682S_SAR_IL_CMD_1,
 		RT5682S_SAR_BUTDET_MASK | RT5682S_SAR_BUTDET_POW_MASK |
 		RT5682S_SAR_SEL_MB1_2_CTL_MASK, RT5682S_SAR_BUTDET_DIS |
-		RT5682S_SAR_BUTDET_POW_SAV | RT5682S_SAR_SEL_MB1_2_MANU);
+		RT5682S_SAR_BUTDET_POW_NORM | RT5682S_SAR_SEL_MB1_2_MANU);
 }
 
 /**
@@ -786,7 +787,7 @@ static int rt5682s_headset_detect(struct snd_soc_component *component, int jack_
 			jack_type = SND_JACK_HEADSET;
 			snd_soc_component_write(component, RT5682S_SAR_IL_CMD_3, 0x024c);
 			snd_soc_component_update_bits(component, RT5682S_CBJ_CTRL_1,
-				RT5682S_FAST_OFF_MASK, RT5682S_FAST_OFF_EN);
+				RT5682S_FAST_OFF_MASK, RT5682S_FAST_OFF_DIS);
 			snd_soc_component_update_bits(component, RT5682S_SAR_IL_CMD_1,
 				RT5682S_SAR_SEL_MB1_2_MASK, val << RT5682S_SAR_SEL_MB1_2_SFT);
 			rt5682s_enable_push_button_irq(component);
@@ -966,7 +967,7 @@ static int rt5682s_set_jack_detect(struct snd_soc_component *component,
 			RT5682S_EMB_JD_MASK | RT5682S_DET_TYPE |
 			RT5682S_POL_FAST_OFF_MASK | RT5682S_MIC_CAP_MASK,
 			RT5682S_EMB_JD_EN | RT5682S_DET_TYPE |
-			RT5682S_POL_FAST_OFF_HIGH | RT5682S_MIC_CAP_HS);
+			RT5682S_POL_FAST_OFF_LOW | RT5682S_MIC_CAP_HS);
 		regmap_update_bits(rt5682s->regmap, RT5682S_SAR_IL_CMD_1,
 			RT5682S_SAR_POW_MASK, RT5682S_SAR_POW_EN);
 		regmap_update_bits(rt5682s->regmap, RT5682S_GPIO_CTRL_1,
-- 
2.51.0



