Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0111374A17;
	Wed, 30 Sep 2026 18:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791487; cv=none; b=uhD1OH3vdzXM6Vh8L0sicHEcZfmKvwIMhvxn6oDnZEQCVCS4b9GoTGXfurX3Lws316AGyiBO1R8ZI4u3FwMj7pOJhjNsTQbk7TwdNL2rnid/zARQTQw+TIlqUWKtscv9QcqlOUlBlxv3jKys+0EXWAiMmfetz7fVsstHRb3I494=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791487; c=relaxed/simple;
	bh=eHtPo53xJg/G1xoVzO0n0iLJN5TaW+4lL6qHC49e1O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYsYd2Nrfcgl+kvHKhTPwJWbEscSf8Ya/KOXeVS6NZI6LgSpDliycog3uUQdwmpryynrigAvBq7XKF9DMv+SMdzSTttVWnu75hAA8qEO2v+kpM35vFfnOO2k2FHI0PHgXwX8Y3avWUa1cGqtAswY6JpIuYmotRwgjjufYVlom0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trFubiS2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trFubiS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2879B1F000FF;
	Wed, 30 Sep 2026 18:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791485;
	bh=eJm/HHiXgUVjlYm0VfYMFj6+WfMCYlzAZuipG/0hwqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=trFubiS2z3lEhGRt89wTXPEPJtBjwlL9t4y1dm55Sg9G0/g5tCobtSn6hERW91ksV
	 1q1sRwoHgEwdV3G60HnRCKjrE+PC60IR6ZZNCEpAroPr8CGw05zHy1hWBQJx2ISyTX
	 23bfnpl/grcFh42+B9A+2UJPuGgRyFMhWXSAm8qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqun Feng <boqun.feng@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 274/752] locking/lockdep: Improve the deadlock scenario print for sync and read lock
Date: Wed, 30 Sep 2026 17:22:24 +0200
Message-ID: <20260930152404.216605596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boqun Feng <boqun.feng@gmail.com>

[ Upstream commit 0471db447cb7de56bbe2fedd9256b4d2b8ef642a ]

Lock scenario print is always a weak spot of lockdep splats. Improvement
can be made if we rework the dependency search and the error printing.

However without touching the graph search, we can improve a little for
the circular deadlock case, since we have the to-be-added lock
dependency, and know whether these two locks are read/write/sync.

In order to know whether a held_lock is sync or not, a bit was
"stolen" from ->references, which reduce our limit for the same lock
class nesting from 2^12 to 2^11, and it should still be good enough.

Besides, since we now have bit in held_lock for sync, we don't need the
"hardirqoffs being 1" trick, and also we can avoid the __lock_release()
if we jump out of __lock_acquire() before the held_lock stored.

With these changes, a deadlock case evolved with read lock and sync gets
a better print-out from:

	[...]  Possible unsafe locking scenario:
	[...]
	[...]        CPU0                    CPU1
	[...]        ----                    ----
	[...]   lock(srcuA);
	[...]                                lock(srcuB);
	[...]                                lock(srcuA);
	[...]   lock(srcuB);

