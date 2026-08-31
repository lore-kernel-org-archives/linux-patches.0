Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E914A482E;
	Mon, 31 Aug 2026 13:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183806; cv=none; b=eUG/NFbIjzRZBG6/6QQYEIzicmbZe2mQh4JXMofH7qdJjQCpZlcQ4GOjIC8pP6UgD35DYfDM/sovldtrKfWTd2Yks7vRlz5iyEW3EK/gqgzIk6rQkPhFR7KzxjN46JTgiUr/A/drCQKfFPVh+0Gk1VDrkfH54fpF71YmvM3kYGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183806; c=relaxed/simple;
	bh=aanHgtxrOkFo7na4bjAtowsl2AtJOHOCqqst0oTQv/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gGFWYbLOAX20bpGUXiXHofUpksBH/qx71nYMAoeKdviaUhPxsvpNxJnqQJQ5MNX/06vTt1rZ8fAz++bV5gpuMMr3Mi9PYOjb3RUr4Y9RpCILUVS7cJhKim4ZEEi6DpbY8GS802RFpuw2sPmm5y5JHBnKY2bVvy4ABAmz20r39NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nFNv1QKJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nFNv1QKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56BF1F00ADE;
	Mon, 31 Aug 2026 13:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183802;
	bh=6TRf/5aQD6QV4DyyjHPwPS1ZwpW1Ix0XV6VA48lecg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFNv1QKJph7HxIxxevCQYahk8y+3NDRot5QWtkIy+cOWIjrhgHeViGYac9eWG2BT1
	 foyzjHhTx5Ba4gWuEL7g1TbeWGTXDV4FNicaEwRb+x1BduwLlaF1Ifb8NPxqd34KId
	 53hUQsoi08G8id+xYJWlP3lfDVfLhvQ+7RA4l2L+3FtnF2ST1jAupt+2eYd5kgKTfv
	 9EyJqYGVvknqNfqyv4VsWZonPgyfx5Meb97L9Zzn90QMjIwjOBWTej8TkWWRzQjSx9
	 BtaTP1mygtfOuSkDhJDrJPBiQwgORs5E5M/3HkGIJFJS+GMP4lUmqw8W302VKhfpak
	 YXk/Xu8Je4pzg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matteo Croce <technoboy85@gmail.com>,
	Timothy Redaelli <tredaelli@redhat.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Matteo Croce <teknoraver@meta.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] fat: stop reading directory entries past the end-of-directory marker
Date: Mon, 31 Aug 2026 09:25:41 -0400
Message-ID: <20260831133314.4125787-313-sashal@kernel.org>
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

From: Matteo Croce <technoboy85@gmail.com>

[ Upstream commit 6a2875517c778ac1111b6920e94cbab91cda8724 ]

The FAT specification[1] (FAT Directory Structure -> "DIR_Name[0]") states:

    If DIR_Name[0] == 0x00, then the directory entry is free (same as for
    0xE5), and there are no allocated directory entries after this one
    (all of the DIR_Name[0] bytes in all of the entries after this one
    are also set to 0).

    The special 0 value, rather than the 0xE5 value, indicates to FAT
    file system driver code that the rest of the entries in this
    directory do not need to be examined because they are all free.

Linux did not honour this. fat_get_entry() kept advancing past the 0x00
terminator; if the trailing on-disk slots were not zero-filled (buggy
formatters, read-only media written by other operating systems, on-disk
corruption) the driver surfaced arbitrary bytes as real directory
entries. On a typical affected image, `ls /mnt` returns ~150 bogus
entries with random binary names, multi-gigabyte sizes, dates ranging
from 1980 to 2106, and a flood of -EIO from stat().

Earlier attempts (v1..v3, see [2][3][4]) added `de->name[0] == 0` guards
at each call site. As Hirofumi pointed out on v3, those guards reject
the entry but fat_get_entry() has already advanced *pos past it; the
next readdir() resumes after the marker and walks straight back into
the garbage. His suggestion was to centralise the check.

