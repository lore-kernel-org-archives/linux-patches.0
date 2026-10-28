Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214975;
	b=2jMtEDT6aVbGlSQXDxgwGThIQhvx10qS8KTD8W/W7KrfyPiHf1DpFseQ9anS37ZVEaqY
	 IH3ENBLAD7/q38k1DZrSxHg+RrKtheNP95w4vLXB9lV5QOOPiT9qQHui9sqj8zAulHto2
	 VmspaEOC/pZDlbCSGXNXMVxQHh+aXApz01DU7AU81VDGio9eUF0gRM9BnIFSFGAqD+VQP
	 MUOL5zrFWvmdvRnXCJAsMpYyJcT14cFOIcOlcdW8S6I+CkhI3El4QZfEx73Vk4Eivjsoc
	 g8EE3I2zdoonqmfa8VxTxhffmXpysFLEHLZBLGmcyR6C8OFgyDBZMJ9FNkmlZ64aJiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rlTpdhTlLS0PtCcQxAWErunyDL+W6GEd4g3ghw/yF8I=;
	b=PedZkBmzSv10FaptU19h0EVyz3O9iSjQWdkJrJDz7Dus9l6hsx5+TSG7G39a8GydXFka
	 CmjpR7z5AFwIzdqkoA3BP3sD+HjYYKGAKneie7YbrboR4wlHDAfN0N/gn4GAAZV7AFdjl
	 rSGpD0aUlmbs97yqJ6doPLs7/NzovPabiDUZmqi8SCa5FIW0yThYx6mQqzY5+hs9eIVSL
	 YCt5AjZwhgqAc+0aWhVqJv0tXBFoJKHZDY/03su31iqnCLejwOJyvM7qNJrBRKxmr7miK
	 4W+GvEwrlPNF++1nfwsvv5zOpdSrwgai2dvDTJFHtxB9vJdTSumflXJsNzUDP1yqWaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l79iEKYQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EC960A2612;
	Wed, 28 Oct 2026 19:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l79iEKYQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775581F01829;
	Wed, 28 Oct 2026 19:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214975;
	bh=rlTpdhTlLS0PtCcQxAWErunyDL+W6GEd4g3ghw/yF8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l79iEKYQuldu2rdAsCcEtL5V0YW99/rc7VT1xiooGjZcNCVSAQkWVx0pJ1bx4ZBtx
	 BCzl2C2/uggUCf7ScZzmvOh+Ri5sOll70CHBB0tqC2tnIvyu88oQP/srrdfLnA6bOC
	 Ddo2LSe+2PDvsKW7qWfZVMPOwkOov5u33FL3+pfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>
Subject: [PATCH 6.1 1049/1887] ALSA: pcm: oss: Fix data race at accessing runtime.oss.trigger
Date: Wed, 28 Oct 2026 17:52:25 +0100
Message-ID: <20261028170523.280653886@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

[ Upstream commit 901ac0ff15edf9503162e2cf6579bd11a30f1ed4 ]

Currently the runtime.oss.trigger field may be accessed concurrently
without protection, which may lead to the data race.  And, in this
case, it may lead to more severe problem because it's a bit field; as
writing the data, it may overwrite other bit fields as well, which
confuses the operation completely, as spotted by fuzzing.

Fix it by covering runtime.oss.trigger bit fled also with the existing
params_lock mutex in both snd_pcm_oss_get_trigger() and
snd_pcm_oss_poll().

Reported-and-tested-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Closes: https://lore.kernel.org/20260423145330.210035-1-jjy600901@snu.ac.kr
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260424112205.123703-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/oss/pcm_oss.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index 80dae370a0d58..d5cd728c30a00 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -2161,10 +2161,16 @@ static int snd_pcm_oss_get_trigger(struct snd_pcm_oss_file *pcm_oss_file)
 
 	psubstream = pcm_oss_file->streams[SNDRV_PCM_STREAM_PLAYBACK];
 	csubstream = pcm_oss_file->streams[SNDRV_PCM_STREAM_CAPTURE];
-	if (psubstream && psubstream->runtime && psubstream->runtime->oss.trigger)
-		result |= PCM_ENABLE_OUTPUT;
-	if (csubstream && csubstream->runtime && csubstream->runtime->oss.trigger)
-		result |= PCM_ENABLE_INPUT;
+	if (psubstream && psubstream->runtime) {
+		guard(mutex)(&psubstream->runtime->oss.params_lock);
+		if (psubstream->runtime->oss.trigger)
+			result |= PCM_ENABLE_OUTPUT;
+	}
+	if (csubstream && csubstream->runtime) {
+		guard(mutex)(&csubstream->runtime->oss.params_lock);
+		if (csubstream->runtime->oss.trigger)
+			result |= PCM_ENABLE_INPUT;
+	}
 	return result;
 }
 
@@ -2839,6 +2845,17 @@ static int snd_pcm_oss_capture_ready(struct snd_pcm_substream *substream)
 						runtime->oss.period_frames;
 }
 
+static bool need_input_retrigger(struct snd_pcm_runtime *runtime)
+{
+	bool ret;
+
+	guard(mutex)(&runtime->oss.params_lock);
+	ret = runtime->oss.trigger;
+	if (ret)
+		runtime->oss.trigger = 0;
+	return ret;
+}
+
 static __poll_t snd_pcm_oss_poll(struct file *file, poll_table * wait)
 {
 	struct snd_pcm_oss_file *pcm_oss_file;
@@ -2871,11 +2888,11 @@ static __poll_t snd_pcm_oss_poll(struct file *file, poll_table * wait)
 		    snd_pcm_oss_capture_ready(csubstream))
 			mask |= EPOLLIN | EPOLLRDNORM;
 		snd_pcm_stream_unlock_irq(csubstream);
-		if (ostate != SNDRV_PCM_STATE_RUNNING && runtime->oss.trigger) {
+		if (ostate != SNDRV_PCM_STATE_RUNNING &&
+		    need_input_retrigger(runtime)) {
 			struct snd_pcm_oss_file ofile;
 			memset(&ofile, 0, sizeof(ofile));
 			ofile.streams[SNDRV_PCM_STREAM_CAPTURE] = pcm_oss_file->streams[SNDRV_PCM_STREAM_CAPTURE];
-			runtime->oss.trigger = 0;
 			snd_pcm_oss_set_trigger(&ofile, PCM_ENABLE_INPUT);
 		}
 	}
-- 
2.53.0



