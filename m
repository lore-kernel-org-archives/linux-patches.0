Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD362566;
	Tue, 27 May 2025 17:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368310; cv=none; b=KcoAm4VNXvtnzZrLFUerkIa5y7JKM4BhzMT8wwOqmW5N+/4/1547YWTON3NHyXi+jgrjUB9Vk5S7LKuKpzmw+ajR9DGQB+cC/1S+B0zC/VVRHYd+/7NZ8D+jXz0oHQk+ao+zpXytfYlDtoJjdylm87HS2bke69Sfpp8sCMildSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368310; c=relaxed/simple;
	bh=J/AO0H4b8vX2dxICYyrqOD6rpP0M5Yaa9Wn1kmFy4pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVUcjm1qfaHHsinNPCuFBWjyfS/sD/FswpyQkK8MuZAKMnPaYAvvXpUMSge+JjQz6irCd7pijnO53kp/nysAfI+9DggIQlANj0Uy+n8KsoLXinebPWRxHYSllF2mxo0lOtq1WTtJg22CNRpLXy6Am5aSWZXp6yplQN63AoiKPvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQKsrrh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQKsrrh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E5BC4CEE9;
	Tue, 27 May 2025 17:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368310;
	bh=J/AO0H4b8vX2dxICYyrqOD6rpP0M5Yaa9Wn1kmFy4pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQKsrrh1hHJH6v+vb8FJolqBBCowe9GhIehlt2ueMlZaEIWLLSwIkE4XZi7xDVSY3
	 zM7mm5Oup2kaSkJGY6yutsQxMkzjOenuR0B44CpkCx2l2XHBUqCTit2BzIOJbj3rRH
	 zTiMG1aM7QLB929WNYfetPGC4uIKhqrXaogjBYFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 666/783] ASoC: intel/sdw_utils: Add volume limit to cs35l56 speakers
Date: Tue, 27 May 2025 18:27:43 +0200
Message-ID: <20250527162540.244882235@linuxfoundation.org>
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



