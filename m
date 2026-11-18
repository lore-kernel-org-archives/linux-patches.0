Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027540;
	b=nQhmq8FV+APKWmjP7smYRjcrhW54ingXh+x3Z9163Yzbp8cfSc9SsQi87xqsi5Oq9/fZ
	 68dPOJt8xEFEDU+1C5QdU2HT4I5xm9R7LnWa+sxhQeXvmIaTT9h2TNQ4FDnzU6perBOND
	 nYwwbaOaUYV+mE2YOXTgeYStBlyxnSvswsXy5O5xxkfLMpLr1Nhk++9PlH8ESZNy1vwq4
	 YpX3FUFZmxaqbhBIZvmFouryWPqfocbXvrx1GsxcDIN87UagXSJqHqHujOp9Sc+eY8Qp3
	 N0PdAltpPkt6rV3j2B686n3FP/iQNnG01khfOg7QEYd0I1/BBA2V9IUoJGRLZO2nIRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IJaJR3ylGOeYtnIKmuPIO5HNHBCglYsIr61C/79h2rw=;
	b=mU3HRh/MAeR62cvZmANHqld9EVSN4CRjc/ABpB1dvFTvN+YOgksPcZiS1TQX2sHse9eL
	 jevqbvz4uvXlc+Sx24i9uS1JcvH0cp1m91quWEt0ghLb4jiI4QBZ5aveFWMSa0a00inuP
	 M3qw8CCs3blFkmNjKgLWzYKsc6KkVHPNXAdLYVSuMEGoEqDeTMhMp77haL0qKZLCCySAS
	 1lmLxHyTMWUVpYbkDzhEDbewP5qy8TK/SaQsyH6LY0k819cfFdeQeBUicFxOwk3GlMNDy
	 8nfrJZ+Ub2fw7OXZYZtcbMedCvTLf0nWgumkkK4q/h/eJnLkyuqmOkYXDfU+iS6Uqmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=phs7EUOB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB1060A260E;
	Wed, 18 Nov 2026 18:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=phs7EUOB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EED91F00925;
	Wed, 18 Nov 2026 18:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027540;
	bh=IJaJR3ylGOeYtnIKmuPIO5HNHBCglYsIr61C/79h2rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=phs7EUOBMn+ak0Ssf8H1jvRj+SedJ3dEDCxBGcI8bR6oSapfhPGnqSyilEj6NS5En
	 PAZRHQ0u3MhwNodbfsPpbHgDrvhd3ol7/Bh6R9kBkIMRMOfRcFth1S4otHRJWjSvMN
	 zP/uBASMvHI/n/imORdOJiRcbsiG0ifdbd0HNltM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1785/2151] ALSA: aloop: Use the new helper for stop-count refcount
Date: Wed, 18 Nov 2026 15:58:40 +0100
Message-ID: <20261118150226.846718423@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit c54888c1171e6a03b8325e03011cedc0a9781161 ]

Replace the open-code for managing the stop-count refcount with the
new helpers.
Only a code cleanup, no functional changes.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260610154538.51076-5-tiwai@suse.de
Stable-dep-of: a7d4d780f34b ("ALSA: aloop: Keep shared timer callbacks alive through close")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index fd8d6b474e465..226d96bfa6e53 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -100,8 +100,7 @@ struct loopback_cable {
 	spinlock_t lock;
 	struct loopback_pcm *streams[2];
 	/* in-flight peer stops running outside cable->lock */
-	atomic_t stop_count;
-	wait_queue_head_t stop_wait;
+	struct snd_refcount stop_count;
 	struct snd_pcm_hardware hw;
 	/* flags */
 	unsigned int valid;
@@ -374,7 +373,7 @@ static int loopback_check_format(struct loopback_cable *cable, int stream)
 				return -EIO;
 			else if (check && cruntime->state == SNDRV_PCM_STATE_RUNNING) {
 				/* close must not free the peer runtime below */
-				atomic_inc(&cable->stop_count);
+				snd_refcount_get(&cable->stop_count);
 				stop_capture = true;
 			}
 		}
@@ -407,8 +406,7 @@ static int loopback_check_format(struct loopback_cable *cable, int stream)
 
 	if (stop_capture) {
 		snd_pcm_stop(dpcm_capt->substream, SNDRV_PCM_STATE_DRAINING);
-		if (atomic_dec_and_test(&cable->stop_count))
-			wake_up(&cable->stop_wait);
+		snd_refcount_put(&cable->stop_count);
 	}
 
 	return 0;
@@ -1093,7 +1091,7 @@ static void free_cable(struct snd_pcm_substream *substream)
 	}
 
 	/* Pair with the stop_count increment in loopback_check_format(). */
-	wait_event(cable->stop_wait, !atomic_read(&cable->stop_count));
+	snd_refcount_sync(&cable->stop_count);
 	if (other_alive)
 		return;
 
@@ -1297,8 +1295,7 @@ static int loopback_open(struct snd_pcm_substream *substream)
 			goto unlock;
 		}
 		spin_lock_init(&cable->lock);
-		atomic_set(&cable->stop_count, 0);
-		init_waitqueue_head(&cable->stop_wait);
+		snd_refcount_init(&cable->stop_count);
 		cable->hw = loopback_pcm_hardware;
 		if (loopback->timer_source)
 			cable->ops = &loopback_snd_timer_ops;
-- 
2.53.0



