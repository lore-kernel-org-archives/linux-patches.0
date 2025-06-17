Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB552FA622;
	Tue, 17 Jun 2025 16:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179124; cv=none; b=Bv1Qq/4ngwTbzV4VJUk+0VkDIIEFx24FgPpFiodi2CQEyw1gNNQiJY0g+SPLsqENSFiGJzFkvcPtcgUdWSjTM2q8XnvC761NTpQm3lsC1qOCT+gA6/e+izy3nR4/bkp5GQ6jnFn7vsQPmfWZZuwGEPI69SYRv9JfxjZzG6lb9Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179124; c=relaxed/simple;
	bh=acr92J2tpuMT4SfhqkTRjwX+PoUqrTJJJPLftUnkTT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i4+QHuKr7pdfMD2M9I61KiMiW66QDS9AoYfgjyn2ILoUP/YggTJDe1bs7j9eBQAFcMvy12BDNSl55KOrbmdVId+bTQRicfT78QN0Q2nqWmsg6WeF/TNBGeSv1IAzHMrIYJEbKFqR+RtK1gXW3V0KZ56jU5msDwFOreLZSkh26Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXw3Qv4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXw3Qv4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4AEC4CEE7;
	Tue, 17 Jun 2025 16:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179124;
	bh=acr92J2tpuMT4SfhqkTRjwX+PoUqrTJJJPLftUnkTT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXw3Qv4vL916t3H9FljIQLue0M+bpAGYsUHNm8tJCAnyNtcvrIZUGRaDf2/JP9yxa
	 Ev/xt+n3Q1qRFGzXXauMVhqCqiqyX5D3Z8ZRPLAJw0GMYq4ft25QL8XEzTYiER/RSv
	 sOJB2+MswVgnoCBoPQIgIneyKeTaCYaRjAYKC0Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Liam Girdwood <liam.r.girdwood@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 638/780] ASoC: Intel: avs: PCM operations for LNL-based platforms
Date: Tue, 17 Jun 2025 17:25:46 +0200
Message-ID: <20250617152517.455472951@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 716643786f140f2d68f22424c75b9198ffe14290 ]

Starting from LNL platform the so-called non-HDAudio transfer types,
e.g.: I2S/DMIC, utilize HDAudio LINK DMA rather than GPDMA for the data
streaming. In essence, all transfer types now utilize HDAudio Link. Most
of the existing code can be reused with the major difference being
HDAudio Link query method:

- fetch the Link by codec.addr in standard HDAudio transfer case
- fetch the Link by LEPTR.ID in non-HDAudio transfer case

To make the unification happen, store pointer to the Link in dma_data
and utilize it in the common code. And to avoid confusion in
transfer-type naming between cAVS-ACE 1.x (SkyLake till MeteorLake) and
ACE 2.0+ architecture (LunarLake onward), use:

- 'hda' for typical HDAudio transfer case
- 'nonhda' for non-HDAudio transfer case, cAVS-ACE 1.x
- 'althda' for non-HDAudio transfer case, ACE 2.0+

Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Acked-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Link: https://patch.msgid.link/20250407112352.3720779-7-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 347c8d6db7c9 ("ASoC: Intel: avs: Fix PPLCxFMT calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 116 ++++++++++++++++++++++++++++----------
 1 file changed, 85 insertions(+), 31 deletions(-)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index d83ef504643bb..6116465c8f9b1 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -36,6 +36,7 @@ struct avs_dma_data {
 	struct snd_pcm_hw_constraint_list sample_bits_list;
 
 	struct work_struct period_elapsed_work;
+	struct hdac_ext_link *link;
 	struct snd_pcm_substream *substream;
 };
 
@@ -325,32 +326,75 @@ static const struct snd_soc_dai_ops avs_dai_nonhda_be_ops = {
 	.trigger = avs_dai_nonhda_be_trigger,
 };
 
