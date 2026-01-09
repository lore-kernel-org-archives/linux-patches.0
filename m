Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9AC2F0C7F;
	Fri,  9 Jan 2026 12:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960845; cv=none; b=MBiddVnIhqeyYOQHGoZu2dlplp/Zu0Bqy2FFjtmrQY5zJA0vR4yid0zym8z/inqnm3uroVhB6P79XRkYFw0X7G6kP/9BULmv7SvLGxBp2GZMQC1m+kXOLf7CTsiMkSvkaXkxAd5iBkwlpEHZA1qSAKvjMzsQ3MNQfSnkwwQrmi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960845; c=relaxed/simple;
	bh=ZpXbQA56tNTCU3jt80opTnPTKoEdUYmPOfa04Ak7Eps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCF/b+8qSjX4D/HYvtOgZ6LSfZLEwr6Njj0YLqae+3HUiHlTEV5SPPzQrs2qZHiEa4G6hLkHgvIvzZYWJOHW3pLixstrot5pzRwzcJJq0BSvmMuQUlpGsUBp9+VAfs8856RsppgpnXRgTbaKcyEz1/L33k/8C3mIaUvdHd8HN1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFxVqP0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFxVqP0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD78C4CEF1;
	Fri,  9 Jan 2026 12:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960845;
	bh=ZpXbQA56tNTCU3jt80opTnPTKoEdUYmPOfa04Ak7Eps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HFxVqP0+Llwt5rKfXNTVgVCyxn34zsv8uLbraQrCojWf2IsdqAQxpMgd63gBnXsMG
	 r/Rn3LGBizk54r4jhP8DnpSAASkKMDTQ8lMSDS8G353NbAfD2zcYUY6bg5yHFhBqqR
	 UE0lk4Fektc064OgKGX61GDJJyyZY+wUk9gX8Hq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>
Subject: [PATCH 6.6 546/737] ASoC: qcom: q6asm-dai: perform correct state check before closing
Date: Fri,  9 Jan 2026 12:41:25 +0100
Message-ID: <20260109112154.535012766@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit bfbb12dfa144d45575bcfe139a71360b3ce80237 upstream.

Do not stop a q6asm stream if its not started, this can result in
unnecessary dsp command which will timeout anyway something like below:

q6asm-dai ab00000.remoteproc:glink-edge:apr:service@7:dais: CMD 10bcd timeout

Fix this by correctly checking the state.

Fixes: 2a9e92d371db ("ASoC: qdsp6: q6asm: Add q6asm dai driver")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Tested-by: Alexey Klimov <alexey.klimov@linaro.org> # RB5, RB3
Link: https://patch.msgid.link/20251023102444.88158-5-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6asm-dai.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/qcom/qdsp6/q6asm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6asm-dai.c
@@ -237,13 +237,14 @@ static int q6asm_dai_prepare(struct snd_
 	prtd->pcm_count = snd_pcm_lib_period_bytes(substream);
 	prtd->pcm_irq_pos = 0;
 	/* rate and channels are sent to audio driver */
-	if (prtd->state) {
+	if (prtd->state == Q6ASM_STREAM_RUNNING) {
 		/* clear the previous setup if any  */
 		q6asm_cmd(prtd->audio_client, prtd->stream_id, CMD_CLOSE);
 		q6asm_unmap_memory_regions(substream->stream,
 					   prtd->audio_client);
 		q6routing_stream_close(soc_prtd->dai_link->id,
 					 substream->stream);
+		prtd->state = Q6ASM_STREAM_STOPPED;
 	}
 
 	ret = q6asm_map_memory_regions(substream->stream, prtd->audio_client,


