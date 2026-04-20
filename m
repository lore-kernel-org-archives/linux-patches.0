Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8543D091C;
	Mon, 20 Apr 2026 13:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691822; cv=none; b=qbJ+/tQATV9LSk8eAcQVZQ1O+jZcmW/5JpgG7qdLTpMTWTqaootBiFvC+B4LDZAxilx0eaoIzAU+o0/mOwdGinkb5ORZZBVCbxA+zzzXc5OIXwDF7Bkeas2xd4iwFKU3IlrEPxsxMx0PMdtqaGqdHBVZNhK+T9ueX8wwmsQqQoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691822; c=relaxed/simple;
	bh=hbuw5dPqNgsunIQh/phpOXznV7S8JK7qTS2mgMGHf6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PcBSCuT0ZjucTXCcqE/+t23WnR2yL0geYTGz+4O3fWBr1ve669OvurFFvKkFTfKz/oQHw/yDu5TSFdGThG3VdAzJVV8a00ZlVcNGl0HRS1/0etcOSYt0tjpR7VwoYB3oIC0pEMISKEGDToDD+cpeObtfqXLLbEzWrrcU3FPTiHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qAtcf2cO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qAtcf2cO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F79C2BCC7;
	Mon, 20 Apr 2026 13:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691822;
	bh=hbuw5dPqNgsunIQh/phpOXznV7S8JK7qTS2mgMGHf6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAtcf2cOa4MLXSRZ7WBIqnw81N8fxiww2ui2T1BXbWw95iECj9D5+Budf1eJd9Uph
	 vHIY+95OJ/QYDL9iWIvu2G7ucT9Efqr21mJw2iS1usTlYTjYKcpojlkbhpyLd5mq97
	 uvXDdhPrMsuA5akPAgEJZ/hCiEe4xcGjqFbabzxu9TV4bpQggmBHWmjGH9tlmDXpiz
	 agL/znL/JZhlgGzIM9oX+pMsBLk+n+9vWac+d+GLCnTQ9kWsemZcNBSSrlT7IvHuGn
	 fX6wcBbUu8t8P8B0dPIyqIk+c27z5mHPlyC4qpIYS+hqTvuXZ8OZsQdjFtNzIdhNnD
	 IXll1iQlsiesw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yun Zhou <yun.zhou@windriver.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	shaggy@kernel.org,
	jfs-discussion@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] jfs: add dtroot integrity check to prevent index out-of-bounds
Date: Mon, 20 Apr 2026 09:20:09 -0400
Message-ID: <20260420132314.1023554-215-sashal@kernel.org>
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

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit c83abc766aeb153e69cb46363bf7c9de0c9f3268 ]

Add check_dtroot() to validate dtroot_t integrity, focusing on preventing
index/pointer overflows from on-disk corruption.

Key checks:
 - freecnt bounded by [0, DTROOTMAXSLOT-1] (slot[0] reserved for header).
 - freelist validity: -1 when freecnt=0; 1~DTROOTMAXSLOT-1 when non-zero,
   with linked list checks (no duplicates, proper termination via next=-1).
 - stbl bounds: nextindex within stbl array size; entries within 0~8, no
   duplicates (excluding idx=0).

Invoked in copy_from_dinode() when loading directory inodes, catching
corruption early before directory operations trigger out-of-bounds access.

This fixes the following UBSAN warning.

