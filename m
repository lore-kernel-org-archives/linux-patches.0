Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3123DC4B4;
	Mon, 20 Apr 2026 13:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691458; cv=none; b=u8Q0cq7xGVMTsjZKknt/6DUlamk2L89j8G/9GKGmowv33JgNA4iuavtciXpMIMCCITB9zAb6nDwDrH7xyPKbVHsTnZNVaKcQbdBkF0WPQ9SJG+UGYMAH6rlHoO9eMg32tZ2d7rRZ/44reh5z4VYP6Mjg2ADpEUQ1a29GoKMO1CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691458; c=relaxed/simple;
	bh=qVbr9smmygCPDrQROEOKn16A+o0LYOpDI1j92VAZsog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f03Ka5HhGnMrvFYgeamLZF+ULsiWc5IEWAv7bWtKVXWHGoLmfOadxJGp3unHKrhodQGiImOOuTJBvM1YzIqy0BbJudKRe51H4hodXQm9Yh31U1hWlF5msETe2sn3rKd3ABslzd9BUdBq3IQV25ewHpJIv5pGmzG2bgkcL0GuL/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VMrPuvG9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VMrPuvG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0750C2BCC6;
	Mon, 20 Apr 2026 13:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691458;
	bh=qVbr9smmygCPDrQROEOKn16A+o0LYOpDI1j92VAZsog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMrPuvG9y2VmHasLUGKbizideagK5G/sLw1uE9ZXcd7bCuXEhmkxyzYuXQzLhkyx7
	 Z67S7kWSGRHDNgR1IgjU+g9pJGqDtCG+PXwXs4xQLqusMYbrVivlTinpKNhVLukziC
	 PbecfVGAG9QJ1LGIWV9EhyGTBOIize0Ye/ctaCUPale9DtSjVb8Z+lT0nCVu6xm4rU
	 tn/8mhhYAaPQtZYcYDITIvQE7hlAg1in7qMySp5XF95RbLkeOyLMcpiD/cP1bpcV2U
	 k68f1oAYuXDHcqXVRPrw9pUQCVl4CRWvPbJXFjJg/ldt6mwuT5P7IvUcpLDkNFmKY1
	 A+Xuts6jw8H7w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gregory Price <gourry@gourry.net>,
	syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] md/raid0: use kvzalloc/kvfree for strip_zone and devlist allocations
Date: Mon, 20 Apr 2026 09:17:14 -0400
Message-ID: <20260420132314.1023554-40-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
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

From: Gregory Price <gourry@gourry.net>

[ Upstream commit 078d1d8e688d75419abfedcae47eab8e42b991bb ]

syzbot reported a WARNING at mm/page_alloc.c:__alloc_frozen_pages_noprof()
triggered by create_strip_zones() in the RAID0 driver.

When raid_disks is large, the allocation size exceeds MAX_PAGE_ORDER (4MB
on x86), causing WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER).

Convert the strip_zone and devlist allocations from kzalloc/kzalloc_objs to
kvzalloc/kvzalloc_objs, which first attempts a contiguous allocation with
__GFP_NOWARN and then falls back to vmalloc for large sizes. Convert the
corresponding kfree calls to kvfree.

Both arrays are pure metadata lookup tables (arrays of pointers and zone
descriptors) accessed only via indexing, so they do not require physically
contiguous memory.

Reported-by: syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69adaba8.a00a0220.b130.0005.GAE@google.com/
Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Link: https://lore.kernel.org/linux-raid/20260308234202.3118119-1-gourry@gourry.net/
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the same bug also triggers on linux-5.15.y stable kernel.
Now I have comprehensive information for my analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
- **Subsystem prefix:** `md/raid0`
- **Action verb:** "use" (converting allocation API calls)
- **One-line summary:** Convert strip_zone and devlist allocations from
  kzalloc to kvzalloc to avoid WARNING when allocation exceeds
  MAX_PAGE_ORDER.
Record: [md/raid0] [use/convert] [Switch large allocations to kvzalloc
to avoid WARNING on large arrays]

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Reported-by:** syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com
  — syzbot fuzzer report, strong signal
- **Closes:** https://lore.kernel.org/all/69adaba8.a00a0220.b130.0005.GA
  E@google.com/ — syzbot bug report
