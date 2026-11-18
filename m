Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021077;
	b=AJ6IFgBzpNWGlM9X2Dx10IGeGwMOYwkbUawcMp8KpAsS+u+OPFsqbqC9ACMywCfGnui7
	 zP0z6XWdd6srd0IIlsQR2OwgUmxA9M/QdYoK5mTbSvGjp/m5iRu98z0d7jGxIjjf7UHZK
	 +tzk6vUFHCNHrG3Y0XFuFAVwguzVIe8Du0YubIHatYms176YoBMTo+dzO77sLUu1Twv2d
	 JzVtH7cu/yhvuL7jdbhWts01vG1aJ04KT22KwdrEJloEvGe7nBi/1CPovYXK0hNrlKAT3
	 Z+VUZfInGo6DbPdKflFNajQ1hpt87ULKaCvly2laHgtWM5igrZtRtl4AbRrE1lTDxnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PZtQQS3a1bDJW5NlF1rmNmKVBvI4DfkOyHkb/jv5HLI=;
	b=Pu45RK/5+BE+Xp//dsbPf1EJFEbmGbvIWcHg4FXhbfRzaQQQgpwLQ6Fuzc0O3smr8tkb
	 SYDmaERNQ9/jnZBJ1IAEVCa2D41/NZGJhWrgLSZwYNu5ZeFnRjpDqGmsm4/VoTvB9kGKw
	 hXMk3OpwaH4FmaxLt0ziE63iqRpmL++YwTz5cyvPly2GkVDJU+C+8vFAZ2OlrsxqhaGNx
	 NrkgIC7zG20rALSN8lQrVoP7RjpoalDFoLTAsLBEjx7MR3rVM566AH6E4puiRhwpwgRsg
	 Fm5NZlQPz/d3F2N1jWtzX13B1J4RsKW2+u4lKx/HMmtBEA3TtUd6JMjn8gp7Z/IVBMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZX55FOnl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F25C606A32A;
	Wed, 18 Nov 2026 16:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZX55FOnl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86DB1F000C4;
	Wed, 18 Nov 2026 16:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021077;
	bh=PZtQQS3a1bDJW5NlF1rmNmKVBvI4DfkOyHkb/jv5HLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZX55FOnlF4Agtw4K08A6W0FkKNfQdXcMyYmmOBwCk+WVOWkVP6jjDfbyCFSxYIe99
	 4Gy6rMmh/guLBbIrJJJUKI0b0m15zxeXfO9Mr+nzYs1/zHn82yFYlvbH/rzm7NXSrc
	 y+nYGlRIuCmMf0Kybq6JliPnuTdqUfbzy9pinGS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2178/2651] ALSA: aloop: Keep shared timer callbacks alive through close
Date: Wed, 18 Nov 2026 15:56:58 +0100
Message-ID: <20261118150404.198685637@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit a7d4d780f34b9e43eefab6a7e6c9f4101f2c144e ]

The shared sound-timer callback must finish using the selected PCM
runtimes before a close can detach them. loopback_snd_timer_period_elapsed()
saves the active substreams under cable->lock, then drops the lock before
calling snd_pcm_period_elapsed() or snd_pcm_stop_xrun(). The sound-timer
backend has no per-stream close drain, and free_cable() keeps the timer
open when the paired endpoint remains attached.

With both directions running on a shared sound timer, playback can be
dropped and closed while a notification is pending. Capture keeps the
timer alive, allowing this order:

  Timer callback                       Playback owner
  --------------                       --------------
  select playback under cable->lock
  unlock; delay notification
                                       DROP; HW_FREE -> OPEN
                                       close: snd_pcm_drop(); unlock
                                       free_cable(); peer stays alive
  snd_pcm_period_elapsed()
    lock stream; cache runtime
                                       snd_pcm_detach_substream()
                                         free runtime and its fasync
    read runtime->fasync

The stream lock taken by snd_pcm_drop() cannot protect a notification
that starts after it returns, and detach does not take it. The callback
can therefore read runtime->fasync after the runtime has been freed, and
an escaped notification can also reach a replacement runtime if the same
substream slot is reopened before the notification resumes.

Take the existing cable->stop_count reference under cable->lock when
selecting the targets and release it after the PCM callbacks finish,
including the XRUN path. free_cable() already removes the closing
endpoint under that lock and waits for stop_count before returning, so
runtime detach and slot reuse cannot overtake the notification.

Fixes: 26c53379f98d ("ALSA: aloop: Support selection of snd_timer instead of jiffies")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM
Link: https://patch.msgid.link/pm-pmb-275c4399f517e09d7188-v2-2f64c1328529ef7a8fec@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index ba690bdd93736..4d05accb838ca 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -100,7 +100,7 @@ struct loopback_ops {
 struct loopback_cable {
 	spinlock_t lock;
 	struct loopback_pcm *streams[2];
-	/* in-flight peer stops running outside cable->lock */
+	/* in-flight PCM callbacks running outside cable->lock */
 	struct snd_refcount stop_count;
 	struct snd_pcm_hardware hw;
 	/* flags */
@@ -876,6 +876,8 @@ static void loopback_snd_timer_period_elapsed(struct loopback_cable *cable,
 		valid_runtime = (running & (1 << SNDRV_PCM_STREAM_PLAYBACK)) ?
 			dpcm_play->substream->runtime :
 			dpcm_capt->substream->runtime;
+		/* Keep runtimes alive through the PCM callbacks. */
+		snd_refcount_get(&cable->stop_count);
 
 		/* resolution is only valid for SNDRV_TIMER_EVENT_TICK events */
 		if (event == SNDRV_TIMER_EVENT_TICK) {
@@ -911,13 +913,16 @@ static void loopback_snd_timer_period_elapsed(struct loopback_cable *cable,
 			snd_pcm_stop_xrun(substream_play);
 		if (substream_capt)
 			snd_pcm_stop_xrun(substream_capt);
-		return;
+		goto exit;
 	}
 
 	if (substream_play)
 		snd_pcm_period_elapsed(substream_play);
 	if (substream_capt)
 		snd_pcm_period_elapsed(substream_capt);
+
+exit:
+	snd_refcount_put(&cable->stop_count);
 }
 
 static void loopback_snd_timer_function(struct snd_timer_instance *timeri,
@@ -1177,7 +1182,7 @@ static void free_cable(struct snd_pcm_substream *substream)
 		other_alive = cable->streams[!substream->stream];
 	}
 
-	/* Pair with the stop_count increment in loopback_check_format(). */
+	/* Wait for PCM callbacks running outside cable->lock. */
 	snd_refcount_sync(&cable->stop_count);
 	if (other_alive)
 		return;
-- 
2.53.0



