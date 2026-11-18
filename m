Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049921;
	b=k/DthmwkB0S+1mR+I7MghvbyTb5uTY0Gtm2Ds9Ee21WjPrd8KWDdhwKy3mU821N+sgtM
	 K2V+f8ghYPcvffNhZGGzPD/8YonNszh+i1tGywqyDJQ18tc6R686KTXWFXNUEEMvZ0WtI
	 oYq6HrY/f3sHU2e6PI/PqszMBoLP4ThthrpKE0zzGwZ7AVlZAtT57YLbDqA6aR22HAssO
	 TNc1vbfGSerhA6bvHDfoGTRUVXMLWZZmUsbg2aH7P1sJn3nASAbyqwKL6Xyoz/zhzDaDi
	 G81ZDyCQiusd1fQCu7r2nCzcJn42/n5NXCqqAXN1dj+FD0OiGH9dFtjr+309vTn7VDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1t9PYA51RarlSh2LWR18G1ptt/U/FsonOI2p4V0js40=;
	b=UQjTiNWkmv2jtRomZFnVOCypsxr1gvYa98UWa6C2HFJflDQGhYCWG9HhUwPuDA0aODJk
	 3dde5jwfUNIV/3QCOUhIOXU/eJdc/iTcl8FJMD+wbDvRskuLWVYavrwKqfhCbM6bJAZyP
	 ZDWy+69wbY9p6Hvv5kyTTgcnhfO0Fk4JVYHeHHqmJi6N6nsWJlBdmwwigYRzYOk7oTysA
	 RIbDszQ++M25t3mRvMiS4T3hrNsqLn9fm8RDxg4KN+awsFnwPrLheM/yn37TkqFKy6kHT
	 OWWE6nC9kWFXiMU4xfEuHhPKfLauEpTYWkw+PWFXCbOcOoYD9xTkqXly/K7F/C4I5SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxLlaWCQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894CC606A325;
	Thu, 19 Nov 2026 00:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxLlaWCQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0CF1F000C4;
	Thu, 19 Nov 2026 00:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049921;
	bh=1t9PYA51RarlSh2LWR18G1ptt/U/FsonOI2p4V0js40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pxLlaWCQ444DpH/UQ8SaPOLlGlmmj2tKPBBTiOvXrXm3epBYaNcDEHFw75OwwivMF
	 noBnKG3B49VBXEBqXMlwxHZ6JIvCbJ6+wOLcZ1yH4Y3Zt764EMtVv5uJILfMhiscEy
	 GLM5CUctaCu5yFOYRn0PFKgIsueESnMouot3eG/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2523/2857] ALSA: Add simple refcount helper functions
Date: Wed, 18 Nov 2026 15:59:17 +0100
Message-ID: <20261118150332.388522407@linuxfoundation.org>
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
index 9a73c60b6f1ea..fb49bbeb59188 100644
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



