Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C657A314A92;
	Mon, 13 Oct 2025 15:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370177; cv=none; b=m2xYqSreNvV1ch3tTos/Hv6iDYN3my/9KinQkg/6yH3QiGlF25cxJpkm2uAjlHwW8gdZXtf+WDt1mJXiEfPQ3mGzBZj4Jibdqfc8dTXJddP6pdJf0e+phgGNCdvEQtDsHBJhbU+Li5UXPkIamMx9zExpI46u69tgZIbGj4O7QZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370177; c=relaxed/simple;
	bh=4lziDK6tC3YxGnIydqv+ygG6NRwTXN8vZ2I0SAn5qGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YEPH/6KWFA3AXyv04kO+9LPFjyB+ubG3RrLqh/Dd/agNM6U7zk71yUPGZaqiBg1nnhSm1xJAojNM+v1FyoEyjc9OaQKSONHLXGhASr3wyI8B1cGkujQUWEAi0UtAfMRj0BltbGm5iyWz9NU9U209lrOUovhePSiTB//yDjUvHc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dma9hc3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dma9hc3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA09C116B1;
	Mon, 13 Oct 2025 15:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370177;
	bh=4lziDK6tC3YxGnIydqv+ygG6NRwTXN8vZ2I0SAn5qGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dma9hc3pCkxGnJIKBhrY5iYtkhOb8mZQzK9+0enwWHMW9ZY2IqINy8j+uX9c5iImU
	 JxJfBtCyXa8jglLZTXkHpzAXUVi9ANrfk5GT6CfE9yO7mqQQQIKM9dcKrUOegsJE11
	 e9+mlF+Kfcrc6kbckbJr5ueMiPggR9uHNJP/OT+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.17 505/563] ASoC: SOF: ipc4-pcm: fix delay calculation when DSP resamples
Date: Mon, 13 Oct 2025 16:46:06 +0200
Message-ID: <20251013144429.604029730@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

commit bcd1383516bb5a6f72b2d1e7f7ad42c4a14837d1 upstream.

When the sampling rates going in (host) and out (dai) from the DSP
are different, the IPC4 delay reporting does not work correctly.
Add support for this case by scaling the all raw position values to
a common timebase before calculating real-time delay for the PCM.

Cc: stable@vger.kernel.org
Fixes: 0ea06680dfcb ("ASoC: SOF: ipc4-pcm: Correct the delay calculation")
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20251002074719.2084-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-pcm.c |   83 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 62 insertions(+), 21 deletions(-)

--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -19,12 +19,14 @@
  * struct sof_ipc4_timestamp_info - IPC4 timestamp info
  * @host_copier: the host copier of the pcm stream
  * @dai_copier: the dai copier of the pcm stream
- * @stream_start_offset: reported by fw in memory window (converted to frames)
- * @stream_end_offset: reported by fw in memory window (converted to frames)
+ * @stream_start_offset: reported by fw in memory window (converted to
+ *                       frames at host_copier sampling rate)
+ * @stream_end_offset: reported by fw in memory window (converted to
+ *                     frames at host_copier sampling rate)
  * @llp_offset: llp offset in memory window
- * @boundary: wrap boundary should be used for the LLP frame counter
  * @delay: Calculated and stored in pointer callback. The stored value is
