Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36303FE369;
	Tue, 28 Apr 2026 10:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372935; cv=none; b=Q1DRw17MxnLQRradPGqo587vyeRhNAMoQpWRzWcqy+aSUfLbzOd4eGsNXJbhXfnEqWYBuZZWkgKXWhigwrFS23qr1DkZZJQl319Tu5giiIfqZUG1kExXc8rGY9QMPANV6C1L9xoBMuByEhqzWO5Y186l1H3IpVGhNUuNgn7h4eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372935; c=relaxed/simple;
	bh=MBrOsObmFc7XibG6V+hMrHPinF/bUwb7BtC8HRIaKOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AyNxahQ4YL0rJ1SFvaJ/3EM11kw57nAQo8/7504mYbnScRDKVwb/bn8h/lN+tsra4BY1otiSMs4T4lwST4DQq1IFt9AtvLsQyODR4ZHp0VfZ8ec5pvJT89mw06wSzQNnDWP8Xo9k34tMd4SsTeaQtnQJTMO4sKaWwgBd0/nA/oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eCEcB9Ig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eCEcB9Ig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E737C2BCAF;
	Tue, 28 Apr 2026 10:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372935;
	bh=MBrOsObmFc7XibG6V+hMrHPinF/bUwb7BtC8HRIaKOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCEcB9IgcPZBEl5POXQCX+J6Hw7cjJoyoEjtJ3MkzI/1W8qdiEwqbrAHHpSBOLia3
	 bwCTa8HWHfwDLRMtOcUyefSXYN4K8Bn4LyLcuBBXZzhIWJ8X6OwKuO+ai+qaVDBka2
	 hYO1u3ZDYfsqUHR2aMuowukLRNCtbDGb+xw/3r/zhFO6lQa6pKCZRZ9OXgqN6ep/l2
	 su4Qp3p74usYVGzb5DLXvZKm1fSuhedlU0HjncEt4GmByIMdSZuVTr9LBWJPfKp6Rk
	 Lei8lXS+cFqd7SjNOY3SRwIJVMtuQG3lk3AjISHYU3vFDLfrs29ZwMu2VEzYHH57fL
	 Ch4fFh1NXITzg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] f2fs: fix to skip empty sections in f2fs_get_victim
Date: Tue, 28 Apr 2026 06:40:41 -0400
Message-ID: <20260428104133.2858589-30-sashal@kernel.org>
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

[ Upstream commit dccd324fa9bd1a2907a63fa4cc2651f687b2b5d0 ]

In age-based victim selection (ATGC, AT_SSR, or GC_CB), f2fs_get_victim
can encounter sections with zero valid blocks. This situation often
arises when checkpoint is disabled or due to race conditions between
SIT updates and dirty list management.

In such cases, f2fs_get_section_mtime() returns INVALID_MTIME, which
subsequently triggers a fatal f2fs_bug_on(sbi, mtime == INVALID_MTIME)
in add_victim_entry() or get_cb_cost().

This patch adds a check in f2fs_get_victim's selection loop to skip
sections with no valid blocks. This prevents unnecessary age
calculations for empty sections and avoids the associated kernel panic.
This change also allows removing redundant checks in add_victim_entry().

Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to make a thorough decision. Let me
compile my complete analysis.

## Complete 9-Phase Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 - Parse Subject Line:**
Record: `[fs: f2fs]` `[fix]` - Fix to skip empty sections in
`f2fs_get_victim` to avoid kernel panic from `f2fs_bug_on(mtime ==
INVALID_MTIME)`.

**Step 1.2 - Parse Tags:**
Record:
- Author: `Daeho Jeong <daehojeong@google.com>` (Google Android kernel
  engineer)
- `Reviewed-by: Chao Yu <chao@kernel.org>` (F2FS subsystem maintainer)
- `Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>` (F2FS maintainer)
- NO `Fixes:` tag, NO `Cc: stable` tag, NO `Reported-by:` tag, NO
  `Link:` tag

**Step 1.3 - Analyze Commit Body:**
Record:
- Bug description: In age-based victim selection (ATGC, AT_SSR, GC_CB),
  `f2fs_get_victim` can encounter sections with zero valid blocks
- Failure mode: `f2fs_get_section_mtime()` returns `INVALID_MTIME`,
  triggering `f2fs_bug_on(sbi, mtime == INVALID_MTIME)` in
  `add_victim_entry()` or `get_cb_cost()` → kernel panic (with
  `CONFIG_F2FS_CHECK_FS`) or WARN + `SBI_NEED_FSCK` flag
- Root cause claim: "checkpoint is disabled or due to race conditions
  between SIT updates and dirty list management"
- Commit says "This change also allows removing redundant checks in
  `add_victim_entry()`" — but the final v2 does NOT remove those checks
  (they remain)

