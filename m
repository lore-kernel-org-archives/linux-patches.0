Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B2EBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864FBC433D2;
	Tue,  7 Mar 2023 18:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212955;
	bh=NXGQ01tlgLQN7MbI9LHosK6ExbGw+zd4mydgOVcpzk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAwFU4V8yeyysze+SkWcmWfyhTfRkFyWLql/9K9AqcHJ/RnoIrKioeB4t4gE1bKJQ
	 CjmZ5LCLKgJ509NoG7zNZijvDYs6JyWmRJLCT2SpFL1YBkIWoABL+utVtJcBInIFxR
	 o7684dWIzPQzlgzClBB/V6UB6e4J/Vwfn4+1zaTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 352/885] ASoC: qcom: q6apm-dai: fix race condition while updating the position pointer
Date: Tue,  7 Mar 2023 17:54:46 +0100
Message-Id: <20230307170017.559237005@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 84222ef54bfd8f043c23c8603fd5257a64b00780 ]

It is noticed that the position pointer value seems to get a get corrupted
due to missing locking between updating and reading.

Fix this by adding a spinlock around the position pointer.

Fixes: 9b4fe0f1cd79 ("ASoC: qdsp6: audioreach: add q6apm-dai support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230209122806.18923-3-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm-dai.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/sound/soc/qcom/qdsp6/q6apm-dai.c b/sound/soc/qcom/qdsp6/q6apm-dai.c
index ee59ef36b85a6..bd35067a40521 100644
--- a/sound/soc/qcom/qdsp6/q6apm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6apm-dai.c
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
+#include <linux/spinlock.h>
 #include <sound/pcm.h>
 #include <asm/dma.h>
 #include <linux/dma-mapping.h>
@@ -53,6 +54,7 @@ struct q6apm_dai_rtd {
 	uint16_t session_id;
 	enum stream_state state;
 	struct q6apm_graph *graph;
+	spinlock_t lock;
 };
 
 struct q6apm_dai_data {
@@ -99,20 +101,25 @@ static void event_handler(uint32_t opcode, uint32_t token, uint32_t *payload, vo
 {
 	struct q6apm_dai_rtd *prtd = priv;
 	struct snd_pcm_substream *substream = prtd->substream;
+	unsigned long flags;
 
 	switch (opcode) {
 	case APM_CLIENT_EVENT_CMD_EOS_DONE:
 		prtd->state = Q6APM_STREAM_STOPPED;
 		break;
 	case APM_CLIENT_EVENT_DATA_WRITE_DONE:
+	        spin_lock_irqsave(&prtd->lock, flags);
 		prtd->pos += prtd->pcm_count;
+		spin_unlock_irqrestore(&prtd->lock, flags);
 		snd_pcm_period_elapsed(substream);
 		if (prtd->state == Q6APM_STREAM_RUNNING)
 			q6apm_write_async(prtd->graph, prtd->pcm_count, 0, 0, 0);
 
 		break;
 	case APM_CLIENT_EVENT_DATA_READ_DONE:
+	        spin_lock_irqsave(&prtd->lock, flags);
 		prtd->pos += prtd->pcm_count;
+		spin_unlock_irqrestore(&prtd->lock, flags);
 		snd_pcm_period_elapsed(substream);
 		if (prtd->state == Q6APM_STREAM_RUNNING)
 			q6apm_read(prtd->graph);
@@ -253,6 +260,7 @@ static int q6apm_dai_open(struct snd_soc_component *component,
 	if (prtd == NULL)
 		return -ENOMEM;
 
+	spin_lock_init(&prtd->lock);
 	prtd->substream = substream;
 	prtd->graph = q6apm_graph_open(dev, (q6apm_cb)event_handler, prtd, graph_id);
 	if (IS_ERR(prtd->graph)) {
@@ -332,11 +340,17 @@ static snd_pcm_uframes_t q6apm_dai_pointer(struct snd_soc_component *component,
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct q6apm_dai_rtd *prtd = runtime->private_data;
+	snd_pcm_uframes_t ptr;
+	unsigned long flags;
 
+	spin_lock_irqsave(&prtd->lock, flags);
 	if (prtd->pos == prtd->pcm_size)
 		prtd->pos = 0;
 
-	return bytes_to_frames(runtime, prtd->pos);
+	ptr =  bytes_to_frames(runtime, prtd->pos);
+	spin_unlock_irqrestore(&prtd->lock, flags);
+
+	return ptr;
 }
 
 static int q6apm_dai_hw_params(struct snd_soc_component *component,
-- 
2.39.2



