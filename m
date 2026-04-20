Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFF63DE432;
	Mon, 20 Apr 2026 13:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691460; cv=none; b=ueqpwBSwIUFyI8J7OT0VhgwFYmO3MsOJDQZ8quuq4176+APKvAVXu/JgKy/3hTuNhHS8jwtRjkLQFrTl9ygBwg8NpVqwpNWU66qJIriaOfHph1N6kYz6JwyE2+5Fw64XsN5tSURtBFEn2LWcLRKb0k4xFwz0sJuXNZeN7nedKTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691460; c=relaxed/simple;
	bh=MdskwkX7po6mo27QWZXsVB1TlC4vDRE5LcUcrDKVqgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EzdoVqQMeEx4ZLTYbONNpqTFzhQoWicySJ9nDxevICrreCYZOwDI5bz8xGLB5MRSxTsInijCAKraOcAKa2XU37m+v8MAgoaxP0Dj2kNKNSajZdmdx0tmo7PywH96Z9Pc56Tko9RztjiBvVZScAB7soDi4SpLZGO4ECRomYlhhWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JtI/8Qvi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JtI/8Qvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F16C19425;
	Mon, 20 Apr 2026 13:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691459;
	bh=MdskwkX7po6mo27QWZXsVB1TlC4vDRE5LcUcrDKVqgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtI/8QvilcP3ULixDcFxBmdQUKh1pYawGyZAN+KbmK+GSWUY/XtMlNTimJ/Jy6QNn
	 xD5bu9ALHeydPQEXTOxvcjr4qCVNYqFNY1k9vTJMYk9iwrIFr2NPSBK93z6ZcSj77M
	 eIGiIfUWWZE/md1DKHlIgqJkqQiCDPDlTttooGpc+I6A2IjucGWZOffK2sCsLtxOSw
	 WLrDKYqs4BXl07zSDtj5qRwT6jAVkOYt2iz3BphfmW2k9gvv1jZ1QHWh4rGcohqTtw
	 gy9OAMPz258ls+GDmLlTXIYr+IyAGroOaoUHHjeKf8lSvFJL1tH697zwYXUmT3pcRw
	 ABmm5ZUywnnfQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Viacheslav Dubeyko <slava@dubeyko.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	linux-fsdevel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] hfsplus: fix generic/642 failure
Date: Mon, 20 Apr 2026 09:17:15 -0400
Message-ID: <20260420132314.1023554-41-sashal@kernel.org>
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

From: Viacheslav Dubeyko <slava@dubeyko.com>

[ Upstream commit c1307d18caa819ddc28459d858eb38fdd6c3f8a0 ]

The xfstests' test-case generic/642 finishes with
corrupted HFS+ volume:

sudo ./check generic/642
[sudo] password for slavad:
FSTYP -- hfsplus
PLATFORM -- Linux/x86_64 hfsplus-testing-0001 7.0.0-rc1+ #26 SMP PREEMPT_DYNAMIC Mon Mar 23 17:24:32 PDT 2026
MKFS_OPTIONS -- /dev/loop51
MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch

