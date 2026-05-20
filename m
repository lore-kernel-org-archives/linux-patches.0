Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EE53FF891;
	Wed, 20 May 2026 11:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276073; cv=none; b=QKMhWkrb4JYu8cL8jFa+JClH0nJsNICbIgm2v3pm1h5huOKJ3xwLaCDrz6p41BWmXLXBA4bj8evDb0CjVm+lvEHgKlfXNalKwC31vMI43yOTxUpIjhaghk8Hy3/eWXD4eGed+OixheE2fGcX+GXGEVZi/qrqn2UX4c1L/MnYlFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276073; c=relaxed/simple;
	bh=Cp+lBv8tQQFrjmMonLILwdwCH0R1yb5N2UCeb3mM/Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z/xXLjVNJO3ST6xnyg3Pln0p+73QMUSSyrQt0eDY+2nqnlbfWyAe3bnrMlR2oGCxQpQH2JmGLDQZhM83QwlkVI91N2UOsHJtK1WFaCiU7Sdt8MTcLG/f3YdmO+2ppn8SYMW1wQSCDH2Ld3PhFbpFRXEs4hm/FzJ2KnWTWxDBDAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ep7KMfsH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ep7KMfsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999B01F00894;
	Wed, 20 May 2026 11:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276071;
	bh=mPBqWvhV0w+LojEY1Nxwbe6bI+MnpUqUyjd4Zb9cQtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ep7KMfsHYYn3FupZG2S6VBwh0vN4FtzAe2uea4LVwCdXDQRs/KYTt1cQi2LIwZxOm
	 VknaJx1nmDAxmdPKjHrzXg3EVmfnM3VV+AuAG6QBns9tOHai6iSdDoh3uT0fwD8G8V
	 1oQUuIa/5MgBO5LKQXCuu2i6Ky1E+7ver8FGGIYE7zJ8AafZ2YHwX7yJtHj8zwgrLA
	 ULsWkxqBH8vt1N4QWaUXsY1lTt3ID0biQC6v4JTNIQV1FSamh7ZLmiL6uel+Lf9d3U
	 2oJqdEKjNFddFV/35ifnOA8cT5AVf13TVFSD4iEQxHw0OHgrAxRjww85G8bFbQnIrT
	 uTKL6v2CghBXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Breno Leitao <leitao@debian.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] workqueue: Release PENDING in __queue_work() drain/destroy reject path
Date: Wed, 20 May 2026 07:19:33 -0400
Message-ID: <20260520111944.3424570-61-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Breno Leitao <leitao@debian.org>

[ Upstream commit a7488f089bdfa87c4fef1744d4dca9f4f8b46f8b ]

The caller of __queue_work() owns WORK_STRUCT_PENDING, won via
test_and_set_bit() in queue_work_on()/__queue_delayed_work(). The
state machine documented above __queue_work() requires that owner
to either hand the token to a pwq (insert_work() -> set_work_pwq()),
hand it to a timer, or release it via set_work_pool_and_clear_pending().
try_to_grab_pending() relies on this: when it observes
"PENDING && off-queue" it busy-loops, trusting the current owner to
make progress.

The (__WQ_DESTROYING | __WQ_DRAINING) early-return path violates that
contract. It WARN_ONCE()s and bare-returns, leaving work->data with
PENDING set, WORK_STRUCT_PWQ clear, and work->entry empty.

The path is reachable without explicit API abuse: queue_delayed_work()
arms a timer with PENDING set; if drain_workqueue() runs while the
timer is still pending, delayed_work_timer_fn() -> __queue_work() in
softirq context hits the WARN, current is not a wq worker so
is_chained_work() is false, and the work is silently dropped with
PENDING leaked.

Mirror what clear_pending_if_disabled() already does on its analogous
reject path: unpack the off-queue data and call
set_work_pool_and_clear_pending() to release the token before
returning.

I was able to reproduce this by queueing several slow works on
a max_active=1 wq, arm a delayed_work whose timer fires while
drain_workqueue() is blocked, then call cancel_delayed_work_sync().
Without this patch the cancel livelocks at 100% CPU; with it the cancel
returns immediately.

Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough
### Phase 1: Commit Message Forensics
Record 1.1: Subsystem `workqueue`; action verb `Release`; intent: clear
`WORK_STRUCT_PENDING` when `__queue_work()` rejects work during
drain/destroy.

Record 1.2: Commit tags: `Signed-off-by: Breno Leitao
<leitao@debian.org>` and `Signed-off-by: Tejun Heo <tj@kernel.org>`. No
committed `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`,
`Acked-by:`, `Link:`, or `Cc: stable@vger.kernel.org`.

