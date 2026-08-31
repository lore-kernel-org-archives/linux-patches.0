Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCC95A3132;
	Mon, 31 Aug 2026 13:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184330; cv=none; b=LNduECmNMvXQ9WP1MV272mBnQ1vHS5qrvmilDftr09GaP6NdkhKrzAR5p+w2EGjN7si7/7+zg4fQpfoqyRcAWNXQJo+Vbpd+H6y4Itz9JIy8u4Rdag5xPaTXHePGr1onJkL3ae6QplcQoBHAmzxCf/s/JfQ4s1wFA0GWpnkb6I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184330; c=relaxed/simple;
	bh=PhNWb4A1YtuXaqB59mJJqXRhd4QjjVHMWQqM4OLs7/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NvFUCMeR2e7Hrig7FjKp/T3sdb/a5803r3R42Ba7nkn8812OT1ycDhHD3xPdQsc32ytXntJAcpFMMaeR+Nx9npdsFf59JVnBXHrYQT3JA1RqEW9y5NqwMHu/pA3FK6BN2xWpYYnla4Gi2BpySwoDwS97l60IxOC7l0x2FBfVCJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HcMMSmUy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HcMMSmUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD8A1F00ADE;
	Mon, 31 Aug 2026 13:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184328;
	bh=/BHNSQercJ1KBWP4/OvCJJfpKEPic8I6aXh57K7KDh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcMMSmUyuH84xJ0QIKYlTB9TpKLrmwf14PZ+CPdD2A/LeuZPMC29UBErTVHkSy7Qt
	 EbhT5H3xAcPXwnV9MewxyroB9mAsEbq/SmnCf7YUq/97gpw9rzP6WpllfX9qun04GA
	 eXWpLVrNk2rpEIPsO2SXK5ggURmDkBwhuwaI00lfdSccONQmPaK259K+yO/WzAWaBV
	 sY3M51TKWWPyEEmPjpe+Fiq8i5svY4p+6k0R13aJAGY6iQfEn0iGTaGZghNdMjmbsj
	 NlPrbGBOLweOL1W/cL1xoh0zHyRnkoxWI6k0rVk5Z4gRv8r8vlSc7t8y5Xw51HCmL9
	 P1kXvXrDgFQwQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Samuel Moelius <samuel.moelius@trailofbits.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] f2fs: validate inline dentry name lengths before conversion
Date: Mon, 31 Aug 2026 09:30:56 -0400
Message-ID: <20260831133314.4125787-628-sashal@kernel.org>
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

From: Samuel Moelius <sam.moelius@trailofbits.com>

[ Upstream commit cfcd0e49a178b3dac2c0ece656079081dbf5da74 ]

Inline dentry conversion copies names out of the inline dentry area
before checking that each recorded name length fits in the available
filename slots.

A corrupted image can therefore make the conversion path read past
the inline filename storage while building the regular dentry block.

Validate each inline dentry name length against the inline filename
area before copying it.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <samuel.moelius@trailofbits.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `f2fs: validate inline dentry name lengths
before conversion`

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`)
**Commit under review:** `cfcd0e49a178b3dac2c0ece656079081dbf5da74`
(mainline, **not** in this tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[f2fs] [validate] validate inline dentry name lengths
before conversion` — defensive validation on the inline-to-regular
dentry conversion path.

### Step 1.2: Parse all commit message tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** Chao Yu `<chao@kernel.org>` (f2fs maintainer)
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable@vger.kernel.org:** — absent (not a negative signal)
- **Signed-off-by:** Samuel Moelius (author), Jaegeuk Kim (f2fs
  maintainer merge)
- **Assisted-by:** Codex:gpt-5.5-cyber-preview
- **Notable:** Reviewed by subsystem maintainer; no syzbot report;
  security-research origin (Trail of Bits)

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** Inline dentry conversion uses `de->name_len` to set
  `fname.disk_name.len` and point at `d.filename[bit_pos]` before
  verifying the length fits in the inline filename area.
- **Symptom:** On a corrupted F2FS image, conversion can read past
  inline filename storage while building regular dentry blocks.
- **Root cause:** Missing bounds check on `name_len` and slot count vs.
  `d.max` in `f2fs_add_inline_entries()`.
- **Version info:** None in commit message.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — explicitly a corruption-handling / memory-
safety fix. Validates `name_len <= F2FS_NAME_LEN` and `bit_pos +
GET_DENTRY_SLOTS(name_len) <= d.max` before use.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `fs/f2fs/inline.c` (+7 / −0)
- **Functions:** `f2fs_add_inline_entries()` only
- **Scope:** Single-file surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (validation):** Before setting `fname.disk_name` from inline
  dentry metadata, check `name_len` and slot span. On failure: `err =
  -EFSCORRUPTED; goto punch_dentry_pages`.
- **Hunk 2 (blank line):** Cosmetic before `punch_dentry_pages` label.
- **Before:** Corrupted `name_len` propagated into
  `f2fs_add_regular_entry()` → `f2fs_update_dentry()` → `memcpy(...,
  name->len)`.