- **Signed-off-by:** Gregory Price <gourry@gourry.net> — patch author
- **Reviewed-by:** Yu Kuai <yukuai@fnnas.com> — MD subsystem maintainer
- **Reviewed-by:** Li Nan <linan122@huawei.com> — MD subsystem developer
- **Link:** https://lore.kernel.org/linux-
  raid/20260308234202.3118119-1-gourry@gourry.net/
- **Signed-off-by:** Yu Kuai <yukuai@fnnas.com> — committer/maintainer
Record: Syzbot report, two Reviewed-by from MD maintainers, no Fixes:
tag (expected)

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit explains that when `raid_disks` is large, the allocation size
for `strip_zone` and `devlist` arrays exceeds `MAX_PAGE_ORDER` (4MB on
x86), triggering `WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER)`. The fix
converts to `kvzalloc`/`kvfree` which first tries contiguous allocation
with `__GFP_NOWARN` and then falls back to vmalloc. The author
explicitly notes these are "pure metadata lookup tables" accessed only
via indexing, so physically contiguous memory is not required.
Record: [Bug: WARNING triggered in page allocator when RAID0 array has
many disks] [Symptom: kernel WARNING at mm/page_alloc.c] [No specific
version info; bug present since original code in 2005] [Root cause:
kzalloc for variable-size arrays that can exceed MAX_PAGE_ORDER]

### Step 1.4: DETECT HIDDEN BUG FIXES
This is a clear fix for a syzbot-reported WARNING. Not disguised at all.
Record: [Not a hidden bug fix — explicitly described as fixing a
WARNING]

---

## PHASE 2: DIFF ANALYSIS — LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
- **File:** `drivers/md/raid0.c` — 9 lines changed (9 added, 9 removed)
- **Functions modified:**
  - `create_strip_zones()` — allocation site + error cleanup path
  - `raid0_free()` — normal cleanup path
- **Scope:** Single-file surgical fix. Minimal.
Record: [drivers/md/raid0.c: +9/-9] [create_strip_zones, raid0_free]
[Single-file surgical fix]

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Hunk 1 (create_strip_zones allocation):**
- Before: `kzalloc_objs()` and `kzalloc()` for strip_zone and devlist
- After: `kvzalloc_objs()` and `kvzalloc()` — same semantics but with
  vmalloc fallback

**Hunk 2 (abort label cleanup):**
- Before: `kfree(conf->strip_zone); kfree(conf->devlist);`
- After: `kvfree(conf->strip_zone); kvfree(conf->devlist);`

**Hunk 3 (raid0_free):**
- Before: `kfree(conf->strip_zone); kfree(conf->devlist);`
- After: `kvfree(conf->strip_zone); kvfree(conf->devlist);`

Record: [All three hunks: kzalloc->kvzalloc and kfree->kvfree, perfectly
paired]

### Step 2.3: IDENTIFY THE BUG MECHANISM
Category: **Logic/correctness fix** — Using physically-contiguous
allocation for data that doesn't need it, causing allocation
failures/warnings when size is large.

The code allocates `sizeof(struct strip_zone) * nr_strip_zones` and
`sizeof(struct md_rdev *) * nr_strip_zones * raid_disks`. When
`raid_disks` is large, this exceeds MAX_PAGE_ORDER (4MB), causing a
WARN_ON_ONCE.

The fix is the standard Linux kernel pattern: use `kvzalloc` (which
falls back to vmalloc) for allocations that don't require physical
contiguity.

Record: [Logic/allocation bug] [kzalloc can't handle large allocations >
MAX_PAGE_ORDER; kvzalloc falls back to vmalloc]

### Step 2.4: ASSESS THE FIX QUALITY
- **Obviously correct?** Yes. `kzalloc`→`kvzalloc` and `kfree`→`kvfree`
  is an extremely common, well-understood pattern in the kernel.
- **Minimal?** Yes, only 9 lines changed (purely API substitution).
- **Regression risk?** Extremely low. `kvfree` correctly handles both
  kmalloc and vmalloc memory. The arrays are metadata lookup tables
  accessed via indexing — no DMA or physical contiguity requirement.
Record: [Excellent fix quality, minimal, obviously correct, no
regression risk]

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
- `conf->strip_zone` allocation: dates back to `1da177e4c3f41` (Linux
  2.6.12, 2005) with wrapping by `kzalloc_objs` in 2026 (32a92f8c89326)
  and earlier by `kcalloc` in 2018 (6396bb221514d2). Original code from
  Linus's initial git commit.
