Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542135D5DB7;
	Mon, 19 Oct 2026 14:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418523; cv=none; b=PsxawrTLTtbet76Ii6KR+9z2TZGgI18KjtWqkERvaW8PEiSzk7blJKJkkB7oueDkRuPbKfEnzvWrA6j/hNnKJNvq/3xJJGld8Pur0DakrTBhSO3cZNDFtiw//cPzVlMV9xmuXTugLtLwTe6hqKReuesYGZNPVP86f59xzNiYtBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418523; c=relaxed/simple;
	bh=jFjoZje5kLn73JJIeD6nU3VHpkgdr+EoS63/2I4yVqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uxGI4lbDeA8R6UuKepxwJjFhDfHAk4/LUwj/deSJn3D32mVfkrGWGmRgo8sybhWA/0ptLYXgFACHzFlLdXf+JmBfRQghlA9bvY2uiliMqZhdnG9EucnYwt2FR9/qCSBGfRP6/01caxY/BeZFxN7pOQ7ZZcC/hibRAVWTHkP2iuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jsQZLJj0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jsQZLJj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E89A1F000CD;
	Mon, 19 Oct 2026 14:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418519;
	bh=wbCfE7+0JL3bHLkZaRl4667sbctaeZUWcJ36KHksLU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jsQZLJj0Xzt6k5uslVbISviUURz0CZWLXYkK7bmWS/IpWACqArtJWN9Qc4CWlT1RO
	 p0YV9t/V4qXnPxuVWRX6XE5nfUetvaWdp6elCxr7nKRU6E55xnJIHcon1GPL7pUdii
	 sGoG+cLGfDxuiTRwUJsqrem74Otk6mNWt4DFXrzQnwOObc11TjN/cQiIOY9BqOwaML
	 A/4IYqCeiT+CUVaSOIFoGKs563wXMqXOr4YHkD7Tm8mZ7c9hZBBT0kyPbTJsXYbJ9F
	 beP89md4SVnJYYKTkY2M4nGhCy8vGhfOgJlC5o2UkCHtgxYO55hnlh6N/91rBDsut5
	 9O7jng4C0Ja/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Senjin <senjin@hatchling.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] fs/ntfs3: fix lseek EINVAL on sparse/compressed files with 64-bit clusters
Date: Mon, 19 Oct 2026 09:49:57 -0400
Message-ID: <20261019135441.1420968-306-sashal@kernel.org>
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

From: Senjin <senjin@hatchling.org>

[ Upstream commit 789af83e41aef54c1ff1cee16adc27822e0a0d71 ]

When CONFIG_NTFS3_64BIT_CLUSTER is enabled, sbi->maxbytes_sparse is set
to -1. As a signed loff_t this is -1LL, the most negative value. Any
lseek on a sparse or compressed file passes this as maxsize to
vfs_setpos(), which returns -EINVAL whenever offset > maxsize, and
since -1LL is less than any non-negative offset, every seek fails,
including lseek(fd, 0, SEEK_SET).

The intent of -1 here appears to be "no limit" (matching the spirit of
MAX_LFS_FILESIZE assigned to sbi->maxbytes and sb->s_maxbytes in the
same block), but the signed type makes it the minimum instead of the
maximum.

Fix by assigning MAX_LFS_FILESIZE to sbi->maxbytes_sparse in the
64-bit cluster path, consistent with the other two limits set there.

Observed on a 16 TB NTFS volume with 0xFFFFFEFF total clusters compiled
with CONFIG_NTFS3_64BIT_CLUSTER=y. Sequential reads via dd/cp worked
correctly; any lseek call on sparse files returned EINVAL, preventing
archive managers and other tools from random-accessing files on the
volume. The non-64-bit-cluster path correctly sets maxbytes_sparse to
(1ull << (cluster_bits + 32)) - 1, a large positive value.

Signed-off-by: Senjin <senjin@hatchling.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line NTFS3 correctness fix: with 64-bit clusters,
sparse/compressed `lseek` was passing a signed `-1` limit into
`vfs_setpos()`, so every nonnegative seek returned `-EINVAL`. The local
tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`); the path and the
bug both exist here.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[fs/ntfs3] [fix] [lseek returns EINVAL on sparse/compressed
files when CONFIG_NTFS3_64BIT_CLUSTER is set]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Senjin <senjin@hatchling.org>` (author)
- `Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-
  software.com>` (NTFS3 maintainer; listed in MAINTAINERS)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable@` (absence is expected for this review)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** With `CONFIG_NTFS3_64BIT_CLUSTER`, `sbi->maxbytes_sparse` is
  set to `-1`. Used as signed `loff_t`, that is `-1LL`. `ntfs_llseek()`
  passes it to `vfs_setpos()` / `generic_file_llseek_size()`, which
  rejects any `offset > maxsize`.
- **Symptom:** Every `lseek` on sparse/compressed files fails with
  `EINVAL`, including `lseek(fd, 0, SEEK_SET)`. Sequential `dd`/`cp`
  still work. Archive managers cannot random-access those files.
- **Trigger:** Observed on a 16 TB NTFS volume (`0xFFFFFEFF` clusters)
  with `CONFIG_NTFS3_64BIT_CLUSTER=y`.
- **Root cause:** `-1` was meant as “no limit” (same idea as
  `MAX_LFS_FILESIZE` for `sb->s_maxbytes`), but as a signed max it is
  the minimum, not the maximum.
- **Fix:** Assign `MAX_LFS_FILESIZE` instead, matching `sb->s_maxbytes`
  in the same `#ifdef`.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: `[Not hidden]` — subject and body describe a real, reproduced
