Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E0B43B48D;
	Mon, 31 Aug 2026 13:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183219; cv=none; b=UOmDzq3ju3GV4TPMH0kv2hhOR+PO1nWmbYMO74P3FpJEKJFfyumTwKUsF3Svm3YNVnRRcXY/MqHZwHlsGiUCBWtdqV4uOi52xbUZB1OvYJZnfKSpCEAxWNBUjSZCOyzkFX8y0kHYn6tel14lplg/E4Qn76zP14p/t3MniT12LwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183219; c=relaxed/simple;
	bh=p1qATjbL3auARJbN7KAqGjdc/w7Xup74OTjUZ56BNqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GYs/cFm1HRnBOhIW4Vhv0U6GPPQaVxVGC5aOy+pmkts8Ou7i6wedQvM9PAEY0cYQ7qgwkwHvmfTrmGXSd1vraGGsiELg1Hf1MUyXR7HacyAL5N3JbFYJ7waPMWArcI14raZH/DPnSCm0wARVOjINS0WmweTBfs+JGOh8MINlufg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CKHJP/Kc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CKHJP/Kc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066131F00A3F;
	Mon, 31 Aug 2026 13:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183215;
	bh=2PQ4t6svgmCFZdaM/dcvEVvPOrzQymWTx+ThL75m5uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKHJP/Kcgeoai/bpR8n8MMIfUFMW90jdwJtjQoKHbvGyVoizJDLTwMrL4klQDtuMy
	 kUdXFgpNchQoPE/NxLtjt0wU+Xi1pIS9L2V3F9OpHkfENRVe2WtUszGIGfnO8E3UOA
	 OnK6sMaBmTpF/F0labnRmW14KtiEJjp+tGvk04j2hR1WfyJ4XbK67izhS63E+GnIQj
	 fKNhf9DOptM66y/v3v8CoTH/Xn25flwK3CqNQA8YhFlZ+4nMELdxW0pJcMo3WsEC24
	 AHWSHZIy9dEw2xopsXjuZYYvc6lKsVBfpLE/2hj3XZWbyGDXxunHkHEu4k+blhO356
	 y2vYklQpsnaeQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Viacheslav Dubeyko <slava@dubeyko.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	linux-fsdevel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] hfs: rework hfsplus_readdir() logic
Date: Mon, 31 Aug 2026 09:20:42 -0400
Message-ID: <20260831133314.4125787-14-sashal@kernel.org>
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

From: Viacheslav Dubeyko <slava@dubeyko.com>

[ Upstream commit 7fde7e806657fbe0d33f489521b488eed94f9b39 ]

The xfstests' test-case generic/637 fails with error:

FSTYP -- hfs
PLATFORM -- Linux/x86_64 kvm-xfstests 6.15.0-rc4-xfstests-g00b827f0cffa #1 SMP PREEMPT_DYNAMIC Fri May 25
MKFS_OPTIONS -- /dev/vdc
MOUNT_OPTIONS -- /dev/vdc /vdc

