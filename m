Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BEA17727;
	Mon, 27 May 2024 19:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838393; cv=none; b=d4vK6FreAdq5rKEReJhIoALa8giFYm7XyYYLBI1NfqIYop1zA5F17Xer1Y1xKkS9TDZ+nx96QRCyE7T5hYbaYN8VZ4GCvrIE79w60h8JIE2AOgWeM/iZbmjxJUCXEK9mMwl0B/ejAZjlSl7WgoR3brACcbZH9LsaZX53VZOMY2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838393; c=relaxed/simple;
	bh=oHPJF1PiU9HhLeQt3kOkr3BG81XunxH88vybH9NVfS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ku1yWyakFWaS1IdgislBoP+3BA16/AX6xhmKhgErTTC9pFgOa2xN4SoYh5mbidl75JNrhVPKEfm6Jfu7OccFPbH7g5oUq3axle6L0bIWcBO9Tdu+F6Hbq52bts0VkuMvgA3FDcuHWHGo2WpAe3Feb0Rbq9e6BT+UVnpvh5AOQQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6WpAH9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6WpAH9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924A9C2BBFC;
	Mon, 27 May 2024 19:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838392;
	bh=oHPJF1PiU9HhLeQt3kOkr3BG81XunxH88vybH9NVfS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6WpAH9LDkjZNpTuvvDN/j/DtJyKkvtjknRRg1r56DeYqqv0Wt74KOzHhZHwki0Yi
	 nKuHAllO7r80OBEx0t9vmfvlncJnh8xwbbAk95DazTzWc+YHViSOgfu8dJ7+xEx+6l
	 YvgIZAqt/Pnya8ImlVZC77AMHZ4K6OhZ8ytvANqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 375/493] ASoC: SOF: Intel: hda-dai: fix channel map configuration for aggregated dailink
Date: Mon, 27 May 2024 20:56:17 +0200
Message-ID: <20240527185642.540495760@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index f4cbc0ad5de3b..0e665c0840d71 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -434,10 +434,17 @@ int sdw_hda_dai_hw_params(struct snd_pcm_substream *substream,
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
@@ -452,9 +459,29 @@ int sdw_hda_dai_hw_params(struct snd_pcm_substream *substream,
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