This patch:

  * Adds fat_get_entry_eod(), a small wrapper around fat_get_entry()
    that returns -1 when name[0] == 0 and seeks *pos to dir->i_size.
    Per spec every slot after the 0x00 marker is also zero, so jumping
    to the end of the directory is correct: subsequent reads return -1
    from fat_bmap() without re-fetching trailing zero slots, and
    callers persisting *pos across invocations (notably readdir's
    ctx->pos) keep reporting end-of-directory on re-entry.

  * Converts the read/search paths to use the new wrapper:
      fat_parse_long(), fat_search_long(), __fat_readdir(),
      and fat_get_short_entry() -- the last covers
      fat_get_dotdot_entry(), fat_dir_empty(), fat_subdirs(),
      fat_scan(), and fat_scan_logstart() transitively.

  * Leaves fat_add_entries() and __fat_remove_entries() on raw
    fat_get_entry(): the write paths legitimately need to operate on
    free/zero slots. fat_add_entries() additionally detects an
    allocated entry past a 0x00 marker (the spec violation that
    produces the garbage) and treats it as filesystem corruption:
    fat_fs_error_ratelimit() is called -- which honours the configured
    errors= mount option (panic / remount-ro / continue) -- and the
    operation returns -EIO so we don't write fresh entries into an
    already-corrupt directory.

[1] https://download.microsoft.com/download/1/6/1/161ba512-40e2-4cc9-843a-923143f3456c/fatgen103.doc
[2] https://lore.kernel.org/lkml/20181207013410.7050-1-mcroce@redhat.com/
[3] https://lore.kernel.org/lkml/20181216231510.26854-1-mcroce@redhat.com/
[4] https://lore.kernel.org/lkml/20190201001408.7453-1-mcroce@redhat.com/

Reported-by: Timothy Redaelli <tredaelli@redhat.com>
Suggested-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Matteo Croce <teknoraver@meta.com>
Link: https://patch.msgid.link/20260616163346.32603-1-technoboy85@gmail.com
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `fat: stop reading directory entries past
the end-of-directory marker`

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[fat]` `[stop]` — FAT filesystem driver; stop directory
iteration past the FAT end-of-directory (EOD) marker (`DIR_Name[0] ==
0x00`).

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
| Tag | Value |
|-----|-------|
| Reported-by | Timothy Redaelli \<tredaelli@redhat.com\> |
| Suggested-by | OGAWA Hirofumi \<hirofumi@mail.parknet.co.jp\> (FAT
maintainer) |
| Signed-off-by | Matteo Croce \<teknoraver@meta.com\> (author) |
| Link |
https://patch.msgid.link/20260616163346.32603-1-technoboy85@gmail.com |
| Acked-by | OGAWA Hirofumi \<hirofumi@mail.parknet.co.jp\> |
| Signed-off-by | Christian Brauner (Amutable) \<brauner@kernel.org\>
(VFS maintainer merge) |

**Notable patterns:** Real user report from Red Hat; subsystem
maintainer Acked-by and Suggested-by; references to earlier v1–v3
attempts (2018–2019). No syzbot, no Fixes: tag (expected for manual
review).

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** Linux `fat_get_entry()` does not honor the FAT spec EOD
  marker. After `name[0] == 0`, iteration continues into trailing
  directory slots.
- **Symptom:** On non-spec-compliant images (buggy formatters, other
  OSes, corruption), `ls` shows ~150 bogus entries with random binary
  names, multi-GB sizes, invalid dates; `stat()` floods `-EIO`.
- **Root cause:** Per FAT spec, `name[0] == 0` means no allocated
  entries follow; Linux kept scanning. Prior per-call-site guards were
  insufficient because `fat_get_entry()` had already advanced `*pos`
  past the marker.
- **Fix approach:** Centralize EOD handling in `fat_get_entry_eod()`;
  use it on read/search paths; keep write paths on raw
  `fat_get_entry()`; detect spec violations on write in
  `fat_add_entries()`.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — this is an explicit filesystem correctness
bug fix, though described in terms of spec compliance rather than "fix
crash."

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **File:** `fs/fat/dir.c` only (~65 lines added/changed)
- **Functions modified/added:**
  - **Added:** `fat_get_entry_eod()`
  - **Modified call sites:** `fat_parse_long()`, `fat_search_long()`,
    `__fat_readdir()`, `fat_get_short_entry()`, `fat_add_entries()`
- **Scope:** Single-file surgical fix

### Step 2.2: CODE FLOW CHANGE (per hunk)
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| `fat_get_entry_eod()` (new) | N/A | Wraps `fat_get_entry()`; on
`name[0]==0`, releases `*bh`, sets `*pos = dir->i_size`, returns `-1` |
| `fat_parse_long()` | Advances past EOD during LFN parse | Stops at EOD
via wrapper |
| `fat_search_long()` | Scans past EOD | Stops at EOD |
| `__fat_readdir()` | `IS_FREE()` skips EOD slot but loop continues into
garbage | Stops directory iteration at EOD |
| `fat_get_short_entry()` | Skips free slots including EOD, keeps
scanning | Stops at EOD |
| `fat_add_entries()` | No EOD awareness on write path | Tracks
`saw_eod`; errors if allocated entry found after EOD marker |

### Step 2.3: BUG MECHANISM
**Record:** **Category:** Logic / filesystem correctness (spec
violation).

Verified in current tree `__fat_readdir()`:

```615:616:fs/fat/dir.c
                if (de->attr != ATTR_EXT && IS_FREE(de->name))
                        goto record_end;
