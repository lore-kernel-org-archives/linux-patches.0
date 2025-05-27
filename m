Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D8825A627;
	Tue, 27 May 2025 17:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367614; cv=none; b=H3d4G0ZRjb9tTX4gWOliyziPT6llF44iTza0J18P+Rijo9S7ynl81CHT2yb/Xxv8z02cZ19gGtjYquIrqcLi2i61FTKLIExjbTfZyWvYbVRG/wWe5VSrC7MnVD/qH9Uvwad02oSDzFN2n9FwrO+6ESR14DBlZu0/x2Rpx8GS0s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367614; c=relaxed/simple;
	bh=BIOcGsGWD9y0JQulbAAM4IaxzlBzA9LHYdVuKfSsOA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAb5JmXsSz75jq4vMKwYlEPjQRB1pODPV62idRaFJRtpFJXoZcRd/XwZyz9ctcMyZYe3yaohFiVhjN8a9OKxSgaL5UWaXLeFXN0Ihhi1C3taTmshoZ+iNAJKgL0BKOw/sVT+2U/ayfYGQO6Is5g3KJkBMaLYNRM0HGsDJYLfRxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igCZY6Q3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igCZY6Q3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8F6C4CEE9;
	Tue, 27 May 2025 17:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367613;
	bh=BIOcGsGWD9y0JQulbAAM4IaxzlBzA9LHYdVuKfSsOA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igCZY6Q3WYB45cuGtPTcQ3mHLrs8ysD3PcbTRD75pUhAlZII0n8xaW7OS4/EDZj5z
	 BvblbqHBNfQWo3Yld5j3lduRDyp50wlgyoEde2ZlymIEm1Ksv3xodvCuyQKezuoVxj
	 vgZMzgDlYU3qJzBrVNt8PaQrZYJvawQn87h2QZXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 442/783] ASoC: tas2764: Power up/down amp on mute ops
Date: Tue, 27 May 2025 18:23:59 +0200
Message-ID: <20250527162531.138599540@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 1c3b5f37409682184669457a5bdf761268eafbe5 ]

The ASoC convention is that clocks are removed after codec mute, and
power up/down is more about top level power management. For these chips,
the "mute" state still expects a TDM clock, and yanking the clock in
this state will trigger clock errors. So, do the full
shutdown<->mute<->active transition on the mute operation, so the amp is
in software shutdown by the time the clocks are removed.

This fixes TDM clock errors when streams are stopped.

Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20250208-asoc-tas2764-v1-1-dbab892a69b5@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 51 ++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index 31f94c8cf2844..39a7d39536fe6 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -180,33 +180,6 @@ static SOC_ENUM_SINGLE_DECL(
 static const struct snd_kcontrol_new tas2764_asi1_mux =
 	SOC_DAPM_ENUM("ASI1 Source", tas2764_ASI1_src_enum);
 
-static int tas2764_dac_event(struct snd_soc_dapm_widget *w,
-			     struct snd_kcontrol *kcontrol, int event)
-{
-	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
-	struct tas2764_priv *tas2764 = snd_soc_component_get_drvdata(component);
-	int ret;
-
-	switch (event) {
-	case SND_SOC_DAPM_POST_PMU:
-		tas2764->dac_powered = true;
-		ret = tas2764_update_pwr_ctrl(tas2764);
-		break;
-	case SND_SOC_DAPM_PRE_PMD:
-		tas2764->dac_powered = false;
-		ret = tas2764_update_pwr_ctrl(tas2764);
-		break;
-	default:
-		dev_err(tas2764->dev, "Unsupported event\n");
-		return -EINVAL;
-	}
-
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
 static const struct snd_kcontrol_new isense_switch =
 	SOC_DAPM_SINGLE("Switch", TAS2764_PWR_CTRL, TAS2764_ISENSE_POWER_EN, 1, 1);
 static const struct snd_kcontrol_new vsense_switch =
@@ -219,8 +192,7 @@ static const struct snd_soc_dapm_widget tas2764_dapm_widgets[] = {
 			    1, &isense_switch),
 	SND_SOC_DAPM_SWITCH("VSENSE", TAS2764_PWR_CTRL, TAS2764_VSENSE_POWER_EN,
 			    1, &vsense_switch),
-	SND_SOC_DAPM_DAC_E("DAC", NULL, SND_SOC_NOPM, 0, 0, tas2764_dac_event,
-			   SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
+	SND_SOC_DAPM_DAC("DAC", NULL, SND_SOC_NOPM, 0, 0),
 	SND_SOC_DAPM_OUTPUT("OUT"),
 	SND_SOC_DAPM_SIGGEN("VMON"),
 	SND_SOC_DAPM_SIGGEN("IMON")
@@ -241,9 +213,28 @@ static int tas2764_mute(struct snd_soc_dai *dai, int mute, int direction)
 {
 	struct tas2764_priv *tas2764 =
 			snd_soc_component_get_drvdata(dai->component);
+	int ret;
+
+	if (!mute) {
+		tas2764->dac_powered = true;
+		ret = tas2764_update_pwr_ctrl(tas2764);
+		if (ret)
+			return ret;
+	}
 
 	tas2764->unmuted = !mute;
-	return tas2764_update_pwr_ctrl(tas2764);
+	ret = tas2764_update_pwr_ctrl(tas2764);
+	if (ret)
+		return ret;
+
+	if (mute) {
+		tas2764->dac_powered = false;
+		ret = tas2764_update_pwr_ctrl(tas2764);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int tas2764_set_bitwidth(struct tas2764_priv *tas2764, int bitwidth)
-- 
2.39.5



