Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE6C342539;
	Thu, 17 Sep 2026 15:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659195; cv=none; b=CoW2722lKo5UF5y2umZls935/4MR+3yf92vGZS1JQbW3yJ9KC7NsTTHi3K/p1uc8XbfHiU1Qtssp9RQEosRla/Nqsb1dkYWQ43RlueMSapHlExxvCoHFbAGBJQmoSzfja0+EMM6/G3Lo/RavDUfjzz9sBw07zBnPaAUbw2VwOfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659195; c=relaxed/simple;
	bh=GTWy1upf7JZ4OUHJzzUgpaSbWvTPUISFzIJS3/QKM30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMklpMbazlrUfQnC0Hm9rn7POPTpglq/N+PlJY7INSa5AyKTR4NED4RnAcNgvyA4hzDWSv8vYC8HIhZjwm6m7n0dx8FlkarYHoS/iLSjXvPUI3Iz1VnoY3rIHXUksyDqIej3NMzc1nrSGaLCcI/45o/ie/CfYPC8ToQwlIxwgJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUC8Vmzc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUC8Vmzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90251F000FF;
	Thu, 17 Sep 2026 15:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659185;
	bh=zSy+sru/Ch5YAGevEn3KSRgK4JVbWfDlwChyidhszzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HUC8Vmzcx1lyACEqTzNNB3Ol7rt2zJ9QZDzElbZvl8DqP+nrL6YtVeXwEiMjdb2ZE
	 wgDxvLXgZyjxN6d1FdLkaqam3bN6UALL/r8HUkszI+6ooxnEMHJWdHpuDqWfUZ1GTR
	 Abdq7PH7p50VuQK8q3k23CVWVbcpOilTKOsPjcTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2d770620059281e225a4@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 173/733] locking/lockdep: Invalidate stale class_cache entries for zapped classes
Date: Thu, 17 Sep 2026 16:08:01 +0100
Message-ID: <20260917151355.417535028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 02c6be7d675b21d81f0ba3a524346850a8c0e3bf ]

syzbot reported a lockdep splat hitting DEBUG_LOCKS_WARN_ON(1) in
hlock_class() due to an invalid class_idx:

  WARNING: kernel/locking/lockdep.c:238 at __lock_acquire+0x382/0x2cf0 kernel/locking/lockdep.c:5203
  Workqueue: wg-crypt-wg0 wg_packet_tx_worker
  RIP: 0010:hlock_class kernel/locking/lockdep.c:238 [inline]
  RIP: 0010:check_wait_context kernel/locking/lockdep.c:4870 [inline]
  RIP: 0010:__lock_acquire+0x389/0x2cf0 kernel/locking/lockdep.c:5203
  Call Trace:
   <IRQ>
   lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5886
   _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:173
   tcp_tsq_handler+0x29/0x200 net/ipv4/tcp_output.c:1291
   tcp_tsq_workfn+0x384/0x410 net/ipv4/tcp_output.c:1325
   ...

When a lock class is zapped (e.g. during module unload or key
unregistration), zap_class() clears the class's bit in
lock_classes_in_use and removes it from the class hash table.
However, existing lockdep_map instances embedded in data structures
may still retain a pointer to the zapped class in their class_cache[]
array.

When __lock_acquire() subsequently runs on such a lock, it finds
lock->class_cache[subclass] != NULL, skipping register_lock_class()
and assigning hlock->class_idx to the index of the zapped class. When
check_wait_context() or hlock_class() inspects the held_lock, it finds
!test_bit(class_idx, lock_classes_in_use) and warns. Furthermore, if
the zapped slot is subsequently re-allocated to an unrelated lock key,
the stale class_cache entry would erroneously match the unrelated
class (ABA issue).

Add lock_class_cache_is_valid() to validate that the cached class is
within lock_classes bounds, still allocated in lock_classes_in_use
(using uninstrumented arch_test_bit() in __always_inline context so it
is safe in noinstr contexts like match_held_lock()), and that
class->key matches the expected subkey (taking lockdep_set_subclass()
overrides into account). Also use READ_ONCE()/WRITE_ONCE() when
accessing class_cache[].  If the entry is invalid or stale, fall back
to register_lock_class() / look_up_lock_class().

