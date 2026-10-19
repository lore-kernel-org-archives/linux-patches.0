Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CE8530ABF;
	Mon, 19 Oct 2026 14:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418632; cv=none; b=CI6hLlweNeFu9vSJywvY16rnl439sVsUYVQbQq3fxMIIA1A04I/kGisxcOIAm9YgrqUy49GhnSdtDaiRs0Vku8iJhjDDQRDMvxzt5Rc19dlvspO71+Iu37TYfd+xb7tU6Fkuir2RnenpYaT+p3qv8RNJpZRZCqd3NQ7YJSlLyEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418632; c=relaxed/simple;
	bh=rcpwPJ7mcV+mpVjshr18mmEwCaZCXXtBA3JTQOERv7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mrlrc3elum3MB0/PfF8F8un348qyOvCPU+Oteafq8MLfJ61SVW6Jkdx1fRMh8LHQRd7Q0dVJ9Q/EQt7svbvNB/UtolY4eXytrECB6KFLA3ORrcXVAHS7i/qzwFeQEQjmTucaoZuuWPdjHSSMkFDEMTsoUSeJ00cGm2wX5qtgfvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bnyvl+H9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bnyvl+H9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E08F1F000C7;
	Mon, 19 Oct 2026 14:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418629;
	bh=euT1B/egjPX/wctp3QDspXsmLwlDfRDCrI84bw+LBz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bnyvl+H9nzsYyKam45p4sxdrWh4eMEk9X0sFpCZd719nWPbJZs7w1XFbDAsO1VHHl
	 nr/gaOuVPXZr84imucDvxlG4fC3Qpis3yYmF0/TzXG5a/FfP1ZKmunMADLu6C5g+Su
	 jPS9IwBwk0ZaJ5lJoCfR5uoXhjrfV/fzFrqTlzVx/OpGymeqmd0fHZiejtjFqJNdS6
	 5wHAKLoUuKkWGcVlEdexyHe09Ai1jEyQ+HF86Ou4JjieAgEuwVDJ5tKVMZdrgQ5mSL
	 hIC/l2+x7tdnA7Qlz68tzoY9UC1eaOolk9Xrx1FCskNaT6aCDeNxwJqPhQwJSaVj0N
	 9QtP3XcDT7jLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yang Wen <anmuxixixi@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sj1557.seo@samsung.com,
	exfat@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] exfat: keep FITRIM within the requested range
Date: Mon, 19 Oct 2026 09:51:16 -0400
Message-ID: <20261019135441.1420968-385-sashal@kernel.org>
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

From: Yang Wen <anmuxixixi@gmail.com>

[ Upstream commit 2de727471b3b13409466a4af4f8824a86073bf4b ]

exfat_find_free_bitmap() searches the entire allocation bitmap and may
wrap around to its beginning. exfat_trim_fs() does not verify that the
returned cluster is still within the requested FITRIM range.

As a result, a partial FITRIM operation may discard free clusters outside
the user-specified range and report a trimmed length larger than the
requested length.

Validate each returned cluster against the requested range and stop the
search when it wraps around or passes the range end.

Signed-off-by: Yang Wen <anmuxixixi@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The FITRIM range bug is
in this checkout, and the fix applies cleanly.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Record: **[exfat] [keep / constrain] keep FITRIM within the requested
  range**
