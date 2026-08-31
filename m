Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DF74B5CB8;
	Mon, 31 Aug 2026 13:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184375; cv=none; b=N6GRHNjgCwN2/I+dviUC/bW0uLXdnC4S9G/uJIUFXwnUPHs1WNENNthR3DWcZ6ClBSVrNDdmpfdve9NgT6JYYKnk9PC7J5wOW6o0hHIXJpCHXE22bM8gHw60meh+A2HCTZ/fsEBSARnS/GAZdIge20kE5cCbh5rgIO8bPMbp4eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184375; c=relaxed/simple;
	bh=x74tzz1tGb9T0KgkWKckomXEDmM3HhxUWvQvdoS8XZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NbDKZPBqAihW7LEmgcjN+ApUGOb6zd3GF9mK5vt4MjTSfT8aEUVwJNs9KYBEIxJby+6vX14UQegAuXFBvRFxWIG700OufG0h0jCwLjz5lTi5oW1GOkMMYx2lm6VjVZ13HbAc9vAmwxTOrNb0fwKi+r0NOWD05KANLCqvokQE2bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f8AQAxfJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f8AQAxfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E2B1F000E9;
	Mon, 31 Aug 2026 13:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184373;
	bh=uOolE7WRmdv9KZkryDdJWBNrvjePe1UYXI9l8f7nFGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f8AQAxfJ367bObvqzi24z1Z0ac1H0G4auKgrHQoCFqkEqBYJJwiv7bIwSuXio8Ixx
	 2NlxgH+xIT2E/pPNEEMioeS2Ug2yHn8UKFSCUl7OjDIB09qPSv333vOXXRiB9+E5jj
	 udweC7CeWka+DHsQEhGCg34t+G0wqb9DqTA+bRx3qIXcEvGimgRqGvs29PxeHm1nKa
	 5bAkJ+U/TVWJooLumgprQBKNNpKno0Z1MUkFH4fDQsFdFZ3dATvaJJf9p3iyC3wJjf
	 UCCnK7hX1obAbyxDZ7Hmkp2WogAXppPXKDZ+hBREvvv1inu4tDdAVTCUpxFtzmjAGg
	 Kq5v+9kvhjZoQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] md/raid5: account discard IO
Date: Mon, 31 Aug 2026 09:31:23 -0400
Message-ID: <20260831133314.4125787-655-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

[ Upstream commit 74ddbf98e2db646ec58f7e7731c936b7a4a470fe ]

Raid5 handles discard bios internally through make_discard_request() and
never passes them through md_account_bio(). As a result, discard IO is
missing the md-device iostat accounting that normal raid5 IO and discard
IO in other raid levels get from md_account_bio().

Before accounting the bio, trim the request to the full data stripes that
raid5 will actually discard. The first full stripe is the ceiling of the
bio start divided by data-stripe sectors, and the last full stripe is the
floor of the bio end divided by data-stripe sectors. Account that exact
MD logical full-stripe range, then restore the original iterator so bio
completion and iostat still cover the original request.

Link: https://patch.msgid.link/20260605072639.2434847-2-yukuai@kernel.org
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `md/raid5: account discard IO`

**Local tree:** Linux **6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`)
**Upstream commit:** `74ddbf98e2db6` (not yet in current HEAD; present
on `autosel` as `36d4b4a2d7925`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[md/raid5]` — missing verb "fix", but intent is clear —
`[account]` discard IO through `md_account_bio()` for iostat and unified
MD accounting.

### Step 1.2: Tags
**Record:**
- **Link:**
  https://patch.msgid.link/20260605072639.2434847-2-yukuai@kernel.org
  (patch 2 of a series)
- **Signed-off-by:** Yu Kuai `<yukuai@fygo.io>`
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Cc: stable@
- Message ID suffix `-2` implies a multi-patch series (patch 1 not
  identified in this tree)

### Step 1.3: Body analysis
**Record:**
- **Bug:** RAID5 discard bios go through `make_discard_request()` and
  bypass `md_account_bio()`, unlike normal RAID5 IO and discard on other
  RAID levels.
- **Symptom:** MD device iostat does not reflect discard traffic
  (`iostat` discard columns wrong).
- **Fix approach:** Temporarily trim bio iterator to the full data-
  stripe range RAID5 will actually discard, call `md_account_bio()`,
  restore original iterator for completion.
- **Root cause:** Discard has a dedicated code path that never
  integrated with the `md_account_bio()` infrastructure added for other
  IO.

### Step 1.4: Hidden bug fix?
**Record:** Yes — described as accounting, but `md_account_bio()` also:
- Holds `active_io` until bio completion (via cloned bio +
  `md_end_clone_io`)