[  101.832754][ T5960] ------------[ cut here ]------------
[  101.832762][ T5960] UBSAN: array-index-out-of-bounds in fs/jfs/jfs_dtree.c:3713:8
[  101.832792][ T5960] index -1 is out of range for type 'struct dtslot[128]'
[  101.832807][ T5960] CPU: 2 UID: 0 PID: 5960 Comm: 5f7f0caf9979e9d Tainted: G            E       6.18.0-rc4-00250-g2603eb907f03 #119 PREEMPT_{RT,(full
[  101.832817][ T5960] Tainted: [E]=UNSIGNED_MODULE
[  101.832819][ T5960] Hardware name: QEMU Ubuntu 25.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  101.832823][ T5960] Call Trace:
[  101.832833][ T5960]  <TASK>
[  101.832838][ T5960]  dump_stack_lvl+0x189/0x250
[  101.832909][ T5960]  ? __pfx_dump_stack_lvl+0x10/0x10
[  101.832925][ T5960]  ? __pfx__printk+0x10/0x10
[  101.832934][ T5960]  ? rt_mutex_slowunlock+0x493/0x8a0
[  101.832959][ T5960]  ubsan_epilogue+0xa/0x40
[  101.832966][ T5960]  __ubsan_handle_out_of_bounds+0xe9/0xf0
[  101.833007][ T5960]  dtInsertEntry+0x936/0x1430 [jfs]
[  101.833094][ T5960]  dtSplitPage+0x2c8b/0x3ed0 [jfs]
[  101.833177][ T5960]  ? __pfx_rt_mutex_slowunlock+0x10/0x10
[  101.833193][ T5960]  dtInsert+0x109b/0x6000 [jfs]
[  101.833283][ T5960]  ? rt_mutex_slowunlock+0x493/0x8a0
[  101.833296][ T5960]  ? __pfx_rt_mutex_slowunlock+0x10/0x10
[  101.833307][ T5960]  ? rt_spin_unlock+0x161/0x200
[  101.833315][ T5960]  ? __pfx_dtInsert+0x10/0x10 [jfs]
[  101.833391][ T5960]  ? txLock+0xaf9/0x1cb0 [jfs]
[  101.833477][ T5960]  ? dtInitRoot+0x22a/0x670 [jfs]
[  101.833556][ T5960]  jfs_mkdir+0x6ec/0xa70 [jfs]
[  101.833636][ T5960]  ? __pfx_jfs_mkdir+0x10/0x10 [jfs]
[  101.833721][ T5960]  ? generic_permission+0x2e5/0x690
[  101.833760][ T5960]  ? bpf_lsm_inode_mkdir+0x9/0x20
[  101.833776][ T5960]  vfs_mkdir+0x306/0x510
[  101.833786][ T5960]  do_mkdirat+0x247/0x590
[  101.833795][ T5960]  ? __pfx_do_mkdirat+0x10/0x10
[  101.833804][ T5960]  ? getname_flags+0x1e5/0x540
[  101.833815][ T5960]  __x64_sys_mkdir+0x6c/0x80
[  101.833823][ T5960]  do_syscall_64+0xfa/0xfa0
[  101.833832][ T5960]  ? lockdep_hardirqs_on+0x9c/0x150
[  101.833840][ T5960]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  101.833847][ T5960]  ? exc_page_fault+0xab/0x100
[  101.833856][ T5960]  entry_SYSCALL_64_after_hwframe+0x77/0x7f

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Complete Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 - Subject Line:**
- Subsystem: `jfs` (JFS filesystem, directory B+-tree)
- Action verb: "add" (integrity check to "prevent" out-of-bounds)
- Summary: Adds dtroot_t integrity validation to catch corrupted on-disk
  data before it triggers UBSAN/OOB access

**Step 1.2 - Tags:**
- `Signed-off-by: Yun Zhou <yun.zhou@windriver.com>` - author
- `Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>` - JFS
  maintainer; applied the patch
- No Fixes: tag (expected for manual review)
- No Reported-by: tag
- No Cc: stable tag

**Step 1.3 - Commit Body:**
- Bug: Corrupted on-disk `dtroot_t` structure can cause out-of-bounds
  array access (index -1 into `struct dtslot[128]`)
- Concrete UBSAN trace provided: `index -1 is out of range for type
  'struct dtslot[128]'` in `dtInsertEntry+0x936`
- Call chain: `do_syscall_64` -> `do_mkdirat` -> `vfs_mkdir` ->
  `jfs_mkdir` -> `dtInsert` -> `dtSplitPage` -> `dtInsertEntry` -> crash
