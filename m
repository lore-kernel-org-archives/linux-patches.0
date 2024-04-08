Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5CF7D09F;
	Mon,  8 Apr 2024 13:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583739; cv=none; b=TQOzQ0dlXnuW9NyBcGNmAV8VhplrUC5t6BMFfYFj3qz/kXcMtZpq1nd1Tr2pn8Fp+VOjW+hMwp1WR/I4/VQOf1b15J72cL2XedGkEVZ9ShbO5IxF8L6IkNGFH/h422hg0oBtk0KYFY1iUFr/OsJh8hKqHJJHNynzAI+W1MQdTl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583739; c=relaxed/simple;
	bh=AMIc4fQwZ7aKc6VRRVO8pATkimcMkc+xpp9xAb6nIpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzBbeZZeYj7+uBfOxgm1Dah5r3vNygXhTePa8V0POxC7iD0svGnUKgBu3FBvm/WxbZ5hCcvPH0T0fqSHNYJ6LEpCwhzi6A2iMRJI+tUfJnnbBXjpow9Gyh4Oovn8Gj4GW97I5oK2K5MqzsNVlMY+gEWEp+DCxZKY7gTm0dkV3Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnf3MTBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnf3MTBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518DFC433F1;
	Mon,  8 Apr 2024 13:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583739;
	bh=AMIc4fQwZ7aKc6VRRVO8pATkimcMkc+xpp9xAb6nIpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnf3MTBXRxqSFDbTNZatoG7hJ/oMFHl2YMAFgr01XgvHPnp/neV39Hw0SR6aYS4m0
	 GxqdDRZlxjUhBlj1kJhLgCK5/oaOCIQhACQ5MJ6snKW33IushtN7IuN77HloHNUnOe
	 nDowRURPKiU0Gj5mO7ksPTUf4wwRjyUwcavLqusk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.8 214/273] ASoC: SOF: Intel: hda-pcm: Use dsp_max_burst_size_in_ms to place constraint
Date: Mon,  8 Apr 2024 14:58:09 +0200
Message-ID: <20240408125316.018887102@linuxfoundation.org>
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

commit fe76d2e75a6da97edd2b4ec5cfb9efd541be087a upstream.

If the PCM have the dsp_max_burst_size_in_ms set then place a constraint
to limit the minimum buffer time to avoid xruns caused by DMA bursts
spinning on the ALSA buffer.

Cc: stable@vger.kernel.org # 6.8
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240321130814.4412-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-pcm.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/sound/soc/sof/intel/hda-pcm.c b/sound/soc/sof/intel/hda-pcm.c
index 18f07364d219..69fefcd1abc5 100644
--- a/sound/soc/sof/intel/hda-pcm.c
+++ b/sound/soc/sof/intel/hda-pcm.c
@@ -259,6 +259,27 @@ int hda_dsp_pcm_open(struct snd_sof_dev *sdev,
 		snd_pcm_hw_constraint_mask64(substream->runtime, SNDRV_PCM_HW_PARAM_FORMAT,
 					     SNDRV_PCM_FMTBIT_S16 | SNDRV_PCM_FMTBIT_S32);
 
+	/*
+	 * The dsp_max_burst_size_in_ms is the length of the maximum burst size
+	 * of the host DMA in the ALSA buffer.
+	 *
+	 * On playback start the DMA will transfer dsp_max_burst_size_in_ms
+	 * amount of data in one initial burst to fill up the host DMA buffer.
+	 * Consequent DMA burst sizes are shorter and their length can vary.
+	 * To make sure that userspace allocate large enough ALSA buffer we need
+	 * to place a constraint on the buffer time.
+	 *
+	 * On capture the DMA will transfer 1ms chunks.
+	 *
+	 * Exact dsp_max_burst_size_in_ms constraint is racy, so set the
+	 * constraint to a minimum of 2x dsp_max_burst_size_in_ms.
+	 */
+	if (spcm->stream[direction].dsp_max_burst_size_in_ms)
+		snd_pcm_hw_constraint_minmax(substream->runtime,
+			SNDRV_PCM_HW_PARAM_BUFFER_TIME,
+			spcm->stream[direction].dsp_max_burst_size_in_ms * USEC_PER_MSEC * 2,
+			UINT_MAX);
+
 	/* binding pcm substream to hda stream */
 	substream->runtime->private_data = &dsp_stream->hstream;
 	return 0;
-- 
2.44.0