Fixes: a0b0fd53e1e6 ("locking/lockdep: Free lock classes that are no longer in use")
Closes: https://lore.kernel.org/netdev/6a8c66dc.4d75e56a.c9a88.0050.GAE@google.com/T/#u
Reported-by: syzbot+2d770620059281e225a4@syzkaller.appspotmail.com
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260824155129.676096-1-edumazet@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 50 +++++++++++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 8 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index e0de811148242..06f025abe8875 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -947,6 +947,34 @@ look_up_lock_class(const struct lockdep_map *lock, unsigned int subclass)
 	return NULL;
 }
 
+static __always_inline bool lock_class_cache_is_valid(const struct lockdep_map *lock,
+						      const struct lock_class *class,
+						      unsigned int subclass)
+{
+	unsigned int class_subclass;
+
+	if (!class)
+		return false;
+
+	if (unlikely(class < lock_classes || class >= lock_classes + MAX_LOCKDEP_KEYS))
+		return false;
+
+	if (unlikely(!arch_test_bit(class - lock_classes, lock_classes_in_use)))
+		return false;
+
+	if (unlikely(!lock->key))
+		return false;
+
+	class_subclass = subclass ? subclass : class->subclass;
+	if (unlikely(class_subclass >= MAX_LOCKDEP_SUBCLASSES))
+		return false;
+
+	if (unlikely(READ_ONCE(class->key) != lock->key->subkeys + class_subclass))
+		return false;
+
+	return true;
+}
+
 /*
  * Static locks do not have their class-keys yet - for them the key is
  * the lock object itself. If the lock is in the per cpu area, the
@@ -1379,9 +1407,9 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 
 out_set_class_cache:
 	if (!subclass || force)
-		lock->class_cache[0] = class;
+		WRITE_ONCE(lock->class_cache[0], class);
 	else if (subclass < NR_LOCKDEP_CACHING_CLASSES)
-		lock->class_cache[subclass] = class;
+		WRITE_ONCE(lock->class_cache[subclass], class);
 
 	/*
 	 * Hash collision, did we smoke some? We found a class with a matching
@@ -4941,7 +4969,7 @@ void lockdep_init_map_type(struct lockdep_map *lock, const char *name,
 	int i;
 
 	for (i = 0; i < NR_LOCKDEP_CACHING_CLASSES; i++)
-		lock->class_cache[i] = NULL;
+		WRITE_ONCE(lock->class_cache[i], NULL);
 
 #ifdef CONFIG_LOCK_STAT
 	lock->cpu = raw_smp_processor_id();
@@ -5006,12 +5034,15 @@ EXPORT_SYMBOL_GPL(__lockdep_no_track__);
 void lockdep_set_lock_cmp_fn(struct lockdep_map *lock, lock_cmp_fn cmp_fn,
 			     lock_print_fn print_fn)
 {
-	struct lock_class *class = lock->class_cache[0];
+	struct lock_class *class = READ_ONCE(lock->class_cache[0]);
 	unsigned long flags;
 
 	raw_local_irq_save(flags);
 	lockdep_recursion_inc();
 
+	if (!lock_class_cache_is_valid(lock, class, 0))
+		class = NULL;
+
 	if (!class)
 		class = register_lock_class(lock, 0, 0);
 
@@ -5103,8 +5134,11 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (DEBUG_LOCKS_WARN_ON(subclass >= MAX_LOCKDEP_SUBCLASSES))
 		return 0;
 
-	if (subclass < NR_LOCKDEP_CACHING_CLASSES)
-		class = lock->class_cache[subclass];
+	if (subclass < NR_LOCKDEP_CACHING_CLASSES) {
+		class = READ_ONCE(lock->class_cache[subclass]);
+		if (!lock_class_cache_is_valid(lock, class, subclass))
+			class = NULL;
+	}
 	/*
 	 * Not cached?
 	 */
@@ -5307,9 +5341,9 @@ static noinstr int match_held_lock(const struct held_lock *hlock,
 		return 1;
 
 	if (hlock->references) {
-		const struct lock_class *class = lock->class_cache[0];
+		const struct lock_class *class = READ_ONCE(lock->class_cache[0]);
 
-		if (!class)
+		if (!lock_class_cache_is_valid(lock, class, 0))
 			class = look_up_lock_class(lock, 0);
 
 		/*
-- 
2.53.0