**Step 1.4 - Hidden Bug Fix Detection:**
Record: Not hidden — explicitly a "fix" commit preventing a kernel
panic.

### PHASE 2: DIFF ANALYSIS

**Step 2.1 - Inventory Changes:**
Record: 1 file (`fs/f2fs/gc.c`), 3 lines added, 0 lines removed. Single-
function change within `f2fs_get_victim()`.

**Step 2.2 - Code Flow Change:**
Record:
- Before: Under `SBI_CP_DISABLED`, only LFS-mode checked
  `get_ckpt_valid_blocks` and SSR-mode checked
  `f2fs_segment_has_free_slot`. Sections with zero valid blocks could
  proceed to `add_victim_entry()` / `get_gc_cost()`.
- After: Added `if (!get_valid_blocks(sbi, segno, true)) goto next;`
  after both LFS/SSR branches — skips empty sections in CP_DISABLED mode
  before they hit the BUG_ON.

**Step 2.3 - Bug Mechanism:**
Record: Category (d) memory safety / sanity-check, specifically avoiding
a `BUG_ON` trip in age-based victim selection when large sections have
all zero valid blocks (→ `f2fs_get_section_mtime` returns
`INVALID_MTIME`).

**Step 2.4 - Fix Quality:**
Record: Obviously correct — sections with zero valid blocks contain no
data to migrate, so skipping them is semantically correct. Zero
regression risk: just bypasses useless work. Fix is minimal (3 lines)
and localized.

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 - Blame:**
Record: The `f2fs_bug_on(sbi, mtime == INVALID_MTIME)` and
`INVALID_MTIME` machinery were introduced by `b19ee7272208` ("f2fs:
introduce f2fs_get_section_mtime") in v6.13-rc1.

**Step 3.2 - Follow Fixes Tag:**
Record: No `Fixes:` tag. The underlying issue originated in
`b19ee7272208` (v6.13-rc1). An earlier related fix `207764e5d6f19`
("f2fs: fix to avoid return invalid mtime from
f2fs_get_section_mtime()") handled mtime fuzzing via syzbot report; it's
in stable 6.14.y, 6.15.y, 6.16.y, 6.17.y, 6.18.y, 6.19.y but not 6.13.y.

**Step 3.3 - Related Recent Changes:**
Record: `d625a2b08c089` ("f2fs: fix to avoid migrating empty section")
in Sep 2025 is thematically related — both deal with empty sections
during GC.

**Step 3.4 - Author's Other Commits:**
Record: Daeho Jeong is a regular f2fs contributor from Google working
extensively on f2fs GC logic and Android kernel integration. Multiple
GC-related commits.

**Step 3.5 - Dependencies:**
Record: Standalone — calls only `get_valid_blocks()` which exists in all
stable trees. No dependencies on newer code.

### PHASE 4: MAILING LIST RESEARCH

**Step 4.1 - Original Patch Discussion:**
Record: `b4 dig -c dccd324fa9bd1` found `https://lore.kernel.org/all/202
60316185922.2184759-1-daeho43@gmail.com/`. Patch went through v1 → v2.
v2 changelog: "changed the check position." v1 placed the check
unconditionally (before CP_DISABLED) AND removed redundant check from
`add_victim_entry()`. v2 narrowed scope to only run under CP_DISABLED
and kept redundant check.

**Step 4.2 - Reviewers:**
Record: Reviewed by Chao Yu (F2FS co-maintainer). Mailing lists: linux-
kernel, linux-f2fs-devel, kernel-team@android.com.

**Step 4.3 - Bug Report:**
Record: No explicit Reported-by or Link. The language "race conditions
between SIT updates and dirty list management" suggests it was observed
(possibly internally at Google/Android).

**Step 4.4 - Related Patches:**
Record: Not part of a series.

**Step 4.5 - Stable Mailing List:**
Record: No explicit stable nomination by reviewers in thread. Patchwork-
bot confirmed application to `jaegeuk/f2fs.git (dev)`.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 - Key Functions:**
Record: `f2fs_get_victim()`, which calls `add_victim_entry()` (for
is_atgc) and `get_gc_cost()` → `get_cb_cost()` (for GC_CB).

**Step 5.2 - Callers:**
Record: `f2fs_get_victim` is called from `__get_victim` which is called
from `f2fs_gc`. `f2fs_gc` is called from GC background thread and from
ioctl `F2FS_IOC_GC` (user triggerable).

**Step 5.3 - Callees:**
Record: `get_valid_blocks()` reads section metadata; quick, safe call.

**Step 5.4 - Reachability:**
Record: Reachable from userspace via `ioctl(F2FS_IOC_GC)` as
demonstrated by the earlier syzbot reproducer for the related bug. Also
reached via background GC thread.

**Step 5.5 - Similar Patterns:**
Record: `add_victim_entry()` already has a similar check (`p->gc_mode ==
GC_AT && get_valid_blocks == 0`) — but it's narrower. This commit
extends the protection to all modes under CP_DISABLED.

### PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1 - Code in Stable:**
Record: `f2fs_get_section_mtime` exists in 6.13.y, 6.14.y, 6.15.y,
6.16.y, 6.17.y, 6.18.y, 6.19.y. Does NOT exist in 6.12.y (introduced in
v6.13-rc1). Therefore bug only affects 6.13.y+.

**Step 6.2 - Backport Complications:**
Record: The surrounding code (CP_DISABLED block with LFS/SSR branches)
is identical in all stable branches from 6.13.y to 6.19.y. Patch applies
cleanly.

**Step 6.3 - Related Fixes Already in Stable:**
Record: `207764e5d6f19` (related INVALID_MTIME fix) already in 6.14.y,
6.15.y, 6.16.y, 6.17.y, 6.18.y, 6.19.y. This commit is complementary,
not duplicative — handles the `total_valid_blocks == 0` path that
`207764e5d6f19` left intact.

### PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1 - Subsystem Criticality:**
Record: `fs/f2fs/` — IMPORTANT. Widely used on Android devices,
ChromeOS, and some embedded flash-storage systems.

**Step 7.2 - Subsystem Activity:**
Record: Very active subsystem with regular stable backports. Many
similar small fixes get backported routinely.

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 - Affected Population:**
Record: Users of f2fs (Android, ChromeOS, embedded) running large
sections (zoned devices, some flash) with age-based GC modes, especially
when using `checkpoint=disable` mount option.

**Step 8.2 - Trigger Conditions:**
Record: Requires all of: (a) large section mode
(`__is_large_section(sbi)`), (b) `SBI_CP_DISABLED` flag set, (c) victim
selection in `is_atgc` or `GC_CB` mode, (d) a section with zero valid
blocks reaching this code path via SIT/dirty-list race. User-triggerable
via `ioctl(F2FS_IOC_GC)` or naturally during background GC.

**Step 8.3 - Failure Mode Severity:**
Record:
- With `CONFIG_F2FS_CHECK_FS=y` (dev builds, debug distros): kernel
  panic via `BUG_ON` — CRITICAL
- Without: `WARN_ON` + sets `SBI_NEED_FSCK` flag (filesystem marked
  needing repair, user-facing disruption) — MEDIUM
- Also, `INVALID_MTIME` (= ULLONG_MAX) then fed into age calculations
  produces wildly wrong GC cost → suboptimal GC decisions.

**Step 8.4 - Risk-Benefit:**
Record:
- Benefit: Prevents panic on debug builds; avoids FS-needs-fsck flag and
  bogus GC cost on production.
- Risk: Very low. 3 lines added, inside an `unlikely(CP_DISABLED)`
  branch. The skipped work is legitimately unnecessary (empty sections
  have nothing to migrate). No locking changes, no allocation changes.

### PHASE 9: FINAL SYNTHESIS

**Step 9.1 - Evidence Compilation:**

FOR:
- Prevents kernel panic (w/ `F2FS_CHECK_FS`) or FS-needs-fsck (w/o)
- Small, obvious 3-line fix
- Reviewed by F2FS subsystem maintainer (Chao Yu)
- Went through v1→v2 review cycle; narrowed scope based on feedback
- Zero regression risk (skipping empty sections is semantically correct)
- Bug exists in every stable branch from 6.13.y through 6.19.y
- Patch applies cleanly to all affected stable branches
- Previous related INVALID_MTIME fix (`207764e5d6f19`) already in stable
- Applicable to Android's `checkpoint=disable` usage pattern
- Reaches via user-triggerable `ioctl(F2FS_IOC_GC)` (syscall-reachable)

AGAINST:
- No `Fixes:` tag
- No `Cc: stable` tag from author/maintainer
- No explicit `Reported-by:` or `Link:` to a bug report
- Trigger conditions are specific (CP_DISABLED + large section + age-
  based GC + race)
- Commit message mentions removing checks that v2 didn't remove (minor
  inconsistency)

**Step 9.2 - Stable Rules Checklist:**
1. Obviously correct and tested? YES — empty sections have nothing to
   migrate; reviewed by maintainer
2. Fixes a real bug? YES — documented panic path via `f2fs_bug_on(mtime
   == INVALID_MTIME)`
3. Important issue? YES — kernel panic on debug kernels, FS corruption
   flagging on production
4. Small and contained? YES — 3 lines, single function
5. No new features/APIs? YES
6. Applies to stable trees? YES — clean apply to 6.13.y through 6.19.y

**Step 9.3 - Exception Categories:**
Not applicable (not a device ID / quirk / DT / build / doc fix).
Standard bug-fix commit.

**Step 9.4 - Decision:**
This is a small, surgical bug fix preventing a legitimate kernel
panic/warn-and-flag-for-fsck condition, reviewed by the subsystem
maintainer, with zero regression risk. The trigger window (CP_DISABLED +
race) is uncommon but realistic on Android/ChromeOS workloads. Similar
small f2fs sanity-check fixes are routinely backported. The absence of
Fixes:/Cc:stable is expected per the instructions — this is why it needs
review.

## Verification

- [Phase 1] Read full commit message from `git show dccd324fa9bd1` —
  confirmed tags (Reviewed-by Chao Yu, Signed-off-by Daeho/Jaegeuk), no
  Fixes:/Cc:stable/Reported-by:/Link:
- [Phase 2] Read `fs/f2fs/gc.c` lines 850-950 and diff — confirmed
  3-line addition inside the `SBI_CP_DISABLED` block of
  `f2fs_get_victim`
- [Phase 2] Read `get_cb_cost` (line 367) and `add_victim_entry` (line
  520) — confirmed both have `f2fs_bug_on(mtime == INVALID_MTIME)`
- [Phase 2] Read `f2fs_get_section_mtime` in `fs/f2fs/segment.c:5637` —
  confirmed returns `INVALID_MTIME` when `total_valid_blocks == 0`
- [Phase 2] Read `f2fs_bug_on` macro in `f2fs.h:33-41` — confirmed
  BUG_ON with CONFIG_F2FS_CHECK_FS, WARN+SBI_NEED_FSCK without
- [Phase 3] `git log -S INVALID_MTIME` — identified introduction in
  `b19ee7272208`, partial fix `207764e5d6f19`
- [Phase 3] `git describe --contains b19ee7272208` → `v6.13-rc1~77^2~39`
  (bug introduced in v6.13)
- [Phase 3] `git describe --contains 207764e5d6f19` → `v6.14-rc1~63^2~4`
  (prior fix in v6.14)
- [Phase 3] `git branch --contains dccd324fa9bd1` — confirmed only in
  `linux-next/master` and `fs-next` (not in any stable tag yet)
- [Phase 4] `b4 dig -c dccd324fa9bd1` — found submission at
  `lore.kernel.org/all/20260316185922.2184759-1-daeho43@gmail.com`
- [Phase 4] `b4 dig -a` — confirmed v1→v2 evolution; v2 is what was
  applied
- [Phase 4] Read `/tmp/f2fs_thread.mbox` — confirmed Chao Yu Reviewed-
  by, patchwork-bot applied to `jaegeuk/f2fs.git (dev)`
- [Phase 4] Read `/tmp/20260310_daeho43_...mbx` (v1) — confirmed v1 had
  unconditional check + removed redundant `add_victim_entry` check; v2
  narrowed to CP_DISABLED only
- [Phase 6] `git grep -l f2fs_get_section_mtime` on each stable branch —
  confirmed bug exists in 6.13.y through 6.19.y, not in 6.12.y
- [Phase 6] Inspected CP_DISABLED block in each stable branch —
  confirmed identical code, patch would apply cleanly
- [Phase 6] `git log --grep "avoid return invalid mtime"` on stable
  branches — confirmed `207764e5d6f19` present in 6.14.y through 6.19.y
- [Phase 8] Verified `f2fs_get_victim` reachable via `F2FS_IOC_GC` ioctl
  from the stack trace in `207764e5d6f19` commit message
- UNVERIFIED: Exact frequency/reproducibility of the race condition
  between SIT updates and dirty list management — commit message asserts
  this but provides no reproducer
- UNVERIFIED: Whether the commit message's claim "allows removing
  redundant checks in add_victim_entry()" is still meaningful for v2 (v2
  doesn't actually remove them; likely leftover from v1 description)

The fix is small, surgical, reviewed by the subsystem maintainer,
prevents a real panic/filesystem-flagging bug present in all active
stable trees from 6.13.y onward, and carries negligible regression risk.
This matches the profile of f2fs fixes routinely backported to stable.

**YES**

 fs/f2fs/gc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index f46b2673d31f5..5c355d3da23bf 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -909,6 +909,9 @@ int f2fs_get_victim(struct f2fs_sb_info *sbi, unsigned int *result,
 				if (!f2fs_segment_has_free_slot(sbi, segno))
 					goto next;
 			}
+
+			if (!get_valid_blocks(sbi, segno, true))
+				goto next;
 		}
 
 		if (gc_type == BG_GC && test_bit(secno, dirty_i->victim_secmap))
-- 
2.53.0

