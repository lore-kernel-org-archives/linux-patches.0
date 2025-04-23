Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F179262FD6;
	Wed, 23 Apr 2025 15:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420575; cv=none; b=K32iaJoHOa20+obI+dNcZcy21gf70oB9gaF7R7yNojobvwgbAZjfSC1tIA1c1IgOOOqCY0FOn1xmwXidqyoSSnv3rMoH1nXzN39wK6ySD11wYr1ULbAj4KiZnVBp8Oc12gWKWI08gWmBxo2L+JJW6GExiYQLuf4R9hEw5EDXPms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420575; c=relaxed/simple;
	bh=b0zjW9f4aI8L9Q8dlUT2fZI66lGmxSaWQevPbrj5UAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3WFS/0sPj6Fz2bs0E3hKAzCIcGUUV/klqRWrVzY+B7qgRyUbqm1s5whjGfeO3nKBitdKs5m1TeQGOE72sn3aKug17i27dMcN4h1fNj3T3Vyc3WCMIsvZAFENsTrEVrgEYChfZ5L/7ISdl42vAhE0NIWKRq2ZCvAVu2NqFfk1PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFeOQLpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFeOQLpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37563C4CEE3;
	Wed, 23 Apr 2025 15:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420574;
	bh=b0zjW9f4aI8L9Q8dlUT2fZI66lGmxSaWQevPbrj5UAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFeOQLpPKMOZY/MLIWKmVg081BreWU098//3KukAs+ZghJQkXkli3biIQ5SsYseUa
	 RaWLCs8ntAJW2hEeTfWhw1EYW4KcMQYnnBUwWidqugt2ZSfPtw/UMFOXSfeO6EN2HT
	 Thc6JWN4vSneFinj1BSmvMaJW6VvU3Ux4/wgRaVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.14 104/241] ASoC: fsl: fsl_qmc_audio: Reset audio data pointers on TRIGGER_START event
Date: Wed, 23 Apr 2025 16:42:48 +0200
Message-ID: <20250423142624.819448899@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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


