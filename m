Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031778;
	b=OWoZveNxS2vnDk4UaHlQecGYuaB+duqaLKAsBHLoxQw41VVY3O7qxRV0ljvWPNTCyLgJ
	 pnzxWExjWLyj19wG+UN/Cm9+wSnY9hTu66zw+l7kTdHxyLknlyn72DmRLwJS9qhdQ+O+A
	 1hLvNEqvbOvhc9T+lzRii686IlGCmp2+iBZ4xagb1hGvkjewFNSdlGcOd6WKd8WDem1Pa
	 QBp5roBDh4FHmX+Xbq3CVGQ3NLUuawQ0TAygu7hKY3ITzddm2Qh1BzSHGUCkI5UGwWU14
	 J+eZHUVR6B4Tq9CCgNCrWzCwZDWMqPb6QztGlw6sF4Mdo5bf7Tw3MPX/ay382kWpK3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pjOSeXuXe5XkxydwOwhorAU+6hnU+h8gNNoiDYpN2k8=;
	b=gnOOV0HXTLfmKg2Nd+4AEdpHyyH4jdtbnE8pLNyNJlyp3JR4VTm3CCTPKlLL30Ogc4Hx
	 UXcjE+rQCaBKcgttjYIGis5ICWFPxrw3bN5pnfdLD6JWcytLdAsrAJjrKYy8l6RnamuaE
	 OlIyCPJVPglCrok7L/wj8xU4ww+GugPGopP11MFnqpIcyAasjnlM6gaV46LZjpBOuDtDp
	 MzO/POoayTYrQ/AzCFjrUTNmgk5F+CpbRk1uXqWP15Ylsz/lxSgycN/wDE5cn6PYpjwe7
	 Ff3uOyk9dPxueo4hzbzvjkUrLereVaLRapg7uULVdX79PcWDPschI+jbQDrZyDlZBlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xLO0GAb3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECCD60A2626;
	Wed, 18 Nov 2026 19:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xLO0GAb3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE101F000C7;
	Wed, 18 Nov 2026 19:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031778;
	bh=pjOSeXuXe5XkxydwOwhorAU+6hnU+h8gNNoiDYpN2k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xLO0GAb3n2X4B+ZXQlDuajjvQUnrQnue6QdDOxNrHkQHXedB2GEcHVb/cIFpRdIpY
	 XHzj41or/RZCNRUYWMYcB41/LyWaXWTYb2IH00aPUonhDgTbWBQhEqkfPYRcz4u4gI
	 BcN6TxcXIftgXR+qahk/GF8dvPJMKipk89oI9w40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1177/1756] ALSA: pcm: Protect delay DMA sync in forward and rewind, too
Date: Wed, 18 Nov 2026 15:55:04 +0100
Message-ID: <20261118150056.797223714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4d0e3dd36c57f..55ce00a41ca53 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3037,11 +3037,15 @@ static snd_pcm_sframes_t rewind_appl_ptr(struct snd_pcm_substream *substream,
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
@@ -3050,17 +3054,22 @@ static snd_pcm_sframes_t snd_pcm_rewind(struct snd_pcm_substream *substream,
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
@@ -3069,6 +3078,7 @@ static snd_pcm_sframes_t snd_pcm_forward(struct snd_pcm_substream *substream,
 	}
 	if (ret >= 0)
 		snd_pcm_dma_buffer_sync(substream, SNDRV_DMA_SYNC_DEVICE);
+	atomic_dec(&runtime->buffer_accessing);
 	return ret;
 }
 
-- 
2.53.0