Record 1.3: The body describes a real state-machine bug:
`__queue_work()` may return from the `__WQ_DESTROYING | __WQ_DRAINING`
reject path with `PENDING` still set while the work is off-queue.
`try_to_grab_pending()` then sees `PENDING && off-queue` and busy-
retries. The verified failure mode is `cancel_delayed_work_sync()`
livelocking at 100% CPU after a delayed timer fires during
`drain_workqueue()`.

Record 1.4: This is not a hidden cleanup; it is an explicit correctness
fix for a leaked pending token causing livelock.

### Phase 2: Diff Analysis
Record 2.1: One file changed: `kernel/workqueue.c`, 12 insertions. One
function changed: `__queue_work()`. Scope: single-file surgical core
workqueue fix.

Record 2.2: Before: reject path warned and returned directly. After:
reject path unpacks off-queue work data and calls
`set_work_pool_and_clear_pending()` before returning.

Record 2.3: Bug category: workqueue state-machine/token leak with a race
between delayed-work timer execution and draining/destroying a
workqueue. Mechanism: queued delayed work owns `PENDING`; timer callback
enters `__queue_work()`; reject path drops the work but did not release
`PENDING`.

Record 2.4: Fix quality is high. It mirrors the existing
`clear_pending_if_disabled()` pattern in the same file and does not add
an API or change normal queueing behavior. Regression risk is low; the
change is limited to an already-rejecting path.

### Phase 3: Git History
Record 3.1: `git blame` shows the PENDING/off-queue busy-loop contract
comment came from `8930caba3dbd`; the drain reject mechanism is rooted
in `9c5a2ba70251` (`v3.1`), and the destroy-side diagnostic flag came
from `33e3f0a3358b` (`v6.3`). The bare reject `return` traces back to
`e41e704bc4f4` (`v2.6.36-rc4` era).

Record 3.2: No committed `Fixes:` tag. I inspected the patch-thread note
suggesting `e41e704bc4f4`; that commit added the “warn and ignore”
dying-workqueue behavior.

Record 3.3: Recent `kernel/workqueue.c` history shows nearby independent
workqueue fixes and diagnostics; this patch is standalone, not a multi-
patch series dependency.

Record 3.4: Breno Leitao has multiple recent workqueue commits in
`origin/master`; Tejun Heo, the workqueue maintainer, committed this
patch.

Record 3.5: Dependencies: conceptually standalone. Exact patch applies
cleanly to `v6.18.32`, `v6.19.14`, `v7.0`, and `v7.0.9`; older trees
need small backport adjustment because helper APIs and warning text
differ.

### Phase 4: Mailing List / External Research
Record 4.1: `b4 dig -c a7488f089bdfa` found the original thread: `https:
//patch.msgid.link/20260507-workqueue_pending-v1-1-
3a53e2facf4e@debian.org`. Series revisions: v1 only.

Record 4.2: Original recipients included Breno Leitao, Tejun Heo, Lai
Jiangshan, `linux-kernel@vger.kernel.org`, `clm@meta.com`, and `kernel-
team@meta.com`. Tejun replied that it was applied to `wq/for-7.1-fixes`.

Record 4.3: No external bug report or syzbot link in this commit. The
bug report evidence is the author’s concrete reproducer in the
commit/thread.

Record 4.4: No related patch series found; b4 reports a single-patch v1.

Record 4.5: Web search found no stable-specific discussion for this
exact patch. Lore WebFetch was blocked by Anubis, but b4 successfully
fetched the mbox.

### Phase 5: Code Semantic Analysis
Record 5.1: Modified function: `__queue_work()`.

Record 5.2: Callers verified in `kernel/workqueue.c`: `queue_work_on()`,
`queue_work_node()`, `delayed_work_timer_fn()`, zero-delay
`__queue_delayed_work()`, `rcu_work_rcufn()`, and requeue paths. The
relevant caller is `delayed_work_timer_fn()`.

Record 5.3: Key callees: `is_chained_work()`, `work_offqd_unpack()`,
`set_work_pool_and_clear_pending()`, and, on non-reject paths, pool
selection plus `insert_work()`.

Record 5.4: Verified call chain: `queue_delayed_work_on()` sets
`PENDING`; `__queue_delayed_work()` arms the timer;
`delayed_work_timer_fn()` calls `__queue_work()`; `drain_workqueue()`
sets `__WQ_DRAINING`; `cancel_delayed_work_sync()` reaches
`try_to_grab_pending()` through `work_grab_pending()` and can spin on
`-EAGAIN`. Direct unprivileged trigger was not verified.

Record 5.5: Similar in-tree pattern verified:
`clear_pending_if_disabled()` already unpacks off-queue data and clears
pending in an analogous reject path.

