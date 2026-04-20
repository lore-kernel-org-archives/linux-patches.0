Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BC93A8730;
	Mon, 20 Apr 2026 13:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690985; cv=none; b=skW+qqRAGgDdfKX7Snoat3neKeOYIX4bQ7YG/Llnm2II0rXowm7vN0ISUY8GAYEYM4oqFsqub2V9Lq4kmBgAD/uYFPFGCEmmdmzVg4jFqe/9TKQbhq8CV2A8IaBJ4YEk+5IuM4Q1lpmF4ExsYkayBYK/5/QfV1ms+412sEZfV5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690985; c=relaxed/simple;
	bh=4ac5VFJqRpwie/oCRdGJcKvf1pxCdANGgNIs75pGaPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o5YLofdSWO4aMxdQF1cYkxGRlic5gR3OoNlspLCIPisc4FHpbSGOEJIejXlUDl0+BH1/kw7Y2FHyPPPYxAxG//n6rYqCyRHsD9BRQXPSgKrcPvOXE55ojG51NmK6SIGs+DMBxydDzDZ+Xip/ZGPSyH5gykaQ01RmNtLAmDTIsTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sG0ZnFM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sG0ZnFM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C168BC2BCB9;
	Mon, 20 Apr 2026 13:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690983;
	bh=4ac5VFJqRpwie/oCRdGJcKvf1pxCdANGgNIs75pGaPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sG0ZnFM04I5FzaHksXSnvEs2AOYQcqQTsuaY635WI3CyDjwCMdHVF64V0q/JbefdX
	 d7zNsTRfmFKyWLD+DjYTMZQb7SobWX8n8iaBd8WY9NZx+UNOSALN218aEWPOdMDuiX
	 UCpLfZ5Uat7j8fjvdw27umrhoSrW1RMzogEyOdrjUA1a86GD8kKGYEReB4TLuhRh2O
	 eNyJLUytwHRh4KtFt0sl5I/s43jX9wUlpnuOpmYgzHt6Y8iKA2UAOqVudmi2simdpY
	 KCGI4stFRfdjluHCWgR/oSNwViz5syQkSI3raWLYDKbVpgPUXWz1Y4qRlXqhg+BRO7
	 9WvK4zECpBr5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Edward Adam Davis <eadavis@qq.com>,
	syzbot+1d38eedcb25a3b5686a7@syzkaller.appspotmail.com,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	shaggy@kernel.org,
	jfs-discussion@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] jfs: Set the lbmDone flag at the end of lbmIODone
Date: Mon, 20 Apr 2026 09:08:12 -0400
Message-ID: <20260420131539.986432-26-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit b15e4310633f90072d66cc9b6692acbf6b4d7d00 ]

In lbmRead(), the I/O event waited for by wait_event() finishes before
it goes to sleep, and the lbmIODone() prematurely sets the flag to
lbmDONE, thus ending the wait. This causes wait_event() to return before
lbmREAD is cleared (because lbmDONE was set first), the premature return
of wait_event() leads to the release of lbuf before lbmIODone() returns,
thus triggering the use-after-free vulnerability reported in [1].

Moving the operation of setting the lbmDONE flag to after clearing lbmREAD
in lbmIODone() avoids the use-after-free vulnerability reported in [1].

[1]
BUG: KASAN: slab-use-after-free in rt_spin_lock+0x88/0x3e0 kernel/locking/spinlock_rt.c:56
Call Trace:
 blk_update_request+0x57e/0xe60 block/blk-mq.c:1007
 blk_mq_end_request+0x3e/0x70 block/blk-mq.c:1169
 blk_complete_reqs block/blk-mq.c:1244 [inline]
 blk_done_softirq+0x10a/0x160 block/blk-mq.c:1249

