Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A7453365;
	Thu, 12 Dec 2024 17:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023140; cv=none; b=fMnyzPjpUb9B5/XVR5+X3nJoeG5l1j2Okv7hYDJq4NSqgWbo5NCKX8gLR6lMzj2qDtSWrrJPVvn+Re4e55nst1oHhTi3KbyByAxri2GikGiSRj28nFChJIW9gP7TybGDKDYwpmd1CZLr4uocKbNbQFrZtpsiQL4M7NfygD3OHkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023140; c=relaxed/simple;
	bh=9WAYaIZ64DDE4KMlRuu8wCLaGaRwltDcY7kRaXf4G7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYeoLF4ndiMWq0udEtkhcyHNpANPC7ZEovQXBGbLI1o0TUJJ2tCFwbhacNqUSR4h+rm61CnhniPY3YJjFWmRoIb4+XvSiT4Qr3JZVHsekW9H8IdH4FLPNifnEv4WqF57SNQe68BV6x603C9TPw4RKwy2SKSBt/zJiU5x96O2Veo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZaUSjJ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZaUSjJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FECC4CECE;
	Thu, 12 Dec 2024 17:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023139;
	bh=9WAYaIZ64DDE4KMlRuu8wCLaGaRwltDcY7kRaXf4G7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZaUSjJ1R8pbqNjVukGn2cWu4yHE3xjJqazMS3O4pmuSvnTzh6tcIq6NY+VTvojYB
	 X8DxYZBKNPLQoD4WFXbfJ2CWqk1/kLD4Ms0dW0iLUcstyTK72aVAUEzltTEk2tCV+d
	 uQtN7MFPceJU5Gw7yrP0MuOkhRGafc0BWqqSdpA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 436/565] ALSA: pcm: Add more disconnection checks at file ops
Date: Thu, 12 Dec 2024 16:00:31 +0100
Message-ID: <20241212144328.918963805@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 36df2427ac3ea04510368561c8cee22388a7434a ]

In the case of hot-disconnection of a PCM device, all file operations
except for close should be rejected.  This patch adds more sanity
checks in the file operation code paths.

Link: https://lore.kernel.org/r/20211006142214.3089-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 4f9d674377d0 ("ALSA: usb-audio: Notify xrun for low-latency mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_native.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 464b99b432d33..0193ac199c270 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3283,6 +3283,9 @@ static int snd_pcm_common_ioctl(struct file *file,
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 
+	if (substream->runtime->status->state == SNDRV_PCM_STATE_DISCONNECTED)
+		return -EBADFD;
+
 	res = snd_power_wait(substream->pcm->card);
 	if (res < 0)
 		return res;
@@ -3409,6 +3412,9 @@ int snd_pcm_kernel_ioctl(struct snd_pcm_substream *substream,
 	snd_pcm_uframes_t *frames = arg;
 	snd_pcm_sframes_t result;
 	
+	if (substream->runtime->status->state == SNDRV_PCM_STATE_DISCONNECTED)
+		return -EBADFD;
+
 	switch (cmd) {
 	case SNDRV_PCM_IOCTL_FORWARD:
 	{
@@ -3451,7 +3457,8 @@ static ssize_t snd_pcm_read(struct file *file, char __user *buf, size_t count,
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
-	if (runtime->status->state == SNDRV_PCM_STATE_OPEN)
+	if (runtime->status->state == SNDRV_PCM_STATE_OPEN ||
+	    runtime->status->state == SNDRV_PCM_STATE_DISCONNECTED)
 		return -EBADFD;
 	if (!frame_aligned(runtime, count))
 		return -EINVAL;
@@ -3475,7 +3482,8 @@ static ssize_t snd_pcm_write(struct file *file, const char __user *buf,
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
-	if (runtime->status->state == SNDRV_PCM_STATE_OPEN)
+	if (runtime->status->state == SNDRV_PCM_STATE_OPEN ||
+	    runtime->status->state == SNDRV_PCM_STATE_DISCONNECTED)
 		return -EBADFD;
 	if (!frame_aligned(runtime, count))
 		return -EINVAL;
@@ -3501,7 +3509,8 @@ static ssize_t snd_pcm_readv(struct kiocb *iocb, struct iov_iter *to)
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
-	if (runtime->status->state == SNDRV_PCM_STATE_OPEN)
+	if (runtime->status->state == SNDRV_PCM_STATE_OPEN ||
+	    runtime->status->state == SNDRV_PCM_STATE_DISCONNECTED)
 		return -EBADFD;
 	if (!iter_is_iovec(to))
 		return -EINVAL;
@@ -3537,7 +3546,8 @@ static ssize_t snd_pcm_writev(struct kiocb *iocb, struct iov_iter *from)
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
-	if (runtime->status->state == SNDRV_PCM_STATE_OPEN)
+	if (runtime->status->state == SNDRV_PCM_STATE_OPEN ||
+	    runtime->status->state == SNDRV_PCM_STATE_DISCONNECTED)
 		return -EBADFD;
 	if (!iter_is_iovec(from))
 		return -EINVAL;
@@ -3576,6 +3586,9 @@ static __poll_t snd_pcm_poll(struct file *file, poll_table *wait)
 		return ok | EPOLLERR;
 
 	runtime = substream->runtime;
+	if (runtime->status->state == SNDRV_PCM_STATE_DISCONNECTED)
+		return ok | EPOLLERR;
+
 	poll_wait(file, &runtime->sleep, wait);
 
 	mask = 0;
@@ -3887,6 +3900,8 @@ static int snd_pcm_mmap(struct file *file, struct vm_area_struct *area)
 	substream = pcm_file->substream;
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
+	if (substream->runtime->status->state == SNDRV_PCM_STATE_DISCONNECTED)
+		return -EBADFD;
 
 	offset = area->vm_pgoff << PAGE_SHIFT;
 	switch (offset) {
@@ -3923,6 +3938,8 @@ static int snd_pcm_fasync(int fd, struct file * file, int on)
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
+	if (runtime->status->state == SNDRV_PCM_STATE_DISCONNECTED)
+		return -EBADFD;
 	return fasync_helper(fd, file, on, &runtime->fasync);
 }
 
-- 
2.43.0



