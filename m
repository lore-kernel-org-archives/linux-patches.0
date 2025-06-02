Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677962153CB;
	Mon,  2 Jun 2025 14:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875022; cv=none; b=LO8+2O3I8ejuk2LNE70gHgSQd9NG8xOiUitsUGdnSsEfluEVxrIYM87irFa+BRHOLGVjqNnP08UXyPQdADGDplqr2CCjpkva4PA40m5eLvO2Mf3D0lKadGV0nBflAXmfp2gW+3eX/6OjVVTpxtZ08i8dOUbxm5HNwG27xqe0J28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875022; c=relaxed/simple;
	bh=RbBeM3mmrbCJJ2Rx5Dq2I8qgQgfDsr4wJjjEDoHvR4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uo158a09Dl0bPeYODy8stJ0ZuqHwuvA9/IX70WWcgfUPGUzvsp5ZxRFdq4TzZl266pI/cAAMZVIqHgEq6B9Tu+WwTP4EuieqjLa0aVjobDK6p3HtOcEhCGtfBcTpAdgkVZuUbtHlA09bcpePHqMdXh0+rIoiv4OwNwsKFXeJQ+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dpqa4z7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dpqa4z7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB9AC4CEEB;
	Mon,  2 Jun 2025 14:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875022;
	bh=RbBeM3mmrbCJJ2Rx5Dq2I8qgQgfDsr4wJjjEDoHvR4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dpqa4z7pT/KF7mVzXFqvYH8yoN1v2tPLp2DpvgMaOf/vn2HA4HJ/RIavq+GbSF6mo
	 rFgmMLIpTAWYN1/zUraYj7t4j7Sw3FFtdENiOm6mrz4UGTmHoAdpLFB2kFI+hW3jNz
	 gyn/ayyvqVAECiLcFOkirGPggJr294xCiGECk+3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+32d4647f551007595173@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 178/204] ALSA: pcm: Fix race of buffer access at PCM OSS layer
Date: Mon,  2 Jun 2025 15:48:31 +0200
Message-ID: <20250602134302.645736241@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1319,6 +1319,8 @@ int snd_pcm_lib_mmap_iomem(struct snd_pc
 #define snd_pcm_lib_mmap_iomem	NULL
 #endif
 
+void snd_pcm_runtime_buffer_set_silence(struct snd_pcm_runtime *runtime);
+
 /**
  * snd_pcm_limit_isa_dma_size - Get the max size fitting with ISA DMA transfer
  * @dma: DMA number
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -1081,8 +1081,7 @@ static int snd_pcm_oss_change_params_loc
 	runtime->oss.params = 0;
 	runtime->oss.prepare = 1;
 	runtime->oss.buffer_used = 0;
-	if (runtime->dma_area)
-		snd_pcm_format_set_silence(runtime->format, runtime->dma_area, bytes_to_samples(runtime, runtime->dma_bytes));
+	snd_pcm_runtime_buffer_set_silence(runtime);
 
 	runtime->oss.period_frames = snd_pcm_alsa_frames(substream, oss_period_size);
 
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -648,6 +648,17 @@ static void snd_pcm_buffer_access_unlock
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