- **After:** Corruption detected early; partial conversion cleaned up
  via existing error path.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Buffer over-read / out-of-bounds read (memory safety on
  corrupted media)
- **Mechanism:** `f2fs_update_dentry()` does
  `memcpy(d->filename[bit_pos], name->name, name->len)`. With inflated
  `name_len`, the source pointer `d.filename[bit_pos]` in the inline
  area is read beyond allocated inline filename storage.

### Step 2.4: Fix quality
**Record:**
- Mirrors existing validation in `dir.c` readdir (lines 1013–1023).
- Uses `goto punch_dentry_pages` (better than v1's bare `return
  -EFSCORRUPTED`) to truncate partial work.
- Minimal, low regression risk; `-EFSCORRUPTED` is standard f2fs
  corruption handling.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:**
- `f2fs_add_inline_entries()` introduced in `675f10bde6cc3` (Feb 2016,
  "f2fs: fix to convert inline directory correctly").
- Bug present since inline dentry conversion was added; long-lived in
  6.18.y.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: File history for related changes
**Record:**
- Recent f2fs corruption fixes in this tree: `8aad54746c251` (orphan
  inode count), `ff83de56882cb` (ACL sizes), `ec9f79c8d5b28` (xattr
  entries), `4ce2d52f680c1` (inline xattr bounds).
- Pattern: f2fs stable tree regularly backports corruption-validation
  fixes.
- Standalone single patch; not part of a series.

### Step 3.4: Author's other commits
**Record:** Samuel Moelius has no other f2fs commits in this tree.
Security researcher submission, reviewed by maintainer.

### Step 3.5: Prerequisites
**Record:** No dependencies. Uses `F2FS_NAME_LEN`, `GET_DENTRY_SLOTS`,
`d.max` — all present in 6.18.44. `git apply --check` succeeds cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:**
- **b4 dig URL:** https://patch.msgid.link/20260603151141.15635-1-
  samuel.moelius@trailofbits.com
- **Series revisions:** v1 only (`b4 dig -a`)
- **Thread content:** Patch submission only; no replies, no NAKs, no
  explicit stable nomination in thread

### Step 4.2: Reviewers
**Record:** CC'd: Jaegeuk Kim, Chao Yu, linux-f2fs-devel, linux-kernel.
Reviewed-by: Chao Yu in final commit.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Issue identified via
code/security review (Trail of Bits).

### Step 4.4: Related patches
**Record:** Standalone; no series dependencies.

### Step 4.5: Stable mailing list
**Record:** Not searched on lore stable list; no stable discussion found
in patch thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `f2fs_add_inline_entries()` (modified); callers unchanged.

### Step 5.2: Callers
**Record:**
- `f2fs_move_rehashed_dirents()` → `do_convert_inline_dir()` (when
  `i_dir_level != 0`)
- Reachable from `f2fs_try_convert_inline_dir()`:
  - `f2fs_add_inline_entry()` when inline dir is full
  - `namei.c` rename path (`old_dir == new_dir && !new_inode`)

### Step 5.3: Callees
**Record:** On success path calls `f2fs_add_regular_entry()` →
`f2fs_update_dentry()` → `memcpy(..., name->len)`. Error path uses
existing `punch_dentry_pages` cleanup.

### Step 5.4: Reachability
**Record:**
- Triggered during normal filesystem operations (create, rename) on
  inline directories that must convert.
- Corrupted on-disk metadata is the trigger; mount + directory operation
  on malicious/corrupt image is the attack surface.
- Userspace-reachable via VFS syscalls on mounted F2FS.

### Step 5.5: Similar patterns
**Record:** `dir.c` lines 1013–1023 validate the same fields during
readdir. This conversion path was the missing check.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does buggy code exist?
**Record:** **Yes.** `fs/f2fs/inline.c:484–534` lacks validation; fix
not present (`git merge-base --is-ancestor cfcd0e49 HEAD` → exit 1). Bug
present since 2016.

### Step 6.2: Backport complications
**Record:** Clean apply verified (`git apply --check` exit 0). No
refactoring conflicts expected.

### Step 6.3: Related fixes already present?
**Record:** Readdir validation in `dir.c` exists; this specific
conversion-path gap does not. No duplicate fix in tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **f2fs filesystem** — IMPORTANT. F2FS is widely used
(Android, embedded, servers). Corruption handling affects data integrity
and kernel memory safety.

### Step 7.2: Subsystem activity
**Record:** Actively maintained; recent stable-relevant f2fs corruption
fixes in this 6.18.y tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of F2FS with inline directories (common for small
directories). Anyone mounting corrupted or attacker-crafted F2FS images.

### Step 8.2: Trigger conditions
**Record:**
- Corrupted inline dentry `name_len` or slot layout on disk
- Directory operation forcing inline→regular conversion (dir full,
  rename)
- Unprivileged user can trigger if they can mount/access the filesystem
  image

### Step 8.3: Failure mode severity
**Record:** Kernel out-of-bounds read from inline dentry area during
`memcpy`. Severity: **HIGH** (memory safety; potential info leak or
crash; corrupted-FS class bug consistent with other f2fs stable
backports).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — closes OOB read on realistic corruption/attack
  path
- **Risk:** VERY LOW — 7 lines, mirrors existing pattern, reviewed by
  maintainer
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug: OOB read on corrupted inline dentry during conversion
- Important: kernel memory safety on user-reachable VFS path
- Small, surgical, maintainer-reviewed
- Bug in tree since 2016; applies cleanly to 6.18.44
- Consistent with existing f2fs corruption-validation stable backports
- Matches validation already in `dir.c` readdir path

**AGAINST backport:**
- No user crash reports or syzbot reproduction
- Requires corrupted/malicious filesystem image (not a regression in
  normal operation)
- No explicit stable nomination in mailing list thread

**Unresolved:** No runtime crash trace or CVE assignment (not needed for
stable decision).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic mirrors `dir.c`;
   Reviewed-by maintainer
2. Fixes real bug? **PASS** — OOB read on corrupted metadata
3. Important issue? **PASS** — memory safety / corruption handling
   (HIGH)
4. Small and contained? **PASS** — 7 lines, 1 file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
corruption-validation bug fix.

### Step 9.4: Decision rationale
For Linux **6.18.44**, the vulnerable code is present and the fix is
absent. The patch closes a verified out-of-bounds read in inline dentry
conversion — a path reachable from normal directory operations on
corrupted F2FS images. It is minimal, maintainer-reviewed, matches
existing f2fs validation patterns, and applies cleanly. This is
appropriate stable material.

---

## Verification

- [Phase 1] Parsed commit message and tags from provided text and `git
  show cfcd0e49`
- [Phase 1] Confirmed Reviewed-by: Chao Yu; no Reported-by/syzbot/Fixes
  tags
- [Phase 2] Read diff: +7 lines validation + blank line in
  `f2fs_add_inline_entries()`
- [Phase 2] Read `f2fs_update_dentry()` at `dir.c:665` — `memcpy(...,
  name->len)` confirms OOB read mechanism
- [Phase 2] Read `F2FS_NAME_LEN` (255) and `GET_DENTRY_SLOTS` in
  `include/linux/f2fs_fs.h`
- [Phase 3] `git blame`: function from 2016 (`675f10bde6cc3`)
- [Phase 3] `git log --oneline -20 -- fs/f2fs/inline.c` and `-20 --
  fs/f2fs/`
- [Phase 3] `git apply --check` on patch: clean apply (exit 0)
- [Phase 4] `b4 dig -c cfcd0e49`: lore URL found
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: Jaegeuk Kim, Chao Yu, linux-f2fs-devel CC'd
- [Phase 4] Downloaded mbox: patch only, no review replies or stable
  nomination
- [Phase 5] Traced callers: `f2fs_move_rehashed_dirents` →
  `do_convert_inline_dir` → `f2fs_try_convert_inline_dir`
- [Phase 5] Read `namei.c:938` rename trigger path
- [Phase 5] Found similar validation in `dir.c:1013-1023`
- [Phase 6] `git describe HEAD`: 6.18.44
- [Phase 6] `git merge-base --is-ancestor cfcd0e49 HEAD`: exit 1 (fix
  NOT in tree)
- [Phase 6] Read current `inline.c:484-534`: buggy code confirmed
  present
- [Phase 6] `grep validate inline dentry`: no existing fix in tree
- [Phase 8] Confirmed `EFSCORRUPTED` is standard f2fs corruption return
  code

**YES****Verdict: YES** — backport to this tree (Linux 6.18.44).

The fix adds a 7-line bounds check in `f2fs_add_inline_entries()` before
inline dentry conversion. Without it, a corrupted F2FS image can make
the kernel read past inline filename storage during `memcpy` in
`f2fs_update_dentry()`. The bug has been present since 2016, the patch
applies cleanly, and it matches validation already done in the `dir.c`
readdir path. Chao Yu reviewed it.

 fs/f2fs/inline.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index ea5680406e23d..e2c8e5db25a2a 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -506,6 +506,12 @@ static int f2fs_add_inline_entries(struct inode *dir, void *inline_dentry)
 			bit_pos++;
 			continue;
 		}
+		if (unlikely(le16_to_cpu(de->name_len) > F2FS_NAME_LEN ||
+			     bit_pos + GET_DENTRY_SLOTS(le16_to_cpu(de->name_len)) >
+			     d.max)) {
+			err = -EFSCORRUPTED;
+			goto punch_dentry_pages;
+		}
 
 		/*
 		 * We only need the disk_name and hash to move the dentry.
@@ -526,6 +532,7 @@ static int f2fs_add_inline_entries(struct inode *dir, void *inline_dentry)
 		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 	}
 	return 0;
+
 punch_dentry_pages:
 	truncate_inode_pages(&dir->i_data, 0);
 	f2fs_truncate_blocks(dir, 0, false);
-- 
2.53.0

