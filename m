Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784252DF73;
	Mon,  8 Apr 2024 13:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583748; cv=none; b=TYK4bRAeqeRzKc/+0oCT0+eer76iq0vlHm68UmsZ42Df6F6uw0MPHMmuHJYpb8iLMfvic5yd17LqY54z7wn1OfqzBsbgZTG1+qLQcjlAgFZ7q2c1VUVdGTnTH5XLhrks7lgu7ad0yYlMeTv1m7L+Pk+3TtMGimypeyiZXXSUh1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583748; c=relaxed/simple;
	bh=KOygjfRjr4BVPPj5vjcfCnGPnafNvObA8GCFoKGvSAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8VHRqkazgBH98UDop60Cr4gqLc+7W7XCgkxgEMiBaVp3qVYBBKK1mqyctz5ffJgY5wdK4UDcXK/qxdsZhp6MP0uPL+ukbSa4mU3FXSRGXj3pKGn9C6Q7bvMEkouYxgzTV/gE6NvXkR2y9GlGx2u6rjCK3IIFQZ0INGoiOO+kb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhejvihW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhejvihW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00910C433F1;
	Mon,  8 Apr 2024 13:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583748;
	bh=KOygjfRjr4BVPPj5vjcfCnGPnafNvObA8GCFoKGvSAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhejvihWQMW1ImNVDcIwGc182iN93cdLuZr1vndSaIJ4Lp3bkXtPIK51xO7vX8qZd
	 6iYG2c3XXh+BogflgiTiRp+azVs1xUO74rv+rrICzveK+i4LFZsdDdlVZEb16eTQxW
	 L3TU5ZWgy5kfItHjyucs2srAcISt6W98+UpPGrG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.8 215/273] ASoC: SOF: Intel: hda: Implement get_stream_position (Linear Link Position)
Date: Mon,  8 Apr 2024 14:58:10 +0200
Message-ID: <20240408125316.060060932@linuxfoundation.org>
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

commit 67b182bea08a8d1092b91b57aefdfe420fce1634 upstream.

When the Linear Link Position is not available in firmware SRAM window we
use the host accessible position registers to read it.
The address of the PPLCLLPL/U registers depend on the number of streams
(playback+capture).
At probe time the pplc_addr is calculated for each stream and we can use
it to read the LLP without the need of address re-calculation.

Set the get_stream_position callback in sof_hda_common_ops for all
platforms:
The callback is used for IPC4 delay calculations only but the register is
a generic HDA register, not tied to any specific IPC version.

Cc: stable@vger.kernel.org # 6.8
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240321130814.4412-5-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-common-ops.c |    2 ++
 sound/soc/sof/intel/hda-stream.c     |   32 ++++++++++++++++++++++++++++++++
 sound/soc/sof/intel/hda.h            |    3 +++
 3 files changed, 37 insertions(+)

--- a/sound/soc/sof/intel/hda-common-ops.c
+++ b/sound/soc/sof/intel/hda-common-ops.c
@@ -57,6 +57,8 @@ struct snd_sof_dsp_ops sof_hda_common_op
 	.pcm_pointer	= hda_dsp_pcm_pointer,
 	.pcm_ack	= hda_dsp_pcm_ack,
 
+	.get_stream_position = hda_dsp_get_stream_llp,
+
 	/* firmware loading */
 	.load_firmware = snd_sof_load_firmware_raw,
 
--- a/sound/soc/sof/intel/hda-stream.c
+++ b/sound/soc/sof/intel/hda-stream.c
@@ -1054,3 +1054,35 @@ snd_pcm_uframes_t hda_dsp_stream_get_pos
 
 	return pos;
 }
+
+/**
+ * hda_dsp_get_stream_llp - Retrieve the LLP (Linear Link Position) of the stream
+ * @sdev: SOF device
+ * @component: ASoC component
+ * @substream: PCM substream
+ *
+ * Returns the raw Linear Link Position value
+ */
+u64 hda_dsp_get_stream_llp(struct snd_sof_dev *sdev,
+			   struct snd_soc_component *component,
+			   struct snd_pcm_substream *substream)
+{
+	struct hdac_stream *hstream = substream->runtime->private_data;
+	struct hdac_ext_stream *hext_stream = stream_to_hdac_ext_stream(hstream);
+	u32 llp_l, llp_u;
+
+	/*
+	 * The pplc_addr have been calculated during probe in
+	 * hda_dsp_stream_init():
+	 * pplc_addr = sdev->bar[HDA_DSP_PP_BAR] +
+	 *	       SOF_HDA_PPLC_BASE +
+	 *	       SOF_HDA_PPLC_MULTI * total_stream +
+	 *	       SOF_HDA_PPLC_INTERVAL * stream_index
+	 *
+	 * Use this pre-calculated address to avoid repeated re-calculation.
+	 */
+	llp_l = readl(hext_stream->pplc_addr + AZX_REG_PPLCLLPL);
+	llp_u = readl(hext_stream->pplc_addr + AZX_REG_PPLCLLPU);
+
+	return ((u64)llp_u << 32) | llp_l;
+}
--- a/sound/soc/sof/intel/hda.h
+++ b/sound/soc/sof/intel/hda.h
@@ -657,6 +657,9 @@ bool hda_dsp_check_stream_irq(struct snd
 
 snd_pcm_uframes_t hda_dsp_stream_get_position(struct hdac_stream *hstream,
 					      int direction, bool can_sleep);
+u64 hda_dsp_get_stream_llp(struct snd_sof_dev *sdev,
+			   struct snd_soc_component *component,
+			   struct snd_pcm_substream *substream);
 
 struct hdac_ext_stream *
 	hda_dsp_stream_get(struct snd_sof_dev *sdev, int direction, u32 flags);