Allocated by task 6101:
 lbmLogInit fs/jfs/jfs_logmgr.c:1821 [inline]
 lmLogInit+0x3d0/0x19e0 fs/jfs/jfs_logmgr.c:1269
 open_inline_log fs/jfs/jfs_logmgr.c:1175 [inline]
 lmLogOpen+0x4e1/0xfa0 fs/jfs/jfs_logmgr.c:1069
 jfs_mount_rw+0xe9/0x670 fs/jfs/jfs_mount.c:257
 jfs_fill_super+0x754/0xd80 fs/jfs/super.c:532

Freed by task 6101:
 kfree+0x1bd/0x900 mm/slub.c:6876
 lbmLogShutdown fs/jfs/jfs_logmgr.c:1864 [inline]
 lmLogInit+0x1137/0x19e0 fs/jfs/jfs_logmgr.c:1415
 open_inline_log fs/jfs/jfs_logmgr.c:1175 [inline]
 lmLogOpen+0x4e1/0xfa0 fs/jfs/jfs_logmgr.c:1069
 jfs_mount_rw+0xe9/0x670 fs/jfs/jfs_mount.c:257
 jfs_fill_super+0x754/0xd80 fs/jfs/super.c:532

Reported-by: syzbot+1d38eedcb25a3b5686a7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1d38eedcb25a3b5686a7
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed to complete the full analysis. Let
me compile the results.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
Record: [jfs] [Set/fix] Move the lbmDONE flag assignment to the end of
lbmIODone to prevent a use-after-free race.

**Step 1.2: Tags**
- Reported-by: syzbot+1d38eedcb25a3b5686a7@syzkaller.appspotmail.com
  (syzbot fuzzer-found bug)
- Closes: https://syzkaller.appspot.com/bug?extid=1d38eedcb25a3b5686a7
  (syzbot bug tracker)
- Signed-off-by: Edward Adam Davis <eadavis@qq.com> (author)
- Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com> (JFS
  maintainer)
- No Fixes: tag, no Cc: stable (expected for candidates under review)

Record: Syzbot-reported, maintainer-signed. Strong quality signals.

**Step 1.3: Commit Body**
The commit describes a race in `lbmRead()`: the `wait_event()` condition
`bp->l_flag != lbmREAD` becomes true prematurely when `lbmIODone()` sets
`lbmDONE` BEFORE clearing `lbmREAD`. This allows `wait_event()` to
return before `lbmIODone()` finishes processing the buffer, causing the
buffer to be freed while `lbmIODone()` is still accessing it. Full KASAN
stack trace included showing slab-use-after-free.

Record: Bug = race condition causing UAF. Symptom = KASAN slab-use-
after-free in `blk_update_request`. Trigger = JFS mount path during log
initialization.

**Step 1.4: Hidden Bug Fix?**
No disguise needed - this is an explicit use-after-free fix with KASAN
evidence.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Single file: `fs/jfs/jfs_logmgr.c`
- Net change: ~7 lines removed, ~6 lines added (very surgical)
- Functions modified: `lbmIODone()` only

**Step 2.2: Code Flow Changes**
The key changes are:

1. **Removed** `bp->l_flag |= lbmDONE` from the beginning of
   `lbmIODone()`
2. **READ path**: Removed early `LCACHE_UNLOCK` and `return`, replaced
   with `LCACHE_WAKEUP` while still holding the lock, then `goto out`
3. **DIRECT path**: Changed `LCACHE_UNLOCK; return` to `goto out`
4. **SYNC path**: Removed `LCACHE_UNLOCK` before `LCACHE_WAKEUP`
5. **GC path**: Added `LCACHE_LOCK(flags)` after `lmPostGC(bp)` to re-
   acquire lock (avoiding the deadlock v1 had)
6. **ASYNC path**: Removed explicit `LCACHE_UNLOCK`
7. **Added** `out:` label at end: `bp->l_flag |= lbmDONE;
   LCACHE_UNLOCK(flags);`

Record: Single function refactored to consolidate exit paths through
single `out:` label. The `lbmDONE` flag is now set as the very last
operation before releasing the lock.

