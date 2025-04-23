Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2144143736;
	Wed, 23 Apr 2025 14:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420087; cv=none; b=jRPXVrhJSlN+9pANtG3oNaOP/D6MsMkcwT+luhYsTu90mwBhSeo2iDvt971P8si28miNeTv3tgfrMeeBqIfU747x3UI/tz2O8/G5rUXxp+0ovlGE+pb5ncKqkHzdLXoWaipnF5PvxQ6tgarsI9y5Z0Pr0Fvbu0Uxbh+Rk6NfdYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420087; c=relaxed/simple;
	bh=1UvG2ag6AOsyNvYKPfCsllubRLx4GLS/LBRdq6ofh9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPCCCWya214P8GpTuBlQ7z/YS0pShbxyfAqny5TsSa/mfmkn9ziUzwfPT9DVF7q6rigctC5jEccBWkdqAAqQRxbEjNXy8okQWRStTy/9HJNuN+fxMlYWw+b/tgm5KTGId++UEpljk+8V770C+p3Q+I/pEOFCt1r3/YENzwVoOzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICRNup3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICRNup3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDBDC4CEE2;
	Wed, 23 Apr 2025 14:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420086;
	bh=1UvG2ag6AOsyNvYKPfCsllubRLx4GLS/LBRdq6ofh9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICRNup3kU5h2MQGaav0OBc+1RSNQAtoV9oK/qcJYGoXkJNlc7r2ttQpO37aUU4BVR
	 Hoayw/Mh2BiLeYxzae21FeGimF9sMOaz0oa7/9rbKbkWZne2LWG18CBVywRyUnSfjA
	 J+JsqFtHKYKpUxHn8IRdaBp4ZZsivczaXIW0TyUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 089/223] ASoC: fsl: fsl_qmc_audio: Reset audio data pointers on TRIGGER_START event
Date: Wed, 23 Apr 2025 16:42:41 +0200
Message-ID: <20250423142620.747740060@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit 9aa33d5b4a53a1945dd2aee45c09282248d3c98b upstream.

On SNDRV_PCM_TRIGGER_START event, audio data pointers are not reset.

This leads to wrong data buffer usage when multiple TRIGGER_START are
received and ends to incorrect buffer usage between the user-space and
the driver. Indeed, the driver can read data that are not already set by
the user-space or the user-space and the driver are writing and reading
the same area.

Fix that resetting data pointers on each SNDRV_PCM_TRIGGER_START events.

Fixes: 075c7125b11c ("ASoC: fsl: Add support for QMC audio")
Cc: stable@vger.kernel.org
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Link: https://patch.msgid.link/20250410091643.535627-1-herve.codina@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_qmc_audio.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/soc/fsl/fsl_qmc_audio.c
+++ b/sound/soc/fsl/fsl_qmc_audio.c
@@ -250,6 +250,9 @@ static int qmc_audio_pcm_trigger(struct
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 		bitmap_zero(prtd->chans_pending, 64);
+		prtd->buffer_ended = 0;
+		prtd->ch_dma_addr_current = prtd->ch_dma_addr_start;
+
 		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 			for (i = 0; i < prtd->channels; i++)
 				prtd->qmc_dai->chans[i].prtd_tx = prtd;


