Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AF0529F38;
	Mon, 19 Oct 2026 13:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418170; cv=none; b=kUqEAf3S0c9wJomeN+T0wltFWOz5e0ELa52q9DqDPHb+rHmlALSEtJ+WRcbrTO8A4aUm20szjTGLAwg+7zunI8kpRpM/fAETm/+z2bwp7HuRwhU0D9+u0wUj9LdVQz9K4/Jfqmjduh2UAFhkVbZzF6ekikhBKZs5hHrbgt/2wXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418170; c=relaxed/simple;
	bh=gp6L2SLZLQSVAsFSrzv4BkAxb7JCVmh4SxNRmDD+fIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=luzXTXWfbkOwbe58FtrFcUVRPmPsTBZh6IZ/p1ziph+gLY41OE2LBHDwWnS9MZbW2wNRdOeN2eUTnF9/Mfa2Rz5bbNFCRfFipFXcvs1YQXD0itb8RFCzBi7F1d/ppRp7m09QauxdbfTE6qFbArPF9JOWxh4FgqV6fzwGuxdcROQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BZMt5TLK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BZMt5TLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CA11F000C9;
	Mon, 19 Oct 2026 13:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418166;
	bh=3fvkY4iGTxDb4k+17WCCVeBqJl78KDBhzfpsQEyiF9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZMt5TLKLdvi5nu+5aAKh8ebWcSnKzqoNhY8yUzjixPMS22SB2OgARo+fbdQUlIQV
	 0yj0gvcqfYObLlZ3azFkqSvg27CbBBN7hJYoTtY4TcZBMQOiPYCj79wCG3WZ8HaCin
	 4N6YATOinbdOPcjgI0Ma2UhPL+DbyKcNpSEno+0/YGVUiIxbEeLWm1Cw2ylG+qBO2e
	 PM2iLG2wAebtqpzYj7q3mo6r7Lc1YL37FEYvRphdNHv7L2FOd8WxyX/TW82Wei4KZW
	 heAMCW9xNI5JJlLen0/rK2BqimEHOIYpfMz+s0DFOC4pHUO3FcXIvQR7IuDucyk/TL
	 Ud+4c4zsZor5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jimmy Zuber <jamz@amazon.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	miklos@szeredi.hu,
	fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] fuse: zero the partial EOF page when extending a file
Date: Mon, 19 Oct 2026 09:45:50 -0400
Message-ID: <20261019135441.1420968-59-sashal@kernel.org>
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

From: Jimmy Zuber <jamz@amazon.com>

[ Upstream commit 34b5c4a6e4fb9dbb3f9d87f3b0fb0372105c8302 ]

Extending a fuse file past a non-page-aligned EOF does not zero the tail of
the old last page.  When that page is cached and has been mmap-dirtied beyond
the old EOF, the now in-bounds tail is served to later reads as stale data
rather than zeros, which violates POSIX file-extension semantics.

Some file systems get this zeroing automatically at writeback time
(block_write_full_folio() / iomap_writeback_handle_eof() zero the tail of the
folio straddling i_size).  A non-writeback caching fuse file system uses neither
path, so it has to zero the tail itself from the size-extending paths, like
XFS (xfs_file_write_zero_eof()) and ext4 (ext4_block_zero_eof()) do.

Call truncate_pagecache_range() over the newly-exposed range up front from the
three paths that extend a file, before the new size is published:

  - a buffered write whose position is past the old EOF (fuse_perform_write());
  - a size-extending setattr/truncate (fuse_do_setattr());
  - a size-extending fallocate (fuse_file_fallocate()).

This unmaps the stale mappings and zeroes the partial tail of the old EOF
folio, so a later read returns zeros.  Truncating [old EOF, write start) before
a buffered write keeps the dropped range disjoint from the written data, so a
write that lands inside the old EOF folio is preserved.

writeback_cache connections are unaffected, as their writes go through
iomap_file_buffered_write(), which zeroes post-EOF folios.  The bug is
observable on a non-writeback_cache server that returns FOPEN_KEEP_CACHE on
writable files (without FOPEN_DIRECT_IO), and is caught by the new
write_extend_eof fuse selftest.