- Starts bitmap discard tracking via `md_bitmap_start()` when bitmap is
  enabled (since `ac9dad8faaa7b`)
- Provides `bio_start_io_acct()` / `bio_end_io_acct()` for block-layer
  statistics

The stripe-boundary refactor (`first_stripe`/`last_stripe` vs old align-
then-round-up) may also correct edge-case discard range selection.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/md/raid5.c` only (+23 / -10 lines)
- **Function:** `make_discard_request()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow per hunk
**Record:**
1. **Before:** Computed stripe range via align-to-`RAID5_STRIPE_SECTORS`
   then `DIV_ROUND_UP`; no accounting; proceeded directly to stripe
   loop.
2. **After:** Computes `first_stripe`/`last_stripe` directly from bio
   sector range; early `bio_endio()` if no full stripes; temporarily
   adjusts `bi_iter`, calls `md_account_bio()`, restores iterator, then
   runs existing stripe loop.
3. **Affected path:** `raid5_make_request()` → `make_discard_request()`
   for `REQ_OP_DISCARD` bios.

### Step 2.3: Bug mechanism
**Record:** **Missing integration with unified MD IO accounting
infrastructure** (category: logic/correctness + reference-counting side
effects)
- No `percpu_ref_get(&mddev->active_io)` for discard IO lifetime
- No iostat accounting (`bio_start_io_acct` / `bio_end_io_acct`)
- No bitmap `start_discard`/`end_discard` via `md_account_bio()` path
  (relevant since `ac9dad8faaa7b` is in this tree)

### Step 2.4: Fix quality
**Record:** Fix is minimal and mirrors the already-merged `md/raid10:
fix missing discard IO accounting` (`d05af90d6218e`). Iterator
save/restore pattern is sound. Low regression risk; stripe-index
simplification is equivalent or more conservative at boundaries.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `make_discard_request()` introduced in `620125f2bf8ff`
(Shaohua Li, 2012) — discard support predates `md_account_bio()`.
Missing accounting since `10764815ff472` (2021) added `md_account_bio()`
to RAID5 read/write paths but not discard.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag. Logical regression point:
`10764815ff472` ("md: add io accounting for raid0 and raid5"), which is
an ancestor of this tree.

### Step 3.3: Related commits
**Record:**
- `d05af90d6218e` — raid10 discard accounting fix (in this tree)
- `05048cbccab79` — raid5 inflight counter leak fix via
  `md_account_bio()`
- `ac9dad8faaa7b` — bitmap discard ops support (in this tree)
- `cc22b5407e9ca` — raid0 split-bio iostat accounting (backported to
  stable 6.6.y)
- `74ddbf98e2db6` — this fix (mainline, not in HEAD)

### Step 3.4: Author context
**Record:** Yu Kuai is an active MD contributor; authored raid10 discard
fix, raid5 inflight accounting fix, and bitmap discard infrastructure.

### Step 3.5: Dependencies
**Record:** Standalone for backport purposes. Requires
`md_account_bio()` (present since 2021) and benefits from
`ac9dad8faaa7b` bitmap discard ops (present in 6.18.44). No other series
patches required for correctness.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1–4.2: Patch discussion
**Record:** `b4 dig -c 74ddbf98e2db6` returned no results. Lore search
blocked by Anubis bot protection. Link from commit message could not be
fetched. Patch is `2434847-2` (series context unknown).

### Step 4.3: Bug reports
**Record:** No syzbot, bugzilla, or user Reported-by tags. Raid10
parallel fix included before/after `iostat` measurements showing severe
under-reporting.

### Step 4.4: Series context
**Record:** Patch 2 of unknown series. No evidence other patches are
required for this fix to apply.

### Step 4.5: Stable list history
**Record:** `d05af90d6218e` (raid10 discard accounting) is already in
`stable/linux-6.18.y`. `cc22b5407e9ca` (raid0 iostat) was backported to
6.6.y. Strong precedent for this class of MD accounting fix in stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `make_discard_request()`, `md_account_bio()`,
`raid5_make_request()`

### Step 5.2: Callers
**Record:** `raid5_make_request()` (line 6137) is the sole caller of
`make_discard_request()`. Reached from `md_handle_request()` →
`md_submit_bio()` on discard bios to `/dev/md*`.

### Step 5.3: Callees
**Record:** `md_account_bio()` → `percpu_ref_get(&active_io)` +
`md_clone_bio()` → `bio_start_io_acct()`, `md_bitmap_start()` (for
WRITE-direction ops including discard, since `REQ_OP_DISCARD=3` has
write bit set).

