Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84E830C353;
	Mon, 13 Oct 2025 15:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368414; cv=none; b=ih3irrCjCLmlyZHE1MhTaoqFB0YIzlqSe1PYkj7SMLTWmcDiw/b+6ZjC3VwavGvShB7+lh0no63alE8aaST18Ywb86t1ADwIVKuaVJJo/otIQW9Pe8srGqtedr9az1/HnbCj/Sdo6K2735no1vSjZuXy+mej5tU8W2emkoCx1GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368414; c=relaxed/simple;
	bh=IMFFuu+ZGUjm9c+Pjsy5mUsLr05PUnYeQwxb1duNttE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVe3rItmyzgZufWxAQn46wKLX9YQin/8xzNClepy5a2SK8jyOzCu/OLp0xEziKwAzxjatoyTR5sAODfXsRhu1I/qiswHPkjN86RFROwIXUg7f+PqwRvNaP66kbYLEKRdCvQuxyR9GwPsmV8NZbnMVi0cKEVEtl3PyUqUBz7rq7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JcfbJp8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JcfbJp8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411D6C4CEE7;
	Mon, 13 Oct 2025 15:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368414;
	bh=IMFFuu+ZGUjm9c+Pjsy5mUsLr05PUnYeQwxb1duNttE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JcfbJp8X8Yiwhtwn1/6US12L8eB97jScdQwgDeKjcpil3HEhayNa1hXxRZd1Ex78d
	 Cq5Me2ZlOUXTIcyIzTpX//S9fDKCSodxGj2QnhAcudHFuYERipx/fkkNW9XLSEDzqS
	 HVoTXxoAsYHZy4L9T6laDR2CYNQNFzLhKrQbr6bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+10b4363fb0f46527f3f3@syzkaller.appspotmail.com,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/262] ALSA: pcm: Disable bottom softirqs as part of spin_lock_irq() on PREEMPT_RT
Date: Mon, 13 Oct 2025 16:44:56 +0200
Message-ID: <20251013144331.665675700@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 9fc4a3da9a0259a0500848b5d8657918efde176b ]

snd_pcm_group_lock_irq() acquires a spinlock_t and disables interrupts
via spin_lock_irq(). This also implicitly disables the handling of
softirqs such as TIMER_SOFTIRQ.
On PREEMPT_RT softirqs are preemptible and spin_lock_irq() does not
disable them. That means a timer can be invoked during spin_lock_irq()
on the same CPU. Due to synchronisations reasons local_bh_disable() has
a per-CPU lock named softirq_ctrl.lock which synchronizes individual
softirq against each other.
syz-bot managed to trigger a lockdep report where softirq_ctrl.lock is
acquired in hrtimer_cancel() in addition to hrtimer_run_softirq(). This
is a possible deadlock.

The softirq_ctrl.lock can not be made part of spin_lock_irq() as this
would lead to too much synchronisation against individual threads on the
system. To avoid the possible deadlock, softirqs must be manually
disabled before the lock is acquired.

Disable softirqs before the lock is acquired on PREEMPT_RT.

Reported-by: syzbot+10b4363fb0f46527f3f3@syzkaller.appspotmail.com
Fixes: d2d6422f8bd1 ("x86: Allow to enable PREEMPT_RT.")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_native.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 9b91f68b3fff0..d15de21f6ebf0 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -84,19 +84,24 @@ void snd_pcm_group_init(struct snd_pcm_group *group)
 }
 
 /* define group lock helpers */
-#define DEFINE_PCM_GROUP_LOCK(action, mutex_action) \
+#define DEFINE_PCM_GROUP_LOCK(action, bh_lock, bh_unlock, mutex_action) \
 static void snd_pcm_group_ ## action(struct snd_pcm_group *group, bool nonatomic) \
 { \
-	if (nonatomic) \
+	if (nonatomic) { \
 		mutex_ ## mutex_action(&group->mutex); \
-	else \
-		spin_ ## action(&group->lock); \
-}
-
-DEFINE_PCM_GROUP_LOCK(lock, lock);
-DEFINE_PCM_GROUP_LOCK(unlock, unlock);
-DEFINE_PCM_GROUP_LOCK(lock_irq, lock);
-DEFINE_PCM_GROUP_LOCK(unlock_irq, unlock);
+	} else { \
+		if (IS_ENABLED(CONFIG_PREEMPT_RT) && bh_lock)   \
+			local_bh_disable();			\
+		spin_ ## action(&group->lock);			\
+		if (IS_ENABLED(CONFIG_PREEMPT_RT) && bh_unlock) \
+			local_bh_enable();                      \
+	}							\
+}
+
+DEFINE_PCM_GROUP_LOCK(lock, false, false, lock);
+DEFINE_PCM_GROUP_LOCK(unlock, false, false, unlock);
+DEFINE_PCM_GROUP_LOCK(lock_irq, true, false, lock);
+DEFINE_PCM_GROUP_LOCK(unlock_irq, false, true, unlock);
 
 /**
  * snd_pcm_stream_lock - Lock the PCM stream
-- 
2.51.0