- `conf->devlist` allocation: same — dates to `1da177e4c3f41` (2005).
- The kfree calls were refactored in `ed7b00380d957e` (2009) and
  `d11854ed05635` (2024) but the fundamental issue (kzalloc for
  variable-size metadata) has existed since 2005.
Record: [Buggy code introduced in original Linux 2.6.12 (2005)] [Present
in ALL stable trees]

### Step 3.2: FOLLOW THE FIXES: TAG
No Fixes: tag present (expected for autosel candidates).
Record: [No Fixes: tag — N/A]

### Step 3.3: CHECK FILE HISTORY
Recent `drivers/md/raid0.c` changes are mostly unrelated (alloc_obj
refactoring, mddev flags, dm-raid NULL fix, queue limits). The patch is
standalone.
Record: [No prerequisites identified] [Standalone fix]

### Step 3.4: CHECK THE AUTHOR
Gregory Price is primarily a CXL/mm developer, not the md subsystem
maintainer. But the fix was reviewed and committed by Yu Kuai, who IS
the MD subsystem maintainer.
Record: [Authored by Gregory Price (CXL/mm), reviewed and committed by
Yu Kuai (MD maintainer)]

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
The key dependency concern: the mainline patch uses `kzalloc_objs` →
`kvzalloc_objs`, but `kzalloc_objs`/`kvzalloc_objs` macros only exist in
v7.0 (introduced by commit `2932ba8d9c99` in v7.0-rc1). In older stable
trees (6.12, 6.6, 6.1, 5.15), the code uses `kcalloc`/`kzalloc`, so the
backport would need trivial adaptation: `kcalloc` → `kvcalloc` (or
`kvzalloc` with size calculation), not `kzalloc_objs` → `kvzalloc_objs`.
This is a trivial adaptation. For this specific tree (7.0),
`kvzalloc_objs` is available and the patch applies cleanly.
Record: [For 7.0: applies cleanly. For older stable: needs trivial
adaptation of the alloc macro]

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
From spinics.net mirror:
- The patch was submitted on 2026-03-08 as a single patch (not a
  series).
- Yu Kuai reviewed it on 2026-03-20 with `Reviewed-by`.
- Li Nan reviewed it on 2026-03-21 with `Reviewed-by` and "LGTM".
- Yu Kuai applied it to md-7.1 on 2026-04-07, adding the `Closes:` tag.
- No objections, NAKs, or concerns raised.
Record: [Single patch, two reviewers, both approved, applied by
maintainer]

### Step 4.2: CHECK WHO REVIEWED
- Yu Kuai — MD subsystem maintainer (also the committer)
- Li Nan — MD subsystem developer at Huawei
Both are key people for the MD subsystem. Thorough review.
Record: [Key MD maintainers reviewed the patch]

### Step 4.3: SEARCH FOR THE BUG REPORT
The syzbot report confirms:
- **Upstream bug:** Reported 2026-03-08, fix commit `078d1d8e688d`
  identified, patched on some CI instances.
- **5.15 stable bug:** Same WARNING also triggered on linux-5.15.y
  (commit `91d48252ad4b`), confirming the bug affects old stable trees.
- Crash trace shows: `WARN_ON_ONCE` at
  `__alloc_frozen_pages_noprof+0x23ea/0x2ba0`, triggered through
  `create_strip_zones → raid0_run → md_run → do_md_run → md_ioctl →
  blkdev_ioctl → vfs_ioctl → __x64_sys_ioctl`.
Record: [Syzbot reproduced on both upstream and linux-5.15.y] [Triggered
via ioctl syscall]

### Step 4.4/4.5: CHECK FOR RELATED PATCHES AND STABLE DISCUSSION
Single standalone patch. No series. No prior stable discussion found.
Record: [Standalone fix, no series context]

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS
- `create_strip_zones()` — allocates RAID0 metadata
- `raid0_free()` — frees RAID0 metadata

### Step 5.2: TRACE CALLERS
- `create_strip_zones()` is called from `raid0_run()` → called from
  `md_run()` → called from `do_md_run()` → called from `md_ioctl()` →
  reachable from userspace via `ioctl()`.
- `raid0_free()` is called during RAID0 teardown.
Record: [Reachable from userspace via ioctl syscall — confirmed by
syzbot stack trace]

