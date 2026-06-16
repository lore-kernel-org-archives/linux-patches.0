Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5A2331A44;
	Tue, 16 Jun 2026 18:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635563; cv=none; b=hgIk2JdHLwq0p5H8XafCutn5AT97GZVj+WkRRi1olAUaziXzhWmG8pPClr7UMFTdDuI9HSiRgHCi5Tz363W4p5Wj30op+t3DUZazEM+XXbMc2oGTtY07kDiAJFHVqTj6rUX+vF89BP8SyQlosKHRCpXeWVXzrRIY2HlfkhnHBaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635563; c=relaxed/simple;
	bh=Noim+MBRN6f3N69rFx8jeEiySxxGoGXiW80P9Dw43EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQBXuzqfdB55FCSjvER6uGgGVYVkdOjdy0sYKdYL62HUVh/BYxBI3lRbFZN92Q0AFeeaLex3gBJTQ4XlzLnbJEIbVPFJeNziYM2DaiPShR+bEMbF4IbbsVgUEsljrMkqh75G3XIi3T0xIuZvD21THeUpwOmQNk/4HHju0+XiOx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1yc0Ckx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1yc0Ckx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32DD1F000E9;
	Tue, 16 Jun 2026 18:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635562;
	bh=bW/m705OzeOQ93fgJDd6lgTt8ueuN1l5hOLm6v7EUpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1yc0CkxfWoB0Yy+wCzcWKVonEEhrPFnAA1t39NuTzfP6+OAIlXTzugX9QPkngpUv
	 UHAdjq00W0MfNzl3pNZFjPryqtrEii4mbJkqQy+P1+btDuWuHnZXzaKiXKLV8bv1qU
	 RrmTX/JYw5vV6j+75fpfIhur2NWjKRB7wgUFuAT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 072/342] ASoC: qcom: q6asm-dai: fix error handling in prepare and set_params
Date: Tue, 16 Jun 2026 20:26:08 +0530
Message-ID: <20260616145051.599063975@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit 4b4db09f283df65d780bc7cee66cb4a7e9bf4770 upstream.

Fix error handling in q6asm_dai_compr_set_params() and q6asm_dai_prepare()
for both CMD_CLOSE and q6asm_unmap_memory_regions().

In both the functions, we are doing q6asm_audio_client_free in failure
cases, which means if prepare or set_params fail, we can never recover.
Now open and close are done in respective dai_open/close functions.

Fixes: 2a9e92d371db ("ASoC: qdsp6: q6asm: Add q6asm dai driver")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260518092347.3446946-4-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6asm-dai.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/sound/soc/qcom/qdsp6/q6asm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6asm-dai.c
@@ -239,9 +239,19 @@ static int q6asm_dai_prepare(struct snd_
 	/* rate and channels are sent to audio driver */
 	if (prtd->state == Q6ASM_STREAM_RUNNING) {
 		/* clear the previous setup if any  */
-		q6asm_cmd(prtd->audio_client, prtd->stream_id, CMD_CLOSE);
-		q6asm_unmap_memory_regions(substream->stream,
-					   prtd->audio_client);
+		ret = q6asm_cmd(prtd->audio_client, prtd->stream_id, CMD_CLOSE);
+		if (ret < 0) {
+			dev_err(dev, "Failed to close q6asm stream %d\n", prtd->stream_id);
+			return ret;
+		}
+
+		ret = q6asm_unmap_memory_regions(substream->stream, prtd->audio_client);
+		if (ret < 0) {
+			dev_err(dev, "Failed to unmap memory regions for q6asm stream %d\n",
+				prtd->stream_id);
+			return ret;
+		}
+
 		q6routing_stream_close(soc_prtd->dai_link->id,
 					 substream->stream);
 		prtd->state = Q6ASM_STREAM_STOPPED;
@@ -309,8 +319,6 @@ routing_err:
 	q6asm_cmd(prtd->audio_client, prtd->stream_id,  CMD_CLOSE);
 open_err:
 	q6asm_unmap_memory_regions(substream->stream, prtd->audio_client);
-	q6asm_audio_client_free(prtd->audio_client);
-	prtd->audio_client = NULL;
 
 	return ret;
 }
@@ -926,7 +934,7 @@ static int q6asm_dai_compr_set_params(st
 			      prtd->session_id, dir);
 	if (ret) {
 		dev_err(dev, "Stream reg failed ret:%d\n", ret);
-		goto q6_err;
+		goto routing_err;
 	}
 
 	ret = __q6asm_dai_compr_set_codec_params(component, stream,
@@ -952,11 +960,11 @@ static int q6asm_dai_compr_set_params(st
 	return 0;
 
 q6_err:
+	q6routing_stream_close(rtd->dai_link->id, dir);
+routing_err:
 	q6asm_cmd(prtd->audio_client, prtd->stream_id, CMD_CLOSE);
 
 open_err:
-	q6asm_audio_client_free(prtd->audio_client);
-	prtd->audio_client = NULL;
 	return ret;
 }
 