Signed-off-by: Jimmy Zuber <jamz@amazon.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The buggy FUSE size-
extend paths are present here; the fix is not. This is a small
POSIX/data-integrity fix that belongs in this tree.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[fuse]** **[zero]** zero the partial EOF page when extending a
file. “Zero” here is a correctness fix (fill a hole that should read as
zeros), not a feature.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Jimmy Zuber \<jamz@amazon.com\> (author)
- Signed-off-by: Miklos Szeredi \<mszeredi@redhat.com\> (FUSE
  maintainer; applied the patch)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Link:, or Cc:
  stable (absence of Fixes/Cc: stable is expected for this pipeline)
- Ignore any “[Upstream commit …]” / Sasha Levin SOB if present —
  candidate-prep only

Notable: maintainer SOB. Cover letter (v4 0/2) also names testing under
UML plus libfuse `passthrough_ll`. Recipients included Jan Kara, Joanne
Koong, Brian Foster (author of the analogous ext4/XFS EOF-zeroing work).

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Extending a FUSE file past a non-page-aligned EOF does not
  zero the tail of the old last page.
- **Symptom:** If that page is cached and mmap-dirtied past the old EOF,
  later reads of the newly in-bounds tail return stale bytes instead of
  zeros (POSIX file-extension violation).
- **Root cause:** Writeback-style filesystems get this from
  `block_write_full_folio()` / `iomap_writeback_handle_eof()`. A non-
  writeback caching FUSE fs uses neither, so it must zero on extend,
  like XFS/ext4.
- **Fix:** `truncate_pagecache_range()` over the newly exposed range on
  write, setattr/truncate, and fallocate, before publishing the new size
  (write/fallocate; setattr still publishes `i_size` first, as it
  already did).
- **Scope note:** writeback_cache writes are claimed unaffected on
  mainline because they go through `iomap_file_buffered_write()`.
  Observable on non-writeback_cache + `FOPEN_KEEP_CACHE` without
  `FOPEN_DIRECT_IO`. Caught by `write_extend_eof` selftest.
- **Version info:** none in the message. Cover letter base-commit
  `7d87a5a284bb34edb3f4e7e312ef403b3385a7b7` is post-6.12.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Explicit POSIX/data-integrity bug with a regression
test. v1 originally zeroed from `fuse_write_update_attr()` after the
fact; v3/v4 moved zeroing to the extend paths so a write inside the old
EOF folio is preserved.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `fs/fuse/dir.c`: +3 in `fuse_do_setattr()`
- `fs/fuse/file.c`: +4 in `fuse_perform_write()`, +5 in
  `fuse_file_fallocate()`
- **~12 insertions, 0 deletions.** Single-subsystem surgical fix (FUSE
  only). Companion selftest (series 2/2) is not part of this commit.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **`fuse_perform_write()`:** Snapshot `old_size`. If `pos > old_size`,
  `truncate_pagecache_range(inode, old_size, pos-1)` before filling
  pages. Hole `[old EOF, write start)` is unmapped/zeroed; the write
  range itself is left intact.
- **`fuse_do_setattr()`:** On size change, if extending, range-truncate
  `[oldsize, newsize-1]` then the existing `truncate_pagecache()` +
  `invalidate_inode_pages2()`.
- **`fuse_file_fallocate()`:** If not `FALLOC_FL_KEEP_SIZE` and
  `offset+length > oldsize`, range-truncate `[oldsize, offset+length-1]`
  before `fuse_write_update_attr()` publishes the new size. Punch/zero
  still has its own existing range truncate.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Logic/correctness + memory-contents (stale page-cache data).**
mmap may dirty the last page past `i_size`. Extending makes that tail
in-bounds. Without zeroing, reads return mmap garbage instead of zeros.
`truncate_pagecache_range()` unmaps full pages in the hole and
`truncate_inode_partial_folio()` / `folio_zero_range()` zeros the
partial old-EOF folio (`mm/truncate.c`).

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Minimal, matches XFS/ext4. Uses a long-standing helper. v4
dropped a custom `fuse_zero_partial_eof_folio()` after Miklos/Jan noted
`folio_mkclean()`/`folio_mark_dirty()` is a buffer-head concern;
`truncate_pagecache_range()` already zeros. Regression risk is low:
extra truncate of a hole that must read as zeros. Failed write after
hole-zeroing only clears post-EOF cache, which is still past `i_size`.
Does not add APIs or features.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- setattr size-change block: `8373200b124d03` (“fuse: Trust kernel
  i_size only”, 2014) wrapping `truncate_pagecache` from
  `7caef26767c172` (2013). Comment around the invalidate goes back to
  Miklos 2008 (`3be5a52b30aa5c`).