to

	[...]  Possible unsafe locking scenario:
	[...]
	[...]        CPU0                    CPU1
	[...]        ----                    ----
	[...]   rlock(srcuA);
	[...]                                lock(srcuB);
	[...]                                lock(srcuA);
	[...]   sync(srcuB);

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Stable-dep-of: 02c6be7d675b ("locking/lockdep: Invalidate stale class_cache entries for zapped classes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/lockdep.h  |  3 ++-
 kernel/locking/lockdep.c | 48 ++++++++++++++++++++++++++--------------
 2 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 4ec21addcec3a..710f5fb64813e 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -138,7 +138,8 @@ struct held_lock {
 	unsigned int read:2;        /* see lock_acquire() comment */
 	unsigned int check:1;       /* see lock_acquire() comment */
 	unsigned int hardirqs_off:1;
-	unsigned int references:12;					/* 32 bits */
+	unsigned int sync:1;
+	unsigned int references:11;					/* 32 bits */
 	unsigned int pin_count;
 };
 
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 585d0b5574a5c..018d156151afd 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1836,6 +1836,8 @@ print_circular_lock_scenario(struct held_lock *src,
 	struct lock_class *source = hlock_class(src);
 	struct lock_class *target = hlock_class(tgt);
 	struct lock_class *parent = prt->class;
+	int src_read = src->read;
+	int tgt_read = tgt->read;
 
 	/*
 	 * A direct locking problem where unsafe_class lock is taken
@@ -1863,7 +1865,10 @@ print_circular_lock_scenario(struct held_lock *src,
 	printk(" Possible unsafe locking scenario:\n\n");
 	printk("       CPU0                    CPU1\n");
 	printk("       ----                    ----\n");
-	printk("  lock(");
+	if (tgt_read != 0)
+		printk("  rlock(");
+	else
+		printk("  lock(");
 	__print_lock_name(target);
 	printk(KERN_CONT ");\n");
 	printk("                               lock(");
@@ -1872,7 +1877,12 @@ print_circular_lock_scenario(struct held_lock *src,
 	printk("                               lock(");
 	__print_lock_name(target);
 	printk(KERN_CONT ");\n");
-	printk("  lock(");
+	if (src_read != 0)
+		printk("  rlock(");
+	else if (src->sync)
+		printk("  sync(");
+	else
+		printk("  lock(");
 	__print_lock_name(source);
 	printk(KERN_CONT ");\n");
 	printk("\n *** DEADLOCK ***\n\n");
@@ -4487,7 +4497,13 @@ mark_usage(struct task_struct *curr, struct held_lock *hlock, int check)
 					return 0;
 		}
 	}
-	if (!hlock->hardirqs_off) {
+
+	/*
+	 * For lock_sync(), don't mark the ENABLED usage, since lock_sync()
+	 * creates no critical section and no extra dependency can be introduced
+	 * by interrupts
+	 */
+	if (!hlock->hardirqs_off && !hlock->sync) {
 		if (hlock->read) {
 			if (!mark_lock(curr, hlock,
 					LOCK_ENABLED_HARDIRQ_READ))
@@ -4866,7 +4882,7 @@ static int __lock_is_held(const struct lockdep_map *lock, int read);
 static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			  int trylock, int read, int check, int hardirqs_off,
 			  struct lockdep_map *nest_lock, unsigned long ip,
-			  int references, int pin_count)
+			  int references, int pin_count, int sync)
 {
 	struct task_struct *curr = current;
 	struct lock_class *class = NULL;
@@ -4917,7 +4933,8 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 
 	class_idx = class - lock_classes;
 
-	if (depth) { /* we're holding locks */
+	if (depth && !sync) {
+		/* we're holding locks and the new held lock is not a sync */
 		hlock = curr->held_locks + depth - 1;
 		if (hlock->class_idx == class_idx && nest_lock) {
 			if (!references)
@@ -4951,6 +4968,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	hlock->trylock = trylock;
 	hlock->read = read;
 	hlock->check = check;
+	hlock->sync = !!sync;
 	hlock->hardirqs_off = !!hardirqs_off;
 	hlock->references = references;
 #ifdef CONFIG_LOCK_STAT
@@ -5012,6 +5030,10 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (!validate_chain(curr, hlock, chain_head, chain_key))
 		return 0;
 
+	/* For lock_sync(), we are done here since no actual critical section */
+	if (hlock->sync)
+		return 1;
+
 	curr->curr_chain_key = chain_key;
 	curr->lockdep_depth++;
 	check_chain_key(curr);
@@ -5153,7 +5175,7 @@ static int reacquire_held_locks(struct task_struct *curr, unsigned int depth,
 				    hlock->read, hlock->check,
 				    hlock->hardirqs_off,
 				    hlock->nest_lock, hlock->acquire_ip,
-				    hlock->references, hlock->pin_count)) {
+				    hlock->references, hlock->pin_count, 0)) {
 		case 0:
 			return 1;
 		case 1:
@@ -5623,7 +5645,7 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 
 	lockdep_recursion_inc();
 	__lock_acquire(lock, subclass, trylock, read, check,
-		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0);
+		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0, 0);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
 }
@@ -5656,11 +5678,6 @@ EXPORT_SYMBOL_GPL(lock_release);
  * APIs are used to wait for one or multiple critical sections (on other CPUs
  * or threads), and it means that calling these APIs inside these critical
  * sections is potential deadlock.
- *
- * This annotation acts as an acquire+release annotation pair with hardirqoff
- * being 1. Since there's no critical section, no interrupt can create extra
- * dependencies "inside" the annotation, hardirqoff == 1 allows us to avoid
- * false positives.
  */
 void lock_sync(struct lockdep_map *lock, unsigned subclass, int read,
 	       int check, struct lockdep_map *nest_lock, unsigned long ip)
@@ -5674,10 +5691,9 @@ void lock_sync(struct lockdep_map *lock, unsigned subclass, int read,
 	check_flags(flags);
 
 	lockdep_recursion_inc();
-	__lock_acquire(lock, subclass, 0, read, check, 1, nest_lock, ip, 0, 0);
-
-	if (__lock_release(lock, ip))
-		check_chain_key(current);
+	__lock_acquire(lock, subclass, 0, read, check,
+		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0, 1);
+	check_chain_key(current);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
 }
-- 
2.53.0



