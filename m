Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4171171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAB9C433C9;
	Mon, 21 Aug 2023 20:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648595;
	bh=N4EUw4PifvMKdwjUETYz/Nw7zeZI0pRp9+6kpbzT+XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sf43Tr0M/ifn9OzYOd38bhcv2Tpid4fbLkwEVLMi5yH4VvlLL80HJCwyPHxc/GYlF
	 biF7Z1ms5XFfeSsrIjO3gNWqfReo/zhoypXn0v2SDbwMw1ceAR+lOgiOq8OCVVB3Vm
	 8ExJa1Z/t+pcONgB61zbvtUfr0lSuNM5Jx0k1/C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH 6.4 232/234] ASoC: SOF: intel: hda: Clean up link DMA for IPC3 during stop
Date: Mon, 21 Aug 2023 21:43:15 +0200
Message-ID: <20230821194139.186602229@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

commit 90219f1bd273055f1dc1d7bdc0965755b992c045 upstream.

With IPC3, we reset hw_params during the stop trigger, so we should also
clean up the link DMA during the stop trigger.

Fixes: 1bf83fa6654c ("ASoC: SOF: Intel: hda-dai: Do not perform DMA cleanup during stop")
Closes: https://github.com/thesofproject/linux/issues/4455
Closes: https://github.com/thesofproject/linux/issues/4482
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217673
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230808110627.32375-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-dai-ops.c |   13 ++++++++++++-
 sound/soc/sof/intel/hda-dai.c     |    8 ++++----
 sound/soc/sof/intel/hda.h         |    2 ++
 3 files changed, 18 insertions(+), 5 deletions(-)

--- a/sound/soc/sof/intel/hda-dai-ops.c
+++ b/sound/soc/sof/intel/hda-dai-ops.c
@@ -289,16 +289,27 @@ static const struct hda_dai_widget_dma_o
 static int hda_ipc3_post_trigger(struct snd_sof_dev *sdev, struct snd_soc_dai *cpu_dai,
 				 struct snd_pcm_substream *substream, int cmd)
 {
+	struct hdac_ext_stream *hext_stream = hda_get_hext_stream(sdev, cpu_dai, substream);
 	struct snd_soc_dapm_widget *w = snd_soc_dai_get_widget(cpu_dai, substream->stream);
+	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
+	struct snd_soc_dai *codec_dai = asoc_rtd_to_codec(rtd, 0);
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_STOP:
 	{
 		struct snd_sof_dai_config_data data = { 0 };
+		int ret;
 
 		data.dai_data = DMA_CHAN_INVALID;
-		return hda_dai_config(w, SOF_DAI_CONFIG_FLAGS_HW_FREE, &data);
+		ret = hda_dai_config(w, SOF_DAI_CONFIG_FLAGS_HW_FREE, &data);
+		if (ret < 0)
+			return ret;
+
+		if (cmd == SNDRV_PCM_TRIGGER_STOP)
+			return hda_link_dma_cleanup(substream, hext_stream, cpu_dai, codec_dai);
+
+		break;
 	}
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 		return hda_dai_config(w, SOF_DAI_CONFIG_FLAGS_PAUSE, NULL);
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -91,10 +91,10 @@ hda_dai_get_ops(struct snd_pcm_substream
 	return sdai->platform_private;
 }
 
-static int hda_link_dma_cleanup(struct snd_pcm_substream *substream,
-				struct hdac_ext_stream *hext_stream,
-				struct snd_soc_dai *cpu_dai,
-				struct snd_soc_dai *codec_dai)
+int hda_link_dma_cleanup(struct snd_pcm_substream *substream,
+			 struct hdac_ext_stream *hext_stream,
+			 struct snd_soc_dai *cpu_dai,
+			 struct snd_soc_dai *codec_dai)
 {
 	struct snd_sof_dev *sdev = snd_soc_component_get_drvdata(cpu_dai->component);
 	const struct hda_dai_widget_dma_ops *ops = hda_dai_get_ops(substream, cpu_dai);
--- a/sound/soc/sof/intel/hda.h
+++ b/sound/soc/sof/intel/hda.h
@@ -942,5 +942,7 @@ const struct hda_dai_widget_dma_ops *
 hda_select_dai_widget_ops(struct snd_sof_dev *sdev, struct snd_sof_widget *swidget);
 int hda_dai_config(struct snd_soc_dapm_widget *w, unsigned int flags,
 		   struct snd_sof_dai_config_data *data);
+int hda_link_dma_cleanup(struct snd_pcm_substream *substream, struct hdac_ext_stream *hext_stream,
+			 struct snd_soc_dai *cpu_dai, struct snd_soc_dai *codec_dai);
 
 #endif


