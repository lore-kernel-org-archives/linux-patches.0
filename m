Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC7F3A35BE;
	Wed, 21 Jan 2026 18:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019755; cv=none; b=rWfAztp+X28F3f77jQJsG9UN5FhpyjBINOwrJB7uh6CvSXk0CefyhJwfMRY78DDnaG7F5ILBNgMnczG2XLFA8JBuTatZ83f5HxjyB6wyMpRMnP1q4WDvijvWK9wwYjzy6SJnFdjnbp5iVQjewutnVJx78kz/6vGTbuQGovi2lmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019755; c=relaxed/simple;
	bh=oPIeztBM9RJzXfAFDMuYQGL9d/5OxGLLZc0iQWUsZJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkYxUacqqfRH5qn5oMjTZs7vdIny7tRsyitj1wqcvythUOuQh8HsYjGy2P/AZko5ljBFd6WL6sOzDvPGpP6EwudfEazDJHwTZVJIyVj8doD5GmQbZewy3eeaa/drBdNudfRiKIOZ0/mdCfyTtgAe21wAHnlHZrfW4bf5dPRdjdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=symTalOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="symTalOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CEAC4CEF1;
	Wed, 21 Jan 2026 18:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019754;
	bh=oPIeztBM9RJzXfAFDMuYQGL9d/5OxGLLZc0iQWUsZJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=symTalOlmbCXPZbtU4vsMC8Nva5cF+MO+gCFosRGoWckaY2hDOfd+CWdSV8AVyq8S
	 nQIxMzOb5G6FjgneUgYoquvuUG9yPu5lgCTfWfbu5pZuGAygLftUhLweSRTt3BFD6T
	 45oTg6cZ5IDyNdTz/gJi73qLbrVViGMKxpVlpZIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 065/139] ALSA: pcm: Improve the fix for race of buffer access at PCM OSS layer
Date: Wed, 21 Jan 2026 19:15:13 +0100
Message-ID: <20260121181413.792765940@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1428,7 +1428,7 @@ int snd_pcm_lib_mmap_iomem(struct snd_pc
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
 


