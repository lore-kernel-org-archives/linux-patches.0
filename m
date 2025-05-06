Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9FF21ABC2;
	Tue,  6 May 2025 21:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567371; cv=none; b=WPEwF1t/QdFOPKEJdZObTbBUOS3jzakqeLjpBUbOO8lETfUqgY5/zDERzBpPCXZoNOBVXZChrFF838DZsZlQamTx+xpMHw/hrgO63aJaDWK1d9WDxeiuNPm56Jkbc4A3GS1IMw8FgU2dPO7D8vBs9T+/aLqXfNLmrubybdweVMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567371; c=relaxed/simple;
	bh=Eoezmwc1mQuw/h1zpgZmj0kj/x9SlLTyaWjd2qTeR6o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QmPqqH9t9dRr0x23f04NxYbde//T2DXjCSP/4f/KGz6csG2j8Sx3akpTJ6er/tlq5q224dygn6eywLenUaiJYAA1Epf2OOcZCb5k6wtn5a2lf7guEcrxLH6ezFaqVT4wFLv54hOQqxO5VWJuZdFelbcJp4g/9q/9HTXuzr6z+N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZiA25YaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZiA25YaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8217C4CEE4;
	Tue,  6 May 2025 21:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567369;
	bh=Eoezmwc1mQuw/h1zpgZmj0kj/x9SlLTyaWjd2qTeR6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiA25YaOh/BHnB77qeL6WjIL0hEQTbtt7Ucvtr3J+7Yx/EGvA+SB0T8AHL+Fs+HlV
	 4+aJSMvwkmQydU+M3hDCZ57yqpgcL1GdXMm/njLO9styeEoFlGzqPihfhbRamQFxEq
	 ip4En614z1mY07pX15hMdQ0mRxZ0ADuyC7RSNuBEyNJXaiwYPdRAcYIFUdlL21G00y
	 1csEgYy4eqsemm68aaCqshY1c86860+/f06kT44QwE9LhTzWZ7ragibGIf0DyydP4o
	 lcQFq475ZPJD+wHfrrjLUHnrFzHNuCbpSvMDty4LF5PJFQWc2VUcm+UE7dB+qucEE1
	 l4WEUHU6Tq/Ww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stefan Binding <sbinding@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	Vijendar.Mukunda@amd.com,
	yung-chuan.liao@linux.intel.com,
	pierre-louis.bossart@linux.dev,
	peterz@infradead.org,
	peter.ujfalusi@linux.intel.com,
	rf@opensource.cirrus.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 20/20] ASoC: intel/sdw_utils: Add volume limit to cs35l56 speakers
Date: Tue,  6 May 2025 17:35:23 -0400
Message-Id: <20250506213523.2982756-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213523.2982756-1-sashal@kernel.org>
References: <20250506213523.2982756-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit d5463e531c128ff1b141fdba2e13345cd50028a4 ]

The volume control for cs35l56 speakers has a maximum gain of +12 dB.
However, for many use cases, this can cause distorted audio, depending
various factors, such as other signal-processing elements in the chain,
for example if the audio passes through a gain control before reaching
the amp or the signal path has been tuned for a particular maximum
gain in the amp.

In the case of systems which use the soc_sdw_* driver, audio will
likely be distorted in all cases above 0 dB, therefore add a volume
limit of 400, which is 0 dB maximum volume inside this driver.

The volume limit should be applied to both soundwire and soundwire
bridge configurations.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://patch.msgid.link/20250430103134.24579-3-sbinding@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc_sdw_utils.h                |  1 +
 sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c |  4 ++++
 sound/soc/sdw_utils/soc_sdw_cs_amp.c         | 24 ++++++++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/include/sound/soc_sdw_utils.h b/include/sound/soc_sdw_utils.h
index 36a4a1e1d8ca2..d8bd5d37131aa 100644
--- a/include/sound/soc_sdw_utils.h
+++ b/include/sound/soc_sdw_utils.h
@@ -226,6 +226,7 @@ int asoc_sdw_cs_amp_init(struct snd_soc_card *card,
 			 bool playback);
 int asoc_sdw_cs_spk_feedback_rtd_init(struct snd_soc_pcm_runtime *rtd,
 				      struct snd_soc_dai *dai);
+int asoc_sdw_cs35l56_volume_limit(struct snd_soc_card *card, const char *name_prefix);
 
 /* MAXIM codec support */
 int asoc_sdw_maxim_init(struct snd_soc_card *card,
diff --git a/sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c b/sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c
index 246e5c2e0af55..c7e55f4433514 100644
--- a/sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c
+++ b/sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c
@@ -60,6 +60,10 @@ static int asoc_sdw_bridge_cs35l56_asp_init(struct snd_soc_pcm_runtime *rtd)
 
 	/* 4 x 16-bit sample slots and FSYNC=48000, BCLK=3.072 MHz */
 	for_each_rtd_codec_dais(rtd, i, codec_dai) {
+		ret = asoc_sdw_cs35l56_volume_limit(card, codec_dai->component->name_prefix);
+		if (ret)
+			return ret;
+
 		ret = snd_soc_dai_set_tdm_slot(codec_dai, tx_mask, rx_mask, 4, 16);
 		if (ret < 0)
 			return ret;
diff --git a/sound/soc/sdw_utils/soc_sdw_cs_amp.c b/sound/soc/sdw_utils/soc_sdw_cs_amp.c
index 4b6181cf29716..35b550bcd4ded 100644
--- a/sound/soc/sdw_utils/soc_sdw_cs_amp.c
+++ b/sound/soc/sdw_utils/soc_sdw_cs_amp.c
@@ -16,6 +16,25 @@
 
 #define CODEC_NAME_SIZE	8
 #define CS_AMP_CHANNELS_PER_AMP	4
+#define CS35L56_SPK_VOLUME_0DB 400 /* 0dB Max */
+
+int asoc_sdw_cs35l56_volume_limit(struct snd_soc_card *card, const char *name_prefix)
+{
+	char *volume_ctl_name;
+	int ret;
+
+	volume_ctl_name = kasprintf(GFP_KERNEL, "%s Speaker Volume", name_prefix);
+	if (!volume_ctl_name)
+		return -ENOMEM;
+
+	ret = snd_soc_limit_volume(card, volume_ctl_name, CS35L56_SPK_VOLUME_0DB);
+	if (ret)
+		dev_err(card->dev, "%s limit set failed: %d\n", volume_ctl_name, ret);
+
+	kfree(volume_ctl_name);
+	return ret;
+}
+EXPORT_SYMBOL_NS(asoc_sdw_cs35l56_volume_limit, "SND_SOC_SDW_UTILS");
 
 int asoc_sdw_cs_spk_rtd_init(struct snd_soc_pcm_runtime *rtd, struct snd_soc_dai *dai)
 {
@@ -40,6 +59,11 @@ int asoc_sdw_cs_spk_rtd_init(struct snd_soc_pcm_runtime *rtd, struct snd_soc_dai
 
 		snprintf(widget_name, sizeof(widget_name), "%s SPK",
 			 codec_dai->component->name_prefix);
+
+		ret = asoc_sdw_cs35l56_volume_limit(card, codec_dai->component->name_prefix);
+		if (ret)
+			return ret;
+
 		ret = snd_soc_dapm_add_routes(&card->dapm, &route, 1);
 		if (ret)
 			return ret;
-- 
2.39.5

