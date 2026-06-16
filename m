Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229A9331A44;
	Tue, 16 Jun 2026 18:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635622; cv=none; b=DnwtVnrUAZ1EXYpBA41Tvn4dTANx72JqUjZAsJaKJmEo/xjC9tPWOlDPlIXQSfK8ej+wgZXq+lx9C6Po/AHGdWGHl2lCjP3xfeZmQQsOc3TjPFD9qsoTzWitTdwhhcNjEun5EcJmcInUfJY3FEo7JegVvxUkwnVnqbcCX1B9Dts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635622; c=relaxed/simple;
	bh=/c3nbl+jVh9ZfPQQO7wKnOy6Ms7p8zETAGb6Kkoujzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyQbqaqKWpr+zGDdGVVf06X/StxDxwoAxrW8ar7q4CgfRGy45jdFi3IWUSbcs0jRkPjmxGuNOXYuoBUWImsZ8F7KvysoGMo08qK+AZdabXY7JqkXvYppjBZ1C7xFsIFyVcydnk0dezlBMP0k9QGNdOJxJSZTwFTKxdzqk5wDH2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QauhMeA4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QauhMeA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110121F000E9;
	Tue, 16 Jun 2026 18:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635621;
	bh=FtxT9X0KTuCgoqrkw6/WK2158HPZu4RIDUzvsYHRVDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QauhMeA4Ywbu23r6eqr+hyBqTdxs8VAbjrkYLz3312CA19LYSi6hfy9HbLngzFZT+
	 jIeO1uHMXQowQVFWCNGuJIfhuyOI0g7zlLHaT7x5/xO6JPIt9pd18y/lL1/7xRPX1Z
	 E01sfftarUIji1v3625sF71R4zB6xo2Gz5cEEcis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 082/342] ASoC: qcom: q6asm-dai: close stream only when running
Date: Tue, 16 Jun 2026 20:26:18 +0530
Message-ID: <20260616145052.063998276@linuxfoundation.org>
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
@@ -458,12 +458,12 @@ static int q6asm_dai_close(struct snd_so
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
@@ -692,7 +692,7 @@ static int q6asm_dai_compr_free(struct s
 	struct snd_soc_pcm_runtime *rtd = stream->private_data;
 
 	if (prtd->audio_client) {
-		if (prtd->state) {
+		if (prtd->state == Q6ASM_STREAM_RUNNING) {
 			q6asm_cmd(prtd->audio_client, prtd->stream_id,
 				  CMD_CLOSE);
 			if (prtd->next_track_stream_id) {
@@ -700,11 +700,11 @@ static int q6asm_dai_compr_free(struct s
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


