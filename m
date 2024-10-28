Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B74824A3;
	Mon, 28 Oct 2024 06:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098482; cv=none; b=uzxM7bXfD0Wmt9v+Majw9RgWe33GVxqr3qxIqfe5m+/Dsz13Lhkskhy1yy3ROARx30BAd72xy0KIkLhsEa3bV2fw/2MdAwpPvBtNuJ+HWBdRIVMvdeUQDSvE9+TSsw/tMQz/ZeqoHOM4b659Y/Qqpgrfo7zwgNqomzkwmo+D6PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098482; c=relaxed/simple;
	bh=O1BA+/lAoZqoqCCOP56/wt1b4TYv6QiaDTG3YtfQ0Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sUgemUznPkajKWXNYOe5RpCego2O5zZDH5IfxnKygYwlYwfWZ9ifr3GELab76DODNSUgEEl4Lv0LVFOdeKCOxTXn51HKZEHP+2oZnewfembmDaUiTWQ0Cj18QGEbPMM7US2SpJ0JVmmX7MOAcZxRA9RiGQ/V/+jdv9dVcLtFCsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OCLiu+MF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OCLiu+MF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8E0C4CEC3;
	Mon, 28 Oct 2024 06:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098482;
	bh=O1BA+/lAoZqoqCCOP56/wt1b4TYv6QiaDTG3YtfQ0Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCLiu+MF7GUaIXx6zAGR5DiKj0TJETUfEEOGhW3mZ7shuD5jHFzkchZzKS3jXwEqI
	 NvCDTjbP4QGnuJPZBN3ofReW8fU0grHHv5XY5MCRQAXSv9wjr4JZbL/chB+AYCAFj6
	 ao90zGq6ZRMVrtxIm8gyaz/sUBZOT5DvEwv8yNkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.11 245/261] ASoC: SOF: Intel: hda: Always clean up link DMA during stop
Date: Mon, 28 Oct 2024 07:26:27 +0100
Message-ID: <20241028062318.253239348@linuxfoundation.org>
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

commit ab5593793e9088abcddce30ba8e376e31b7285fd upstream.

This is required to reset the DMA read/write pointers when the stream is
prepared and restarted after a call to snd_pcm_drain()/snd_pcm_drop().
Also, now that the stream is reset during stop, do not save LLP registers
in the case of STOP/suspend to avoid erroneous delay reporting.

Link: https://github.com/thesofproject/sof/issues/9502
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
All: stable@vger.kernel.org # 6.10.x 6.11.x
Link: https://patch.msgid.link/20241016032910.14601-5-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-dai-ops.c |   23 ++++++++++-------------
 sound/soc/sof/intel/hda-dai.c     |    1 +
 2 files changed, 11 insertions(+), 13 deletions(-)

--- a/sound/soc/sof/intel/hda-dai-ops.c
+++ b/sound/soc/sof/intel/hda-dai-ops.c
@@ -346,20 +346,21 @@ static int hda_trigger(struct snd_sof_de
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
 		snd_hdac_ext_stream_start(hext_stream);
 		break;
-	case SNDRV_PCM_TRIGGER_SUSPEND:
-	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		snd_hdac_ext_stream_clear(hext_stream);
-
 		/*
-		 * Save the LLP registers in case the stream is
-		 * restarting due PAUSE_RELEASE, or START without a pcm
-		 * close/open since in this case the LLP register is not reset
-		 * to 0 and the delay calculation will return with invalid
-		 * results.
+		 * Save the LLP registers since in case of PAUSE the LLP
+		 * register are not reset to 0, the delay calculation will use
+		 * the saved offsets for compensating the delay calculation.
 		 */
 		hext_stream->pplcllpl = readl(hext_stream->pplc_addr + AZX_REG_PPLCLLPL);
 		hext_stream->pplcllpu = readl(hext_stream->pplc_addr + AZX_REG_PPLCLLPU);
+		snd_hdac_ext_stream_clear(hext_stream);
+		break;
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_STOP:
+		hext_stream->pplcllpl = 0;
+		hext_stream->pplcllpu = 0;
+		snd_hdac_ext_stream_clear(hext_stream);
 		break;
 	default:
 		dev_err(sdev->dev, "unknown trigger command %d\n", cmd);
@@ -512,7 +513,6 @@ static const struct hda_dai_widget_dma_o
 static int hda_ipc3_post_trigger(struct snd_sof_dev *sdev, struct snd_soc_dai *cpu_dai,
 				 struct snd_pcm_substream *substream, int cmd)
 {
-	struct hdac_ext_stream *hext_stream = hda_get_hext_stream(sdev, cpu_dai, substream);
 	struct snd_soc_dapm_widget *w = snd_soc_dai_get_widget(cpu_dai, substream->stream);
 
 	switch (cmd) {
@@ -527,9 +527,6 @@ static int hda_ipc3_post_trigger(struct
 		if (ret < 0)
 			return ret;
 
-		if (cmd == SNDRV_PCM_TRIGGER_STOP)
-			return hda_link_dma_cleanup(substream, hext_stream, cpu_dai);
-
 		break;
 	}
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -302,6 +302,7 @@ static int __maybe_unused hda_dai_trigge
 	}
 
 	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 		ret = hda_link_dma_cleanup(substream, hext_stream, dai);
 		if (ret < 0) {


