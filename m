Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855E7155351;
	Tue, 23 Jul 2024 18:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759680; cv=none; b=gDfzB1aqQJ+SqQJLmFpOT+J50iCUPOOuG3tWBL+hAoLvIf35JyfFNssDcuC+JKmfdQsOuCce2grdFf7KjYr32DLs5NFggOtRgYi7uXVi0smtBXWpUpHk+2fWOUhjvd8IPGVmha7ObOTOGylZUAoUQrMPk0tFTG1cNwBer8LCtfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759680; c=relaxed/simple;
	bh=Gmo9vaGQGcymIBeD+oFghrpKbQXizMwmEJcMfzwFgZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqAkRz4jL5ga5Ogzl+Z2+SLwBN6mpltbRNEnHEAl3iMHIyjM9PJGnYA4cN5u9dXOPdojMYhYRW2J7jdulQGL7YOYr/gSEi3gDkIRMFJi/nUgrgJZG51DoiJ+RIB3s0rh7Knx83vYgPeolzRqCsy0DKa+WGdMtHoV1AznEAN6UA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7iX+CHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7iX+CHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37F4C4AF09;
	Tue, 23 Jul 2024 18:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759680;
	bh=Gmo9vaGQGcymIBeD+oFghrpKbQXizMwmEJcMfzwFgZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7iX+CHSl9neMdT0JwPcpwrdnd4lxtOALgxX1l5dWkEV+bMg5Ch/LIueoaf7/ftqS
	 k58wswadahidky6m2rOm1ohd0BTDditj8APlumPr7Ocd15+aHIrPcLiW3J7kx1EY3w
	 ZZbVfhTjhpXGgrFZsIoYPTAOHz6mzH79camwtt9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/129] ALSA: dmaengine_pcm: terminate dmaengine before synchronize
Date: Tue, 23 Jul 2024 20:23:58 +0200
Message-ID: <20240723180408.263226673@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d142609570347..e299e8634751f 100644
--- a/sound/core/pcm_dmaengine.c
+++ b/sound/core/pcm_dmaengine.c
@@ -368,6 +368,12 @@ EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_sync_stop);
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
@@ -388,6 +394,12 @@ EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_close);
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



