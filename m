Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E82A19A2A7;
	Thu,  6 Jun 2024 14:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683018; cv=none; b=c2wBsfiXCCQoq9FdojJFiTblSeXzLC2YrMCnkzJyJCsygRqdOFliaBQ1f7wYFRJ7+keQeBZ/jrxHEp8eVOrz2LWoa/wEkSKfYuXTree7yrpIRBybbstbF+h48OykmEU+u2RZ6bwTLcXHpvL8t+to+Jc2kxD60V2ks/cP3H5txO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683018; c=relaxed/simple;
	bh=7AhlLpr/kef3I6L4YGWPDCBUFancnb1YAFpgB9mlZo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nb348gM4He80QjuGsy1+GwE2j6wKgVkWhrcrM9ltix9IXgdoYMR9+fEcRRdUQVT5efLBG4k/VkzF/x2Fhvlzo+GTmb/nmxCTfTMfNknfss7nubmdmXQjAH1ddCQ0Hhx+4W15WNoP84TyHBb1A7oGARZaV6CM95nLxBOr0MJ4t4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5Hvvp7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5Hvvp7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFC9C32781;
	Thu,  6 Jun 2024 14:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683017;
	bh=7AhlLpr/kef3I6L4YGWPDCBUFancnb1YAFpgB9mlZo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5Hvvp7APh1OfIzgZeq+7v5LUv1d0D47GyJ3cGOqZCSg1Cd0CbZYcgAMyeqMay/4n
	 C+sV+OEQfaJReZ9fsDFKcRON8NRoI4NWxqcTtS82A5MfJmKqxnxTDUbq4n7P3+hSjw
	 lLoJ+0lSEFYJ7QmHngmfd6kWwX3GGheysQ7l5mto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 237/374] ASoC: tas2552: Add TX path for capturing AUDIO-OUT data
Date: Thu,  6 Jun 2024 16:03:36 +0200
Message-ID: <20240606131659.761046522@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit 7078ac4fd179a68d0bab448004fcd357e7a45f8d ]

TAS2552 is a Smartamp with I/V sense data, add TX path
to support capturing I/V data.

Fixes: 38803ce7b53b ("ASoC: codecs: tas*: merge .digital_mute() into .mute_stream()")
Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://msgid.link/r/20240518033515.866-1-shenghao-ding@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2552.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tas2552.c b/sound/soc/codecs/tas2552.c
index 8c9dc318b0e82..c65a4219ecd6c 100644
--- a/sound/soc/codecs/tas2552.c
+++ b/sound/soc/codecs/tas2552.c
@@ -2,7 +2,8 @@
 /*
  * tas2552.c - ALSA SoC Texas Instruments TAS2552 Mono Audio Amplifier
  *
- * Copyright (C) 2014 Texas Instruments Incorporated -  https://www.ti.com
+ * Copyright (C) 2014 - 2024 Texas Instruments Incorporated -
+ *	https://www.ti.com
  *
  * Author: Dan Murphy <dmurphy@ti.com>
  */
@@ -119,12 +120,14 @@ static const struct snd_soc_dapm_widget tas2552_dapm_widgets[] =
 			 &tas2552_input_mux_control),
 
 	SND_SOC_DAPM_AIF_IN("DAC IN", "DAC Playback", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("ASI OUT", "DAC Capture", 0, SND_SOC_NOPM, 0, 0),
 	SND_SOC_DAPM_DAC("DAC", NULL, SND_SOC_NOPM, 0, 0),
 	SND_SOC_DAPM_OUT_DRV("ClassD", TAS2552_CFG_2, 7, 0, NULL, 0),
 	SND_SOC_DAPM_SUPPLY("PLL", TAS2552_CFG_2, 3, 0, NULL, 0),
 	SND_SOC_DAPM_POST("Post Event", tas2552_post_event),
 
-	SND_SOC_DAPM_OUTPUT("OUT")
+	SND_SOC_DAPM_OUTPUT("OUT"),
+	SND_SOC_DAPM_INPUT("DMIC")
 };
 
 static const struct snd_soc_dapm_route tas2552_audio_map[] = {
@@ -134,6 +137,7 @@ static const struct snd_soc_dapm_route tas2552_audio_map[] = {
 	{"ClassD", NULL, "Input selection"},
 	{"OUT", NULL, "ClassD"},
 	{"ClassD", NULL, "PLL"},
+	{"ASI OUT", NULL, "DMIC"}
 };
 
 #ifdef CONFIG_PM
@@ -538,6 +542,13 @@ static struct snd_soc_dai_driver tas2552_dai[] = {
 			.rates = SNDRV_PCM_RATE_8000_192000,
 			.formats = TAS2552_FORMATS,
 		},
+		.capture = {
+			.stream_name = "Capture",
+			.channels_min = 2,
+			.channels_max = 2,
+			.rates = SNDRV_PCM_RATE_8000_192000,
+			.formats = TAS2552_FORMATS,
+		},
 		.ops = &tas2552_speaker_dai_ops,
 	},
 };
-- 
2.43.0