-static int avs_dai_hda_be_startup(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
+static int __avs_dai_hda_be_startup(struct snd_pcm_substream *substream, struct snd_soc_dai *dai,
+				    struct hdac_ext_link *link)
 {
-	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct hdac_ext_stream *link_stream;
 	struct avs_dma_data *data;
-	struct hda_codec *codec;
 	int ret;
 
 	ret = avs_dai_startup(substream, dai);
 	if (ret)
 		return ret;
 
-	codec = dev_to_hda_codec(snd_soc_rtd_to_codec(rtd, 0)->dev);
-	link_stream = snd_hdac_ext_stream_assign(&codec->bus->core, substream,
+	data = snd_soc_dai_get_dma_data(dai, substream);
+	link_stream = snd_hdac_ext_stream_assign(&data->adev->base.core, substream,
 						 HDAC_EXT_STREAM_TYPE_LINK);
 	if (!link_stream) {
 		avs_dai_shutdown(substream, dai);
 		return -EBUSY;
 	}
 
-	data = snd_soc_dai_get_dma_data(dai, substream);
 	data->link_stream = link_stream;
-	substream->runtime->private_data = link_stream;
+	data->link = link;
 	return 0;
 }
 
+static int avs_dai_hda_be_startup(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
+{
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
+	struct hdac_ext_link *link;
+	struct avs_dma_data *data;
+	struct hda_codec *codec;
+	int ret;
+
+	codec = dev_to_hda_codec(snd_soc_rtd_to_codec(rtd, 0)->dev);
+
+	link = snd_hdac_ext_bus_get_hlink_by_addr(&codec->bus->core, codec->core.addr);
+	if (!link)
+		return -EINVAL;
+
+	ret = __avs_dai_hda_be_startup(substream, dai, link);
+	if (!ret) {
+		data = snd_soc_dai_get_dma_data(dai, substream);
+		substream->runtime->private_data = data->link_stream;
+	}
+
+	return ret;
+}
+
+static int avs_dai_i2shda_be_startup(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
+{
+	struct avs_dev *adev = to_avs_dev(dai->component->dev);
+	struct hdac_ext_link *link;
+
+	link = snd_hdac_ext_bus_get_hlink_by_id(&adev->base.core, AZX_REG_ML_LEPTR_ID_INTEL_SSP);
+	if (!link)
+		return -EINVAL;
+	return __avs_dai_hda_be_startup(substream, dai, link);
+}
+
+static int avs_dai_dmichda_be_startup(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
+{
+	struct avs_dev *adev = to_avs_dev(dai->component->dev);
+	struct hdac_ext_link *link;
+
+	link = snd_hdac_ext_bus_get_hlink_by_id(&adev->base.core, AZX_REG_ML_LEPTR_ID_INTEL_DMIC);
+	if (!link)
+		return -EINVAL;
+	return __avs_dai_hda_be_startup(substream, dai, link);
+}
+
 static void avs_dai_hda_be_shutdown(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
 {
 	struct avs_dma_data *data = snd_soc_dai_get_dma_data(dai, substream);
@@ -360,6 +404,14 @@ static void avs_dai_hda_be_shutdown(struct snd_pcm_substream *substream, struct
 	avs_dai_shutdown(substream, dai);
 }
 
+static void avs_dai_althda_be_shutdown(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
+{
+	struct avs_dma_data *data = snd_soc_dai_get_dma_data(dai, substream);
+
+	snd_hdac_ext_stream_release(data->link_stream, HDAC_EXT_STREAM_TYPE_LINK);
+	avs_dai_shutdown(substream, dai);
+}
+
 static int avs_dai_hda_be_hw_params(struct snd_pcm_substream *substream,
 				    struct snd_pcm_hw_params *hw_params, struct snd_soc_dai *dai)
 {
@@ -375,13 +427,8 @@ static int avs_dai_hda_be_hw_params(struct snd_pcm_substream *substream,
 
 static int avs_dai_hda_be_hw_free(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
 {
-	struct avs_dma_data *data;
-	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct hdac_ext_stream *link_stream;
-	struct hdac_ext_link *link;
-	struct hda_codec *codec;
-
-	dev_dbg(dai->dev, "%s: %s\n", __func__, dai->name);
+	struct avs_dma_data *data;
 
 	data = snd_soc_dai_get_dma_data(dai, substream);
 	if (!data->path)
@@ -393,27 +440,19 @@ static int avs_dai_hda_be_hw_free(struct snd_pcm_substream *substream, struct sn
 	data->path = NULL;
 
 	/* clear link <-> stream mapping */
-	codec = dev_to_hda_codec(snd_soc_rtd_to_codec(rtd, 0)->dev);
-	link = snd_hdac_ext_bus_get_hlink_by_addr(&codec->bus->core, codec->core.addr);
-	if (!link)
-		return -EINVAL;
-
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		snd_hdac_ext_bus_link_clear_stream_id(link, hdac_stream(link_stream)->stream_tag);
+		snd_hdac_ext_bus_link_clear_stream_id(data->link,
+						      hdac_stream(link_stream)->stream_tag);
 
 	return 0;
 }
 
 static int avs_dai_hda_be_prepare(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
 {
-	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	const struct snd_soc_pcm_stream *stream_info;
 	struct hdac_ext_stream *link_stream;
-	struct hdac_ext_link *link;
 	struct avs_dma_data *data;
-	struct hda_codec *codec;
-	struct hdac_bus *bus;
 	unsigned int format_val;
 	unsigned int bits;
 	int ret;
@@ -424,23 +463,18 @@ static int avs_dai_hda_be_prepare(struct snd_pcm_substream *substream, struct sn
 	if (link_stream->link_prepared)
 		return 0;
 
-	codec = dev_to_hda_codec(snd_soc_rtd_to_codec(rtd, 0)->dev);
-	bus = &codec->bus->core;
 	stream_info = snd_soc_dai_get_pcm_stream(dai, substream->stream);
 	bits = snd_hdac_stream_format_bits(runtime->format, runtime->subformat,
 					   stream_info->sig_bits);
 	format_val = snd_hdac_stream_format(runtime->channels, bits, runtime->rate);
 
-	snd_hdac_ext_stream_decouple(bus, link_stream, true);
+	snd_hdac_ext_stream_decouple(&data->adev->base.core, link_stream, true);
 	snd_hdac_ext_stream_reset(link_stream);
 	snd_hdac_ext_stream_setup(link_stream, format_val);
 
-	link = snd_hdac_ext_bus_get_hlink_by_addr(bus, codec->core.addr);
-	if (!link)
-		return -EINVAL;
-
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		snd_hdac_ext_bus_link_set_stream_id(link, hdac_stream(link_stream)->stream_tag);
+		snd_hdac_ext_bus_link_set_stream_id(data->link,
+						    hdac_stream(link_stream)->stream_tag);
 
 	ret = avs_dai_prepare(substream, dai);
 	if (ret)
@@ -515,6 +549,26 @@ static const struct snd_soc_dai_ops avs_dai_hda_be_ops = {
 	.trigger = avs_dai_hda_be_trigger,
 };
 
+__maybe_unused
+static const struct snd_soc_dai_ops avs_dai_i2shda_be_ops = {
+	.startup = avs_dai_i2shda_be_startup,
+	.shutdown = avs_dai_althda_be_shutdown,
+	.hw_params = avs_dai_hda_be_hw_params,
+	.hw_free = avs_dai_hda_be_hw_free,
+	.prepare = avs_dai_hda_be_prepare,
+	.trigger = avs_dai_hda_be_trigger,
+};
+
+__maybe_unused
+static const struct snd_soc_dai_ops avs_dai_dmichda_be_ops = {
+	.startup = avs_dai_dmichda_be_startup,
+	.shutdown = avs_dai_althda_be_shutdown,
+	.hw_params = avs_dai_hda_be_hw_params,
+	.hw_free = avs_dai_hda_be_hw_free,
+	.prepare = avs_dai_hda_be_prepare,
+	.trigger = avs_dai_hda_be_trigger,
+};
+
 static int hw_rule_param_size(struct snd_pcm_hw_params *params, struct snd_pcm_hw_rule *rule)
 {
 	struct snd_interval *interval = hw_param_interval(params, rule->var);
-- 
2.39.5



