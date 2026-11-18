Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027378;
	b=W7izfkbZ0OtlfO8vbc740E0i8Tdx3Zlem/7qVLu3xioKSZLDesBt1OhHvrbL3IV/vguJ
	 LaRuTwUmHAvK0Ajo+6RIV2JOMlRUEtMloN7E96vVfiDRwuoCY+1FlVPtX1liw8iWi/+my
	 iPbl9qokJWlHaiUtaZ8X8FVj3TEIsR/fFFEu3mRg6woKQXCGsYuwQCPlkHDn7K/YyWY+p
	 92fIO2JYHR4TtQduu5knnSsLDQ+Is8ell39XcttChDRR90uYKnooq4cAkH1hx8VbRP2hH
	 9HlksNPscsxo0mbr+CRtYa7NMGW1y7x9QB5dVN1ufemm8Wev/11caC4E6m+wJ2A2Fgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GjbKkkDORk52//+QBYEAb8jqceoli6KppBqBZ01WGjw=;
	b=5XfIX5GwO3tQA93aM2ajNzI+hy526HFedYYGfRRD9MmGbq8oKyfLdIATiUvue7EFqxGy
	 90+wolFtVKnysMfeZUAvBmtWsji1PWgcZk1qg31k1yhI8i/x4DJq5ai7R3rBJ6+cFQYmP
	 Z3nWpiuvsrxY9FxHN7ozeXAOkVxcB1QG0BvMG4TDh8mfCF6BSevO7RZGbUtSKNfLJUgrD
	 i6BmqoEqQbJaSUmDweRUbS5+WXQnww1+LSveuYvM+S9cV7krAQXCc05R4Gs8ktpP0Dqly
	 GTBCgR9w253+wjUd6c3tBP8/DDX0nifXjucxaTXTQWyZTRvkNEFHXOddcLtHIpVzSGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cHvz94El;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C20E60A2615;
	Wed, 18 Nov 2026 18:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cHvz94El
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF5E1F000C4;
	Wed, 18 Nov 2026 18:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027377;
	bh=GjbKkkDORk52//+QBYEAb8jqceoli6KppBqBZ01WGjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cHvz94ElUd1knsc4JL+nRQTf/mj75IGlDm70icpJJ2G8w2UAhwsEq6R/AE38pCgcz
	 OlPFULMTTyHEVvELzOnqswtK6sDAUSbYQBRt63Vty0s5iErjMrAfSAIDKVi7eDfvNU
	 2NVzyr9wmz/eeE5ErJ4g38Ytur3uaGCPexrCLyas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1767/2151] ALSA: pcm: Protect the unregister notifier traversal
Date: Wed, 18 Nov 2026 15:58:22 +0100
Message-ID: <20261118150226.203935429@linuxfoundation.org>
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
index a9fbbbc8986c3..62ef75115f3bf 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -855,8 +855,10 @@ static int snd_pcm_free(struct snd_pcm *pcm)
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



