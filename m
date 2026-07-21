Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486BE366DA5;
	Tue, 21 Jul 2026 15:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649296; cv=none; b=ZajxF6wTEcCcCAINSNtNp6igRoOcB14DTllmJIdpLC5TlkVJ3Tmxs55ud6GnLcNMmCI9n3Mt4uCJeiO8kgrWyOyL/WoNWcQVdGB/zyAGgVZRuBGeI7uJ3H/ocyxHze1dZt0rHcpPwzIKq/qcgU3lwpAAjOCcp0tiW4xgeVUE1HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649296; c=relaxed/simple;
	bh=azI0p1SunBYoROQgaDJ6Qi61Nc64QxnbPn02FCbdVq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JV3oWnUa03QJQ6P2ecLloetF2sGQF04bOl2sEfaJX5HeKbFZGys6551WA/I4ABrTm5PDF68rWRNEr9nWVFojjndWAZlCJ9fx2LzoV1eZL3Knt46UKIQwEubSwfkbs6vrQ/9TVWe348jVsMEbq37OsWWrFtBhuASLp6dyY0ji1ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGIPEvm5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGIPEvm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEF91F000E9;
	Tue, 21 Jul 2026 15:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649294;
	bh=gsZ8Wk6xP6emxp3bRLJdXZqlpOq6AVv+fgEE+khnWbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tGIPEvm58ou+IUBaoA6DpUj6z2UaVEwV+2MvRPtwcY3bhuyNU94U5xnT0WALaV0p0
	 Zeb2Jak1tcMfART8FSQhOY+B/brPovO2cIcXxRYugqZhGBrDsZASPOZTIcLGqaI57B
	 uAyN9g7Hcj/sgsZTfKoZIHi4q25s8XQWtVOpi+w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0524/2077] ALSA: pcm: Fix unlocked runtime state reads in xfer ioctls
Date: Tue, 21 Jul 2026 17:03:17 +0200
Message-ID: <20260721152605.168005104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 98fe3988a2efe89a1a1ded213a0561e6543e94e2 ]

The recent runtime state locking cleanup converted several PCM ioctl state
checks to snd_pcm_get_state(), including snd_pcm_pre_prepare(),
snd_pcm_drain() and snd_pcm_kernel_ioctl(). The native and compat xfer
ioctl paths still sample runtime->state directly before dispatching to the
PCM transfer helpers, and snd_pcm_common_ioctl() still samples the
DISCONNECTED state directly in its common precheck.

Use snd_pcm_get_state() for those ioctl-side prechecks as well. This keeps
the externally visible ioctl entry checks consistent with the stream-locked
state access used by the recent PCM state-read cleanup.

Fixes: 032322b44c02 ("ALSA: pcm: oss: use proper stream lock for runtime->state access")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260605-alsa-pcm-xfer-state-helper-v1-1-eba97cecf820@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_compat.c | 4 ++--
 sound/core/pcm_native.c | 7 +++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/sound/core/pcm_compat.c b/sound/core/pcm_compat.c
index 5313f50f17da5e..55ecf87586c4dd 100644
--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -293,7 +293,7 @@ static int snd_pcm_ioctl_xferi_compat(struct snd_pcm_substream *substream,
 		return -ENOTTY;
 	if (substream->stream != dir)
 		return -EINVAL;
-	if (substream->runtime->state == SNDRV_PCM_STATE_OPEN)
+	if (snd_pcm_get_state(substream) == SNDRV_PCM_STATE_OPEN)
 		return -EBADFD;
 
 	if (get_user(buf, &data32->buf) ||
@@ -338,7 +338,7 @@ static int snd_pcm_ioctl_xfern_compat(struct snd_pcm_substream *substream,
 		return -ENOTTY;
 	if (substream->stream != dir)
 		return -EINVAL;
-	if (substream->runtime->state == SNDRV_PCM_STATE_OPEN)
+	if (snd_pcm_get_state(substream) == SNDRV_PCM_STATE_OPEN)
 		return -EBADFD;
 
 	ch = substream->runtime->channels;
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 302643c1c1921e..aa334416968557 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3303,10 +3303,9 @@ static int snd_pcm_xferi_frames_ioctl(struct snd_pcm_substream *substream,
 				      struct snd_xferi __user *_xferi)
 {
 	struct snd_xferi xferi;
-	struct snd_pcm_runtime *runtime = substream->runtime;
 	snd_pcm_sframes_t result;
 
-	if (runtime->state == SNDRV_PCM_STATE_OPEN)
+	if (snd_pcm_get_state(substream) == SNDRV_PCM_STATE_OPEN)
 		return -EBADFD;
 	if (put_user(0, &_xferi->result))
 		return -EFAULT;
@@ -3329,7 +3328,7 @@ static int snd_pcm_xfern_frames_ioctl(struct snd_pcm_substream *substream,
 	void *bufs __free(kfree) = NULL;
 	snd_pcm_sframes_t result;
 
-	if (runtime->state == SNDRV_PCM_STATE_OPEN)
+	if (snd_pcm_get_state(substream) == SNDRV_PCM_STATE_OPEN)
 		return -EBADFD;
 	if (runtime->channels > 128)
 		return -EINVAL;
@@ -3392,7 +3391,7 @@ static int snd_pcm_common_ioctl(struct file *file,
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 
-	if (substream->runtime->state == SNDRV_PCM_STATE_DISCONNECTED)
+	if (snd_pcm_get_state(substream) == SNDRV_PCM_STATE_DISCONNECTED)
 		return -EBADFD;
 
 	res = snd_power_wait(substream->pcm->card);
-- 
2.53.0