functional bug.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `fs/ntfs3/super.c` — 1 insertion, 1 deletion
- Function: `ntfs_init_from_boot()`
- Scope: single-file surgical one-liner

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `#ifdef CONFIG_NTFS3_64BIT_CLUSTER` always does
  `sbi->maxbytes_sparse = -1`.
- **After:** `sbi->maxbytes_sparse = MAX_LFS_FILESIZE`.
- Path: superblock init at mount. Affects every later
  `ntfs_get_maxbytes()` use for sparse/compressed inodes.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: `[Logic / type-signedness]`

Verified types and call path:
- `maxbytes_sparse` is `u64` (`fs/ntfs3/ntfs_fs.h`). Assigning `-1`
  stores `U64_MAX`.
- `ntfs_get_maxbytes()` returns that as `loff_t`. `U64_MAX` → `-1LL`.
- `ntfs_llseek()` (`fs/ntfs3/file.c`) passes that to
  `generic_file_llseek_size()` / `vfs_setpos()`.
- `vfs_setpos_cookie()` (`fs/read_write.c`) does `if (offset > maxsize)
  return -EINVAL`. For `offset == 0` and `maxsize == -1`, `0 > -1` is
  true.

Same conversion also breaks `ntfs_iomap_begin()`’s `IOMAP_REPORT` check
(`offset > ntfs_get_maxbytes(ni)`), so fiemap/bmap on those files can
fail the same way.

The `#else` path already uses a large positive `(1ull << (cluster_bits +
32)) - 1`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: `MAX_LFS_FILESIZE` is `LLONG_MAX` on 64-bit
  (`include/linux/fs.h`); this config is 64-bit-only (`#error` on
  32-bit). Same constant is already assigned to `sb->s_maxbytes` in this
  block.
- Minimal: one assignment change, no API/struct change.
- Regression risk: very low. Limit goes from “every seek fails” to the
  VFS max file size. `ntfs_set_size()` / attrib insert compare against
  `u64`; `LLONG_MAX` is still a huge positive cap and matches VFS, vs
  the old `U64_MAX` which was accidentally unlimited on those u64
  checks.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Buggy assignment introduced in `82cae269cfa95` (“fs/ntfs3: Add
  initialization of super block”, 2021-08-13), first in **v5.15-rc1**.
- Field has been `u64 maxbytes_sparse` since the original headers
  (`4534a70b7056f`).
- User-visible `lseek` breakage requires `ntfs_llseek()` using
  `ntfs_get_maxbytes()`, added in `c613269677283` (“implement llseek
  SEEK_DATA/SEEK_HOLE…”), contained in **v7.0-rc1**. Before that,
  `.llseek = generic_file_llseek` used `sb->s_maxbytes`
  (`MAX_LFS_FILESIZE` in this config), so SEEK_SET worked.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: `[N/A — no Fixes: tag]`. Effective buggy commit for the reported
symptom is `c613269677283` (in this tree). The `-1` store itself is from
`82cae269cfa95` (also in this tree).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Candidate: `789af83e41aef` (2026-06-13 / committed 2026-07-24).
- Merged to Linus in `dc83d18cdd904` (`ntfs3_for_7.3`, 2026-08-20);
  present in **v7.3-rc1**. **Not** in v7.2 / v7.1 / v7.0.
- Series sibling (v2 1/2): `e31886cb6e0e1` (ATTR_BITMAP extents) is the
  git parent but touches `fs/ntfs3/inode.c` only. Independent of this
  hunk.
