Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB2A2F2602;
	Fri, 10 Oct 2025 13:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102339; cv=none; b=RHaMG2Pv5wF4SEpW5XwRJsYt24iTr85vN6BOjqBswEGP7VyeBTTE6705sG8C91PA6DivKdncfV5aF7BuzzBM3uCmAOm1tXB22f7PBXEu7KaJVxAlFxtSi6MA2EtLDEp3FwNzkoTJahttEDw1XrrudCo9MvNHWR3gO/CKwK+walw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102339; c=relaxed/simple;
	bh=s/0lu1+tWeT3QK0fbk5nD+YiJQoNumZFW3a4NsxdMUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4G0LAuQnhBr+G8/tN/EQMNikX/9pp56nyRDpDHl+GOh/0oLNZKY9O330eNU71LL0vAZVt1U+pDtsGo3fVQidHUyVgVDY+EJaYmY5TCRuuOoDzMXfNHenhIqZjFBf+BmSS0syFEwQRou89ezwdDmTtS9+42IoZqta2RcNrFzrj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l28wzFZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l28wzFZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1CFC4CEF8;
	Fri, 10 Oct 2025 13:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102338;
	bh=s/0lu1+tWeT3QK0fbk5nD+YiJQoNumZFW3a4NsxdMUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l28wzFZPmgpDYTjaQ3mDN+ZUqsglL2ZnkxizMP+i7L9yIHE9kUd8Zwa4oYp2QzVwz
	 YUgO0JlAQrXd79CFhlHlPv3dhKdke2k4jUsYOcyn11X7t3zy2a83YsaXTSStX5jjZ/
	 QhfbW/upinvIy6ubNbvAKXlp098PvQtcULDiGua4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 21/41] ASoC: rt5682s: Adjust SAR ADC button mode to fix noise issue
Date: Fri, 10 Oct 2025 15:16:09 +0200
Message-ID: <20251010131334.187706412@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 73c4b3c31f8c4..d44f7574631dc 100644
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



