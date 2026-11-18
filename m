Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032088;
	b=27CWSuXUVJ76gPqeo3VBczi/n6hkP5kSkFB8ARs6OVy6+HQQ5Kq71dy6pa3KQWlRM0Hp
	 Tomdq1YWo3dqWmo3UlBwt5zJiaZQVvNIzGeJZMm/UPGOWAH9dowF37G5lw/9/44vgDkg/
	 2/J8c86mGOaD/3LwUM3J9nk/f8T9OfUlA7dssOba4RsF6x2jol5bW15/FBMYnX4++pqBN
	 T6CltxPqZj/HXiHizHFrVJmmhwAQ+0mg33k1Fese8soHz4DyjLjATwbNMAp8C/rueNYvZ
	 jFqoaaDWCfa9ILiGW92Pm5cP6bhgBPYjOfjduSTQH3XY0u8HVW/wPJivZohteuVeu7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Yr/rVf3SomyNtnucI4XJMOQJft39lINQCrWtSP4vpk=;
	b=tN7R5zBh0NIcReX426AKepZNqbKNdHWgD6mX5z/ieAgWiVZSOurQuT5P5yL5oOSXQZt0
	 Sj23X/utNteEWSgSmP9ZccxbKjdU3McTou9WPCScV8RxmcxLrrEAEQ4JCEJE6A2grBgi9
	 lOvsKcuQKjMs7AeOlbfOefzSqorJKpo+q09WF4Lp/eE5ar/Y2vUp9nkXw3i9DG86XCQvb
	 Q7PngNXe4RKlfWxBFKwt+NGu8zMT9cMfYgBH5FZEMYrsDDLlslviSvmcS8Z39b6OyvtMt
	 71avi2tte9cYj4xzlpVu8y98rdVO3lxQfNaD5dyqtUYtfwM39yJHHngYLyYJPVr4rQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TPmqTINF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687F6606A320;
	Wed, 18 Nov 2026 20:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TPmqTINF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C204F1F000C4;
	Wed, 18 Nov 2026 20:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032088;
	bh=0Yr/rVf3SomyNtnucI4XJMOQJft39lINQCrWtSP4vpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPmqTINFH0+3Ew09IAciVlskyCksuXLkljFwOjMShmqU3kBxvlH6GHTj5AuKDNDAJ
	 W2QZUjEiQDSbDVaRE4KgCymmVRGQ4n6/mmiLnyOvW9Z7Y9cIFCreWcqavC0uAuCJTi
	 gMCwTj/m4U4Fah4VJ2MzBl+yn83e2Elu5ulH7keQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1281/1756] ALSA: core: Serialize snd_refcount put and sync
Date: Wed, 18 Nov 2026 15:56:48 +0100
Message-ID: <20261118150100.569042506@linuxfoundation.org>
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
index 9c56a7b0ae78f..e215dc1e25bde 100644
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



