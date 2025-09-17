Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2D31F09B6;
	Wed, 17 Sep 2025 12:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112681; cv=none; b=F24e+qhwpIPujZfrRhmIoXZnmLYT/dkkTQhav7jgnI+NdQhmpBIHmnpet5E/p76SxDfhxC5Yb0CnSQRCWn+Ial/lPXunQzXhjuMKbmVLCz0B96/sN5TzHLrdaoOZ4bQHKXVhHOzviqzOJgOBhPv2zGO6zTnSNG+o+Oa22SO0dO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112681; c=relaxed/simple;
	bh=B5ne9wI+0cYRWOv691hr0p4euJGBd9G3i7Y7+W9gQCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shRpEuXoo1+iLDwTJp7KfsW8TLhdfqvqGPnEmussGCEelPqL6o0TWFK0/k5Hp+h8nr2lHmO0PhAG+VC5Ar4aAeVJhV5OH1bvqizwD6M+ErlrFUNiTmCVK566OBrt4cglrhE3VaE+NWLSnq6vyQ2s2WLxHUo+QRYVJOCokiWaopw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXxE7Lne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXxE7Lne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0CEC4CEF0;
	Wed, 17 Sep 2025 12:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112680;
	bh=B5ne9wI+0cYRWOv691hr0p4euJGBd9G3i7Y7+W9gQCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXxE7LneJf8T2FghxGouVlHp5bv0gY3k7zr/jmrIYKgJXiEWgVyew1vuyJK4EjO3N
	 E2ZbO4uCSxH1CAIYboIN87V2ZGabtLe0tEfTnv4k5EHbgc5cyYAW5Nw2C8WRwpZnaS
	 33UXZqGUXvYcUKyfkX38nt0JUfzTjs/sFpO8Fx7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 043/189] rqspinlock: Choose trylock fallback for NMI waiters
Date: Wed, 17 Sep 2025 14:32:33 +0200
Message-ID: <20250917123352.914906590@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 0d80e7f951be1bdd08d328fd87694be0d6e8aaa8 ]

Currently, out of all 3 types of waiters in the rqspinlock slow path
(i.e., pending bit waiter, wait queue head waiter, and wait queue
non-head waiter), only the pending bit waiter and wait queue head
waiters apply deadlock checks and a timeout on their waiting loop. The
assumption here was that the wait queue head's forward progress would be
sufficient to identify cases where the lock owner or pending bit waiter
is stuck, and non-head waiters relying on the head waiter would prove to
be sufficient for their own forward progress.

However, the head waiter itself can be preempted by a non-head waiter
for the same lock (AA) or a different lock (ABBA) in a manner that
impedes its forward progress. In such a case, non-head waiters not
performing deadlock and timeout checks becomes insufficient, and the
system can enter a state of lockup.

This is typically not a concern with non-NMI lock acquisitions, as lock
holders which in run in different contexts (IRQ, non-IRQ) use "irqsave"
variants of the lock APIs, which naturally excludes such lock holders
from preempting one another on the same CPU.

It might seem likely that a similar case may occur for rqspinlock when
programs are attached to contention tracepoints (begin, end), however,
these tracepoints either precede the enqueue into the wait queue, or
succeed it, therefore cannot be used to preempt a head waiter's waiting
loop.

We must still be careful against nested kprobe and fentry programs that
may attach to the middle of the head's waiting loop to stall forward
progress and invoke another rqspinlock acquisition that proceeds as a
non-head waiter. To this end, drop CC_FLAGS_FTRACE from the rqspinlock.o
object file.

For now, this issue is resolved by falling back to a repeated trylock on
the lock word from NMI context, while performing the deadlock checks to
break out early in case forward progress is impossible, and use the
timeout as a final fallback.

A more involved fix to terminate the queue when such a condition occurs
will be made as a follow up. A selftest to stress this aspect of nested
NMI/non-NMI locking attempts will be added in a subsequent patch to the
bpf-next tree when this fix lands and trees are synchronized.

Reported-by: Josef Bacik <josef@toxicpanda.com>
Fixes: 164c246571e9 ("rqspinlock: Protect waiters in queue from stalls")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20250909184959.3509085-1-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/Makefile     | 1 +
 kernel/bpf/rqspinlock.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 3a335c50e6e3c..12ec926ed7114 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -62,3 +62,4 @@ CFLAGS_REMOVE_bpf_lru_list.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_queue_stack_maps.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_lpm_trie.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_ringbuf.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_rqspinlock.o = $(CC_FLAGS_FTRACE)
diff --git a/kernel/bpf/rqspinlock.c b/kernel/bpf/rqspinlock.c
index 338305c8852cf..804e619f1e006 100644
--- a/kernel/bpf/rqspinlock.c
+++ b/kernel/bpf/rqspinlock.c
@@ -471,7 +471,7 @@ int __lockfunc resilient_queued_spin_lock_slowpath(rqspinlock_t *lock, u32 val)
 	 * any MCS node. This is not the most elegant solution, but is
 	 * simple enough.
 	 */
-	if (unlikely(idx >= _Q_MAX_NODES)) {
+	if (unlikely(idx >= _Q_MAX_NODES || in_nmi())) {
 		lockevent_inc(lock_no_node);
 		RES_RESET_TIMEOUT(ts, RES_DEF_TIMEOUT);
 		while (!queued_spin_trylock(lock)) {
-- 
2.51.0



