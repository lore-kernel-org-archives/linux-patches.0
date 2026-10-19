Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A386238A0;
	Mon, 19 Oct 2026 14:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418693; cv=none; b=s5dDmhQhy3bUfs50TQyFQtBlBhjDqPwHGuaXRu28zbePy8RcQgDW+HwudXwRUCsvwrkaOW0jRX5MwKaveL/v/MIESvSnQWJUwmz9pQI4654eV6KmAEZVNkGYsk9Xx55IeWTngRuiB3NQCJjgLcp0k4DIwuUAlMfEFnWEMM4Clus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418693; c=relaxed/simple;
	bh=ft629vtileep1FfktRDH0L4etrkbJbrC8XDK3cHHkWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EfvDvdrPCDUtr9h2hKc3IqRLrVRTsSk9eAsdPVKDWi3PwGavVLvypLIxdZHq+pFwlM2wgwjt80AfUrIWy4ltGceCCZFZwXIuhO3wi2WPMVng835jcyXx+I9i8YIRMpyLFlwE7Cn+LB5VtPMwyklbQxK2GiLlwNgwbiKhsevKm/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOfWy+Bu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOfWy+Bu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681EE1F000C9;
	Mon, 19 Oct 2026 14:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418690;
	bh=4amEEY/Xct1faar7l9czoxlKhgGqkKJbq754RzhoEmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jOfWy+BuXrTl8vItMCjvJtfMgVCfoAfYqcU0HA9oQ5a4DVxgwzVc5tp42HmkE80Qf
	 p8adFBF6IGGWG1ZBEx4YBVGl3oq9DhvGKJxqqqX3DPCOmMhTrMcxTUOwmWdQpedWws
	 2b2IWbPzdWrq4yMP1VBGt5GQCBKetUeT8YaAo9kyJKdxwarmWEqjTLXkF17ieo7XNK
	 Mru+hBkOTMDqHc5V1X1cG6dxuZ6ZnA3/Jdm2Qg8Z8zNKcgiECbI0DSkxjo3H6kWU2v
	 1TCnkqH81BHmW1xQaVR+pQ2/TRJDtrh3ZbJHqgaisyXLT9m87y0TFPMm+j1z74Uf0K
	 CROb5LuYAIl4A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daeho Jeong <daehojeong@google.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] f2fs: avoid setting SBI_NEED_FSCK on transient resize failure
Date: Mon, 19 Oct 2026 09:51:58 -0400
Message-ID: <20261019135441.1420968-427-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 258c95150c26a30db1896eacd3bdef26314f2ca1 ]

When free_segment_range() fails in f2fs_resize_fs(), no on-disk
superblock or filesystem metadata has been modified yet, and
free_segment_range() safely restores all in-memory counters before
returning.

However, the current error recovery path unconditionally sets the
SBI_NEED_FSCK flag and prints a scary error message on any error,
forcing an unnecessary and time-consuming fsck.f2fs repair on the
subsequent mount/reboot.

Fix this by separating the error recovery path with a dedicated
recover_user_blocks label to bypass setting SBI_NEED_FSCK on
free_segment_range() failures.

Signed-off-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Sunmin Jeong <s_min.jeong@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the local 6.12 code, the introducer, and the mailing-list review.
Compiling the full nine-phase analysis next.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [f2fs] [avoid setting] Avoid setting `SBI_NEED_FSCK` when
`f2fs_resize_fs()` fails in `free_segment_range()` before any on-disk
metadata is modified.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Daeho Jeong <daehojeong@google.com> (author,
  Google/Android f2fs)
- Signed-off-by: Sunmin Jeong <s_min.jeong@samsung.com>
- Reviewed-by: Chao Yu <chao@kernel.org> (primary f2fs reviewer)
- Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org> (f2fs maintainer)
- No Fixes: tag (expected)
- No Cc: stable (expected)
- No Reported-by / Tested-by / Link / syzbot
- Ignore pipeline-added Sasha Levin SOB / Upstream commit markers if
  present

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: `f2fs_resize_fs()` error recovery sets `SBI_NEED_FSCK` on any
  error after `free_segment_range()`, including failures that happen
  before `update_sb_metadata()` / `f2fs_commit_super()`.
- Symptom: scary `f2fs_err` plus a persistent “need fsck” mark, so the
  next mount/reboot runs a long `fsck.f2fs` even though the filesystem
  is still consistent.
- Root cause: one shared `recover_out` label for both “GC/segment-free
  failed, nothing committed” and “superblock/checkpoint already
  changed.”
- Version info: none in the message. Code has been this way since online
  resize was added.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden. It is an explicit error-path correctness fix: stop
treating a transient resize failure as filesystem corruption.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `fs/f2fs/gc.c` only (~6 insertions / 3 deletions in
  `f2fs_resize_fs()`)
