Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026882;
	b=HiCZkoOZwOxXPYfFq9gXbQC8R56LRPsWuek/wKTVN7+S1XHymPM/8YvXlu7Az9NjQ/4a
	 AKyH0y8veYT8ObJwDOfrUTGu25/DIRluB8sQXnoUeO/3jpKR8e8rrcZkHHl0TBjG3cLAy
	 mS0+l9+r4SeXF6Slzvoz6N761wpLeMtyfx6lLvED/d6L5WgvgQ++BwT/nVOxOKSPGORaL
	 fLQYRJJzkI8G97xz/6rwouixOYdNA6XxOi/7aIqAZzbFWBXKqukzHHrLlMVGKKqiHoEVI
	 dHXNXemnB7XuJdDahMTekI4k/9UXLW1qOu0jFHbtyhHayNpZZ17tjLmV4GehoAGLzuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XZvwspPIkV5BguqlXpaGMIsm6zjjfVn6UgcWwX7+SmY=;
	b=qLZk1DlGeUQ2ymPxoFd6EfqgOwN9SejzI9a/CwCb/YQsApz1qH9azktMQUV0e836kdqb
	 e9RkPOVfnETXV6CLpr/0OvztrlGgJB8G4PX/C7Qn0WlWrSb6BYSADRterffNSM15XMwRv
	 AzXT/7zGjztsnLZ7Gpwyf31XRxTmTIOO/gQFqB3nwuMuGFY2r+mt6cUI2bqgmAzeON5cu
	 JdIy2zGynOa4WaSmHYmGdv2zCmRrfJyqnFgE/bPUS4zBdCP0j1N7GXKuJreqTfgZ3lWHe
	 ZcjR3Pau+4Yydokj/a6ccDsU9iZUupTO25uk2hCJRfGrOGwlB4aTbzAAMzE0mNFnrdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L8UMQPgs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D759F606A32F;
	Wed, 18 Nov 2026 18:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L8UMQPgs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DA61F000C5;
	Wed, 18 Nov 2026 18:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026882;
	bh=XZvwspPIkV5BguqlXpaGMIsm6zjjfVn6UgcWwX7+SmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L8UMQPgsTn+qDv0xkbHppfhS5YjDNgep+jjL1mJUt4ZkQketrnE021yUB8fJW1jIY
	 g4uww884/Zunl65/Hb6IFlrX0lygIH2SPsgPZgblo3olj3vV6mFs5xktn0IttHZtUF
	 C5rBYVGycDtkchr0b6XktB8uGNwPhGbbmQh/vEKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1592/2151] ALSA: Add simple refcount helper functions
Date: Wed, 18 Nov 2026 15:55:27 +0100
Message-ID: <20261118150219.874342167@linuxfoundation.org>
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
index 0b7148b0d9d75..563fe6ad20252 100644
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
index 833124c8e4fa8..4772b2a3b808d 100644
--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -174,3 +174,27 @@ void snd_fasync_free(struct snd_fasync *fasync)
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



