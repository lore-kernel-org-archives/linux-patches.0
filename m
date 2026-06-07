Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D186C2FB97B;
	Sun,  7 Jun 2026 10:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828979; cv=none; b=DJFZ8+O8mA+Q6Q2dohJjoq/ZMtDyohsB3FyzIHGgZaUlDa/cp8G8n9IjUhilO8kWwQKKXWFZbtAdUCOlH8lJK7ZQldDjPZF++YIyW5QReffWLznHiof8mEIJBCfKUTEaNocRycUqkLzgXQ85QkjCQHDqCMmxKldUxvBW0iFSvdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828979; c=relaxed/simple;
	bh=ZMqy/CkSkVypEgFSFa0Z+9glSvdGSRRfib+1yvF/kiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I48ntoeCZwwxL8/vtMpmmoQQAmUGg5RaaWA6jOqS6qikmh4gypPreIHwzSIht9RDkThFb2j1t4mc7C7EVBIdth8Eiglz5sCScICLmRrYiShdc0mdSNpokSvKnKoRxn+CQB1SnT7ZE1069v9g2qUQfxUQfdHeW6puEuJffGsKUg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kua1nKMO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kua1nKMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A49B1F00893;
	Sun,  7 Jun 2026 10:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828978;
	bh=O6jMeNgqdL+Nm1s487mxMviiSQPF65w307WEdUE6U6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kua1nKMOiasmbivxYl4L4X83Mfz40wUui5E7kbVBnZigqkXHgQ+N9uKDuLS9vazqc
	 mM7DKLjPKXOL9JhsgoAv9linGwV8gLZwaUkw8i4v9oicDO1PNluLEI91XhP7Di0MyF
	 klbxaqAfNZd4B8hpVQxJ3W05ksp6cAqAAAVd1fvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 231/332] ASoC: qcom: q6asm-dai: close stream only when running
Date: Sun,  7 Jun 2026 12:00:00 +0200
Message-ID: <20260607095736.536337478@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit 048c540ee76ded666bda74f9dae1ca3254e0633c upstream.

q6asm_dai_close() and q6asm_dai_compr_free() currently issue CMD_CLOSE
whenever prtd->state is non-zero.

After prepare() closes an existing stream, the state is updated to
Q6ASM_STREAM_STOPPED. Since this state is also non-zero, the close and
free paths can send CMD_CLOSE again for a stream that has already been
closed.

Restrict CMD_CLOSE to the Q6ASM_STREAM_RUNNING state so the command is
sent only when the ASM stream is still active.

Fixes: 2a9e92d371db ("ASoC: qdsp6: q6asm: Add q6asm dai driver")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260518092347.3446946-3-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6asm-dai.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/sound/soc/qcom/qdsp6/q6asm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6asm-dai.c
@@ -465,12 +465,12 @@ static int q6asm_dai_close(struct snd_so
 	struct q6asm_dai_rtd *prtd = runtime->private_data;
 
 	if (prtd->audio_client) {
-		if (prtd->state)
+		if (prtd->state == Q6ASM_STREAM_RUNNING) {
 			q6asm_cmd(prtd->audio_client, prtd->stream_id,
 				  CMD_CLOSE);
-
-		q6asm_unmap_memory_regions(substream->stream,
+			q6asm_unmap_memory_regions(substream->stream,
 					   prtd->audio_client);
+		}
 		q6asm_audio_client_free(prtd->audio_client);
 		prtd->audio_client = NULL;
 	}
@@ -682,7 +682,7 @@ static int q6asm_dai_compr_free(struct s
 	struct snd_soc_pcm_runtime *rtd = stream->private_data;
 
 	if (prtd->audio_client) {
-		if (prtd->state) {
+		if (prtd->state == Q6ASM_STREAM_RUNNING) {
 			q6asm_cmd(prtd->audio_client, prtd->stream_id,
 				  CMD_CLOSE);
 			if (prtd->next_track_stream_id) {
@@ -690,11 +690,11 @@ static int q6asm_dai_compr_free(struct s
 					  prtd->next_track_stream_id,
 					  CMD_CLOSE);
 			}
-		}
 
-		snd_dma_free_pages(&prtd->dma_buffer);
-		q6asm_unmap_memory_regions(stream->direction,
+			q6asm_unmap_memory_regions(stream->direction,
 					   prtd->audio_client);
+		}
+		snd_dma_free_pages(&prtd->dma_buffer);
 		q6asm_audio_client_free(prtd->audio_client);
 		prtd->audio_client = NULL;
 	}


