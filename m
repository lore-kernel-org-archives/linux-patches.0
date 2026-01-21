Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0A13559ED;
	Wed, 21 Jan 2026 18:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020224; cv=none; b=s3fsCRE1BKfKesGa1jkRWXWmDWF+iQk5fAXifJ6dW1V+4tJZQGVnf6fBvtELxhmGmzNcDCddYnsbZug2nilR4AC2ZWfTJAtzhGZZGSTmwv8enIp0qV1a3ivV1DI53tDhn0WtpRA8K6blGkUX99ga/FPz6VIUz/C5arPCG8sZTcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020224; c=relaxed/simple;
	bh=1pt/3eUrs+q/RgiUwpDwijm6j8JsweuPVZhIG9Kel1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlOHbTiXpuMOyLvqhhRF1TeGYRgR3nSY7J3qwMVDCo5WE+1WPi5qZDi/a/DU6BlHPpSTCMoWZYsA8Aw/VxWh64tGSpbWTOqrG9MCcwOwuHK2g+6AlRm7vhrDm6AaSJEp1NxBn3/c9LH1eGC4I7cQ3Yiizrtp3GegO97PRq3RtCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1XM5TBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1XM5TBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED13C4CEF1;
	Wed, 21 Jan 2026 18:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020224;
	bh=1pt/3eUrs+q/RgiUwpDwijm6j8JsweuPVZhIG9Kel1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1XM5TBiG/96aj3FwGoGWWp0zZRrQCUxj69U4kq3DMmGAS9tCT7uOreksOLJFsVRR
	 rr8Psh/oOv04VefV20HkeI9Gd7hzU4uMmqgEmlfbJICKJtqblFPBpyHd9gmyy0HksX
	 wP+qUOKUMBf3dlf+k3V9bzf4Jg4Vb9OhoX7P6BAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 094/198] ALSA: pcm: Improve the fix for race of buffer access at PCM OSS layer
Date: Wed, 21 Jan 2026 19:15:22 +0100
Message-ID: <20260121181421.936797025@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaroslav Kysela <perex@perex.cz>

commit 47c27c9c9c720bc93fdc69605d0ecd9382e99047 upstream.

Handle the error code from snd_pcm_buffer_access_lock() in
snd_pcm_runtime_buffer_set_silence() function.

Found by Alexandros Panagiotou <apanagio@redhat.com>

Fixes: 93a81ca06577 ("ALSA: pcm: Fix race of buffer access at PCM OSS layer")
Cc: stable@vger.kernel.org # 6.15
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://patch.msgid.link/20260107213642.332954-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/sound/pcm.h      |    2 +-
 sound/core/oss/pcm_oss.c |    4 +++-
 sound/core/pcm_native.c  |    9 +++++++--
 3 files changed, 11 insertions(+), 4 deletions(-)

--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -1402,7 +1402,7 @@ int snd_pcm_lib_mmap_iomem(struct snd_pc
 #define snd_pcm_lib_mmap_iomem	NULL
 #endif
 
-void snd_pcm_runtime_buffer_set_silence(struct snd_pcm_runtime *runtime);
+int snd_pcm_runtime_buffer_set_silence(struct snd_pcm_runtime *runtime);
 
 /**
  * snd_pcm_limit_isa_dma_size - Get the max size fitting with ISA DMA transfer
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -1074,7 +1074,9 @@ static int snd_pcm_oss_change_params_loc
 	runtime->oss.params = 0;
 	runtime->oss.prepare = 1;
 	runtime->oss.buffer_used = 0;
-	snd_pcm_runtime_buffer_set_silence(runtime);
+	err = snd_pcm_runtime_buffer_set_silence(runtime);
+	if (err < 0)
+		goto failure;
 
 	runtime->oss.period_frames = snd_pcm_alsa_frames(substream, oss_period_size);
 
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -730,13 +730,18 @@ static void snd_pcm_buffer_access_unlock
 }
 
 /* fill the PCM buffer with the current silence format; called from pcm_oss.c */
-void snd_pcm_runtime_buffer_set_silence(struct snd_pcm_runtime *runtime)
+int snd_pcm_runtime_buffer_set_silence(struct snd_pcm_runtime *runtime)
 {
-	snd_pcm_buffer_access_lock(runtime);
+	int err;
+
+	err = snd_pcm_buffer_access_lock(runtime);
+	if (err < 0)
+		return err;
 	if (runtime->dma_area)
 		snd_pcm_format_set_silence(runtime->format, runtime->dma_area,
 					   bytes_to_samples(runtime, runtime->dma_bytes));
 	snd_pcm_buffer_access_unlock(runtime);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(snd_pcm_runtime_buffer_set_silence);
 


