Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CB07E115;
	Mon,  8 Apr 2024 13:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583777; cv=none; b=ggoQf6Vco3WIbWfT7S4G73n7r6rdtdlg/TYrvkjGyAhaz73QW4LBIeb51cFOWnaQHxXlHNvaCgEFFwgsREVv9Qg4zkZP5moPHJzWFqRkHeS0+rRc50WQ0bRqaA3ite7ZDMK2eKmk6KNsKjBGIYwtNmopXuxaMTs4iZBcq9tATrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583777; c=relaxed/simple;
	bh=dM8ztpZYoKV3YycYALca6/mx3KmBedW9E5c8TTTnSKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AofuYS+Qekkwx/QDjfXAMsyXAPMBI2M+vP25JqfBzwPIHRMX7d7cMOp2Rddbxec1NkzUHEtJbGEG2Ltwnikzto+fmTsc9QaMkZz5Uj0zG8pYjyr/KtSZ4u2IT1G2Ht5d9sd5etRUlSh4TpebcyYTd0qM/somW/+rOCvDOvdsvnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzL0opzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzL0opzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7DCC433C7;
	Mon,  8 Apr 2024 13:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583777;
	bh=dM8ztpZYoKV3YycYALca6/mx3KmBedW9E5c8TTTnSKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yzL0opztOdR1I7Jq5Hsz4YasCZwALIMyc83IP+iy42EzYqiAA7zmps8UZ0nHwg6WK
	 BjEqeduWUa26/6ifyBcSvgBaqqkv/llmrOepn0XDtPHkMWbquG0fBc9C96UFNv23ZD
	 ATtk2HLPlsKQxdS5NkBxHmIAFUGDQkNOk1EIyipU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.8 218/273] ASoC: SOF: Intel: Set the dai/host get frame/byte counter callbacks
Date: Mon,  8 Apr 2024 14:58:13 +0200
Message-ID: <20240408125316.161919822@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit fd6f6a0632bc891673490bf4a92304172251825c upstream.

Add implementation for reading the LDP (Linear DMA Position) to be used as
get_host_byte_counter().
The LDP is counting the number of bytes moved between the DSP and host
memory.

Set the get_dai_frame_counter to hda_dsp_get_stream_llp, which is counting
the frames on the link side of the DSP.

Cc: stable@vger.kernel.org # 6.8
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240321130814.4412-8-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-common-ops.c |    2 ++
 sound/soc/sof/intel/hda-stream.c     |   31 +++++++++++++++++++++++++++++++
 sound/soc/sof/intel/hda.h            |    3 +++
 3 files changed, 36 insertions(+)

--- a/sound/soc/sof/intel/hda-common-ops.c
+++ b/sound/soc/sof/intel/hda-common-ops.c
@@ -58,6 +58,8 @@ struct snd_sof_dsp_ops sof_hda_common_op
 	.pcm_ack	= hda_dsp_pcm_ack,
 
 	.get_stream_position = hda_dsp_get_stream_llp,
+	.get_dai_frame_counter = hda_dsp_get_stream_llp,
+	.get_host_byte_counter = hda_dsp_get_stream_ldp,
 
 	/* firmware loading */
 	.load_firmware = snd_sof_load_firmware_raw,
--- a/sound/soc/sof/intel/hda-stream.c
+++ b/sound/soc/sof/intel/hda-stream.c
@@ -1086,3 +1086,34 @@ u64 hda_dsp_get_stream_llp(struct snd_so
 
 	return ((u64)llp_u << 32) | llp_l;
 }
+
+/**
+ * hda_dsp_get_stream_ldp - Retrieve the LDP (Linear DMA Position) of the stream
+ * @sdev: SOF device
+ * @component: ASoC component
+ * @substream: PCM substream
+ *
+ * Returns the raw Linear Link Position value
+ */
+u64 hda_dsp_get_stream_ldp(struct snd_sof_dev *sdev,
+			   struct snd_soc_component *component,
+			   struct snd_pcm_substream *substream)
+{
+	struct hdac_stream *hstream = substream->runtime->private_data;
+	struct hdac_ext_stream *hext_stream = stream_to_hdac_ext_stream(hstream);
+	u32 ldp_l, ldp_u;
+
+	/*
+	 * The pphc_addr have been calculated during probe in
+	 * hda_dsp_stream_init():
+	 * pphc_addr = sdev->bar[HDA_DSP_PP_BAR] +
+	 *	       SOF_HDA_PPHC_BASE +
+	 *	       SOF_HDA_PPHC_INTERVAL * stream_index
+	 *
+	 * Use this pre-calculated address to avoid repeated re-calculation.
+	 */
+	ldp_l = readl(hext_stream->pphc_addr + AZX_REG_PPHCLDPL);
+	ldp_u = readl(hext_stream->pphc_addr + AZX_REG_PPHCLDPU);
+
+	return ((u64)ldp_u << 32) | ldp_l;
+}
--- a/sound/soc/sof/intel/hda.h
+++ b/sound/soc/sof/intel/hda.h
@@ -660,6 +660,9 @@ snd_pcm_uframes_t hda_dsp_stream_get_pos
 u64 hda_dsp_get_stream_llp(struct snd_sof_dev *sdev,
 			   struct snd_soc_component *component,
 			   struct snd_pcm_substream *substream);
+u64 hda_dsp_get_stream_ldp(struct snd_sof_dev *sdev,
+			   struct snd_soc_component *component,
+			   struct snd_pcm_substream *substream);
 
 struct hdac_ext_stream *
 	hda_dsp_stream_get(struct snd_sof_dev *sdev, int direction, u32 flags);


