Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026931;
	b=JiCTyIoaPKh+FJS1Np7mPVkC6O+iWFeUoVf8fLz/N+ZOTRKkwal+oCu3py3K+n77AMsN
	 ONmDRW5dcwL2roThYA6WkBiL7HwB2b+zQyyEoIq4ykBPTLWHs4CRelKlHNRm2hnVC5Zwj
	 Ltb81+UaBL1eZFVtOHRazB+b/4LTMod7VTK3Wx8Zk2CEVX6LQzfjZJjILi8cyLFOlMw4t
	 D1qHahHLQli/GxJm7maYsQXxNYm3qRnn2dPn4nt4JtYg/QeIjpTsBrTnhs21B2q2vIyd6
	 wIJQHr6QPA8NeA8RBPV4h/3UJmszzICUDvVsynq4cb9/aYRTA8OCEueWf5b8BXQglew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FGk1r3pm7owKoLzKsozXKtqNo/+3x6l2IzcE4sFVxdM=;
	b=SpN10rwKkXmTuyR3nmLdr5crDowO3g7itnkAQy0EeLVpdP5iQ5qkqQxQ5q224U2enNzn
	 c4PP6DiWvZPwSwOQrcoHmlleC+Ki6a2mEoohjBbJrS05bwz3diGcAZ3S/Rty08l0POghF
	 NVfP3pIAVLI743hssf7lbs029geYVYaTZEdc/8jr0s9LFmTpev9liwF+ZAUxHXCik4TLB
	 n/TeoDV2Q2i62hxry4KPUXMVFurgUaSHBCYP/ana+p4z80sxfECPNoNQ3QxT3l4tCEY/n
	 e0DfU7WM0jhOlj7vuyroQ/fweaZ+uqeVSX5w4jDijfACfKwIvLxRM33R58p8VU0+H5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zZx9G5dx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CF8606A33A;
	Wed, 18 Nov 2026 18:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zZx9G5dx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BE61F000C5;
	Wed, 18 Nov 2026 18:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026931;
	bh=FGk1r3pm7owKoLzKsozXKtqNo/+3x6l2IzcE4sFVxdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZx9G5dxWjF37jfIxD8s9zTj0u3KBagstYowIx32xZVTeoMSwr5tbRxgoMUplmNXP
	 VPOakFFlbSw4NV3+8xYyC8NsAsdHyWiZKH7QeTawYz6x2lLG/O/u5duKV55qxvM6cD
	 pQGB3Aw6b2gvDiEzA0HqkjsAzCdH9Ef+dnbZex/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1611/2151] ALSA: core: Serialize snd_refcount put and sync
Date: Wed, 18 Nov 2026 15:55:46 +0100
Message-ID: <20261118150220.557730416@linuxfoundation.org>
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
index 563fe6ad20252..25dc738345d18 100644
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
index 4772b2a3b808d..9d59e95222ae1 100644
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



