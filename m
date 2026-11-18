Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056393;
	b=0H/gXGjhGvGufZpK4tZPVZ80hHBCjVCBuLz5boIaKXgXhor7eqMLs/Rj9+4VscxeB3ft
	 K3nJeX1KswwEdxC2GcoR9v3Rw2t202FGPw1XUA3MNh7pQrkLL+1rsLzk1ugn+X1pBJ9NO
	 j+jjreLt9nUs7Nm91bc9KG89y3Ucga0YDk3vjJIsOMflMlcGhDgdK5s5zNHeAf8BRmec3
	 6ZeMDlzS9ZKFwerxU3RDl7kR0IPYJ4Df85zSxszIYrCP2O+doAIZ4p7JYsz8ckYVl60vK
	 uVjdQPtLkZRs6HLHuEJ8XcT0+SAG5diZYhI9AX3xbK8dXxfZBNhLRa4RolJ0zkZg11g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1EquYVB06iiMSm96s4JJmxeBswzACVRS36MnM0RC8qQ=;
	b=zuKtuV5ML61qiYykkBxT70whVz5MmPHbynQ/CCV6IEsh1RzzxBCoHMXFwgpk8nOpk1kV
	 ILmHHhwTtKhPGmH/+MGL5bh/G9/6BO4af9yfu/8ZQaNuOGPskk/TEXuofh3gjKM8utRMX
	 o5MvjDypoh6blcBRA0aDY4TUq0m2+VuLtRI+vwMtF6Ypu955z6Xbc9Tcb64zA2liuhwOx
	 jHfhF7lBFEQ38pLU3Jwn1i/9ur+GF0qeYqHmwD2F2JW7cpxGnf6ZsIuXUpk+RPMicF8eM
	 9VGzG5pMvZ8bNb4IGgLK1Omu/WV+87JBlKSEvZD2I/ihEhBGCYa2Az7tgeAZ9c28vJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FFeLzmu8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4F5606A31C;
	Thu, 19 Nov 2026 02:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FFeLzmu8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EB91F000C4;
	Thu, 19 Nov 2026 02:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056393;
	bh=1EquYVB06iiMSm96s4JJmxeBswzACVRS36MnM0RC8qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FFeLzmu8LyUKYw/uOMbgWx29qf2DWL25Il/uYyDTLxgn+lueJcGOwOjTeF6kWVU6H
	 8qxYhjvl6m43Rr0zyUHxMh71TC4Yw7p5ZvBRAJBflef0vF+y1OoqUP+iDKMjjQ9SN9
	 QGusHXdyNpXJIbfYe+98rN90FyWrYjgozVrAKeTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1972/2214] ALSA: core: Serialize snd_refcount put and sync
Date: Wed, 18 Nov 2026 16:00:48 +0100
Message-ID: <20261118150129.797977709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b76345c8e2e0d..2e30269a99813 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -83,6 +83,7 @@ struct snd_device {
 struct snd_refcount {
 	atomic_t count;
 	wait_queue_head_t waiter;
+	spinlock_t lock;
 };
 
 void snd_refcount_init(struct snd_refcount *ref);
diff --git a/sound/core/misc.c b/sound/core/misc.c
index 9012a23047f86..07556a38a1fe2 100644
--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -256,11 +256,13 @@ void snd_refcount_init(struct snd_refcount *ref)
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
@@ -268,6 +270,7 @@ EXPORT_SYMBOL_GPL(snd_refcount_put);
 
 void snd_refcount_sync(struct snd_refcount *ref)
 {
-	wait_event(ref->waiter, !atomic_read(&ref->count));
+	guard(spinlock_irq)(&ref->lock);
+	wait_event_lock_irq(ref->waiter, !atomic_read(&ref->count), ref->lock);
 }
 EXPORT_SYMBOL_GPL(snd_refcount_sync);
-- 
2.53.0



