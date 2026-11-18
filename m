Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021060;
	b=rD3fDJXKHCNRbibMqlco+x3AdHcgevmCjWytfdoYnLv7uonG96RhrbtlT3XC/RCJk5Jd
	 oPfcFL1sHLs/IwVF60qPpb9wzphSlc+xKUhlP+mNIUXJw9BMquHxYmZ6qqiDAHTRdewOe
	 DjMt6sLrUqf4IKVJkrTnSnbj4L2NINCGK0gfGwHjBfEnDu1ZSUcIq5536M+/4nBTT7gEp
	 W7L27Z5njJbcJiYDFR79OTzr7/Cn6Buk3ANM4yFp3cnqlXPNcVbXdLu7dpoVc6b6UWcog
	 az6veiKJz1+P0zVUu3zWZ7OTgNGcaPUoXOm3bM8JbM7+Y6E0u5dIBAWsgq0K3K2Lv5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zpgW3YBxH8rVr8VQZU7TfjDvYoLTI4eWp4ZHvwNoIFk=;
	b=KKhGod0w7W41U4vQZspwCnWzwVRgS4QPNGhWpQHEsih9C7HVeXl2NTnMsdvdlOh9RK12
	 cshM1bYf7otc8GrKziGqy7P6j/dPntHZ7edcQzl0uYBEdXAX0V/ofTzxKkDm2sQ79Nw0f
	 Ucs99Ml6+eJAj9Nr+G+xvHRsIbnGION9vMgdfJXNBK+OebRzwnE9KLix34WC6XwSYDQj9
	 8j0oZjxFFvaF78jkD+8lrHVtkTyOgLo5Cm4cfF+WD86bMHGq5KkgscWY4scu5KeHyF43V
	 UMYnjpaWfETuacdJvW9jT1J1naI0ow/DsPaEF4BnTp50kApglxzKYh9XND2bUdmDP5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xB+JcLIW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600FA606A331;
	Wed, 18 Nov 2026 16:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xB+JcLIW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E961F000C4;
	Wed, 18 Nov 2026 16:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021060;
	bh=zpgW3YBxH8rVr8VQZU7TfjDvYoLTI4eWp4ZHvwNoIFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xB+JcLIW5sImut5hL9UvqsrBXbNB2NNGWIAm4sJJ//QCng3HG8M8a3U5Q0QTxoM46
	 Lwe7B4Shb6FVf92b4MfJCsUkEXYQLvLbTNiRPKn7q+JGYGQiNmvoH9qI9S93mA5GVN
	 GNNo3MX50IIDBDJXBydkZ7y+aGjRM78BdnRfFuPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2172/2651] ALSA: pcm: Protect channel-map reads against runtime detach
Date: Wed, 18 Nov 2026 15:56:52 +0100
Message-ID: <20261118150403.998263884@linuxfoundation.org>
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
index 4d665b4148d70..1ec7db324196f 100644
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