- Functions: `f2fs_resize_fs()`
- Scope: single-file surgical error-path change

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record (verified against local `fs/f2fs/gc.c`):
- Before: `free_segment_range()` error → `goto recover_out` → always
  `set_sbi_flag(SBI_NEED_FSCK)` + restore `user_block_count`.
- After: `free_segment_range()` error → `goto recover_user_blocks` →
  restore `user_block_count` / clear `SBI_IS_RESIZEFS` only.
- `recover_out` still used after `f2fs_commit_super()` /
  `f2fs_write_checkpoint()` failures (on-disk metadata already touched).
  It now also `f2fs_bug_on(sbi, err == -EAGAIN)` then sets
  `SBI_NEED_FSCK`, then falls through to restore `user_block_count`.
- Success path still falls through both labels with `err == 0`; no extra
  NEED_FSCK, no counter restore.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: logic / error-path correctness (false-positive corruption
  flag)
- Mechanism: `free_segment_range()` restores `MAIN_SECS` on every return
  (`MAIN_SECS(sbi) += secs` at its `out:` label). Callers have not yet
  called `update_sb_metadata()`. Marking NEED_FSCK is wrong for that
  path.
- Common trigger in this tree: `f2fs_gc_range()` returns `-EAGAIN` when
  valid blocks remain after one GC pass (`gc.c` “if (!dry_run &&
  get_valid_blocks(...)) return -EAGAIN”).

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: splits “no metadata written” vs “metadata already
  updated.”
- Minimal; no API/data-structure change.
- Regression risk low. `f2fs_bug_on(err == -EAGAIN)` on `recover_out` is
  an invariant: with `CONFIG_F2FS_CHECK_FS=n` it WARNs and sets
  NEED_FSCK (already being set); with CHECK_FS it BUG_ONs only if
  checkpoint/super commit returned `-EAGAIN`, which that path should
  not.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Unconditional NEED_FSCK on resize failure introduced in
  `04f0b2eaa3b3ee` (“f2fs: ioctl for removing a range from F2FS”,
  Qiuyang Sun, 2019).
- `recover_out` label from `b4b10061ef98c5` (Jaegeuk Kim, 2020).
- Present in this 6.12 tree (`git merge-base --is-ancestor
  04f0b2eaa3b3ee HEAD` succeeded).

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Introducer is the 2019 online-resize ioctl,
confirmed in-tree.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Related in-tree: `3b85edf3391f3` (migrate all curseg types in
  `free_segment_range`), `28fc4e9077ce5` (SBI_IS_RESIZEFS locking),
  `3ab0598e6d860` (resize panic). None already skip NEED_FSCK on
  `free_segment_range()` failure.
- Later mainline (f2fs-for-7.3-rc1, after this patch): “accurately
  adjust free_sections during free_segment_range” — separate accounting
  fix, not a prerequisite.
