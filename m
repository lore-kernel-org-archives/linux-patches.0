Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3CD4218B8;
	Tue, 28 Apr 2026 10:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372975; cv=none; b=X9G0OZlxDvqueWBRNxX/M8WZk7F/m8onoyFXOwajbeCbYjrjcZb3sIidGWJBvdnAGiENB+6THl3kuH/BUrepgM1U3gx1WUp1MKG2meBeESPbw8chxpmAc7anMOKxOsFOrzxdEcqJRqCdl/VO+PW7kJky1HwbWT5uYtqazd+P7+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372975; c=relaxed/simple;
	bh=LI1iQlZbbQDjNAhGAk0kGRLEV+00qPcgqSX3MRDOdcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l39b3t8JSE7ssN1SVgFEMk7FKtnrKPudDmOUljfVH192K/obnQjP1kOtP/FegzwWdh1G5QmURRVNa2O+Jwz7qsNs4m6NLC5yHK59dukwJRaYf/C8MhAIcdCl1w5Nk3OIDHOpDoljCHC1jY3gWx7jQmp9qXL4or+TAA28bZErIoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ca7sHpUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ca7sHpUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B43C2BCB6;
	Tue, 28 Apr 2026 10:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372975;
	bh=LI1iQlZbbQDjNAhGAk0kGRLEV+00qPcgqSX3MRDOdcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ca7sHpUJPIoT34bX7NpnJ37/Db/O5MhK1mY9Xw9AIaBNzKZtWUYWpw43ILTX9koOD
	 9ggoD5O88VDQD73q4+y84S6gYgWlGv9AEG/ueP4mMiJ2pXaTbmKnQK2/P+ynJXEQNN
	 b/qxisTc7R+X+SrPFV0LWp4Z7BOXkgL0q1HDq3cy2H4mEivZtgtzrktgU1kvEEpgFI
	 RgHxZsq6QQ4/bG+BjD40j38o5d2sLVeimQLFinZgiHtyk4fITENYPW9ZwTFvBticHX
	 e66WQtcYlTEWga3tM79iBiEVQkawBMBYELB7VVNt9ul/xDZTRBnzDupVhNjZePv04q
	 JJLuF7zBDMUIg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] f2fs: fix to freeze GC and discard threads quickly
Date: Tue, 28 Apr 2026 06:41:07 -0400
Message-ID: <20260428104133.2858589-56-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 02d91398a602c394d72cd61a67c84e2730c5f79b ]

Suspend can fail if kernel threads do not freeze for a while.
f2fs_gc and f2fs_discard threads can perform long-running operations
that prevent them from reaching a freeze point in a timely manner.

This patch adds explicit freezing checks in the following locations:
1. f2fs_gc: Added a check at the 'retry' label to exit the loop quickly
   if freezing is requested, especially during heavy GC rounds.
2. __issue_discard_cmd: Added a 'suspended' flag to break both inner and
   outer loops during discard command issuance if freezing is detected
   after at least one command has been issued.
3. __issue_discard_cmd_orderly: Added a similar check for orderly discard
   to ensure responsiveness.

These checks ensure that the threads release locks safely and enter the
frozen state.

Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to complete the analysis. Let me write up
the full response.

## Phase 1: COMMIT MESSAGE FORENSICS

**Step 1.1 - Subject parsing**:
Record: [f2fs] [fix] [to freeze GC and discard threads quickly - ensures
kernel threads enter frozen state promptly during suspend]

**Step 1.2 - Tag parsing**:
- No Fixes: tag
- No Reported-by: tag
- Reviewed-by: Chao Yu <chao@kernel.org> (f2fs subsystem maintainer)
- Signed-off-by: Daeho Jeong (Google/Android), Jaegeuk Kim (f2fs
  maintainer)
- No Cc: stable tag
- No Link: to bug reports
Record: Minimal tags; reviewed by subsystem maintainer; author from
Android team

**Step 1.3 - Body analysis**:
Record: Bug described: "Suspend can fail if kernel threads do not freeze
for a while." Failure mode: suspend fails because GC and discard threads
perform long-running operations between `wait_event_freezable_timeout()`
wait points. Root cause: kernel PM framework times out waiting for
kthreads to freeze. Author's explanation: threads release locks safely
after exiting to wait point.

**Step 1.4 - Hidden bug fix detection**:
Record: This IS an explicit bug fix (says "fix to..."). Fixes kernel PM
suspend reliability - a real user-visible system-level bug.

