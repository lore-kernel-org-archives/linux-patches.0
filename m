Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012CE22CBF4;
	Mon,  2 Jun 2025 15:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876439; cv=none; b=c6IQvb181bRmSyJ9mfuh2sFtGbyyRVofcI2QKem01Nx3rniZ4McMzHIsVjx8yZU68FFJq+GHFEIT3SavOABtSRGUEU/Ckna8qPGsbUPxfYNDbesNrLqH2vs44UXX4XtgU1Iamhl2ahMbm0k8up6WADa5+IhYYsgijxIBBeqE0QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876439; c=relaxed/simple;
	bh=uCNu65uhj925jorTD8EIaVuGIqVjg0m6mDra+baDkZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcXuQUDBN0uHB66LIcMOQHD3ZdXnhKok/H/1oQgDM8FongDYycD/Cn6KNbmxGqcoQ9vpB0L9gqxOi4QDtdUcIgSmTnEXKvTnI5PwFQp92bg9jItnKcGuNKIh8YPjuomyUFs5ffsZx/DVOjeGmVP8XGPhJ++bbtZSuRor31YkLNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzbG5yCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzbG5yCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DD3C4CEEB;
	Mon,  2 Jun 2025 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876438;
	bh=uCNu65uhj925jorTD8EIaVuGIqVjg0m6mDra+baDkZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzbG5yCvGrIBroIDPJdDIcF0iyAuLBYAFx2xlC5WMT7gGxPd/xCdLsJf3HwAh53Ed
	 MuTG3h0jyMfkxpH3SxKXU1aSEIHG42X2qayCfVAY8fqc95e/nNiN6ldYci9sSoQ4Ig
	 A4i9+9VPmP2dWsCsis8DoMi+lyMBdgmWw4HUW4r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+32d4647f551007595173@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 174/207] ALSA: pcm: Fix race of buffer access at PCM OSS layer
Date: Mon,  2 Jun 2025 15:49:06 +0200
Message-ID: <20250602134305.563585940@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 93a81ca0657758b607c3f4ba889ae806be9beb73 upstream.

The PCM OSS layer tries to clear the buffer with the silence data at
initialization (or reconfiguration) of a stream with the explicit call
of snd_pcm_format_set_silence() with runtime->dma_area.  But this may
lead to a UAF because the accessed runtime->dma_area might be freed
concurrently, as it's performed outside the PCM ops.

For avoiding it, move the code into the PCM core and perform it inside
the buffer access lock, so that it won't be changed during the
operation.

Reported-by: syzbot+32d4647f551007595173@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/68164d8e.050a0220.11da1b.0019.GAE@google.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250516080817.20068-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/sound/pcm.h      |    2 ++
 sound/core/oss/pcm_oss.c |    3 +--
 sound/core/pcm_native.c  |   11 +++++++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -1384,6 +1384,8 @@ int snd_pcm_lib_mmap_iomem(struct snd_pc
 #define snd_pcm_lib_mmap_iomem	NULL
 #endif
 
+void snd_pcm_runtime_buffer_set_silence(struct snd_pcm_runtime *runtime);
+
 /**
  * snd_pcm_limit_isa_dma_size - Get the max size fitting with ISA DMA transfer
  * @dma: DMA number
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -1079,8 +1079,7 @@ static int snd_pcm_oss_change_params_loc
 	runtime->oss.params = 0;
 	runtime->oss.prepare = 1;
 	runtime->oss.buffer_used = 0;
-	if (runtime->dma_area)
-		snd_pcm_format_set_silence(runtime->format, runtime->dma_area, bytes_to_samples(runtime, runtime->dma_bytes));
+	snd_pcm_runtime_buffer_set_silence(runtime);
 
 	runtime->oss.period_frames = snd_pcm_alsa_frames(substream, oss_period_size);
 
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -703,6 +703,17 @@ static void snd_pcm_buffer_access_unlock
 	atomic_inc(&runtime->buffer_accessing);
 }
 
+/* fill the PCM buffer with the current silence format; called from pcm_oss.c */
+void snd_pcm_runtime_buffer_set_silence(struct snd_pcm_runtime *runtime)
+{
+	snd_pcm_buffer_access_lock(runtime);
+	if (runtime->dma_area)
+		snd_pcm_format_set_silence(runtime->format, runtime->dma_area,
+					   bytes_to_samples(runtime, runtime->dma_bytes));
+	snd_pcm_buffer_access_unlock(runtime);
+}
+EXPORT_SYMBOL_GPL(snd_pcm_runtime_buffer_set_silence);
+
 #if IS_ENABLED(CONFIG_SND_PCM_OSS)
 #define is_oss_stream(substream)	((substream)->oss.oss)
 #else


