Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD82346FA1;
	Tue, 16 Dec 2025 11:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886330; cv=none; b=SukfLQHSxdCyo3houmIq0BJN7Y7Dwhgc5HjEOWHlkQ1pVR6/X3YII/acpXLhDzkqgW9/QAoBL++Yb31tkay90S4w0qrBKVVDN5SMualYFV9fkyQTxX66FpdkaPgZLSvsHN/aVkXHMRPhMOv2zPEAYJRScOHQTvwYiNyT+ssWAvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886330; c=relaxed/simple;
	bh=QZXtGa+kXcYCPKL6rEpOUOFzWR8lUQa4d6d87TSUDkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbzSynCGDv9jTOLhXbUDX60ITYOMSqFbz3QCaTwEdFZtn0ThDzRXtpXZTQbtDv4WYXrmjBM44340NiLiWFiLqiPRhzCyAOVmteIAeWZmbo8eR1mzBkOJRQ6oksbPWrrDX/MUSuXpr+R/1rOX5+LDN9YCU1MB0WawYBF2dDmFyVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmuyBMow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmuyBMow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFC5C4CEF1;
	Tue, 16 Dec 2025 11:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886330;
	bh=QZXtGa+kXcYCPKL6rEpOUOFzWR8lUQa4d6d87TSUDkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmuyBMoweN1qfK2cmBDvV8xxvA4nhTqx9h3r1OX5zzUv7ReAD2Rr94Jg3TmYqsVEq
	 CrF+WgD6Z4WLj+4/vw1JRBdknzWurnjMT1ORHKCb+rXtqMaFIDm8O7aiUxcyEa/qw2
	 3JEleWSAGBBS7DtcteU8sFQzWff+B5BFeo3OotXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ritesh Oedayrajsingh Varma <ritesh@superluminal.eu>,
	Alexei Starovoitov <ast@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 405/507] rqspinlock: Use trylock fallback when per-CPU rqnode is busy
Date: Tue, 16 Dec 2025 12:14:06 +0100
Message-ID: <20251216111400.125823745@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 81d5a6a438595e46be191d602e5c2d6d73992fdc ]

In addition to deferring to the trylock fallback in NMIs, only do so
when an rqspinlock waiter is queued on the current CPU. This is detected
by noticing a non-zero node index. This allows NMI waiters to join the
waiter queue if it isn't interrupting an existing rqspinlock waiter, and
increase the chances of fairly obtaining the lock, performing deadlock
detection as the head, and not being starved while attempting the
trylock.

The trylock path in particular is unlikely to succeed under contention,
as it relies on the lock word becoming 0, which indicates no contention.
This means that the most likely result for NMIs attempting a trylock is
a timeout under contention if they don't hit an AA or ABBA case.

The core problem being addressed through the fixed commit was removing
the dependency edge between an NMI queue waiter and the queue waiter it
is interrupting. Whenever a circular dependency forms, and with no way
to break it (as non-head waiters don't poll for deadlocks or timeouts),
we would enter into a deadlock. A trylock either breaks such an edge by
probing for deadlocks, and finally terminating the waiting loop using a
timeout.

By excluding queueing on CPUs where the node index is non-zero for NMIs,
this sort of dependency is broken. The CPU enters the trylock path for
those cases, and falls back to deadlock checks and timeouts. However, in
other case where it doesn't interrupt the CPU in the slow path while its
queued on the lock, it can join the queue as a normal waiter, and avoid
trylock associated starvation and subsequent timeouts.

There are a few remaining cases here that matter: the NMI can still
preempt the owner in its critical section, and if it queues as a
non-head waiter, it can end up impeding the progress of the owner. While
this won't deadlock, since the head waiter will eventually signal the
NMI waiter to either stop (due to a timeout), it can still lead to long
timeouts. These gaps will be addressed in subsequent commits.

Note that while the node count detection approach is less conservative
than simply deferring NMIs to trylock, it is going to return errors
where attempts to lock B in NMI happen while waiters for lock A are in a
lower context on the same CPU. However, this only occurs when the lower
context is queued in the slow path, and the NMI attempt can proceed
without failure in all other cases. To continue to prevent AA deadlocks
(or ABBA in a similar NMI interrupting lower context pattern), we'd need
a more fleshed out algorithm to unlink NMI waiters after they queue and
detect such cases. However, all that complexity isn't appealing yet to
reduce the failure rate in the small window inside the slow path.

It is important to note that reentrancy in the slow path can also happen
through trace_contention_{begin,end}, but in those cases, unlike an NMI,
the forward progress of the head waiter (or the predecessor in general)
is not being blocked.

Fixes: 0d80e7f951be ("rqspinlock: Choose trylock fallback for NMI waiters")
Reported-by: Ritesh Oedayrajsingh Varma <ritesh@superluminal.eu>
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20251128232802.1031906-4-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/rqspinlock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/rqspinlock.c b/kernel/bpf/rqspinlock.c
index f4c534fa4e87b..3faf9cbd6c753 100644
--- a/kernel/bpf/rqspinlock.c
+++ b/kernel/bpf/rqspinlock.c
@@ -465,7 +465,7 @@ int __lockfunc resilient_queued_spin_lock_slowpath(rqspinlock_t *lock, u32 val)
 	 * any MCS node. This is not the most elegant solution, but is
 	 * simple enough.
 	 */
-	if (unlikely(idx >= _Q_MAX_NODES || in_nmi())) {
+	if (unlikely(idx >= _Q_MAX_NODES || (in_nmi() && idx > 0))) {
 		lockevent_inc(lock_no_node);
 		RES_RESET_TIMEOUT(ts, RES_DEF_TIMEOUT);
 		while (!queued_spin_trylock(lock)) {
-- 
2.51.0



