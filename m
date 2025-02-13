Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A061126B082;
	Thu, 13 Feb 2025 15:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459297; cv=none; b=oTyjSoO/9jU4zGBvDXoQO9S+yspV8xSmUx/aLDcBde0vcORJo5Hqffn+sNacu93MaxnbgXUmeTO7eYnVAAgfMgV3zUJhd/+Mtyp4A1I9q1euEoe0ug3aSCYaHCfhN9fjP9MrZ4eYFQbYhFX7YHbr/07qkMGsUnXwsjvDUpj5K60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459297; c=relaxed/simple;
	bh=3lSP9LKftmIK436Eb8by0bvuRIyIhG1OtoU4oTCr+JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXKtnD79X+9vymUQlJAD/I8QNaXwXyVxXNo1ZxQm/s10QaSSZMta3gGIY2BSfoa92Z94RBZy+7qCsoii+CeT7x/Zb3KCsBScuO/fRJ+2egQfnjPUt40bNHa2/G28SoTLAgYieRbkG3I0+Ehpi4bvsR2OV+12ZRyLUhrVLx5QId0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gqzi2ri4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gqzi2ri4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8A0C4CED1;
	Thu, 13 Feb 2025 15:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459297;
	bh=3lSP9LKftmIK436Eb8by0bvuRIyIhG1OtoU4oTCr+JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gqzi2ri46fSbsv9IXZ0Cg+gjdWXpGsHo/1PJMUfCXHHfCIZdaO7NRpE/vZeAKXSr8
	 xnuz50A1ZJmtoE4HLtIJLgSbwqyL8jC+0tNpSHDte/ceOKFGhJyH1N2vR6JtpJJALr
	 4LS+vc2d2G6mn2aY1dGP1cZFEE9dgcEZsz6bYHeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Ludwig Rydberg <ludwig.rydberg@gaisler.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 223/443] atomic64: Use arch_spin_locks instead of raw_spin_locks
Date: Thu, 13 Feb 2025 15:26:28 +0100
Message-ID: <20250213142449.217998598@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 6c8ad3ab45ad0e94bfb7a9c71f2fa9c6cacea4b2 upstream.

raw_spin_locks can be traced by lockdep or tracing itself. Atomic64
operations can be used in the tracing infrastructure. When an architecture
does not have true atomic64 operations it can use the generic version that
disables interrupts and uses spin_locks.

The tracing ring buffer code uses atomic64 operations for the time
keeping. But because some architectures use the default operations, the
locking inside the atomic operations can cause an infinite recursion.

As atomic64 implementation is architecture specific, it should not be
using raw_spin_locks() but instead arch_spin_locks as that is the purpose
of arch_spin_locks. To be used in architecture specific implementations of
generic infrastructure like atomic64 operations.

Note, by switching from raw_spin_locks to arch_spin_locks, the locks taken
to emulate the atomic64 operations will not have lockdep, mmio, or any
kind of checks done on them. They will not even disable preemption,
although the code will disable interrupts preventing the tasks that hold
the locks from being preempted. As the locks held are done so for very
short periods of time, and the logic is only done to emulate atomic64, not
having them be instrumented should not be an issue.

Cc: stable@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/20250122144311.64392baf@gandalf.local.home
Fixes: c84897c0ff592 ("ring-buffer: Remove 32bit timestamp logic")
Closes: https://lore.kernel.org/all/86fb4f86-a0e4-45a2-a2df-3154acc4f086@gaisler.com/
Reported-by: Ludwig Rydberg <ludwig.rydberg@gaisler.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/atomic64.c |   78 +++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 48 insertions(+), 30 deletions(-)

--- a/lib/atomic64.c
+++ b/lib/atomic64.c
@@ -25,15 +25,15 @@
  * Ensure each lock is in a separate cacheline.
  */
 static union {
-	raw_spinlock_t lock;
+	arch_spinlock_t lock;
 	char pad[L1_CACHE_BYTES];
 } atomic64_lock[NR_LOCKS] __cacheline_aligned_in_smp = {
 	[0 ... (NR_LOCKS - 1)] = {
-		.lock =  __RAW_SPIN_LOCK_UNLOCKED(atomic64_lock.lock),
+		.lock =  __ARCH_SPIN_LOCK_UNLOCKED,
 	},
 };
 