### Step 5.3-5.5: CALLEES AND SIMILAR PATTERNS
The fix is purely about allocation strategy. No complex call chain
analysis needed.
Record: [Simple allocation API change, no complex callee analysis
needed]

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
Yes — the buggy `kzalloc`/`kcalloc` calls for strip_zone and devlist
have existed since Linux 2.6.12 (2005). Confirmed in v5.15 and v6.12.
Syzbot also reproduced the same WARNING on linux-5.15.y.
Record: [Bug exists in ALL active stable trees]

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
- For **7.0 stable**: The patch should apply cleanly since
  `kzalloc_objs`/`kvzalloc_objs` macros exist.
- For **older stable trees** (6.12, 6.6, 6.1, 5.15): Needs trivial
  adaptation (use `kvcalloc` instead of `kvzalloc_objs`; or `kvzalloc`
  with manual size calculation instead of the macro).
Record: [7.0: clean apply. Older: needs trivial adaptation of alloc
macro]

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY IN STABLE
No. The syzbot report for 5.15 is still marked as unfixed.
Record: [No existing fix in any stable tree]

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM
- **Subsystem:** `drivers/md` — MD (Multiple Devices) RAID subsystem
- **Criticality:** IMPORTANT — RAID0 is a widely-used storage
  configuration. Many production systems use MD RAID.
Record: [md/raid0] [Criticality: IMPORTANT — widely used storage
subsystem]

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Active subsystem with regular commits from Yu Kuai and others.
Record: [Actively maintained subsystem]

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
Any user creating a RAID0 array with a large number of disks (where
`nr_strip_zones * raid_disks` allocation exceeds 4MB). This is plausible
in production environments with many disks.
Record: [Affected: RAID0 users with large disk counts]

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
- **Trigger:** Creating a RAID0 array (via `md_ioctl`) with enough disks
  that the metadata allocation exceeds MAX_PAGE_ORDER.
- **How common?** Syzbot triggered it, meaning it's reachable from
  unprivileged-ish ioctl. In production, requires many disks.
- **Unprivileged user?** The ioctl path is reachable from userspace
  (requires device access, typically root for md devices).
Record: [Triggered via ioctl with large raid_disks, reachable from
userspace]

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
- **Primary symptom:** kernel WARNING (WARN_ON_ONCE) in page allocator —
  this taints the kernel and may trigger panic in some configurations
  (`panic_on_warn`).
- **Secondary consequence:** The allocation fails with -ENOMEM even
  though vmalloc could service it, meaning RAID0 arrays with many disks
  simply cannot be created (functional failure).
- **Severity:** MEDIUM-HIGH — WARNING triggers kernel taint, potential
  panic_on_warn crash, and prevents legitimate RAID0 creation.
Record: [WARNING + allocation failure → kernel taint, possible panic,
RAID0 creation failure] [Severity: MEDIUM-HIGH]

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
- **BENEFIT:** High — fixes a syzbot-reported real bug affecting
  multiple stable trees, preventing WARNINGs and enabling RAID0 with
  many disks.
- **RISK:** Very low — 9 lines changed, pure API substitution
  (kzalloc→kvzalloc, kfree→kvfree), a well-tested kernel pattern.
Record: [High benefit, very low risk]

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Syzbot-reported real bug with reproducer
- Same bug reproduced on linux-5.15.y (confirmed in multiple stable
  trees)
- Triggers WARN_ON_ONCE, which can cause panic with `panic_on_warn`
- Prevents creation of RAID0 arrays with many disks (functional failure)
- Very small, surgical fix (9 lines, single file)
- Well-understood pattern (kzalloc→kvzalloc) used thousands of times in
  the kernel
- Reviewed by TWO MD subsystem maintainers (Yu Kuai, Li Nan)
- No objections or concerns in review
- Standalone fix with no prerequisites (for 7.0 tree)

**AGAINST backporting:**
- For older stable trees (pre-7.0), the `kzalloc_objs`/`kvzalloc_objs`
  macro won't exist — needs trivial adaptation
- The trigger requires a large number of disks (not every RAID0 user
  hits this)

### Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. **Obviously correct and tested?** YES — trivial API swap, reviewed by
   two maintainers, syzbot-tested
2. **Fixes a real bug?** YES — syzbot reproduced WARNING, confirmed on
   multiple kernels
3. **Important issue?** YES — WARNING can trigger panic_on_warn; blocks
   RAID0 creation
4. **Small and contained?** YES — 9 lines in one file
5. **No new features or APIs?** CORRECT — pure API swap
6. **Can apply to stable?** YES for 7.0; needs minor adaptation for
   older trees

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Not an exception category — this is a straightforward bug fix.

### Step 9.4: DECISION
Clear YES. This is a textbook stable backport candidate: syzbot-
reported, small surgical fix, obviously correct, reviewed by
maintainers, fixes a real bug in widely-used code.

---

## Verification

- [Phase 1] Parsed tags: found Reported-by: syzbot, Closes: link to
  syzbot, Reviewed-by from Yu Kuai and Li Nan, committed by Yu Kuai (MD
  maintainer)
- [Phase 2] Diff analysis: 9 lines changed in `drivers/md/raid0.c`, pure
  kzalloc→kvzalloc + kfree→kvfree swap in `create_strip_zones()`
  (allocation + abort path) and `raid0_free()` (normal path)
- [Phase 3] git blame: strip_zone/devlist allocations date to Linux
  2.6.12 (2005), present in all stable trees
- [Phase 3] git blame: `kzalloc_objs` wrapper is v7.0-only (commit
  32a92f8c89326), older trees use `kcalloc`/`kzalloc`
- [Phase 3] Verified `kvzalloc_objs` macro exists in v7.0 tree
  (include/linux/slab.h line 1057)
- [Phase 3] Verified `kvzalloc` and `kvfree` exist in v5.15, v6.6 (well-
  established APIs)
- [Phase 4] spinics.net mirror: confirmed patch reviewed by Yu Kuai
  (2026-03-20) and Li Nan (2026-03-21), applied to md-7.1 on 2026-04-07,
  no objections
- [Phase 4] Syzbot upstream report: WARNING in create_strip_zones at
  mm/page_alloc.c, fix commit 078d1d8e688d confirmed
- [Phase 4] Syzbot 5.15 report: same WARNING triggered on linux-5.15.y
  (commit 91d48252ad4b), confirming bug in old stable trees
- [Phase 5] Call trace verified from syzbot: `create_strip_zones` →
  `raid0_run` → `md_run` → `md_ioctl` → ioctl syscall (reachable from
  userspace)
- [Phase 6] Bug code confirmed in v5.15, v6.12, v6.14 — all use
  kzalloc/kcalloc for strip_zone/devlist
- [Phase 6] For 7.0 tree: patch applies cleanly (kvzalloc_objs
  available)
- [Phase 6] For older trees: needs trivial adaptation (kcalloc→kvcalloc
  instead of kzalloc_objs→kvzalloc_objs)
- [Phase 7] md/raid0 is IMPORTANT subsystem, actively maintained
- [Phase 8] Failure mode: WARN_ON_ONCE (kernel taint, panic_on_warn) +
  ENOMEM preventing RAID0 creation; severity MEDIUM-HIGH

**YES**

 drivers/md/raid0.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index ef0045db409fc..5e38a51e349ad 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -143,13 +143,13 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	}
 
 	err = -ENOMEM;
-	conf->strip_zone = kzalloc_objs(struct strip_zone, conf->nr_strip_zones);
+	conf->strip_zone = kvzalloc_objs(struct strip_zone, conf->nr_strip_zones);
 	if (!conf->strip_zone)
 		goto abort;
-	conf->devlist = kzalloc(array3_size(sizeof(struct md_rdev *),
-					    conf->nr_strip_zones,
-					    mddev->raid_disks),
-				GFP_KERNEL);
+	conf->devlist = kvzalloc(array3_size(sizeof(struct md_rdev *),
+					     conf->nr_strip_zones,
+					     mddev->raid_disks),
+				 GFP_KERNEL);
 	if (!conf->devlist)
 		goto abort;
 
@@ -291,8 +291,8 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 
 	return 0;
 abort:
-	kfree(conf->strip_zone);
-	kfree(conf->devlist);
+	kvfree(conf->strip_zone);
+	kvfree(conf->devlist);
 	kfree(conf);
 	*private_conf = ERR_PTR(err);
 	return err;
@@ -373,8 +373,8 @@ static void raid0_free(struct mddev *mddev, void *priv)
 {
 	struct r0conf *conf = priv;
 
-	kfree(conf->strip_zone);
-	kfree(conf->devlist);
+	kvfree(conf->strip_zone);
+	kvfree(conf->devlist);
 	kfree(conf);
 }
 
-- 
2.53.0

