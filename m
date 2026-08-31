Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3440598BE9;
	Mon, 31 Aug 2026 13:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184292; cv=none; b=gcdW2FxCsnrLTu+wGsvo6Wa1uycy+et0aWGKyD0u/u49qcxzxg1O4qhhnzjRmlrP2wRnPsTHFvkvCbQEWivaJ22WJ3BNkwGEG1jfbBh/CTvk4eEvWOOT21eb2iesFagaGNnBLSj+He4yUg5WYeiCbF0PGH07oXQd0NurJO7r5tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184292; c=relaxed/simple;
	bh=y4TRHcG7OtKRfiCs+0BbJPPnBvTAJkJ/V78BHZrUSqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SXr2JahKQg+GEc9p8fp4FvIjrnqtNdWY8rlhC0faHDE1pPUVdj/kawaGJhX72kzRJ3TXCBKHh4/a+VSG0m/KLx0Ohqw0Jir9YsmuXNLLMmXDtOsaEitlV0bJQpQx3Ai4btk0Ys4VNrrFtehm/9Kv5+0wRYOLG0asIBlxeWVE2zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GtcOWmXG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GtcOWmXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2371F000E9;
	Mon, 31 Aug 2026 13:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184289;
	bh=OQPoetGYYt4dOA8Bw9hMoT+JjlkQhHd/tUE7dRGUAmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GtcOWmXGXvXSPVMmSKFhYsEEXQDNDffbhNJ+K/VcBBagzhp12YY3c1nvwEBk9taBL
	 r1vNAFiU/RNceVr/9VQFqJIRIAUAub7nlrh2+9sNOpX+tIfMu2V8Sj40+aDTvpjbai
	 p3A6e2WZMaN71qLHNayh0ZazTxRCh1l3uQj79Emcjzz8u8euQqLKdtw6PT/15k4qbn
	 UH8Bml4tJJQKzdmYJiSYZEVaXpAVgdfRxAq4XPyPjal8cs4/43rkSeAaVZgtTphpzS
	 2QTWdNfGcU0doY4aRarmKirPKBxgL+YXp3HyRnnTYNpEWC8TO3VXJQY7iVxtJq9RWb
	 rgCdzbsFqPygg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Viacheslav Dubeyko <slava@dubeyko.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	linux-fsdevel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] hfsplus: fix issue of direct writes beyond end-of-file
Date: Mon, 31 Aug 2026 09:30:32 -0400
Message-ID: <20260831133314.4125787-604-sashal@kernel.org>
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

[ Upstream commit 5f63ac80aef2ee6bb58eab62e98c264774872da6 ]

The xfstests' test-case generic/729 fails with error:

sudo ./check generic/729
FSTYP         -- hfsplus
PLATFORM      -- Linux/x86_64 hfsplus-testing-0001 7.0.0-rc1+ #36 SMP PREEMPT_DYNAMIC Fri Apr 17 12:40:51 PDT 2026
MKFS_OPTIONS  -- /dev/loop51
MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch

generic/729  23s ... [failed, exit status 1]- output mismatch

mmap-rw-fault: /mnt/test/mmap-rw-fault.tmp: Input/output error

The hfsplus_get_block() only allows creating the next
sequential block. It returns -EIO for direct writes
beyond EOF. This patch waits for any in-flight DIO on the inode
to finish. Then, it extends the file by calling
generic_cont_expand_simple() with the goal to guarantee
that blockdev_direct_IO() finds all needed blocks
already reachable sequentially. And, finally, it flushes and
invalidates the DIO range again so the page cache is clean
before the direct write begins.

sudo ./check generic/729
FSTYP         -- hfsplus
PLATFORM      -- Linux/x86_64 hfsplus-testing-0001 7.0.0-rc1+ #40 SMP PREEMPT_DYNAMIC Thu Apr 16 15:41:03 PDT 2026
MKFS_OPTIONS  -- /dev/loop51
MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch

generic/729  23s ...  32s
Ran: generic/729
Passed all 1 tests

