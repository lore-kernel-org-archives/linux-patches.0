Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7E25D8C9E;
	Mon, 19 Oct 2026 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418537; cv=none; b=DF0JhsAVkhf+l9tvzGidpank1VFOvDFzhe3kFP/Vby2Ie0zU8D2i5r/Qcj+JfAY92aYXfkTNpFxjiYbWJpdAboB1TBPpg10kprYoFhCWYj4ogwFKncltclqdsuo2qBVAqacAF4VAZgYuqlsyBDQ13av+OzyOZYpd7AfWmk0MLKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418537; c=relaxed/simple;
	bh=KRjUi9m61hUJXhNp30prZZoG7F0ZzDqJJcR4H4iHVbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uIGxncjr1co1JkjMk80Ccakyq139bBQ8Xs/wfrWBtQdGP9+GLQYEeBPZPrfblrbUd6C5yjQ8hoCyrUu5qnCjP9xHwHsVEtrCwrNMzDCcrBSGYdobjUzTKNGAUz85UrDQfUwrwqCAdn7TMwVGwj3ndGjBBlFHkypr8ZOOa1RvkYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBwVAnRo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBwVAnRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2121F000CA;
	Mon, 19 Oct 2026 14:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418533;
	bh=VEX4lCPK+/AocbyN8CKqcWs4cMNwySrK0OZC2wVRcIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UBwVAnRonuuRqen00SLTzgAg2/Rfcq+nM4Gr7n4mUhzT7qv/Ds4QMR+K5uRYRpiBE
	 xdVk+7qhiQjhthTiZDmvve5MwAcHvZ6++QyWJpFeFG/nrnDXGTDEzg7YjQWfR9n+hb
	 V1U0g+2E205VThL2TvAiu9KkwYly+f+SP7tFgNrkfaxNL7NWjiwVyBs7Ar13kKs0LV
	 AkExVR0hsPAQl70CIUjcwPg/4zZ4Wv5TjKBCVA368BENHm3kxYf7b8ZuGca5nCZMuk
	 IuG2QynIaY8dmxnljwftaOmDWlXUS+Pm+D8eqjpcaQilkJHsXOKES3I5Gp4lVqh5Ho
	 AQTNvrpdsoXdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yu Kuai <yukuai@fygo.io>,
	Mykola Marzhan <mykola@meshstor.io>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] md/raid5: reject zero-sector reshape chunks
Date: Mon, 19 Oct 2026 09:50:06 -0400
Message-ID: <20261019135441.1420968-315-sashal@kernel.org>
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

[ Upstream commit a41bb2ee1aca486853e84920565e50c15f86fa5d ]

Sashiko reported that RAID5 can accept a reshape chunk size that becomes
zero sectors. chunk_size_store() stores the sysfs byte value as n >> 9, so
writing a value below 512 bytes sets mddev->new_chunk_sectors to zero.
RAID5 then accepted that pending reshape geometry and raid5_start_reshape()
installed it into conf->chunk_sectors, letting reshape code divide by zero.

Reject zero-sector chunks both in check_reshape(), where normal sysfs
requests are validated, and in raid5_start_reshape(), so assembly/resume
paths also cannot install zero chunk geometry.

Test script: in QEMU, create a plain three-disk RAID5 array with 64K
chunks, write/read back a small pattern, write 1 to
/sys/block/md0/md/chunk_size, add a fourth disk, and run mdadm --grow
--raid-devices=4 --backup-file=... . The script scans dmesg for divide
error/Oops/KASAN signatures.

