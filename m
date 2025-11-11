Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6F91D6DB5;
	Tue, 11 Nov 2025 00:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822119; cv=none; b=dWuh1ocYGM9WKqvCPozHMaw6wVBrD5penkwhBicsHb2gM9QXPirkWWESJJDqKYCmBvJuoCzKza5FiR3KKDoOK7M4ny93A9ocPQEMPbG3QRifaN3Var5gz6hC4xEKk1H9wbGzgMq6e+JSgfmdv3I5PHN8kJzIKmOcGJuSRCR9fW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822119; c=relaxed/simple;
	bh=YL4F4f5wWut2mc1/7KCmQ8WT+1t0w9VESCVv/Gkp/mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rttT91sWsl+X3X4pJ1pmk6pOwcEXny7xfqeeP9lfweRMTPInrJ0JIm2GkzlVu6AFI3qDN4OOvHuMcnP3gizVwofZOQd8uPMuTTL02vpFP6KKgGAli5TkYhAhndAdZLU+9npjyGWPScTY1fStiOEyCQU224KibbSB7/tCoE9+9UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rzvq7qQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rzvq7qQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C261C4CEFB;
	Tue, 11 Nov 2025 00:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822119;
	bh=YL4F4f5wWut2mc1/7KCmQ8WT+1t0w9VESCVv/Gkp/mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rzvq7qQyBuYXAW89ePAxk8HeNm4UxLhU634FYfXs3Sv3yTcM7oi2OIknbOHGwp1WX
	 l2bgVSxMKcBaWOAbrJQV2ZyrfGxIX6xpA+lNoJQXoLHw/iTWXRZc5Z1cciyQmAy/Cq
	 0FgH8j0ScchiYUws50L+SEOnHIPRu4qoAnGXnkKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.17 023/849] ASoC: renesas: rz-ssi: Use proper dma_buffer_pos after resume
Date: Tue, 11 Nov 2025 09:33:13 +0900
Message-ID: <20251111004537.013205801@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 22897e568646de5907d4981eae6cc895be2978d1 upstream.

When the driver supports DMA, it enqueues four DMA descriptors per
substream before the substream is started. New descriptors are enqueued in
the DMA completion callback, and each time a new descriptor is queued, the
dma_buffer_pos is incremented.

During suspend, the DMA transactions are terminated. There might be cases
where the four extra enqueued DMA descriptors are not completed and are
instead canceled on suspend. However, the cancel operation does not take
into account that the dma_buffer_pos was already incremented.

Previously, the suspend code reinitialized dma_buffer_pos to zero, but this
is not always correct.

To avoid losing any audio periods during suspend/resume and to prevent
clip sound, save the completed DMA buffer position in the DMA callback and
reinitialize dma_buffer_pos on resume.

Cc: stable@vger.kernel.org
Fixes: 1fc778f7c833a ("ASoC: renesas: rz-ssi: Add suspend to RAM support")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://patch.msgid.link/20251029141134.2556926-3-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/renesas/rz-ssi.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/sound/soc/renesas/rz-ssi.c
+++ b/sound/soc/renesas/rz-ssi.c
@@ -85,6 +85,7 @@ struct rz_ssi_stream {
 	struct snd_pcm_substream *substream;
 	int fifo_sample_size;	/* sample capacity of SSI FIFO */
 	int dma_buffer_pos;	/* The address for the next DMA descriptor */
+	int completed_dma_buf_pos; /* The address of the last completed DMA descriptor. */
 	int period_counter;	/* for keeping track of periods transferred */
 	int sample_width;
 	int buffer_pos;		/* current frame position in the buffer */
@@ -221,6 +222,7 @@ static void rz_ssi_stream_init(struct rz
 	rz_ssi_set_substream(strm, substream);
 	strm->sample_width = samples_to_bytes(runtime, 1);
 	strm->dma_buffer_pos = 0;
+	strm->completed_dma_buf_pos = 0;
 	strm->period_counter = 0;
 	strm->buffer_pos = 0;
 
@@ -443,6 +445,10 @@ static void rz_ssi_pointer_update(struct
 		snd_pcm_period_elapsed(strm->substream);
 		strm->period_counter = current_period;
 	}
+
+	strm->completed_dma_buf_pos += runtime->period_size;
+	if (strm->completed_dma_buf_pos >= runtime->buffer_size)
+		strm->completed_dma_buf_pos = 0;
 }
 
 static int rz_ssi_pio_recv(struct rz_ssi_priv *ssi, struct rz_ssi_stream *strm)
@@ -784,10 +790,14 @@ no_dma:
 	return -ENODEV;
 }
 
-static int rz_ssi_trigger_resume(struct rz_ssi_priv *ssi)
+static int rz_ssi_trigger_resume(struct rz_ssi_priv *ssi, struct rz_ssi_stream *strm)
 {
+	struct snd_pcm_substream *substream = strm->substream;
+	struct snd_pcm_runtime *runtime = substream->runtime;
 	int ret;
 
+	strm->dma_buffer_pos = strm->completed_dma_buf_pos + runtime->period_size;
+
 	if (rz_ssi_is_stream_running(&ssi->playback) ||
 	    rz_ssi_is_stream_running(&ssi->capture))
 		return 0;
@@ -800,16 +810,6 @@ static int rz_ssi_trigger_resume(struct
 				ssi->hw_params_cache.channels);
 }
 
-static void rz_ssi_streams_suspend(struct rz_ssi_priv *ssi)
-{
-	if (rz_ssi_is_stream_running(&ssi->playback) ||
-	    rz_ssi_is_stream_running(&ssi->capture))
-		return;
-
-	ssi->playback.dma_buffer_pos = 0;
-	ssi->capture.dma_buffer_pos = 0;
-}
-
 static int rz_ssi_dai_trigger(struct snd_pcm_substream *substream, int cmd,
 			      struct snd_soc_dai *dai)
 {
@@ -819,7 +819,7 @@ static int rz_ssi_dai_trigger(struct snd
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_RESUME:
-		ret = rz_ssi_trigger_resume(ssi);
+		ret = rz_ssi_trigger_resume(ssi, strm);
 		if (ret)
 			return ret;
 
@@ -858,7 +858,6 @@ static int rz_ssi_dai_trigger(struct snd
 
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 		rz_ssi_stop(ssi, strm);
-		rz_ssi_streams_suspend(ssi);
 		break;
 
 	case SNDRV_PCM_TRIGGER_STOP:


