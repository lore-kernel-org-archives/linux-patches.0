Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020070;
	b=awVbYBySAUW3FqAmxOev+XUvsy48m0gOJ354OmA/xT92wo2mCHAfhdMid3H/yuoBPEQu
	 q8oPDj27yuQ4eyrTEwMCEic09m5ijL2BhgxWLhbIzJnX/8tY3QZNgkz92hTPVuMJyT0WI
	 jOXSlbMRFaPDGnFXudnycRd9XW1LyG6d4+475cAIoWee9mZq5U35YgPdYinc0CA9f6dqR
	 B5R2JKg+wyIFp7+MD0ROp3LhfriDgJyd+1DzpgLwSZNQqK/GziWX+9eJbUqiBJCvF/dW6
	 8NebcGhVh6N6Aasj6ebLJ29Nrx3o3YC3P3Y4qWmtT+o8Q2wmVdWAmRQRHjFQBsKkpQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YZfy0IyxQVUv3txeQe9kzvzBFQF+Y+Wyj26HuQy8Ljw=;
	b=pY/BIJMMZ6dPknlBjnlOZj85EsuidNzUhKHLI3WAPQy4WQ+CURYPxX62dWUOa0c9HqDx
	 01TA5KqS9eHxTumIL6+glGep8vxoTFC56vX3atKyQhKIZqfN3nzDytFosjkLfdAAihI0a
	 QgxWQywesSal4Fe4lqPqwBovWHCuhMOPpj9Tb8WrM1t6ErMVJUF7NO2O0KNeP6wCs9uUJ
	 aTJ8v6TXrF013w1xcCqpAyoNPI/ufkW9KPbzCnqc2iNSMjO971PFej6y/rJIMIfVvMSZF
	 wNJISdYV6POztdLNGhPdaX/qO1pSAYe3HDdbtLBHUisIliLq29Iv2+J8+vSAz6YCvMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQz8cpLW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45C4606A320;
	Wed, 18 Nov 2026 16:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQz8cpLW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394C51F000C4;
	Wed, 18 Nov 2026 16:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020070;
	bh=YZfy0IyxQVUv3txeQe9kzvzBFQF+Y+Wyj26HuQy8Ljw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rQz8cpLWQke+3yQqeqwZX8Wu23/fK49ROxe0umPc70RZw2TsNiLIm15KnicqM9/hu
	 XpJuBoYeDmJ3Myg/nkhNBk/u0vqsDT9Zk2DCs2zUQfvRBm/aULNO+bfur2/RIB6IrC
	 SlTE0mq9msttWgA3VhS6R7KZanc1FYLgxo73muNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1820/2651] ALSA: pcm: Protect delay DMA sync in forward and rewind, too
Date: Wed, 18 Nov 2026 15:51:00 +0100
Message-ID: <20261118150352.706574221@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit d5096bb9beacb448091c1c9541432021dd5c1fcd ]

Like the previous fix for snd_pcm_delay() (in the commit 50f413b83b31
"ALSA: pcm: Protect delay DMA sync against concurrent HW_FREE"), the
snd_pcm_dma_buffer_sync() call in snd_pcm_forward() and
snd_pcm_rewind() needs the similar protection against the concurrent
hw_free action for avoiding potential UAFs.

Fixes: a25684a95646 ("ALSA: memalloc: Support for non-contiguous page allocation")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261013120528.52586-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_native.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index d2298bf6518a2..e36737ef53aed 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3072,11 +3072,15 @@ static snd_pcm_sframes_t rewind_appl_ptr(struct snd_pcm_substream *substream,
 static snd_pcm_sframes_t snd_pcm_rewind(struct snd_pcm_substream *substream,
 					snd_pcm_uframes_t frames)
 {
+	struct snd_pcm_runtime *runtime = substream->runtime;
 	snd_pcm_sframes_t ret;
 
 	if (frames == 0)
 		return 0;
 
+	/* Keep the DMA buffer alive through the sync below. */
+	if (!atomic_inc_unless_negative(&runtime->buffer_accessing))
+		return -EBUSY;
 	scoped_guard(pcm_stream_lock_irq, substream) {
 		ret = do_pcm_hwsync(substream);
 		if (!ret)
@@ -3085,17 +3089,22 @@ static snd_pcm_sframes_t snd_pcm_rewind(struct snd_pcm_substream *substream,
 	}
 	if (ret >= 0)
 		snd_pcm_dma_buffer_sync(substream, SNDRV_DMA_SYNC_DEVICE);
+	atomic_dec(&runtime->buffer_accessing);
 	return ret;
 }
 
 static snd_pcm_sframes_t snd_pcm_forward(struct snd_pcm_substream *substream,
 					 snd_pcm_uframes_t frames)
 {
+	struct snd_pcm_runtime *runtime = substream->runtime;
 	snd_pcm_sframes_t ret;
 
 	if (frames == 0)
 		return 0;
 
+	/* Keep the DMA buffer alive through the sync below. */
+	if (!atomic_inc_unless_negative(&runtime->buffer_accessing))
+		return -EBUSY;
 	scoped_guard(pcm_stream_lock_irq, substream) {
 		ret = do_pcm_hwsync(substream);
 		if (!ret)
@@ -3104,6 +3113,7 @@ static snd_pcm_sframes_t snd_pcm_forward(struct snd_pcm_substream *substream,
 	}
 	if (ret >= 0)
 		snd_pcm_dma_buffer_sync(substream, SNDRV_DMA_SYNC_DEVICE);
+	atomic_dec(&runtime->buffer_accessing);
 	return ret;
 }
 
-- 
2.53.0



