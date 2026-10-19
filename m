Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE5253F9AB;
	Mon, 19 Oct 2026 14:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418722; cv=none; b=YENZhJtmEqF5DmFr1KVLe5YvgB78rCkaiDsE821gX6orcg3gEGGEYj+xqOb/JmPXxo3c7dagYIzlOUHOxEREOSbzpkI+nLDinUSZPQisoQbk62ncXpEa/L/SF0QYHl1xPjJSnyDHQgMN8kzH0V0owowy1oda6tmwYQm3vajCaus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418722; c=relaxed/simple;
	bh=fpKt3M6Yb4rAuiuMk+ukdm6y9Uzj2EfKJngLWbZqIMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NKY1lUzX+odaAmGWP54ybpw9o+tYTg5vpRknxQTt+N8AUEDzX4CEri/KunHDNBzp2QYd6br9C2k1nBrR4KcKxpsLqhG9icOe8EjbmCQvxtYDOb65l78gBij/uzwMAsnHd3mSSRXd6Mu9i7oUvm4Gfn8XD1CFBZNVLta5/y8zZ8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nk2nKAAA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nk2nKAAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578201F000C5;
	Mon, 19 Oct 2026 14:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418719;
	bh=+hcH1HiLgHTHuCm0DvzlFDDPUk0wpg9BqkPllEirZrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nk2nKAAAfJRqHb3yMGbpYrSmumy52OMwELcgJ3AUd9jFnXJdOifg17KGD+dMJmoSt
	 dlVVh7wRVY8dTc/lfjTTDmMGWoXYZeoXZjLBTUoDVoSH/48rHKMBBB5epixVDKZgYf
	 c+7K1zdZSEaqasmCrzaQ2AigjMsCJ8ESsNxUKWziIk3pIS8mg3GMPx+KT+mKasFtw4
	 x4Tj6Ipkqf446IvKVi4nTxzOxERaKDCdFM3xme3csoIlX2rXbfe4/DVelSDgM0RjMz
	 c+aO86Nmv7l3Z4M9ZAfD9nF98nIqJcJCk29lfa6FZQrEZKoDS4k4bnkLWuVq4xwXFs
	 pkX2Qx0POPtvQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Genjian Zhang <zhanggenjian@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] md/raid5: complete discard bios while reshape is active
Date: Mon, 19 Oct 2026 09:52:18 -0400
Message-ID: <20261019135441.1420968-447-sashal@kernel.org>
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

From: Genjian Zhang <zhanggenjian@kylinos.cn>

[ Upstream commit 85764f475f3b3abd956bf8eaeaa643b367676cf4 ]

make_discard_request() returns without completing the bio when reshape
is in progress. Discard callers block in submit_bio_wait()
waiting for a completion that never arrives.  The caller hangs in
uninterruptible sleep, and this does not resolve when reshape finishes.

Complete the bio with BLK_STS_AGAIN so userspace can retry after reshape,
consistent with the existing policy of not processing discard during
reshape.

Tested on a loop-backed RAID5 array during mdadm --grow: without this
patch, blkdiscard hangs in bio_await() and remains in uninterruptible
sleep after md reports "reshape done"; with this patch it returns
-EAGAIN instead.

Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260711161326.962336-1-zhanggenjian@126.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **6.1.188**. The reshape discard hang is present here; the
fix is a small completion of an otherwise leaked bio.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: `[md/raid5] [complete] complete discard bios while reshape is
active`

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn> (author)
- Reviewed-by: Yu Kuai <yukuai@fygo.io> (applied the patch to md-7.3)
- Link:
  https://patch.msgid.link/20260711161326.962336-1-zhanggenjian@126.com
- Signed-off-by: Yu Kuai <yukuai@fygo.io> (maintainer tree)
- No Fixes: tag (expected)
- No Cc: stable (expected)
- No Reported-by / Tested-by / Acked-by
- Ignore pipeline SOBs

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: `make_discard_request()` returns without `bio_endio()` when
  `mddev->reshape_position != MaxSector`.
- Symptom: discard callers (`submit_bio_wait()` / `blkdiscard`) sleep in
  D-state forever. Hang survives reshape completion.
- Root cause: early return that skips completion; the bio is never
  finished.
- Fix: complete with `BLK_STS_AGAIN` so userspace gets `-EAGAIN` and can
  retry after reshape.
