Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2860718D649;
	Mon, 28 Oct 2024 06:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098480; cv=none; b=sU0npUKTorQwmJicqsGqbxZdxCIntzItWXRAAF0+SfER7VtpwsK9yhmJqLRNAl0EJDK+c2rtDXWnRyyp679QvQaiB3SrNkGI3GTFIbXNTp2wkwgERlJ1A5XuS4sU3ws2R2vekQFm4dSpBunNWsECKrwaEkxnosg6bwYAHprzyiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098480; c=relaxed/simple;
	bh=eREsLpQ9hBkAlqazPb/ops02i1hG+kVKU9YRDLigXYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ED5FesfsPEN7ZAJXYaeFhyzWXPTx1e7Mfs8ugY6XJJPzk8UYRZPcJ6G6yX74i5sDaUn1ngZXoXVO9I5ydlMxBvNJ++GuX9KoQnlLhmVrico/LkVKROmXT6M7SGE4viPlh33uFEInNxYxLIRHE/FSzVNpFx5LSXVYnZ9UN47lyrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yw6lK165; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yw6lK165"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEBBC4CEC3;
	Mon, 28 Oct 2024 06:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098480;
	bh=eREsLpQ9hBkAlqazPb/ops02i1hG+kVKU9YRDLigXYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yw6lK165VQq/gMG4Ey9vLcG4XIFYNcObFvCVd8XHgN0WHyHE95I5MFYhmR4Fuo5dX
	 8LffBXs1MSA1D9BFt8436R8z3PHkBTOKscIRdiEEJ+5t2B2EaYoo+RBdbG8/HSuOOX
	 D0M9Y4Aq4qyd/XR8mI2+4P3UUxaVDuLS8ksDtBz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.11 244/261] ASoC: SOF: Intel: hda: Handle prepare without close for non-HDA DAIs
Date: Mon, 28 Oct 2024 07:26:26 +0100
Message-ID: <20241028062318.229917178@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

commit 6e38a7e098d32d128b00b42a536151de9ea1340b upstream.

When a PCM is restarted after a snd_pcm_drain/snd_pcm_drop(), the prepare
callback will be invoked and the hw_params will be set again. For the
HDA DAI's, the hw_params function handles this case already but not for
the non-HDA DAI's. So, add the check for link_prepared to verify if the
hw_params should be done again or not. Additionally, for SDW DAI's reset
the PCMSyCM registers as would be done in the case of a start after a
hw_free.

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
All: stable@vger.kernel.org # 6.10.x 6.11.x
Link: https://patch.msgid.link/20241016032910.14601-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-dai.c | 36 +++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index 1c823f9eea57..8cccf38967e7 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -370,6 +370,13 @@ static int non_hda_dai_hw_params_data(struct snd_pcm_substream *substream,
 		return -EINVAL;
 	}
 
+	sdev = widget_to_sdev(w);
+	hext_stream = ops->get_hext_stream(sdev, cpu_dai, substream);
+
+	/* nothing more to do if the link is already prepared */
+	if (hext_stream && hext_stream->link_prepared)
+		return 0;
+
 	/* use HDaudio stream handling */
 	ret = hda_dai_hw_params_data(substream, params, cpu_dai, data, flags);
 	if (ret < 0) {
@@ -377,7 +384,6 @@ static int non_hda_dai_hw_params_data(struct snd_pcm_substream *substream,
 		return ret;
 	}
 
-	sdev = widget_to_sdev(w);
 	if (sdev->dspless_mode_selected)
 		return 0;
 
@@ -482,6 +488,31 @@ int sdw_hda_dai_hw_params(struct snd_pcm_substream *substream,
 	int ret;
 	int i;
 
+	ops = hda_dai_get_ops(substream, cpu_dai);
+	if (!ops) {
+		dev_err(cpu_dai->dev, "DAI widget ops not set\n");
+		return -EINVAL;
+	}
+
+	sdev = widget_to_sdev(w);
+	hext_stream = ops->get_hext_stream(sdev, cpu_dai, substream);
+
+	/* nothing more to do if the link is already prepared */
+	if (hext_stream && hext_stream->link_prepared)
+		return 0;
+
+	/*
+	 * reset the PCMSyCM registers to handle a prepare callback when the PCM is restarted
+	 * due to xruns or after a call to snd_pcm_drain/drop()
+	 */
+	ret = hdac_bus_eml_sdw_map_stream_ch(sof_to_bus(sdev), link_id, cpu_dai->id,
+					     0, 0, substream->stream);
+	if (ret < 0) {
+		dev_err(cpu_dai->dev, "%s:  hdac_bus_eml_sdw_map_stream_ch failed %d\n",
+			__func__, ret);
+		return ret;
+	}
+
 	data.dai_index = (link_id << 8) | cpu_dai->id;
 	data.dai_node_id = intel_alh_id;
 	ret = non_hda_dai_hw_params_data(substream, params, cpu_dai, &data, flags);
@@ -490,10 +521,7 @@ int sdw_hda_dai_hw_params(struct snd_pcm_substream *substream,
 		return ret;
 	}
 
-	ops = hda_dai_get_ops(substream, cpu_dai);
-	sdev = widget_to_sdev(w);
 	hext_stream = ops->get_hext_stream(sdev, cpu_dai, substream);
-
 	if (!hext_stream)
 		return -ENODEV;
 
-- 
2.47.0



