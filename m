Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA00C2DEA74;
	Tue, 21 Jul 2026 18:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660110; cv=none; b=hOuFjEog3lz9GFuZpvo75auGHPPGVbDHsHa5XyvxI+Yun7+9Bi1KfZVPHqEqoUSNKWHCsdugDtEBiw2spyRIfaY+FNS9oHGLymeafisMayzp01WIjZy/xOmhUdn3Ytdk4BBEKPBJSi6TU7R8ZFDWIdbeUhDITjQp8feI5uAnzN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660110; c=relaxed/simple;
	bh=lgJ1izzL5wloK4szePI6unjITtaIwk6mNOBoBEuabEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckUL/UC7MYC9BJKXBpkFSbMZ03RJ7aGVpK7ZBSJlTeDcxwjYSCiCLDZjoGubxzB2stcNAVDoRrEfGI3Z5tcM5LNJ2tpJo3liMo3yTHdEymdMrdhDi/ayf+t5xI7lDphIzD4igaV5Riyb1RQSkiFw7kMV108i2KhEst77Nu1J9H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tya1d6WD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tya1d6WD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2448D1F000E9;
	Tue, 21 Jul 2026 18:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660108;
	bh=A/Qd1BowTIvEOC/aTJln4To4P+la0ezCZZQf+fAqlug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tya1d6WDS8D0Kz4EVC8I+sEDeOQ3UmxYnIqmR/tmONjlwOxlxiXT12VKNhHhsRsrx
	 XnYOq1fTTQ6vM4zcmjUGsQs1SHoLYCFTAODbErWxDTnQPamQjRP2+uC6vWhvikH11D
	 bVK3ibMqxRkIpjW1pAZYTUDXbMiwVHzAmPVwxH3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0828/2077] eventpoll: expand top-of-file overview / locking doc
Date: Tue, 21 Jul 2026 17:08:21 +0200
Message-ID: <20260721152612.317412783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 7c25a0bd4bf7139944c5893ff61211f4b5a3455e ]

The existing ~40-line "LOCKING:" banner covered the three-level lock
hierarchy (epnested_mutex > ep->mtx > ep->lock) but nothing else.
Lifetime rules, the ready-list state machine, the three removal paths,
and the POLLFREE contract are implicit in the code. The recent UAF
series (a6dc643c6931, 07712db80857, 8c2e52ebbe88, f2e467a48287) rode
on invariants that were only implicit.