**Step 2.3: Bug Mechanism**
Category: **Race condition + Use-after-free**

The race:
1. `lbmRead()` submits bio, then calls `wait_event(bp->l_ioevent,
   (bp->l_flag != lbmREAD))`
2. `lbmIODone()` (bio completion handler) sets `lbmDONE` early →
   `l_flag` becomes `lbmREAD | lbmDONE` which `!= lbmREAD`
3. `wait_event()` on another CPU sees condition true (lockless check),
   returns
4. Caller continues, eventually frees the buffer on error paths
   (`lbmLogShutdown` → `kfree`)
5. `lbmIODone()` is still executing, accesses freed buffer → UAF

**Step 2.4: Fix Quality**
- Obviously correct: centralizes exit and delays the "done" signal to
  after all processing
- Minimal and surgical: single function, ~13 lines changed
- The v2 correctly handles the GC path deadlock (drops lock for
  `lmPostGC`, re-acquires after)
- Low regression risk: the lock ordering is preserved, exit paths are
  consolidated

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The buggy code (`bp->l_flag |= lbmDONE` at the start of `lbmIODone`) was
introduced in the initial Linux commit `1da177e4c3f41` (Linus Torvalds,
2005-04-16). This bug has been present since the very beginning of the
git history - ALL kernel versions are affected.

**Step 3.2: Fixes tag**
No Fixes: tag present. The bug predates all stable branch points.

**Step 3.3: File History**
No changes to `fs/jfs/jfs_logmgr.c` since v7.0. The file matches the
expected pre-patch state exactly. The fix applies cleanly.

**Step 3.4: Author**
Edward Adam Davis is a frequent contributor of syzbot-triggered fixes.
Dave Kleikamp (JFS maintainer) tested and applied the patch.

**Step 3.5: Dependencies**
No dependencies. This is a self-contained fix to a single function. The
code in the 7.0 tree at line 2183 matches the old code exactly.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: Patch Discussion**
- b4 dig found the original submission: https://patch.msgid.link/tencent
  _48DDBA00BB1033889E551BDE4B721B042508@qq.com
- Two revisions: v1 introduced a deadlock (caught by syzbot CI), v2
  fixed the deadlock by keeping the `LCACHE_UNLOCK/lmPostGC/LCACHE_LOCK`
  pattern for the GC path
- Dave Kleikamp (JFS maintainer "Shaggy") replied: "Finally tested and
  applied to jfs-next"

**Step 4.2: Reviewers**
- CC'd: jfs-discussion, linux-block, linux-kernel, Jens Axboe, Dave
  Kleikamp
- Applied by the JFS maintainer after testing

**Step 4.3: Bug Report**
- Syzbot first reported this bug on Nov 1, 2024 (6.12-rc5)
- C reproducer available since Dec 7, 2025
- Bug has been active for 708+ days
- Multiple syzbot reproducers show it's reliably triggerable
- Also found on linux-6.1 stable tree (separate syzbot entry)
- Jens Axboe reassigned the subsystem from "block?" to "jfs"

**Step 4.4: Series Context**
Standalone single patch (not part of a series). The v2 is the final
applied version.

**Step 4.5: Stable Discussion**
No explicit stable nomination found, but the syzbot bug page shows it
was also found on linux-6.1 stable tree.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
Only `lbmIODone()` - the bio completion handler for JFS log buffers.

**Step 5.2: Callers**
`lbmIODone` is called:
1. As `bio->bi_end_io` callback from block layer (softirq context) -
   async I/O completion
2. Directly from `lbmRead()` when `log->no_integrity` is true
   (synchronous)

**Step 5.3: Callees**
`lbmIODone` calls: `bio_put`, `LCACHE_WAKEUP` (wake_up), `lbmRedrive`,
`lmPostGC`, `lbmfree`

**Step 5.4: Call Chain**
Trigger path: `mount()` → `jfs_fill_super` → `jfs_mount_rw` →
`lmLogOpen` → `lmLogInit` → `lbmRead` → `submit_bio` → (bio completion
on another CPU) → `lbmIODone` → UAF

