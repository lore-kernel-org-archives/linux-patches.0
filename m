Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021007;
	b=qpv/5aqHH32qXDiw/tGw+GbS/efjpU5w2fy+INTY8qoahqWISSA2UamxhbmqzKdSHr/p
	 xWIitbqbF9E2yBmRCnmv0AukVfS+HnKcoOeGGGXa58a7kxUU26wjITtnHRJZVt24orPqv
	 6AvZBcPMBZO3X4bQEfScWEz4MHU5x3uKUNC8aXAYDoa/Td4A6+lXlD5AA8PIhb2ac6SHQ
	 CNDvVMtO5TaRaY8oGIG764YXNDpoKmCgXjAvB7SnbhGLeRr+4FFDXyY+Ha4yOlcdl5N+b
	 1aK9NeFfy7EnJdOw9fDmfqZuRsBXrcXpStYSkzvb69/RZMThcRRzk3MUxy6B9BN0D6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q01BZK+2Z6s2U+t5VMDOwf4WX4JYCxs9Qsl6H8iIeOw=;
	b=QsvtBJMDM1M1oaDMYNBdkI5eZqbChqLmMq+Z+KYGXcqgpt/6b1157XUsYjx5x+03tLAO
	 I8Jr/9TrwVy04nm0b8OY0roHpjoBAzmZfWtw0m1Ti0I7sPgl2xPq/zkKBVhOKYTXCaXxH
	 SoOKXU8vV1ta51bVdWVQxqciPDpPDasMYutjEVmUG/imK64RAIBSUoWTW+csdUeI7Uqen
	 LagTVGu4v5mILncXjr1e7cZpz3HO9cjwxgVBRMDFN5EQSPbiOZxQV07Xq60G9/gFNbQCC
	 /eyicUufJWDR4yf2c1Et8J+Fdfv7cc9ihDZ7rsfCWH+nFPFt4E5nul7atVHETAZPeQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m5QeJjG9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56436606A31C;
	Wed, 18 Nov 2026 16:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m5QeJjG9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BA51F000C4;
	Wed, 18 Nov 2026 16:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021007;
	bh=q01BZK+2Z6s2U+t5VMDOwf4WX4JYCxs9Qsl6H8iIeOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m5QeJjG9rZZK/f08TlKJOWMN4oHu0MaakLLpfldJ1mtOPQzxwLUp4Y8v0MevRdC8J
	 IKhldYp3unWuagY88DT01cFTeaPn+hcKExJTrJpjgd8phziZloZAC+UXvxZ2YCT8W4
	 yuY4dE75kRaxHdaFLZzkkAPeeqMelB1Mf/zO2xns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2155/2651] ALSA: pcm: Protect the unregister notifier traversal
Date: Wed, 18 Nov 2026 15:56:35 +0100
Message-ID: <20261118150403.405316206@linuxfoundation.org>
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
index 423a183e395eb..c2c032946d97f 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -853,8 +853,10 @@ static int snd_pcm_free(struct snd_pcm *pcm)
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