-static inline raw_spinlock_t *lock_addr(const atomic64_t *v)
+static inline arch_spinlock_t *lock_addr(const atomic64_t *v)
 {
 	unsigned long addr = (unsigned long) v;
 
@@ -45,12 +45,14 @@ static inline raw_spinlock_t *lock_addr(
 s64 generic_atomic64_read(const atomic64_t *v)
 {
 	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
+	arch_spinlock_t *lock = lock_addr(v);
 	s64 val;
 
-	raw_spin_lock_irqsave(lock, flags);
+	local_irq_save(flags);
+	arch_spin_lock(lock);
 	val = v->counter;
-	raw_spin_unlock_irqrestore(lock, flags);
+	arch_spin_unlock(lock);
+	local_irq_restore(flags);
 	return val;
 }
 EXPORT_SYMBOL(generic_atomic64_read);
@@ -58,11 +60,13 @@ EXPORT_SYMBOL(generic_atomic64_read);
 void generic_atomic64_set(atomic64_t *v, s64 i)
 {
 	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
+	arch_spinlock_t *lock = lock_addr(v);
 
-	raw_spin_lock_irqsave(lock, flags);
+	local_irq_save(flags);
+	arch_spin_lock(lock);
 	v->counter = i;
-	raw_spin_unlock_irqrestore(lock, flags);
+	arch_spin_unlock(lock);
+	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(generic_atomic64_set);
 
@@ -70,11 +74,13 @@ EXPORT_SYMBOL(generic_atomic64_set);
 void generic_atomic64_##op(s64 a, atomic64_t *v)			\
 {									\
 	unsigned long flags;						\
-	raw_spinlock_t *lock = lock_addr(v);				\
+	arch_spinlock_t *lock = lock_addr(v);				\
 									\
-	raw_spin_lock_irqsave(lock, flags);				\
+	local_irq_save(flags);						\
+	arch_spin_lock(lock);						\
 	v->counter c_op a;						\
-	raw_spin_unlock_irqrestore(lock, flags);			\
+	arch_spin_unlock(lock);						\
+	local_irq_restore(flags);					\
 }									\
 EXPORT_SYMBOL(generic_atomic64_##op);
 
@@ -82,12 +88,14 @@ EXPORT_SYMBOL(generic_atomic64_##op);
 s64 generic_atomic64_##op##_return(s64 a, atomic64_t *v)		\
 {									\
 	unsigned long flags;						\
-	raw_spinlock_t *lock = lock_addr(v);				\
+	arch_spinlock_t *lock = lock_addr(v);				\
 	s64 val;							\
 									\
-	raw_spin_lock_irqsave(lock, flags);				\
+	local_irq_save(flags);						\
+	arch_spin_lock(lock);						\
 	val = (v->counter c_op a);					\
-	raw_spin_unlock_irqrestore(lock, flags);			\
+	arch_spin_unlock(lock);						\
+	local_irq_restore(flags);					\
 	return val;							\
 }									\
 EXPORT_SYMBOL(generic_atomic64_##op##_return);
@@ -96,13 +104,15 @@ EXPORT_SYMBOL(generic_atomic64_##op##_re
 s64 generic_atomic64_fetch_##op(s64 a, atomic64_t *v)			\
 {									\
 	unsigned long flags;						\
-	raw_spinlock_t *lock = lock_addr(v);				\
+	arch_spinlock_t *lock = lock_addr(v);				\
 	s64 val;							\
 									\
-	raw_spin_lock_irqsave(lock, flags);				\
+	local_irq_save(flags);						\
+	arch_spin_lock(lock);						\
 	val = v->counter;						\
 	v->counter c_op a;						\
-	raw_spin_unlock_irqrestore(lock, flags);			\
+	arch_spin_unlock(lock);						\
+	local_irq_restore(flags);					\
 	return val;							\
 }									\
 EXPORT_SYMBOL(generic_atomic64_fetch_##op);
@@ -131,14 +141,16 @@ ATOMIC64_OPS(xor, ^=)
 s64 generic_atomic64_dec_if_positive(atomic64_t *v)
 {
 	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
+	arch_spinlock_t *lock = lock_addr(v);
 	s64 val;
 
-	raw_spin_lock_irqsave(lock, flags);
+	local_irq_save(flags);
+	arch_spin_lock(lock);
 	val = v->counter - 1;
 	if (val >= 0)
 		v->counter = val;
-	raw_spin_unlock_irqrestore(lock, flags);
+	arch_spin_unlock(lock);
+	local_irq_restore(flags);
 	return val;
 }
 EXPORT_SYMBOL(generic_atomic64_dec_if_positive);
@@ -146,14 +158,16 @@ EXPORT_SYMBOL(generic_atomic64_dec_if_po
 s64 generic_atomic64_cmpxchg(atomic64_t *v, s64 o, s64 n)
 {
 	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
+	arch_spinlock_t *lock = lock_addr(v);
 	s64 val;
 
-	raw_spin_lock_irqsave(lock, flags);
+	local_irq_save(flags);
+	arch_spin_lock(lock);
 	val = v->counter;
 	if (val == o)
 		v->counter = n;
-	raw_spin_unlock_irqrestore(lock, flags);
+	arch_spin_unlock(lock);
+	local_irq_restore(flags);
 	return val;
 }
 EXPORT_SYMBOL(generic_atomic64_cmpxchg);
@@ -161,13 +175,15 @@ EXPORT_SYMBOL(generic_atomic64_cmpxchg);
 s64 generic_atomic64_xchg(atomic64_t *v, s64 new)
 {
 	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
+	arch_spinlock_t *lock = lock_addr(v);
 	s64 val;
 
-	raw_spin_lock_irqsave(lock, flags);
+	local_irq_save(flags);
+	arch_spin_lock(lock);
 	val = v->counter;
 	v->counter = new;
-	raw_spin_unlock_irqrestore(lock, flags);
+	arch_spin_unlock(lock);
+	local_irq_restore(flags);
 	return val;
 }
 EXPORT_SYMBOL(generic_atomic64_xchg);
@@ -175,14 +191,16 @@ EXPORT_SYMBOL(generic_atomic64_xchg);
 s64 generic_atomic64_fetch_add_unless(atomic64_t *v, s64 a, s64 u)
 {
 	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
+	arch_spinlock_t *lock = lock_addr(v);
 	s64 val;
 
-	raw_spin_lock_irqsave(lock, flags);
+	local_irq_save(flags);
+	arch_spin_lock(lock);
 	val = v->counter;
 	if (val != u)
 		v->counter += a;
-	raw_spin_unlock_irqrestore(lock, flags);
+	arch_spin_unlock(lock);
+	local_irq_restore(flags);
 
 	return val;
 }