- Standalone.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Daeho Jeong is a regular Google/Android f2fs contributor in this
tree (gc/zoned/sysfs work). Co-author Samsung. Maintainer Jaegeuk
applied it.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: No new helpers. Uses existing `set_sbi_flag` / `f2fs_bug_on` /
`recover_out`. Surrounding mainline context uses `f2fs_down_write_trace`
and 3-arg `thaw_super`, which this tree does not have; those are context
only, not dependencies of the logic change. Can apply standalone with a
trivial context tweak.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c <sha>` not used: candidate SHA is not in this checkout (`b4
  dig` on the f2fs-for-7.3-rc1 merge 115bd364 rejected as a merge
  commit).
- `b4 mbox` msgid `20260818170535.3190869-1-daeho43@gmail.com`:
  5-message v1 thread saved.
- v1 (18 Aug 2026): skip NEED_FSCK only when `err != -EAGAIN`.
- Chao Yu: don’t key off `-EAGAIN` globally; it might come from other
  sites later.
- Daeho: any `free_segment_range()` error is pre-metadata; use a
  separate label.
- Chao: add `f2fs_bug_on(sbi, err == -EAGAIN)` on `recover_out`.
- v2 (20 Aug 2026): matches this candidate. Chao Reviewed-by. No NAKs.
  No Cc: stable in the thread.
- Landed in f2fs-for-7.3-rc1 (merged to mainline as 115bd364, “f2fs:
  avoid setting SBI_NEED_FSCK on transient resize failure”).

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: linux-f2fs-devel, linux-kernel, kernel-team@android.com.
Reviewed by Chao Yu; applied by Jaegeuk Kim.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Authors are Android/Samsung; the message
describes forced fsck after a failed resize. No separate user bug URL
found.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone (v1 then v2 of the same idea). Same 7.3 pull has
other `free_segment_range` fixes; this one does not depend on them.
“migrate all curseg types” is already here.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: Web search of lore.kernel.org/stable for this subject found no
prior stable discussion or rejection. UNVERIFIED that no one privately
requested it.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `f2fs_resize_fs()`; closely related callees
`free_segment_range()`, `update_sb_metadata()`, `f2fs_commit_super()`,
`f2fs_write_checkpoint()`.

Step 5.2: TRACE CALLERS
Record:
- `f2fs_ioc_resize_fs()` in `fs/f2fs/file.c` (F2FS_IOC_RESIZE_FS and
  compat). Requires `CAP_SYS_ADMIN`.
- Not interrupt/hot-path. Userspace-triggered admin ioctl (Android
  update_engine/vold online shrink is the main production use).

Step 5.3: TRACE CALLEES
Record: `free_segment_range()` temporarily drops `MAIN_SECS`, may move
cursegs and GC, then always `MAIN_SECS += secs` before return. Only
after success does `f2fs_resize_fs()` call `update_sb_metadata()` /
`f2fs_commit_super()`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: ioctl → `f2fs_resize_fs` → freeze → `user_block_count -=
shrunk_blocks` → `free_segment_range`. `-EAGAIN` when tail sections
still have valid blocks is reachable and expected. After NEED_FSCK is
set, a later resize hits `is_sbi_flag_set(sbi, SBI_NEED_FSCK)` and
returns `-EFSCORRUPTED`. Checkpoint persists `CP_FSCK_FLAG`; remount
restores NEED_FSCK.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: NEED_FSCK is used widely for real corruption. This was the only
resize path that set it on a fully rolled-back in-memory failure. In-
tree “f2fs: remove false alarm on iget failure during GC” is the same
class of false NEED_FSCK.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Local tree is `pending-6.12`, `git describe HEAD` =
`p-6.12-3-gc504cf0baa3d8`, `make kernelversion` = 6.12.111.
```
2364:   set_sbi_flag(sbi, SBI_IS_RESIZEFS);
2365:   err = free_segment_range(sbi, secs, false);
2366:   if (err)
2367:           goto recover_out;
...
2388:recover_out:
2390:   if (err) {
2391:           set_sbi_flag(sbi, SBI_NEED_FSCK);
```
Bug present since 2019 resize ioctl. `recover_user_blocks` is absent.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Functional hunk matches. Mainline context uses
`f2fs_down_write_trace` (not in 6.12) and `thaw_super(...,
FREEZE_HOLDER_KERNEL, NULL)` vs local two-arg `FREEZE_HOLDER_USERSPACE`.
Expected difficulty: minor context adjustment, not a rework.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No. `git log --grep` on gc.c for this subject is empty. Resize-
related commits here do not skip NEED_FSCK on `free_segment_range()`
failure.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: f2fs (`fs/f2fs/`). IMPORTANT: not core VFS, but the default
Android userdata filesystem; 6.12 LTS is used there.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Active (recent gc.c history is busy), but this bug is in long-
stable resize recovery, not new 6.12-only code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: f2fs users of `F2FS_IOC_RESIZE_FS` (Android virtual A/B /
dynamic partitions, some embedded). Not universal. Config:
`CONFIG_F2FS_FS`.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Shrink ioctl while tail sections still have valid blocks
(`-EAGAIN`), or other `free_segment_range()` errors (`-EIO`,
`-ERESTARTSYS`, allocate-segment failures). Common on a busy/full
filesystem. Privileged only (`CAP_SYS_ADMIN`). Not a race; deterministic
on that error path.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- False `SBI_NEED_FSCK` → next checkpoint writes `CP_FSCK_FLAG` →
  remount restores the flag → userspace `fsck.f2fs`.
- Further resize immediately `-EFSCORRUPTED`.
- `fstrim` warns and returns `-EFSCORRUPTED`; discard thread backs off.
- Severity: HIGH operational (forced long fsck, resize stuck). Not a
  panic, silent corruption, or UAF.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for Android/embedded f2fs-resize users on 6.12; stops a
  common `-EAGAIN` from pinning NEED_FSCK until fsck.
- Risk: very low (few lines, error path only, maintainer-acked).
- Ratio: favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real, long-standing bug (2019) still in 6.12.111.
- Common `-EAGAIN` from GC during shrink is treated as corruption.
- Sticky NEED_FSCK blocks resize and can force a large-partition fsck.
- Small, obviously correct, reviewed by Chao Yu, applied by Jaegeuk.
- Google/Samsung authors; Android team on Cc.
- No missing helpers in this tree.

AGAINST:
- Not a crash, UAF, or on-disk corruption (it over-reports corruption).
- Privileged ioctl, not unprivileged.
- Exact mainline hunk needs trivial context (lock wrappers /
  thaw_super).
- No Fixes:/Cc: stable (not a negative per the rules).

UNRESOLVED:
- Exact mainline SHA not in this checkout (present in 7.3-rc1 f2fs
  pull).
- No stable-list thread found.
- Daeho mentioned restoring `free_sections`; 6.12 `free_segment_range()`
  only restores `MAIN_SECS`. That does not weaken the NEED_FSCK split.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — review-driven v2; logic matches
   `free_segment_range()` rollback.
2. Fixes a real bug that affects users? PASS — false NEED_FSCK / forced
   fsck / resize stuck.
3. Important issue? PASS — not a panic, but persistent false corruption
   flag plus `-EFSCORRUPTED` on later resize/fstrim is a serious
   availability bug on Android f2fs.
4. Small and contained? PASS — one function, ~9 lines.
5. No new features or APIs? PASS
6. Can apply to the local tree? PASS — buggy code present; needs only
   context adjustment.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None of device-ID / quirk / DT / build / docs. Ordinary bugfix.

Step 9.4: MAKE YOUR DECISION
This belongs on 6.12. The bug exists here, the fix is surgical, and
leaving it out keeps a production Android path where a retryable shrink
failure marks the filesystem corrupted until fsck.

What it solves for stable users: a failed `F2FS_IOC_RESIZE_FS` that
never committed superblock/FS metadata currently sets `SBI_NEED_FSCK`.
That flag is checkpointed as `CP_FSCK_FLAG`, blocks later resize with
`-EFSCORRUPTED`, and forces a long `fsck.f2fs`. The usual trigger is
`-EAGAIN` from GC when the tail is not empty yet.

Risk vs benefit: a few error-path lines, fall-through restore preserved,
NEED_FSCK still set after real super/checkpoint failures. Benefit is
large for f2fs resize users on this LTS.

Concerns: apply with 6.12 lock/thaw context, not the mainline
`f2fs_down_write_trace` / 3-arg `thaw_super` lines.

Verification:
- [Phase 1] Tags: Chao Reviewed-by, Jaegeuk SOB, Google+Samsung; no
  Fixes/syzbot
- [Phase 2] Diff: `goto recover_user_blocks` on `free_segment_range()`
  error; NEED_FSCK only on `recover_out`
- [Phase 2] Local `free_segment_range()`: `MAIN_SECS += secs` on all
  exits before `update_sb_metadata()`
- [Phase 2] Local `f2fs_gc_range()`: `-EAGAIN` if valid blocks remain
- [Phase 3] blame: NEED_FSCK from 04f0b2eaa3b3ee (2019); ancestor of
  HEAD
- [Phase 3] `git merge-base --is-ancestor 04f0b2eaa3b3ee HEAD` succeeded
- [Phase 3] No `recover_user_blocks` in this tree
- [Phase 4] `b4 mbox` msgid 20260818170535.3190869-1-daeho43@gmail.com:
  v1, Chao review, label split
- [Phase 4] v2 + Chao Reviewed-by via lkml/openwall; no NAK
- [Phase 4] Pull f2fs-for-7.3-rc1 lists this subject
- [Phase 4] lore.kernel.org WebFetch 403; used b4 mbox + lkml mirrors
  instead
- [Phase 5] Caller: `f2fs_ioc_resize_fs`, `CAP_SYS_ADMIN`; NEED_FSCK
  blocks resize (`gc.c:2293`) and fstrim (`segment.c:3400`); checkpoint
  writes `CP_FSCK_FLAG` (`checkpoint.c:1386-1387`); remount restores it
  (`super.c:4642-4643`)
- [Phase 6] `git describe HEAD` p-6.12-3-gc504cf0baa3d8; `make
  kernelversion` 6.12.111
- [Phase 6] `f2fs_down_write_trace` absent; `thaw_super` is 2-arg
- [Phase 8] Failure: false NEED_FSCK, not oops; HIGH operational impact
- UNVERIFIED: exact mainline SHA (not in this checkout); no stable-list
  hit

**YES**

 fs/f2fs/gc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 02bd008d79b5c..e85d7f239e7d0 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2415,7 +2415,7 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
 	set_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	err = free_segment_range(sbi, secs, false);
 	if (err)
-		goto recover_out;
+		goto recover_user_blocks;
 
 	update_sb_metadata(sbi, -secs);
 
@@ -2437,11 +2437,14 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
 		f2fs_commit_super(sbi, false);
 	}
 recover_out:
-	clear_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	if (err) {
+		f2fs_bug_on(sbi, err == -EAGAIN);
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		f2fs_err(sbi, "resize_fs failed, should run fsck to repair!");
-
+	}
+recover_user_blocks:
+	clear_sbi_flag(sbi, SBI_IS_RESIZEFS);
+	if (err) {
 		spin_lock(&sbi->stat_lock);
 		sbi->user_block_count += shrunk_blocks;
 		spin_unlock(&sbi->stat_lock);
-- 
2.53.0

