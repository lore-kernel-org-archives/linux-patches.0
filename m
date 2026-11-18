Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042069;
	b=XXU4QTTCRSZttGFljgm94FLJayOhrl16Du2qc8RTRVqIWoE/gtQvEZW3z9lFzw/kWUKN
	 ERwk2L4/Hg7IM0v6W5NYKr7oKpeY0uSzxRYtlvMB5gZRO4eJPGdWNP0vSzNAKt1cQ68r1
	 lOuhDefo6STDR7COIg9GASzt/3HoqRT7NdFyb6r5K7938yN7t1btet5hEUrVDlbEejGtU
	 O1sslCaoqXKB0ECZjf5D5cPL7EMnAsIiAOFE/1OHzbPKnyq3LeUQ8hEutDCzD1zj8JlNs
	 osW/7J3zakgV5IrJVFtJnz2Vc3Bv85KcUPBjD0HabVo7RH1qYRCUk9sgOImRgRg3mfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ik//OIBZwmmzuDgCuJzZnh/wcXbS2RrtIdOQrK8vKOE=;
	b=qrgndvpqY2g5VZ05uSquXUJKA8N+080ebz6anMkztVxe3I26taxn67m5TUEv5cgKi5WV
	 VPntVlKSSZDp9wFE4Pmwr4jaK9W8YCNHHmk0uMRrz0GGD2/7kdbPLdXnA4R1cgpJZYXh+
	 zrESAgHa6Ae+UBJCKr/yN2SFJhQMLXEThBZX7V3cIMe/WqsMtt2nKOxiPIsqge/hqjwLH
	 CXXN+YnH40NHBv5YHDNY1p1wMHc9J6UnVlkd5rJXwpGtBXJpymGhwDoLsaiYKFE/HOPT1
	 2qVuVjqB6u5jbsdiFKpsKUd4AWq0oUpsa0oG1z3Kxjn9dKz4bUz1Q57oXWN+p6b9ssA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y91FcuNk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835B4606A320;
	Wed, 18 Nov 2026 22:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y91FcuNk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55AF1F000C4;
	Wed, 18 Nov 2026 22:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042069;
	bh=Ik//OIBZwmmzuDgCuJzZnh/wcXbS2RrtIdOQrK8vKOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y91FcuNkOrr717+lopunAwOdm5Dd1zu3Db8zuRBhzfA8uzB9xgYIc1OqQ9OqgrVSx
	 chZflyVJ36e2ykt/DkZ4A4T7WvPotdyIPJ0vA5VFq1Z+GZdymNFG18Esv/Y6oouvHQ
	 e/FKWsw98/pBr7Kc2DRtR7bB0GVGpCHAxiTAVKDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3040/3318] ALSA: pcm: Protect the unregister notifier traversal
Date: Wed, 18 Nov 2026 16:01:02 +0100
Message-ID: <20261118150451.367407555@linuxfoundation.org>
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
index a921e4e05baf2..fa2f0bcbb63dc 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -870,8 +870,10 @@ static int snd_pcm_free(struct snd_pcm *pcm)
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