- *	   returned in the delay callback.
+ *         returned in the delay callback. Expressed in frames at host copier
+ *         sampling rate.
  */
 struct sof_ipc4_timestamp_info {
 	struct sof_ipc4_copier *host_copier;
@@ -33,7 +35,6 @@ struct sof_ipc4_timestamp_info {
 	u64 stream_end_offset;
 	u32 llp_offset;
 
-	u64 boundary;
 	snd_pcm_sframes_t delay;
 };
 
@@ -48,6 +49,16 @@ struct sof_ipc4_pcm_stream_priv {
 	bool chain_dma_allocated;
 };
 
+/*
+ * Modulus to use to compare host and link position counters. The sampling
+ * rates may be different, so the raw hardware counters will wrap
+ * around at different times. To calculate differences, use
+ * DELAY_BOUNDARY as a common modulus. This value must be smaller than
+ * the wrap-around point of any hardware counter, and larger than any
+ * valid delay measurement.
+ */
+#define DELAY_BOUNDARY		U32_MAX
+
 static inline struct sof_ipc4_timestamp_info *
 sof_ipc4_sps_to_time_info(struct snd_sof_pcm_stream *sps)
 {
@@ -993,6 +1004,35 @@ static int sof_ipc4_pcm_hw_params(struct
 	return 0;
 }
 
+static u64 sof_ipc4_frames_dai_to_host(struct sof_ipc4_timestamp_info *time_info, u64 value)
+{
+	u64 dai_rate, host_rate;
+
+	if (!time_info->dai_copier || !time_info->host_copier)
+		return value;
+
+	/*
+	 * copiers do not change sampling rate, so we can use the
+	 * out_format independently of stream direction
+	 */
+	dai_rate = time_info->dai_copier->data.out_format.sampling_frequency;
+	host_rate = time_info->host_copier->data.out_format.sampling_frequency;
+
+	if (!dai_rate || !host_rate || dai_rate == host_rate)
+		return value;
+
+	/* take care not to overflow u64, rates can be up to 768000 */
+	if (value > U32_MAX) {
+		value = div64_u64(value, dai_rate);
+		value *= host_rate;
+	} else {
+		value *= host_rate;
+		value = div64_u64(value, dai_rate);
+	}
+
+	return value;
+}
+
 static int sof_ipc4_get_stream_start_offset(struct snd_sof_dev *sdev,
 					    struct snd_pcm_substream *substream,
 					    struct snd_sof_pcm_stream *sps,
@@ -1043,14 +1083,13 @@ static int sof_ipc4_get_stream_start_off
 	time_info->stream_end_offset = ppl_reg.stream_end_offset;
 	do_div(time_info->stream_end_offset, dai_sample_size);
 
+	/* convert to host frame time */
+	time_info->stream_start_offset =
+		sof_ipc4_frames_dai_to_host(time_info, time_info->stream_start_offset);
+	time_info->stream_end_offset =
+		sof_ipc4_frames_dai_to_host(time_info, time_info->stream_end_offset);
+
 out:
-	/*
-	 * Calculate the wrap boundary need to be used for delay calculation
-	 * The host counter is in bytes, it will wrap earlier than the frames
-	 * based link counter.
-	 */
-	time_info->boundary = div64_u64(~((u64)0),
-					frames_to_bytes(substream->runtime, 1));
 	/* Initialize the delay value to 0 (no delay) */
 	time_info->delay = 0;
 
@@ -1093,6 +1132,8 @@ static int sof_ipc4_pcm_pointer(struct s
 
 	/* For delay calculation we need the host counter */
 	host_cnt = snd_sof_pcm_get_host_byte_counter(sdev, component, substream);
+
+	/* Store the original value to host_ptr */
 	host_ptr = host_cnt;
 
 	/* convert the host_cnt to frames */
@@ -1111,6 +1152,8 @@ static int sof_ipc4_pcm_pointer(struct s
 		sof_mailbox_read(sdev, time_info->llp_offset, &llp, sizeof(llp));
 		dai_cnt = ((u64)llp.reading.llp_u << 32) | llp.reading.llp_l;
 	}
+
+	dai_cnt = sof_ipc4_frames_dai_to_host(time_info, dai_cnt);
 	dai_cnt += time_info->stream_end_offset;
 
 	/* In two cases dai dma counter is not accurate
@@ -1144,8 +1187,9 @@ static int sof_ipc4_pcm_pointer(struct s
 		dai_cnt -= time_info->stream_start_offset;
 	}
 
-	/* Wrap the dai counter at the boundary where the host counter wraps */
-	div64_u64_rem(dai_cnt, time_info->boundary, &dai_cnt);
+	/* Convert to a common base before comparisons */
+	dai_cnt &= DELAY_BOUNDARY;
+	host_cnt &= DELAY_BOUNDARY;
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		head_cnt = host_cnt;
@@ -1155,14 +1199,11 @@ static int sof_ipc4_pcm_pointer(struct s
 		tail_cnt = host_cnt;
 	}
 
-	if (head_cnt < tail_cnt) {
-		time_info->delay = time_info->boundary - tail_cnt + head_cnt;
-		goto out;
-	}
-
-	time_info->delay =  head_cnt - tail_cnt;
+	if (unlikely(head_cnt < tail_cnt))
+		time_info->delay = DELAY_BOUNDARY - tail_cnt + head_cnt;
+	else
+		time_info->delay = head_cnt - tail_cnt;
 
-out:
 	/*
 	 * Convert the host byte counter to PCM pointer which wraps in buffer
 	 * and it is in frames


