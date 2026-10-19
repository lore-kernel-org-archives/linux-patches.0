Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9231549FC4;
	Mon, 19 Oct 2026 13:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418209; cv=none; b=D/jbhxi3iYweMHKHXNbtkEc3MaXXNnV5pJcMmiOnPSyUJX0CWFMkN9qsA0PJDKlQhHnU9s1CRo4CEUOtHgaoEyEaWn1AXuwjNdzGAmxeDRXwQFv0EGXuMsDja/gcLgI9TlrMfkvKU1knvebaBGlkT7NonQf06InXHF3f7Ny5Q4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418209; c=relaxed/simple;
	bh=LoGHjCg9Sdcxom0ypPmWIaigurbig5u9/msoRi9pe9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ar5PNBgxhMQa1CNJ02DoiJPdnXlv5W/dox1+7ccNa6qHoHiHkXd9CHXCtIcm3OfU6dNffayr/+K0BXzgb8lgQ9ZeWH1A/uQlkt42fr1Q+s9WbpE0XB1kJmIv3P0DdbzsKyLSGhU7CgbyEZEPg7Eh64i6qSkDDytdb5x14AJEHFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JsCneYY1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JsCneYY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17B11F000C6;
	Mon, 19 Oct 2026 13:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418206;
	bh=uG5gA47gOYSyqqgUu8gf686568I17wT33QCswzzSEF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JsCneYY1MgmhpCzfm5O6CLs+yIAv4q2PBtazRARbHJ9HgADn+ghuia+eMWDfdhWml
	 Ku5WaPzOfXwTUtPvHtp1MSW9IvDyHt3gKfBvUXMeTOGhUHyaR9qD9ms+JL7R0xYqKw
	 b6Db/cAj0tNvnop5pvodQFE3EDBc1AJi4u6oM2RhXVH3JD0PiTQ6pVvjnGQOlLQ8xR
	 CQWJlX5pcVB/EQC43PvQwfJGUzH15fUPm1gcBgvgqG39y1sJ3pUZORd0dqBxRSbckk
	 oQXlat4+gOjHOLa60WRMJ8GkD8/oDy5b463bQljwUy8e2DMqpj1Ut2peKXjxYJ963t
	 K9xjUwk0I6cVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yunye Zhao <yunye.zhao@linux.alibaba.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] md: add cond_resched() to md_do_sync()'s skip path
Date: Mon, 19 Oct 2026 09:46:19 -0400
Message-ID: <20261019135441.1420968-88-sashal@kernel.org>
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

From: Yunye Zhao <yunye.zhao@linux.alibaba.com>

[ Upstream commit 162eb5ba791f6260fdaabae75fa2df20134f67d8 ]

When sync_request() reports a skipped region (*skipped == 1),
md_do_sync()'s main loop advances the cursor and takes an early
continue:

	j += sectors;
	...
	if (last_check + window > io_sectors || j == max_sectors)
		continue;

If the personality returns a small span per call (raid10 recovery
returns only 128 sectors), syncing a large, mostly clean array iterates
this branch an enormous number of times without ever yielding the CPU.
On a non-preemptive kernel the resync thread then trips the soft-lockup
watchdog:

  watchdog: BUG: soft lockup - CPU#149 stuck for 313s! [mdX_resync]
   md_bitmap_start_sync+0x6f/0xe0
   raid10_sync_request+0x2c9/0x1530 [raid10]
   md_do_sync+0x810/0x1030
   md_thread+0xa7/0x150

Add a cond_resched().  This does not reduce the wasted iterations; the
excessive iteration count is a raid10 problem addressed separately.

Signed-off-by: Yunye Zhao <yunye.zhao@linux.alibaba.com>
Link: https://patch.msgid.link/20260723135535.101995-3-yunye.zhao@linux.alibaba.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The checked-out tree is **6.18.53** (`pending-6.18`). The skip path in
`md_do_sync()` is present, has no yield, and matches this patch. That is
a real soft-lockup fix.

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
- Record: `[md] [add] add cond_resched() to md_do_sync()'s skip path`
- Subsystem: MD RAID core. Verb “add” here is a yield on an existing
  loop, not a feature.