- Root cause: No validation of `freecnt`, `freelist`, or `stbl` fields
  in dtroot after loading from disk

**Step 1.4 - Hidden Bug Fix?**
Yes. Although labeled "add check", this is a bug fix: it prevents a
concrete UBSAN out-of-bounds access from corrupted filesystem metadata.
The crash trace is real and reproducible.

---

### PHASE 2: DIFF ANALYSIS

**Step 2.1 - Inventory:**
- `fs/jfs/jfs_dtree.c`: +86 lines (new `check_dtroot()` function)
- `fs/jfs/jfs_dtree.h`: +2 lines (extern declaration)
- `fs/jfs/jfs_imap.c`: +4 lines (call site in `copy_from_dinode()`)
- Total: ~92 lines added, 0 removed
- Scope: Single new validation function + one call site

**Step 2.2 - Code Flow Change:**
- Before: `copy_from_dinode()` blindly copies dtroot data from disk
  inode via `memcpy(&jfs_ip->u.dir, &dip->u._dir, 384)` with no
  validation
- After: After the memcpy, `check_dtroot()` validates the structure. If
  corrupt, returns `-EIO` early

**Step 2.3 - Bug Mechanism:**
Category: **Buffer overflow / out-of-bounds access** from on-disk
corruption

The crash path:
1. `copy_from_dinode()` loads a directory inode with corrupted `freelist
   = -1` but `freecnt > 0`
2. `dtInsertEntry()` at line ~3651: `hsi = fsi = p->header.freelist;`
   (fsi = -1)
3. Line ~3652: `h = &p->slot[fsi];` => `p->slot[-1]` => UBSAN out-of-
   bounds
4. UBSAN warning confirmed in commit message at `jfs_dtree.c:3713`

The validation checks:
- `freecnt` bounded by [0, DTROOTMAXSLOT-1] (slot[0] is the header)
- `freelist = -1` when `freecnt = 0`; `freelist` in range [1,
  DTROOTMAXSLOT-1] when non-zero
- Free list traversal: no duplicates, proper termination via `next = -1`
- `nextindex` within stbl array size
- stbl entries in valid range [0, 8], no duplicates

**Step 2.4 - Fix Quality:**
- Obviously correct: Each check validates a specific documented
  constraint of the dtroot_t structure (see header definition at
  `jfs_dtree.h:132-147`)
- Self-contained: entirely a new function + one call site
- Regression risk: Very low. Only adds validation at inode load time.
  Worst case is a false positive rejecting a valid filesystem, but the
  checks match the documented constraints precisely.

---

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 - Blame:**
The buggy code in `copy_from_dinode()` at line 3103-3104
(`memcpy(&jfs_ip->u.dir, &dip->u._dir, 384)`) dates back to
`^1da177e4c3f41` (Linus Torvalds, 2005-04-16) - the initial Linux git
import. This means the vulnerability has existed since JFS was first
added to Linux.

**Step 3.2 - No Fixes: tag** to follow. Expected for manual review.

**Step 3.3 - Related Changes:**
JFS has a strong pattern of similar corruption-defense fixes:
- `a8dfb21689069` - "jfs: add index corruption check to DT_GETPAGE()"
  (syzbot-reported)
- `5dff41a863775` - "jfs: fix array-index-out-of-bounds read in
  add_missing_indices" (syzbot-reported)
- `27e56f59bab5d` - "UBSAN: array-index-out-of-bounds in dtSplitRoot"
- `7a5aa54fba2bd` - "jfs: Verify inode mode when loading from disk"
  (syzbot-reported)

This commit follows the established pattern and is standalone (no
dependencies).

**Step 3.4 - Author:**
Yun Zhou (Wind River) is not the JFS maintainer but has contributed JFS
fixes before (linelock array bounds fix). Dave Kleikamp (Oracle, JFS
maintainer) signed off.

