Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042102;
	b=MvwjIiuAG7/HA1lkyoWxEzeWzn6+Xxp9/Phn5uUfulJkFmtf/tu+pCG5PyfGPSLlqG1O
	 lU4OQa6lYbS4cZa0IzwGgiw2urg49AIS/6YF+4K+1IK3EIntnu7wTNKf4yWijzu3hO0Jd
	 78kgz4hHeWmWl4o3TwUA+cjoEOxxkTJUe6wY40yQna8aYpCxpGldTnyiQO/Tu4C1dZzqB
	 EhrIF5T9/Pl7rqj3S3fvEwbbIJpnTjkKReOPpNVNdmDpEXq2KvP2dyqyAFcX6t4HtWLGJ
	 b2TGW6VLovLyWjKCyU1uJcZ4SKTQ5UuYEXiQPwEXmqeCmJ7f+0VxACY9okaOl3Y14bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OsBYlYGmyMR4WimAB0FsMqm8Re1bMt4A9viy8Zggz8c=;
	b=sGzKwEu/EH2fdRE4Kfet/IpXFop49/70f/hGSGEY0MobpyT0gtNwjq4b6UI8zm2/+wUG
	 fmtoDTCRq5trK90NZ5xbaOpwVc1vMfRHkHjHzFBIp/DQ5n4VYa81l06jRN+ZvzDyVsI6Z
	 xNFmFKRj4iAK2MIgjLxMpnJZWAG42e88YOW0wgycbDPtBoe4UW0Rp63d7/ucAnMDGWNxq
	 rKoZL3JGDrLdZWtZDA+WZnKtfEm3W/61UBPMD/oH2LBK5LQg/Ho3ixWinuXFc9AHBEbOD
	 Ct/V9H/jn8j/InHxNBiXlTA2A7trfkcsy1dZQU7mdEwm6c+/faDKuEC5OgZF/CaXGOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NkbRY/sw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA1D606A31C;
	Wed, 18 Nov 2026 22:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NkbRY/sw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D401F000C4;
	Wed, 18 Nov 2026 22:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042101;
	bh=OsBYlYGmyMR4WimAB0FsMqm8Re1bMt4A9viy8Zggz8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NkbRY/swc+mk9zYc80g+xYZJ4pH+wku6Mf/K0b08ZNc4L5HZp2FztobB/oPn6eoZq
	 9Xs0MS/bFdm4/ad49utrbV5hHaWVVd1HTg1XiVrglJC5rpWz5hUfeDs98L2yeRukXk
	 u6ez8+gdLsJBHiDeb41iPcioURooZDIpBtNi9DRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3050/3318] ALSA: pcm: Protect channel-map reads against runtime detach
Date: Wed, 18 Nov 2026 16:01:12 +0100
Message-ID: <20261118150451.653991966@linuxfoundation.org>
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
index 459c1be526391..0d17b66266336 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -2466,6 +2466,7 @@ static int pcm_chmap_ctl_get(struct snd_kcontrol *kcontrol,
 	unsigned int idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
 	struct snd_pcm_substream *substream;
 	const struct snd_pcm_chmap_elem *map;
+	unsigned int channels;
 
 	if (!info->chmap)
 		return -EINVAL;
@@ -2474,11 +2475,20 @@ static int pcm_chmap_ctl_get(struct snd_kcontrol *kcontrol,
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