- Author tested loop-backed RAID5 during `mdadm --grow`.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden. This is an explicit hang fix (bio never completed).

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/md/raid5.c` only
- Scope: surgical, one function (`make_discard_request`)
- Candidate form: early `return` → `goto complete_again`; success-path
  `bio_endio` gets an explicit `return`; new label calls
  `bio_endio_status(bi, BLK_STS_AGAIN)`
- Mailing-list v1 (what Yu Kuai applied): 3 insertions / 1 deletion,
  inline `bio_endio_status` before `return`. Same behavior.

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: reshape active → return, bio left outstanding.
- After: reshape active → complete bio with `BLK_STS_AGAIN`.
- Path: discard submit during reshape (admin `blkdiscard` / `fstrim` /
  FS discard).
- Success path unchanged (`bio_endio(bi)` still runs).

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: logic / resource-completion bug → uninterruptible hang
- Mechanism: bio remaining count never reaches zero; `submit_bio_wait()`
  sits in `wait_for_completion_io()`.
- Fix: complete the bio with a retryable status instead of dropping it.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: every bio must be completed; this path did not.
- Minimal: a few lines, one function.
- Regression: callers see `-EAGAIN` instead of hanging.
  `blkdev_issue_discard()` maps `-EOPNOTSUPP` to success, so
  `BLK_STS_NOTSUPP` would lie; `BLK_STS_AGAIN` is the right retry
  signal. Header comment says `BLK_STS_AGAIN` is for NOWAIT; maintainer
  still accepted this, and the author showed `NOTSUPP` would look like a
  successful discard.
- Red flags: none on the hang fix itself. Helper `bio_endio_status()` is
  missing in 6.1 (backport uses existing `bio->bi_status` +
  `bio_endio()`).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Introducer: `620125f2bf8ff0` “MD: raid5 trim support” (Shaohua Li,
  2012-10-11).
- The skip-without-complete has been in tree since RAID5 discard was
  added.
- Present in this 6.1 checkout at `drivers/md/raid5.c:5809-5811`.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Introducer confirmed via blame + `git merge-base
--is-ancestor 620125f2bf8ff0 HEAD`.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Recent `raid5.c` work is other hang/lockup fixes, not this discard
  skip.
- `git log --grep='complete discard'` / `'discard bios while reshape'`
  on `drivers/md/`: not in this tree.
- Standalone patch (not `N/M`).

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record:
- Genjian Zhang: not an MD regular in this tree.
- Yu Kuai: frequent MD contributor here (`md/raid5: account discard IO`,
  `fix IO hang when array is broken with IO inflight`, etc.) and applied
  this to md-7.3.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Functional dependency: none. Completing the bio does not need later
  RAID5 refactoring.
- `bio_endio_status()` is absent in 6.1; equivalent is already used
  (`bio_wouldblock_error()`, `bio->bi_status = ...; bio_endio()`).
- `raid5_discard_limits()` is context from later mainline, not used by
  the fix. Not in 6.1.
- Applies standalone with a 2-line helper substitution.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- Lore/msgid: `20260711161326.962336-1-zhanggenjian@126.com`
- `b4 mbox`: 6-message thread, standalone v1 (no v2).
- Recipients: Song Liu, Yu Kuai, linux-raid, linux-kernel.
- Yu Kuai 2026-07-19: Reviewed-by; leave REQ_NOWAIT hang (nowait being
  removed in mainline).
- Yu Kuai 2026-07-31: “Rebase and applied to md-7.3”.
- Author: no v2 for REQ_NOWAIT.
- No NAK. No reviewer `Cc: stable`.
- Sashiko bot: (1) REQ_NOWAIT also leaks the bio (pre-existing); (2)
  `BLK_STS_AGAIN` on blocking bios.
- Author: NOTSUPP is wrong (discard is supported, just not during
  reshape); `blkdev_issue_discard()` treats `-EOPNOTSUPP` as success, so
  NOTSUPP would report success with no discard; `BLK_STS_AGAIN` matches
  raid10’s discard-during-reshape `-EAGAIN` policy.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: MD maintainers CC’d (Song Liu, Yu Kuai). Yu Kuai reviewed and
applied. Song Liu did not comment in the thread.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No bugzilla/syzbot. Author reproduced with `blkdiscard` during
`mdadm --grow` on loop RAID5. Hang remained after “reshape done”.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone. REQ_NOWAIT leak left unfixed on maintainer request
(mainline nowait removal). In 6.1 that WARN_ON_ONCE return without
`bio_endio` is still present; it is a separate, rarer path.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No stable-list discussion found for this subject. Absence of
`Cc: stable` is expected for this review pipeline.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `make_discard_request()` only.

Step 5.2: TRACE CALLERS
Record:
- Only caller: `raid5_make_request()` when `bio_op(bi) ==
  REQ_OP_DISCARD` (`drivers/md/raid5.c:6175-6178`).
- After the call: `md_write_end(mddev)` always runs, so write accounting
  stays balanced if the bio is completed with error.
- Context: MD make_request from `submit_bio` / `submit_bio_wait`.

Step 5.3: TRACE CALLEES
Record: On the buggy skip path, no stripe work, no `bio_inc_remaining`,
no bitmap. Completing the original bio is sufficient. Success path still
ends with `bio_endio(bi)` after stripe setup.

Step 5.4: FOLLOW THE CALL CHAIN
Record:
```
blkdiscard / FITRIM / FS discard
  → blkdev_issue_discard() / sb_issue_discard()
  → submit_bio_wait()  [wait_for_completion_io, uninterruptible]
  → raid5_make_request()
  → make_discard_request()
  → return without bio_endio  [BUG]
