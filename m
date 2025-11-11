Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2AF342CBC;
	Tue, 11 Nov 2025 01:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823530; cv=none; b=XAMVFyQ32lzP6S2NT06mzjTUXBQwzEQ7XkrVdUa50FjnZ4/+qjTbNfHOKXU4g5JXkkt7Nx989AK7tUPfPkZUka9WFZvgobDZJsGnY0WI6z8O1ihZziI77IVa9U4kGHOHlqUqgL5Px80Mzn3alaE/RW0HgmdkgTWAiEHmtcHPUFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823530; c=relaxed/simple;
	bh=sy0+hcoknFGYV54hX4DSBMWU+ocaVIupXvQIPQgnLHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EsyabfaCgG0TDVYnju26vSLA4MslRqpPOelvX5optqB2vdc76zcWFIlfqFT71HZG2j+/xKIBz1ojRaZ+3KG19elhoj0mZKA2/6rjooVPhCFLBp0bp1LYd5v4Z7ijwwIn4Q6QhE8Y25U7duhv76Vfv4vmm1sNQbX2z74wrUpb5kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Si6jTwPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Si6jTwPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F63C2BC86;
	Tue, 11 Nov 2025 01:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823529;
	bh=sy0+hcoknFGYV54hX4DSBMWU+ocaVIupXvQIPQgnLHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Si6jTwPx/xyy4M+fNav0BHH0uD8xVSHuc8g3bkbUgXpVJnnqeVPc4VZ6Uv8wJeQy8
	 oVjSr4y58dcu2i7rwvroMhbBn5bhX9BN5gs903zXeqOhn2VBftS6Yl8spJ6e0A/uag
	 q0ZgYFk6igS60a+eJIPS68bfrJ81K3hxjAjPPacI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 264/565] ASoC: SOF: ipc4-pcm: Add fixup for channels
Date: Tue, 11 Nov 2025 09:42:00 +0900
Message-ID: <20251111004532.832321544@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 6ad299a9b968e1c63988e2a327295e522cf6bbf5 ]

We can have modules in path which can change the number of channels and in
this case the BE params needs to be adjusted to configure the DAI according
to the copier configuration.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Message-ID: <20250829105305.31818-2-peter.ujfalusi@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-pcm.c | 56 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/sound/soc/sof/ipc4-pcm.c b/sound/soc/sof/ipc4-pcm.c
index b11279f9d3c97..5e877dc921b1e 100644
--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -675,6 +675,58 @@ static int sof_ipc4_pcm_dai_link_fixup_rate(struct snd_sof_dev *sdev,
 	return 0;
 }
 
+static int sof_ipc4_pcm_dai_link_fixup_channels(struct snd_sof_dev *sdev,
+						struct snd_pcm_hw_params *params,
+						struct sof_ipc4_copier *ipc4_copier)
+{
+	struct sof_ipc4_pin_format *pin_fmts = ipc4_copier->available_fmt.input_pin_fmts;
+	struct snd_interval *channels = hw_param_interval(params, SNDRV_PCM_HW_PARAM_CHANNELS);
+	int num_input_formats = ipc4_copier->available_fmt.num_input_formats;
+	unsigned int fe_channels = params_channels(params);
+	bool fe_be_match = false;
+	bool single_be_channels = true;
+	unsigned int be_channels, val;
+	int i;
+
+	if (WARN_ON_ONCE(!num_input_formats))
+		return -EINVAL;
+
+	/*
+	 * Copier does not change channels, so we
+	 * need to only consider the input pin information.
+	 */
+	be_channels = SOF_IPC4_AUDIO_FORMAT_CFG_CHANNELS_COUNT(pin_fmts[0].audio_fmt.fmt_cfg);
+	for (i = 0; i < num_input_formats; i++) {
+		val = SOF_IPC4_AUDIO_FORMAT_CFG_CHANNELS_COUNT(pin_fmts[i].audio_fmt.fmt_cfg);
+
+		if (val != be_channels)
+			single_be_channels = false;
+
+		if (val == fe_channels) {
+			fe_be_match = true;
+			break;
+		}
+	}
+
+	/*
+	 * If channels is different than FE channels, topology must contain a
+	 * module which can change the number of channels. But we do require
+	 * topology to define a single channels in the DAI copier config in
+	 * this case (FE channels may be variable).
+	 */
+	if (!fe_be_match) {
+		if (!single_be_channels) {
+			dev_err(sdev->dev, "Unable to select channels for DAI link\n");
+			return -EINVAL;
+		}
+
+		channels->min = be_channels;
+		channels->max = be_channels;
+	}
+
+	return 0;
+}
+
 static int sof_ipc4_pcm_dai_link_fixup(struct snd_soc_pcm_runtime *rtd,
 				       struct snd_pcm_hw_params *params)
 {
@@ -738,6 +790,10 @@ static int sof_ipc4_pcm_dai_link_fixup(struct snd_soc_pcm_runtime *rtd,
 	if (ret)
 		return ret;
 
+	ret = sof_ipc4_pcm_dai_link_fixup_channels(sdev, params, ipc4_copier);
+	if (ret)
+		return ret;
+
 	if (single_bitdepth) {
 		snd_mask_none(fmt);
 		valid_bits = SOF_IPC4_AUDIO_FORMAT_CFG_V_BIT_DEPTH(ipc4_fmt->fmt_cfg);
-- 
2.51.0



