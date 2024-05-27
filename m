Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA58E17E90E;
	Mon, 27 May 2024 19:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837070; cv=none; b=SvEV5veOA4aQf5TOWfmGE/IZWMGIGC7dWIKIqEcGjK89fdy1t7vp/F+zKehZQ4F+0xFvVAC/MvHCHy/bAbQ6IwFSm3FBkAD6TnHofkRE8JJH5Bmvv4tqVU6ZzydhxTwJaJYhTap47PptqcfISj9yl5n5gbw4y0EU8hAd+NOdM+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837070; c=relaxed/simple;
	bh=ZXbD3375AoYj6k3GZgA1MQj02/2gsAG5tbaU4EUBvfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUdnRAk5k7CDvAgqrFROMie6XTuJaJrW5cDSfKWolaYJ/QSPPhEkJaukbX2T2C/ZVCTpLGTvxeQNMEmeANxqIhl4HV1YSMdOrYNyY5JeQQRtOuo4Pa/CSTeSh6uSClBArw7CBmLYXMFE2zG7Oyz83Y7Hta7hANNuDpWw3y5utaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OG8vZphj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OG8vZphj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7104EC2BBFC;
	Mon, 27 May 2024 19:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837070;
	bh=ZXbD3375AoYj6k3GZgA1MQj02/2gsAG5tbaU4EUBvfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OG8vZphjiIiBGskav/SW1tSY9vVJIX65oGGYEjScLJ+C8mWRkIfXkyC3p+unTgBgd
	 HUTiwhUOV+/jcyFz4c7eR4V1jH/8JJQU3BzyFvGXWnQsuRYJSiN0BkSBmzpxwKcGd6
	 0jSe3BSTDxs4COl4VOLPGLw2YWgTqj9B4nVNfk6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 299/427] ASoC: SOF: Intel: hda-dai: fix channel map configuration for aggregated dailink
Date: Mon, 27 May 2024 20:55:46 +0200
Message-ID: <20240527185630.139401920@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 831045513c8a2ef14c3cf39b33d1ccedf588c4a8 ]

The existing code derives the channel map used to program the HDaudio
link DMA from the hw_params, but that is not quite right in the case
of aggregation. The code in soc-pcm.c splits the hw_params depending
on the codec_ch_map, and we need to reconstruct the channel-map to
insert the data in the right places.

This issue is seen only on amplifier feedback capture where the data
from the second amplifier was replaced by that of the first amplifier.

Note that the loop iterator of the macro for_each_rtd_cpu_dais() is
reused in a following loop. This is different to all existing usages
of that macro, hence the use of a boolean flag to avoid an access to
an uninitialized variable.

Fixes: 2960ee5c4814 ("ASoC: SOF: Intel: hda-dai: add helpers for SoundWire callbacks")
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240402151828.175002-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dai.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index c1682bcdb5a66..6a39ca632f55e 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -439,10 +439,17 @@ int sdw_hda_dai_hw_params(struct snd_pcm_substream *substream,
 			  int link_id)
 {
 	struct snd_soc_dapm_widget *w = snd_soc_dai_get_widget(cpu_dai, substream->stream);
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	const struct hda_dai_widget_dma_ops *ops;
+	struct snd_soc_dai_link_ch_map *ch_maps;
 	struct hdac_ext_stream *hext_stream;
+	struct snd_soc_dai *dai;
 	struct snd_sof_dev *sdev;
+	bool cpu_dai_found = false;
+	int cpu_dai_id;
+	int ch_mask;
 	int ret;
+	int j;
 
 	ret = non_hda_dai_hw_params(substream, params, cpu_dai);
 	if (ret < 0) {
@@ -457,9 +464,29 @@ int sdw_hda_dai_hw_params(struct snd_pcm_substream *substream,
 	if (!hext_stream)
 		return -ENODEV;
 
-	/* in the case of SoundWire we need to program the PCMSyCM registers */
+	/*
+	 * in the case of SoundWire we need to program the PCMSyCM registers. In case
+	 * of aggregated devices, we need to define the channel mask for each sublink
+	 * by reconstructing the split done in soc-pcm.c
+	 */
+	for_each_rtd_cpu_dais(rtd, cpu_dai_id, dai) {
+		if (dai == cpu_dai) {
+			cpu_dai_found = true;
+			break;
+		}
+	}
+
+	if (!cpu_dai_found)
+		return -ENODEV;
+
+	ch_mask = 0;
+	for_each_link_ch_maps(rtd->dai_link, j, ch_maps) {
+		if (ch_maps->cpu == cpu_dai_id)
+			ch_mask |= ch_maps->ch_mask;
+	}
+
 	ret = hdac_bus_eml_sdw_map_stream_ch(sof_to_bus(sdev), link_id, cpu_dai->id,
-					     GENMASK(params_channels(params) - 1, 0),
+					     ch_mask,
 					     hdac_stream(hext_stream)->stream_tag,
 					     substream->stream);
 	if (ret < 0) {
-- 
2.43.0