- `fuse_perform_write()`: writethrough extend path since at least
  `ea9b9907b82a09` (2008); `FUSE_I_SIZE_UNSTABLE` from `06a7c3c2781409`
  (2013).
- fallocate extend: `bee6c307800bbb` / `b0aa7606521790` (2013).
Bug is old, long predating 6.12.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Introducing commit is “FUSE never zeroed this on
extend,” not a recent regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent 6.12 fuse work is lock leaks, DIO cache, virtiofs UAF —
unrelated. This is standalone, not a prep patch. Series 2/2 is a
selftest only.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Jimmy Zuber has no other fuse commits in this tree. Applied by
Miklos Szeredi (maintainer). Analogous ext4 fix `b6ce2dbe984bc` (“ext4:
partial zero eof block on unaligned inode size extension”) **is already
in this tree**.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Added calls are only `i_size_read()` +
`truncate_pagecache_range()`, both present. No new helpers. The mainline
hunk context mentions `fuse_folios_alloc`; this tree still uses
`fuse_pages_alloc` / `ap->pages`, so the **write hunk may need a trivial
context backport**. setattr and fallocate hunks match 6.12. Standalone:
yes.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record: Could not `b4 dig -c <sha>` (commit not in this checkout).
Retrieved thread via msgid `20260824143052.1546163-2-jamz@amazon.com`.
- Lore/LWN cover: `[PATCH v4 0/2] fuse: zero the partial EOF page when
  extending a file`
- Openwall: https://lists.openwall.net/linux-kernel/2026/08/24/1447
  (1/2), 1443 (2/2)
- Revisions: v1 (2026-07-31) zeroed from `fuse_write_update_attr()`
  (would clobber in-page extending writes); v2/v3 moved zeroing to
  extend paths; v4 dropped the helper per Miklos/Jan. Applied version is
  v4.
- Miklos reply 2026-08-24: **“Applied, thanks.”** No NAK, no stable
  objection.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: To: Miklos Szeredi, Shuah Khan. Cc: fuse-devel, linux-kselftest,
Jan Kara, Joanne Koong, Brian Foster. Maintainer applied v4 after
review-driven simplification.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Author reproduced vs libfuse
`passthrough_ll` and added a selftest that fails without the fix. Same
mmap-beyond-EOF pattern as the ext4 case (`xfs_io`
pwrite/mmap/mwrite/truncate).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 2-patch series. 2/2 is `write_extend_eof_test.c` only. Kernel
fix does not depend on it. 6.12 has no
`tools/testing/selftests/filesystems/fuse/` (no need to backport the
test).

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** — lore.kernel.org returned 403 (Anubis). Patch is
from Aug 2026; no evidence it was rejected for stable. Absence of Cc:
stable is not a negative signal here.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `fuse_perform_write()`, `fuse_do_setattr()`,
`fuse_file_fallocate()`. Helper used: `truncate_pagecache_range()`.

**Step 5.2: TRACE CALLERS**
Record:
- `fuse_perform_write()` ← `fuse_cache_write_iter()` (under
  `inode_lock`) ← `fuse_file_write_iter()` (`.write_iter`). Userspace
  `write`/`pwrite` on cached FUSE files. Direct-IO and DAX do not use
  this function.
- `fuse_do_setattr()` ← `fuse_setattr()` / open `O_TRUNC` path.
  Userspace `ftruncate`/`truncate`.
- `fuse_file_fallocate()` ← `.fallocate`. Userspace `fallocate()`.

**Step 5.3: TRACE CALLEES**
Record: `truncate_pagecache_range()` → optional `unmap_mapping_range()`
for full pages in the hole → `truncate_inode_pages_range()` →
`truncate_inode_partial_folio()` / `folio_zero_range()` for the partial
EOF folio. Confirmed in `mm/truncate.c` in this tree.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable from ordinary syscalls on a common FUSE mount. Default
no-open flags are `FOPEN_KEEP_CACHE` (`fs/fuse/file.c` ~line 151). Non-
writeback is the usual libfuse default. Unprivileged apps that mmap then
extend trigger it.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same class as ext4 `ext4_zero_partial_blocks()` on unaligned
extend (already in this tree) and XFS `xfs_file_write_zero_eof()`.
Remaining FUSE holes not covered here: `copy_file_range` (truncates only
the copied range), getattr-driven remote size growth in
`fuse_change_attributes()`. Incomplete coverage is not a reason to skip
the three primary paths.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.**
- `fuse_do_setattr()`: `fs/fuse/dir.c` ~2061–2065 — size change →
  `truncate_pagecache` + `invalidate_inode_pages2` only (no hole zero on
  extend). Dirty mmap pages can survive invalidate.