**Step 1.2 — Tags**
- Record:
  - `Signed-off-by: Yunye Zhao <yunye.zhao@linux.alibaba.com>` (author)
  - `Link: https://patch.msgid.link/20260723135535.101995-3-
    yunye.zhao@linux.alibaba.com`
  - `Signed-off-by: Yu Kuai <yukuai@fygo.io>` (md maintainer; applied)
  - No `Fixes:` / `Reported-by:` / `Tested-by:` in the committed text
  - Original v2 submission **did** include `Cc: stable@vger.kernel.org`;
    Yu Kuai dropped it when applying (“Remove the cc stable as there is
    no fixtag”). That is process, not a technical NAK.
  - Pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit …]`
    ignored as instructed.

**Step 1.3 — Body**
- Record:
  - **Bug:** when `sync_request()` returns `*skipped == 1` with a small
    span (RAID10 recovery: 128 sectors), `md_do_sync()` takes `continue`
    and never reaches the existing `cond_resched()`.
  - **Symptom:** `watchdog: BUG: soft lockup - CPU#149 stuck for 313s!
    [mdX_resync]` with `md_bitmap_start_sync` → `raid10_sync_request` →
    `md_do_sync` → `md_thread`.
  - **Trigger:** large, mostly-clean RAID10 recovery (author:
    2^40-sector device → ~2^33 iterations).
  - **Root cause of CPU burn:** RAID10 recovery discards the bitmap’s
    large clean span and returns 128; that is patch 3/3. This commit
    only yields.
  - Author tested on 6.6.102 and mainline.

**Step 1.4 — Hidden bug fix?**
- Record: Not hidden. Explicit soft-lockup fix. Series cover letter
  calls it a “safety net, any personality/layout.”

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- Record: `drivers/md/md.c` only; ~3 insertions / 1 deletion in
  `md_do_sync()`. Surgical, single-function.

**Step 2.2 — Flow**
- Record: **Before:** skip/early-continue path never yields. **After:**
  `cond_resched()` then `continue`. Normal I/O path still uses the later
  `cond_resched()` at the speed-limit check.

**Step 2.3 — Bug mechanism**
- Record: **Hang / soft-lockup** (non-preemptive). Skip path bypasses
  the yield that already exists later in the same loop.

Verified in this tree:

```9751:9753:drivers/md/md.c
                if (last_check + window > io_sectors || j ==
max_sectors)
                        continue;
```

```9779:9779:drivers/md/md.c
                cond_resched();
