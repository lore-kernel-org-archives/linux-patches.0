Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041755;
	b=tey+X/eqjOzYl6BmTo8p6mlBvipT23U6Xoq1sJbkh7mg6nZZ2dXZIjOCQPmzO6JJ7DA8
	 60maZY+AzQ5F8oxONmq2h3AvpK5WG0iesFjRUSdHmAmPhK5H+5kU3uF4F24ZtsCrmhWGm
	 1GBW1Jwc+axToVf/MpCpeQqTxqAMfR/ymK4gWIfAHYVycnfu7qH3RrPHAKTmPp5X67dWZ
	 68P4Jy31FYrSALnLzYo539CNk1Akeydq8E6jnLYPlah3sG8SXC1XhLt9TbWGtVuUuPVsO
	 d0M+jVNIghD7VSTZkXDkxADSBjHpq3R763ifZyIlbOkBzMBE+HUMF1Q9ujBtTboxBJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W+nX0MmcwJFvuo16jV731MB9NAS+uM5/lWaAyzsEvIw=;
	b=gmfDkUJEITc06KmzItIGdPOQZyrujsQQVZgrHg0n2oGf3djpGtGBGsRuO1fCKmR5qO4n
	 y8vRHVFRxwMLHpJ4RKvHjqmPiS18efGwfIAARrlIY2KIJkmz2RwO3IVOKfgZHuACGWz+G
	 5GFnntL1XDryzTPBIAF7XAKtlTDpiBDURMwRE+6C1mz5K/vlS383cSceuDQEIBwfc1F+X
	 MD609NZisbvxiZ8ZuDSZhFI/jangdwhnTm3BQcn3FLyYiBINDUofvF9ubGS498uKFVERX
	 cVOUYAsWPhLQms0JYpI0GyWxgj+1ur+IQ5/GCNOACNb7VauMnmF/DzEABGDR4bnndSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="X4/6agfw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DCC606A31C;
	Wed, 18 Nov 2026 22:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X4/6agfw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2321F000C4;
	Wed, 18 Nov 2026 22:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041755;
	bh=W+nX0MmcwJFvuo16jV731MB9NAS+uM5/lWaAyzsEvIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X4/6agfw284U3/pgNL+j7OwVkxvYpySUUkwXdFLWHEzM3Iot+k0JILu5dLo9m7gVG
	 cfEVMWKYHn1BPVnZ+09ogRZKe5EWdSlaiFtoJVIj4CDU7v6UW+1FXuj6lsb81JMCTS
	 Ot5kyDt447GLRsGic82QTnUmOHHaitMHgSBEd9q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2926/3318] ALSA: core: Serialize snd_refcount put and sync
Date: Wed, 18 Nov 2026 15:59:08 +0100
Message-ID: <20261118150448.179074380@linuxfoundation.org>
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
index 11784021da3a7..0e25aedb724b2 100644
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