```

`IS_FREE()` is true for `name[0]==0` (EOD):

```52:53:include/uapi/linux/msdos_fs.h
#define DELETED_FLAG    0xe5    /* marks file as deleted when in name[0]
*/
#define IS_FREE(n)      (!*(n) || *(n) == DELETED_FLAG)
```

At `record_end`, `ctx->pos = cpos` and the loop returns to `get_new`,
which calls `fat_get_entry()` again — advancing **past** the EOD marker
into potentially non-zero garbage slots that are then emitted as real
directory entries.

### Step 2.4: FIX QUALITY
**Record:** Fix is obviously correct per FAT spec; minimal wrapper
centralizes behavior; write paths correctly remain on raw
`fat_get_entry()`. **Regression risk: LOW** — only affects behavior
after EOD marker; well-formed filesystems unchanged.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** `fat_get_entry()` at lines 116–129 last touched by merge
commit `5d324e5159d9e` (2025-11-28); the EOD-ignoring behavior is
longstanding (not a recent regression). Bug predates this stable branch.

### Step 3.2: FOLLOW Fixes: TAG
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: FILE HISTORY FOR RELATED CHANGES
**Record:** Recent FAT change in this tree: `17866f8a0822d` "fat: avoid
parent link count underflow in rmdir" (touches `fs/fat/` but not this
EOD logic). No prior EOD fix in this tree. Standalone fix (v4 of a long-
standing effort per commit message references to v1–v3 from 2018–2019).

### Step 3.4: AUTHOR'S OTHER COMMITS
**Record:** No Matteo Croce commits found in this tree's `fs/fat/`
history. Author is external contributor; fix endorsed by maintainer
OGAWA Hirofumi.

### Step 3.5: DEPENDENT/PREREQUISITE COMMITS
**Record:** **None.** Self-contained; uses existing
`fat_fs_error_ratelimit()` (present in `fs/fat/fat.h:447`). No patch-
series dependency.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: ORIGINAL PATCH DISCUSSION
**Record:** Commit not present in local tree — `b4 dig -c <hash>` could
not be run. `b4 dig` requires a commit-ish object. Link and
lore.kernel.org fetches returned 403/bot protection. Commit message
references v1–v3 at lore.kernel.org (2018–2019) — unverified directly
but cited by author.

### Step 4.2: REVIEWERS
**Record:** Acked-by and Suggested-by from OGAWA Hirofumi (FAT
maintainer). Merged by VFS maintainer Christian Brauner. Strong
maintainer endorsement (from commit message tags).

### Step 4.3: BUG REPORT
**Record:** Reported-by Timothy Redaelli (Red Hat). Concrete user-
visible symptoms described in commit message (~150 bogus `ls` entries,
`-EIO` from `stat()`). No syzbot/KASAN report.

### Step 4.4: RELATED PATCHES/SERIES
**Record:** v4 of a fix series; earlier v1–v3 added per-call-site guards
that maintainer identified as insufficient. This version centralizes the
check per maintainer suggestion.

### Step 4.5: STABLE MAILING LIST HISTORY
**Record:** UNVERIFIED — lore.kernel.org inaccessible from this
environment.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: KEY FUNCTIONS
**Record:** `fat_get_entry_eod()` (new), `fat_parse_long()`,
`fat_search_long()`, `__fat_readdir()`, `fat_get_short_entry()`,
`fat_add_entries()`.

### Step 5.2: CALLERS
**Record:**
- `__fat_readdir()` → `fat_readdir()` →
  `fat_dir_operations.iterate_shared` — **every `ls`/`getdents()` on
  FAT/vfat**
- `fat_search_long()` → vfat name lookup (`namei_vfat.c`)
- `fat_get_short_entry()` → `fat_get_dotdot_entry()`, `fat_dir_empty()`,
  `fat_subdirs()`, `fat_scan()`, `fat_scan_logstart()` — rmdir, lookup,
  NFS export
- `fat_add_entries()` → file/directory creation (`namei_vfat.c`,
  `namei_msdos.c`)

### Step 5.3: CALLEES
**Record:** `fat_get_entry()`, `fat__get_entry()`, `brelse()`,
`fat_fs_error_ratelimit()`, `fat_bmap()` (indirectly via position
advance to `dir->i_size`).

### Step 5.4: CALL CHAIN / REACHABILITY
**Record:** Reachable from **userspace syscalls**: `open()` +
`getdents64()`/`readdir()`, `stat()`, `mkdir()`, `unlink()`, `rename()`
on FAT/vfat mounts. **High reachability** for anyone mounting FAT media.

### Step 5.5: SIMILAR PATTERNS
**Record:** Sibling filesystem `exfat` had related directory-entry
bounds fixes backported to stable (`33c0b96d7e167`, `adfacfbaeae2c` in
this tree's history), indicating stable maintainers value directory-
entry correctness fixes.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: DOES THE BUGGY CODE EXIST?
**Record:** **YES.** `fat_get_entry_eod` does **not** exist (grep: 0
matches). All vulnerable `fat_get_entry()` call sites present at lines
328, 490, 602, 885, 1309. Bug is longstanding, not post-branch.

### Step 6.2: BACKPORT COMPLICATIONS
**Record:** **Clean apply** for main hunks verified via `git apply
--check`. `fat_add_entries()` hunk may need minor line-number adjustment
due to `17866f8a0822d` (parent link count fix) — content matches,
trivial backport adjustment.

### Step 6.3: RELATED FIXES ALREADY PRESENT?
**Record:** **No.** No EOD handling, no `fat_get_entry_eod`, no
`saw_eod` logic in current tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
**Record:** **Filesystem (FAT/vfat)** — IMPORTANT. Widely used for USB
sticks, SD cards, EFI partitions, embedded devices.

### Step 7.2: SUBSYSTEM ACTIVITY
**Record:** Active — recent fix `17866f8a0822d` in same subsystem. FAT
driver is mature but still receives correctness fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
**Record:** All users mounting FAT12/FAT16/FAT32/vfat filesystems where
directory trailing slots are not zero-filled after the EOD marker.
Common with cross-platform media and buggy/corrupt images.

### Step 8.2: TRIGGER CONDITIONS
**Record:** Mount FAT filesystem and list/access directory on media with
non-zero data after EOD marker. **Not** every boot, but **common** for
removable media. Unprivileged users can trigger via normal file
operations on mounted filesystem.

### Step 8.3: FAILURE MODE SEVERITY
**Record:** Bogus directory entries surfaced to userspace; `stat()`
returns `-EIO`; potential application confusion/failures; write path
could add entries to corrupt directories without the `fat_add_entries()`
guard. **Severity: MEDIUM-HIGH** (filesystem correctness, not kernel
oops/UAF, but serious user-visible malfunction).

### Step 8.4: RISK-BENEFIT
**Record:**
- **Benefit: HIGH** for FAT users — fixes real, reproducible directory
  listing corruption
- **Risk: LOW** — ~65 lines, one file, spec-aligned, maintainer-acked,
  write paths unchanged except corruption detection
- **Ratio: Strongly favors backport**

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE COMPILED

**FOR backport:**
- Real, user-reported filesystem correctness bug
- FAT spec violation with concrete symptoms (~150 bogus entries)
- Centralized fix addresses root cause (prior per-site guards were
  broken)
- Maintainer Acked-by + Suggested-by
- Small, single-file, no new userspace API
- Buggy code confirmed present in 6.18.44; fix not yet applied
- Patch applies cleanly to this tree
- Affects common syscall paths (readdir, lookup, create)
- Write-path corruption detection prevents worsening damaged directories

**AGAINST backport:**
- Not a kernel crash/UAF/security issue
- Requires non-spec-compliant on-disk layout to trigger (but commit
  documents real-world occurrence)
- Mailing list discussion unverified due to lore access restrictions

**UNRESOLVED:**
- Full lore review thread content
- Exact mainline commit hash (not in this tree)

### Step 9.2: STABLE RULES CHECKLIST
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — spec-aligned,
maintainer-acked; Tested-by not present but logic is verifiable |
| 2. Fixes a real bug affecting users? | **PASS** — Reported-by with
concrete symptoms |
| 3. Important issue? | **PASS** — filesystem correctness, user-visible
directory corruption |
| 4. Small and contained? | **PASS** — one file, ~65 lines |
| 5. No new features/APIs? | **PASS** — internal static wrapper only |
| 6. Can apply to local tree? | **PASS** — verified clean apply for core
hunks |

### Step 9.3: EXCEPTION CATEGORIES
**Record:** N/A — standard bug fix, not device ID/quirk/DT/build/doc
exception.

### Step 9.4: DECISION RATIONALE
This is a longstanding FAT driver spec-compliance bug that causes real
user-visible directory corruption on commonly encountered removable
media. The fix is small, maintainer-reviewed, self-contained, and the
vulnerable code is present in Linux 6.18.44 without an existing fix.
Filesystem correctness on widely used FAT/vfat mounts meets stable
criteria.

---

## Verification

- **[Phase 1]** Parsed commit message tags: Reported-by, Suggested-by,
  Acked-by (OGAWA Hirofumi), Link, Signed-off-by chain
- **[Phase 1]** Identified subsystem: `fat`, action: stop EOD iteration
- **[Phase 2]** Diff inventory: 1 file (`fs/fat/dir.c`), ~65 lines, 1
  new function + 5 modified sites
- **[Phase 2]** Verified `IS_FREE()` treats `name[0]==0` as free:
  `include/uapi/linux/msdos_fs.h:53`
- **[Phase 2]** Traced `__fat_readdir()` EOD→`record_end`→`get_new` loop
  at `fs/fat/dir.c:615-616,694-697,601-602`
- **[Phase 2]** Confirmed `fat_fs_error_ratelimit` exists:
  `fs/fat/fat.h:447`
- **[Phase 3]** `git describe HEAD`: `v6.18.44-1-g2736c32da98b9`;
  Makefile: 6.18.44
- **[Phase 3]** `git blame` on `fat_get_entry()`: lines 116-129,
  longstanding code
- **[Phase 3]** No Fixes: tag to follow
- **[Phase 3]** Recent related commit: `17866f8a0822d` in `fs/fat/`
- **[Phase 4]** `b4 dig -c`: FAILED — commit not in local tree
- **[Phase 4]** lore.kernel.org / patch.msgid.link fetch: FAILED
  (403/bot protection) — discussion unverified
- **[Phase 5]** `grep fat_get_entry` call sites: 8 uses in `dir.c`; read
  paths at 328, 490, 602, 885; write paths at 1015, 1309
- **[Phase 5]** Caller trace: `fat_readdir` → `iterate_shared`;
  `fat_search_long`/`fat_scan` → namei paths
- **[Phase 6]** `grep fat_get_entry_eod`: 0 matches — fix NOT in tree
- **[Phase 6]** Buggy `fat_get_entry()` without EOD handling: CONFIRMED
  present
- **[Phase 6]** `git apply --check`: PASS for `fat_get_entry_eod`
  addition and 4 call-site hunks
- **[Phase 6]** `git apply --check` for `fat_add_entries` hunk: needs
  minor line adjustment (due to `17866f8a0822d`), content matches
- **[Phase 8]** Failure mode: bogus directory entries + `-EIO` on stat —
  MEDIUM-HIGH severity, user-visible

**YES**

 fs/fat/dir.c | 44 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 92b091783966a..415c22a9e6361 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -128,6 +128,31 @@ static inline int fat_get_entry(struct inode *dir, loff_t *pos,
 	return fat__get_entry(dir, pos, bh, de);
 }
 
+/*
+ * Like fat_get_entry(), but honour the FAT end-of-directory marker:
+ * a dirent whose first name byte is NUL terminates iteration per the
+ * spec, which also guarantees that every following slot is zeroed.
+ * Skip straight to the end of the directory so the next call returns
+ * -1 from fat_bmap() without re-reading the trailing zero slots, and
+ * so callers that persist *pos across invocations (e.g. readdir's
+ * ctx->pos) keep reporting EOD.  Release *bh and set it to NULL to
+ * match fat_get_entry()'s contract that *bh is NULL on the -1 return.
+ */
+static int fat_get_entry_eod(struct inode *dir, loff_t *pos,
+			     struct buffer_head **bh,
+			     struct msdos_dir_entry **de)
+{
+	int err = fat_get_entry(dir, pos, bh, de);
+
+	if (err == 0 && (*de)->name[0] == 0) {
+		brelse(*bh);
+		*bh = NULL;
+		*pos = dir->i_size;
+		return -1;
+	}
+	return err;
+}
+
 /*
  * Convert Unicode 16 to UTF-8, translated Unicode, or ASCII.
  * If uni_xlate is enabled and we can't get a 1:1 conversion, use a
@@ -325,7 +350,7 @@ static int fat_parse_long(struct inode *dir, loff_t *pos,
 
 		if (ds->id & 0x40)
 			(*unicode)[offset + 13] = 0;
-		if (fat_get_entry(dir, pos, bh, de) < 0)
+		if (fat_get_entry_eod(dir, pos, bh, de) < 0)
 			return PARSE_EOF;
 		if (slot == 0)
 			break;
@@ -487,7 +512,7 @@ int fat_search_long(struct inode *inode, const unsigned char *name,
 
 	err = -ENOENT;
 	while (1) {
-		if (fat_get_entry(inode, &cpos, &bh, &de) == -1)
+		if (fat_get_entry_eod(inode, &cpos, &bh, &de) == -1)
 			goto end_of_dir;
 parse_record:
 		nr_slots = 0;
@@ -599,7 +624,7 @@ static int __fat_readdir(struct inode *inode, struct file *file,
 
 	bh = NULL;
 get_new:
-	if (fat_get_entry(inode, &cpos, &bh, &de) == -1)
+	if (fat_get_entry_eod(inode, &cpos, &bh, &de) == -1)
 		goto end_of_dir;
 parse_record:
 	nr_slots = 0;
@@ -882,7 +907,7 @@ static int fat_get_short_entry(struct inode *dir, loff_t *pos,
 			       struct buffer_head **bh,
 			       struct msdos_dir_entry **de)
 {
-	while (fat_get_entry(dir, pos, bh, de) >= 0) {
+	while (fat_get_entry_eod(dir, pos, bh, de) >= 0) {
 		/* free entry or long name entry or volume label */
 		if (!IS_FREE((*de)->name) && !((*de)->attr & ATTR_VOLUME))
 			return 0;
@@ -1298,6 +1323,7 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 	struct msdos_dir_entry *de;
 	int err, free_slots, i, nr_bhs;
 	loff_t pos;
+	bool saw_eod;
 
 	sinfo->nr_slots = nr_slots;
 
@@ -1306,12 +1332,15 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 	bh = prev = NULL;
 	pos = 0;
 	err = -ENOSPC;
+	saw_eod = false;
 	while (fat_get_entry(dir, &pos, &bh, &de) > -1) {
 		/* check the maximum size of directory */
 		if (pos >= FAT_MAX_DIR_SIZE)
 			goto error;
 
 		if (IS_FREE(de->name)) {
+			if (de->name[0] == 0)
+				saw_eod = true;
 			if (prev != bh) {
 				get_bh(bh);
 				bhs[nr_bhs] = prev = bh;
@@ -1321,6 +1350,13 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 			if (free_slots == nr_slots)
 				goto found;
 		} else {
+			if (saw_eod) {
+				fat_fs_error_ratelimit(sb,
+					"allocated dir entry found after end-of-directory marker (i_pos %lld)",
+					MSDOS_I(dir)->i_pos);
+				err = -EIO;
+				goto error;
+			}
 			for (i = 0; i < nr_bhs; i++)
 				brelse(bhs[i]);
 			prev = NULL;
-- 
2.53.0

