Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463FE5D9D75;
	Mon, 19 Oct 2026 14:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418524; cv=none; b=N46wzxLHHlEjBhWji8FU2Vk/M+cYcc8iaPwesSLzpeKnG+aBRiR0abgKGBjUaSULFxkk5bT9mYMo+1C16REcosIPhD2SFuvV5U7Vf/BlDpFa5qnRunvxPcPfSSyR57Td8VtPI1myp1L4JDdddYcvTQ1yuAVOzocrpa8dHb9bqp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418524; c=relaxed/simple;
	bh=MMD+EBEPV0Pg7Ltq9yTjC1CMXB2jXqd4hX7pdWvy8Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KLxSu98svAcFK1QDJg1zuNn0CwTTGnXSrEXiJXKQMuID6Wj2viSO3x82DOy6cwtTRRFfwdm8J1HWIgxpufVsb6L9KxlYQA7KuX2+y6xr6gR4A/1V51SHUDPblgmGtyatqnZzYzUklnKu8w5fOcaqOgglMvZsgDXF7+v8H8Ss064=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dvpfWu8G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dvpfWu8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494D81F000C8;
	Mon, 19 Oct 2026 14:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418521;
	bh=u/avkUqxcKZrBjqLt0ZXn2Myl1uHIiz9AgCo+A8lC9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dvpfWu8GEO41oTL8jjpm9IUERIg0k/mjDLKlfOYb5EU6AiKgpqpHh2uK6dzGuMMq3
	 iY4QJVEsPbpgauJ0uUaZaBDQrdijapKo7EDCvYdhIC9omdaEeoKN0DpMza1DadM6Dd
	 sGh1TkyM1Aj060g4BDX5Z/IcXf0D1E+4Kn9SGgP+iyZ7hWFcdZCGir+1Id7PqJCr0y
	 S3FxoxSMoxnMI9YdvZmIaM6KQ/U1wpFU1LBuN/4ahVQERqT+lpydWxzahOhjoYLfLS
	 6lBQNlJpG8XZi5bZTK3/w3bLIItpm45LL6+GH2WDAX8K/BRJ2rQ7O1mj3nIbWSH+dD
	 k82S2kIFpqPKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yu Kuai <yukuai@fygo.io>,
	Mykola Marzhan <mykola@meshstor.io>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] md: skip bitmap accounting for empty write ranges
Date: Mon, 19 Oct 2026 09:49:58 -0400
Message-ID: <20261019135441.1420968-307-sashal@kernel.org>
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

From: Yu Kuai <yukuai@fygo.io>

[ Upstream commit 87c10252e3d6c28769d93bea9e6a9b592e5809d1 ]

mkfs.ext4 can submit zero-sector flush/FUA bios. These bios are WRITE
bios for md_write_start() purposes, but they do not cover any data sector
and must not dirty bitmap bits.

md bitmap accounting currently passes such bios to bitmap start_write().
For llbitmap this reaches llbitmap_start_write() with sectors == 0,
which underflows the end chunk calculation.

Personality bitmap mapping can also turn a non-empty bio into an empty
bitmap range when the requested sectors are outside the active bitmap
geometry. Treat both cases as not started, so the completion path will not
call end_write() for an empty range.

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Link: https://patch.msgid.link/20260802195038.164272-11-yukuai@kernel.org
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53** (`p-6.18`). The empty-range skip is
missing, and the llbitmap underflow path is present. Full analysis
follows.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[md] [skip] skip bitmap accounting for empty write ranges**
- Subsystem: `md` (MD RAID core)
- Action verb: **skip** (prevent incorrect handling)
- Intent: do not run bitmap start/end accounting when the write covers
  no data sectors

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Tested-by: Mykola Marzhan <mykola@meshstor.io>` — independent
  hardware/user verification
- `Link:
  https://patch.msgid.link/20260802195038.164272-11-yukuai@kernel.org` —
  v5 series, patch 10/29 (msgid `-11` is 1-based with cover)
- `Signed-off-by: Yu Kuai <yukuai@fygo.io>` — author (MD contributor;
  ignore pipeline SoBs)