## Phase 2: DIFF ANALYSIS

**Step 2.1 - Inventory**:
Record: 2 files, 21 lines added, 1 modified. gc.c: 10 additions
(do_garbage_collect, f2fs_gc). segment.c: 11 additions, 1 modified
(__issue_discard_cmd, __issue_discard_cmd_orderly). Scope: single-
subsystem, surgical.

**Step 2.2 - Code flow change**:
Record:
- `do_garbage_collect()`: After each segment migration, checks
  `freezing(current)`. If true, drops folio refs and jumps to new
  `stop:` label, bypassing further segments.
- `f2fs_gc()`: At `retry:` label (start of each GC round), checks
  freezing. If true, returns 0.
- `__issue_discard_cmd()`: After issuing ≥1 command, checks freezing,
  breaks both inner loop and outer loop via `suspended` flag.
- `__issue_discard_cmd_orderly()`: Similar check; breaks inner loop once
  ≥1 command issued.

**Step 2.3 - Bug mechanism**:
Record: Category (h) hardware/system workaround + (c) synchronization-
related. The mechanism: freezable kthreads only freeze at
`wait_event_freezable_timeout()` - between waits, the thread runs
uninterruptibly through GC segments or discard queues. When PM suspend
requests freezing, the kthread must reach the wait point within the
freezer timeout (~20s). With long GC/discard rounds, this timeout can be
exceeded → suspend fails.

**Step 2.4 - Fix quality**:
Record: Very conservative. Only takes effect when `freezing(current)` is
true (only true for freezable kthreads that called `set_freezable()`).
Progress-preserving: discard check requires `issued > 0` so at least one
command is made. Uses `unlikely()` hint. Zero risk in non-suspend paths.
No API/ABI changes.

## Phase 3: GIT HISTORY INVESTIGATION

**Step 3.1 - Blame**:
Record: The freezable GC/discard thread infrastructure was set up in
2017 (commits `1d7be2708277e` and `dc6febb6bcec7`). The
`wait_event_freezable_timeout()` conversion (removing old
`try_to_freeze()` mid-loop checks) landed in `94e7eb42414b6` (Dec 2023,
v6.8). Before v6.8, `try_to_freeze()` was called per-iteration of the
top-level loop, but inside nested GC/discard operations there was never
an explicit mid-operation check. The bug has been latent for a long time
and became worse after the v6.8 conversion.

**Step 3.2 - Fixes: tag**:
Record: Not applicable; no Fixes: tag present.