```
Reachable from userspace on a RAID5/6 array with discard enabled. Needs
admin (BLKDISCARD / fstrim), not an unprivileged syscall gadget.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record:
- Same file still has REQ_NOWAIT `WARN_ON_ONCE` then `return` without
  completing (6.1-only leftover).
- RAID10 already returns `-EAGAIN` for discard during reshape
  (`raid10_handle_discard`, `drivers/md/raid10.c:1653-1654`) and
  completes NOWAIT discards with `bio_wouldblock_error()`.
- `raid5_make_request` already uses `bio_wouldblock_error()` for NOWAIT
  vs reshape on normal I/O (`:6193-6201`). Discard skipped that pattern.

No semcode MCP in this environment; callers/callees from `rg` + reading
the functions.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes.

```5809:5811:drivers/md/raid5.c
        if (mddev->reshape_position != MaxSector)
                /* Skip discard while reshape is happening */
                return;
```

- Tree: `p-6.1-11-g10bc6eb33d95f`, `make kernelversion` → 6.1.188.
- Bug since 2012 (`620125f2bf8ff0`), ancestor of HEAD.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Needs a small backport, not a rework.
- No `bio_endio_status()` in 6.1 → `bi->bi_status = BLK_STS_AGAIN;
  bio_endio(bi);` (or `bio_wouldblock_error(bi)`).
- No `raid5_discard_limits()` (later context only).
- 6.1 still has the REQ_NOWAIT warning above the reshape check; leave it
  (out of scope of this commit).
- Expected difficulty: minor context/helper adjustment.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: This hang is not fixed. Discard still disabled by default
(`devices_handle_discard_safely = false`), but the hang exists whenever
that param is set and discard is issued during reshape.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: MD RAID5/6 (`drivers/md/raid5.c`). IMPORTANT: not core VFS/mm,
but widely used for storage. RAID5 reshape (`mdadm --grow`) is a
supported production operation.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Active in this tree (recent hang, lockup, discard accounting
fixes). Yu Kuai is a regular MD committer here. Official maintainer in
MAINTAINERS: Song Liu.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: RAID5/6 users who enabled discard
(`raid456.devices_handle_discard_safely=Y`) and run discard
(`blkdiscard`, `fstrim`, mount-time/online discard) while reshape is
active. Config- and workload-specific, not universal.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Trigger: discard bio while `reshape_position != MaxSector`.
- How common: reshape is infrequent; overlap with `fstrim.timer` / admin
  trim is realistic on SSD RAID.
- Unprivileged: typically no (needs write on the device /
  CAP_SYS_ADMIN). Still a production hang for admins and FS discard from
  `fstrim`/ext4/xfs/f2fs (those use `blkdev_issue_discard` →
  `submit_bio_wait`).

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Failure: uninterruptible sleep (`wait_for_completion_io`) that does
  **not** clear when reshape finishes. Process is unkillable; hung-task
  warnings; reboot to recover.
- Severity: **CRITICAL** for the affected path (hang), even though the
  feature is opt-in.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for RAID5/6 + discard + reshape (unkillable hang →
  `-EAGAIN`).
- Risk: very low (few lines, error-only path, no new API, no
  locking/data-structure change). Worst case: discard fails with
  `-EAGAIN` instead of hanging.
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

FOR:
- Real, tested uninterruptible hang; does not self-resolve after
  reshape.
- Small, obviously correct: complete a bio that was leaked.
- Buggy code present in this 6.1 tree since 2012.
- Maintainer Reviewed-by and applied (Yu Kuai, md-7.3).
- `BLK_STS_AGAIN` avoids the `-EOPNOTSUPP`→success lie in
  `blkdev_issue_discard()`.
- Matches “complete with retryable error” rather than silent drop.
- Callers (`blkdev_issue_discard`, FITRIM, `sb_issue_discard`) all wait
  on completion.

AGAINST:
- Discard off by default (`devices_handle_discard_safely`).
- Exact mainline helper `bio_endio_status()` missing (trivial substitute
  exists).
- `BLK_STS_AGAIN` is documented as NOWAIT-oriented; maintainer accepted
  it anyway.
- No `Cc: stable` (not a negative for this process).

UNRESOLVED:
- Could not use `b4 dig -c <sha>` (commit not in this checkout). Thread
  recovered via msgid/`b4 mbox`.
- No stable-list thread found.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — missing `bio_endio` is the
   hang; author tested `blkdiscard` vs reshape; Yu Kuai reviewed.
2. Fixes a real bug that affects users? **PASS** — D-state hang on
   discard during reshape.
3. Important issue? **PASS** — unkillable hang / hung task (CRITICAL on
   that path).
4. Small and contained? **PASS** — one function, a few lines.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** with a trivial backport
   (`bio_endio_status` → set `bi_status` + `bio_endio`).

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not an ID/quirk/DT/docs exception. Ordinary hang fix.

Step 9.4: MAKE YOUR DECISION
Backport to this 6.1 tree. The hang is in this code, the fix is
surgical, and the only adjustment is how to set bio status without
`bio_endio_status()`.

Verification:
- [Phase 1] Subject/tags/body from the candidate message and lore mbox;
  hang + `-EAGAIN` policy confirmed.
- [Phase 2] Diff: reshape early-return without completion → `bio_endio`
  with `BLK_STS_AGAIN`.
- [Phase 3] `git blame` `raid5.c:5809-5811` → `620125f2bf8ff0` (2012);
  `git merge-base --is-ancestor` true; fix not in this tree.
- [Phase 3] `git log --grep` on `drivers/md/` for this subject: empty.
- [Phase 4] `b4 mbox` msgid
  `20260711161326.962336-1-zhanggenjian@126.com`: 6 msgs; Yu Kuai
  Reviewed-by + applied md-7.3; author rationale for AGAIN vs NOTSUPP.
- [Phase 4] Openwall/LKML mirrors match the patch; lore.kernel.org fetch
  403 (Anubis); thread obtained via b4.
- [Phase 5] `rg make_discard_request`: only `raid5_make_request`.
  `submit_bio_wait` uses `wait_for_completion_io`.
  `blkdev_issue_discard` treats only `-EOPNOTSUPP` as 0.
- [Phase 5] RAID10 already returns `-EAGAIN` for discard during reshape
  (`raid10.c:1653-1654`).
- [Phase 6] `git describe HEAD` → `p-6.1-11-g10bc6eb33d95f`; `make
  kernelversion` → 6.1.188. Buggy return present. `bio_endio_status` /
  `raid5_discard_limits` absent.
- [Phase 6] Equivalent completion: `include/linux/bio.h`
  `bio_wouldblock_error()` / `BLK_STS_AGAIN`.
- [Phase 7] MAINTAINERS: Song Liu / linux-raid; Yu Kuai active on
  `drivers/md/raid5.c` in this tree.
- [Phase 8] Failure mode: D-state hang until reboot; discard opt-in via
  `devices_handle_discard_safely`.
- UNVERIFIED: whether some later mainline commit renamed the helper-only
  form to the `goto complete_again` form (functionally equivalent).

The hang is real in 6.1, the fix is a few lines, and a missing helper is
not a reason to leave an unkillable discard stall in place.

**YES**

 drivers/md/raid5.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2817cd7d197e9..b7da2b83e1938 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5707,8 +5707,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	int stripe_sectors;
 
 	if (mddev->reshape_position != MaxSector)
-		/* Skip discard while reshape is happening */
-		return;
+		goto complete_again;
 
 	stripe_sectors = conf->chunk_sectors *
 		(conf->raid_disks - conf->max_degraded);
@@ -5786,6 +5785,11 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	}
 
 	bio_endio(bi);
+	return;
+
+complete_again:
+	/* Skip discard while reshape is happening */
+	bio_endio_status(bi, BLK_STS_AGAIN);
 }
 
 static bool ahead_of_reshape(struct mddev *mddev, sector_t sector,
-- 
2.53.0

