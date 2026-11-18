Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047567;
	b=2iZfZj9fZlgNIjls3rPPzicdv7Flf+omDjJPJryxa/vYB26ajnVdclNtMRk0X257Gka1
	 ihhLIi5+/LkN832lUxh8upoF9jYHFwX6TdQAMoxwz67SRef8MzzSuXcRRsEKXbuJXmGDL
	 R0rvk0HutrOPHUQRY6YC2v27pJ1cnDVCwzmWZu9xo7PSIUF7npPCl30fyBEmlSQjfX272
	 FEby4fEJw9eb7G3MyFwrutdKgHBCc2n2aRtVzec9c3sdys6EORv3IiAQzSTGB/8UhV+p+
	 Ac4VvF/CY/FubilUzn8SowBUIdVq0xAxqyE6S0cfaEP1KA6CGJjf1uKHSE4OokRyyZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bMPT4xgjd1FTmNOg/gn24FRkvTD85Zsj3Lut+2DzxFU=;
	b=0zp0U9G+jrc4Dp3SeJguTweWJHCW1U0LoINbYPFmb/7Vwdca0WIbKKP5G2MuxDilYjPK
	 T5FX3Fxod1jHjCJwJmVON1gr2ID1iAlOq/426ZykK6rxCXd65HKlNmuw7xAmgZmhfjlXF
	 IYICiR4CaggX/wg1BRo92X+WnAh5u0Ncrvkc45diTwJDJYgt4pYYbnam6U3NLoDfZW2CM
	 s8FBwrvp8sf1BQIaBIUtSNLXNzUWX5E7K43/pbmrCIXAGvddyQhBXeRW+I3+K8PEGTt3t
	 ch8Lbq7BTHty8OQxVtIWSLN7ws9DVYw2EgcbWNyCuIwQJRIilYiwcLS9MM3FCgz+4TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bCQvjDx2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69983606A31C;
	Thu, 19 Nov 2026 00:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bCQvjDx2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AE81F000C5;
	Thu, 19 Nov 2026 00:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047567;
	bh=bMPT4xgjd1FTmNOg/gn24FRkvTD85Zsj3Lut+2DzxFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCQvjDx2t+QkPQykVU4iCCS5j08aWqevJ5TIDb/HzOtq32zdEIAuphXTHMfVtEd3v
	 jAEI8cnNsDqw9+YtyIkQxE2IPBoihLRzQAy5GOWgR6gRz9PJYs9ZwHdlTyLxqauHfC
	 AyltwOxJepRSYiA0smXMr7jN1iDZ0omxC7qCKEsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1644/2857] ALSA: pcm: Optimize cpu_latency_qos_*() calls
Date: Wed, 18 Nov 2026 15:44:38 +0100
Message-ID: <20261118150300.533395895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 497521424ea71..e015f34ce463c 100644
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
@@ -1974,6 +1989,7 @@ static int snd_pcm_do_prepare(struct snd_pcm_substream *substream,
 	err = substream->ops->prepare(substream);
 	if (err < 0)
 		return err;
+	pcm_qos_req_update(substream, period_to_usecs(substream->runtime));
 	return snd_pcm_do_reset(substream, state);
 }
 
@@ -2748,8 +2764,7 @@ void snd_pcm_release_substream(struct snd_pcm_substream *substream)
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