- No other `maxbytes_sparse` fix in this tree.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Senjin has this plus the ATTR_BITMAP mount fix on the same 16 TB
volume. Konstantin Komarov is the NTFS3 maintainer (`MAINTAINERS`:
Supported) and committed both.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Standalone. Needs only `CONFIG_NTFS3_64BIT_CLUSTER` and
`MAX_LFS_FILESIZE`, both present since ntfs3 was added. Does not need
patch 1/2.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 789af83e41aef`: `[PATCH v2 2/2]`,
  https://patch.msgid.link/6a2dba8e030b48618aa54661@mailersend.net
- `b4 dig -a`: v1 was only the ATTR_BITMAP patch (2026-06-10); v2 added
  this as 2/2 (2026-06-13). Applied version is v2.
- lore.kernel.org / patch.msgid.link returned **403**; spinics ntfs3
  thread returned **500**. Patch text confirmed via LKML IU and Openwall
  mirrors. Full reply thread: **UNVERIFIED**.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): `senjin@hatchling.org`, `ntfs3@lists.linux.dev`,
`almaz.alexandrovich@paragon-software.com`, `linux-
kernel@vger.kernel.org`. Maintainer list was CCed; maintainer signed off
and merged. No NAK found in reachable archives.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla link. Author reports a real 16 TB volume;
sequential I/O worked, `lseek` did not. Same volume as the ATTR_BITMAP
mount failure.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: v2 1/2 is a different mount bug (`inode.c`). This 2/2 is self-
contained. Linus’s `ntfs3_for_7.3` pull lists “lseek EINVAL on
sparse/compressed files with 64-bit clusters” under Fixed.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search did not turn up this subject
(403/unrelated hits). **UNVERIFIED** whether anyone already
requested/rejected it for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `ntfs_init_from_boot()` (assignment). Consumers:
`ntfs_get_maxbytes()` → `ntfs_llseek()`, `ntfs_iomap_begin()`; also raw
`sbi->maxbytes_sparse` in `ntfs_set_size()` and attrib insert.

**Step 5.2: TRACE CALLERS**
Record:
- `ntfs_init_from_boot()` — mount/fill_super.
- `ntfs_llseek` — `file_operations.llseek` for regular ntfs3 files
  (syscall `lseek`/`llseek`).
- `ntfs_iomap_begin` — fiemap/bmap `IOMAP_REPORT`.
- Directory `llseek` still uses `generic_file_llseek` (`dir.c`); not
  this bug.

**Step 5.3: TRACE CALLEES**
Record: The changed line is an assignment. Downstream: `vfs_setpos()` /
`generic_file_llseek_size()`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace `lseek` → `ntfs_llseek` → `ntfs_get_maxbytes` →
`vfs_setpos`. Reachable from unprivileged processes with a file open.
Confirmed in-tree.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `sbi->maxbytes = -1` remains in the overflow branch (`clusters
>= 1ull << (64 - cluster_bits)`). Same signedness issue for *non-sparse*
files, but that volume size is far beyond the reported 16 TB /
`0xFFFFFEFF` clusters. Out of this patch’s scope.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. `fs/ntfs3/super.c`, `ntfs_llseek`,
`CONFIG_NTFS3_64BIT_CLUSTER`, and `ntfs_get_maxbytes()` are all present.
Current line is already the fixed assignment (`sbi->maxbytes_sparse =
MAX_LFS_FILESIZE` at line 1214). Pre-fix `-1` is in `789af83e41aef^`.
Bug introduction for lseek: v7.0; this checkout is 7.3-rc4.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. Surrounding `#ifdef CONFIG_NTFS3_64BIT_CLUSTER` /
`sb->s_maxbytes = MAX_LFS_FILESIZE` matches the hunk. No conflicting
refactor in this function.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This commit *is* the fix (`789af83e41aef` is an ancestor of
HEAD). No earlier substitute fix. That is origin-tree presence, not a
reason to reject on merit.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `[fs/ntfs3] [IMPORTANT]` — not core VFS, but a supported RW
filesystem used for Windows/large volumes. Maintainer-supported.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained (regular `ntfs3_for_*` pulls, many 7.3
fixes). This is not staging.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Config-specific (`CONFIG_NTFS3_64BIT_CLUSTER=y`, 64-bit,
recommended N in Kconfig) **and** sparse or compressed files. That
option exists specifically for 16T+ volumes with 4K clusters (Windows
ntfs.sys is 32-bit cluster). Real users of large NTFS volumes.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Any `lseek` (SEEK_SET/SEEK_END/nonzero SEEK_CUR) on a
sparse/compressed file after mount. Common for archive tools, not rare
error-path. Unprivileged if the user can open the file. Not a race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: `[Failure: all random access via lseek fails with EINVAL;
sequential read still works] [Severity: HIGH]`. Not a panic/UAF, but the
filesystem is unusable for a normal class of tools. Also breaks
fiemap/bmap `IOMAP_REPORT` on those inodes.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: Benefit high for affected mounts (restores `lseek`). Risk very
low (1 line, same constant already used for `s_maxbytes`). Ratio
strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real user-visible bug on a 16 TB volume; `lseek` always `EINVAL` on
  sparse/compressed files.
