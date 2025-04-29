Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AC0248889;
	Tue, 29 Apr 2025 18:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950210; cv=none; b=dW83AozlYY/jOVxxLHocY+UOY2xHrfOKeHUM+SGsk+nkm7PHrv7Y2HmJ0nyhGWIaWiwurVW7gTn70neHqHDVBeggu21Vf5f4z0J83PYgMCQEzLJaPMQ6q700UznkrMRxoi5zimtVl/EUX1VOXZEZcbfOcl55IR42NU+2HkCoXNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950210; c=relaxed/simple;
	bh=VR9SSDxSufjMoQ5n/UcR305pJDICjUzdpQ1fLnm23oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7ZD+ZPRvOwNrsHKjWvy3G8ZDGbQ7qXIElBTFMCLeLSmC3cFuiYStzKSd9VZyc2kLLM0mW7GNlU74+zG3DRuhK38uE7yZfWxRJtcFxMS1ichPlQqW3czQ7oaR2imBkrcNOXky8cch+fUHgfQx+omTA+mxXVw/1vAUMdomi5OKok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRD0oQrP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRD0oQrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865A4C4CEE3;
	Tue, 29 Apr 2025 18:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950210;
	bh=VR9SSDxSufjMoQ5n/UcR305pJDICjUzdpQ1fLnm23oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRD0oQrPlIfLWk5jFrndNffTbVhiETItPLqEvyakqTuE2O1wEubsrH7hJLFvXsWg/
	 eFwNN1n6q1RUQhdPVWMfC97LVI/g2nCzBNWgKiEShRothrJWcR4NQ3rN0IIbMzxtZq
	 b1evwu2tRDePzxSc+vlkLbKy0rHBY5sys7wvxwUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/204] ASoC: q6apm-dai: make use of q6apm_get_hw_pointer
Date: Tue, 29 Apr 2025 18:41:50 +0200
Message-ID: <20250429161100.332116110@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit a93dad6f4e6a04a5943f6ee5686585f24abf7063 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm-dai.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6apm-dai.c b/sound/soc/qcom/qdsp6/q6apm-dai.c
index a52304bef9d92..179f4f7386dd0 100644
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
@@ -124,23 +123,16 @@ static void event_handler(uint32_t opcode, uint32_t token, uint32_t *payload, vo
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
@@ -246,7 +238,6 @@ static int q6apm_dai_prepare(struct snd_soc_component *component,
 	}
 
 	prtd->pcm_count = snd_pcm_lib_period_bytes(substream);
-	prtd->pos = 0;
 	/* rate and channels are sent to audio driver */
 	ret = q6apm_graph_media_format_shmem(prtd->graph, &cfg);
 	if (ret < 0) {
@@ -445,16 +436,12 @@ static snd_pcm_uframes_t q6apm_dai_pointer(struct snd_soc_component *component,
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
@@ -669,8 +656,6 @@ static int q6apm_dai_compr_set_params(struct snd_soc_component *component,
 	prtd->pcm_size = runtime->fragments * runtime->fragment_size;
 	prtd->bits_per_sample = 16;
 
-	prtd->pos = 0;
-
 	if (prtd->next_track != true) {
 		memcpy(&prtd->codec, codec, sizeof(*codec));
 
-- 
2.39.5