- `fuse_perform_write()`: `fs/fuse/file.c` ~1294–1305 — no
  `truncate_pagecache_range`.
- `fuse_file_fallocate()`: `fs/fuse/file.c` ~3223–3230 — extend updates
  `i_size` only; range truncate is punch/zero only.
Introduced years before 6.12 (2008–2014). `git log --grep="zero the
partial EOF"` on `fs/fuse/` is empty here.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Minor context only.** setattr/fallocate match. Write function
exists with the same `pos` / `FUSE_I_SIZE_UNSTABLE` shape; later in the
function 6.12 still uses pages, not folios. No semantic rework required.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This fix is not present. No earlier FUSE EOF-tail zeroing. ext4
analog is present (`b6ce2dbe984bc`).

Note: the commit’s “writeback_cache uses `iomap_file_buffered_write()`”
is mainline. **6.12 writeback still uses `generic_file_write_iter` →
`fuse_write_begin`/`fuse_write_end`.** That does not remove the
writethrough bug this patch fixes (`fuse_cache_write_iter` non-wb path
still calls `fuse_perform_write()`). setattr/fallocate changes still
apply to both modes.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **fs/fuse — IMPORTANT.** Not mm/VFS-core, but FUSE is widely
used (sshfs, fuse-overlayfs, ntfs-3g, virtiofs, container/user mounts).
Data served from the page cache is wrong.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained (Miklos). This is a long-standing hole, not
churn from a brand-new API.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **FUSE users with page cache kept and without writeback_cache**
(common). Config-specific (`CONFIG_FUSE_FS`), not a single obscure
driver.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Mid-page EOF + mmap store past EOF (legal on the last page) +
extend via `pwrite`/`ftruncate`/`fallocate`. Not every write; well-known
and reproducible (selftest + libfuse passthrough). Unprivileged if the
user can mmap/write the file.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Stale data returned as file contents / POSIX hole not zero —
HIGH (data integrity).** Not a panic. Same class stable already took for
ext4.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: **Benefit high** (wrong reads on a common FUSE config). **Risk
low** (~12 lines, existing helper, maintainer-applied, selftest). Ratio
strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

For:
- Real POSIX/data-integrity bug; selftest fails without the fix
- Small, surgical, no new API
- Buggy code present in 6.12 for years
- Same pattern as ext4, already backported here
- Maintainer applied v4 after review
- Default `FOPEN_KEEP_CACHE`; userspace-reachable
- Failed-write side effect is only clearing post-EOF cache

Against:
- Trigger needs mmap-past-EOF then extend (not every I/O)
- Does not cover `copy_file_range` / getattr size updates
- Write hunk may need a one-line context tweak (pages vs folios)
- No explicit Cc: stable (expected)

Unresolved:
- Exact mainline SHA (not in this tree; git.kernel.org blocked)
- stable@ thread (lore 403)
- Follow-ups after Miklos applied (none seen in the 4-message v4 thread)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — helper is standard; UML
   selftest; maintainer applied
2. Fixes a real bug that affects users? **PASS** — stale reads vs zeros
3. Important (crash/security/corruption/deadlock)? **PASS** — data
   integrity / POSIX hole semantics
4. Small and contained? **PASS** — 12 lines, two files, three call sites
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — logic applies; write hunk may
   need trivial context

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-id/quirk/DT/build/docs exception. Qualifies as a
normal important bugfix.

**Step 9.4: MAKE YOUR DECISION**
Backport. The bug exists in this 6.12 tree, the fix is small and already
the form the maintainer wanted, and the user-visible failure is wrong
file data.

---

### What the commit solves for stable users

On cached, non-writeback FUSE, extending a file (write past EOF,
`ftruncate` up, `fallocate` without `KEEP_SIZE`) leaves mmap-dirtied
bytes in the old last page. Those bytes become part of the file and are
returned to `read` instead of zeros. That is a data-integrity / POSIX
violation. 6.12’s three extend paths match the buggy mainline code.