This is reachable from the `mount()` syscall - unprivileged users can
trigger it (with a crafted JFS filesystem image).

**Step 5.5: Similar Patterns**
`lbmIOWait()` uses `LCACHE_SLEEP_COND` which holds the lock during
condition checks, making it immune to this race. Only `lbmRead()` uses
the lockless `wait_event` and is affected.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code Existence**
The buggy code has been present since 2005. It exists in ALL stable
trees. The syzbot dashboard confirms it was also found on linux-6.1.

**Step 6.2: Backport Complications**
The file has NO changes since v7.0 in this tree. The patch should apply
cleanly.

**Step 6.3: Related Fixes**
No related fixes found in the tree. This is the first fix for this bug.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem**
JFS filesystem (`fs/jfs/`). Criticality: IMPORTANT - filesystem bugs can
lead to data corruption or system crashes. While JFS is not the most
widely used filesystem, it has real users especially in enterprise
environments.

**Step 7.2: Activity**
JFS is a mature, low-activity subsystem. The bug has been present for
~20 years, affecting all kernel versions.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
All users who mount JFS filesystems. Also security-relevant as it can be
triggered with a crafted filesystem image.

**Step 8.2: Trigger Conditions**
- Triggered during JFS mount (`lmLogInit` → `lbmRead`)
- Requires multi-CPU system and specific timing (I/O completion racing
  with `wait_event`)
- Syzbot has a C reproducer - reliably triggerable
- Can be triggered by unprivileged users mounting a filesystem
  (depending on policy)

**Step 8.3: Failure Mode**
KASAN: slab-use-after-free → potential kernel crash, memory corruption,
or exploitable vulnerability. Severity: **CRITICAL**

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: Very high - fixes a KASAN-detected UAF with reproducer,
  present in all kernels
- RISK: Low - single file, well-contained, tested by maintainer, v2
  addressed deadlock issue from v1
- The change consolidates exit paths which is structurally cleaner

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Compilation**

FOR backporting:
- Fixes slab-use-after-free (KASAN-verified, syzbot-reported with C
  reproducer)
- Bug present since initial Linux git commit (2005) - affects ALL stable
  trees
- Triggered from mount() syscall - reachable from userspace
- Single file, single function, ~13 lines changed
- JFS maintainer tested and applied
- v2 iteration fixed a deadlock found by syzbot CI in v1
- Clean apply expected (no file changes since v7.0)
- Bug active 708+ days, also found on linux-6.1 stable

AGAINST backporting:
- (None significant)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** - maintainer tested, v2
   addresses v1's deadlock
2. Fixes a real bug? **YES** - KASAN UAF with syzbot reproducer
3. Important issue? **YES** - UAF in filesystem mount path
   (crash/security)
4. Small and contained? **YES** - single function in single file
5. No new features/APIs? **YES** - pure bug fix
6. Can apply to stable? **YES** - no changes to file since v7.0

**Step 9.3: Exception Categories**
Not an exception category - this is a standard high-priority bug fix.

**Step 9.4: Decision**
Clear YES. This fixes a critical use-after-free vulnerability in JFS
that has been present since 2005, is syzbot-verified with a reproducer,
and is a small, well-tested, maintainer-approved fix.

---

## Verification

- [Phase 1] Parsed tags: Reported-by: syzbot, Closes: syzkaller link,
  SOB from author and JFS maintainer
- [Phase 2] Diff analysis: `lbmDONE` flag move from start to end of
  `lbmIODone()`, consolidated exit paths via `goto out`
- [Phase 3] git blame: buggy code (`bp->l_flag |= lbmDONE` at line 2183)
  from commit 1da177e4c3f41 (2005), present in ALL kernels
- [Phase 3] git log v7.0..: confirmed no changes to file since v7.0
  branch point
