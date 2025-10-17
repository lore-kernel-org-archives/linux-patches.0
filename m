Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A2B32C94B;
	Fri, 17 Oct 2025 15:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715048; cv=none; b=o4jjLv9JoEuI8LFw1b33hk9O4h0lvtv2AusR4QRkae8t1ZP0fDCJHUCKJerOMoME4+PLKL9GjlXznkIHf6mRkzyx6RRj2F3DQG0ZOcvTlBswSGQl0GD7RqU5bnvK97r556PRikTtfPHmwbNHiHWhV+RyBJ7lfv9AQrsi6dsFn1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715048; c=relaxed/simple;
	bh=j4KienSS+lDgxMqRwrzla0RtTgE+T5fx7Sj1oUK7a4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2uZ/J7gZnIObeZNWbgZlI52VEd9ojisSQjDqdU9WQIv6sj0tGDTmIxdIz4zBQ8xmENVYRIPrurkhmydUcNeFOIZhoQgmM8ck94VEM+ykbDj7zed8QdRqqPe1L/LRWpddAEOx2RtEGt+FLrNt8AaRj+pWREiVgj0fPsHY0c2XtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1BqRZEL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1BqRZEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFC1C4CEE7;
	Fri, 17 Oct 2025 15:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715046;
	bh=j4KienSS+lDgxMqRwrzla0RtTgE+T5fx7Sj1oUK7a4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1BqRZEL2VK3R/3jq/xNEY/ID1DPqeMHXsSauJ80wM00+jrjPOtuBeyk5n0O/yh16
	 ck7ry2EqTcF3wf4SYui2bchAsLj+Q7cp1IZoTLg6JQiQ5S8Y4QSeCxfX5/pB8b++Ao
	 KbLZw9TXBytqj1QRx+c3WErLpzyeLoAAI9FGRI8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 079/371] ASoC: SOF: Intel: Read the LLP via the associated Link DMA channel
Date: Fri, 17 Oct 2025 16:50:54 +0200
Message-ID: <20251017145204.798279140@linuxfoundation.org>
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

[ Upstream commit aaab61de1f1e44a2ab527e935474e2e03a0f6b08 ]

It is allowed to mix Link and Host DMA channels in a way that their index
is different. In this case we would read the LLP from a channel which is
not used or used for other operation.

Such case can be reproduced on cAVS2.5 or ACE1 platforms with soundwire
configuration:
playback to SDW would take Host channel 0 (stream_tag 1) and no Link DMA
used
Second playback to HDMI (HDA) would use Host channel 1 (stream_tag 2) and
Link channel 0 (stream_tag 1).

In this case reading the LLP from channel 2 is incorrect as that is not the
Link channel used for the HDMI playback.

To correct this, we should look up the BE and get the channel used on the
Link side.

Fixes: 67b182bea08a ("ASoC: SOF: Intel: hda: Implement get_stream_position (Linear Link Position)")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://patch.msgid.link/20251002074719.2084-6-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-stream.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/intel/hda-stream.c b/sound/soc/sof/intel/hda-stream.c
index a34f472ef1751..9c3b3a9aaf83c 100644
--- a/sound/soc/sof/intel/hda-stream.c
+++ b/sound/soc/sof/intel/hda-stream.c
@@ -1129,10 +1129,35 @@ u64 hda_dsp_get_stream_llp(struct snd_sof_dev *sdev,
 			   struct snd_soc_component *component,
 			   struct snd_pcm_substream *substream)
 {
-	struct hdac_stream *hstream = substream->runtime->private_data;
-	struct hdac_ext_stream *hext_stream = stream_to_hdac_ext_stream(hstream);
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
+	struct snd_soc_pcm_runtime *be_rtd = NULL;
+	struct hdac_ext_stream *hext_stream;
+	struct snd_soc_dai *cpu_dai;
+	struct snd_soc_dpcm *dpcm;
 	u32 llp_l, llp_u;
 
+	/*
+	 * The LLP needs to be read from the Link DMA used for this FE as it is
+	 * allowed to use any combination of Link and Host channels
+	 */
+	for_each_dpcm_be(rtd, substream->stream, dpcm) {
+		if (dpcm->fe != rtd)
+			continue;
+
+		be_rtd = dpcm->be;
+	}
+
+	if (!be_rtd)
+		return 0;
+
+	cpu_dai = snd_soc_rtd_to_cpu(be_rtd, 0);
+	if (!cpu_dai)
+		return 0;
+
+	hext_stream = snd_soc_dai_get_dma_data(cpu_dai, substream);
+	if (!hext_stream)
+		return 0;
+
 	/*
 	 * The pplc_addr have been calculated during probe in
 	 * hda_dsp_stream_init():
-- 
2.51.0



