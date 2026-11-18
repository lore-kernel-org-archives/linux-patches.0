Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032041;
	b=r5zuHc/kCtVLP7e01H6hcEorlMe28HfB+znK4h7t7/1wvwfl8NyPMU+G6x7pC6342zwZ
	 uHMVvIsGYIej4BAGf4XFQzPhWJV6H4R5kTZnU7/7NWoZsK5BX59k96tnSIu9BWY6qN3Qp
	 5Gf7+6R+kU+4fvo1APFD1FvbdEGrZJUTZd/0B95A8G43LCdD2QWaL2hLpjidZhDroPAKF
	 sNYkZ5tmqW7U9uGpv/wsTDspvtLdc+0YCeiBF+6uvZCN2X6idEbNRBAB9aQZfCdAdcbV7
	 6AgTe4n+RwulRFFCilkILt3dWH3UW0gHsh+nLHHMwO80tOLMOHZk/PryUIXlgBUO1xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9Jq3IXSuFd0p0eU2+BHzK01sqekh/w3ZGE1C3lb6NuM=;
	b=zjuD/i74hNQhCTtTmy6coAQ0Fj/GopSw/s6YzsZpLTM5lgGT4A3cF5OxSI06Q++jF9oT
	 /Ofm2sDKxKGAJkgjXbgNp2zxB7uFcXIYHbVmZoIx75mqfW565BiBZWZvwPYQd12bEAKxC
	 rdQrGofgEQWltJz7KRaNRF3727zpGnQNJpOxAV/HrE0T/zGWam4zJyYT9pLlxeF3ypBNY
	 QMLsugfJBDAabSpVWq0pf6L7wJScb7As/VOeD8FVA45DVWwAGqqGx7IMjNrlYLOBPVMz2
	 M0OBXNByQwoUFuXDl/gTrQc7fRCrq5YKnOthJb72b1Jv5ETdp7nSBF1oZOnQghOJJhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmNqO8do;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BDC606A325;
	Wed, 18 Nov 2026 20:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmNqO8do
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D24B1F000C4;
	Wed, 18 Nov 2026 20:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032041;
	bh=9Jq3IXSuFd0p0eU2+BHzK01sqekh/w3ZGE1C3lb6NuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmNqO8doF7OQbNGuwATtQsQK0/QMxo33DxE3m1Cy7TUZXpiZoYQ2yMLjRnxQhhB1B
	 vTbpKlvpcrBqxdV7KibrvD1+2uFoXhxWSxykQqVBNX3V9egw8YaOXjKAEDzngIRugd
	 NTP89smyMuuudB7PKKfhsmONlI+FZ6P7AfzG9juE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1270/1756] ALSA: Add simple refcount helper functions
Date: Wed, 18 Nov 2026 15:56:37 +0100
Message-ID: <20261118150100.192693344@linuxfoundation.org>
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
index 0b7aa6755e2be..9c56a7b0ae78f 100644
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



