Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B466119D066;
	Thu, 25 Jul 2024 14:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918435; cv=none; b=d3whNcN72umsZBZbrdWIIuu/pAp8Ghxywytkn7Ny4ZxFs3nBgSo/0KYDei0VmgH7olSMCS8J5d8+Hr8R8SbN8nKn+/lyujXlfEcJNlJQeEVCk+CXzBl/HehVA0+EBktGFMVVf5v1YigOfBJs29HKgUaehdgUBigTp5EEabkA3fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918435; c=relaxed/simple;
	bh=UwF8abf4tes/B8nQ9l0pChwkh8RJg2yvh73HQBdU70Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TST4Yv8NA0RRzo+3EOmp83kzFXdm3SdfHKcYecemjP81kqExkofS6tgc9HFTSWCI51C51ZuOqZlnHRbbYVYKP7uHaHKw9pIJhyXkvUhoLAgMIVdomzzPoHAECKEDO8Gltu+ZK0EoJZbHuVk+QNcWS0hdwZAn5O6Bra3LFECKW4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t31L7pAI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t31L7pAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA30FC116B1;
	Thu, 25 Jul 2024 14:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918435;
	bh=UwF8abf4tes/B8nQ9l0pChwkh8RJg2yvh73HQBdU70Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t31L7pAIT1r7dcAQFThy96taNTc2LCY3SFpWqCoU6UHERwTttc+LAfBI9Uo3qo0xx
	 rMApqIVow5S8oCzAvviV5rwO/8QoM/WE4ra8DL1V3Jx2aUOWXi3H2dTN06UABmzh2o
	 himn1iUi0Y6OksLtkEtXjYjbFb0IMguFXSpjC0EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/33] ALSA: dmaengine_pcm: terminate dmaengine before synchronize
Date: Thu, 25 Jul 2024 16:36:42 +0200
Message-ID: <20240725142729.242790873@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 6a7db25aad8ce6512b366d2ce1d0e60bac00a09d ]

When dmaengine supports pause function, in suspend state,
dmaengine_pause() is called instead of dmaengine_terminate_async(),

In end of playback stream, the runtime->state will go to
SNDRV_PCM_STATE_DRAINING, if system suspend & resume happen
at this time, application will not resume playback stream, the
stream will be closed directly, the dmaengine_terminate_async()
will not be called before the dmaengine_synchronize(), which
violates the call sequence for dmaengine_synchronize().

This behavior also happens for capture streams, but there is no
SNDRV_PCM_STATE_DRAINING state for capture. So use
dmaengine_tx_status() to check the DMA status if the status is
DMA_PAUSED, then call dmaengine_terminate_async() to terminate
dmaengine before dmaengine_synchronize().

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/1718851218-27803-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_dmaengine.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/core/pcm_dmaengine.c b/sound/core/pcm_dmaengine.c
index 6f6da1128edc2..80188d5c11187 100644
--- a/sound/core/pcm_dmaengine.c
+++ b/sound/core/pcm_dmaengine.c
@@ -354,6 +354,12 @@ EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_open_request_chan);
 int snd_dmaengine_pcm_close(struct snd_pcm_substream *substream)
 {
 	struct dmaengine_pcm_runtime_data *prtd = substream_to_prtd(substream);
+	struct dma_tx_state state;
+	enum dma_status status;
+
+	status = dmaengine_tx_status(prtd->dma_chan, prtd->cookie, &state);
+	if (status == DMA_PAUSED)
+		dmaengine_terminate_async(prtd->dma_chan);
 
 	dmaengine_synchronize(prtd->dma_chan);
 	kfree(prtd);
@@ -371,6 +377,12 @@ EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_close);
 int snd_dmaengine_pcm_close_release_chan(struct snd_pcm_substream *substream)
 {
 	struct dmaengine_pcm_runtime_data *prtd = substream_to_prtd(substream);
+	struct dma_tx_state state;
+	enum dma_status status;
+
+	status = dmaengine_tx_status(prtd->dma_chan, prtd->cookie, &state);
+	if (status == DMA_PAUSED)
+		dmaengine_terminate_async(prtd->dma_chan);
 
 	dmaengine_synchronize(prtd->dma_chan);
 	dma_release_channel(prtd->dma_chan);
-- 
2.43.0