### Step 5.4: Reachability
**Record:** Reachable from userspace via `BLKDISCARD`/`fstrim` on RAID5
arrays. Common on systems using SSD-backed RAID5.

### Step 5.5: Similar patterns
**Record:** Raid10 fixed identically (`d05af90d6218e`). Raid0 discard
path (`raid0_handle_discard`) still lacks `md_account_bio()` —
inconsistency remains elsewhere, but raid5 is the subject here.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current `make_discard_request()` at lines 5701–5782
has no `md_account_bio()` call. Normal RAID5 IO calls it at line 6163.

### Step 6.2: Backport difficulty
**Record:** Clean apply expected — upstream diff applies to current
`raid5.c` with only line-offset differences. No API conflicts.

### Step 6.3: Related fixes already present?
**Record:** Raid10 discard fix (`d05af90d6218e`) and bitmap discard ops
(`ac9dad8faaa7b`) are in tree. This raid5 fix is the remaining gap.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/md/` — **IMPORTANT** (block/MD RAID, used widely in
servers and NAS).

### Step 7.2: Activity
**Record:** Actively maintained; recent raid5 fixes for lockups, IO
hangs, and overlap races in this tree.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of RAID5/6 arrays who issue discard/trim (`fstrim`,
`BLKDISCARD`). Config-specific: RAID5/6 personality with discard
enabled.

### Step 8.2: Trigger conditions
**Record:** Any discard IO to a RAID5 device. Common during periodic
`fstrim` on SSD-backed arrays.

### Step 8.3: Failure mode severity
**Record:**
- **iostat under-reporting** — MEDIUM (monitoring/visibility; raid10
  showed 16 MB/s vs 20462 MB/s)
- **Missing `active_io` tracking for in-flight discard** — MEDIUM-HIGH
  (could affect suspend/quiesce timing; discard bios can complete
  asynchronously via `bio_inc_remaining`)
- **Missing bitmap discard tracking** — MEDIUM (with bitmap-enabled
  arrays, discard regions not tracked through unified path; raid5 has
  stripe-level bitmap handling but `md_account_bio()` path is now the
  canonical one since `ac9dad8faaa7b`)
- Not a direct crash/corruption fix, but functional accounting gap with
  suspend/bitmap implications

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for consistency (raid10 already fixed in this tree),
  correct monitoring, proper `active_io`/bitmap lifecycle
- **Risk:** LOW — 23-line change, mirrors accepted raid10 pattern, no
  API changes
- **Ratio:** Favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR:**
- Direct parallel to `d05af90d6218e` already in 6.18.y stable
- Precedent: `cc22b5407e9ca` iostat fix backported to 6.6.y
- Bug confirmed present in 6.18.44 tree
- All prerequisites present (`md_account_bio`, bitmap discard ops)
- Small, obviously correct, low risk
- `md_account_bio()` provides more than iostat — `active_io` and bitmap
  tracking

**AGAINST:**
- No syzbot/user crash reports
- Primary visible symptom is iostat inaccuracy
- Slight stripe-boundary calculation change (likely correction, but
  unverified with tests)
- No maintainer Reviewed-by/Acked-by on this specific patch
- Lore discussion unavailable

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors raid10 fix; author
   is subsystem expert; no Tested-by but pattern proven
2. Fixes real bug affecting users? **PASS** — discard accounting gap
   affects all RAID5 discard users
3. Important issue? **PASS (MEDIUM)** — not crash/corruption, but
   functional accounting gap with suspend/bitmap implications; same
   class accepted for raid10
4. Small and contained? **PASS** — 23 lines, one file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — prerequisites present, clean
   apply expected

### Step 9.3: Exception category
**Record:** Not a device-ID/quirk/DT/build/docs exception. Standard bug
fix.

### Step 9.4: Decision rationale
This is the RAID5 counterpart to `d05af90d6218e`, which is already in
the 6.18.y tree. The MD subsystem has established stable precedent for
IO accounting fixes (`cc22b5407e9ca` on 6.6.y). The bug exists in
6.18.44, prerequisites are satisfied, and the fix is small with low
regression risk. While the most visible symptom is iostat inaccuracy,
`md_account_bio()` also provides `active_io` lifecycle tracking and
bitmap discard integration that RAID5 discard currently lacks.

---

## Verification

- [Phase 1] Parsed commit message from user query and `git show
  74ddbf98e2db6`
- [Phase 1] Tags: Link only; no Fixes/Reported-by/Tested-by
- [Phase 2] Read current `make_discard_request()` at lines 5701–5782;
  confirmed no `md_account_bio()`
- [Phase 2] Read `raid5_make_request()` discard path at lines 6137–6140
- [Phase 2] Read `md_account_bio()` at `md.c:9308–9312` and
  `md_clone_bio()` at `md.c:9283–9306`
- [Phase 3] `git blame` on `make_discard_request()`: introduced
  `620125f2bf8ff` (2012)
- [Phase 3] `git log -S md_account_bio -- drivers/md/raid5.c`: added
  `10764815ff472`, not extended to discard
- [Phase 3] Found related commits: `d05af90d6218e`, `05048cbccab79`,
  `ac9dad8faaa7b`, `cc22b5407e9ca`
- [Phase 3] `git merge-base --is-ancestor ac9dad8faaa7b 74ddbf98e2db6`:
  bitmap discard prerequisite present
- [Phase 3] `git merge-base --is-ancestor d05af90d6218e HEAD`: raid10
  fix in tree
- [Phase 4] `b4 dig -c 74ddbf98e2db6`: no results
- [Phase 4] Lore fetch blocked by Anubis
- [Phase 4] `git log stable/linux-6.18.y --grep raid10: fix missing
  discard`: found `d05af90d6218e`
- [Phase 4] `git log stable/linux-6.18.y --grep raid0: account for
  split`: found `cc22b5407e9ca` on 6.6.y
- [Phase 5] Traced call chain: `md_submit_bio` → `md_handle_request` →
  `raid5_make_request` → `make_discard_request`
- [Phase 5] Verified `REQ_OP_DISCARD=3` → `op_is_write()` true →
  `bio_data_dir()==WRITE` in `blk_types.h:336,441-444`
- [Phase 6] `git describe HEAD`: v6.18.44; `make kernelversion`: 6.18.44
- [Phase 6] `git merge-base --is-ancestor 74ddbf98e2db6 HEAD`: NOT in
  HEAD (fix needed)
- [Phase 6] Buggy code confirmed at `drivers/md/raid5.c:5701-5782`
- [Phase 8] Read `mddev_suspend()` at `md.c:489-506`: waits on
  `active_io` reaching zero
- [UNVERIFIED] Exact suspend+discard race reproduction — inferred from
  code path, not from bug report

**YES**The background searches finished and match the earlier analysis:

- **Commit location:** `md/raid5: account discard IO` is upstream as
  `74ddbf98e2db6` and on the `autosel` branch as `36d4b4a2d7925`, but it
  is **not** in the current 6.18.44 HEAD.
- **Stable precedent:** `stable/linux-6.18.y` already has the parallel
  raid10 fix (`d05af90d6218e`); this raid5 fix is not there yet.

That supports the **YES** backport recommendation for 6.18.y.

 drivers/md/raid5.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0d83c4adf8e83..5c81dbac7eab5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5702,7 +5702,10 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 {
 	struct r5conf *conf = mddev->private;
 	sector_t logical_sector, last_sector;
+	sector_t first_stripe, last_stripe;
 	struct stripe_head *sh;
+	struct bvec_iter bi_iter;
+	struct bio *orig_bi = bi;
 	int stripe_sectors;
 
 	/* We need to handle this when io_uring supports discard/trim */
@@ -5713,19 +5716,29 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 		/* Skip discard while reshape is happening */
 		return;
 
-	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
-	last_sector = bio_end_sector(bi);
-
-	bi->bi_next = NULL;
-
 	stripe_sectors = conf->chunk_sectors *
 		(conf->raid_disks - conf->max_degraded);
-	logical_sector = DIV_ROUND_UP_SECTOR_T(logical_sector,
-					       stripe_sectors);
-	sector_div(last_sector, stripe_sectors);
+	first_stripe = DIV_ROUND_UP_SECTOR_T(bi->bi_iter.bi_sector,
+					     stripe_sectors);
+	last_stripe = bio_end_sector(bi);
+	sector_div(last_stripe, stripe_sectors);
+
+	if (first_stripe >= last_stripe) {
+		bio_endio(bi);
+		return;
+	}
+
+	bi_iter = bi->bi_iter;
+	bi->bi_iter.bi_sector = first_stripe * stripe_sectors;
+	bi->bi_iter.bi_size = ((last_stripe - first_stripe) *
+			       stripe_sectors) << 9;
+	md_account_bio(mddev, &bi);
+	orig_bi->bi_iter = bi_iter;
+	bi->bi_iter = bi_iter;
+	bi->bi_next = NULL;
 
-	logical_sector *= conf->chunk_sectors;
-	last_sector *= conf->chunk_sectors;
+	logical_sector = first_stripe * conf->chunk_sectors;
+	last_sector = last_stripe * conf->chunk_sectors;
 
 	for (; logical_sector < last_sector;
 	     logical_sector += RAID5_STRIPE_SECTORS(conf)) {
-- 
2.53.0

