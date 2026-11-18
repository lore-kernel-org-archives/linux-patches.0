Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020614;
	b=W2Ees2qvahNHkNHHgT5Zks+3tgiMTlTocknrUjIam9o8znKusgLjSL9vp9YDQ9ENWhrF
	 JGI+ZrO1N0oV37EA2flncm5FbZN+FpXXTKUd0kNJDUXhMU7N457VEhalCxBxCUEpQPDt/
	 GgR1esoZUiOGutiACGu9lANOzaZU6TWyMK3rFqfF8QzGiyi+ZDvxbZ60fSf43+3+klq8z
	 lzlsCVR+/mXsXG2Q4E7A0CFgYLlEKTH80y1u/rvYih6MdDRANhhfuFZRj7JFmxQUDJD56
	 ykDagPGPmij4dEvS1ae53KloEvTKXJuj2r72gNKgs+08L2rUDSK7bt0NZ0hizuMunyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EMc39RJQrDFdSysBAz05aVOqOImVMHmuM7+F5H/lMQI=;
	b=kT36jrS7FkTukL55atx014NiM0sbKy1wosAs4hYAStFedO3/S3qOvMzBukXtuNIb3wpb
	 SaEvDrjR+ttwBeZXWLzVkJmKqMrB4DVZrN+YNm41EA3UTYf+cxR5PUuq+xpDZF7NUyobf
	 Zt4avNZAxX7A52tg7k0nupj6QGVDWaD8SQ9xZx2el+aSg/LSNzCAbkpybnOBFpsBFuT56
	 IJx8jrGccQ54YrBj3tJvaldH64OkLmFlNI52OVq8cGN8MN/0jeoGkbLs3uIarw80+46Uk
	 QmcbqX3F5G8qq4tAEpFOxOkBbNyxY+TE0p4gWMSLu0DdA2fskgaRYYI/w0qxnMQSkcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lJOY/N/m";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2851260A2601;
	Wed, 18 Nov 2026 16:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lJOY/N/m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1411F000CE;
	Wed, 18 Nov 2026 16:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020614;
	bh=EMc39RJQrDFdSysBAz05aVOqOImVMHmuM7+F5H/lMQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJOY/N/mhHbIKGRWlyh8DgEK/oplx7AOwJBLaF9s8zq0yttv0CJUofU2Jl6FyghJr
	 dXIOfVMOh4vjF+xCoWGWLGfz7xaslM340NSORQxJ5hXfn/S7yoY/IhM2VaKLAiBfZ7
	 /hew5h6HMyFO56fJPzFBBRnltl96MjykyXxU1do8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1974/2651] ALSA: core: Serialize snd_refcount put and sync
Date: Wed, 18 Nov 2026 15:53:34 +0100
Message-ID: <20261118150357.507566059@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 6904743ab77e0684dff319f3806ef982e5eea6cf ]

When a thread tries to sync-and-destroy the resource with
snd_refcount_sync(), it might lead to a UAF in a very slight time
window.  Namely, snd_refount_put() calls wake_up() after
atomic_dec_and_test(), but wait_event() in snd_refcount_sync() checks
the condition via atomic_test() without serialization, hence the
thread that called snd_refcount_sync() can continue immediately to
release the resource before another thread calls wake_up().

For avoiding the race above, introduce the spinlock and take it at
snd_refcount_put() and snd_refcount_sync() in order to serialize the
operations.

Fixes: dcca9b6064c3 ("ALSA: Add simple refcount helper functions")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20261015071838.31082-1-tiwai%40suse.de
Reviewed-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/20261015112256.3902-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/core.h | 1 +
 sound/core/misc.c    | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/sound/core.h b/include/sound/core.h
index 15be947a730ef..bea596f36f58e 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -84,6 +84,7 @@ struct snd_device {
 struct snd_refcount {
 	atomic_t count;
 	wait_queue_head_t waiter;
+	spinlock_t lock;
 };
 
 void snd_refcount_init(struct snd_refcount *ref);
diff --git a/sound/core/misc.c b/sound/core/misc.c
index 066fb9ecdcdc3..6fe199e76e837 100644
--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -183,11 +183,13 @@ void snd_refcount_init(struct snd_refcount *ref)
 {
 	atomic_set(&ref->count, 0);
 	init_waitqueue_head(&ref->waiter);
+	spin_lock_init(&ref->lock);
 }
 EXPORT_SYMBOL_GPL(snd_refcount_init);
 
 void snd_refcount_put(struct snd_refcount *ref)
 {
+	guard(spinlock_irqsave)(&ref->lock);
 	if (atomic_dec_and_test(&ref->count))
 		wake_up(&ref->waiter);
 }
@@ -195,6 +197,7 @@ EXPORT_SYMBOL_GPL(snd_refcount_put);
 
 void snd_refcount_sync(struct snd_refcount *ref)
 {
-	wait_event(ref->waiter, !atomic_read(&ref->count));
+	guard(spinlock_irq)(&ref->lock);
+	wait_event_lock_irq(ref->waiter, !atomic_read(&ref->count), ref->lock);
 }
 EXPORT_SYMBOL_GPL(snd_refcount_sync);
-- 
2.53.0



