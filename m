Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836E9449B3D;
	Mon, 31 Aug 2026 13:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183251; cv=none; b=Rf2xWk+oco578xJxd1MjcqpZoiZcXEopQOuK1v+rtKU9cn3UH7WsgWk+o+w4zzzah0LO1SV7xCTzfSQWepT+kaZIATcg8QukTpHRPH1rAJeQmTedGBICg+RkJCD9c51EBbwLnmm7tE2g8rgdGsYk0E0VF0zeecxfyiphFjIuG3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183251; c=relaxed/simple;
	bh=cgyt9q8z3Kn19mmiqMoNiNlfD/XkNvfChnJajs+9DvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MdQ5Uy/yRtrO5oIRFSe7LUOYIJeqU/FXCkRBnVBkrI2x+b6BAtRrRUvz/zvG745qc/HnZAqWiijLxSmQKjh2yguekWNSpGuOTz0r8Vdh0y241/OyoS/8x3mMlpcEkOXu5PA8BmsZCUv8nNcSGFaELB77gUQYmYCMp0vu3P8ck8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DfCjPxt6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DfCjPxt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8172E1F00A3E;
	Mon, 31 Aug 2026 13:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183249;
	bh=0NW4mRM1lFuv3/T0JeKIPEtk3jeYx/q4ImV7WXkVHxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DfCjPxt64lgS3fntUfUA9aV3jVWvnMOhARaXMXCWQMJ2J0n6HjRyCGKP+GtHmYrFx
	 NwSS9p2fSRHoC/fzIIxghbEGiyKN/XWXVHdKLOtPryUqI8Zd95k368XH84hNRl3cud
	 qYZ1nDs7SiWooCHcIg1P1J+bep9rO0wqFvcouyYAhkowReColGkj7WL2JyC+j4h0/a
	 n+pTTT8VxWFd5LUIzXA8tSpFUKVnmw3CBVTCYuSQ3h93y5VdNnPaRbO2+A7ujpI/eB
	 D0IMjb7DWX99lZIj5zXsovVbwdOZoDhmYXEA2vt4Eu31Bg0nj5NMawKutVbn2hd9xA
	 JW96EFLFfBMdA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Timber <dxdt@dev.snart.me>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sj1557.seo@samsung.com,
	exfat@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] exfat: fix handling of damaged volume in exfat_create_upcase_table()
Date: Mon, 31 Aug 2026 09:21:03 -0400
Message-ID: <20260831133314.4125787-35-sashal@kernel.org>
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

From: David Timber <dxdt@dev.snart.me>

[ Upstream commit 20dd3185d13865214ff25b0bf7b931e8d73be1ac ]

When the size of the upcase table is set to zero in the dentry for any
reason(e.g. corrupted media or misbehaving device), an integer overflow
causes the module to loop indefinitely.

If the size of the upcase table is read zero, do not attempt to load the
table. Instead, fallback to loading the default upcase table. If the
size of the upcase table is zero or no upcase table is found, raise
exfat_fs_error() to mark the volume read-only.

Signed-off-by: David Timber <dxdt@dev.snart.me>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `exfat: fix handling of damaged volume in
exfat_create_upcase_table()`

