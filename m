Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026563;
	b=J/sgN3fkic+A47GHFN0avVXYaVJq+roAKyqE2+Bjvu4JlUEp6jHdAOtRIGENzJOLXSVG
	 90d4hL2z0pQepy/l9OwyNPRBOLMXrGRky2i2KWo7uOI6qqavMthQ89rXNCOsF21c0wxOV
	 HIzIzhgfd6M15CIj6mGZ9Gf/7B3zJAlhjn7yPfwoC+uext8W5ElHh4QzMPWwTTiMnX7o3
	 PQIqKugdmClrDoqJjOFet8dmKx02MXek6gkCJb3AphDzCZR7edUOeGFPjDQCTcHvalFIS
	 EZSBp1nJD/ZK3GzAE7HOEd2m2IbyOo3CFlhva9m6mxdFWb7j+5yp+ihngRYLLHiiNcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dGT+P9LHRwfCWJr3leKa17RPe/fmQiKoht9jz+Jz0gc=;
	b=lfFx+zaCqx+KnHNaHAwd3LQLF9F2UXsp+WfA/QweiSEUbHqo3GxbedQFaIG8DQ2wvhh0
	 6gOOaszXc48TWot8IMuKhznhbu4XEiGPsBvqSApbA2v/OCNvODW2dc5GLw2ZcbCg8UJCo
	 iKpVQRMS4wHNBiEC+ib6isf3VCEq12PIhfCpR5c1kr7uwFQXIh6ygUI/MWtfBZjJb1avN
	 dqVMgl6u+j8L+4tARW+NmMBgdZ2ZfzVGmAISpkCm1qfXcWOi02uTbonZYjCgk5yFgKtMq
	 V2cCrPL9kUvSiJ0l+VY8TSv+lqLfldK5Ovc6qdDgh55wxaYyDSiSlDtXywfWHfxYyEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gKNO6ohH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089FB606A31C;
	Wed, 18 Nov 2026 18:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gKNO6ohH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF781F000C4;
	Wed, 18 Nov 2026 18:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026562;
	bh=dGT+P9LHRwfCWJr3leKa17RPe/fmQiKoht9jz+Jz0gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gKNO6ohHuiYmgwUurIrGrsHTKxmBkR7M1h2nMvCKfTML2tzLRfeIwCkV+SV+JBG+I
	 vG/HHJnFlH9sMqfT6bOW+dh82auMyRenv39mtV+FV1tuUnuTI8FnE8YyGsNWte5eQM
	 70mIc5CYLDBXIrC98l2GdRFQz0EH068c5B90sxvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1481/2151] ALSA: pcm: Protect delay DMA sync in forward and rewind, too
Date: Wed, 18 Nov 2026 15:53:36 +0100
Message-ID: <20261118150215.835787076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7797efb2c8976..2c038cdda6873 100644
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