QA output created by 637
entries 7 and 8 have duplicate d_off 8
Found unlinked files in open dir (see xfstests-dev/results//generic/637.full for details)

Likewise HFS+, currently, HFS has very complicated and
fragile logic of rd->file->f_pos correction in hfs_delete_cat().
This patch removes this logic and it stores the current
pos into hfs_readdir_data. Finally, if rd->pos == ctx->pos
then hfs_readdir() tries to find the position in
b-tree's node by means of hfs_cat_key. This position is
used to re-start the folder's content traversal.

sudo ./check generic/637
FSTYP         -- hfs
PLATFORM      -- Linux/x86_64 hfsplus-testing-0001 7.1.0-rc1+ #55 SMP PREEMPT_DYNAMIC Tue May 19 15:18:02 PDT 2026
MKFS_OPTIONS  -- /dev/loop51
MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch

generic/637  32s ...  31s
Ran: generic/637
Passed all 1 tests

Closes: https://github.com/hfs-linux-kernel/hfs-linux-kernel/issues/65
cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
cc: Yangtao Li <frank.li@vivo.com>
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260519222811.1311071-2-slava@dubeyko.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `hfs: rework hfsplus_readdir() logic`

**Local tree:** `v6.18.44` (Makefile: VERSION=6, PATCHLEVEL=18,
SUBLEVEL=44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[hfs] [rework] Rework directory readdir resume logic
(subject incorrectly references hfsplus_readdir; diff is HFS-only)`

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — absent (expected for manual review)
- **Reported-by:** — absent
- **Tested-by:** — absent
- **Reviewed-by / Acked-by:** — absent
- **Link:**
  https://lore.kernel.org/r/20260519222811.1311071-2-slava@dubeyko.com
- **Closes:** https://github.com/hfs-linux-kernel/hfs-linux-
  kernel/issues/65
- **cc:** John Paul Adrian Glaubitz, Yangtao Li, linux-
  fsdevel@vger.kernel.org
- **Signed-off-by:** Viacheslav Dubeyko (author)
- **Notable:** Message-ID suffix `-2-` indicates patch 2 of a series;
  companion patch 1 fixes HFS+ separately. No syzbot, no Cc: stable tag.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** xfstests `generic/637` fails on HFS with `entries 7 and 8
  have duplicate d_off 8` and `Found unlinked files in open dir`.
- **Symptom:** Incorrect `getdents`/`readdir` results — duplicate
  directory offsets and deleted entries visible in an open directory.
- **Root cause (author):** Fragile `rd->file->f_pos--` correction in
  `hfs_cat_delete()` when entries are removed while a directory is open
  for reading.
- **Fix approach:** Store `ctx->pos` and catalog key in
  `hfs_readdir_data`; on resume, if `rd->pos == ctx->pos`, locate
  position via `hfs_cat_key` instead of positional `hfs_brec_goto()`.
- **Testing:** Author reports `generic/637` passes after fix.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — this is an explicit correctness fix for
directory enumeration, though the subject says "rework" rather than
"fix".

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
| File | Change |
|------|--------|
| `fs/hfs/catalog.c` | -9 lines (remove f_pos correction loop) |
| `fs/hfs/dir.c` | ~28 lines changed (key-based resume, simplify
release) |
| `fs/hfs/hfs.h` | struct `hfs_readdir_data` simplified |
| `fs/hfs/hfs_fs.h` | remove `open_dir_list`, `open_dir_lock` |
| `fs/hfs/inode.c` | -4 lines (remove list/lock init) |

**Functions modified:** `hfs_cat_delete()`, `hfs_readdir()`,
`hfs_dir_release()`, `hfs_new_inode()`, `hfs_read_inode()`

**Scope:** Single-subsystem, 5 files, net -22 lines (12 insertions, 34
deletions). Surgical refactor that fixes a bug.

### Step 2.2: CODE FLOW CHANGE
**Record:**

**Hunk 1 — `hfs_cat_delete()`:** BEFORE: on delete, iterate all open
readdir handles and decrement `f_pos` for entries after the deleted key.
AFTER: no f_pos manipulation.

**Hunk 2 — `hfs_readdir()` resume:** BEFORE: always `hfs_brec_goto(&fd,
ctx->pos - 1)`. AFTER: if saved `rd->pos == ctx->pos`, use stored
`hfs_cat_key` with `hfs_brec_find()` (fallback `hfs_brec_goto(&fd, 1)`
on `-ENOENT`); else positional goto.

**Hunk 3 — `hfs_readdir()` state save:** BEFORE: track open dirs in per-
inode linked list with spinlock; save only key. AFTER: save `rd->pos =
ctx->pos` and key in per-file `private_data`.

**Hunk 4 — `hfs_dir_release()`:** BEFORE: remove from linked list under
spinlock, then kfree. AFTER: simple kfree.

**Hunk 5 — struct cleanup:** Remove `list`, `file` from
`hfs_readdir_data`; add `loff_t pos`. Remove
`open_dir_list`/`open_dir_lock` from `hfs_inode_info`.

### Step 2.3: BUG MECHANISM
**Record:** **Category:** Logic/correctness fix in directory
enumeration.

**Mechanism:** When `readdir` is interrupted mid-directory (e.g., small
userspace buffer), the saved position and the catalog key can diverge
from a naïve positional index after concurrent unlinks. The old
`f_pos--` hack in `hfs_cat_delete()` fails to maintain consistency,
causing:
1. Duplicate `d_off` values returned to userspace
2. Deleted ("unlinked") files appearing in directory listings

The companion HFS+ patch (`fc30ae43b8b5b`) documents the exact failure
sequence with debug output confirming this mechanism.

### Step 2.4: FIX QUALITY
**Record:**
- **Obviously correct:** Yes — key-based resume is the standard
  approach; removes complex cross-file f_pos tracking.
- **Minimal:** Yes — net code reduction, no unrelated changes.
- **Regression risk:** Low — simplifies locking (removes spinlock/list
  entirely for this path). The `-ENOENT` → `hfs_brec_goto(&fd, 1)`
  fallback handles deleted-key edge case.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:**
- `f_pos--` logic in `hfs_cat_delete()`: original git import
  (`1da177e4c3f4`, 2005)
- `open_dir_lock`/`list_for_each_entry`: Al Viro, `9717a91b01feda`
  ("hfs: switch to ->iterate_shared()", 2016)
- Bug has been present essentially since HFS support was added; not a
  recent regression.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag present — N/A.

### Step 3.3: FILE HISTORY FOR RELATED CHANGES
**Record:**
- `eec11535ca3d3` — prior `hfs: fix hfs_readdir()` (memcpy bug in key
  save, reviewed by Dubeyko)
- `9717a91b01feda` — iterate_shared conversion added open_dir_list
  mechanism
- `956b1d8051cfa`, `54694417d4384` — same author's HFS+ xfstests fixes
  already in this 6.18.y tree
- Fix commit `7fde7e806657f` exists locally on `autosel` branch but is
  **not** an ancestor of HEAD (6.18.44)

### Step 3.4: AUTHOR'S OTHER COMMITS
**Record:** Viacheslav Dubeyko is an active HFS/HFS+ maintainer with
multiple xfstests-driven fixes backported to stable (generic/498,
generic/480, generic/101, etc.).

### Step 3.5: DEPENDENT/PREREQUISITE COMMITS
**Record:** Standalone for HFS. Companion `hfsplus: rework
hfsplus_readdir() logic` is a separate commit for HFS+; this HFS patch
does not depend on it. Applies cleanly to current tree (`git apply
--check` passed).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: ORIGINAL PATCH DISCUSSION
**Record:**
- **b4 dig -c 7fde7e806657f:**
  https://patch.msgid.link/20260519222811.1311071-2-slava@dubeyko.com
- **Series revisions (b4 dig -a):** v1 only (single revision)
- **Review feedback:** Mbox contains only the patch submission — no
  replies, no stable nominations, no NAKs in thread

### Step 4.2: WHO REVIEWED
**Record (b4 dig -w):** CC'd: Viacheslav Dubeyko, glaubitz@physik.fu-
berlin.de, linux-fsdevel@vger.kernel.org, frank.li@vivo.com,
Slava.Dubeyko@ibm.com. No explicit Reviewed-by in commit or thread.

### Step 4.3: BUG REPORT
**Record:**
- **GitHub issue #65:** 100% failure rate on `generic/637` for HFS (5/5
  runs), kernel 6.15.0-rc4-xfstests. Closed after fix reference.
- **Failure:** duplicate d_off, unlinked files in open directory —
  reproducible, concrete.

### Step 4.4: RELATED PATCHES AND SERIES
**Record:** 2-patch series sent separately:
1. `hfsplus: rework hfsplus_readdir() logic` (upstream `4b04964328446`)
2. `hfs: rework hfsplus_readdir() logic` (upstream `7fde7e806657f`) —
   **this commit**

Each is self-contained for its respective filesystem.

### Step 4.5: STABLE MAILING LIST HISTORY
**Record:** Lore fetch blocked by bot protection; no stable-list
discussion found via b4 or GitHub.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: KEY FUNCTIONS
**Record:** `hfs_readdir()`, `hfs_cat_delete()`, `hfs_dir_release()`

### Step 5.2: TRACE CALLERS
**Record:**
- `hfs_readdir()` — VFS `iterate_shared` callback; reachable from
  `getdents`/`readdir` syscalls on HFS mounts
- `hfs_cat_delete()` — called from `hfs_remove()` (unlink/rmdir),
  reachable from `unlink`/`rmdir` syscalls
- **Trigger path:** open directory → partial readdir → concurrent unlink
  → resume readdir

### Step 5.3: TRACE CALLEES
**Record:** `hfs_brec_goto()`, `hfs_brec_find()`, `hfs_brec_remove()`,
`dir_emit()`, `kmalloc()`, `kfree()`, `hfs_find_init()/exit()`

### Step 5.4: CALL CHAIN / REACHABILITY
**Record:** Fully reachable from userspace via standard VFS syscalls on
`CONFIG_HFS_FS` mounts. Not init-only or obscure kernel-internal path.

### Step 5.5: SIMILAR PATTERNS
**Record:** Identical `f_pos--` pattern exists in `fs/hfsplus/catalog.c`
(lines 394-402) — fixed by companion patch. Same structural bug in both
filesystems.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST?
**Record:** **YES.** Current 6.18.44 tree has:
- `f_pos--` loop in `hfs_cat_delete()` at `fs/hfs/catalog.c:369-375`
- `open_dir_list`/`open_dir_lock` in `hfs_inode_info`
- Positional-only resume in `hfs_readdir()` at `fs/hfs/dir.c:100`

Bug present since original HFS code (~2005).

### Step 6.2: BACKPORT COMPLICATIONS
**Record:** **Clean apply expected.** `git apply --check` against
`7470b727ac4b2` diff succeeded with no conflicts. Uses
`kmalloc(sizeof(...))` matching current tree (not `kmalloc_obj` from the
candidate diff text).

### Step 6.3: RELATED FIXES ALREADY PRESENT?
**Record:** No — fix not in 6.18.44. Related HFS+ xfstests fixes from
same author (generic/498, etc.) are present, establishing precedent for
this class of fix.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM AND CRITICALITY
**Record:** **Filesystem (HFS)** — IMPORTANT for HFS users; PERIPHERAL
in overall kernel scope (legacy Mac filesystem, niche but real user
base).

### Step 7.2: SUBSYSTEM ACTIVITY
**Record:** Active maintenance by Dubeyko — multiple recent xfstests-
driven fixes in 6.18.y.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
**Record:** Users with HFS filesystems mounted (`CONFIG_HFS_FS`).
Includes legacy media, cross-platform data exchange, testing
environments.

### Step 8.2: TRIGGER CONDITIONS
**Record:**
- Directory open for reading
- Partial `readdir`/`getdents` (buffer fills before directory exhausted)
- Concurrent file deletion in same directory
- **Likelihood:** Moderate for backup tools, file managers, `find`-like
  utilities
- **Unprivileged trigger:** Yes — any user with directory access

### Step 8.3: FAILURE MODE SEVERITY
**Record:**
- **Failure:** Wrong directory entries (duplicate offsets, deleted files
  visible)
- **Severity:** **HIGH** for filesystem semantics — not a kernel oops,
  but violates POSIX directory consistency expectations; can cause
  application-level data handling errors
- Comparable to other xfstests generic/ fixes backported from this
  subsystem

### Step 8.4: RISK-BENEFIT RATIO
**Record:**
- **Benefit:** HIGH for HFS users — fixes reproducible xfstests failure
  and real directory listing corruption
- **Risk:** LOW — net code simplification, removes locking, tested with
  xfstests
- **Ratio:** Strongly favorable

**Minor note:** Full patch with context is ~137 lines; stable rules
mention 100-line guideline, but actual changed lines are only 46 with
net reduction.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE COMPILED

**FOR backport:**
- Reproducible xfstests `generic/637` failure (100% repro rate in GitHub
  issue)
- Real user-visible directory listing bug (duplicate d_off, ghost
  entries)
- Bug present in 6.18.44 tree since ~2005
- Small, obviously correct fix (key-based resume)
- Applies cleanly to local tree
- Tested by author with xfstests
- Same author's similar HFS+ xfstests fixes already in 6.18.y
- Reachable from userspace syscalls
- Net code simplification reduces regression surface

**AGAINST backport:**
- HFS is niche (limited user base)
- No formal Reviewed-by or stable nomination in mailing list thread
- Not a crash/oops — semantics bug rather than kernel panic
- Patch context slightly exceeds 100-line stable guideline (borderline)
- HFS+ companion patch needed separately for full generic/637 coverage
  on HFS+

**UNRESOLVED:**
- No mailing list review replies found (thread had no responses in saved
  mbox)
- Could not fetch lore directly (bot protection)

### Step 9.2: STABLE RULES CHECKLIST

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — xfstests generic/637,
clear mechanism |
| 2. Fixes real bug affecting users? | **PASS** — reproducible directory
listing corruption |
| 3. Important issue? | **PASS** — filesystem correctness, HIGH severity
for HFS users |
| 4. Small and contained? | **PASS** — 46 lines changed, 5 files, net
-22 lines |
| 5. No new features/APIs? | **PASS** — internal restructuring only |
| 6. Can apply to local tree? | **PASS** — clean apply verified |

### Step 9.3: EXCEPTION CATEGORIES
**Record:** None — standard bug fix, not device ID/quirk/build fix.

### Step 9.4: DECISION RATIONALE

For **6.18.44**, this commit fixes a long-standing, reproducible
directory enumeration bug in the HFS driver. The failure mode —
duplicate `d_off` values and deleted files appearing in open directory
listings — is a real filesystem correctness issue validated by xfstests
and a tracked GitHub issue. The fix is surgical, simplifies the code by
removing fragile `f_pos` manipulation, applies cleanly, and follows the
established pattern of xfstests-driven HFS/HFS+ fixes from this
maintainer already present in the 6.18.y tree.

---

## Verification

- **[Phase 1]** Parsed commit message: subject, Link, Closes, cc tags;
  no Fixes:/Reported-by:/Reviewed-by:
- **[Phase 1]** GitHub issue #65 fetched: 100% generic/637 failure on
  HFS, duplicate d_off 8, unlinked files
- **[Phase 2]** Read current `fs/hfs/dir.c`, `fs/hfs/catalog.c`,
  `fs/hfs/hfs.h`, `fs/hfs/hfs_fs.h` — confirmed buggy code
- **[Phase 2]** Diff analysis: 5 files, 12+/34-, functions identified
- **[Phase 3]** `git describe HEAD`: v6.18.44
- **[Phase 3]** `git blame fs/hfs/catalog.c:369-375`: f_pos-- from 2005,
  lock from Al Viro 2016
- **[Phase 3]** `git log --oneline -30 -- fs/hfs/dir.c`: recent history
  reviewed
- **[Phase 3]** `git merge-base --is-ancestor 7470b727ac4b2 HEAD`: exit
  1 — fix NOT in tree
- **[Phase 3]** `git show 956b1d8051cfa`: prior xfstests fix from same
  author in tree
- **[Phase 4]** `b4 dig -c 7fde7e806657f`: found lore thread, v1 only
- **[Phase 4]** `b4 dig -c 7fde7e806657f -w`: recipients listed, no
  Reviewed-by
- **[Phase 4]** `b4 dig -c 7fde7e806657f -m /tmp/hfs637.mbox`: saved, no
  review replies
- **[Phase 4]** Lore.kernel.org WebFetch: blocked by bot protection
- **[Phase 5]** `grep hfs_cat_delete/hfs_readdir`: callers traced to VFS
  syscall paths
- **[Phase 5]** Read `fs/hfsplus/catalog.c:394-402`: confirmed identical
  bug pattern in HFS+
- **[Phase 6]** `grep open_dir_list` in fs/hfs/: buggy code confirmed
  present
- **[Phase 6]** `git apply --check` against fix diff: **clean apply**
- **[Phase 6]** `git show 7470b727ac4b2:fs/hfs/dir.c | rg kmalloc`: uses
  `kmalloc(sizeof(...))` matching tree
- **[Phase 8]** Failure mode: directory listing corruption, HIGH
  severity for HFS users

**YES**The background search finished successfully. It found the fix on
the `autosel` branch (`7470b727ac4b2` for HFS, `fc30ae43b8b5b` for
HFS+), but neither commit is in the current **6.18.44** tree — the buggy
`f_pos--` logic is still present there.

The analysis stands: **YES** for backporting this HFS commit to 6.18.y.
It fixes a real `generic/637` directory listing bug, applies cleanly,
and the HFS+ companion patch would need a separate backport decision.

 fs/hfs/catalog.c |  9 ---------
 fs/hfs/dir.c     | 28 +++++++++++-----------------
 fs/hfs/hfs.h     |  3 +--
 fs/hfs/hfs_fs.h  |  2 --
 fs/hfs/inode.c   |  4 ----
 5 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/fs/hfs/catalog.c b/fs/hfs/catalog.c
index b80ba40e38776..ccdbbffaaf7c1 100644
--- a/fs/hfs/catalog.c
+++ b/fs/hfs/catalog.c
@@ -340,7 +340,6 @@ int hfs_cat_delete(u32 cnid, struct inode *dir, const struct qstr *str)
 {
 	struct super_block *sb;
 	struct hfs_find_data fd;
-	struct hfs_readdir_data *rd;
 	int res, type;
 
 	hfs_dbg("name %s, cnid %u\n", str ? str->name : NULL, cnid);
@@ -366,14 +365,6 @@ int hfs_cat_delete(u32 cnid, struct inode *dir, const struct qstr *str)
 		}
 	}
 
-	/* we only need to take spinlock for exclusion with ->release() */
-	spin_lock(&HFS_I(dir)->open_dir_lock);
-	list_for_each_entry(rd, &HFS_I(dir)->open_dir_list, list) {
-		if (fd.tree->keycmp(fd.search_key, (void *)&rd->key) < 0)
-			rd->file->f_pos--;
-	}
-	spin_unlock(&HFS_I(dir)->open_dir_lock);
-
 	res = hfs_brec_remove(&fd);
 	if (res)
 		goto out;
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index 86a6b317b474a..130c2f3a417f0 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -97,7 +97,15 @@ static int hfs_readdir(struct file *file, struct dir_context *ctx)
 	}
 	if (ctx->pos >= inode->i_size)
 		goto out;
-	err = hfs_brec_goto(&fd, ctx->pos - 1);
+	rd = file->private_data;
+	if (rd && rd->pos == ctx->pos) {
+		memcpy(fd.search_key, &rd->key, sizeof(struct hfs_cat_key));
+		err = hfs_brec_find(&fd);
+		if (err == -ENOENT)
+			err = hfs_brec_goto(&fd, 1);
+	} else {
+		err = hfs_brec_goto(&fd, ctx->pos - 1);
+	}
 	if (err)
 		goto out;
 
@@ -146,7 +154,6 @@ static int hfs_readdir(struct file *file, struct dir_context *ctx)
 		if (err)
 			goto out;
 	}
-	rd = file->private_data;
 	if (!rd) {
 		rd = kmalloc(sizeof(struct hfs_readdir_data), GFP_KERNEL);
 		if (!rd) {
@@ -154,15 +161,8 @@ static int hfs_readdir(struct file *file, struct dir_context *ctx)
 			goto out;
 		}
 		file->private_data = rd;
-		rd->file = file;
-		spin_lock(&HFS_I(inode)->open_dir_lock);
-		list_add(&rd->list, &HFS_I(inode)->open_dir_list);
-		spin_unlock(&HFS_I(inode)->open_dir_lock);
 	}
-	/*
-	 * Can be done after the list insertion; exclusion with
-	 * hfs_delete_cat() is provided by directory lock.
-	 */
+	rd->pos = ctx->pos;
 	memcpy(&rd->key, &fd.key->cat, sizeof(struct hfs_cat_key));
 out:
 	hfs_find_exit(&fd);
@@ -171,13 +171,7 @@ static int hfs_readdir(struct file *file, struct dir_context *ctx)
 
 static int hfs_dir_release(struct inode *inode, struct file *file)
 {
-	struct hfs_readdir_data *rd = file->private_data;
-	if (rd) {
-		spin_lock(&HFS_I(inode)->open_dir_lock);
-		list_del(&rd->list);
-		spin_unlock(&HFS_I(inode)->open_dir_lock);
-		kfree(rd);
-	}
+	kfree(file->private_data);
 	return 0;
 }
 
diff --git a/fs/hfs/hfs.h b/fs/hfs/hfs.h
index 6f194d0768b6f..f46d12ce04a3f 100644
--- a/fs/hfs/hfs.h
+++ b/fs/hfs/hfs.h
@@ -281,8 +281,7 @@ struct hfs_mdb {
 /*======== Data structures kept in memory ========*/
 
 struct hfs_readdir_data {
-	struct list_head list;
-	struct file *file;
+	loff_t pos;
 	struct hfs_cat_key key;
 };
 
diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index 38854df4c1b42..d9665226f5474 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -37,8 +37,6 @@ struct hfs_inode_info {
 
 	struct hfs_cat_key cat_key;
 
-	struct list_head open_dir_list;
-	spinlock_t open_dir_lock;
 	struct inode *rsrc_inode;
 
 	struct mutex extents_lock;
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index cd43eff72d13d..cd3dd5bd456e0 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -192,8 +192,6 @@ struct inode *hfs_new_inode(struct inode *dir, const struct qstr *name, umode_t
 		return NULL;
 
 	mutex_init(&HFS_I(inode)->extents_lock);
-	INIT_LIST_HEAD(&HFS_I(inode)->open_dir_list);
-	spin_lock_init(&HFS_I(inode)->open_dir_lock);
 	hfs_cat_build_key(sb, (btree_key *)&HFS_I(inode)->cat_key, dir->i_ino, name);
 	next_id = atomic64_inc_return(&HFS_SB(sb)->next_id);
 	BUG_ON(next_id > U32_MAX);
@@ -334,8 +332,6 @@ static int hfs_read_inode(struct inode *inode, void *data)
 	HFS_I(inode)->flags = 0;
 	HFS_I(inode)->rsrc_inode = NULL;
 	mutex_init(&HFS_I(inode)->extents_lock);
-	INIT_LIST_HEAD(&HFS_I(inode)->open_dir_list);
-	spin_lock_init(&HFS_I(inode)->open_dir_lock);
 
 	/* Initialize the inode */
 	inode->i_uid = hsb->s_uid;
-- 
2.53.0