generic/642 6s ... _check_generic_filesystem: filesystem on /dev/loop51 is inconsistent
(see xfstests-dev/results//generic/642.full for details)

Ran: generic/642
Failures: generic/642
Failed 1 of 1 tests

sudo fsck.hfs -d /dev/loop51
** /dev/loop51
Using cacheBlockSize=32K cacheTotalBlock=1024 cacheSize=32768K.
Executing fsck_hfs (version 540.1-Linux).
** Checking non-journaled HFS Plus Volume.
The volume name is untitled
** Checking extents overflow file.
** Checking catalog file.
** Checking multi-linked files.
** Checking catalog hierarchy.
** Checking extended attributes file.
invalid free nodes - calculated 1637 header 1260
Invalid B-tree header
Invalid map node
(8, 0)
** Checking volume bitmap.
** Checking volume information.
Verify Status: VIStat = 0x0000, ABTStat = 0xc000 EBTStat = 0x0000
CBTStat = 0x0000 CatStat = 0x00000000
** Repairing volume.
** Rechecking volume.
** Checking non-journaled HFS Plus Volume.
The volume name is untitled
** Checking extents overflow file.
** Checking catalog file.
** Checking multi-linked files.
** Checking catalog hierarchy.
** Checking extended attributes file.
** Checking volume bitmap.
** Checking volume information.
** The volume untitled was repaired successfully.

The fsck tool detected that Extended Attributes b-tree is corrupted.
Namely, the free nodes number is incorrect and map node
bitmap has inconsistent state. Analysis has shown that during
b-tree closing there are still some lost b-tree's nodes in
the hash out of b-tree structure. But this orphaned b-tree nodes
are still accounted as used in map node bitmap:

tree_cnid 8, nidx 0, node_count 1408, free_nodes 1403
tree_cnid 8, nidx 1, node_count 1408, free_nodes 1403
tree_cnid 8, nidx 3, node_count 1408, free_nodes 1403
tree_cnid 8, nidx 54, node_count 1408, free_nodes 1403
tree_cnid 8, nidx 67, node_count 1408, free_nodes 1403
tree_cnid 8, nidx 0, prev 0, next 0, parent 0, num_recs 3, type 0x1, height 0
tree_cnid 8, nidx 1, prev 0, next 0, parent 3, num_recs 1, type 0xff, height 1
tree_cnid 8, nidx 3, prev 0, next 0, parent 0, num_recs 1, type 0x0, height 2
tree_cnid 8, nidx 54, prev 29, next 46, parent 3, num_recs 0, type 0xff, height 1
tree_cnid 8, nidx 67, prev 8, next 14, parent 3, num_recs 0, type 0xff, height 1

This issue happens in hfs_bnode_split() logic during detection
the possibility of moving half ot the records out of the node.
The hfs_bnode_split() contains a loop that implements
a roughly 50/50 split of the B-tree node's records by scanning
the offset table to find where the data crosses the node's midpoint.
If this logic detects the incapability of spliting the node, then
it simply calls hfs_bnode_put() for newly created node. However,
node is not set as HFS_BNODE_DELETED and real deletion of node
doesn't happen. As a result, the empty node becomes orphaned but
it is still accounted as used. Finally, fsck tool detects this
inconsistency of HFS+ volume.

This patch adds call of hfs_bnode_unlink() before hfs_bnode_put()
for the case if new node cannot be used for spliting the existing
node.

sudo ./check generic/642
FSTYP         -- hfsplus
PLATFORM      -- Linux/x86_64 hfsplus-testing-0001 7.0.0-rc1+ #26 SMP PREEMPT_DYNAMIC Fri Apr  3 12:39:13 PDT 2026
MKFS_OPTIONS  -- /dev/loop51
MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch

generic/642 40s ...  39s
Ran: generic/642
Passed all 1 tests

Closes: https://github.com/hfs-linux-kernel/hfs-linux-kernel/issues/242
cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
cc: Yangtao Li <frank.li@vivo.com>
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260403230556.614171-6-slava@dubeyko.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
Record: [hfsplus] [fix] Fix filesystem corruption triggered by xfstests
generic/642 test case in the B-tree node split logic.

**Step 1.2: Tags**
- `Closes: https://github.com/hfs-linux-kernel/hfs-linux-
  kernel/issues/242` - Tracked issue
- `cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>` - HFS
  co-maintainer
- `cc: Yangtao Li <frank.li@vivo.com>` - HFS co-maintainer
- `cc: linux-fsdevel@vger.kernel.org` - filesystem mailing list
- `Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>` - Author and
  HFS maintainer
- `Link:
  https://lore.kernel.org/r/20260403230556.614171-6-slava@dubeyko.com`
- No Fixes: tag, no Reported-by, no Cc: stable (expected)

Record: Author is the HFS/HFS+ subsystem maintainer. No syzbot
involvement. Fix has a tracked GitHub issue.

**Step 1.3: Commit Body Analysis**
The commit message includes detailed fsck output showing the corruption:
"invalid free nodes - calculated 1637 header 1260" and "Invalid B-tree
header / Invalid map node". The Extended Attributes B-tree (cnid 8)
becomes corrupted with orphaned nodes that are allocated in the bitmap
but not part of the B-tree structure. The root cause is that
`hfs_bnode_split()` allocates a new node via `hfs_bmap_alloc()` but when
the split fails (node can't be split), it only calls `hfs_bnode_put()`
without `hfs_bnode_unlink()`, so the node remains "used" in the bitmap
forever.

Record: Bug = filesystem corruption (orphaned B-tree nodes). Symptom =
fsck detects inconsistent free node count and invalid map node bitmap.
Root cause = missing `hfs_bnode_unlink()` in `hfs_bnode_split()` error
path.

**Step 1.4: Hidden Bug Fix Detection**
Record: This is an explicit bug fix, not disguised. The title says "fix"
and the description clearly explains the corruption mechanism.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files changed: `fs/hfsplus/brec.c` only
- Single function modified: `hfs_bnode_split()`
- Net change: ~8 lines added (3 new variables, 1 `hfs_bnode_unlink`
  call, plus magic-number-to-named-constant replacements)
- Scope: Single-file, single-function surgical fix + cleanup

Record: 1 file changed. Function: `hfs_bnode_split()`. Classification:
single-file surgical fix.

**Step 2.2: Code Flow Changes**
The diff has two categories of changes:

1. **Bug fix (critical)**: Addition of `hfs_bnode_unlink(new_node)`
   before `hfs_bnode_put(new_node)` in the error path when the split
   fails (the `/* panic? */` path). Before: node was only `put` (memory
   freed but bitmap allocation kept). After: node is properly `unlinked`
   (sets `HFS_BNODE_DELETED` flag) then `put` (triggers
   `hfs_bmap_free()` to release bitmap allocation).

2. **Cleanup (non-functional)**: Magic numbers `14` → `node_desc_size`,
   `2` → `rec_size`, `4` → `(2 * rec_size)`. All mathematically
   equivalent.

Record: Error path fix + equivalent constant replacement. The error path
now properly frees allocated nodes.

**Step 2.3: Bug Mechanism**
This is a **resource leak** (bitmap allocation leak) that causes
**filesystem corruption**:
- `hfs_bmap_alloc()` marks a node as used in the bitmap
- `hfs_bnode_put()` only calls `hfs_bmap_free()` if `HFS_BNODE_DELETED`
  flag is set (verified in `bnode.c` lines 685-692)
- `hfs_bnode_unlink()` sets `HFS_BNODE_DELETED` (verified in `bnode.c`
  line 423)
- Without `hfs_bnode_unlink()`, the bitmap entry persists = orphaned
  node

Record: Resource leak (bitmap) → filesystem corruption. Bug category:
missing cleanup on error path.

**Step 2.4: Fix Quality**
- The fix follows the exact same pattern used in `hfs_brec_remove()` at
  line 199: `hfs_bnode_unlink(node)` before the node is released
- Obviously correct: the mechanism chain is verifiable (`unlink → set
  DELETED → put → bmap_free`)
- Regression risk: LOW. `hfs_bnode_unlink()` adjusts prev/next pointers,
  but at this point the node was never fully linked into the tree
  (node->next was set but the predecessor's next pointer wasn't updated
  yet), so the unlink is effectively a no-op for the linked list and
  just sets the DELETED flag
- The magic number cleanup is equivalent and safe

Record: Fix is obviously correct, follows established pattern. Minimal
regression risk.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The buggy code (lines 268-283, the `for(;;)` loop and error path with
`/* panic? */`) dates to commit `1da177e4c3f41` (Linux 2.6.12-rc2, April
2005). This means the bug has existed since the very beginning of the
git era - ALL stable kernel trees are affected.

Record: Bug introduced in 2005 (Linux 2.6.12-rc2). Present in ALL stable
trees.

**Step 3.2: Fixes Tag**
No Fixes: tag present (expected).

**Step 3.3: File History**
`fs/hfsplus/brec.c` has 18 commits total. Recent activity shows multiple
xfstests fixes from the same author (generic/020, generic/037,
generic/062, generic/480, generic/498). The function has been
essentially unchanged since 2005 with only minor modifications by Al
Viro in 2010 for error handling.

Record: File has low churn. Related recent fixes from same author for
other xfstests.

**Step 3.4: Author**
Viacheslav Dubeyko is the HFS/HFS+ subsystem MAINTAINER (confirmed by
the merge tag from Linus pulling from his tree). He has numerous recent
commits in this subsystem.

Record: Author is the subsystem maintainer. High authority.

**Step 3.5: Dependencies**
This is PATCH 5/5 of a series "hfsplus: fix b-tree logic issues".
However:
- Patches 1-4 modify `bnode.c`, `btree.c`, `xattr.c`, `inode.c`,
  `super.c` - NONE modify `brec.c`
- PATCH 5 is the ONLY patch touching `brec.c` → no textual conflicts
- PATCH 1 adds spin_lock in `hfs_bnode_unlink()` (race protection) but
  `hfs_bnode_unlink()` works correctly without it
- PATCHes 2-3 improve `hfs_bmap_free()` error handling and add
  `hfs_btree_write()` calls, but the basic free mechanism works without
  these
- PATCH 4 reworks xattr map node creation - unrelated to `brec.c`

Record: No dependencies on patches 1-4. This patch is self-contained.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: Original Discussion**
b4 dig was unable to find the commit. The Link tag points to
`https://lore.kernel.org/r/20260403230556.614171-6-slava@dubeyko.com`.
The series is "[PATCH 0/5] hfsplus: fix b-tree logic issues". The GitHub
issue #242 confirmed the bug report and was closed by the author
referencing this patchset.

Record: Tracked via GitHub issue. Series posted to linux-fsdevel. Lore
not accessible due to bot protection.

**Step 4.2: Reviewers**
The patch was CC'd to John Paul Adrian Glaubitz and Yangtao Li (HFS co-
maintainers) and linux-fsdevel@vger.kernel.org. The author is the
subsystem maintainer.

Record: Sent to appropriate maintainers and mailing list.

**Step 4.3: Bug Report**
GitHub issue #242 was filed by the maintainer himself after xfstests
testing on v7.0.0-rc1. The issue includes full fsck output confirming
the corruption.

Record: Bug report with full evidence of corruption.

**Step 4.4-4.5: Related Patches / Stable History**
No prior stable discussions found for this specific issue.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Functions**
Modified: `hfs_bnode_split()` (the only function changed)

**Step 5.2: Callers**
`hfs_bnode_split()` is called from:
1. `hfs_brec_insert()` (line 100) - triggered by ANY B-tree insertion
2. `hfs_brec_update_parent()` (line 400) - triggered during parent key
   updates

`hfs_brec_insert()` is called from:
- `catalog.c` - file/directory creation, renaming (4 call sites)
- `attributes.c` - extended attribute insertion
- `extents.c` - extent record insertion
- `brec.c` - recursive parent update

Record: Extremely high-impact code path. Reachable from all HFS+ file
operations that require B-tree insertion.

**Step 5.3-5.4: Callees / Call Chain**
The bug path: userspace file operation → VFS → HFS+ catalog/xattr/extent
operation → `hfs_brec_insert()` → `hfs_bnode_split()` →
`hfs_bmap_alloc()` → fail to split → missing `hfs_bnode_unlink()` →
orphaned node → filesystem corruption.

Record: Fully reachable from userspace file operations.

**Step 5.5: Similar Patterns**
`hfs_brec_remove()` at line 199 already uses `hfs_bnode_unlink(node)`
before releasing the node - this is the correct pattern. The bug in
`hfs_bnode_split()` was the omission of this call.

Record: Established pattern exists in sibling function.

## PHASE 6: CROSS-REFERENCING

**Step 6.1: Buggy Code in Stable**
The buggy code dates to 2005 (Linux 2.6.12). ALL active stable trees
contain this bug.

Record: All stable trees affected.

**Step 6.2: Backport Complications**
The function in stable trees should be nearly identical to the current
v7.0 code (blame shows minimal changes). The diff includes magic-number-
to-constant cleanup which adds minor noise but should apply cleanly
since the base code is unchanged. If minor conflicts arise, the critical
one-line fix (`hfs_bnode_unlink(new_node)`) can be easily cherry-picked
manually.

Record: Expected clean apply or trivial adaptation needed.

**Step 6.3: Related Fixes Already in Stable**
No related fixes for this specific issue found in stable.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem**
HFS+ filesystem (`fs/hfsplus/`). Criticality: IMPORTANT - used by macOS
dual-boot systems, media devices, and anyone accessing Apple-formatted
volumes.

**Step 7.2: Activity**
Active development with ~20 recent commits, many of which are xfstests
fixes from the maintainer.

Record: Subsystem is actively maintained.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
Users of HFS+ filesystems on Linux (dual-boot macOS, Apple media
devices, external drives).

**Step 8.2: Trigger Conditions**
Triggered when a B-tree node split fails (records too large to split
evenly). This happens during normal file operations (creating files with
xattrs, large directories, etc.). The xfstests generic/642 test reliably
triggers it.

Record: Triggered by normal file operations. Reproducible.

**Step 8.3: Failure Mode Severity**
**CRITICAL**: Filesystem corruption (orphaned B-tree nodes, incorrect
free node count, invalid map node bitmap). This is silent data
corruption - the filesystem appears to work but is internally
inconsistent, potentially leading to data loss.

Record: CRITICAL - silent filesystem corruption.

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: Very High - prevents filesystem corruption on all HFS+
  volumes
- RISK: Very Low - one added function call following established
  pattern, plus equivalent constant replacements
- Fix is 1 functional line + cleanup in a single function

Record: Extremely favorable benefit-to-risk ratio.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Compilation**

FOR backporting:
- Fixes CRITICAL filesystem corruption (orphaned B-tree nodes)
- Bug present since Linux 2.6.12 (2005) - affects ALL stable trees
- Reproducible via xfstests generic/642
- Fix is obviously correct, follows established pattern
  (`hfs_brec_remove()` already uses `hfs_bnode_unlink()`)
- Mechanism verified: `unlink → set DELETED → put → bmap_free`
- Author is the HFS/HFS+ subsystem maintainer
- Self-contained - no dependencies on other patches in the series
- Only modifies one function in one file
- Test evidence: xfstests passes after fix

AGAINST backporting:
- Patch includes magic-number cleanup alongside the bug fix (makes diff
  larger than necessary)
- Part of a 5-patch series (but verified as standalone)
- No explicit `Cc: stable` or `Fixes:` tag (expected)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** - verified mechanism, follows
   established pattern, tested with xfstests
2. Fixes real bug? **YES** - filesystem corruption
3. Important issue? **YES** - CRITICAL (data corruption)
4. Small and contained? **YES** - single function in single file, ~50
   lines of diff
5. No new features/APIs? **YES** - pure bug fix + cleanup
6. Can apply to stable? **YES** - code unchanged since 2005

**Step 9.3: Exception Categories**
Not applicable - this is a standard bug fix.

**Step 9.4: Decision**
The evidence overwhelmingly supports backporting. This fixes filesystem
data corruption that has existed since 2005 in a commonly exercised code
path. The fix is minimal, correct, and verified.

## Verification

- [Phase 1] Parsed tags: Closes: GitHub issue #242, Link: to lore, CC:
  to HFS co-maintainers
- [Phase 2] Diff analysis: Core fix is 1 line
  (`hfs_bnode_unlink(new_node)`) + magic number cleanup, all in
  `hfs_bnode_split()`
- [Phase 2] Verified equivalence: `14 == sizeof(struct hfs_bnode_desc)`,
  `2 == sizeof(__be16)`, `4 == 2*sizeof(__be16)` - all constant
  replacements are mathematically identical
- [Phase 3] git blame: Buggy code from commit `1da177e4c3f41` (Linux
  2.6.12-rc2, 2005), present in ALL stable trees
- [Phase 3] git log: 18 total commits to brec.c, minimal changes to the
  affected function
- [Phase 3] Author check: Viacheslav Dubeyko is the HFS/HFS+ maintainer
  (confirmed via merge tag from Linus)
- [Phase 3] Series analysis: PATCH 5/5, but patches 1-4 don't touch
  brec.c - verified no textual or functional dependencies
- [Phase 4] GitHub issue #242: Confirmed bug report with fsck evidence,
  closed by patchset
- [Phase 5] Verified `hfs_bnode_unlink()` sets `HFS_BNODE_DELETED` flag
  (bnode.c:423)
- [Phase 5] Verified `hfs_bnode_put()` calls `hfs_bmap_free()` only when
  `HFS_BNODE_DELETED` set (bnode.c:685-690)
- [Phase 5] Verified `hfs_brec_remove()` uses same `hfs_bnode_unlink()`
  pattern (brec.c:199)
- [Phase 5] Callers traced: `hfs_bnode_split()` reachable from
  catalog/xattr/extent operations → all normal file operations
- [Phase 6] Code unchanged since 2005 in all stable trees
- [Phase 8] Failure mode: CRITICAL - silent filesystem corruption

**YES**

 fs/hfsplus/brec.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/hfsplus/brec.c b/fs/hfsplus/brec.c
index 6796c1a80e997..e3df89284079d 100644
--- a/fs/hfsplus/brec.c
+++ b/fs/hfsplus/brec.c
@@ -239,6 +239,9 @@ static struct hfs_bnode *hfs_bnode_split(struct hfs_find_data *fd)
 	struct hfs_bnode_desc node_desc;
 	int num_recs, new_rec_off, new_off, old_rec_off;
 	int data_start, data_end, size;
+	size_t rec_off_tbl_size;
+	size_t node_desc_size = sizeof(struct hfs_bnode_desc);
+	size_t rec_size = sizeof(__be16);
 
 	tree = fd->tree;
 	node = fd->bnode;
@@ -265,18 +268,22 @@ static struct hfs_bnode *hfs_bnode_split(struct hfs_find_data *fd)
 		return next_node;
 	}
 
