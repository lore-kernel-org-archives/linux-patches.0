Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0CC18C034;
	Thu, 17 Apr 2025 18:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913391; cv=none; b=ZGbvq8VsEWjmAeaS81SX4mQBy5rLqMJHh7Xl5uBGMLF1Vd4yjKEnnFUN/oaCTCQBK9ztZHFGmEvcpF70XLXvFBb5Sr4LG7h4SsLoXGgY2B+wT8Qkivd7uBJjd+6alD3I2VxhCv+zYcUEYmkXAfqVt9Zdq1nyb462qQ0elwK7wek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913391; c=relaxed/simple;
	bh=7PQzRqwwqrY6Pkan4KzYI1W9s2sTL9bj4YppqHkvLQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giYXDU9CZ89GtSFFCvjHkaKdxersTDZWN/M2L2yfG+CJ4BuIJaPxCB265ljbg6es9kP9mnOSPFE6QlS8pd8UzJYU/sddyxD2S/0hPDekuLDWAL13o7pv9C4bMFVGeVXog37jwQ/EK/FZNFOphHCiML293BVYWXlCc/5mlu22qeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYT9jOW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYT9jOW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1FDC4CEE4;
	Thu, 17 Apr 2025 18:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913390;
	bh=7PQzRqwwqrY6Pkan4KzYI1W9s2sTL9bj4YppqHkvLQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYT9jOW/CFOQF33bpYr7+SutnguI1zF8mUTgi9xwHHu03Szsmj1phl36KYRjYeXsc
	 gQ+WKAoDIqm3k9ATkt3QqyJI3I2BV3ovVy4rLH1AiL4PdspK1lS4iu3U1XBD578yCC
	 15Zpk0wnPHui4vq1eB2on7OB4vd/RhlD0Lzfjhhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.14 296/449] ASoC: q6apm-dai: make use of q6apm_get_hw_pointer
Date: Thu, 17 Apr 2025 19:49:44 +0200
Message-ID: <20250417175130.002036265@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit a93dad6f4e6a04a5943f6ee5686585f24abf7063 upstream.

With the existing code, the buffer position is only reset in pointer
callback, which leaves the possiblity of it going over the size of
buffer size and reporting incorrect position to userspace.

Without this patch, its possible to see errors like:
snd-x1e80100 sound: invalid position: pcmC0D0p:0, pos = 12288, buffer size = 12288, period size = 1536
snd-x1e80100 sound: invalid position: pcmC0D0p:0, pos = 12288, buffer size = 12288, period size = 1536

Fixes: 9b4fe0f1cd791 ("ASoC: qdsp6: audioreach: add q6apm-dai support")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://patch.msgid.link/20250314174800.10142-4-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm-dai.c |   23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

--- a/sound/soc/qcom/qdsp6/q6apm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6apm-dai.c
@@ -64,7 +64,6 @@ struct q6apm_dai_rtd {
 	phys_addr_t phys;
 	unsigned int pcm_size;
 	unsigned int pcm_count;
-	unsigned int pos;       /* Buffer position */
 	unsigned int periods;
 	unsigned int bytes_sent;
 	unsigned int bytes_received;
@@ -124,23 +123,16 @@ static void event_handler(uint32_t opcod
 {
 	struct q6apm_dai_rtd *prtd = priv;
 	struct snd_pcm_substream *substream = prtd->substream;
-	unsigned long flags;
 
 	switch (opcode) {
 	case APM_CLIENT_EVENT_CMD_EOS_DONE:
 		prtd->state = Q6APM_STREAM_STOPPED;
 		break;
 	case APM_CLIENT_EVENT_DATA_WRITE_DONE:
-		spin_lock_irqsave(&prtd->lock, flags);
-		prtd->pos += prtd->pcm_count;
-		spin_unlock_irqrestore(&prtd->lock, flags);
 		snd_pcm_period_elapsed(substream);
 
 		break;
 	case APM_CLIENT_EVENT_DATA_READ_DONE:
-		spin_lock_irqsave(&prtd->lock, flags);
-		prtd->pos += prtd->pcm_count;
-		spin_unlock_irqrestore(&prtd->lock, flags);
 		snd_pcm_period_elapsed(substream);
 		if (prtd->state == Q6APM_STREAM_RUNNING)
 			q6apm_read(prtd->graph);
@@ -247,7 +239,6 @@ static int q6apm_dai_prepare(struct snd_
 	}
 
 	prtd->pcm_count = snd_pcm_lib_period_bytes(substream);
-	prtd->pos = 0;
 	/* rate and channels are sent to audio driver */
 	ret = q6apm_graph_media_format_shmem(prtd->graph, &cfg);
 	if (ret < 0) {
@@ -445,16 +436,12 @@ static snd_pcm_uframes_t q6apm_dai_point
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct q6apm_dai_rtd *prtd = runtime->private_data;
 	snd_pcm_uframes_t ptr;
-	unsigned long flags;
 
-	spin_lock_irqsave(&prtd->lock, flags);
-	if (prtd->pos == prtd->pcm_size)
-		prtd->pos = 0;
-
-	ptr =  bytes_to_frames(runtime, prtd->pos);
-	spin_unlock_irqrestore(&prtd->lock, flags);
+	ptr = q6apm_get_hw_pointer(prtd->graph, substream->stream) * runtime->period_size;
+	if (ptr)
+		return ptr - 1;
 
-	return ptr;
+	return 0;
 }
 
 static int q6apm_dai_hw_params(struct snd_soc_component *component,
@@ -669,8 +656,6 @@ static int q6apm_dai_compr_set_params(st
 	prtd->pcm_size = runtime->fragments * runtime->fragment_size;
 	prtd->bits_per_sample = 16;
 
-	prtd->pos = 0;
-
 	if (prtd->next_track != true) {
 		memcpy(&prtd->codec, codec, sizeof(*codec));
 


