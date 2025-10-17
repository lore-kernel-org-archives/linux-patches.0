Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A48232C931;
	Fri, 17 Oct 2025 15:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715035; cv=none; b=F3EfYzkr3dwOHi+QiT3r+QIClYWmFphQhA13A0sdL2HxnoVzmBOZIrfwxrVwC4Heyi+pwkXgxk2wv8Zx1IDU/fVnhtxL9Wlp495FItFbZA4L2LJU5RjKAy8vSNXtp/LTUJe635fM69nrPBPA8YOZk+ccJzmveywnmgVL5asnF1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715035; c=relaxed/simple;
	bh=bwc3G50cKu/JTMUlHirkApVl7Ubfxu6Q9lGt47t02+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9A6v3pSZ85qU7P+Tl1tUEk5KzCwsKRBoxjvyLKnrJYYKKs7f3/zyPGl9jXlD6E6U+9vKq2J07+qh/vY8PdtQVv6ps5dzroPXTD/ZMu07C/Y2Wks74o1wyaKlmO2k3hK3s0lkwLJMWoBw28StS9PQy2um/aWo1VecLEXyWj50tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hI6GXLbi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hI6GXLbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07826C4CEFE;
	Fri, 17 Oct 2025 15:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715035;
	bh=bwc3G50cKu/JTMUlHirkApVl7Ubfxu6Q9lGt47t02+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hI6GXLbiPKZzPPhWMTmtqqoBsDu4EqEuxREUCiRfo+9WzXk83nK1ikYD9HSva7xZe
	 5hBb7+A93ij+pfFAZGxzbkI6qsyPUmUZ0Y9ST9wH95bjgbqy58kuYXhZFNLoIleWYg
	 634rECeZtY8MLNXulSF8g8AU1sbUFDD7aTrJM7iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 075/371] ASoC: SOF: Intel: hda-pcm: Place the constraint on period time instead of buffer time
Date: Fri, 17 Oct 2025 16:50:50 +0200
Message-ID: <20251017145204.654432874@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 45ad27d9a6f7c620d8bbc80be3bab1faf37dfa0a ]

Instead of constraining the ALSA buffer time to be double of the firmware
host buffer size, it is better to set it for the period time.
This will implicitly constrain the buffer time to a safe value
(num_periods is at least 2) and prohibits applications to set smaller
period size than what will be covered by the initial DMA burst.

Fixes: fe76d2e75a6d ("ASoC: SOF: Intel: hda-pcm: Use dsp_max_burst_size_in_ms to place constraint")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20251002135752.2430-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-pcm.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/sound/soc/sof/intel/hda-pcm.c b/sound/soc/sof/intel/hda-pcm.c
index 1dd8d2092c3b4..da6c1e7263cde 100644
--- a/sound/soc/sof/intel/hda-pcm.c
+++ b/sound/soc/sof/intel/hda-pcm.c
@@ -29,6 +29,8 @@
 #define SDnFMT_BITS(x)	((x) << 4)
 #define SDnFMT_CHAN(x)	((x) << 0)
 
+#define HDA_MAX_PERIOD_TIME_HEADROOM	10
+
 static bool hda_always_enable_dmi_l1;
 module_param_named(always_enable_dmi_l1, hda_always_enable_dmi_l1, bool, 0444);
 MODULE_PARM_DESC(always_enable_dmi_l1, "SOF HDA always enable DMI l1");
@@ -291,19 +293,30 @@ int hda_dsp_pcm_open(struct snd_sof_dev *sdev,
 	 * On playback start the DMA will transfer dsp_max_burst_size_in_ms
 	 * amount of data in one initial burst to fill up the host DMA buffer.
 	 * Consequent DMA burst sizes are shorter and their length can vary.
-	 * To make sure that userspace allocate large enough ALSA buffer we need
-	 * to place a constraint on the buffer time.
+	 * To avoid immediate xrun by the initial burst we need to place
+	 * constraint on the period size (via PERIOD_TIME) to cover the size of
+	 * the host buffer.
+	 * We need to add headroom of max 10ms as the firmware needs time to
+	 * settle to the 1ms pacing and initially it can run faster for few
+	 * internal periods.
 	 *
 	 * On capture the DMA will transfer 1ms chunks.
-	 *
-	 * Exact dsp_max_burst_size_in_ms constraint is racy, so set the
-	 * constraint to a minimum of 2x dsp_max_burst_size_in_ms.
 	 */
-	if (spcm->stream[direction].dsp_max_burst_size_in_ms)
+	if (spcm->stream[direction].dsp_max_burst_size_in_ms) {
+		unsigned int period_time = spcm->stream[direction].dsp_max_burst_size_in_ms;
+
+		/*
+		 * add headroom over the maximum burst size to cover the time
+		 * needed for the DMA pace to settle.
+		 * Limit the headroom time to HDA_MAX_PERIOD_TIME_HEADROOM
+		 */
+		period_time += min(period_time, HDA_MAX_PERIOD_TIME_HEADROOM);
+
 		snd_pcm_hw_constraint_minmax(substream->runtime,
-			SNDRV_PCM_HW_PARAM_BUFFER_TIME,
-			spcm->stream[direction].dsp_max_burst_size_in_ms * USEC_PER_MSEC * 2,
+			SNDRV_PCM_HW_PARAM_PERIOD_TIME,
+			period_time * USEC_PER_MSEC,
 			UINT_MAX);
+	}
 
 	/* binding pcm substream to hda stream */
 	substream->runtime->private_data = &dsp_stream->hstream;
-- 
2.51.0



