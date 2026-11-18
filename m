Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027487;
	b=LFiJj5mVIguWpvlcY6BQ7bg1cWEAFZULhSG2HtaiYDvFHNYQcs5XWU0tgdwi9DWVJplo
	 QqUt4UbqOawo+eFQAgwNlc6y+v5YUmHl8e7eG0uEb2lc/ZugGOkGITkZvaH02VNcaulvu
	 /FyPqFDLQFRYryUhq2MCOzOajCrxNY1kP09b7Y2UW/uvFRo00ujqoTiyWUW/PWUN5OK6D
	 JIBM69yX/25JgP2fuhZD53g6zosFi5KeO6MYA75z3yCxIxwNlrZEhShwrN01QaqR8lPUX
	 AuBCcEzLVLJF1ifSM7MzxdzeYDdZWYy2iPyKze1cIuEB7VRla5dVBJvQzftmGuWLrCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gbAYI0pT0U46f+BZxWwWmZy/Af7K5HCESklk8zwh8U0=;
	b=e8tXoR6V9okdEfE3Ph7IsJomQsWGNh2o7i4ejvYmY3OIGeWztT8ycx4/Fpqifg1RsnW0
	 DajY7lR56O4zW6CBKpH9W/6ka18m0ggJwiVciHOCbkEVlpKxrJGVVSq+38ExliUqJIxFX
	 lsgpsnZ6zBB6EtxM3mmPkbYKdOgfaX6tEfO/HQzvlmCVvatd7+dccU5/IRczPoQJq4H/S
	 eDWPassaF5apycX6BtX2UBmTZsshKQqeq2Hfg+L1CIQvT9e6EL7AcEDsvHSAYO0AindqU
	 vLs47s9q0wWH3P2+DBIQbtl3/oBFsp64UDzGIjpmcbnGlv6wGOsdvyrfsmTWBt+SV0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ce/qo4Q7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7FA60A2613;
	Wed, 18 Nov 2026 18:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ce/qo4Q7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15B11F000C4;
	Wed, 18 Nov 2026 18:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027487;
	bh=gbAYI0pT0U46f+BZxWwWmZy/Af7K5HCESklk8zwh8U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ce/qo4Q7+0MGJ/LF5Zdi/JzJmGwo24Xfg6I90mQgJsQdsQsdsAlfSLaZMiFDGAmug
	 fzxFOmzKMePYdq1R2wuicr+ZUp1i4FWBRGlgafELztkPePjAm1kFjjDo7MbMVqTipy
	 VeqOLKezoc9Smaj2SnXAb9Nfx8hnUSmFBr4lLQkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1780/2151] ALSA: pcm: Protect channel-map reads against runtime detach
Date: Wed, 18 Nov 2026 15:58:35 +0100
Message-ID: <20261118150226.666704645@linuxfoundation.org>
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
index 932b9337c93ee..fc9cb30f1189b 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -2496,6 +2496,7 @@ static int pcm_chmap_ctl_get(struct snd_kcontrol *kcontrol,
 	unsigned int idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
 	struct snd_pcm_substream *substream;
 	const struct snd_pcm_chmap_elem *map;
+	unsigned int channels;
 
 	if (!info->chmap)
 		return -EINVAL;
@@ -2504,11 +2505,20 @@ static int pcm_chmap_ctl_get(struct snd_kcontrol *kcontrol,
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



