Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050334;
	b=bLpJeGjPvUDFt8C1LGGFqNRCOxs5/J1RivXdvxGjpdzu8ew9Aq7PdpfexXTDZop5/phi
	 3pGD3pPKpogLa2MPakVl/kh1BUlV8NqcQhxh9jauIagvb62uOoeYRKyiehw9yRrXvcGx7
	 Y4QQWjwuBfUyXS83ARxp85N9S0oij2jE5O+Tv3L8T0hlv7681Fc6tBCfnjM+FsNyLQ/dP
	 WTRAq49EYvyxxgygh4d0iDxsObw1S6vrbE64WVp5qAxK9UuN8ySicK9wMOmHItU9dD5wD
	 FTRLS5Ju3mgzX/qIy0O3qCL4EgOVd43T7O3Io1o3+pAnDaBeD5SNsCW9ctvzIA2m+4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YXsGs9BzV0TkXyuJQUA5MinTrbki07/O3y37jvfG0yc=;
	b=XiyQfq6xICGqDuFfEeZGMNVP2c9izZor4P4OIdmdnAhmxEpJuO0pVj8tvDRlnzb4jTRb
	 wxmxWQDAWarmoun6l4pwmBp7ahIWyzaXx89k4BUd33HIokOWTI7YRxnufaoB++5EuBB7Z
	 b13zRWX3DjGL7FjiqRPCsrzWeO+u9fUWmr9hhNhJDySEMsoQJbOP/rQtWic6zVcJnf3NI
	 CxdvaeaCKDqB0/0Jfl9d1q3SRD6hUj+4uUAVG4oSKaZdVFYp13qQAqYa7CDMTE8OKJH9q
	 jcqtXpcp0E61vRRPn/8YFT0Sb41CK8dATdTOHMoKLaeblaAon+4+BX8Goezscp8Uqyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wttptxtk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088AF606A334;
	Thu, 19 Nov 2026 01:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wttptxtk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9871F000C6;
	Thu, 19 Nov 2026 01:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050333;
	bh=YXsGs9BzV0TkXyuJQUA5MinTrbki07/O3y37jvfG0yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wttptxtkYGm3kKE4HpWtc3wVIA7A+5aWD43yGbe/anV78udpeBgixeeWM8OsrMMIJ
	 LlbXdL8N418vQQkNNsFsXVI66SV7h/ecKjrxEWzsFFRJknb+B/DCDXPUld6OdUrz9K
	 7erdKeo+iuAXAvM/2ksAoJffvPaWTsOkPFGZhMAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2630/2857] ALSA: pcm: Protect channel-map reads against runtime detach
Date: Wed, 18 Nov 2026 16:01:04 +0100
Message-ID: <20261118150336.288230408@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit bb4834d5242c4829c0d8467ee68eb25a9bafc38d ]

Channel-map controls remain accessible between PCM opens. In-tree HDA
code publishes the generic controls through add_std_chmaps(), so a
SNDRV_CTL_IOCTL_ELEM_READ can overlap the final close of the same PCM
substream.

pcm_chmap_ctl_get() checks substream->runtime and later reads its channel
count. Final close clears and frees that runtime under pcm->open_mutex,
while the control callback holds only controls_rwsem:

  Control GET                         Final PCM close
  -----------                         ---------------
  snd_ctl_elem_read()
    down_read(controls_rwsem)
    pcm_chmap_ctl_get()
      check substream->runtime
                                      lock(pcm->open_mutex)
                                      snd_pcm_release_substream()
                                        snd_pcm_detach_substream()
                                          substream->runtime = NULL
                                          kfree(runtime)
                                      unlock(pcm->open_mutex)
      substream->runtime->channels
        NULL or freed-pointer access
    up_read(controls_rwsem)

Reloading the cleared field can fault through NULL, while retaining the
old pointer can access freed storage. controls_rwsem keeps the control
alive, but does not serialize the matching PCM close.

Copy the channel count under open_mutex and use that scalar for the map
lookup. Use trylock with -EBUSY because snd_pcm_dev_disconnect() takes
open_mutex before removing controls under controls_rwsem; blocking in
the reverse order from GET could deadlock.

Fixes: 2d3391ec0ecc ("ALSA: PCM: channel mapping API implementation")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/pm-pmb-0b5d6bc7124d0b921f2c-v4-b9738bdeab8823999181@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_lib.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index af1eb136feb09..3c7b893a0a56b 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -2397,6 +2397,7 @@ static int pcm_chmap_ctl_get(struct snd_kcontrol *kcontrol,
 	unsigned int idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
 	struct snd_pcm_substream *substream;
 	const struct snd_pcm_chmap_elem *map;
+	unsigned int channels;
 
 	if (!info->chmap)
 		return -EINVAL;
@@ -2405,11 +2406,20 @@ static int pcm_chmap_ctl_get(struct snd_kcontrol *kcontrol,
 		return -ENODEV;
 	memset(ucontrol->value.integer.value, 0,
 	       sizeof(long) * info->max_channels);
-	if (!substream->runtime)
-		return 0; /* no channels set */
+	/*
+	 * PCM disconnect takes open_mutex before removing controls.
+	 * Use trylock to avoid a deadlock with controls_rwsem.
+	 */
+	scoped_cond_guard(mutex_try, return -EBUSY,
+			  &info->pcm->open_mutex) {
+		if (!substream->runtime)
+			return 0; /* no channels set */
+		channels = substream->runtime->channels;
+	}
 	for (map = info->chmap; map->channels; map++) {
 		int i;
-		if (map->channels == substream->runtime->channels &&
+
+		if (map->channels == channels &&
 		    valid_chmap_channels(info, map->channels)) {
 			for (i = 0; i < map->channels; i++)
 				ucontrol->value.integer.value[i] = map->map[i];
-- 
2.53.0



