Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525D9281349;
	Thu, 13 Feb 2025 14:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457313; cv=none; b=A0rYiAN/N+2JYtWE85JpPzgdPJUXSRs/U4xack2XHIU453bvbO50w2ZNmQBGf3daXOMaO/ldQd8uexOStihldh5nX7Hxxg9aYS9rqFUcIQOTU7o43UQUky9262TQbZo2Q5VEUI0ZXG/MdhKVzTowcfJM1yJQ8mp8gORKmQkedIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457313; c=relaxed/simple;
	bh=quM3px6pXpk6yiW68epsWJfpXIrW7+jptajNjNHMUok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mA/QRWlqqBEA9JV/645uxzCzm0Lz/WhRtvPUYlHdbXDojiXokrT/kjw6HzHxfAPcBraWrAFDXX+Jo/cSdYDoTJ3+VGkVpgttrxyFtk8eAvQAPZAXJ9EnCmg7VOgek0iMQJcl/FdEy/hvJwXc9J/Yh14GMSLLUX6PDc/JR7Pz3Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8vVsz3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8vVsz3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8608C4CED1;
	Thu, 13 Feb 2025 14:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457313;
	bh=quM3px6pXpk6yiW68epsWJfpXIrW7+jptajNjNHMUok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8vVsz3UFB3iQg5TTvxFTsi97K16Tkuyz6bYAST/ToCX0k/QvPNuRUb/BxeBRv4nz
	 nJMPjNVTnV+ZBBgCSfgLJkxpZWjbKQ1pAzLKKF78eQ8t4ziKQq6VQ6MiDEw2324H2n
	 KPahwWAJwhimo0Im/5ZvmhOLlF+ZVqVoHBIDsvuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/422] ASoC: SOF: Intel: hda-dai: Ensure DAI widget is valid during params
Date: Thu, 13 Feb 2025 15:23:45 +0100
Message-ID: <20250213142439.489902332@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 569922b82ca660f8b24e705f6cf674e6b1f99cc7 ]

Each cpu DAI should associate with a widget. However, the topology might
not create the right number of DAI widgets for aggregated amps. And it
will cause NULL pointer deference.
Check that the DAI widget associated with the CPU DAI is valid to prevent
NULL pointer deference due to missing DAI widgets in topologies with
aggregated amps.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Link: https://patch.msgid.link/20241203104853.56956-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dai.c | 12 ++++++++++++
 sound/soc/sof/intel/hda.c     |  5 +++++
 2 files changed, 17 insertions(+)

diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index 82f46ecd94301..2e58a264da556 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -503,6 +503,12 @@ int sdw_hda_dai_hw_params(struct snd_pcm_substream *substream,
 	int ret;
 	int i;
 
+	if (!w) {
+		dev_err(cpu_dai->dev, "%s widget not found, check amp link num in the topology\n",
+			cpu_dai->name);
+		return -EINVAL;
+	}
+
 	ops = hda_dai_get_ops(substream, cpu_dai);
 	if (!ops) {
 		dev_err(cpu_dai->dev, "DAI widget ops not set\n");
@@ -582,6 +588,12 @@ int sdw_hda_dai_hw_params(struct snd_pcm_substream *substream,
 	 */
 	for_each_rtd_cpu_dais(rtd, i, dai) {
 		w = snd_soc_dai_get_widget(dai, substream->stream);
+		if (!w) {
+			dev_err(cpu_dai->dev,
+				"%s widget not found, check amp link num in the topology\n",
+				dai->name);
+			return -EINVAL;
+		}
 		ipc4_copier = widget_to_copier(w);
 		memcpy(&ipc4_copier->dma_config_tlv[cpu_dai_id], dma_config_tlv,
 		       sizeof(*dma_config_tlv));
diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 70fc08c8fc99e..f10ed4d102501 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -63,6 +63,11 @@ static int sdw_params_stream(struct device *dev,
 	struct snd_soc_dapm_widget *w = snd_soc_dai_get_widget(d, params_data->substream->stream);
 	struct snd_sof_dai_config_data data = { 0 };
 
+	if (!w) {
+		dev_err(dev, "%s widget not found, check amp link num in the topology\n",
+			d->name);
+		return -EINVAL;
+	}
 	data.dai_index = (params_data->link_id << 8) | d->id;
 	data.dai_data = params_data->alh_stream_id;
 	data.dai_node_id = data.dai_data;
-- 
2.39.5