Closes: https://github.com/hfs-linux-kernel/hfs-linux-kernel/issues/210
cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
cc: Yangtao Li <frank.li@vivo.com>
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260417214940.2735557-2-slava@dubeyko.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `hfsplus: fix issue of direct writes beyond
end-of-file`

**Local tree:** Linux **6.18.43** (`git describe HEAD` → `v6.18.43`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[hfsplus] [fix] [direct writes beyond end-of-file fail with
-EIO]`

### Step 1.2: Tags
**Record:**
- **Fixes:** — absent (expected for manual review)
- **Reported-by:** — absent
- **Tested-by:** — absent
- **Reviewed-by:** — absent
- **Acked-by:** — absent
- **Link:**
  `https://lore.kernel.org/r/20260417214940.2735557-2-slava@dubeyko.com`
- **Closes:** `https://github.com/hfs-linux-kernel/hfs-linux-
  kernel/issues/210`
- **cc:** John Paul Adrian Glaubitz, Yangtao Li, linux-
  fsdevel@vger.kernel.org
- **Signed-off-by:** Viacheslav Dubeyko (author; ignore pipeline SOBs)

Notable: GitHub issue documents reproducible xfstests failure; no
syzbot/KASAN signals.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `hfsplus_get_block()` only allocates the *next sequential*
  block (`iblock > hip->fs_blocks` → `-EIO`). Direct I/O writes starting
  beyond EOF hit this path and fail.
- **Symptom:** xfstests `generic/729` fails with `mmap-rw-fault: ...
  Input/output error` (userspace EIO).
- **Root cause:** DIO bypasses `cont_write_begin()` / page-cache
  expansion that buffered writes use; `blockdev_direct_IO()` calls
  `hfsplus_get_block()` with `create=1` on blocks beyond the current
  allocation frontier.
- **Fix approach:** Before DIO write when `ki_pos > i_size`: wait for
  in-flight DIO, expand via `generic_cont_expand_simple()`, flush and
  invalidate the affected page-cache range, then proceed with
  `blockdev_direct_IO()`.
- **Version info:** Issue filed against 6.15.0-rc4+; fix verified on
  7.0.0-rc1+ per commit message and GitHub issue.

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit functional bug fix, not disguised
cleanup. It corrects incorrect `-EIO` on a valid I/O path.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `fs/hfsplus/inode.c` only (+34 / −2 lines)
- **Function modified:** `hfsplus_direct_IO()`
- **Scope:** Single-file, surgical fix in one function

### Step 2.2: Code Flow Change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| Pre-DIO path | Immediately calls `blockdev_direct_IO()` | For WRITE
with `ki_pos > i_size`: `inode_dio_wait()` →
`generic_cont_expand_simple()` → `filemap_write_and_wait_range()` →
`invalidate_inode_pages2_range()`, then DIO |
| Error cleanup | Declares local `isize`/`end` in error block | Reuses
`isize`/`end` hoisted to function scope |

Affected path: **O_DIRECT write beyond current EOF** (sparse extension /
hole before write).

### Step 2.3: Bug Mechanism
**Record:** **Logic / correctness fix** in filesystem block allocation.

In `hfsplus_get_block()`:

```239:243:fs/hfsplus/extents.c
        if (iblock >= hip->fs_blocks) {
                if (!create)
                        return 0;
                if (iblock > hip->fs_blocks)
                        return -EIO;
```

Only `iblock == hip->fs_blocks` (next block) can be created. A DIO write
at offset 4096 on a zero-length file needs `iblock > fs_blocks` →
`-EIO`. Buffered writes avoid this via `cont_write_begin()` in
`hfsplus_write_begin()`.

### Step 2.4: Fix Quality
**Record:**
- **Obviously correct:** Mirrors the established pattern in
  `hfsplus_setattr()` (same file, lines 278–284): `inode_dio_wait()` +
  `generic_cont_expand_simple()`.
- **Minimal:** Only touches the DIO write-beyond-EOF case.
- **Regression risk:** Low — narrow trigger (`WRITE && ki_pos >
  i_size`), uses standard VFS helpers already used elsewhere in hfsplus.
- **No new APIs or public interface changes.**

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `hfsplus_direct_IO()` and the `iblock > hip->fs_blocks`
check both blame to `19eef1d98eeda` in this tree (a history-rewrite
artifact in the stable queue). The sequential-block constraint in
`hfsplus_get_block()` is longstanding hfsplus design; the DIO path has
lacked pre-expansion since `hfsplus_direct_IO` was wired into
`hfsplus_aops`.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag present.

### Step 3.3: Related File History
**Record:** Recent `fs/hfsplus/inode.c` history in **this tree**
includes multiple backported hfsplus xfstests fixes from the same
author:
- `956b1d8051cfa` — generic/498 (volume corruption)
- `54694417d4384` — generic/480
- `66e2f3c1aefea` — generic/101

This fix is **standalone** (not part of a multi-patch series in the
commit message).

### Step 3.4: Author Context
**Record:** Viacheslav Dubeyko is an active hfsplus contributor;
multiple hfsplus fixes from this author are already in Linux 6.18.43.

### Step 3.5: Dependencies
**Record:** No prerequisite commits required. All APIs exist in this
tree:
- `generic_cont_expand_simple()` — `fs/buffer.c:2473`
- `inode_dio_wait()` — `fs/inode.c:2659`
- `filemap_write_and_wait_range()`, `invalidate_inode_pages2_range()` —
  standard VFS
- Already used in `hfsplus_setattr()` at lines 278–284 of the same file

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig -c <sha>` could not be run — commit is not in this
checkout. Lore URL blocked by Anubis bot protection. GitHub issue #210
confirms the bug and fix (opened 2025-05-27, closed 2026-04-23 after
generic/729 passed).

### Step 4.2: Reviewers
**Record:** UNVERIFIED — could not fetch lore thread. Commit cc's
fsdevel and hfsplus maintainers.

### Step 4.3: Bug Report
**Record:** [GitHub issue #210](https://github.com/hfs-linux-kernel/hfs-
linux-kernel/issues/210):
- Failure: `mmap-rw-fault: ... Input/output error`
- Reproducible since at least 6.15.0-rc4
- Fixed on 7.0.0-rc1+ with this patch
- **Severity from reporter:** xfstests regression; user-visible EIO, not
  corruption/crash

### Step 4.4: Related Patches
**Record:** `generic/729` (added 2023) tests mmap + DIO write — extends
generic/647. It exercises direct writes beyond EOF followed by mmap
fault I/O. Same test class has exposed real bugs in btrfs (deadlock) and
NFS (EFAULT).

### Step 4.5: Stable List History
**Record:** UNVERIFIED — lore stable list not searchable due to bot
protection. Precedent exists in-tree: other Dubeyko hfsplus xfstests
fixes already backported to 6.18.y.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `hfsplus_direct_IO()` (modified); `hfsplus_get_block()`
(buggy callee, unchanged).

### Step 5.2: Callers
**Record:** `hfsplus_direct_IO` is registered in
`hfsplus_aops.direct_IO` (line 173). Invoked from VFS when `O_DIRECT` is
set on hfsplus files — reachable from `pwrite()`, `io_uring`, and
xfstests `mmap-rw-fault` helper.

### Step 5.3: Callees
**Record:** `inode_dio_wait`, `generic_cont_expand_simple` (→
`hfsplus_write_begin` → `cont_write_begin`),
`filemap_write_and_wait_range`, `invalidate_inode_pages2_range`,
`blockdev_direct_IO`.

### Step 5.4: Reachability
**Record:** **Userspace-reachable** on any hfsplus mount with O_DIRECT
writes extending past EOF. `generic/729` is the concrete, reproducible
trigger.

### Step 5.5: Similar Patterns
**Record:** `hfsplus_setattr()` already uses `inode_dio_wait()` +
`generic_cont_expand_simple()` for size extension. `hfs`
(`fs/hfs/inode.c`) has a similar bare `hfs_direct_IO()` — potentially
the same class of bug, but out of scope for this commit.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.43)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Current `hfsplus_direct_IO()` at lines 123–145
calls `blockdev_direct_IO()` directly with no pre-expansion.
`hfsplus_get_block()` sequential-only create logic at
`extents.c:239–243` is present.

### Step 6.2: Backport Complications
**Record:** **Clean apply** — `git apply --check` with the full upstream
diff succeeds on `fs/hfsplus/inode.c` in this tree.

### Step 6.3: Related Fixes Already Present?
**Record:** **NO** — `git log --grep="729"` and `git log --grep="beyond
end-of-file"` find no matching fix. This commit is not yet applied.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem / Criticality
**Record:** **fs/hfsplus** — IMPORTANT (filesystem I/O correctness), not
CORE but affects all hfsplus users doing DIO.

### Step 7.2: Activity
**Record:** Actively maintained in 6.18.y — multiple recent hfsplus
xfstests fixes from the same author already landed in this stable
series.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of hfsplus with `O_DIRECT` writes beyond EOF —
including Mac interoperability workloads, backup tools, and the standard
xfstests `generic/729` regression test.

### Step 8.2: Trigger Conditions
**Record:** `O_DIRECT` write where `ki_pos > i_size` (sparse extension).
Common in `generic/729` (truncate to 0, then write at offset 4096).
Unprivileged users can trigger on mounted hfsplus volumes they can write
to.

### Step 8.3: Failure Mode Severity
**Record:** Returns **-EIO** to userspace on valid I/O. No crash,
corruption, or deadlock documented for hfsplus. **Severity: MEDIUM** —
functional I/O failure / incorrect error, fits stable rules' "oh, that's
not good" category.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** MEDIUM — restores correct DIO semantics; passes standard
  xfstests; fixes long-standing user-visible failure
- **Risk:** LOW — 34 lines, one function, mirrors existing
  `hfsplus_setattr()` pattern, applies cleanly
- **Ratio:** Favorable for backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, reproducible bug (xfstests `generic/729`, GitHub #210)
- User-visible EIO on valid direct writes beyond EOF
- Small, surgical, obviously correct fix
- Uses APIs already present and used in same file
- Applies cleanly to Linux 6.18.43
- Same author/subsystem already has xfstests fixes in this stable series
- Tested before/after in commit message

**AGAINST backport:**
- Not crash/corruption/security — severity is functional I/O failure
- hfsplus is a niche filesystem
- Bug likely present since DIO support was added (long-standing)
- Lore review details unverified

**UNRESOLVED:**
- Full mailing-list review thread (lore blocked)
- Whether reviewers explicitly nominated for stable

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — xfstests generic/729;
   pattern proven in `hfsplus_setattr()`
2. Fixes a real bug affecting users? **PASS** — EIO on valid O_DIRECT
   writes
3. Important issue? **PASS (MEDIUM)** — incorrect I/O failure on
   standard xfstests path; "oh, that's not good" per stable-kernel-
   rules.rst
4. Small and contained? **PASS** — 1 file, ~34 lines
5. No new features/APIs? **PASS** — uses existing VFS helpers
6. Can apply to local tree? **PASS** — clean `git apply --check`

### Step 9.3: Exception Category
**Record:** None (not device ID, quirk, DT, build fix, or docs).
Standard filesystem correctness fix.

### Step 9.4: Decision Rationale
For **Linux 6.18.43**, the buggy code is present, all dependencies
exist, the patch applies cleanly, and the fix addresses a reproducible
userspace I/O failure on a supported filesystem using established
patterns already in the same driver. While not as severe as the
corruption fixes already backported for hfsplus in this series, it meets
stable criteria: real bug, tested fix, low risk, user-visible impact.
The 6.18.y tree has already accepted similar hfsplus xfstests fixes from
this author.

---

## Verification

- **[Phase 1]** Parsed commit message, tags, and GitHub issue #210
  (fetched successfully)
- **[Phase 2]** Read current `hfsplus_direct_IO()` at
  `fs/hfsplus/inode.c:123–145` and `hfsplus_get_block()` at
  `fs/hfsplus/extents.c:239–243`
- **[Phase 2]** Confirmed `hfsplus_setattr()` uses same expansion
  pattern at `fs/hfsplus/inode.c:278–284`
- **[Phase 3]** `git describe HEAD` → v6.18.43; `make kernelversion`
  equivalent via Makefile → 6.18.43
- **[Phase 3]** `git log --oneline -20 -- fs/hfsplus/inode.c` — found
  related backported hfsplus fixes
- **[Phase 3]** `git blame` on changed lines — history rewrite artifact
  noted
- **[Phase 3]** `git log --grep="729"` / `--grep="beyond end-of-file"` —
  no existing fix in tree
- **[Phase 4]** GitHub issue #210 — confirmed failure mode and fix
  verification
- **[Phase 4]** Web search — confirmed generic/729 tests mmap + DIO
  write beyond EOF
- **[Phase 4]** UNVERIFIED: `b4 dig` (no commit SHA in tree),
  lore.kernel.org (bot-blocked)
- **[Phase 5]** `grep hfsplus_direct_IO` — registered in `hfsplus_aops`
  at line 173
- **[Phase 5]** `grep generic_cont_expand_simple` — present in
  `fs/buffer.c:2473` and used in hfsplus
- **[Phase 6]** Confirmed buggy code present in current checkout
- **[Phase 6]** `git apply --check` with full upstream diff —
  **succeeds**
- **[Phase 7]** Multiple Dubeyko hfsplus commits in `git log
  --author="Dubeyko"` on this tree
- **[Phase 8]** Assessed severity as MEDIUM functional I/O failure, not
  CRITICAL

**YES**The background git history search failed: it hit the 30s timeout
because the command fell through to `git log -S 'hfsplus_direct_IO'
--all`, which is exactly what we must avoid on this repo.

That didn’t block the backport analysis. I used narrower searches
instead (`git blame`, `git log -S ... -- fs/hfsplus/inode.c`), and the
conclusion for Linux **6.18.43** is unchanged: **YES** — the fix applies
cleanly and addresses a real O_DIRECT-beyond-EOF EIO bug in hfsplus.

 fs/hfsplus/inode.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 6153e5cc6eb65..7e6cc4dde9f26 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -125,9 +125,44 @@ static ssize_t hfsplus_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
+	loff_t isize;
 	size_t count = iov_iter_count(iter);
+	loff_t end = iocb->ki_pos + count;
 	ssize_t ret;
 
+	/*
+	 * The hfsplus_get_block() only allows creating the next sequential block.
+	 * For direct writes beyond EOF, expand the file first.
+	 */
+	if (iov_iter_rw(iter) == WRITE && iocb->ki_pos > i_size_read(inode)) {
+		loff_t start_off, end_off;
+		loff_t start_page, end_page;
+
+		isize = i_size_read(inode);
+
+		/*
+		 * Wait for any in-flight DIO on this inode to finish before
+		 * calling generic_cont_expand_simple().
+		 */
+		inode_dio_wait(inode);
+
+		ret = generic_cont_expand_simple(inode, iocb->ki_pos);
+		if (ret)
+			return ret;
+
+		start_off = isize;
+		end_off = (end > 0) ? end - 1 : end;
+
+		ret = filemap_write_and_wait_range(mapping, start_off, end_off);
+		if (ret)
+			return ret;
+
+		start_page = start_off >> PAGE_SHIFT;
+		end_page = end_off >> PAGE_SHIFT;
+
+		invalidate_inode_pages2_range(mapping, start_page, end_page);
+	}
+
 	ret = blockdev_direct_IO(iocb, inode, iter, hfsplus_get_block);
 
 	/*
@@ -135,8 +170,7 @@ static ssize_t hfsplus_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	 * blocks outside i_size. Trim these off again.
 	 */
 	if (unlikely(iov_iter_rw(iter) == WRITE && ret < 0)) {
-		loff_t isize = i_size_read(inode);
-		loff_t end = iocb->ki_pos + count;
+		isize = i_size_read(inode);
 
 		if (end > isize)
 			hfsplus_write_failed(mapping, end);
-- 
2.53.0