Bad kernel, eb29914412c3:

  echo 1 > /sys/block/md0/md/chunk_size
  mdadm --grow /dev/md0 --raid-devices=4 --backup-file=/root/md0-grow.bak

  Oops: divide error: 0000 [#1] SMP KASAN NOPTI
  RIP: raid5_get_active_stripe+0x863/0xc10
  Call Trace:
   raid5_sync_request
   md_do_sync
   md_thread
  Kernel panic - not syncing: Fatal exception

Fixed kernel: echo 1 > /sys/block/md0/md/chunk_size bash: echo: write
error: Invalid argument chunk_write_rc=1 grow_rc=skipped RESULT:
REJECTED_ZERO_CHUNK_NO_OOPS

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Link: https://patch.msgid.link/20260802195038.164272-5-yukuai@kernel.org
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a **5-line RAID5 input-validation fix** for a divide-by-zero
panic during reshape. The local tree is **6.18.53** (`pending-6.18`);
the buggy path is present and the patch applies.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[md/raid5] [reject] reject zero-sector reshape chunks**

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Tested-by:** Mykola Marzhan `<mykola@meshstor.io>` (independent QEMU
  reproduction)
- **Link:**
  `https://patch.msgid.link/20260802195038.164272-5-yukuai@kernel.org`
  (v5 04/29)
- **Signed-off-by:** Yu Kuai `<yukuai@fygo.io>` (MD RAID co-maintainer)
- No **Fixes:**, **Reported-by:**, **Cc: stable**, **Reviewed-by**, or
  **Acked-by** on the committed message (absence of Fixes/Cc:stable is
  expected for this review)
- Body names **Sashiko** as the reporter (test harness, not syzbot)
- Bad-kernel SHA cited: `eb29914412c3`

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** `chunk_size_store()` does `n >> 9`. A sysfs write below 512
  bytes stores `mddev->new_chunk_sectors = 0`. RAID5 accepts that
  geometry; `raid5_start_reshape()` copies it into
  `conf->chunk_sectors`.
- **Symptom:** `Oops: divide error` in `raid5_get_active_stripe`, call
  chain `raid5_sync_request` → `md_do_sync` → `md_thread`, then **kernel
  panic**.
- **Trigger:** RAID5 array, `echo 1 > /sys/block/md0/md/chunk_size`,
  then `mdadm --grow --raid-devices=4`.
- **Fix:** return `-EINVAL` in `check_reshape()` and
  `raid5_start_reshape()` when `new_chunk_sectors` is zero.
- **Fixed result:** sysfs write returns `Invalid argument`; grow is
  skipped; no oops.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden. Explicit panic fix with a reproduction and a
before/after result.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/md/raid5.c` only (**+5 / −0**)
- **Functions:** `check_reshape()`, `raid5_start_reshape()`
- **Scope:** single-file surgical validation

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Hunk 1 (`check_reshape`):** after `has_failed()`, add `if
  (!mddev->new_chunk_sectors) return -EINVAL`. Sysfs/`mdadm` reshape
  checks that previously accepted 0 now fail. `chunk_size_store()` then
  restores `new_chunk_sectors` to the live chunk size.
- **Hunk 2 (`raid5_start_reshape`):** after `MD_RECOVERY_RUNNING` busy-
  check, same reject. Covers start-reshape, assembly, and resume so zero
  geometry cannot be installed into `conf->chunk_sectors`.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **[Logic / correctness + divide-by-zero]**
`raid5_check_reshape()` only validates chunk size when `new_chunk > 0`,
so **0 skips the power-of-two / PAGE_SIZE checks**. `check_reshape()`
then treats `0 != current chunk` as a real reshape.
`raid5_start_reshape()` does `conf->chunk_sectors =
mddev->new_chunk_sectors`. `stripe_set_idx()` / `raid5_compute_sector()`
then `sector_div(..., conf->chunk_sectors)` with divisor 0.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct. Two `-EINVAL` guards, no API/locking/data-
structure change. Regression risk is rejecting a reshape that previously
panics. Normal grow does not use chunk size 0: `setup_conf()` already
requires a non-zero chunk, and running arrays keep `new_chunk_sectors ==
chunk_sectors`.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Zero-chunk reject in **`setup_conf()`** since **Andre Noll, 2009**
  (`664e7c413f1e9`) — array *start* is safe.
- `raid5_check_reshape()` `if (new_chunk > 0)` hole since **Neil Brown,
  2009** (`b3546035277847`).
- `chunk_size_store()` `n >> 9` since **2009**.
- `conf->chunk_sectors = mddev->new_chunk_sectors` in
  `raid5_start_reshape()` since **2009** (`09c9e5fa1b93ad`).
- Bug is long-standing, not new 6.18 code.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Introducer is the 2009 `n >> 9` store plus the
`new_chunk > 0` skip, both in this tree.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- This tree **already has** series patch 05: `02c10581866d0 md/raid5:
  round bitmap stripes with sector division` (upstream `17ea021ae7498`).
- This commit (series 04, `a41bb2ee1aca4`) is **not** an ancestor of
  HEAD.
- Cover letter: first five patches are **standalone** RAID5/llbitmap
  correctness fixes. 04 does not depend on 05; 05 being present does not
  replace 04.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Yu Kuai is listed in MAINTAINERS as **SOFTWARE RAID** co-
maintainer with Song Liu. Frequent `drivers/md/raid5.c` contributor.
Weight: high.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: None. Adds two comparisons on existing
`mddev->new_chunk_sectors`. `git apply --check` of `a41bb2ee1aca4`
**succeeded** (hunks at 8445 and 8490, offset −103).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- **b4 dig -c a41bb2ee1aca4:** `[PATCH v5 04/29] md/raid5: reject zero-
  sector reshape chunks` —
  `https://patch.msgid.link/20260802195038.164272-5-yukuai@kernel.org`
- Series: **v5 of 29**, “md: improve lockless bitmap reshape support”
- This check was **added in v3** (“Add patch 4 to reject zero-sector
  RAID5 reshape chunks”); v4/v5 keep the same diff.
- Cover letter: *“The first five patches fix standalone llbitmap and
  RAID5 correctness issues that are independent of reshape.”*
- No NAK found on patchew/LKML/openwall mirrors. lore.kernel.org fetch
  returned **403**; discussion taken from b4, patchew, LKML IU, and
  openwall.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: **b4 dig -w** To/Cc: Song Liu, Li Nan, Xiao Ni, linux-raid,
linux-kernel, Mykola Marzhan, Su Yue. Subsystem maintainers were on the
original mail. No Reviewed-by on this specific commit; series v1 had
Reviewed-by from Su Yue on other patches.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: Reproduced in QEMU with an oops/panic log. **Tested-by** Mykola
Marzhan. Not syzbot. Trigger is crafted (write `1` then grow) but the
oops is real.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: 29-patch llbitmap reshape series. **This patch is standalone
(04/29).** Later patches add llbitmap reshape; they are not required for
this reject.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No stable@ thread found for this subject. UNVERIFIED beyond web
search (lore.kernel.org/stable also 403).

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `check_reshape()`, `raid5_start_reshape()`. Callers of the
first: `raid5_check_reshape()`, `raid6_check_reshape()` (raid4/5/6
`pers->check_reshape`).

Step 5.2: TRACE CALLERS
Record:
- `check_reshape` via sysfs: `chunk_size_store()`, `layout_store()`,
  `raid_disks_store` → `update_raid_disks()`, `action_store`
  (“reshape”), plus ioctl/`md_check_recovery`.
- `raid5_start_reshape`: `pers->start_reshape` from
  action/ioctl/assembly when a reshape starts or is resumed.
- Context: md thread / reconfig, not IRQ.

Step 5.3: TRACE CALLEES
Record: After the new checks, existing `check_stripe_cache()`,
`has_failed()`, `resize_chunks()`, and geometry install. The dangerous
callee is later `sector_div` on `conf->chunk_sectors`.

Step 5.4: FOLLOW THE CALL CHAIN
Record (verified in this tree):
1. `chunk_size_store()` (`drivers/md/md.c:4492`) `new_chunk_sectors = n
   >> 9` (write `1` → 0).
2. `raid5_check_reshape()` (`8793`) skips validation because `new_chunk
   > 0` is false (`8805`).
3. `check_reshape()` (`8436`) has **no** zero reject; `0 !=
   chunk_sectors` so it does not take the “nothing to do” return.
4. `mdadm --grow` → `raid5_start_reshape()` (`8533`)
   `conf->chunk_sectors = mddev->new_chunk_sectors` (**0**).
5. Reshape sync: `raid5_sync_request` → `raid5_get_active_stripe` →
   `init_stripe` → `stripe_set_idx` (`3576`) **`sector_div(stripe,
   sectors_per_chunk)` with 0** → divide error.

Userspace-reachable via sysfs + mdadm; `chunk_size` is `S_IWUSR` (root).

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: `setup_conf()` already rejects `!new_chunk_sectors` (`7524`).
Reshape is the missing twin of that start-time check. `new_chunk_sectors
= 0` elsewhere is array teardown (`md.c` reset), not a live RAID5
reshape sentinel.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes.** Tree is **v6.18.53 / pending-6.18** (`git describe`:
`p-6.18-1-g03b85e06ca9bf`). `a41bb2ee1aca4` is **not** an ancestor of
HEAD. Hole is at `check_reshape()` `8436` and `raid5_start_reshape()`
`8480`; store is `md.c:4492`.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply** (`git apply --check` exit 0, offset −103 only).
Insertion points match: after `has_failed()` and after
`MD_RECOVERY_RUNNING`.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No `zero-sector reshape` commit in this tree. Sibling 05 is
present; it does not reject zero chunks. `setup_conf()` zero check does
not cover reshape.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **md/raid5 (software RAID)** — **IMPORTANT**. RAID5 reshape is a
production path (grow/shrink/layout change).

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained (`raid5.c` still getting lock/bitmap/discard
fixes). This hole is old (2009), not a new-feature bug.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific:** RAID4/5/6 users who reshape (or resume a
reshape) after a sub-512 `chunk_size` sysfs write, or with a superblock
`new_chunk` that becomes 0.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Not every boot. Needs a running RAID5/6, privileged sysfs write
`< 512` to `chunk_size`, then reshape (or resume with zero new-chunk in
metadata). Unprivileged users normally cannot write that sysfs file.
Still a real panic for admins, scripts, and test/fuzz tools.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: **Kernel oops + panic (divide-by-zero).** **CRITICAL.**

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record: **Benefit: high** (stops a proven panic). **Risk: very low** (5
lines, error-path `-EINVAL` only). Ratio strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

**FOR:**
- Proven divide-by-zero panic with call trace and QEMU repro.
- Same hole exists in this 6.18.53 tree (`n >> 9`, `if (new_chunk > 0)`
  skip, unconditional install in `raid5_start_reshape`).
- 5-line, obviously correct guards; apply-check clean.
- Standalone per author cover letter; no new APIs.
- MD co-maintainer author; Tested-by from a third party.
- `setup_conf()` already rejects 0; reshape was the gap.

**AGAINST:**
- Privileged, somewhat artificial trigger (`echo 1` then grow).
- Nested in a 29-patch series (mitigated: explicitly standalone).
- No Fixes:/Cc:stable (expected here; not a negative).

**UNRESOLVED:**
- Full lore.kernel.org HTML was 403; used b4 + mirrors.
- No stable@ discussion found.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — two guards; Tested-by;
   before/after log.
2. Fixes a real bug that affects users? **PASS** — oops/panic on RAID5
   reshape.
3. Important issue? **PASS** — **CRITICAL** kernel panic.
4. Small and contained? **PASS** — +5 lines, one file.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — apply-check succeeded; bug
   present.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not an ID/quirk/DT/docs exception. It is a normal stability fix.

Step 9.4: MAKE YOUR DECISION
Backport to this 6.18.53 tree. It closes a long-standing validation hole
that panics the kernel, with negligible regression risk.

===============================================================
What the commit solves for this tree
===============================================================

On 6.18.53, writing a sub-512 value to `/sys/block/mdX/md/chunk_size`
stores zero sectors. RAID5 reshape validation treats 0 as “no chunk
change” in `raid5_check_reshape()`, then accepts it in
`check_reshape()`, and `raid5_start_reshape()` installs 0 into
`conf->chunk_sectors`. Reshape then divides by zero in
`stripe_set_idx()` / `raid5_compute_sector()` and panics.

The patch rejects that geometry at the two points that can install it.
That matches `setup_conf()`’s existing start-time check and does not
change normal `mdadm --grow` (which keeps the current non-zero chunk).

Risk vs benefit: five lines of `-EINVAL` versus a documented panic.
Apply is clean. Series membership is not a blocker; the cover letter
calls this patch standalone, and this tree already took the following
patch (05) without this one.

===============================================================
Verification
===============================================================

- **[Phase 1]** Parsed tags: Tested-by Mykola Marzhan; Link msgid
  `20260802195038.164272-5`; SoB Yu Kuai; no Fixes/Cc:stable.
  Subject/body describe divide-by-zero panic.
- **[Phase 2]** Diff: +5 in `check_reshape` and `raid5_start_reshape`
  only. Confirmed `raid5_start_reshape` assigns `conf->chunk_sectors =
  mddev->new_chunk_sectors` at `raid5.c:8533`.
- **[Phase 3]** `git merge-base --is-ancestor a41bb2ee1aca4 HEAD` → not
  in tree (exit 1). Blame: `n >> 9` and `new_chunk > 0` from 2009.
  Author is MD co-maintainer (`MAINTAINERS` SOFTWARE RAID).
- **[Phase 3]** `git apply --check` of `a41bb2ee1aca4` → success, offset
  −103.
- **[Phase 3]** Sibling 05 `02c10581866d0` is already in HEAD; 04 is
  not. Cover letter: first five patches standalone.
- **[Phase 4]** `b4 dig -c a41bb2ee1aca4` → v5 04/29, msgid.link above.
  `b4 dig -w` → Song Liu, linux-raid, testers. Patch added in v3; v5
  matches committed diff. lore.kernel.org WebFetch 403.
- **[Phase 4]** patchew/LKML/openwall: same patch text; Mykola Tested-by
  on the series; no NAK found.
- **[Phase 5]** Call path verified in this tree: `chunk_size_store`
  (`md.c:4492`) → `raid5_check_reshape` (`if (new_chunk > 0)` at 8805) →
  `check_reshape` (no zero check) → `raid5_start_reshape` install →
  `stripe_set_idx` `sector_div` at 3576. `setup_conf` already rejects 0
  at 7524.
- **[Phase 6]** `git describe HEAD` = `p-6.18-1-g03b85e06ca9bf`; `make
  kernelversion` = **6.18.53**; branch `pending-6.18`. Buggy code
  present; no existing zero-sector reshape fix.
- **[Phase 7]** md/raid5, IMPORTANT, actively maintained.
- **[Phase 8]** Failure mode: divide error oops + panic. Severity
  CRITICAL. Trigger: privileged sysfs + reshape. Benefit high, risk very
  low.
- **UNVERIFIED:** Full lore.kernel.org thread HTML (HTTP 403); no
  stable@ hit beyond web search.

**YES**

 drivers/md/raid5.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b7da2b83e1938..56d7e05e94ce6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8437,6 +8437,8 @@ static int check_reshape(struct mddev *mddev)
 		return 0; /* nothing to do */
 	if (has_failed(conf))
 		return -EINVAL;
+	if (!mddev->new_chunk_sectors)
+		return -EINVAL;
 	if (mddev->delta_disks < 0 && mddev->reshape_position == MaxSector) {
 		/* We might be able to shrink, but the devices must
 		 * be made bigger first.
@@ -8480,6 +8482,9 @@ static int raid5_start_reshape(struct mddev *mddev)
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 
+	if (!mddev->new_chunk_sectors)
+		return -EINVAL;
+
 	if (!check_stripe_cache(mddev))
 		return -ENOSPC;
 
-- 
2.53.0