**Step 3.3 - Related commits**:
Record: Historical precedent: commit `1d7be2708277e` ("f2fs: try to
freeze in gc and discard threads") from 2017 was marked "Cc:
stable@vger.kernel.org" by Jaegeuk Kim - same kind of fix, same
subsystem, same author-maintainer. Similar freeze/suspend fix in btrfs:
`c7b478504b2e5` (btrfs scrub cancel on freeze, Oct 2025) - that one was
NOT Cc'd stable. Standalone patch, not part of a series.

**Step 3.4 - Author's role**:
Record: Daeho Jeong is a regular f2fs contributor from Google/Android
team, authored 20+ commits in gc.c/segment.c area. Reviewed by Chao Yu
(co-maintainer) and applied by Jaegeuk Kim (maintainer).

**Step 3.5 - Dependencies**:
Record: Standalone - no prerequisites. Uses only `freezing(current)`
(from `linux/freezer.h`) which has existed since early 2.6 kernels.

## Phase 4: MAILING LIST RESEARCH

**Step 4.1 - Patch discussion**:
Record: Lore URL: `https://lore.kernel.org/all/20260316185954.2185806-1-
daeho43@gmail.com/`. Patch went through v1→v2→v3. v2 added the
`do_garbage_collect()` check. v3 removed an unnecessary `suspended`
check in UMOUNT path. Reviewer (Chao Yu) asked whether to return -EBUSY
to signal interruption; author explained that 0 return preserves
caller's accounting semantics. Chao Yu confirmed "freezing(current) will
only be true in context of gc thread, for such background migration
condition, we don't care the error number."

**Step 4.2 - Reviewers**:
Record: Reviewed-by Chao Yu (co-maintainer). Applied by Jaegeuk Kim
(maintainer). CC'd: linux-kernel, linux-f2fs-devel, kernel-
team@android.com.

**Step 4.3 - Bug report**:
Record: No external bug report Link. The kernel-team@android.com Cc
strongly suggests this was motivated by Android device suspend issues,
though no public bug tracker reference.

**Step 4.4 - Series context**:
Record: Standalone single-patch, not part of a series. Revisions v1-v3
with no other patches in the series.

**Step 4.5 - Stable discussion**:
Record: No public discussion about stable nomination found in the
thread. Reviewer did not suggest "Cc: stable" despite the bug being a
suspend reliability issue.

## Phase 5: CODE SEMANTIC ANALYSIS

**Step 5.1 - Key functions**:
Record: `do_garbage_collect()` (gc.c:1782), `f2fs_gc()` (gc.c:1908),
`__issue_discard_cmd()` (segment.c:~1644),
`__issue_discard_cmd_orderly()` (segment.c:~1589).

**Step 5.2 - Callers**:
Record: `f2fs_gc()` called from: gc_thread_func (the freezable BG GC
thread), f2fs_balance_fs, resize path in super.c, ioctls in file.c
(F2FS_IOC_GARBAGE_COLLECT, F2FS_IOC_DEFRAGMENT). The `freezing(current)`
check only returns true in freezable-kthread context (gc_thread_func),
which is the problematic path. For ioctl/user-triggered paths, the check
is inert.

**Step 5.3 - Callees**:
Record: `do_garbage_collect` calls gc_node_segment/gc_data_segment (can
take significant time), f2fs_submit_merged_write. `__issue_discard_cmd`
submits block-layer discard commands.

**Step 5.4 - Reachability**:
Record: The bug path is highly reachable - every system running f2fs
with background GC/discard enabled (default) that goes through
suspend/resume will potentially hit this. Android devices and Linux
laptops with f2fs root are the primary affected population.

**Step 5.5 - Similar patterns**:
Record: Before commit `94e7eb42414b6` (v6.8), f2fs had `try_to_freeze()`
in the per-iteration top loop, but never mid-operation. This class of
suspend-timeout bug exists in other long-running background threads (see
btrfs scrub fix `c7b478504b2e5`).

## Phase 6: CROSS-REFERENCING

**Step 6.1 - Stable tree presence**:
Record: The freezable GC/discard thread infrastructure exists in ALL
currently-supported stable trees (6.1+ have freezable GC/discard; 6.8+
specifically use `wait_event_freezable_timeout`). The specific
do_garbage_collect() structure with `sum_folio`/`folio_put_refs` only
exists in v6.17+. Pre-6.17 trees use `sum_page`/`f2fs_put_page`.

**Step 6.2 - Backport complications**:
Record:
- 6.19+: Clean apply
- 6.17: Likely clean apply (uses sum_folio)
- 6.16: Would need adjustment (sum_folio but different structure)
- 6.15 and older: Would need manual backport (sum_page vs sum_folio,
  different f2fs_put_page semantics, missing `stop:` label
  infrastructure in do_garbage_collect)
- The f2fs_gc() retry-label change and segment.c changes apply cleanly
  to all trees back to 6.8.

**Step 6.3 - Existing fixes**:
Record: No alternative fix for this specific issue found in stable
trees.

## Phase 7: SUBSYSTEM CONTEXT

**Step 7.1 - Subsystem**:
Record: fs/f2fs - filesystem commonly used on Android devices and some
Linux distributions. Criticality: IMPORTANT (affects a user population
including Android phones).

**Step 7.2 - Activity**:
Record: f2fs gc.c/segment.c are actively developed with 100+ commits
since v6.1. Active subsystem with responsive maintainers.

## Phase 8: IMPACT ASSESSMENT

**Step 8.1 - Affected users**:
Record: Users of f2fs who perform suspend/hibernate - particularly
Android devices (dominant f2fs user base) and Linux laptops. Affects
systems with active background GC/discard.

**Step 8.2 - Trigger conditions**:
Record: System suspend or hibernate request while f2fs GC or discard
thread is actively processing many segments/commands. Frequency: every
suspend cycle on an active device has potential to hit it. Cannot be
triggered by unprivileged users directly (though can be a DoS by heavy
I/O + suspend trigger).

**Step 8.3 - Failure mode severity**:
Record: Failure mode is suspend failure - kernel PM emits "Freezing of
tasks failed after X seconds" and either aborts suspend or hangs.
Severity: MEDIUM-HIGH. Not a crash/corruption, but user-visible system
malfunction (laptop won't sleep, Android battery drain). On Android,
this can prevent deep idle states causing battery drain and user-
perceived "broken suspend."

**Step 8.4 - Risk-benefit**:
Record:
- BENEFIT: High - addresses real user-visible suspend reliability issue
  on a major deployment (Android).
- RISK: Very low - 21 lines, check only takes effect in freezable
  kthread context (the GC/discard threads themselves), uses
  `unlikely()`, returns 0 (success), preserves progress (discard
  requires ≥1 issued). No structural or API changes. Reviewed by co-
  maintainer.
- Ratio: Strongly favors backporting.

## Phase 9: FINAL SYNTHESIS

**Step 9.1 - Evidence summary**:
FOR: Real user-visible suspend failures, small conservative fix,
reviewed by co-maintainer, historical precedent (1d7be2708277e was Cc'd
stable), sent by Android team (real-world motivation), only takes effect
during freezing.
AGAINST: No Cc: stable, no Fixes: tag, requires minor backport
adjustment for pre-6.17 due to sum_page→sum_folio rename, not a
crash/corruption/security issue.

**Step 9.2 - Stable rules**:
1. Obviously correct and tested? Yes - minimal, reviewed by maintainer.
2. Fixes a real bug? Yes - suspend reliability.
3. Important issue? Suspend failure on Android = user-visible
   reliability issue (classified under "system hang" from user POV).
4. Small and contained? Yes - 21 lines added.
5. No new features? Correct - just adds check.
6. Applies to stable trees? 6.17+ likely yes; 6.15 and older need
   adjustment.

**Step 9.3 - Exception categories**: Not a device ID/quirk/DT/build/doc
fix. Falls under "performance/reliability fixes that prevent system
hangs" - the "System hang" impact during suspend justifies inclusion.

**Step 9.4 - Decision**: This is a legitimate fix for a real user-
impacting bug (suspend failures on f2fs systems, predominantly Android).
It is small, conservative, well-reviewed, and has strong historical
precedent (1d7be2708277e). The risk of regression is minimal since the
check only activates during PM freeze in the kthread itself. The benefit
is substantial for the Android user base. The patch should backport
cleanly to 6.17+ and with minor adjustment to older trees.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Chao Yu (co-maintainer), Signed-
  off-by Jaegeuk Kim (maintainer); no Cc:stable, no Fixes: tag.
- [Phase 2] Diff analyzed via `git show 02d91398a602c`: 21 lines added
  in 2 files; adds `freezing(current)` checks in GC and discard loops
  with proper cleanup (folio_put_refs, goto stop).
- [Phase 3] `git blame`/history: confirmed freezable thread
  infrastructure added in 2017 (1d7be2708277e) Cc'd stable;
  `wait_event_freezable_timeout` conversion in 94e7eb42414b6 (v6.8).
- [Phase 3] `git show 94e7eb42414b6`: verified that post-v6.8, freeze
  now only happens at wait point (no more per-iteration try_to_freeze),
  making long GC rounds extend the freeze latency.
- [Phase 3] `git log --oneline --grep="freez" -- fs/f2fs/`: identified
  prior freezable-thread commits in f2fs history.
- [Phase 4] `b4 dig -c 02d91398a602c`: found original submission at `htt
  ps://lore.kernel.org/all/20260316185954.2185806-1-daeho43@gmail.com/`.
- [Phase 4] `b4 dig -a`: confirmed patch went through v1→v2→v3, applied
  version is latest.
- [Phase 4] `b4 dig -w`: confirmed linux-f2fs-devel, kernel-
  team@android.com were CC'd.
- [Phase 4] Read /tmp/b4_dig/thread.mbox: verified review by Chao Yu and
  resolved feedback about return codes. Reviewer said "freezing(current)
  will only be true in context of gc thread".
- [Phase 5] `Grep freezing|freezable|try_to_freeze` in fs/f2fs: verified
  that `set_freezable()` is only called in `issue_discard_thread` and
  `gc_thread_func`, confirming the check is inert for user-triggered GC
  paths.
- [Phase 5] `Grep f2fs_gc\b`: verified callers include gc_thread_func
  (freezable), f2fs_balance_fs, super.c resize, file.c ioctls - check is
  safe for all.
- [Phase 6] `git show p-6.6:fs/f2fs/gc.c` / p-6.12 / p-6.15 / p-6.16 /
  p-6.17: confirmed sum_folio exists in 6.16+, sum_page in earlier.
  Pre-6.16 backport would need naming adjustment.
- [Phase 6] `git show p-6.12:fs/f2fs/segment.c`: verified
  __issue_discard_cmd/__issue_discard_cmd_orderly have identical
  structure in 6.12 - segment.c portion applies cleanly to all supported
  trees.
- [Phase 7] Confirmed f2fs is core Android filesystem (kernel-
  team@android.com Cc verifies real-world impact).
- [Phase 8] Trigger: any suspend while GC/discard thread busy. Failure:
  PM suspend abort with "Freezing of tasks failed" message.
- UNVERIFIED: Exact frequency of suspend failures in real Android
  deployments (no public bug tracker link provided). Inferred from
  Android team submission and Chao Yu's review that it's a real field
  issue.
- UNVERIFIED: Whether a specific regression-introducing commit exists
  (the issue appears to be latent since freezable thread implementation,
  worsened by 94e7eb42414b6's removal of per-iteration try_to_freeze).

This is a small, reviewed fix by the subsystem maintainer team that
addresses real user-impacting suspend failures. While not a classic
crash/corruption/security fix, suspend reliability on Android and laptop
deployments is a first-class stability issue. The fix is conservative
(only acts on freezable kthread context), preserves progress, and has
historical precedent (the 2017 freeze-related fix was Cc'd stable).
Backport should be easy for 6.17+ and manageable for older trees with
minor adjustment.

**YES**

 fs/f2fs/gc.c      | 10 ++++++++++
 fs/f2fs/segment.c | 12 +++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 5c355d3da23bf..2e9f2b17fa40b 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1891,12 +1891,18 @@ static int do_garbage_collect(struct f2fs_sb_info *sbi,
 				sbi->next_victim_seg[gc_type] =
 					(cur_segno + 1 < sec_end_segno) ?
 					cur_segno + 1 : NULL_SEGNO;
+
+			if (unlikely(freezing(current))) {
+				folio_put_refs(sum_folio, 2);
+				goto stop;
+			}
 		}
 next_block:
 		folio_put_refs(sum_folio, 2);
 		segno = block_end_segno;
 	}
 
+stop:
 	if (submitted)
 		f2fs_submit_merged_write(sbi, data_type);
 
@@ -1970,6 +1976,10 @@ int f2fs_gc(struct f2fs_sb_info *sbi, struct f2fs_gc_control *gc_control)
 		goto stop;
 	}
 retry:
+	if (unlikely(freezing(current))) {
+		ret = 0;
+		goto stop;
+	}
 	ret = __get_victim(sbi, &segno, gc_type, gc_control->one_time);
 	if (ret) {
 		/* allow to search victim from sections has pinned data */
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 6a97fe76712b5..4216690998f0f 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1606,6 +1606,9 @@ static void __issue_discard_cmd_orderly(struct f2fs_sb_info *sbi,
 		if (dc->state != D_PREP)
 			goto next;
 
+		if (*issued > 0 && unlikely(freezing(current)))
+			break;
+
 		if (dpolicy->io_aware && !is_idle(sbi, DISCARD_TIME)) {
 			io_interrupted = true;
 			break;
@@ -1645,6 +1648,7 @@ static int __issue_discard_cmd(struct f2fs_sb_info *sbi,
 	struct blk_plug plug;
 	int i, issued;
 	bool io_interrupted = false;
+	bool suspended = false;
 
 	if (dpolicy->timeout)
 		f2fs_update_time(sbi, UMOUNT_DISCARD_TIMEOUT);
@@ -1675,6 +1679,11 @@ static int __issue_discard_cmd(struct f2fs_sb_info *sbi,
 		list_for_each_entry_safe(dc, tmp, pend_list, list) {
 			f2fs_bug_on(sbi, dc->state != D_PREP);
 
+			if (issued > 0 && unlikely(freezing(current))) {
+				suspended = true;
+				break;
+			}
+
 			if (dpolicy->timeout &&
 				f2fs_time_over(sbi, UMOUNT_DISCARD_TIMEOUT))
 				break;
@@ -1694,7 +1703,8 @@ static int __issue_discard_cmd(struct f2fs_sb_info *sbi,
 next:
 		mutex_unlock(&dcc->cmd_lock);
 
-		if (issued >= dpolicy->max_requests || io_interrupted)
+		if (issued >= dpolicy->max_requests || io_interrupted ||
+					suspended)
 			break;
 	}
 
-- 
2.53.0

