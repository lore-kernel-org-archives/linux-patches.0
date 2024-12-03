Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2961F7071;
	Tue,  3 Dec 2024 15:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240308; cv=none; b=WpAXbZ/7SMoynRyKd7nzYayNphBLB+bYVhfeJ85PK43dBiLIxuBGyYruV8FAXi6DwAqP0nQIbkS4bh9v1xm+GBG7fIO2tYslOu/SWe1v+wiJ9TiRe4/Kq74qTs/G+RWt0/iXcMyktnkY8abWeRWqNru0GelFT8Jx6aH57GRNnOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240308; c=relaxed/simple;
	bh=kCykv8wtRFKguBE5ap5sa8ZZCg+JhUmlXEPCGmw+lCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r045mokljALxdm6K0uZquMntOL61pR2bAsQB1mJU7cev5caij72xVKD/G9OIy7h+rRTVdAmLze7tLejvyPb9mnynrSxFW1WjIgG8Qwg9e//1n9oCdXuzO9iEv6ptn/kmd1dJ3tEqKeNXkWAp154BXdu7jFxAqGV5ZfomQX6/BMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/SIf+AB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/SIf+AB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDB7C4CECF;
	Tue,  3 Dec 2024 15:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240307;
	bh=kCykv8wtRFKguBE5ap5sa8ZZCg+JhUmlXEPCGmw+lCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/SIf+AB92ucfgGspUR7G8ud3Q5MsyxtJPc19xHcQjJINELBiyXEezV2eK4DffSFm
	 gtiPV2kvoxO+Ady83FMgDbJOS8JybQvpcsOCf1iyw36NO/7ic3wRTKd6syMEq5eEWs
	 t9KfZwdiCTql9d8np8izKEqa5/JS3A1jec6RmFt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/826] locking/rt: Add sparse annotation PREEMPT_RTs sleeping locks.
Date: Tue,  3 Dec 2024 15:37:01 +0100
Message-ID: <20241203144747.398507244@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 52e0874fc16bd26e9ea1871e30ffb2c6dff187cf ]

The sleeping locks on PREEMPT_RT (rt_spin_lock() and friends) lack
sparse annotation. Therefore a missing spin_unlock() won't be spotted by
sparse in a PREEMPT_RT build while it is noticed on a !PREEMPT_RT build.

Add the __acquires/__releases macros to the lock/ unlock functions. The
trylock functions already use the __cond_lock() wrapper.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20240812104200.2239232-2-bigeasy@linutronix.de
Stable-dep-of: 5c2e7736e20d ("rust: helpers: Avoid raw_spin_lock initialization for PREEMPT_RT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rwlock_rt.h   | 10 +++++-----
 include/linux/spinlock_rt.h |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/rwlock_rt.h b/include/linux/rwlock_rt.h
index 8544ff05e594d..7d81fc6918ee8 100644
--- a/include/linux/rwlock_rt.h
+++ b/include/linux/rwlock_rt.h
@@ -24,13 +24,13 @@ do {							\
 	__rt_rwlock_init(rwl, #rwl, &__key);		\
 } while (0)
 
-extern void rt_read_lock(rwlock_t *rwlock);
+extern void rt_read_lock(rwlock_t *rwlock)	__acquires(rwlock);
 extern int rt_read_trylock(rwlock_t *rwlock);
-extern void rt_read_unlock(rwlock_t *rwlock);
-extern void rt_write_lock(rwlock_t *rwlock);
-extern void rt_write_lock_nested(rwlock_t *rwlock, int subclass);
+extern void rt_read_unlock(rwlock_t *rwlock)	__releases(rwlock);
+extern void rt_write_lock(rwlock_t *rwlock)	__acquires(rwlock);
+extern void rt_write_lock_nested(rwlock_t *rwlock, int subclass)	__acquires(rwlock);
 extern int rt_write_trylock(rwlock_t *rwlock);
-extern void rt_write_unlock(rwlock_t *rwlock);
+extern void rt_write_unlock(rwlock_t *rwlock)	__releases(rwlock);
 
 static __always_inline void read_lock(rwlock_t *rwlock)
 {
diff --git a/include/linux/spinlock_rt.h b/include/linux/spinlock_rt.h
index 61c49b16f69ab..babc3e0287791 100644
--- a/include/linux/spinlock_rt.h
+++ b/include/linux/spinlock_rt.h
@@ -32,10 +32,10 @@ do {								\
 	__rt_spin_lock_init(slock, #slock, &__key, true);	\
 } while (0)
 
-extern void rt_spin_lock(spinlock_t *lock);
-extern void rt_spin_lock_nested(spinlock_t *lock, int subclass);
-extern void rt_spin_lock_nest_lock(spinlock_t *lock, struct lockdep_map *nest_lock);
-extern void rt_spin_unlock(spinlock_t *lock);
+extern void rt_spin_lock(spinlock_t *lock) __acquires(lock);
+extern void rt_spin_lock_nested(spinlock_t *lock, int subclass)	__acquires(lock);
+extern void rt_spin_lock_nest_lock(spinlock_t *lock, struct lockdep_map *nest_lock) __acquires(lock);
+extern void rt_spin_unlock(spinlock_t *lock)	__releases(lock);
 extern void rt_spin_lock_unlock(spinlock_t *lock);
 extern int rt_spin_trylock_bh(spinlock_t *lock);
 extern int rt_spin_trylock(spinlock_t *lock);
-- 
2.43.0



