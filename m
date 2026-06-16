Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617483D88F6;
	Tue, 16 Jun 2026 18:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633574; cv=none; b=uW40rdMRAV6vTzNupvd2DQVirOwGskpXWBAS1ZLyEkKNvuirHC/mmEILQ/x1jf74LAK1Z20tuqFtRacAV6zZki65lJJKzq4OOAArbqdA5DKlzMM1N1JOsHmoorzSUW+iW4qUaotH3Cmt2CsGa5YOmar8NVySPBtr5Lcc6JsCJEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633574; c=relaxed/simple;
	bh=ttGFwA5fOtpuswr4HrkdjuIiDF+I33awycm8Sz7skxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJPyNY4hXbANnpPwLISygYYiNucSxPVT7rnljXAt/jO35CbxhIWQy9uqy0KBnSRVq83cXLwfxSslKd0O2YCKekSdzU9KVi4giHXwJfCUHIgfT7QEp15PG1W5VLbGD/F9mlwFqQhFFy4Y/nPFjiRnW8Q2P/pEvgAicefrUO34wmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlWWOEFQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlWWOEFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E7E1F00A3A;
	Tue, 16 Jun 2026 18:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633573;
	bh=NonTEu4rBXDFbqklH4Reb+7Mcp9DOKdYwfo45GsZ7Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nlWWOEFQ/0c1OAo8QJx9v8x8livZ5RWvVf2cS0sdk2SopD7s9GoMN+FTFxdoPAtyv
	 EK/GHh5t7j1LsrFVl66etGq59ggR4tgL3N6LS4yXUdsKXGKffHGA0+z3sdaCCGIjcY
	 L4y7X9gJkzFuNEVNSn9XgIEID1qOO0qzMHXqFafc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 087/411] ASoC: qcom: q6asm-dai: fix error handling in prepare and set_params
Date: Tue, 16 Jun 2026 20:25:25 +0530
Message-ID: <20260616145104.874390377@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -912,7 +920,7 @@ static int q6asm_dai_compr_set_params(st
 			      prtd->session_id, dir);
 	if (ret) {
 		dev_err(dev, "Stream reg failed ret:%d\n", ret);
-		goto q6_err;
+		goto routing_err;
 	}
 
 	ret = __q6asm_dai_compr_set_codec_params(component, stream,
@@ -938,11 +946,11 @@ static int q6asm_dai_compr_set_params(st
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
 