**Step 3.5 - Dependencies:**
No dependencies. The `check_dtroot()` function uses only existing
types/constants (`dtroot_t`, `DTROOTMAXSLOT`, `DECLARE_BITMAP`,
`jfs_err`) that exist in all stable trees. The call site in
`copy_from_dinode()` adds a simple check after an existing `memcpy`.

---

### PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1:** b4 dig could not find the original submission (the commit
may be too new or the patch-id didn't match). Web searches found related
patches by Yun Zhou on JFS (linelock fix) but not this specific patch.
Lore was blocked by anti-bot protection.

**Step 4.2:** Could not retrieve the full reviewer list. However, Dave
Kleikamp (JFS maintainer) applied the patch.

**Step 4.3:** No specific external bug report (no Reported-by tag). The
UBSAN trace in the commit message serves as the bug report.

**Step 4.4-4.5:** This appears to be a standalone patch, not part of a
series.

---

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 - Key Functions:**
- `check_dtroot()` - NEW function (validation)
- `copy_from_dinode()` - MODIFIED (call site)

**Step 5.2 - Callers of `copy_from_dinode()`:**
- `diRead()` (line 384) - main inode read path, called from `jfs_iget()`
- `diReadSpecial()` (line 459) - special inode read

Both are core inode loading paths. Every JFS inode read goes through
here.

**Step 5.3 - The crash path:**
`dtInsertEntry()` (line 3630) uses `p->header.freelist` as array index
without validation:

```3651:3652:fs/jfs/jfs_dtree.c
        hsi = fsi = p->header.freelist;
        h = &p->slot[fsi];
```

If `freelist = -1` (or any invalid value), `p->slot[fsi]` is out-of-
bounds.

**Step 5.4 - Call Chain Reachability:**
`mkdir` syscall -> `vfs_mkdir` -> `jfs_mkdir` -> `dtInsert` ->
`dtSplitPage` -> `dtInsertEntry` -> CRASH. This is reachable from
unprivileged userspace on any mounted JFS filesystem.

---

### PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1:** The buggy code (`copy_from_dinode` without dtroot
validation) exists in ALL stable trees since the code dates to the
initial git import (2005). Confirmed: `jfs_imap.c` is present in v5.15,
v6.1, and v6.6 stable trees with the same vulnerable pattern.

**Step 6.2:** The patch should apply cleanly. The `copy_from_dinode()`
function in `jfs_imap.c` has only had minor changes (e.g., nlink
checking, xtree definition). The core `if (S_ISDIR) memcpy` block is
unchanged across all stable trees.

**Step 6.3:** No existing fix for this specific dtroot validation issue
in any stable tree.

---

### PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

- Subsystem: JFS filesystem (`fs/jfs/`)
- Criticality: IMPORTANT - filesystem bugs can cause data corruption;
  JFS is still used in production
- JFS is mature/stable - bugs have been present for decades
- Active pattern of syzbot-found corruption fixes being backported to
  stable

---

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 - Who is affected:** All JFS filesystem users
**Step 8.2 - Trigger:** Mounting a JFS filesystem with corrupted
directory inode metadata (can happen from disk failure, intentionally
crafted image)
**Step 8.3 - Failure mode:** UBSAN out-of-bounds array access →
potential memory corruption → kernel crash or security vulnerability.
Severity: **HIGH**
**Step 8.4 - Risk-Benefit:**
- BENEFIT: HIGH - prevents a concrete crash from corrupted on-disk data,
  affecting a code path reachable from userspace
- RISK: LOW - purely additive validation code, self-contained, no
  behavioral changes to normal operation
- Size concern: ~90 lines of new code is on the larger side, but it's
  all straightforward bounds-checking logic

---

### PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
1. Fixes a concrete UBSAN out-of-bounds access with a real crash trace
2. The crash is reachable from userspace (mkdir syscall on JFS)
3. Buggy code has existed since 2005 - affects ALL stable trees
4. JFS maintainer (Dave Kleikamp) signed off
5. Self-contained fix with no dependencies on other patches
6. Follows established JFS pattern of on-disk corruption checks (many
   similar fixes already in stable)