- No `Fixes:` tag (expected)
- No `Cc: stable` (expected)
- No `Reported-by:` / syzbot
- No `Reviewed-by:` on this revision (v1 had Reviewed-by from Su Yue on
  earlier series patches)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** mkfs.ext4 can submit zero-sector flush/FUA bios. They are
  WRITE bios for `md_write_start()`, but they cover no data and must not
  dirty bitmap bits. They are still passed to bitmap `start_write()`.
- **llbitmap failure mode:** `llbitmap_start_write()` with `sectors ==
  0` underflows the end-chunk calculation (`offset + sectors - 1`).
- **Second case:** personality `bitmap_sector()` can map a non-empty bio
  to an empty bitmap range (outside active geometry). Completion must
  not call `end_write()` for a start that never ran / was empty.
- **Symptom:** bitmap accounting of a zero-length range → unsigned wrap
  in llbitmap, then a huge page/chunk walk (barriers + state machine),
  i.e. hang, bitmap corruption, or crash.
- **Version info:** none in the message; code is the post-6.14 upper-
  layer bitmap path + llbitmap (2025).

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not hidden.** It is an explicit correctness fix: skip empty
ranges so start/end stay balanced and llbitmap does not underflow.

===============================================================
PHASE 2: DIFF ANALYSIS
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/md/md.c` only (~+7 / −2, four tight edits)
- Functions: `md_bitmap_start()`, `md_end_clone_io()`, `md_clone_bio()`
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
1. **`md_bitmap_start`:** after optional `bitmap_sector()` remap,
   **return if `sectors == 0`** instead of calling
   `start_write`/`start_discard`.
2. **`md_end_clone_io`:** call `md_bitmap_end()` only if
   `md_io_clone->sectors != 0` (paired with start).
3. **`md_clone_bio`:** set `md_io_clone->sectors = 0` (mempool reuse).
   Skip the start path unless `bio_sectors(*bio) != 0`.
4. **Affected paths:** WRITE clone accounting (`md_account_bio` →
   `md_clone_bio`), including 0-sector flush/FUA and post-map empty
   ranges. Not a refactor of the hot data path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** logic / integer underflow (unsigned wrap) + start/end
  accounting mismatch
- **Mechanism:** `llbitmap_start_write()` does
  `end = (offset + sectors - 1) >> chunkshift`.
  `sectors == 0` underflows. If `offset == 0`, `end` becomes a huge
  chunk index; the `page_start <= page_end` loop and
  `llbitmap_state_machine()` then walk a massive range.
- Legacy `bitmap_start_write()` uses `while (sectors)` and is a no-op
  for 0; the crash is **llbitmap-specific**, but the skip is correct for
  both backends.
- The `sectors = 0` init is required: after skipping the start `if`,
  completion must not see a stale mempool `sectors` value.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Obviously correct:** empty range → don’t start, don’t end, init
  `sectors` to 0.
- **Minimal:** four related edits, no API change.
- **Regression risk: low.** Worst case is skipping bitmap bits for a
  0-sector I/O (correct). Start/end stay balanced.
- **Local extra path:** this tree’s `md_free_cloned_bio()` also calls
  `md_bitmap_end()` without a `sectors` check (raid5 reshape-wait
  abort). A faithful backport should add the same guard there. That is a
  small extra hunk, not a reason to reject.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- `md_bitmap_start` / clone accounting introduced by `cd5fc65338181`
  (“md/md-bitmap: move bitmap_{start, end}write to md upper layer”,
  2025-01-09) — **is an ancestor of this HEAD**.
- Discard ops wiring: `ac9dad8faaa7b`.
- `else md_io_clone->start_time = 0` already here from `d81822fd5fa81`
  (“md: avoid stale clone I/O accounting timestamps”).
- llbitmap: `5ab829f1971dc` (“md/md-llbitmap: introduce new lockless
  bitmap”, 2025-09-06) — **present**.
- Bug is in **this** 6.18 tree, not only in later mainline.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Introducers are `cd5fc65338181` (upper-layer
accounting of all WRITE bios, including 0-sector) and `5ab829f1971dc`
(llbitmap underflow). Both are in this tree (`git merge-base --is-
ancestor` exit 0 for `cd5fc65338181`).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: recent `drivers/md/md.c` on this branch includes:
- `73881ff7a7591` md: wait for behind writes before destroying bitmap
  (v5 patch 6)
- `d81822fd5fa81` md: avoid stale clone I/O accounting timestamps (v5
  patch 7)

Same series already on this tree:
- `930cc4f1af5a1` md/md-llbitmap: prevent create failure bitmap UAF
  (patch 8)
- `c55aa6c17f019` md/md-llbitmap: stop daemon timer rearm on destroy
  (patch 9)

This commit is **v5 10/29**, the next accounting fix. Standalone vs
later reshape patches (11+). **No missing prerequisite** among 6–9 for
this hunk.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Yu Kuai is a primary MD/llbitmap author on this tree (bitmap
move, llbitmap, this series). Weight: high.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Needs `md_bitmap_start` / `md_io_clone` /
`bitmap_ops->start_write` — all present. Does **not** need patch 12
(`prepare_range` / exact mapping); v5 commit text was updated to
`bitmap_sector` so it stands alone. **Can apply standalone** with small
context tweaks.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- Lore msgid `20260802195038.164272-11-yukuai@kernel.org` (v5 10/29).
- Cover: [PATCH v5 00/29] md: improve lockless bitmap reshape support
  https://lists.openwall.net/linux-kernel/2026/08/02/769
- Earlier: v1 2026-06-05, v2, v4 07/25, v5 10/29.
- Cover: patches 6–11 are “md core and llbitmap lifetime/accounting
  prerequisites”; this one is “empty bitmap ranges”.
- v5 note: “Fix patch 10 to keep empty-range handling valid before the
  exact mapping hook is introduced.”
- **No NAK** in the fetched cover/patch bodies.
- `b4 mbox`/`b4 dig -c` did not resolve without a mainline SHA (local
  master is older than this series). Thread recovered via
  gnuweeb/IU/openwall.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: To/Cc Song Liu, Li Nan, Xiao Ni; lists linux-raid, linux-kernel.
Tested-by Mykola Marzhan (v4, carried to v5). Su Yue Reviewed-by on v1
series (not re-stated on this hunk in v5).

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot/bugzilla. Trigger described as **mkfs.ext4 zero-sector
flush/FUA** — common userspace. Tested-by supports real-world impact.
**UNVERIFIED:** did not reproduce mkfs.ext4 on this kernel.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Independent of reshape (11+). Empty-range skip is valid before
`prepare_range`. Same-series 6–9 already in this tree.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: gnuweeb `/stable/?q=skip+bitmap+accounting...` returned
unrelated stable-rc noise, **no dedicated stable thread**. Not a
negative signal.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: KEY FUNCTIONS**

Record: `md_bitmap_start`, `md_bitmap_end` (unchanged body, callers
gated), `md_end_clone_io`, `md_clone_bio`. Callee of interest:
`llbitmap_start_write` / `bitmap_start_write`. Local extra:
`md_free_cloned_bio`.

**Step 5.2: TRACE CALLERS**

Record:
- `md_clone_bio` ← `md_account_bio`
- `md_account_bio` ← raid0, raid1, raid10, raid5, md-linear
  `make_request`
- `md_end_clone_io` = clone `bi_end_io`
- `md_free_cloned_bio` ← raid5 `STRIPE_WAIT_RESHAPE` abort
- Context: block submit from userspace (mkfs, etc.), not init-only

**Step 5.3: TRACE CALLEES**

Record: `md_bitmap_start` → `pers->bitmap_sector` (raid5) →
`bitmap_ops->start_write` (`llbitmap_start_write` or
`bitmap_start_write`). llbitmap: unsigned end chunk, per-page barriers,
`llbitmap_state_machine(..., BitmapActionStartwrite)`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: **Userspace-reachable.** raid1/raid5 still send PREFLUSH empty
bios to `md_flush_request()`, which completes `bio_sectors == 0` without
accounting. FUA-only 0-sector WRITEs, or PREFLUSH that falls through
(`-EAGAIN` journal fallback in raid5), hit `md_account_bio`.
raid0/linear call `md_account_bio` on the I/O path. Confirmed in-tree:
`raid5_make_request` calls `md_account_bio` at line 6182 after flush
handling.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: `llbitmap_end_write` / `llbitmap_start_discard` use the same
`offset + sectors - 1` pattern. This patch avoids calling them with 0.
Legacy bitmap is safe via `while (sectors)`. No duplicate core skip
already present (`rg` found no `if (!md_io_clone->sectors)`).

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.**
- Tree: `git describe HEAD` → `p-6.18-1-g03b85e06ca9bf`; `make
  kernelversion` → **6.18.53**
- `md_bitmap_start()` at `drivers/md/md.c:9261` calls `fn()` with no
  empty-range check
- `md_clone_bio()` at 9319 starts bitmap on every WRITE if bitmap
  enabled, including `bio_sectors == 0`
- `llbitmap_start_write()` at `md-llbitmap.c:1074` does `offset +
  sectors - 1`
- `raid5_bitmap_sector()` can set `*sectors = end - start` to 0 when the
  mapped range is empty

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Minor conflicts / small extra hunk.**
- Local `md_end_clone_io` uses `bio->bi_private` as `md_io_clone*`;
  candidate uses `container_of` + reshape completion. The `sectors &&`
  condition still matches.
- Local already has `else start_time = 0` (patch 7).
- Add the same `md_io_clone->sectors &&` guard to `md_free_cloned_bio()`
  (6.18-only helper).

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: Empty-range skip **not** present. Series patches 6–9 **are**
present. No alternate fix for this underflow.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: **md (MD RAID bitmap accounting).** **IMPORTANT** — not core
mm/vfs, but RAID+bitmap is widely used; mkfs on an MD device is a normal
path. llbitmap is the lockless bitmap backend in 6.18.

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: **Active** on this branch (llbitmap, clone accounting, this Yu
Kuai series). Still a real bug in shipping 6.18 code, not a speculative
cleanup.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: WHO IS AFFECTED**

Record: **MD users with a bitmap enabled**, especially **llbitmap**.
Triggered by 0-sector WRITE/flush/FUA (mkfs.ext4) or raid5
`bitmap_sector` mapping a request to an empty range. Config: `CONFIG_MD`
+ bitmap (llbitmap or classic).

**Step 8.2: TRIGGER CONDITIONS**

Record:
- Common: mkfs.ext4 / empty flush+FUA on an MD array with bitmap
- Also: raid5 geometry mapping to a zero bitmap range
- Unprivileged user with write access to the array (typical admin/mkfs)
- Not a narrow race; it is size==0 handling

**Step 8.3: FAILURE MODE SEVERITY**

Record:
- llbitmap: unsigned wrap → enormous chunk/page walk, barriers, state
  machine on invalid range → **hang, bitmap corruption, possible crash**
- Classic bitmap: `while (sectors)` no-op, but start/end still run with
  0; skip is still correct
- Severity: **HIGH** (hang/corruption on a common mkfs path with
  llbitmap)

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit: high** — stops underflow/wrong bitmap updates on a real I/O
  pattern
- **Risk: very low** — ~7–10 lines, local to clone accounting, start/end
  remain paired
- **Ratio: strongly favors backport**

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real bug: 0-sector WRITE accounting into llbitmap underflow
- Common trigger (mkfs.ext4 flush/FUA), Tested-by
- Buggy path exists in this 6.18.53 tree (`md_bitmap_start`, llbitmap)
- Small, obviously correct, no new API
- Series patches 6–9 already here; this is the matching empty-range fix
- MD RAID data-integrity relevant

**AGAINST:**
- Part of a larger reshape series (but this hunk is standalone)
- `md_free_cloned_bio` needs the same `sectors` guard (small extra hunk)
- Context differs slightly (`bi_private` vs `container_of`)

**UNRESOLVED:**
- Did not run mkfs.ext4 against this build
- `b4 dig -c` had no mainline SHA in this clone; thread confirmed via
  other archives
- gnuweeb stable search was noisy, no dedicated nomination thread

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — paired start/end skip +
   Tested-by
2. Real bug affecting users? **PASS** — mkfs.ext4 0-sector WRITE +
   llbitmap wrap
3. Important (crash/corruption/hang)? **PASS** — HIGH (underflow walk /
   bitmap corruption)
4. Small and contained? **PASS** — one file, ~9 lines
5. No new features/APIs? **PASS**
6. Can apply to the local tree? **PASS** — logic matches; minor extra
   hunk on `md_free_cloned_bio`

**Step 9.3: EXCEPTION CATEGORIES**

Record: Not an exception category. Ordinary important bug fix.

**Step 9.4: DECISION**

This tree already moved bitmap accounting into `md_clone_bio` and has
llbitmap. Empty WRITEs still call `start_write(sectors == 0)`, which
underflows llbitmap. The patch is the right, small fix and belongs on
6.18.y.

Verification:
- [Phase 1] Tags: Tested-by Mykola Marzhan; Link msgid
  20260802195038.164272-11 (v5 10/29); author Yu Kuai; no Fixes/Cc-
  stable
- [Phase 2] Diff: `md.c` only; skip empty start; gate end on `sectors`;
  init `sectors = 0`; require `bio_sectors` before start
- [Phase 2] Confirmed `llbitmap_start_write` uses `offset + sectors - 1`
  at md-llbitmap.c:1079
- [Phase 3] `git merge-base --is-ancestor cd5fc65338181 HEAD` → 0
  (upper-layer bitmap in tree)
- [Phase 3] llbitmap file present; intro `5ab829f1971dc` in history
- [Phase 3] Series 6–9 already on this branch (`73881ff7`, `d81822fd`,
  `930cc4f1`, `c55aa6c1`)
- [Phase 3] No `skip bitmap accounting` commit in local `git log --
  drivers/md/`
- [Phase 4] Cover letter: empty bitmap ranges as accounting
  prerequisite; v5 rebased so patch 10 does not need `prepare_range`
- [Phase 4] lore.kernel.org 403; recovered via gnuweeb + openwall + IU
- [Phase 4] No NAK in fetched cover/patch
- [Phase 5] Callers: raid0/1/5/10/linear `md_account_bio`; userspace
  block I/O
- [Phase 5] Legacy `bitmap_start_write` is `while (sectors)` — llbitmap
  is the underflow
- [Phase 6] `git describe HEAD` = p-6.18-1-g03b85e06ca9bf; `make
  kernelversion` = 6.18.53
- [Phase 6] Current `md_bitmap_start` has no empty return;
  `md_clone_bio` has no `bio_sectors` guard
- [Phase 6] Backport: add same `sectors` check to `md_free_cloned_bio`
  (raid5 reshape abort)
- [Phase 8] Failure: unsigned wrap → huge llbitmap walk; severity HIGH
- UNVERIFIED: live mkfs.ext4 reproduction; `b4 dig` match by commit SHA

**YES**

 drivers/md/md.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03d328506b285..ce3bd127e3bb3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9266,6 +9266,8 @@ static void md_bitmap_start(struct mddev *mddev,
 		mddev->pers->bitmap_sector(mddev, &md_io_clone->offset,
 					   &md_io_clone->sectors);
 
+	if (!md_io_clone->sectors)
+		return;
 	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
 }
 
@@ -9284,7 +9286,8 @@ static void md_end_clone_io(struct bio *bio)
 	struct bio *orig_bio = md_io_clone->orig_bio;
 	struct mddev *mddev = md_io_clone->mddev;
 
-	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
+	if (bio_data_dir(orig_bio) == WRITE && md_io_clone->sectors &&
+	    md_bitmap_enabled(mddev, false))
 		md_bitmap_end(mddev, md_io_clone);
 
 	if (bio->bi_status && !orig_bio->bi_status)
@@ -9308,12 +9311,14 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	md_io_clone = container_of(clone, struct md_io_clone, bio_clone);
 	md_io_clone->orig_bio = *bio;
 	md_io_clone->mddev = mddev;
+	md_io_clone->sectors = 0;
 	if (blk_queue_io_stat(bdev->bd_disk->queue))
 		md_io_clone->start_time = bio_start_io_acct(*bio);
 	else
 		md_io_clone->start_time = 0;
 
-	if (bio_data_dir(*bio) == WRITE && md_bitmap_enabled(mddev, false)) {
+	if (bio_data_dir(*bio) == WRITE && bio_sectors(*bio) &&
+	    md_bitmap_enabled(mddev, false)) {
 		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
 		md_io_clone->sectors = bio_sectors(*bio);
 		md_io_clone->rw = op_stat_group(bio_op(*bio));
-- 
2.53.0

