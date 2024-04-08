Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9DE2DF73;
	Mon,  8 Apr 2024 13:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583769; cv=none; b=lwpIeoTxVhEoGn0ULQ68eiE7jYGL4KTQzvXs6Dm2ORE6GpjcTURtZZ4sAta9q9cKvDwRN/hrfNyVkZ1xlB0g/PiZawTjvJ/bSiwdeg2evfSjcsblzC05wXXboUL6sLb1ElaxssX7wJNiFKV5eH+KbVtihxRjg6tqro3a00HtRRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583769; c=relaxed/simple;
	bh=wCPRhtdc1hMn65JLZLrcjzaAEC+OCge4fu31WiNmjck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMkU/jmtGEIy63v5YsIe9e21AwD1CFYxy20aa0lrHfbbrWaG9XaVbX70TVO/q0BPHG5HPrw/853eaQA74IwjhoxhZdubxf/o1ERyQZQTuwVgG8yD1QyAlFLWE33IJX2nkR+6GR0V7ZA37722UDwxmPXLGCwsfdA04LKssDD93FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWpkNGRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWpkNGRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1CFC433C7;
	Mon,  8 Apr 2024 13:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583769;
	bh=wCPRhtdc1hMn65JLZLrcjzaAEC+OCge4fu31WiNmjck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWpkNGRFUdoke5K3Slb2+BiWYgDEqbTLi0xLihvzUo4RLS90Xqt8aEUDDU2VhtDvR
	 9cDr6Y3ZeJ7EOh7I70wqZ0m47sCi5RQFWEGtVkMSKisa6wtun504EwJt1oQipJUoob
	 MRmHEqgUVx5sYkljk3nM0HufAb4nBA+D54Mxn1uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.8 217/273] ASoC: SOF: Introduce a new callback pair to be used for PCM delay reporting
Date: Mon,  8 Apr 2024 14:58:12 +0200
Message-ID: <20240408125316.130552909@linuxfoundation.org>
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

commit ce2faa9a180c1984225689b6b1cb26045f8b7470 upstream.

For delay calculation we need two information:
Number of bytes transferred between the DSP and host memory (ALSA buffer)
Number of frames transferred between the DSP and external device
(link/codec/DMIC/etc).

The reason for the different units (bytes vs frames) on host and dai side
is that the format on the dai side is decided by the firmware and might
not be the same as on the host side, thus the expectation is that the
counter reflects the number of frames.
The kernel know the host side format and in there we have access to the
DMA position which is in bytes.

In a simplified way, the DSP caused delay is the difference between the
two counters.

The existing get_stream_position callback is defined to retrieve the frame
counter on the DAI side but it's name is too generic to be intuitive and
makes it hard to define a callback for the host side.

This patch introduces a new set of callbacks to replace the
get_stream_position and define the host side equivalent:
get_dai_frame_counter
get_host_byte_counter

Subsequent patches will remove the old callback.

Cc: stable@vger.kernel.org # 6.8
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240321130814.4412-7-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ops.h      |   24 ++++++++++++++++++++++++
 sound/soc/sof/sof-priv.h |   21 +++++++++++++++++++++
 2 files changed, 45 insertions(+)

--- a/sound/soc/sof/ops.h
+++ b/sound/soc/sof/ops.h
@@ -533,6 +533,30 @@ static inline u64 snd_sof_pcm_get_stream
 	return 0;
 }
 
+static inline u64
+snd_sof_pcm_get_dai_frame_counter(struct snd_sof_dev *sdev,
+				  struct snd_soc_component *component,
+				  struct snd_pcm_substream *substream)
+{
+	if (sof_ops(sdev) && sof_ops(sdev)->get_dai_frame_counter)
+		return sof_ops(sdev)->get_dai_frame_counter(sdev, component,
+							    substream);
+
+	return 0;
+}
+
+static inline u64
+snd_sof_pcm_get_host_byte_counter(struct snd_sof_dev *sdev,
+				  struct snd_soc_component *component,
+				  struct snd_pcm_substream *substream)
+{
+	if (sof_ops(sdev) && sof_ops(sdev)->get_host_byte_counter)
+		return sof_ops(sdev)->get_host_byte_counter(sdev, component,
+							    substream);
+
+	return 0;
+}
+
 /* machine driver */
 static inline int
 snd_sof_machine_register(struct snd_sof_dev *sdev, void *pdata)
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -263,6 +263,27 @@ struct snd_sof_dsp_ops {
 				   struct snd_soc_component *component,
 				   struct snd_pcm_substream *substream); /* optional */
 
+	/*
+	 * optional callback to retrieve the number of frames left/arrived from/to
+	 * the DSP on the DAI side (link/codec/DMIC/etc).
+	 *
+	 * The callback is used when the firmware does not provide this information
+	 * via the shared SRAM window and it can be retrieved by host.
+	 */
+	u64 (*get_dai_frame_counter)(struct snd_sof_dev *sdev,
+				     struct snd_soc_component *component,
+				     struct snd_pcm_substream *substream); /* optional */
+
+	/*
+	 * Optional callback to retrieve the number of bytes left/arrived from/to
+	 * the DSP on the host side (bytes between host ALSA buffer and DSP).
+	 *
+	 * The callback is needed for ALSA delay reporting.
+	 */
+	u64 (*get_host_byte_counter)(struct snd_sof_dev *sdev,
+				     struct snd_soc_component *component,
+				     struct snd_pcm_substream *substream); /* optional */
+
 	/* host read DSP stream data */
 	int (*ipc_msg_data)(struct snd_sof_dev *sdev,
 			    struct snd_sof_pcm_stream *sps,