```

Skip `continue` never reaches line 9779. `window` is `32 * (PAGE_SIZE /
512)` (256 sectors). If `skipped`, `io_sectors` does not increase, so
`last_check + window > io_sectors` stays true.

RAID10 recovery still does `max_sync = RESYNC_PAGES << (PAGE_SHIFT-9)`
(128 sectors). On a clean bitmap, `biolist == NULL` → `giveup` clamps to
`max_sync` and, because `max_sector` is a parameter (not reset at
`skipped:`), the call returns 128 to `md_do_sync()`.

**Step 2.4 — Fix quality**
- Record: Obviously correct. Same primitive already used in this
  function. Process context (`md_thread`). No new API/locks. Regression
  risk very low. Might slightly slow tight skip loops; that is the goal.

## Phase 3: Git history

**Step 3.1 — Blame**
- Record: Skip `continue` dates to early MD (`57afd89f98a99` / 2.6 era).
  Long-standing. RAID10 128-sector recovery cap is equally old
  (`RESYNC_BLOCK_SIZE` 64KiB).

**Step 3.2 — Fixes: tag**
- Record: None. Not a regression from a single later commit; interaction
  of skip-continue and RAID10 recovery skip size.

**Step 3.3 — Related commits**
- Record: Patch 2/3 of “md/raid10: fix recovery corruption and soft
  lockup on large arrays”.
  - 1/3 `md/raid10: fix still_degraded being inverted` — **already in
    this tree** (`0efabe6229dc6`). Independent.
  - 3/3 `md/raid10: skip clean regions in bulk` — **not** in this tree.
    Independent; this yield still needed for far/offset layouts and
    other personalities.
- No `cond_resched` on this skip path in `HEAD`.

**Step 3.4 — Author**
- Record: Yunye Zhao (Alibaba). Applied by Yu Kuai (md maintainer).

**Step 3.5 — Dependencies**
- Record: Standalone. Uses existing `cond_resched()`. 6.18
  `md_do_sync()` already has `update:`, `MD_RESYNC_ACTIVE`, and 4-arg
  `sync_request()` — same context as the patch. Clean apply.

## Phase 4: Mailing list

**Step 4.1 — Discussion**
- Record: https://lore.kernel.org/linux-
  raid/20260723135535.101995-3-yunye.zhao@linux.alibaba.com/ (also
  openwall mirrors).
- v1: single `cond_resched` patch. Yu Kuai initially thought it was a
  dead loop.
- v2: 3 patches; this one retitled; v1 “io_sectors never increases”
  claim corrected.
- Yu Kuai on v1 follow-up: “This patch is still valuable, even a 5s
  lockup is not acceptable.”
- Applied to md-7.3. No NAK on the yield itself.

**Step 4.2 — Recipients**
- Record: Song Liu, Yu Kuai; Cc Li Nan, Xiao Ni, linux-raid, linux-
  kernel.

**Step 4.3 — Bug report**
- Record: Author stack trace; 2^40-sector array; ~8.6e9 iterations;
  313s. Cover letter: before patch 3, 37.2s 100% CPU on 8T-per-disk
  sparse recovery; `softlockup_panic=1`.

**Step 4.4 — Series**
- Record: 2/3 is the md-core safety net. Does not depend on 1/3 or 3/3.

**Step 4.5 — stable@**
- Record: No useful stable-list thread found (lore.kernel.org/stable
  403). Maintainer dropped `Cc: stable` only for missing `Fixes:`.

## Phase 5: Semantics

**Step 5.1 — Functions**
- Record: `md_do_sync()`.

**Step 5.2 — Callers**
- Record: Registered as the MD resync thread
  (`md_register_thread(md_do_sync, …)`). Kernel thread, not IRQ.
  Userspace triggers via array recovery/resync/check (`mdadm`).

**Step 5.3 — Callees**
- Record: `pers->sync_request()`, bitmap start/end, `cond_resched()`,
  speed-limit waits.

**Step 5.4 — Reachability**
- Record: Yes. Disk replace / rebuild / `--syncaction` on RAID10 with
  internal bitmap. Production path.

**Step 5.5 — Similar patterns**
- Record: Same file already yields on the I/O path. RAID1/5/10 use
  `cond_resched()` in other loops. Skip path was the hole.

## Phase 6: This tree (6.18.53)

**Step 6.1 — Buggy code present?**
- Record: **Yes.** `drivers/md/md.c` ~9752 skip `continue` with no
  yield. RAID10 `giveup` still advances by `max_sync` (128). `git
  describe HEAD`: `p-6.18-1-g03b85e06ca9bf`. `make kernelversion`:
  `6.18.53`.

**Step 6.2 — Backport difficulty**
- Record: **Clean apply.** Local hunk matches the submitted diff
  (`MD_RESYNC_ACTIVE`, `update:`).

**Step 6.3 — Already fixed?**
- Record: No. 1/3 is in tree; 2/3 and 3/3 are not. Older `71e8e4f288e74`
  (bitmap size vs array size) is a different lockup.

## Phase 7: Subsystem

**Step 7.1**
- Record: `drivers/md` — **IMPORTANT** (enterprise RAID, dm-raid). Not
  staging.

**Step 7.2**
- Record: Active; recent RAID10/md fixes on this branch.

## Phase 8: Impact and risk

**Step 8.1 — Who**
- Record: MD/RAID users, especially RAID10 recovery of large mostly-
  clean arrays. Distro/enterprise kernels often `PREEMPT_NONE` /
  `PREEMPT_VOLUNTARY`.

**Step 8.2 — Trigger**
- Record: Recovery/resync of a large sparse array. Not unprivileged
  syscall; rebuild is a privileged/admin path. Common after disk
  replace. Timing-independent tight loop.

**Step 8.3 — Failure mode**
- Record: Soft lockup (313s in the report). With `softlockup_panic=1`,
  panic. **CRITICAL**.

**Step 8.4 — Risk vs benefit**
- Record: Benefit high (stops watchdog/panic). Risk very low (3 lines,
  existing helper). Ratio strongly in favor. Remaining CPU spin is patch
  3; this still prevents the BUG.

## Phase 9: Synthesis

**For backporting**
- Real, reproduced soft lockup with stack trace.
- Hole is in this tree; patch matches.
- Tiny, obviously correct; maintainer applied it and called it valuable.
- Independent of 3/3; still needed after 1/3.
- Classic stable pattern: `cond_resched()` to stop a lockup.

**Against**
- Does not cut the 128-sector crawl (author is explicit).
- No `Fixes:` (maintainer dropped `Cc: stable` for that).
- Pre-existing `md_new_event()` spam on `last_check == 0` (not
  introduced here).

**Unresolved:** none that change the verdict. Could not fetch
lore.kernel.org/stable (403); discussion from the patch mbox is enough.

**Stable rules**
1. Obviously correct and tested — **PASS** (mainline + QEMU tests;
   maintainer applied).
2. Real user-visible bug — **PASS** (soft lockup on RAID10 recovery).
3. Important (crash/hang) — **PASS** (soft lockup / possible panic).
4. Small and contained — **PASS** (~3 lines, one function).
5. No new features/APIs — **PASS**.
6. Applies to this tree — **PASS** (clean).

**Exception category:** none required; it is a hang fix.

This matters on 6.18 because RAID rebuild of large arrays is normal
operations, and a 5–313s lockup (or panic) is exactly what stable is
for. The yield is the same one the I/O path already uses.

## Verification
- [Phase 1] Tags: author SOB, Yu Kuai SOB, msgid link; v2 had `Cc:
  stable`, dropped on apply for missing Fixes.
- [Phase 2] Diff: 3 lines in `md_do_sync()` skip `continue`; 6.18 code
  at 9752–9753 / 9779 matches.
- [Phase 2] RAID10: `max_sync = RESYNC_PAGES << (PAGE_SHIFT-9)` = 128;
  `biolist == NULL` → `giveup`.
- [Phase 3] `git describe HEAD` / `make kernelversion`: 6.18.53, branch
  `pending-6.18`.
- [Phase 3] 1/3 already ancestor (`0efabe6229dc6`); this commit is not
  in HEAD.
- [Phase 4] `b4 mbox` 21-message thread; Yu Kuai: yield still valuable;
  applied to md-7.3.
- [Phase 5] Caller: `md_register_thread(md_do_sync)` resync thread.
- [Phase 6] Skip path present; context matches; expected clean apply.
- [Phase 8] Failure: soft lockup 313s; severity CRITICAL.
- UNVERIFIED: lore.kernel.org/stable search (HTTP 403). Does not change
  the verdict.

**YES**

 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ce3bd127e3bb3..44f44219ed7fe 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9751,8 +9751,10 @@ void md_do_sync(struct md_thread *thread)
 			 */
 			md_new_event();
 
-		if (last_check + window > io_sectors || j == max_sectors)
+		if (last_check + window > io_sectors || j == max_sectors) {
+			cond_resched();
 			continue;
+		}
 
 		last_check = io_sectors;
 	repeat:
-- 
2.53.0

