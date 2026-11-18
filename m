Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049941;
	b=ObPF/vpny7DCjjdDoAo2ehyc5w/T6X2ZTppXaNGn/0Wbg2QS9fQStWnxV9sViwGfLEc+
	 KgjguWmOFtNmYewcFJVhW9qtvTLg2iVmtVSx+rLWOO7esAL43uhakTaukTZxumTQxptRH
	 uRaVbAwPDME2Q4I3i5N5ZzsgbuJiM9aeu1KxJ/3GKQATcBA3sGEhBIzDzlKADSrbg7bOm
	 8Zd+cZP1VkjMLFEGqyyOwJ/HKfPLjAAEVY3t8k73LBIIyrdyFjiKR9ryeY+NfODMmT6vl
	 2kb6HTKGuU65tSw/SkURLtLfls0pJqVXb9KmLgvFtcmjrlpM0zk6jzJX22IilAvBDIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M6kdnGsLdk9mNe5d8XvUmAgHsGtqyBa5NnRg4iXo83U=;
	b=hLGDb+LSFhx8Y/ZgVTh60KtGTJKYGVlKBXt2T0FO2fAbM5KjPE4GyEW64pbT2q7qw4If
	 /bu30JNY5uErc8vuBLoyG1Z5mCd6EthetfuPwSjncxUiCL4gR5x+zypJbflnPbo7CIDmK
	 Df/6Y96PU7EwyyUqWAeBiNLPk3xeJu6ZsJ4hQ0Xw6meUr66nZoL9OmROYXdDDAkbIJJP6
	 CJIn4P2UxCBDXoC39o9uUHwNCf0D1ClchLdQJnIM7Q4FPj1hSCGvEu1RyVHd7+mAaa47Z
	 8VYii+xj6TZPAqE8Ad5gcR/BU3+uan2SpUM5xIpSVJ0e8F8HoWhHm33hZ36Z5+rmSqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JKKQWLS0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322A7606A320;
	Thu, 19 Nov 2026 00:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JKKQWLS0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885331F000C4;
	Thu, 19 Nov 2026 00:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049941;
	bh=M6kdnGsLdk9mNe5d8XvUmAgHsGtqyBa5NnRg4iXo83U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JKKQWLS0EK19+vyoxKqg+OoeVCwgzSH//UVZaYKgo0ItSrV3nqY3L+Q8vI/yVjovt
	 HIz4WXIQJe/Duyl2Y+OBaC1oOVR6oeoypMronuQiiICUWtqHYmWMF+X4O7ofMro2d4
	 GbX1MUSbtmpG7GFXFJdbNsFdE9f9hSxxSS3VVny0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2530/2857] ALSA: core: Serialize snd_refcount put and sync
Date: Wed, 18 Nov 2026 15:59:24 +0100
Message-ID: <20261118150332.631545498@linuxfoundation.org>
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
index fb49bbeb59188..3a0e3010405ca 100644
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
index 19ad0a2cc7e1a..b44bcce7a220f 100644
--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -254,11 +254,13 @@ void snd_refcount_init(struct snd_refcount *ref)
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
@@ -266,6 +268,7 @@ EXPORT_SYMBOL_GPL(snd_refcount_put);
 
 void snd_refcount_sync(struct snd_refcount *ref)
 {
-	wait_event(ref->waiter, !atomic_read(&ref->count));
+	guard(spinlock_irq)(&ref->lock);
+	wait_event_lock_irq(ref->waiter, !atomic_read(&ref->count), ref->lock);
 }
 EXPORT_SYMBOL_GPL(snd_refcount_sync);
-- 
2.53.0



