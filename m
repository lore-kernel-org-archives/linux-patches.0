Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050197;
	b=MetMnjLbMsLrOLH6mjZxo2JosASMVqlsLXnDldkf53mS1f1BEjSKG1U3fHSQJA4AwCTt
	 2cyyqOQeq84QKyho0ouc7qROc9elmrffxC7XlIwf0ATbNhINKs7lQxQuQuoOeeYB0li+Q
	 iHfEFiFtYkMNMBGtt8rLrVBUZIUXQNZfoFMql7iW1/Ew3o4B+ZPk7yBtPkGiRayH+Fd2m
	 Ljllg2H+eiXrTUkFCN9ETUECSd2PM8pfEkqpX1WYsKjblE08WOkbB2rbTQUMaMZwE9Iuq
	 zeqLgIEjzFfmSjUuzbAvR/19G/38F4Za80zesmuEsTqJkCGGIhZyXXMpmHfcNvdZSCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7sQzjzHZq9wO2NrZNWbabKFcJ4DIzOWU7IM47Yy0NL8=;
	b=BheQXPbLgrgGejrQCe3luHNHowsrRVysrY0FR4gi3BswzdZA2+5TRDJQ3O3aJAsaYsQA
	 6IuvbgTS83I4+lMqJvivJGPnjINdMZxGoxe+O/jnGuDUfE6J38xY6hz1vdNFzF+rlxFOW
	 x0NL02YC+lskn7dK1UvKIB8n1RMjqDMkbRejS15x3w2bZQDDSoxjKRQRqMLerrWN6z0Y7
	 IcGnoo9SiPOynvKxPPocIgyYmAIQ9jpV1fuq73F/PehQ9jbYqrcVyda3w1T6LvYTrws+f
	 FKux6WBaGbWFvyx6lQk+w+kPS5e/fLXy9dYPl7TYvk0H84ZpGI0I66NwRBpOAUBGDjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CKiDj5mh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64711606A325;
	Thu, 19 Nov 2026 01:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CKiDj5mh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962AB1F000C4;
	Thu, 19 Nov 2026 01:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050197;
	bh=7sQzjzHZq9wO2NrZNWbabKFcJ4DIzOWU7IM47Yy0NL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKiDj5mhnWHEY/4imIm+FPz83VfkrUZb0uQx2ZsrZOX64TljChBrJaHNXORMahIwU
	 YFhVkTY8EUYYZgmpPc4Zce4MIQA9RCCfyWf8Ufkcq15Ca+Ldav+nwBX3LoPfAfwpfA
	 glktkN967lX4UiOqPHjHS1N4wGp6VnAPgxN/qFVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2620/2857] ALSA: pcm: Protect the unregister notifier traversal
Date: Wed, 18 Nov 2026 16:00:54 +0100
Message-ID: <20261118150335.909107807@linuxfoundation.org>
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

[ Upstream commit 680be9f82d4977d3410c513d3bfe912d100f64fc ]

snd_pcm_free() traverses snd_pcm_notify_list and calls n_unregister
without register_mutex, although snd_pcm_notify() takes that mutex to
add and remove notifiers. PCM disconnect releases the mutex before the
free callback runs, so it does not protect this later traversal.

With no open OSS file, normal snd-pcm-oss removal can overlap PCM card
teardown, for example when unbinding snd-dummy:

  PCM card teardown                     snd-pcm-oss unload
  -----------------                     ------------------
  snd_pcm_dev_disconnect()
    remove PCM under register_mutex
    unlock register_mutex
  snd_pcm_free()
    fetch notifier
                                        snd_pcm_notify(..., 1)
                                          unlink notifier under mutex
                                        free module storage
    read notifier->n_unregister
    invoke callback

The free path can then read the notifier from released module storage
or call its unloaded code.

Hold register_mutex across the unregister traversal and its callbacks.
Notifier removal must wait until both have finished. This also protects
the traversal if a callback releases the last module reference: module
exit cannot unlink its notifier until the free path releases the mutex.
Drop the mutex before private_free and the remaining stream cleanup.

Fixes: c461482c8072 ("[ALSA] Unregister device files at disconnection")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/pm-pmb-26d66390a25fec9fad6c-v6-5be251a3ac8832955a31-1@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 84f0ca7ecbc44..8855481be5b48 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -864,8 +864,10 @@ static int snd_pcm_free(struct snd_pcm *pcm)
 {
 	if (!pcm)
 		return 0;
-	if (!pcm->internal)
-		pcm_call_notify(pcm, n_unregister);
+	if (!pcm->internal) {
+		scoped_guard(mutex, &register_mutex)
+			pcm_call_notify(pcm, n_unregister);
+	}
 	if (pcm->private_free)
 		pcm->private_free(pcm);
 	snd_pcm_lib_preallocate_free_for_all(pcm);
-- 
2.53.0