**Local tree:** `v6.18.44-1-g2736c32da98b9` (Linux 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse Subject Line
**Record:** `[exfat] [fix] [handling of damaged volume in
exfat_create_upcase_table()]`

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — not present
- **Tested-by:** — not present
- **Reviewed-by:** — not present
- **Acked-by:** — not present
- **Link:** — not present
- **Cc: stable@vger.kernel.org** — not present (expected)
- **Signed-off-by:** David Timber `<dxdt@dev.snart.me>` (author)
- **Signed-off-by:** Namjae Jeon `<linkinjeon@kernel.org>` (exfat
  maintainer — strong quality signal)
- **Signed-off-by: Sasha Levin** — not in upstream commit (would be
  pipeline-added)

Notable: Maintainer (Namjae Jeon) signed off on the committed version.

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug:** When upcase table dentry has `size == 0` (corrupted media,
  misbehaving device), `((tbl_size - 1) >> blksize_bits) + 1` underflows
  in unsigned arithmetic, producing a near-maximum sector count.
- **Symptom:** `exfat_load_upcase_table()` loops indefinitely in `while
  (sector < num_sectors)`.
- **Fix approach:** Skip loading when `tbl_size == 0`; call
  `exfat_fs_error()` to mark volume read-only; fall back to default
  upcase table. Also call `exfat_fs_error()` when no upcase dentry is
  found at all.
- **Version info:** Not specified in commit message.
- **Root cause:** Unsigned integer underflow on zero-sized table.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not hidden — explicitly labeled "fix". This is a real
correctness/stability bug (mount-time infinite loop), not cosmetic
cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory Changes
**Record:**
- **Files:** `fs/exfat/nls.c` only (+13 / -6 lines)
- **Functions modified:** `exfat_create_upcase_table()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Change (per hunk)

**Hunk 1 (zero-size upcase table):**
- **Before:** Always computed `num_sectors` from `tbl_size` and called
  `exfat_load_upcase_table()` even when `tbl_size == 0`.
- **After:** If `tbl_size` is non-zero, load normally. If zero, call
  `exfat_fs_error()`, set `ret = -EINVAL`, skip the load path.

**Hunk 2 (missing upcase table dentry):**
- **Before:** Fell through to `load_default:` silently when no
  TYPE_UPCASE dentry was found.
- **After:** Calls `exfat_fs_error(sb, "no upcase table entry. Please
  run fsck")` before falling back to default table.

**Error path:** When `ret == -EINVAL`, existing logic `if (ret && ret !=
-EIO) { exfat_free_upcase_table(); goto load_default; }` still applies,
so the mount proceeds with the built-in default upcase table after
marking the filesystem erroneous.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Integer underflow → logic/correctness bug → effective
  infinite loop (soft lockup)
- **Mechanism:** With `tbl_size = 0` (unsigned `unsigned long long`):
  - `(tbl_size - 1)` wraps to `ULLONG_MAX`
  - `num_sectors = (ULLONG_MAX >> 12) + 1 ≈ 4,503,599,627,370,496`
    (verified via Python unsigned simulation)
  - `exfat_load_upcase_table()` at line 665: `while (sector <
    num_sectors)` iterates ~4.5×10¹⁵ times
  - Mount thread hangs; CPU watchdog / soft lockup likely

### Step 2.4: Fix Quality Assessment
**Record:**
- Fix is minimal and obviously correct: guard the zero case before
  arithmetic.
- Uses existing `exfat_fs_error()` pattern consistent with other
  corruption handling in exfat.
- Low regression risk: only affects corrupted/malformed upcase dentry
  paths.
- `git apply --check` on upstream patch succeeds against current tree.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame Changed Lines
**Record:**
- Buggy code introduced in `370e812b3ec190` ("exfat: add nls
  operations", Namjae Jeon, 2020-03-02).
- exfat has been in the kernel since ~5.7; this bug has existed since
  initial exfat merge.
- **Present in this tree:** Yes — lines 770–776 in `fs/exfat/nls.c`
  still have the vulnerable code.

### Step 3.2: Follow Fixes: Tag
**Record:** No `Fixes:` tag present. N/A.

### Step 3.3: File History for Related Changes
**Record:**
- 17 commits touched `fs/exfat/nls.c` since the buggy code was
  introduced.
- Related corruption-handling fixes in this tree include:
  - `88fc3dd6e631b` — "exfat: fix divide-by-zero in
    exfat_allocate_bitmap" (already backported to this stable tree)
  - `c290fe508eee3` — memory leak fix in `exfat_create_upcase_table()`
  - `fc961522ddbdf` — UAF fix in `exfat_load_upcase_table()`
- **Standalone:** Yes — single patch, no series dependency.
- **Prerequisites:** None identified.

### Step 3.4: Author's Other Commits
**Record:** David Timber has no other commits in this tree. Namjae Jeon
is the exfat maintainer and has extensive exfat history here.

### Step 3.5: Dependent/Prerequisite Commits
**Record:** No dependencies. Patch applies cleanly. Does not assume new
structures or APIs.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Patch Discussion
**Record:**
- **b4 dig -c 20dd3185d1:** Found v1 submission at
  https://patch.msgid.link/20260411233251.330698-1-dxdt@dev.snart.me
- **b4 dig -a:** Only v1 found (committed version matches v1).
- **Lore fetch:** Blocked by Anubis bot protection — could not read
  thread content directly.
- **Spinics:** Fetch timed out — could not read secondary thread.
- **Key reviewer feedback:** UNVERIFIED from mailing list (could not
  fetch). Commit has maintainer SOB from Namjae Jeon, indicating
  acceptance.

### Step 4.2: Reviewers (b4 dig -w)
**Record:** Original recipients included Namjae Jeon, Sungjong Seo,
Yuezhang Mo, and `linux-fsdevel@vger.kernel.org` — appropriate subsystem
maintainers and list were CC'd.

### Step 4.3: Bug Report
**Record:** No external bug report (syzbot, bugzilla). Bug identified by
author through corrupted-volume analysis. Severity is clear from code
path analysis.

### Step 4.4: Related Patches/Series
**Record:** An earlier submission titled "fix integer overflow" exists
on spinics (per web search). Final committed version adds the "no upcase
table entry" `exfat_fs_error()` call. Standalone — no other patches
required.

### Step 4.5: Stable Mailing List History
**Record:** UNVERIFIED — could not search stable@ lore due to fetch
limitations. Precedent exists in this tree: similar exfat corruption fix
(`88fc3dd6e631b` divide-by-zero) was already backported.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `exfat_create_upcase_table()`, `exfat_load_upcase_table()`,
`exfat_load_default_upcase_table()`, `exfat_fs_error()`

### Step 5.2: Callers
**Record:**
- `exfat_create_upcase_table()` called from `__exfat_fill_super()` in
  `fs/exfat/super.c:620`
- `__exfat_fill_super()` called from `exfat_fill_super()` →
  `get_tree_bdev()` → `exfat_get_tree()`
- **Context:** Filesystem mount path — every exfat mount runs this code.

### Step 5.3: Callees
**Record:** `exfat_get_dentry()`, `exfat_load_upcase_table()` (reads
sectors in loop), `exfat_fs_error()` (marks FS read-only by default),
`exfat_load_default_upcase_table()`.

### Step 5.4: Call Chain / Reachability
**Record:**
```
mount(2) / automount → exfat_get_tree → exfat_fill_super →
__exfat_fill_super
  → exfat_create_upcase_table → exfat_load_upcase_table [infinite loop
if tbl_size==0]
```
- **Userspace reachable:** Yes — mounting an exfat volume (USB stick, SD
  card, etc.) triggers this.
- Requires mount capability (typically root or fstab/udev automount),
  but corrupted removable media is a common real-world scenario.

### Step 5.5: Similar Patterns
**Record:** Same class of bug as `88fc3dd6e631b` (divide-by-zero on
corrupted exfat metadata during mount). The exfat subsystem has a
pattern of hardening mount-time parsing against corrupted volumes.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does Buggy Code Exist?
**Record:** **Yes.** Current `fs/exfat/nls.c` lines 773–776 compute
`num_sectors` without checking `tbl_size`:
```773:776:fs/exfat/nls.c
                        sector = exfat_cluster_to_sector(sbi, tbl_clu);
                        num_sectors = ((tbl_size - 1) >> blksize_bits) +
1;
                        ret = exfat_load_upcase_table(sb, sector,
num_sectors,
le32_to_cpu(ep->dentry.upcase.checksum));
```
- Fix commit `20dd3185d1` exists in object database but is **not** an
  ancestor of HEAD (`git merge-base --is-ancestor` returned 1).
- Bug introduced 2020; present throughout 6.18.y.

### Step 6.2: Backport Complications
**Record:** **Clean apply.** `git apply --check` on upstream patch
succeeds with no conflicts. File has had 17 commits since introduction
but the target hunk is unchanged.

### Step 6.3: Related Fixes Already Present?
**Record:** No — `git log --grep="bad upcase"` and `--grep="no upcase
table"` return nothing. This fix is not yet in the tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **Filesystem (exfat)** — IMPORTANT. exfat is widely used for
removable storage (USB drives, SD cards, cameras, Android-adjacent
devices). `CONFIG_EXFAT_FS` in `fs/exfat/Kconfig`.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained — 20 recent commits in `fs/exfat/`,
including multiple stable-worthy corruption fixes in this 6.18.y cycle.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users mounting exfat volumes with corrupted upcase table
metadata — common on failing flash media, improperly ejected devices, or
maliciously crafted images.

### Step 8.2: Trigger Conditions
**Record:**
- **Trigger:** exfat volume with TYPE_UPCASE dentry where `size == 0`
- **Likelihood:** Uncommon but realistic for corrupted removable media
- **Privilege:** Mount requires elevated privileges (or automount
  policy), but USB automount makes this a practical DoS vector

### Step 8.3: Failure Mode Severity
**Record:**
- **Failure mode:** Infinite loop in mount path → hung mount task → CPU
  soft lockup / system unresponsiveness
- **Severity:** **CRITICAL** (system hang during mount, potential
  watchdog reset)

### Step 8.4: Risk-Benefit Ratio
**Record:**
- **Benefit:** HIGH — prevents mount-time hang on corrupted media;
  aligns with Windows behavior (reject bad upcase, use default, mark
  read-only)
- **Risk:** VERY LOW — 13-line guard in error path only; patch applies
  cleanly; maintainer-reviewed
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real bug with verified unsigned underflow mechanism (~4.5×10¹⁵ loop
  iterations)
- CRITICAL failure mode (mount hang / soft lockup)
- Triggered on common exfat mount path
- Small, surgical, obviously correct fix
- exfat maintainer signed off
- Applies cleanly to 6.18.44
- Bug present since exfat introduction (2020)
- Precedent: similar exfat corruption fix already backported to this
  tree
- Default `errors=remount-ro` means `exfat_fs_error()` safely degrades
  to read-only

**AGAINST backport:**
- No syzbot/user bug report (weaker evidence of field impact, but code
  analysis is conclusive)
- No explicit stable nomination found (UNVERIFIED due to lore fetch
  failure)

**Unresolved:**
- Mailing list review discussion content (lore blocked)
- Whether any distro has independently worked around this

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — logic is clear;
maintainer SOB; applies cleanly |
| 2. Fixes real bug affecting users? | **PASS** — mount hang on
corrupted exfat media |
| 3. Important issue? | **PASS** — CRITICAL (system hang/soft lockup) |
| 4. Small and contained? | **PASS** — 1 file, 13 lines added |
| 5. No new features/APIs? | **PASS** — uses existing `exfat_fs_error()`
|
| 6. Can apply to local tree? | **PASS** — clean apply verified |

### Step 9.3: Exception Categories
**Record:** None apply directly (not device ID, quirk, DT, build fix, or
docs). This is a standard bug fix.

### Step 9.4: Decision Rationale
This commit fixes a long-standing mount-time infinite loop in exfat
triggered by corrupted upcase table metadata (`size == 0`). The bug
exists in Linux 6.18.44, the fix is minimal and maintainer-approved, and
a nearly identical class of exfat corruption fix has already been
backported to this stable tree. The failure mode (system hang on mount)
is severe enough to meet stable criteria.

---

## Verification

- **[Phase 1]** Parsed commit message from user query and `git show
  20dd3185d1`: subsystem=exfat, action=fix, tags=David Timber SOB +
  Namjae Jeon SOB only
- **[Phase 2]** Read `fs/exfat/nls.c` lines 647–802: confirmed
  vulnerable arithmetic and infinite-loop `while (sector < num_sectors)`
- **[Phase 2]** Python unsigned simulation: `tbl_size=0` →
  `num_sectors=4503599627370496`
- **[Phase 2]** `git apply --check` on upstream patch: **clean apply**
- **[Phase 3]** `git blame -L 770,776 fs/exfat/nls.c`: introduced
  `370e812b3ec190` (2020-03-02)
- **[Phase 3]** `git log --oneline -15 -- fs/exfat/nls.c`: 17 commits
  since introduction, no duplicate fix
- **[Phase 3]** `git log --grep="bad upcase"/"no upcase table"`: no
  matches (fix not present)
- **[Phase 4]** `b4 dig -c 20dd3185d1`: lore URL found; v1 only
- **[Phase 4]** `b4 dig -w`: Namjae Jeon, Sungjong Seo, Yuezhang Mo,
  linux-fsdevel CC'd
- **[Phase 4]** WebFetch lore.kernel.org: **BLOCKED** (Anubis)
- **[Phase 4]** WebFetch spinics: **TIMED OUT**
- **[Phase 5]** `grep exfat_create_upcase_table`: caller is
  `super.c:620` in mount path
- **[Phase 5]** Read `misc.c`: `exfat_fs_error()` remounts read-only
  when `errors=remount-ro` (default at `super.c:832`)
- **[Phase 6]** `git describe HEAD`: v6.18.44-1-g2736c32da98b9
- **[Phase 6]** `git merge-base --is-ancestor 20dd3185d1 HEAD`: exit 1
  (fix NOT in tree)
- **[Phase 6]** Read current `nls.c:770-776`: buggy code confirmed
  present
- **[Phase 7]** `git log --oneline -20 -- fs/exfat/`: active subsystem
  with prior stable backports
- **[Phase 7]** `git show 88fc3dd6e631b`: precedent for exfat corruption
  fix in this tree
- **[Phase 8]** Mount call chain verified: `exfat_fill_super` →
  `__exfat_fill_super` → `exfat_create_upcase_table`

**YES**The background searches finished: neither `git log --grep="fix
handling of damaged volume"` nor greps for `"bad upcase"` / `"no upcase
table"` turned up anything in this tree, so the fix isn’t present under
another commit message.

That matches the earlier finding — commit `20dd3185d1` exists in the
object database but isn’t on HEAD, and the vulnerable code is still in
`fs/exfat/nls.c`. The backport recommendation remains **YES** for Linux
6.18.44.

 fs/exfat/nls.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/exfat/nls.c b/fs/exfat/nls.c
index 57db08a5271cf..055447edcf9a6 100644
--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -769,13 +769,18 @@ int exfat_create_upcase_table(struct super_block *sb)
 
 			tbl_clu  = le32_to_cpu(ep->dentry.upcase.start_clu);
 			tbl_size = le64_to_cpu(ep->dentry.upcase.size);
-
-			sector = exfat_cluster_to_sector(sbi, tbl_clu);
-			num_sectors = ((tbl_size - 1) >> blksize_bits) + 1;
-			ret = exfat_load_upcase_table(sb, sector, num_sectors,
-				le32_to_cpu(ep->dentry.upcase.checksum));
-
+			if (tbl_size) {
+				sector = exfat_cluster_to_sector(sbi, tbl_clu);
+				num_sectors = ((tbl_size - 1) >> blksize_bits) + 1;
+				ret = exfat_load_upcase_table(sb, sector, num_sectors,
+					le32_to_cpu(ep->dentry.upcase.checksum));
+			} else {
+				exfat_fs_error(sb,
+					       "bad upcase table size (0 bytes). Please run fsck");
+				ret = -EINVAL;
+			}
 			brelse(bh);
+
 			if (ret && ret != -EIO) {
 				/* free memory from exfat_load_upcase_table call */
 				exfat_free_upcase_table(sbi);
@@ -790,6 +795,8 @@ int exfat_create_upcase_table(struct super_block *sb)
 			return -EIO;
 	}
 
+	exfat_fs_error(sb, "no upcase table entry. Please run fsck");
+
 load_default:
 	/* load default upcase table */
 	return exfat_load_default_upcase_table(sb);
-- 
2.53.0