### Phase 6: Stable Tree Analysis
Record 6.1: The buggy drain reject path exists in checked tags from
`v5.4`, `v5.10`, `v5.15`, `v6.1`, `v6.6`, `v6.12`, `v6.18`, `v6.19`, and
`v7.0`. Drain behavior dates back to `v3.1`.

Record 6.2: Backport difficulty: clean for `v6.18+` and `v7.0`; minor
manual backport for `v6.12`; more adjustment for `v6.6` and older
because `work_offqd_unpack()`/flags helpers differ or are absent.

Record 6.3: I found no exact related fix already present by subject in
checked stable branches.

### Phase 7: Subsystem Context
Record 7.1: Subsystem is core workqueue infrastructure. Criticality:
CORE, because workqueues are used throughout drivers, filesystems,
networking, storage, GPU, and core kernel code.

Record 7.2: Workqueue is actively maintained, with recent commits by
Breno Leitao and Tejun Heo, but the affected state machine is mature and
present across long-lived stable lines.

### Phase 8: Impact / Risk
Record 8.1: Affected population: broad kernel users, but trigger-
specific to users of delayed work on workqueues being drained or
destroyed.

Record 8.2: Trigger: delayed-work timer fires while `drain_workqueue()`
or destroy-time draining is active, followed by cancellation/grab of
that delayed work. Commonness is workload dependent; direct unprivileged
reachability was not verified.

Record 8.3: Failure mode: livelock at 100% CPU in
`cancel_delayed_work_sync()`. Severity: HIGH, potentially CRITICAL for
teardown/suspend/remove paths that must complete.

Record 8.4: Benefit high: prevents a real hang/livelock in core
infrastructure. Risk low: 12-line change, reject path only, mirrors
existing cleanup logic.

### Phase 9: Final Synthesis
Record 9.1: Evidence for backporting: real reproduced livelock, core
subsystem, broad stable-tree presence, small fix, maintainer-applied, no
new API. Evidence against: exact patch does not cleanly apply to older
stable trees and lacks independent `Tested-by`; older trees need careful
helper-specific backports. Unresolved: no independent bug report found,
no direct unprivileged trigger verified.

Record 9.2: Stable rules: obviously correct and self-tested: yes; fixes
real bug: yes; important issue: yes, livelock/hang; small and contained:
yes, one function and 12 lines; no new features/APIs: yes; applies to
stable: clean for newer stable, minor/manual for older.

Record 9.3: No exception category applies; this is a core bug fix, not a
device ID, quirk, DT, build, or documentation change.

Record 9.4: Decision: backport. The technical merit is strong: this
fixes a verified workqueue livelock with a small, localized, maintainer-
accepted change.

## Verification
- Phase 1: Parsed `git show --format=fuller` for `a7488f089bdfa`;
  confirmed tags and commit body.
- Phase 2: Inspected the diff; confirmed only `kernel/workqueue.c`
  changed with 12 insertions in `__queue_work()`.
- Phase 3: Used `git blame`, `git show`, `git describe --contains`, and
  path-limited `git log`; confirmed historical origins and stable
  version presence.
- Phase 4: Used `b4 dig -c`, `-a`, `-w`, and mbox fetch; confirmed v1
  patch and Tejun’s apply reply. WebFetch to lore was blocked.
- Phase 5: Used `rg` and `ReadFile` to trace callers/callees and the
  delayed-work/cancel path.
- Phase 6: Checked specific stable tags and ran patch apply checks in
  temporary worktrees; confirmed clean apply for `v6.18+` and backport
  needs for older trees.
- Phase 7: Verified subsystem path and recent workqueue history.
- Phase 8: Verified failure mode from commit body and matching code
  path; unprivileged trigger remains unverified.

**YES**

 kernel/workqueue.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c6ea96d5b7167..2c512b4a74482 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2281,6 +2281,18 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 	if (unlikely(wq->flags & (__WQ_DESTROYING | __WQ_DRAINING) &&
 		     WARN_ONCE(!is_chained_work(wq), "workqueue: cannot queue %ps on wq %s\n",
 			       work->func, wq->name))) {
+		struct work_offq_data offqd;
+
+		/*
+		 * State on entry: PENDING is set, work is off-queue (no
+		 * insert_work() has run).
+		 *
+		 * Returning without clearing PENDING would leave the work
+		 * in a weird state (PENDING=1, PWQ=0, entry empty)
+		 */
+		work_offqd_unpack(&offqd, *work_data_bits(work));
+		set_work_pool_and_clear_pending(work, offqd.pool_id,
+						work_offqd_pack_flags(&offqd));
 		return;
 	}
 	rcu_read_lock();
-- 
2.53.0