7. The validation logic is straightforward and obviously correct
8. Should apply cleanly to all stable trees

**Evidence AGAINST backporting:**
1. ~90 lines of new code is somewhat large for stable
2. No Reported-by: or syzbot tag (though the UBSAN trace demonstrates
   the issue)
3. No explicit Cc: stable nomination

**Assessment:** The benefits clearly outweigh the risks. The fix
prevents a real OOB access from corrupted filesystem metadata, follows
an established pattern of JFS hardening that has been extensively
backported, and is self-contained. The ~90 line size is acceptable
because it's purely validation logic.

---

### Verification

- [Phase 1] Parsed tags: Signed-off-by from author (Yun Zhou) and JFS
  maintainer (Dave Kleikamp). No Fixes:/Reported-by:/Cc: stable.
- [Phase 2] Diff analysis: ~92 lines added across 3 files. New
  check_dtroot() validation function + call in copy_from_dinode() +
  header declaration.
- [Phase 2] Verified crash path: dtInsertEntry line 3651-3652 uses
  p->header.freelist as array index without bounds checking.
- [Phase 3] git blame: Vulnerable code in copy_from_dinode dates to
  ^1da177e4c3f41 (2005, initial git import). Present in all stable
  trees.
- [Phase 3] git log: Multiple similar JFS corruption fixes exist
  (a8dfb21689069, 5dff41a863775, 27e56f59bab5d, 7a5aa54fba2bd).
- [Phase 3] Author check: Yun Zhou has prior JFS contributions; Dave
  Kleikamp is JFS maintainer.
- [Phase 4] b4 dig: Could not find original submission thread.
- [Phase 4] Web search: Found related Yun Zhou JFS patches but not this
  specific one.
- [Phase 5] Verified call chain: copy_from_dinode() called from diRead()
  (line 384) and diReadSpecial() (line 459) - core inode loading.
- [Phase 5] Verified crash reachability: mkdir syscall -> jfs_mkdir ->
  dtInsert -> dtSplitPage -> dtInsertEntry -> slot[freelist] OOB.
- [Phase 6] Verified stable tree presence: jfs_imap.c exists in
  v5.15/v6.1/v6.6 stable with same vulnerable pattern.
- [Phase 6] No pre-existing fix for dtroot validation in any stable
  tree.
- [Phase 7] JFS is mature filesystem with active syzbot-found fix
  pattern.
- [Phase 8] Severity: HIGH - OOB access from userspace-reachable path on
  corrupted fs.
- UNVERIFIED: Could not find original lore discussion or confirm
  explicit reviewer feedback.

**YES**

 fs/jfs/jfs_dtree.c | 86 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/jfs/jfs_dtree.h |  2 ++
 fs/jfs/jfs_imap.c  |  4 +++
 3 files changed, 92 insertions(+)

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 9ab3f2fc61d17..8abd9c7663ea4 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -4297,3 +4297,89 @@ int dtModify(tid_t tid, struct inode *ip,
 
 	return 0;
 }
