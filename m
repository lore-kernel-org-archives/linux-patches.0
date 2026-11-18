Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054377;
	b=d3XxUlD6oY5BpHUPfjRCoMoZk3o+EkpDvSpUwEuoZZt6sAyqpuy/q/fzDx6TX61SpX2g
	 C299oITXI5fR5NMIUmMw0457ht4lfUgEo4PGm+38OcUAvYwVCFxEwpgbLe7nJKrYdB0ST
	 FLHJa+a5Q7k2e8/E8j12rOumse6GkiApArbNdBdkJ+cTU+0aBWC2QAw3FWSUJDIcYHPM+
	 6UV7tGoao0mqbWxestbugt3LAryBpOV+c1m0PglqOI9BjNWDdlP1H3LYVgA3w7+pUrx2r
	 eWpZprNKgELQ4/B4g7eJxSzI3Ze5upGy2WBiNgfbIvSYnyRmzitmrL+Qko5MEww1pVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p/J+smghPuJVOXB8bZQE21beVQ6wIQ1OyJovfA9TC64=;
	b=reTzVFhEGQNACik3jaLaIIi51cdwE43Y9Z4BbS3MpuqBljWxnrGLwvJQ22BxJJd1+JD9
	 C6sqCZnuLME+hbFa7squJabV9sTslNUsy6plvfM2WeZZOctgcg6Y7buBYXI/7ox/daib3
	 6l4i6K+mx5he3mlsb3abVIBlZnqatmDF28OZ0MsLaHTz+2EODenPHDN9xcfHFLhOEz/kd
	 RdWAZ9oxc+HZJTuMaZt3tI/hLIrCnrtcVr/sqey9Lq6IkuF6/sbA4oBtzZ19KlGP0CAVV
	 iQwB2yxsEC/poEQblf/HBfPGW8sy730E+wYeMUfaeApAxB0qWbxvNbKLVjZEo8uxAFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vG8TsVvc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FF2606A320;
	Thu, 19 Nov 2026 02:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vG8TsVvc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDF01F000C8;
	Thu, 19 Nov 2026 02:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054376;
	bh=p/J+smghPuJVOXB8bZQE21beVQ6wIQ1OyJovfA9TC64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vG8TsVvc7fHmE3xFvwth9g3oLyNUqFIIcZYXVHk7kB/hlpWyoypufGpZ6cY93a4Wh
	 HTDRejshhxcxbz41v9H9pNPwAx6KN/u+psdwMa+Sapvpw9DMgv8CTNDgWE9bVUpcZV
	 TxtuNdRBAoxevCAVHy+DHavVdI+IK6K+8FcLtbCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1245/2214] ALSA: pcm: Optimize cpu_latency_qos_*() calls
Date: Wed, 18 Nov 2026 15:48:41 +0100
Message-ID: <20261118150101.515089802@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9f6f4e97fd53908aecb0979507d9ff10a22288eb ]

We have a few cpu_latency_qos_*() calls in PCM callbacks, but they
seem suboptimal in a few aspects:
- We call them at each time when the hw_params changed, but explicitly
  do remove and (re-)add; this could be
  cpu_latency_qos_update_request(), instead
- The setup of cpu_latency_qos_*() doesn't have to be in hw_params at
  all; it's not the place where the actual parameters are set up, but
  rather better at the prepare callback.
- The hw_free calls cpu_latency_qos_remove_request() unconditionally,
  which may be poking a WARNING when it wasn't queued.

For addressing the issues above, this patch cleans up and reorganize
the cpu_latency_qos_*() calls in the PCM core by a couple helper
functions.  Now, they are set up at prepare callback, and cleared at
hw_free and release callbacks via the new helpers.

Link: https://patch.msgid.link/20261002150420.879056-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 9017bc3d13da ("ALSA: pcm: Prevent O_APPEND open on OSS streams")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_native.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index e085d061daaa4..e861404d393b6 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -726,11 +726,32 @@ EXPORT_SYMBOL_GPL(snd_pcm_runtime_buffer_set_silence);
 #define is_oss_stream(substream)	false
 #endif
 
+static void pcm_qos_req_clear(struct snd_pcm_substream *substream)
+{
+	if (cpu_latency_qos_request_active(&substream->latency_pm_qos_req))
+		cpu_latency_qos_remove_request(&substream->latency_pm_qos_req);
+}
+
+static void pcm_qos_req_update(struct snd_pcm_substream *substream, int usecs)
+{
+	if (usecs < 0) {
+		pcm_qos_req_clear(substream);
+		return;
+	}
+
+	if (cpu_latency_qos_request_active(&substream->latency_pm_qos_req))
+		cpu_latency_qos_update_request(&substream->latency_pm_qos_req,
+					       usecs);
+	else
+		cpu_latency_qos_add_request(&substream->latency_pm_qos_req,
+					    usecs);
+}
+
 static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 			     struct snd_pcm_hw_params *params)
 {
 	struct snd_pcm_runtime *runtime;
-	int err, usecs;
+	int err;
 	unsigned int bits;
 	snd_pcm_uframes_t frames;
 
@@ -837,12 +858,6 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 	snd_pcm_timer_resolution_change(substream);
 	snd_pcm_set_state(substream, SNDRV_PCM_STATE_SETUP);
 
-	if (cpu_latency_qos_request_active(&substream->latency_pm_qos_req))
-		cpu_latency_qos_remove_request(&substream->latency_pm_qos_req);
-	usecs = period_to_usecs(runtime);
-	if (usecs >= 0)
-		cpu_latency_qos_add_request(&substream->latency_pm_qos_req,
-					    usecs);
 	err = 0;
  _error:
 	if (err) {
@@ -921,7 +936,7 @@ static int snd_pcm_hw_free(struct snd_pcm_substream *substream)
 		goto unlock;
 	result = do_hw_free(substream);
 	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
-	cpu_latency_qos_remove_request(&substream->latency_pm_qos_req);
+	pcm_qos_req_clear(substream);
  unlock:
 	snd_pcm_buffer_access_unlock(runtime);
 	return result;
@@ -1972,6 +1987,7 @@ static int snd_pcm_do_prepare(struct snd_pcm_substream *substream,
 	err = substream->ops->prepare(substream);
 	if (err < 0)
 		return err;
+	pcm_qos_req_update(substream, period_to_usecs(substream->runtime));
 	return snd_pcm_do_reset(substream, state);
 }
 
@@ -2746,8 +2762,7 @@ void snd_pcm_release_substream(struct snd_pcm_substream *substream)
 		substream->ops->close(substream);
 		substream->hw_opened = 0;
 	}
-	if (cpu_latency_qos_request_active(&substream->latency_pm_qos_req))
-		cpu_latency_qos_remove_request(&substream->latency_pm_qos_req);
+	pcm_qos_req_clear(substream);
 	if (substream->pcm_release) {
 		substream->pcm_release(substream);
 		substream->pcm_release = NULL;
-- 
2.53.0



