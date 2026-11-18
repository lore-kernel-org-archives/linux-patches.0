Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041710;
	b=rEK2AssBsqDwUEmUWYGblc75N4NmISRVHEvoDLMwmbYKzi31a/+mZD3uGfhDsgfBHEkM
	 0jPMI+YLscUCtcxt+b1vkBl3cVvEPG3kDvNQNSOjkm1pAOuSF6/6kKjw8EPQggfq4M9e6
	 U3Cu7v5fL2oVnUIYe8dUIw8BhdH7xkTgRLKxSBairtwrCaVTN11B5SLKk8aoHjqx9BSyF
	 XUpYAm2/qOvzq7XzN75yQgUgu9PeShIHG/e9zadQA8NQ/LsyHwVM2ki1G8kYkxbjLSYM4
	 SIbbvb2XVgliEMjcb9oukNyTMNA0hjWwEsB8ELuKD7vXCriBva+JkXspaVqSlFVKnug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TVO5w2K35hYAMTVfTPRl9oEmEDK1RnWkRmpCIDPwcM4=;
	b=IREA7b6UKVw3nfEJQ4eWb+eag1UNHjqWPzee6kgrwoNFjU8jhu0K/iByZt+AL9Gi8Gvh
	 +2rAT1lCfrDZ2KQH6kJmrc8AxcO7B1WAQatYmpCvnmF+8tYp9eLPgTuQ1MFeX+BKiIg7V
	 oXcD+V1BnA6fXFL6aLkcg45RqrovVSRg9tuF9Fp6wflzOFM6Mbn5LKMDsh42AYv8uuNAQ
	 oNw7IADfgSpL7n5KBkTJg7LSrQccfKidl4wYTo7Jv9gkmdVtoBfnBmtbkSD3fD2mbXFJT
	 7bhpIe6pX9pgIl9GeSq8FS9wopWooQgDrFkdZRd3kuIPEXA/tAuR89LM1WHX9j/ND9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tQ9VBo2X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B898606A325;
	Wed, 18 Nov 2026 22:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tQ9VBo2X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47F21F000C4;
	Wed, 18 Nov 2026 22:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041710;
	bh=TVO5w2K35hYAMTVfTPRl9oEmEDK1RnWkRmpCIDPwcM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tQ9VBo2XSuvnTv05J8W/rnZp9q8psmJ+3Xc9HgBwJVMyMqOtgWbK5Rw4+woFJstln
	 Afy2YyJ0th2ao+4duEndTraALs9yAzbP2ZBrzkhtXukhOTeRU1woIbnAl1PCjjpARg
	 2Nn7tMOTjIb+IL1/P745/UqmyogXO5F7L7VQVrL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2911/3318] ALSA: Add simple refcount helper functions
Date: Wed, 18 Nov 2026 15:58:53 +0100
Message-ID: <20261118150447.783724797@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit dcca9b6064c33c84fbeb9f09814178a206321249 ]

There are many open-code to manage the same pattern for refcount +
wakeup sync at closing.  Let's provide the common helper functions to
replace the open-code.

- The recount is kept in struct snd_refcount, where it's initialized
by snd_refcount_init().
- The user can simply reference or unreference via snd_refcount_get()
and snd_refcount_put() functions
- The user can wait for the all usages gone by snd_refcount_sync()

Note that here we use atomic_t instead of refcount_t since the current
users allow reusing the refcount after sync again.  The design of
refcount_t prevents exactly this behavior, so it doesn't fit.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260610154538.51076-2-tiwai@suse.de
Stable-dep-of: 91d0048a97e0 ("ALSA: pcm: Add refcount for races between drain and unlink")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/core.h | 21 +++++++++++++++++++++
 sound/core/misc.c    | 24 ++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/include/sound/core.h b/include/sound/core.h
index f9d85dd653066..11784021da3a7 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -75,6 +75,27 @@ struct snd_device {
 
 #define snd_device(n) list_entry(n, struct snd_device, list)
 
+/*
+ * A simple reference counter with a wait queue;
+ * typically used for usage counts, and you can synchronize at finishing
+ * via snd_refcount_sync(), which is woken up when the refcount reaches to
+ * zero again.
+ */
+struct snd_refcount {
+	atomic_t count;
+	wait_queue_head_t waiter;
+};
+
+void snd_refcount_init(struct snd_refcount *ref);
+
+static inline void snd_refcount_get(struct snd_refcount *ref)
+{
+	atomic_inc(&ref->count);
+}
+
+void snd_refcount_put(struct snd_refcount *ref);
+void snd_refcount_sync(struct snd_refcount *ref);
+
 /* main structure for soundcard */
 
 struct snd_card {
diff --git a/sound/core/misc.c b/sound/core/misc.c
index fd891a3ceb963..19ad0a2cc7e1a 100644
--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -245,3 +245,27 @@ void snd_fasync_free(struct snd_fasync *fasync)
 	kfree(fasync);
 }
 EXPORT_SYMBOL_GPL(snd_fasync_free);
+
+/*
+ * generic refcount helper
+ */
+
+void snd_refcount_init(struct snd_refcount *ref)
+{
+	atomic_set(&ref->count, 0);
+	init_waitqueue_head(&ref->waiter);
+}
+EXPORT_SYMBOL_GPL(snd_refcount_init);
+
+void snd_refcount_put(struct snd_refcount *ref)
+{
+	if (atomic_dec_and_test(&ref->count))
+		wake_up(&ref->waiter);
+}
+EXPORT_SYMBOL_GPL(snd_refcount_put);
+
+void snd_refcount_sync(struct snd_refcount *ref)
+{
+	wait_event(ref->waiter, !atomic_read(&ref->count));
+}
+EXPORT_SYMBOL_GPL(snd_refcount_sync);
-- 
2.53.0



