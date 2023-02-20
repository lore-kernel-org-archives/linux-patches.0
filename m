Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B8B63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD5FC433D2;
	Mon, 20 Feb 2023 13:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901017;
	bh=EOq7uZVi9OOmpnQnjIbzpuyxxkAF1SMw49w5jFM3Z0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yWYJUVeqPhVFRL9KUA5rGqc8dUO6DPaS0GjEnYN64iNT8J8qNwjx/PYDqmv8og6t
	 NCgJSTjDwf3j6EhRZar0s2Eyeni9EYKOqckeQmYnPZYHhUCc2ijWFFYutgzT2XdCjx
	 AC4c9898lJcUrQiaRjukqgpy3ZXBcoj3sb0+7RAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 154/156] ASoC: SOF: Intel: hda-dai: fix possible stream_tag leak
Date: Mon, 20 Feb 2023 14:36:38 +0100
Message-Id: <20230220133609.100216993@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit 1f810d2b6b2fbdc5279644d8b2c140b1f7c9d43d upstream.

The HDaudio stream allocation is done first, and in a second step the
LOSIDV parameter is programmed for the multi-link used by a codec.

This leads to a possible stream_tag leak, e.g. if a DisplayAudio link
is not used. This would happen when a non-Intel graphics card is used
and userspace unconditionally uses the Intel Display Audio PCMs without
checking if they are connected to a receiver with jack controls.

We should first check that there is a valid multi-link entry to
configure before allocating a stream_tag. This change aligns the
dma_assign and dma_cleanup phases.

Complements: b0cd60f3e9f5 ("ALSA/ASoC: hda: clarify bus_get_link() and bus_link_get() helpers")
Link: https://github.com/thesofproject/linux/issues/4151
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230216162340.19480-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-dai.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -211,6 +211,10 @@ static int hda_link_hw_params(struct snd
 	int stream_tag;
 	int ret;
 
+	link = snd_hdac_ext_bus_get_link(bus, codec_dai->component->name);
+	if (!link)
+		return -EINVAL;
+
 	/* get stored dma data if resuming from system suspend */
 	link_dev = snd_soc_dai_get_dma_data(dai, substream);
 	if (!link_dev) {
@@ -231,10 +235,6 @@ static int hda_link_hw_params(struct snd
 	if (ret < 0)
 		return ret;
 
-	link = snd_hdac_ext_bus_get_link(bus, codec_dai->component->name);
-	if (!link)
-		return -EINVAL;
-
 	/* set the stream tag in the codec dai dma params */
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		snd_soc_dai_set_tdm_slot(codec_dai, stream_tag, 0, 0, 0);


