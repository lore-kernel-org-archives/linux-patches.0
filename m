Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C304E3EAC83;
	Wed, 20 May 2026 16:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294460; cv=none; b=OrnXHKuqp0RQa4iFrYDTzmqQv6ajX/YPUrccYT2IvHzlZF8Mc6OnFBAvp1/5Y7a1GAWcw7sTPFF9GH6fFKKAzlojjF4Nkl9zQlILQClmgw55t01mLBN8G2pFWXEYdWcOwCamF8bW0k1REEQuxaxSCCnN9qkQorICAtigyvWp1F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294460; c=relaxed/simple;
	bh=FGH4ZJfjUqLY/MYhF8Lz6crjMVBpx+dM9VBj05L3gts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXyud+WFc0oZHlO9UJZNynemM1fpn8UWj2NK8pvMo0Zx8msBOmNuH4cC8QaQhmuqrVjlObicGBtr+gBWRzgejMkTo3+YRHvEixP2u7Osd6RfNOy2eSCgpY4FJ+gtNjmP9Ywe+I9DTTvEHPGtOLI8boaMzruNuspOGhGOBoJwvoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nIZ0Brny; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nIZ0Brny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109C41F000E9;
	Wed, 20 May 2026 16:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294458;
	bh=83GwyVpQn66mcM7dfwqIRoMgx+ycTiPqh72qFVF7zvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nIZ0BrnyoP0DrgOySUn4cCFdM8/MImhGHTa6yvKEmiD4X61LwvHuKlA8VCpMPqkKs
	 bKmWD6RusXUUDhivyDDv61OpbQfilOVwbRhoJzTPthY/ySLtz+hc1NDra2c8xHE2JH
	 KBdxYN3x7vPcMOlrF7unGLaFrq5wJathGC/TTPXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0048/1146] locking: Fix rwlock and spinlock lock context annotations
Date: Wed, 20 May 2026 18:04:58 +0200
Message-ID: <20260520162149.464230111@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 38e18d825f7281fdc16d3241df5115ce6eaeaf79 ]

Fix two incorrect rwlock_t lock context annotations. Add the raw_spinlock_t
lock context annotations that are missing.

Fixes: f16a802d402d ("locking/rwlock, spinlock: Support Clang's context analysis")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Marco Elver <elver@google.com>
Link: https://patch.msgid.link/20260225183244.4035378-2-bvanassche@acm.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rwlock.h         | 4 ++--
 include/linux/rwlock_api_smp.h | 6 ++++--
 include/linux/spinlock.h       | 3 ++-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/rwlock.h b/include/linux/rwlock.h
index 3390d21c95dd1..21ceefc4a49f2 100644
--- a/include/linux/rwlock.h
+++ b/include/linux/rwlock.h
@@ -30,10 +30,10 @@ do {								\
 
 #ifdef CONFIG_DEBUG_SPINLOCK
  extern void do_raw_read_lock(rwlock_t *lock) __acquires_shared(lock);
- extern int do_raw_read_trylock(rwlock_t *lock);
+ extern int do_raw_read_trylock(rwlock_t *lock) __cond_acquires_shared(true, lock);
  extern void do_raw_read_unlock(rwlock_t *lock) __releases_shared(lock);
  extern void do_raw_write_lock(rwlock_t *lock) __acquires(lock);
- extern int do_raw_write_trylock(rwlock_t *lock);
+extern int do_raw_write_trylock(rwlock_t *lock) __cond_acquires(true, lock);
  extern void do_raw_write_unlock(rwlock_t *lock) __releases(lock);
 #else
 # define do_raw_read_lock(rwlock)	do {__acquire_shared(lock); arch_read_lock(&(rwlock)->raw_lock); } while (0)
diff --git a/include/linux/rwlock_api_smp.h b/include/linux/rwlock_api_smp.h
index 61a852609eab4..9e02a5f28cd1d 100644
--- a/include/linux/rwlock_api_smp.h
+++ b/include/linux/rwlock_api_smp.h
@@ -23,7 +23,7 @@ void __lockfunc _raw_write_lock_bh(rwlock_t *lock)	__acquires(lock);
 void __lockfunc _raw_read_lock_irq(rwlock_t *lock)	__acquires_shared(lock);
 void __lockfunc _raw_write_lock_irq(rwlock_t *lock)	__acquires(lock);
 unsigned long __lockfunc _raw_read_lock_irqsave(rwlock_t *lock)
-							__acquires(lock);
+							__acquires_shared(lock);
 unsigned long __lockfunc _raw_write_lock_irqsave(rwlock_t *lock)
 							__acquires(lock);
 int __lockfunc _raw_read_trylock(rwlock_t *lock)	__cond_acquires_shared(true, lock);
@@ -36,7 +36,7 @@ void __lockfunc _raw_read_unlock_irq(rwlock_t *lock)	__releases_shared(lock);
 void __lockfunc _raw_write_unlock_irq(rwlock_t *lock)	__releases(lock);
 void __lockfunc
 _raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
-							__releases(lock);
+							__releases_shared(lock);
 void __lockfunc
 _raw_write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 							__releases(lock);
@@ -116,6 +116,7 @@ _raw_write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 #endif
 
 static inline int __raw_read_trylock(rwlock_t *lock)
+	__cond_acquires_shared(true, lock)
 {
 	preempt_disable();
 	if (do_raw_read_trylock(lock)) {
@@ -127,6 +128,7 @@ static inline int __raw_read_trylock(rwlock_t *lock)
 }
 
 static inline int __raw_write_trylock(rwlock_t *lock)
+	__cond_acquires(true, lock)
 {
 	preempt_disable();
 	if (do_raw_write_trylock(lock)) {
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index e1e2f144af9b4..241277cd34cf3 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -178,7 +178,7 @@ do {									\
 
 #ifdef CONFIG_DEBUG_SPINLOCK
  extern void do_raw_spin_lock(raw_spinlock_t *lock) __acquires(lock);
- extern int do_raw_spin_trylock(raw_spinlock_t *lock);
+ extern int do_raw_spin_trylock(raw_spinlock_t *lock) __cond_acquires(true, lock);
  extern void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock);
 #else
 static inline void do_raw_spin_lock(raw_spinlock_t *lock) __acquires(lock)
@@ -189,6 +189,7 @@ static inline void do_raw_spin_lock(raw_spinlock_t *lock) __acquires(lock)
 }
 
 static inline int do_raw_spin_trylock(raw_spinlock_t *lock)
+	__cond_acquires(true, lock)
 {
 	int ret = arch_spin_trylock(&(lock)->raw_lock);
 
-- 
2.53.0