+
+bool check_dtroot(dtroot_t *p)
+{
+	DECLARE_BITMAP(bitmap, DTROOTMAXSLOT) = {0};
+	int i;
+
+	/* freecnt cannot be negative or exceed DTROOTMAXSLOT-1
+	 * (since slot[0] is occupied by the header).
+	 */
+	if (unlikely(p->header.freecnt < 0 ||
+				p->header.freecnt > DTROOTMAXSLOT - 1)) {
+		jfs_err("Bad freecnt:%d in dtroot\n", p->header.freecnt);
+		return false;
+	} else if (p->header.freecnt == 0) {
+		/* No free slots: freelist must be -1 */
+		if (unlikely(p->header.freelist != -1)) {
+			jfs_err("freecnt=0, but freelist=%d in dtroot\n",
+					p->header.freelist);
+			return false;
+		}
+	} else {
+		int fsi, i;
+		/* When there are free slots, freelist must be a valid slot index in
+		 * 1~DTROOTMAXSLOT-1(since slot[0] is occupied by the header).
+		 */
+		if (unlikely(p->header.freelist < 1 ||
+					p->header.freelist >= DTROOTMAXSLOT)) {
+			jfs_err("Bad freelist:%d in dtroot\n", p->header.freelist);
+			return false;
+		}
+
+		/* Traverse the free list to check validity of all node indices */
+		fsi = p->header.freelist;
+		for (i = 0; i < p->header.freecnt - 1; i++) {
+			/* Check for duplicate indices in the free list */
+			if (unlikely(__test_and_set_bit(fsi, bitmap))) {
+				jfs_err("duplicate index%d in slot in dtroot\n", fsi);
+				return false;
+			}
+			fsi = p->slot[fsi].next;
+
+			/* Ensure the next slot index in the free list is valid */
+			if (unlikely(fsi < 1 || fsi >= DTROOTMAXSLOT)) {
+				jfs_err("Bad index:%d in slot in dtroot\n", fsi);
+				return false;
+			}
+		}
+
+		/* The last node in the free list must terminate with next = -1 */
+		if (unlikely(p->slot[fsi].next != -1)) {
+			jfs_err("Bad next:%d of the last slot in dtroot\n",
+					p->slot[fsi].next);
+			return false;
+		}
+	}
+
+	/* Validate nextindex (next free entry index in stbl)
+	 * stbl array has size 8 (indices 0~7).
+	 * It may get set to 8 when the last free slot has been filled.
+	 */
+	if (unlikely(p->header.nextindex > ARRAY_SIZE(p->header.stbl))) {
+		jfs_err("Bad nextindex:%d in dtroot\n", p->header.nextindex);
+		return false;
+	}
+
+	/* Validate index validity of stbl array (8 elements)
+	 * Each entry in stbl is a slot index, with valid range: -1 (invalid)
+	 * or 0~8 (slot[0]~slot[8])
+	 */
+	for (i = 0; i < p->header.nextindex; i++) {
+		int idx = p->header.stbl[i];
+
+		if (unlikely(idx < 0 || idx >= 9)) {
+			jfs_err("Bad index:%d of stbl[%d] in dtroot\n", idx, i);
+			return false; /* stbl entry points out of slot array range */
+		}
+
+		/* Check for duplicate valid indices (skip check for idx=0) */
+		if (unlikely(idx && __test_and_set_bit(idx, bitmap))) {
+			jfs_err("Duplicate index:%d in stbl in dtroot\n", idx);
+			return false;
+		}
+	}
+
+	return true;
+}
diff --git a/fs/jfs/jfs_dtree.h b/fs/jfs/jfs_dtree.h
index 1758289647a0e..94dc16123c87e 100644
--- a/fs/jfs/jfs_dtree.h
+++ b/fs/jfs/jfs_dtree.h
@@ -253,4 +253,6 @@ extern int dtModify(tid_t tid, struct inode *ip, struct component_name * key,
 		    ino_t * orig_ino, ino_t new_ino, int flag);
 
 extern int jfs_readdir(struct file *file, struct dir_context *ctx);
+
+extern bool check_dtroot(dtroot_t *p);
 #endif				/* !_H_JFS_DTREE */
diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index 294a67327c735..fbb5f7966b754 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -3102,6 +3102,10 @@ static int copy_from_dinode(struct dinode * dip, struct inode *ip)
 
 	if (S_ISDIR(ip->i_mode)) {
 		memcpy(&jfs_ip->u.dir, &dip->u._dir, 384);
+		if (!check_dtroot(&jfs_ip->i_dtroot)) {
+			jfs_error(ip->i_sb, "Corrupt dtroot\n");
+			return -EIO;
+		}
 	} else if (S_ISREG(ip->i_mode) || S_ISLNK(ip->i_mode)) {
 		memcpy(&jfs_ip->i_xtroot, &dip->di_xtroot, 288);
 	} else
-- 
2.53.0