Codify them at the top of the file: the subsystem overview, the lock
hierarchy and its mutex_lock_nested() subclass convention (reworded
from the old banner), a field-protection table for struct eventpoll
and struct epitem that names the two faces of the rbn/rcu union (rbn
under ep->mtx while linked into ep->rbr; rcu touched only by
kfree_rcu(epi) on the free path), the ovflist sentinel encoding and
scan-flip invariants, the three removal paths (A ep_remove, B
ep_clear_and_put, C eventpoll_release_file) and the epi_fget() pin
that orchestrates A vs C, and the POLLFREE store-release /
load-acquire handshake.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Link: https://patch.msgid.link/20260424-work-epoll-rework-v1-1-249ed00a20f3@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 0c4aefe3c2d0 ("eventpoll: Fix epoll_wait() report false negative")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 199 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 162 insertions(+), 37 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index dc8dc529684bfb..9cd6b3511f065a 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -41,45 +41,170 @@
 #include <net/busy_poll.h>
 
 /*
- * LOCKING:
- * There are three level of locking required by epoll :
+ * fs/eventpoll.c - Efficient event polling ("epoll") kernel implementation.
  *
- * 1) epnested_mutex (mutex)
- * 2) ep->mtx (mutex)
- * 3) ep->lock (spinlock)
  *
- * The acquire order is the one listed above, from 1 to 3.
- * We need a spinlock (ep->lock) because we manipulate objects
- * from inside the poll callback, that might be triggered from
- * a wake_up() that in turn might be called from IRQ context.
- * So we can't sleep inside the poll callback and hence we need
- * a spinlock. During the event transfer loop (from kernel to
- * user space) we could end up sleeping due a copy_to_user(), so
- * we need a lock that will allow us to sleep. This lock is a
- * mutex (ep->mtx). It is acquired during the event transfer loop,
- * during epoll_ctl(EPOLL_CTL_DEL) and during eventpoll_release_file().
- * The epnested_mutex is acquired when inserting an epoll fd onto another
- * epoll fd. We do this so that we walk the epoll tree and ensure that this
- * insertion does not create a cycle of epoll file descriptors, which
- * could lead to deadlock. We need a global mutex to prevent two
- * simultaneous inserts (A into B and B into A) from racing and
- * constructing a cycle without either insert observing that it is
- * going to.
- * It is necessary to acquire multiple "ep->mtx"es at once in the
- * case when one epoll fd is added to another. In this case, we
- * always acquire the locks in the order of nesting (i.e. after
- * epoll_ctl(e1, EPOLL_CTL_ADD, e2), e1->mtx will always be acquired
- * before e2->mtx). Since we disallow cycles of epoll file
- * descriptors, this ensures that the mutexes are well-ordered. In
- * order to communicate this nesting to lockdep, when walking a tree
- * of epoll file descriptors, we use the current recursion depth as
- * the lockdep subkey.
- * It is possible to drop the "ep->mtx" and to use the global
- * mutex "epnested_mutex" (together with "ep->lock") to have it working,
- * but having "ep->mtx" will make the interface more scalable.
- * Events that require holding "epnested_mutex" are very rare, while for
- * normal operations the epoll private "ep->mtx" will guarantee
- * a better scalability.
+ * Overview
+ * --------
+ *
+ * Each epoll_create(2) returns an anonymous [eventpoll] file whose
+ * ->private_data is a struct eventpoll. Each EPOLL_CTL_ADD installs
+ * a struct epitem linking one (watched file, fd) pair back to that
+ * eventpoll via the watched file's f_op->poll() wait queue(s). When
+ * the watched file signals readiness, ep_poll_callback() fires and
+ * marks the epitem ready. epoll_wait(2) drains the ready list under
+ * ep->mtx, re-queueing items in level-triggered mode.
+ *
+ * epoll instances can watch other epoll instances up to EP_MAX_NESTS
+ * deep; cycles are forbidden and detected at EPOLL_CTL_ADD time.
+ *
+ *
+ * Locking
+ * -------
+ *
+ * Three levels, acquired from outer to inner:
+ *
+ *   epnested_mutex   (global; rare; taken only for EPOLL_CTL_ADD
+ *                     loop / path checks)
+ *     > ep->mtx     (per-eventpoll; sleepable; serializes most ops)
+ *       > ep->lock  (per-eventpoll; IRQ-safe spinlock)
+ *
+ *   file->f_lock    (per-file; NOT IRQ-safe; guards f_ep hlist ops;
+ *                    nested inside ep->mtx, outside ep->lock)
+ *
+ * Rationale:
+ *   - ep->lock is a spinlock because ep_poll_callback() is called from
+ *     wake_up() which may run in hard-IRQ context. All ep->lock
+ *     critical sections use spin_lock_irqsave().
+ *   - ep->mtx is a sleepable mutex because the event delivery loop
+ *     calls copy_to_user(), and ep_insert() may sleep in
+ *     kmem_cache_alloc() and f_op->poll().
+ *   - epnested_mutex is global because cycle detection needs a global
+ *     view of the epoll topology; a per-object scheme would let two
+ *     concurrent inserts (A into B, B into A) construct a cycle
+ *     without either observer seeing it.
+ *   - Per-ep ep->mtx is preferred for scalability elsewhere. Events
+ *     that require epnested_mutex are rare.
+ *
+ * When EPOLL_CTL_ADD nests one eventpoll inside another we acquire
+ * ep->mtx on both: outer first, target second. Since cycles are
+ * forbidden the set of live ep->mtx holds is always a strict chain,
+ * communicated to lockdep via mutex_lock_nested() subclasses derived
+ * from the current recursion depth.
+ *
+ *
+ * Field protection
+ * ----------------
+ *
+ * struct eventpoll:
+ *   mtx              - self
+ *   rbr              - ep->mtx
+ *   ovflist, rdllist - ep->lock (IRQ-safe)
+ *   wq               - ep->lock for queue mutation
+ *   poll_wait        - internal waitqueue spinlock
+ *   refs             - file->f_lock for adds; ep->mtx for removes;
+ *                      RCU for readers (hlist_del_rcu + kfree_rcu(ep))
+ *   ws               - ep->mtx
+ *   gen, loop_check_depth - epnested_mutex
+ *   file, user       - immutable after setup
+ *   refcount         - atomic (refcount_t)
+ *   napi_*           - READ_ONCE / WRITE_ONCE
+ *
+ * struct epitem:
+ *   rbn / rcu union  - rbn: ep->mtx (while epi is linked in ep->rbr).
+ *                      rcu: written only by kfree_rcu(epi) on the free
+ *                      path; otherwise untouched by epoll code.
+ *   rdllink, next    - ep->lock
+ *   ffd, ep          - immutable after ep_insert()
+ *   pwqlist          - ep->mtx for writes; POLLFREE clears pwq->whead
+ *                      via smp_store_release(), see below
+ *   fllink           - file->f_lock for mutation; hlist_del_rcu +
+ *                      kfree_rcu(epi) for safe RCU readers
+ *   ws               - RCU (rcu_assign_pointer /
+ *                      rcu_dereference_check(mtx))
+ *   event            - ep->mtx for writes; lockless read in
+ *                      ep_poll_callback pairs with smp_mb() in
+ *                      ep_modify()
+ *
+ *
+ * Ready-list state machine
+ * ------------------------
+ *
+ * Readiness is tracked in two lists under ep->lock:
+ *
+ *   rdllist   - doubly-linked FIFO; the "current" ready list.
+ *   ovflist   - singly-linked LIFO; used during a scan to catch
+ *               events that arrive while rdllist is being iterated
+ *               without ep->lock.
+ *
+ * Encoded in ep->ovflist:
+ *   EP_UNACTIVE_PTR - no scan active; callback appends to rdllist.
+ *   NULL            - scan active, no spill yet.
+ *   pointer to epi  - scan active with spilled items (LIFO).
+ *
+ * Encoded in epi->next:
+ *   EP_UNACTIVE_PTR - epi is not on ovflist.
+ *   otherwise       - next epi on ovflist (NULL at tail).
+ *
+ * ep_start_scan() flips "not scanning" to "scanning" and splices
+ * rdllist into a caller-local txlist. ep_done_scan() drains ovflist
+ * back to rdllist (list_add head-insert reverses LIFO to FIFO),
+ * flips back to "not scanning", and re-splices any items the caller
+ * left in txlist (e.g., level-triggered re-queues).
+ *
+ *
+ * Removal paths
+ * -------------
+ *
+ * Three paths dispose of epitems and/or eventpolls:
+ *
+ *   A. ep_remove()              - EPOLL_CTL_DEL and ep_insert()
+ *                                 rollback. Caller holds ep->mtx.
+ *   B. ep_clear_and_put()       - close of the epoll fd itself
+ *                                 (ep_eventpoll_release).
+ *   C. eventpoll_release_file() - close of a watched file, invoked
+ *                                 from __fput().
+ *
+ * Coordination:
+ *   A and C exclude each other via the watched file's refcount.
+ *   A pins the file with epi_fget() before touching file->f_ep or
+ *   file->f_lock; if the pin fails, __fput() is in flight and C
+ *   will clean this epi up. See the epi_fget() block comment.
+ *   A and B both hold ep->mtx serially. B walks the rbtree with
+ *   rb_next() captured before ep_remove() erases the current node.
+ *   B and C both take ep->mtx; the loser sees fewer entries or an
+ *   empty file->f_ep.
+ *
+ * Within every path the internal order is strict:
+ *   ep_unregister_pollwait()  - drain pwqlist; synchronizes with any
+ *                                in-flight ep_poll_callback via the
+ *                                watched wait-queue head's lock.
+ *   ep_remove_file()          - hlist_del_rcu of epi->fllink and,
+ *                                if last watcher, clear file->f_ep,
+ *                                under file->f_lock.
+ *   ep_remove_epi()           - rb_erase, rdllist unlink (ep->lock),
+ *                                wakeup_source_unregister,
+ *                                kfree_rcu(epi).
+ *
+ * kfree_rcu(epi) defers the free past RCU readers in
+ * reverse_path_check_proc(); kfree_rcu(ep) defers past readers in
+ * ep_get_upwards_depth_proc().
+ *
+ *
+ * POLLFREE handshake
+ * ------------------
+ *
+ * When a subsystem tears down a wait-queue head that an epitem is
+ * registered on (binder, signalfd, ...), it wakes the callback with
+ * POLLFREE and must RCU-defer the head's free. The store/load pair:
+ *
+ *   ep_poll_callback() POLLFREE branch:
+ *     smp_store_release(&pwq->whead, NULL)
+ *
+ *   ep_remove_wait_queue():
+ *     smp_load_acquire(&pwq->whead)
+ *
+ * See those sites for the full argument.
  */
 
 /* Epoll private bits inside the event mask */
-- 
2.53.0