- Mechanism verified in this tree (`vfs_setpos` `offset > maxsize`,
  signed `-1`).
- One-line, obviously correct, matches existing `MAX_LFS_FILESIZE`
  usage.
- Maintainer signed off and merged.
- Standalone; no new API/feature.
- Call path is a normal syscall.

**AGAINST:**
- Option defaults to N; smaller population.
- Not a crash/UAF/corruption.
- Series labeled 2/2 (sibling is unrelated and not required).
- Full lore review thread not readable (403/500).

**UNRESOLVED:** Full reviewer comments; any stable@ discussion.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — type/`vfs_setpos` logic is
   clear; author observed it on real hardware; maintainer merged.
2. Fixes a real bug that affects users? **PASS** — reproduced; tools
   cannot seek.
3. Important issue? **PASS** — HIGH: filesystem random-access completely
   broken for sparse/compressed files on this config (not a panic, but a
   serious functional failure).
4. Small and contained? **PASS** — 1 line, one file, one assignment.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — hunk matches
   `ntfs_init_from_boot()` here.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: `[None]` — ordinary bugfix, not a device-ID/quirk/DT/build/doc
exception.

**Step 9.4: MAKE YOUR DECISION**
This tree has the ntfs3 64-bit-cluster init path and
`ntfs_llseek()`/`ntfs_get_maxbytes()`. The signed `-1` max makes every
sparse/compressed seek fail. Replacing it with `MAX_LFS_FILESIZE` is the
right, minimal fix and meets stable rules.

---

### What the commit solves and why it matters here
On `CONFIG_NTFS3_64BIT_CLUSTER=y`, sparse/compressed files cannot be
seeked at all. That breaks archive managers and any random-access reader
while sequential copy still works. This checkout is 7.3, which already
has the 7.0 `ntfs_llseek` path, so the bug is in this codebase.

### Stable rules
Small, correct, user-reported functional failure, no new API, applies
cleanly.

### Risk vs benefit
Very low risk, high benefit for large NTFS volumes built with 64-bit
clusters.

### Concerns
Kconfig recommends N, so not every ntfs3 user. Patch 1/2 is not a
dependency. Residual `sbi->maxbytes = -1` overflow branch is a separate
edge case.

---

Verification:
- [Phase 1] Parsed commit `789af83e41aef`: SOB Senjin + maintainer
  Komarov; no Fixes/Cc stable/Reported-by
- [Phase 2] Diff: `sbi->maxbytes_sparse = -1` → `MAX_LFS_FILESIZE` in
  `ntfs_init_from_boot()`; 1 line
- [Phase 2] Confirmed `maxbytes_sparse` is `u64`; `ntfs_get_maxbytes()`
  returns `loff_t`; `vfs_setpos_cookie()` rejects `offset > maxsize`
- [Phase 2] Confirmed `ntfs_llseek()` and `ntfs_iomap_begin()` consume
  that value
- [Phase 3] `git blame`: `-1` from `82cae269cfa95` (v5.15-rc1);
  `ntfs_llseek` from `c613269677283` (v7.0-rc1)
- [Phase 3] `git merge-base --is-ancestor 789af83e41aef HEAD`: yes; in
  v7.3-rc1; not in v7.2/v7.1/v7.0
- [Phase 3] Series 1/2 `e31886cb6e0e1` touches `inode.c` only; not
  required
- [Phase 4] `b4 dig -c/-a/-w`: v2 2/2, maintainer+ntfs3 list CCed; lore
  fetch 403
- [Phase 4] LKML IU / Openwall: patch text matches; no NAK in those
  copies
- [Phase 4] UNVERIFIED: full lore thread, stable@ discussion
- [Phase 5] Callers: `ntfs_llseek` (syscall), `ntfs_iomap_begin`
  (fiemap)
- [Phase 6] `git describe HEAD`: `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion`: 7.3.0-rc4; current `super.c:1214` already has the fix
- [Phase 6] `CONFIG_NTFS3_64BIT_CLUSTER` in `fs/ntfs3/Kconfig`, 64-bit
  only
- [Phase 7] MAINTAINERS: Konstantin Komarov, Supported
- [Phase 8] Failure: every sparse/compressed `lseek` → `-EINVAL`;
  severity HIGH; trigger is normal userspace seek

**YES**

 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 346c52f952076..dcf14410c6621 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1163,7 +1163,7 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 #ifdef CONFIG_NTFS3_64BIT_CLUSTER
 	if (clusters >= (1ull << (64 - cluster_bits)))
 		sbi->maxbytes = -1;
-	sbi->maxbytes_sparse = -1;
+	sbi->maxbytes_sparse = MAX_LFS_FILESIZE;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 #else
 	/* Maximum size for sparse file. */
-- 
2.53.0