### Risk vs benefit

Benefit is preventing stale data on a common FUSE configuration. Risk is
a few `truncate_pagecache_range()` calls on a hole that must be zeros
anyway. Companion selftest is optional and this tree lacks the fuse
selftest directory.

---

### Verification
- **[Phase 1]** Tags: author Jimmy Zuber; Miklos Szeredi SOB; no
  Fixes/Reported-by/Cc: stable
- **[Phase 1]** Cover letter v4: msgid
  `20260824143052.1546163-1-jamz@amazon.com`; tested UML + libfuse
  passthrough_ll
- **[Phase 2]** Diff: +3 dir.c setattr, +4 perform_write, +5 fallocate;
  12 lines
- **[Phase 2]** `truncate_pagecache_range()` /
  `truncate_inode_partial_folio()` / `folio_zero_range()` read in
  `mm/truncate.c`
- **[Phase 3]** blame: setattr guard `8373200b124d03` (2014); write path
  `ea9b9907b82a09` (2008); fallocate `bee6c307800bbb` (2013)
- **[Phase 3]** No Fixes: tag; `git log --grep="zero the partial EOF" --
  fs/fuse/` empty in this tree
- **[Phase 3]** ext4 analog `b6ce2dbe984bc` is an ancestor of HEAD
- **[Phase 4]** `b4 mbox` msgid
  `20260824143052.1546163-2-jamz@amazon.com`: 4 messages; Miklos
  “Applied, thanks.”
- **[Phase 4]** v1→v4: moved zeroing off `fuse_write_update_attr`;
  dropped custom helper
- **[Phase 4]** lore.kernel.org search 403 — UNVERIFIED stable@
  discussion
- **[Phase 5]** Callers: `fuse_file_write_iter` →
  `fuse_cache_write_iter` → `fuse_perform_write` under `inode_lock`;
  setattr; `.fallocate`
- **[Phase 5]** Default `FOPEN_KEEP_CACHE` at `fs/fuse/file.c:151`
- **[Phase 6]** `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → 6.12.111
- **[Phase 6]** Buggy snippets present at dir.c:2061–2065,
  file.c:1294–1305, file.c:3223–3230
- **[Phase 6]** 6.12 uses `fuse_pages_alloc`, not `fuse_folios_alloc` —
  minor apply context
- **[Phase 6]** 6.12 writeback_cache uses `fuse_write_begin`, not
  `iomap_file_buffered_write` (commit text is mainline-specific)
- **[Phase 8]** Failure mode: stale page-cache data on read after
  extend; severity HIGH
- **UNVERIFIED:** exact mainline SHA; post-apply follow-ups beyond the
  v4 thread; copy_file_range/getattr as extra bugs (not used to vote NO)

**YES**

 fs/fuse/dir.c  | 3 +++
 fs/fuse/file.c | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index a013fad843b2c..9e20bc9dbdac4 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -2095,6 +2095,9 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	 */
 	if ((is_truncate || !is_wb) &&
 	    S_ISREG(inode->i_mode) && oldsize != outarg.attr.size) {
+		if (outarg.attr.size > oldsize)
+			truncate_pagecache_range(inode, oldsize,
+						 outarg.attr.size - 1);
 		truncate_pagecache(inode, outarg.attr.size);
 		invalidate_inode_pages2(mapping);
 	}
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 0812eee881519..a7a3ac5b34f42 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1290,9 +1290,13 @@ static ssize_t fuse_perform_write(struct kiocb *iocb, struct iov_iter *ii)
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	loff_t pos = iocb->ki_pos;
+	loff_t old_size = i_size_read(inode);
 	int err = 0;
 	ssize_t res = 0;
 
+	if (pos > old_size)
+		truncate_pagecache_range(inode, old_size, pos - 1);
+
 	if (inode->i_size < pos + iov_iter_count(ii))
 		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 
@@ -2952,6 +2956,11 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 
 	/* we could have extended the file */
 	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
+		loff_t oldsize = i_size_read(inode);
+
+		if (offset + length > oldsize)
+			truncate_pagecache_range(inode, oldsize,
+						 offset + length - 1);
 		if (fuse_write_update_attr(inode, offset + length, length))
 			file_update_time(file);
 	}
-- 
2.53.0