- Subsystem: `exfat`. Action is “keep … within”, i.e. stop the ioctl
  from acting outside the caller’s range.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Commit `2de727471b3b13409466a4af4f8824a86073bf4b` (mainline, contained
in `v7.3-rc1`):
- Signed-off-by: Yang Wen \<anmuxixixi@gmail.com\> (author)
- Signed-off-by: Namjae Jeon \<linkinjeon@kernel.org\> (exFAT
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable (absence is expected for this review)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Record: **[Bug]** `exfat_find_free_bitmap()` walks the whole
  allocation bitmap and **wraps to cluster 2**. `exfat_trim_fs()` treats
  that result as the next hole to discard, without checking the FITRIM
  range.
- **[Symptom]** A **partial** FITRIM can `sb_issue_discard()` free
  clusters **outside** `range->start`/`range->len`, and write back a
  `range->len` **larger than requested**.
- **[Root cause]** Trim reused the allocator’s circular free-cluster
  search and never rejected a wrapped or out-of-range cluster.
- **[Versions]** Message does not name versions. FITRIM was added in
  `654762df2ec7d` (v5.13); wrap-around has been in
  `exfat_find_free_bitmap()` since `1e49a94cf70720` (exFAT bitmap ops).

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: **Not a disguised cleanup.** It is an explicit FITRIM
  correctness fix (wrong discard range + wrong reported length).

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- Record: **`fs/exfat/balloc.c` only** — 19 insertions, 12 deletions
  (net +7). Function: `exfat_trim_fs()`. **Single-function surgical
  fix.**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Local `exfat_trim_fs()` (lines 309–387) is **byte-identical** to the
parent of `2de727471b3b1`.

Before:
1. `trim_begin = exfat_find_free_bitmap(sb, clu_start)` — wrap is
   ignored.
2. Second search; EOF bails **before** remainder trim.
3. `do { ... } while (next != EOF && next > trim_end)` — wrap at the
   **end** of an iteration can exit, but if the wrapped cluster was
   **assigned** to `trim_begin`/`trim_end`, wrap detection is lost and
   the loop trims from the start of the volume.
4. `next >= clu_end` does not catch wrap-to-beginning.

After:
1. Reject first cluster if EOF or `trim_begin < clu_start || trim_begin
   > clu_end`.
2. `for (;;)`: stop when `trim_end >= clu_end`.
3. Reject next cluster if EOF, wrap (`next <= trim_end`), or `next >
   clu_end`.
4. Remainder trim still runs for the last in-range hole.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Record: **[Logic / correctness]** FITRIM range not enforced against a
  wrapping bitmap walk. Also a minor hole: old EOF-on-second-search
  skipped remainder trim of a valid in-range hole.

**Step 2.4: ASSESS THE FIX QUALITY**
- Record: **Obviously correct.** Range checks match FITRIM’s
  `[clu_start, clu_end]`. Wrap is `next <= trim_end`. Inclusive end:
  `trim_end++` only when `next == trim_end+1` and `next <= clu_end`.
  `fatal_signal_pending` kept. No API/lock/structure changes. **Low
  regression risk** (tightens discard, does not expand it). Remainder
  after a range-validated hole cannot start outside the range.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Record: Entire `exfat_trim_fs()` is **`654762df2ec7d`** (“exfat: add
  support ioctl and FITRIM function”, Hyeongseok Kim, 2021-03-04). Wrap
  in `exfat_find_free_bitmap()` is **`1e49a94cf70720`** (“exfat: add
  bitmap operations”). Bug is as old as FITRIM itself (**v5.13**).

**Step 3.2: FOLLOW THE FIXES: TAG**
- Record: **No Fixes: tag.** Introducer is `654762df2ec7d`, **present in
  this tree** (`git merge-base --is-ancestor` succeeded).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
- Record: Recent local `fs/exfat/balloc.c` commits are bitmap
  validation, soft lockup, leaks, ffs/hweight — **none change trim**.
  Mainline after this fix has **no further `balloc.c` commits**.
  **Standalone, not a series.**

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Record: **Yang Wen** has **no** prior `fs/exfat/` commits in this
  tree. **Namjae Jeon** is the exFAT maintainer and applied the patch
  the next day.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Record: **None.** Uses existing `exfat_find_free_bitmap`,
  `sb_issue_discard`, `clu_start`/`clu_end`. `git apply --check`
  **succeeds** (hunks at offset −12).

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- Record: **[Lore]**
  https://patch.msgid.link/20260813142919.812744-1-anmuxixixi@gmail.com
- **[Revisions]** **v1 only** (b4 dig -a). Applied as submitted.
- Maintainer reply (Namjae Jeon, 2026-08-14): **“Applied it to #dev.
  Thanks!”** — no NAK, no requested changes, no stable nomination in-
  thread.
- WebFetch/curl to lore.kernel.org hit Anubis bot-check (403). Thread
  recovered via **`b4 dig -m`**.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- Record: To/Cc: Namjae Jeon, Sungjong Seo, Yuezhang Mo,
  `exfat@lists.linux.dev`, `linux-kernel`. **Maintainer applied v1.** No
  extra Reviewed-by on the commit.

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Record: **No Reported-by / bugzilla / syzbot.** Analysis-driven, not a
  user crash report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- Record: **Standalone single patch.** No follow-up on `origin/master`
  for this function.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- Record: lore.kernel.org/stable search **blocked** (Anubis).
  **UNVERIFIED** whether stable@ discussed this. Not used as a NO
  signal.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
- Record: **Modified:** `exfat_trim_fs()`. **Relies on:**
  `exfat_find_free_bitmap()` (wraps; unchanged).

**Step 5.2: TRACE CALLERS**
- Record: Only **`exfat_ioctl_fitrim()`** in `fs/exfat/file.c` (`FITRIM`
  ioctl). Requires **`CAP_SYS_ADMIN`**. Copies `struct fstrim_range`
  in/out; `range.len` is the trimmed-byte count userspace sees (`fstrim
  -v`).

**Step 5.3: TRACE CALLEES**
- Record: `exfat_find_free_bitmap()`, `sb_issue_discard()`,
  `exfat_cluster_to_sector()`, `mutex_lock(&sbi->bitmap_lock)`,
  `fatal_signal_pending()`.

**Step 5.4: FOLLOW THE CALL CHAIN**
- Record: `ioctl(FITRIM)` → `exfat_ioctl()` → `exfat_ioctl_fitrim()` →
  `exfat_trim_fs()`. Reachable from userspace **with CAP_SYS_ADMIN**
  (`fstrim`, systemd-fstrim, Android idle trim). **Not** an unprivileged
  path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- Record: **FAT** `fat_trim_fs()` walks **only** `ent_start..ent_end`
  (no wrap). exFAT is the outlier. FAT’s loop is the intended FITRIM
  contract.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Record: **Yes.** `fs/exfat/balloc.c` `exfat_trim_fs()` matches the
  pre-fix function (SHA-1 of the function text identical to
  `2de727471b3b1^`). Introduced **v5.13**, present in **6.12.111**.
  Candidate **not** an ancestor of HEAD.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- Record: **Clean apply** (`git apply --check`, offset −12 from later
  bitmap-load changes that do not touch trim). **No rework needed.**

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- Record: **No** other FITRIM-range fix in this tree. Only FITRIM commit
  is the original add (`654762df2ec7d`).

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
- Record: **[exFAT filesystem] [IMPORTANT]** — SD cards, USB sticks,
  Android/embedded. Not mm/VFS-core, but a widely shipped FS.

**Step 7.2: SUBSYSTEM ACTIVITY**
- Record: **Active** (bitmap validation, lockups, leaks). Trim loop
  itself has been **unchanged since 2021**.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
- Record: **Filesystem-specific (exFAT) + ioctl path.** Anyone running
  **partial** FITRIM (`fstrim -o/-l`, chunked idle trim). Full-volume
  trim (`start=0`, `len=ULLONG_MAX`) sets `clu_start` to
  `EXFAT_FIRST_CLUSTER`, so wrap is inside the requested range —
  **default `fstrim` is largely unaffected**.

**Step 8.2: TRIGGER CONDITIONS**
- Record: CAP_SYS_ADMIN FITRIM with a **range that is not the whole
  volume**, and **no free cluster from `clu_start` to end of bitmap**
  (first search wraps), **or** a hole whose next free cluster is found
  only after wrap. Not a race (`bitmap_lock` held). Unprivileged users
  **cannot** trigger it.

**Step 8.3: FAILURE MODE SEVERITY**
- Record: **Wrong-range discard of free clusters** + **inflated
  `range->len`**. Not a panic/UAF. On SSDs: extra wear and extra
  latency. On thin/sparse LUNs: **unmap of the wrong region** (space
  accounting / unexpected hole punch of free space outside the requested
  byte range). File data in allocated clusters is not discarded.
  **Severity: MEDIUM** (contract + device-side unmap), not CRITICAL.

**Step 8.4: RISK-BENEFIT RATIO**
- Record: **Benefit: medium** (correct FITRIM; matters for
  ranged/chunked trim on exFAT). **Risk: very low** (~20-line single-
  function tighten). **Ratio: favorable.**

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real FITRIM bug: discard and reported length ignore the requested
  range when the bitmap search wraps.
- Present in this 6.12 tree since v5.13; function matches mainline
  parent.
- Small, obviously correct, applies cleanly; no new API.
- Maintainer applied v1 the next day; no follow-up revert/fix.
- FAT already confines trim to the range; this aligns exFAT with that
  contract.
- Extra/wrong-range discard is user-visible and can unmap the wrong
  thin-provisioned region.

AGAINST:
- Not a crash, UAF, or file-data corruption.
- Needs CAP_SYS_ADMIN; default full-FS `fstrim` rarely hits wrap.
- No Reported-by / Tested-by / syzbot.
- “Important” is a correctness/contract issue, not panic-class.

UNRESOLVED:
- Stable@ discussion (lore blocked).
- How often 6.12 users actually pass a partial FITRIM range.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — logic is local and
   checkable; maintainer merged v1; in mainline as of v7.3-rc1. No
   separate Tested-by.
2. Fixes a real bug that affects users? **PASS** — ranged FITRIM
   discards the wrong free clusters and lies about `len`.
3. Important issue? **PASS** (MEDIUM) — wrong discard range / thin unmap
   / wrong userspace length, not a crash. Still a real FS ioctl bug, not
   a cleanup.
4. Small and contained? **PASS** — one function, +19/−12.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — `git apply --check`
   succeeded.

**Step 9.3: EXCEPTION CATEGORIES**
- Record: **None** (not a device ID/quirk/DT/build/doc exception).
  Qualifies as a normal bugfix.

**Step 9.4: DECISION**
This tree still has the original 2021 trim loop. The fix is a tight
range/wrap check, not a refactor. For 6.12 users of exFAT FITRIM,
especially chunked/partial trim, backporting prevents out-of-range
discards with negligible risk.

### What the commit solves for this tree
Partial `FITRIM` on exFAT can discard free clusters **before** the
requested offset after `exfat_find_free_bitmap()` wraps, and return a
**larger** trimmed length than requested. That violates the ioctl
contract and can TRIM the wrong region on SSDs/thin volumes. The code
path exists here unchanged; the patch applies cleanly.

### Risk vs benefit
Benefit is correctness of a privileged but standard maintenance ioctl on
a common removable/Android filesystem. Risk is very low: fewer discards,
same locks, same helpers.

---

Verification:
- [Phase 1] `git log -1` / `git show 2de727471b3b1`: subject/body/SOBs
  only; no Fixes/Reported-by/Cc stable
- [Phase 1] Local tree: `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`;
  `make kernelversion` → **6.12.111**
- [Phase 2] Diff is only `exfat_trim_fs()` in `fs/exfat/balloc.c`
  (+19/−12)
- [Phase 2] Read local `exfat_trim_fs` (balloc.c:309–387) and
  `exfat_find_free_bitmap` wrap (balloc.c:266–271)
- [Phase 2] Function SHA-1 of local trim == parent of `2de727471b3b1`
- [Phase 3] `git blame -L 309,387 fs/exfat/balloc.c` → all
  `654762df2ec7d` (v5.13 FITRIM)
- [Phase 3] `git blame -L 266,274` wrap → `1e49a94cf70720`
- [Phase 3] `git merge-base --is-ancestor 654762df2ec7d HEAD` → yes;
  `2de727471b3b1` → **not** in HEAD
- [Phase 3] `git apply --check` of `2de727471b3b1` → **success**, offset
  −12
- [Phase 3] `git log origin/master -- fs/exfat/balloc.c` after the fix →
  **empty** (no follow-up)
- [Phase 4] `b4 dig -c 2de727471b3b1` →
  https://patch.msgid.link/20260813142919.812744-1-anmuxixixi@gmail.com
- [Phase 4] `b4 dig -a`: v1 only; `-w`: maintainer + Seo + Mo + exfat
  list
- [Phase 4] mbox: Namjae Jeon “Applied it to #dev”; no NAK/stable tag
- [Phase 4] lore WebFetch/curl: **403 Anubis** — stable@ search
  UNVERIFIED
- [Phase 5] Callers: only `exfat_ioctl_fitrim()`;
  `capable(CAP_SYS_ADMIN)`
- [Phase 5] FAT `fat_trim_fs()` already limits to `ent_start..ent_end`
- [Phase 6] Buggy loop present; no prior range fix in this tree
- [Phase 8] Failure: out-of-range discard + bad `range->len`; severity
  MEDIUM
- UNVERIFIED: whether this SHA was already discussed on stable@

The patch is a small, correctly scoped FITRIM range check for a bug that
exists in this 6.12 tree and applies without prerequisites.

**YES**

 fs/exfat/balloc.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/exfat/balloc.c b/fs/exfat/balloc.c
index 0b6466b3490a0..4013034375dbe 100644
--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -327,14 +327,27 @@ int exfat_trim_fs(struct inode *inode, struct fstrim_range *range)
 	mutex_lock(&sbi->bitmap_lock);
 
 	trim_begin = trim_end = exfat_find_free_bitmap(sb, clu_start);
-	if (trim_begin == EXFAT_EOF_CLUSTER)
+	/*
+	 * exfat_find_free_bitmap() may wrap around to the beginning of
+	 * the bitmap. Reject a cluster outside the requested range.
+	 */
+	if (trim_begin == EXFAT_EOF_CLUSTER ||
+		trim_begin < clu_start || trim_begin > clu_end)
 		goto unlock;
 
-	next_free_clu = exfat_find_free_bitmap(sb, trim_end + 1);
-	if (next_free_clu == EXFAT_EOF_CLUSTER)
-		goto unlock;
+	for (;;) {
+		if (trim_end >= clu_end)
+			break;
+
+		next_free_clu = exfat_find_free_bitmap(sb, trim_end + 1);
+		/*
+		 * Stop if the search wrapped around or moved beyond the requested
+		 * FITRIM range.
+		 */
+		if (next_free_clu == EXFAT_EOF_CLUSTER ||
+			next_free_clu <= trim_end || next_free_clu > clu_end)
+			break;
 
-	do {
 		if (next_free_clu == trim_end + 1) {
 			/* extend trim range for continuous free cluster */
 			trim_end++;
@@ -355,17 +368,11 @@ int exfat_trim_fs(struct inode *inode, struct fstrim_range *range)
 			trim_begin = trim_end = next_free_clu;
 		}
 
-		if (next_free_clu >= clu_end)
-			break;
-
 		if (fatal_signal_pending(current)) {
 			err = -ERESTARTSYS;
 			goto unlock;
 		}
-
-		next_free_clu = exfat_find_free_bitmap(sb, next_free_clu + 1);
-	} while (next_free_clu != EXFAT_EOF_CLUSTER &&
-			next_free_clu > trim_end);
+	}
 
 	/* try to trim remainder */
 	count = trim_end - trim_begin + 1;
-- 
2.53.0

