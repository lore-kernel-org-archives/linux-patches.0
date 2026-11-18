Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027544;
	b=pfJ3Rz7qtdtumwxuIrn7EC6MQ6O653TMASfqXlLuzomBWmqXLIG7vOJlS8XV9p9+/HS2
	 EW4DyOcpLGntrBOgG6cOfQSz+1XVqyYnJaB51ySyEBzqmwHFZc1kJJp8J+Cgb4eh/kUZp
	 t45C9o222fSUvkdNgF5smXOCLI5wnOW8OAuwg2MAzErMI/oFz3NCrFmZQKQHbifkLe8fM
	 6BJXqj8saxWmDPJ4G0zmTG13rIFtgcLPg+aWiFbw3BQ5PB9LcL/EyxqAmJ10xVFW4bNAz
	 u9g7/jq09uj9wuupPpFD3KHip/evnFgy4Yv+kAKaSthEiWd5K2jboMqkoLGW6ExnC+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ufGBlGeW2xHMUT7cy55A55QB6nt1HVETjT6HX7ARL14=;
	b=g3wm9jNB0RQpEO9P7oBRt3JgbJc7nLr1RlDsvTjsD0eXZH65D64W4fVJFBbRO0cYD9c3
	 Ns49h+366l3QYLC5RH88DajWaxj93ZgxxZxMSNnmFAGnGB2wt0t1fU7cOJrzheKBSzPgo
	 J6KZE8FuoVk5wnDYaYR5smSQBay8LKEX1rQ2RhhK8UhLQmtsXRMB17gd5n3VfIvwYKIeo
	 HH6c8IhWqDEuIDZux7//YAyLprbY0KwrXpvBtwq/a7DMXohv3EToammLoUxgOo2lqHUHz
	 ZuEOqF1EdIdSY56RrzmYEeeKGL+AHGipWe9N5ROVeGnb6gJogBxzaBizFXLTZHB0Z1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YldrdVAW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EAE60A2611;
	Wed, 18 Nov 2026 18:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YldrdVAW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935C71F000C6;
	Wed, 18 Nov 2026 18:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027544;
	bh=ufGBlGeW2xHMUT7cy55A55QB6nt1HVETjT6HX7ARL14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YldrdVAWTp4mrgJbkk5PkvRw7WzfI6/F7xC3yno6Ds7JCHu6vynG7n+EHyHDDMUX9
	 KxSBTwgpVhaCHlUdSxhYGxirNz574N3eLwrzdZXkZo4gnxZqm8lnUhou/9NjropRpT
	 Tl+l5TJuqEwtBkJR0ZSjRfzVOB7JHGUsx+4eEG00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1786/2151] ALSA: aloop: Keep shared timer callbacks alive through close
Date: Wed, 18 Nov 2026 15:58:41 +0100
Message-ID: <20261118150226.881785651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 226d96bfa6e53..24a5fbc1c288f 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -99,7 +99,7 @@ struct loopback_ops {
 struct loopback_cable {
 	spinlock_t lock;
 	struct loopback_pcm *streams[2];
-	/* in-flight peer stops running outside cable->lock */
+	/* in-flight PCM callbacks running outside cable->lock */
 	struct snd_refcount stop_count;
 	struct snd_pcm_hardware hw;
 	/* flags */
@@ -804,6 +804,8 @@ static void loopback_snd_timer_period_elapsed(struct loopback_cable *cable,
 		valid_runtime = (running & (1 << SNDRV_PCM_STREAM_PLAYBACK)) ?
 			dpcm_play->substream->runtime :
 			dpcm_capt->substream->runtime;
+		/* Keep runtimes alive through the PCM callbacks. */
+		snd_refcount_get(&cable->stop_count);
 
 		/* resolution is only valid for SNDRV_TIMER_EVENT_TICK events */
 		if (event == SNDRV_TIMER_EVENT_TICK) {
@@ -839,13 +841,16 @@ static void loopback_snd_timer_period_elapsed(struct loopback_cable *cable,
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
@@ -1090,7 +1095,7 @@ static void free_cable(struct snd_pcm_substream *substream)
 		other_alive = cable->streams[!substream->stream];
 	}
 
-	/* Pair with the stop_count increment in loopback_check_format(). */
+	/* Wait for PCM callbacks running outside cable->lock. */
 	snd_refcount_sync(&cable->stop_count);
 	if (other_alive)
 		return;
-- 
2.53.0