- [Phase 4] b4 dig -c b15e4310633f: found original at https://patch.msgi
  d.link/tencent_48DDBA00BB1033889E551BDE4B721B042508@qq.com
- [Phase 4] b4 dig -a: two revisions (v1 had deadlock, v2 fixed it)
- [Phase 4] b4 dig -w: JFS maintainer (Dave Kleikamp/shaggy@kernel.org),
  Jens Axboe, mailing lists were CC'd
- [Phase 4] mbox thread: Dave Kleikamp tested and applied to jfs-next;
  syzbot CI found deadlock in v1 confirming proper testing
- [Phase 4] syzbot dashboard: bug first reported Nov 2024, C reproducer
  available, 708+ days active, also on linux-6.1
- [Phase 5] Traced call chain: mount() → jfs_fill_super → jfs_mount_rw →
  lmLogOpen → lmLogInit → lbmRead → submit_bio → lbmIODone (race)
- [Phase 5] Verified `lbmRead` uses lockless `wait_event` (line 1989) vs
  `lbmIOWait` using locked `LCACHE_SLEEP_COND` (line 2151)
- [Phase 5] Verified `__SLEEP_COND` macro in jfs_lock.h - confirmed
  lockless condition check in wait_event is the root cause
- [Phase 6] Code exists in ALL stable trees (bug since 2005)
- [Phase 6] Clean apply expected - no file changes since v7.0
- [Phase 8] Failure mode: slab-use-after-free → potential kernel
  crash/exploit, severity CRITICAL

**YES**

 fs/jfs/jfs_logmgr.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index d8266220776e8..306165e61438c 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2178,8 +2178,6 @@ static void lbmIODone(struct bio *bio)
 
 	LCACHE_LOCK(flags);		/* disable+lock */
 
-	bp->l_flag |= lbmDONE;
-
 	if (bio->bi_status) {
 		bp->l_flag |= lbmERROR;
 
@@ -2194,12 +2192,10 @@ static void lbmIODone(struct bio *bio)
 	if (bp->l_flag & lbmREAD) {
 		bp->l_flag &= ~lbmREAD;
 
-		LCACHE_UNLOCK(flags);	/* unlock+enable */
-
 		/* wakeup I/O initiator */
 		LCACHE_WAKEUP(&bp->l_ioevent);
 
-		return;
+		goto out;
 	}
 
 	/*
@@ -2223,8 +2219,7 @@ static void lbmIODone(struct bio *bio)
 
 	if (bp->l_flag & lbmDIRECT) {
 		LCACHE_WAKEUP(&bp->l_ioevent);
-		LCACHE_UNLOCK(flags);
-		return;
+		goto out;
 	}
 
 	tail = log->wqueue;
@@ -2276,8 +2271,6 @@ static void lbmIODone(struct bio *bio)
 	 * leave buffer for i/o initiator to dispose
 	 */
 	if (bp->l_flag & lbmSYNC) {
-		LCACHE_UNLOCK(flags);	/* unlock+enable */
-
 		/* wakeup I/O initiator */
 		LCACHE_WAKEUP(&bp->l_ioevent);
 	}
@@ -2288,6 +2281,7 @@ static void lbmIODone(struct bio *bio)
 	else if (bp->l_flag & lbmGC) {
 		LCACHE_UNLOCK(flags);
 		lmPostGC(bp);
+		LCACHE_LOCK(flags);		/* disable+lock */
 	}
 
 	/*
@@ -2300,9 +2294,11 @@ static void lbmIODone(struct bio *bio)
 		assert(bp->l_flag & lbmRELEASE);
 		assert(bp->l_flag & lbmFREE);
 		lbmfree(bp);
-
-		LCACHE_UNLOCK(flags);	/* unlock+enable */
 	}
+
+out:
+	bp->l_flag |= lbmDONE;
+	LCACHE_UNLOCK(flags);
 }
 
 int jfsIOWait(void *arg)
-- 
2.53.0