-	size = tree->node_size / 2 - node->num_recs * 2 - 14;
-	old_rec_off = tree->node_size - 4;
+	rec_off_tbl_size = node->num_recs * rec_size;
+	size = tree->node_size / 2;
+	size -= node_desc_size;
+	size -= rec_off_tbl_size;
+	old_rec_off = tree->node_size - (2 * rec_size);
+
 	num_recs = 1;
 	for (;;) {
 		data_start = hfs_bnode_read_u16(node, old_rec_off);
 		if (data_start > size)
 			break;
-		old_rec_off -= 2;
+		old_rec_off -= rec_size;
 		if (++num_recs < node->num_recs)
 			continue;
-		/* panic? */
 		hfs_bnode_put(node);
+		hfs_bnode_unlink(new_node);
 		hfs_bnode_put(new_node);
 		if (next_node)
 			hfs_bnode_put(next_node);
@@ -287,7 +294,7 @@ static struct hfs_bnode *hfs_bnode_split(struct hfs_find_data *fd)
 		/* new record is in the lower half,
 		 * so leave some more space there
 		 */
-		old_rec_off += 2;
+		old_rec_off += rec_size;
 		num_recs--;
 		data_start = hfs_bnode_read_u16(node, old_rec_off);
 	} else {
@@ -295,27 +302,28 @@ static struct hfs_bnode *hfs_bnode_split(struct hfs_find_data *fd)
 		hfs_bnode_get(new_node);
 		fd->bnode = new_node;
 		fd->record -= num_recs;
-		fd->keyoffset -= data_start - 14;
-		fd->entryoffset -= data_start - 14;
+		fd->keyoffset -= data_start - node_desc_size;
+		fd->entryoffset -= data_start - node_desc_size;
 	}
 	new_node->num_recs = node->num_recs - num_recs;
 	node->num_recs = num_recs;
 
-	new_rec_off = tree->node_size - 2;
-	new_off = 14;
+	new_rec_off = tree->node_size - rec_size;
+	new_off = node_desc_size;
 	size = data_start - new_off;
 	num_recs = new_node->num_recs;
 	data_end = data_start;
 	while (num_recs) {
 		hfs_bnode_write_u16(new_node, new_rec_off, new_off);
-		old_rec_off -= 2;
-		new_rec_off -= 2;
+		old_rec_off -= rec_size;
+		new_rec_off -= rec_size;
 		data_end = hfs_bnode_read_u16(node, old_rec_off);
 		new_off = data_end - size;
 		num_recs--;
 	}
 	hfs_bnode_write_u16(new_node, new_rec_off, new_off);
-	hfs_bnode_copy(new_node, 14, node, data_start, data_end - data_start);
+	hfs_bnode_copy(new_node, node_desc_size,
+			node, data_start, data_end - data_start);
 
 	/* update new bnode header */
 	node_desc.next = cpu_to_be32(new_node->next);
-- 
2.53.0

