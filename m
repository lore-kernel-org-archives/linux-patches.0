Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032417;
	b=jOCy44bAH6xNPknXBtpjq6dO+zSWEfofLUjN6V6m+OTgXkBRp+r8YW/5ZfCHiUQRxDgs
	 +fonh4ivRl9poqqTmQGTXJ8783qvcmn3hdpY/KreCm3QHEdcDkAjHpZ69vfYXRdVxqtdO
	 ERZeBGBfqNwNoe4OPJQEbDJ6v10dhqmEsLrrKoGljz1CZCDQ5f6np2jT4IQAKUcxTFLjt
	 9Nq7QwWev3HWjlmnnmUAZnobNqMl6XZhfBmiW0KghWeC/YNWmBr80Z1iw7LVfbhoqeYKD
	 co80Fu6PiaqLa7mArFsXW6flDHX66S9+xbrIzFl+LXSZlHbuSfSpFSk3FBFZwIQqDZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SvK98TS5uJwt51JZhunCBV+kvNjPt6M9TPLP9A+xVBE=;
	b=jvZ+pUtb4G7lfgis1Ha3NPcVB62ctPw8GAskB/I0Q9kv2gORRBHnEjQwV+433U6mSLwM
	 ohWb9nGO1EUod4Z1ezDUXIdvQmh+ZNL/I/P1eh/796KRyTVe4QYXER0OSXc917ED+c2mC
	 aFRJvhiSjh/RUoizJPxOME0y7RePOuvzrt9LMMf2DT8FrGTzxbaKSDswxo8U4tegY5WsP
	 nEwHVKpE482IS9DSIQtdAyT7qo/VczQsI3zHhMKSxoVL/Jb2klvSyJhhzesl7CYb8uFpw
	 nDeXLS23OPaMGiusshs0Kk4yRxsQs4mmocoaYvC5g8cf+p1akUEmgzz8vZEwrJ5F9Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+UtEZ14;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98EB606A85C;
	Wed, 18 Nov 2026 20:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+UtEZ14
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EE61F000CB;
	Wed, 18 Nov 2026 20:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032417;
	bh=SvK98TS5uJwt51JZhunCBV+kvNjPt6M9TPLP9A+xVBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+UtEZ14pURx/PM71QWGSqYCzh67gENwucu5VteWWfCLRyofEgWns9RXFvnIPu+/T
	 1GpsPCGx3yFiRKhmnAVckwMHWO/c0iC3yWOYIqjeM/+SQnc5LylZ2fEDQAk1JU80fa
	 Rx2uASh6ZxL5i/fwGxuoJeuuhcdgzPzXul7UG/1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1404/1756] ALSA: pcm: Protect the unregister notifier traversal
Date: Wed, 18 Nov 2026 15:58:51 +0100
Message-ID: <20261118150105.074186101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bc4f90874ce3a..fbaac30ab32e3 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -857,8 +857,10 @@ static int snd_pcm_free(struct snd_pcm *pcm)
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



