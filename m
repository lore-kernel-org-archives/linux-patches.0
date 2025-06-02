Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819992288E3;
	Mon,  2 Jun 2025 14:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875790; cv=none; b=ADutc4DAdpkXCikQoUItYqb4ZPkumFlRBRu0UkUxz0zh89F0ueXprBqC2rPExUybWKyLQmY5bTDM2hgJKki24TDKeDNFgG1XGj3iE6bDFYpe8LhMxMMbOXRAl2G44uCpdihp1NXILiH8NmY2f1vrQ55oBfnmecNrdUTfH5Q26AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875790; c=relaxed/simple;
	bh=9xDnyjg4kS8N60atJtIHl/VZWSCbf8sTuttiopGaBjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XE0xWcT3eW8Bn0FSE8cvqp9rk4Eh9mU//xm/Nybs5RrpY88C7dMxgX4u1K7uFWybo/lJ1ETJoNvCfAe/2hO1GcZwrwD3nZmw0W4cbXGJ7HWwgcxuN3nHN+NISZJO0kGkx459sXQaK3Cyebq4bCgrqmzNJ9dqsEIoZu28DhsdPgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zn3ImAK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zn3ImAK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839ABC4CEEB;
	Mon,  2 Jun 2025 14:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875790;
	bh=9xDnyjg4kS8N60atJtIHl/VZWSCbf8sTuttiopGaBjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zn3ImAK7eD9g3mfhMYC6nbYzmwTVugQ0kq0bfsWd06t/T8u/1O/NZM18a0SoXj+8w
	 Xau8ka3W0+RVgQj0hrZGuk1JJThhxwFVlMa1dFDxDIoC5NtypkzDV8aSV84BvO4ELC
	 3/T0PxfVUS5zVqsS7Hcsidv4cVHs2m1jKFS7dPMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+32d4647f551007595173@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 244/270] ALSA: pcm: Fix race of buffer access at PCM OSS layer
Date: Mon,  2 Jun 2025 15:48:49 +0200
Message-ID: <20250602134317.305561094@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1334,6 +1334,8 @@ int snd_pcm_lib_mmap_iomem(struct snd_pc
 #define snd_pcm_lib_mmap_iomem	NULL
 #endif
 
+void snd_pcm_runtime_buffer_set_silence(struct snd_pcm_runtime *runtime);
+
 /**
  * snd_pcm_limit_isa_dma_size - Get the max size fitting with ISA DMA transfer
  * @dma: DMA number
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -1078,8 +1078,7 @@ static int snd_pcm_oss_change_params_loc
 	runtime->oss.params = 0;
 	runtime->oss.prepare = 1;
 	runtime->oss.buffer_used = 0;
-	if (runtime->dma_area)
-		snd_pcm_format_set_silence(runtime->format, runtime->dma_area, bytes_to_samples(runtime, runtime->dma_bytes));
+	snd_pcm_runtime_buffer_set_silence(runtime);
 
 	runtime->oss.period_frames = snd_pcm_alsa_frames(substream, oss_period_size);
 
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -685,6 +685,17 @@ static void snd_pcm_buffer_access_unlock
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


