Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038874;
	b=oHlLBIxyy+kSQMbV/XL3HntO0UDoREt/Kb+1gAA6PYGUMzwjkw2dmTIMLo1niz9eYdJD
	 eLZTTVLa7kDelKeiMgTcfYS+L3wpX/WqxGPOlymY5YFZ5aqe8wMLXpqKhiiTs1QbxtCQ6
	 o0uxdjwSGKDbzDjTCwxN11FNDDDetQHLv8+vmh1x/heV7cOJupZRVZDpe1clM9oFzAJBV
	 OIv5jqTcKCdryYEPBIESWyWgpKwZ8RmkE13SjjzkpRg8wRtwLYzZLiTw8llQSiMVBHfOS
	 EsGxJF9oPdL3CTBv6b3y+nKDwbsKIHjQvAH6NT6G8/Wi8TAgj+8VvcI4AXz3oyMhg8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HEt/BrKBr4KMdnjshTOaOxg3V5g1ZUMLmRrUHX3jWvA=;
	b=a0g2nK4kGctjVOPsGtzHZY1grEanroE2EbUtgO9uoahYDOArzsHt0z+dM8VdLl+37JnB
	 Waj7v0oz7JAM7dW+/7xt15KB/hF++BxKL+s/WUNyG7MvCJ3SR+LIfbJv+a61yanJxhoaT
	 I/qHdTweyy9D7RK1GWz5Z33h1+yTrpyBsWOQ8rqdHDjJnXE6oV8qlutJW5BpeSa/u1Hgb
	 3LlGYMKhwlrs34mZXYbKUOCiyTZKQjEb1csqfmED1nxm2R0soJMAw6gVeggMzRwk3o5EZ
	 iQ3ietZPkWfE6FgWEOv8TIbMtaQSe+AOq2mIecnFIbDsz378N321hRvQufOp1GzDhAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSZInrYQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A9C606A320;
	Wed, 18 Nov 2026 21:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSZInrYQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515E11F000C4;
	Wed, 18 Nov 2026 21:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038873;
	bh=HEt/BrKBr4KMdnjshTOaOxg3V5g1ZUMLmRrUHX3jWvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSZInrYQLQQlviDUpABzsLreK+6PtUV1QJKBXJgal4Nb/FjoycNpWPK82b6fvpROU
	 WzqEAUFufXoT9oqFobEgv0glx9tjTY5JfShFguAvqnoGcEFdY/FdNHWr9bOJOHbLRd
	 yX4uoi7gia4qHtYVPDOhVGEA58kWs/N0yCT80ZaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1898/3318] ALSA: pcm: Optimize cpu_latency_qos_*() calls
Date: Wed, 18 Nov 2026 15:42:00 +0100
Message-ID: <20261118150418.950682375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4b570d8aa80eb..989e822c1059c 100644
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
@@ -1976,6 +1991,7 @@ static int snd_pcm_do_prepare(struct snd_pcm_substream *substream,
 	err = substream->ops->prepare(substream);
 	if (err < 0)
 		return err;
+	pcm_qos_req_update(substream, period_to_usecs(substream->runtime));
 	return snd_pcm_do_reset(substream, state);
 }
 
@@ -2750,8 +2766,7 @@ void snd_pcm_release_substream(struct snd_pcm_substream *substream)
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



