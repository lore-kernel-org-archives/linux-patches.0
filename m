Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B88F500A9E;
	Mon, 19 Oct 2026 13:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418312; cv=none; b=of34982+7Jsk2IrvJsCIpknMA+nIhgViqcXe2u9cK6rZWYpN72eUI5kumtW/X/mlBf9um+k5ntERXN2Z5cbEPBqFsLP6dHDE+TzzuVcaKiTmClEWquWqAtli08Ts8mZTew1qYfZRni1g0G+pSPlbYERe/+n8CYvGYrKf/geVmr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418312; c=relaxed/simple;
	bh=DEsVVjTZVY90Ka7n53WmGuTJTSTE5ygZt3C6uVjN1hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cQ+Sh3+VHromfjGy5ON3VNk8aELmEpTxRdGqlr3IHXuQuF8b1jXzBlXUR3dMrO68TzVtyG3SujMVP7nOp/iMKYv0XIJA5RWkri1WvMgOMPUQtBZkaPk0mlBNHDUqr+t87bUxDkoflOSGvTdri+YXCvig6jgl4+Maqk3gbB1iIyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mur3lRdz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mur3lRdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E051F000C6;
	Mon, 19 Oct 2026 13:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418309;
	bh=wG4zJt5e8jRWe/qFhezOQCc+266LkI357X4K5fg4FTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mur3lRdzZH2EuRdGw30rPO+vRF3B9FV9hbjwURuWK/bG9vj/yJHEbuE5ZVNJX7xp1
	 2HVWkyHtg5aNJwlgpoM4AjueJC9F4hHcOdDePzUcLiIjAVs0MTSOTz/n2ojctmBjyC
	 v9rt7Gv9/nFWz7a18xatv/qtENKJNGdS7bDfhPdpG4L00J2fKmvSFPzoe+iT2f3/YZ
	 zUvTWaHjnX88tJY8+bOAD8yRGg1qMnzVEMgCCK++JdfoAolvsnMPkBqBojrSRe6nbd
	 mcrj1uwYCtD9oWZmoIcSWRD+WzZx0PadiMRhMSpNnc+QZzGAlymKVX+tJ4Q/VgjEWf
	 8LANJinElQYpw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+6a680377e13041c19d50@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>,
	jack@suse.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] udf: avoid recursive s_alloc_mutex deadlock when freeing AED blocks
Date: Mon, 19 Oct 2026 09:47:27 -0400
Message-ID: <20261019135441.1420968-156-sashal@kernel.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit 31e5e0c8c8e2617eb9f7a20c1cf5df23f592ade2 ]

udf_table_prealloc_blocks() and udf_table_new_block() call
udf_delete_aext() on the unallocated-space-table inode while holding
sbi->s_alloc_mutex. When the deleted allocation descriptor empties an
allocation-extent (AED) block, udf_delete_aext() returns that block to
free space via udf_free_blocks(). For a table-managed partition that
path is udf_free_blocks() -> udf_table_free_blocks() ->
mutex_lock(&sbi->s_alloc_mutex), i.e. the task tries to acquire a mutex
it already holds.

On a PREEMPT_RT kernel the rtmutex deadlock detector reports this as
-EDEADLK:

  rtmutex deadlock detected
  WARNING: kernel/locking/rtmutex.c:1698 at rt_mutex_handle_deadlock
  udf_table_free_blocks fs/udf/balloc.c:376 [inline]
  udf_free_blocks+0xa8c/0x1900 fs/udf/balloc.c:678
  udf_delete_aext+0x4f5/0xc00 fs/udf/inode.c:2381
  udf_table_prealloc_blocks fs/udf/balloc.c:544 [inline]
  udf_prealloc_blocks+0xbd4/0x10e0 fs/udf/balloc.c:702

On a non-RT kernel the same path is a hard self-deadlock (or a lockdep
recursive-locking splat). It is reachable from a crafted UDF image via
the write/sendfile path.

The allocator already refuses to recurse on the add side: see the
comment in udf_table_free_blocks() explaining why it must not call
udf_add_aext() while holding s_alloc_mutex. Apply the same rule to the
delete side. Let udf_delete_aext() report the AED block it would
otherwise free through a new out-parameter, and have the two callers
that hold s_alloc_mutex free it after dropping the lock. The block is
already unlinked from the inode's descriptor chain by then, so nothing
can reference it in the meantime. All other callers pass NULL and keep
freeing the block inline, exactly as before.

The out-parameter is pre-initialised with the reserved partition number
0xFFFF, which can never name a real block, so the caller can tell
whether a block was handed back.

Reported-by: syzbot+6a680377e13041c19d50@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6a680377e13041c19d50
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: https://syzkaller.appspot.com/bug?extid=6a680377e13041c19d50
Link: https://patch.msgid.link/20260621035841.56194-1-kartikey406@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real UDF self-deadlock on `s_alloc_mutex`, found by syzbot
with a C repro, and the local 7.3 tree has the same allocator path. It
is a contained locking fix, not a feature.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [udf] [avoid] recursive `s_alloc_mutex` deadlock when freeing
AED blocks. Subsystem is UDF (`fs/udf`). Verb “avoid” is a
deadlock/safety fix, not a feature.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Reported-by: syzbot+6a680377e13041c19d50@syzkaller.appspotmail.com
  (fuzzer, C repro)
- Closes: https://syzkaller.appspot.com/bug?extid=6a680377e13041c19d50
- Link: same syzkaller URL
- Link:
  https://patch.msgid.link/20260621035841.56194-1-kartikey406@gmail.com
- Signed-off-by: Deepanshu Kartikey (author)
- Signed-off-by: Jan Kara (UDF maintainer)
- No Fixes: tag (expected)
- No Cc: stable (expected)
- Ignore pipeline SOBs / “[Upstream commit …]” if present; none on the
  real commit `31e5e0c8c8e2`

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: `udf_table_prealloc_blocks()` / `udf_table_new_block()` call
  `udf_delete_aext()` while holding `sbi->s_alloc_mutex`. Emptying an
  AED block makes `udf_delete_aext()` call `udf_free_blocks()` →
  `udf_table_free_blocks()` → `mutex_lock(&sbi->s_alloc_mutex)` on a
  mutex the same task already holds.
- Symptom: PREEMPT_RT reports `rtmutex deadlock detected` / `-EDEADLK`;
  non-RT is a hard self-deadlock or lockdep recursive-lock splat.
- Trigger: crafted UDF image, write/sendfile.
- Root cause: delete-side recursion into the table allocator under the
  same mutex. Add-side already refuses this (`udf_table_free_blocks()`
  comment: must not call `udf_add_aext()` while holding the mutex).
- Version info in the message: none. Stack points at `fs/udf/balloc.c` /
  `inode.c`.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit deadlock fix. The
extra `udf_delete_aext()` argument is the mechanism, not a new user-
visible API.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record: 4 files, +29 / −7 (12+19+2+3). Functions:
`udf_table_prealloc_blocks`, `udf_table_new_block`, `udf_delete_aext`,
`udf_update_extents`, `udf_discard_prealloc`, plus the prototype in
`udfdecl.h`. Scope: single-subsystem surgical change.

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- `udf_delete_aext()`: when `epos.bh != oepos.bh` (AED block emptied),
  previously always called `udf_free_blocks()` inline. Now: if `freed !=
  NULL`, copy `epos.block` to `*freed`; else free inline as before.
- `udf_table_prealloc_blocks` / `udf_table_new_block`: pass `&freed`
  (sentinel `partitionReferenceNum = 0xFFFF`), unlock `s_alloc_mutex`,
  then `udf_free_blocks()` if a real block was handed back.
- `udf_update_extents` / `udf_discard_prealloc`: pass `NULL` (unchanged
  inline free).
- Affected path: table-managed unallocated-space allocator, only when
  deleting an extent empties an AED block.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Deadlock / recursive locking]. `struct mutex s_alloc_mutex` is
non-recursive. Holding it and calling `udf_free_blocks()` on a
`UDF_PART_FLAG_UNALLOC_TABLE` partition re-enters
`udf_table_free_blocks()` which takes the same mutex. Fix defers that
free until after unlock. The block is already unlinked from the
descriptor chain, so it is temporarily orphaned (not in free space, not
in the chain) until the post-unlock free; it cannot be double-allocated
in the window.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct and aligned with the existing add-side rule.
All four call sites in this tree were updated. Sentinel `0xFFFF` is a
reserved partition number, so “was a block returned?” is unambiguous.
Regression risk is low: NULL callers keep old behavior; lock-holding
callers only change when an AED block is actually handed back. Pre-
existing ignored `udf_delete_aext()` return values are not introduced
here. Internal prototype change only (`udfdecl.h`, not UAPI).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Mutex around prealloc: `1e7933defd0fce` (2006, sem2mutex).
`udf_delete_aext()` calling `udf_free_blocks()` on emptied AED: present
at least since `cb00ea3528eb3` (2007 lindent; logic is older).
`udf_delete_aext()` signature last changed in `6c1e4d06a3808` (2018,
drop unused args). This is a long-standing bug, not new 7.3 code.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Bug is the combination of non-recursive
`s_alloc_mutex` (2006) and delete-aext freeing AED blocks (ancient UDF).
Both exist in this tree’s lineage.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent `fs/udf/` work is hardening and writeout fixes. No
prerequisite series for this deadlock. Follow-ups after `31e5e0c8c8e2`
on these files (`b8228f59dc58a`, `d95094d4c0a62`, writeout series) do
not revert or redo this locking change. Standalone.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Only this UDF commit by Deepanshu Kartikey in this tree.
Accepted by Jan Kara (UDF maintainer; many contemporaneous UDF commits).

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: No functional dependencies. Uses existing `struct
kernel_lb_addr`, `udf_free_blocks()`, `s_alloc_mutex`. Applies
standalone on this tree. Context around `mmb_mark_buffer_dirty` is
adjacent old code, not part of the change.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record: `b4 dig -c 31e5e0c8c8e2` →
https://patch.msgid.link/20260621035841.56194-1-kartikey406@gmail.com.
`b4 dig -a`: single v1 (plus a syzbot forward of the same subject). No
v2/v3. Thread: author patch, Sashiko bot, Jan Kara “Thanks! I've added
the patch to my tree.” No NAK. Direct lore.kernel.org fetch returned
403; full thread recovered via `b4 dig -m`.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: To: Jan Kara, RT maintainers (bigeasy, clrkwllms, rostedt). Cc:
linux-kernel, linux-rt-devel, syzbot. Appropriate: UDF maintainer + RT
list because the splat was rtmutex. Maintainer applied it.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: syzbot “WARNING in udf_free_blocks (3)”, prio:high, C repro,
first crash 2026-06-18. Status upstream, fix commit `31e5e0c8c8e2`.
Assessment: DenialOfService exploitable as DoS, FilesystemTrigger,
Unprivileged: no (mount typically privileged). Stack: `sendfile64` →
`udf_file_write_iter` → `udf_write_begin` → `udf_get_block` →
`inode_getblk` → `udf_prealloc_blocks` → `udf_table_prealloc_blocks` →
`udf_delete_aext` → `udf_free_blocks` → `udf_table_free_blocks`.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone one-patch series. Not 2/N.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: UNVERIFIED for lore.kernel.org/stable (HTTP 403). No in-tree
discussion that this was rejected from stable. Sashiko comments were
pre-existing `udf_delete_aext()` error-handling/bh-leak notes, not
objections to the deadlock fix.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `udf_delete_aext`, `udf_table_prealloc_blocks`,
`udf_table_new_block`, `udf_update_extents`, `udf_discard_prealloc`.

Step 5.2: TRACE CALLERS
Record:
- `udf_table_prealloc_blocks` ← `udf_prealloc_blocks` (UNALLOC_TABLE) ←
  `udf_prealloc_extents` ← `inode_getblk` ← `udf_map_block` /
  `__udf_get_block` ← `udf_get_block` ← `udf_write_begin` / splice /
  sendfile.
- `udf_table_new_block` ← `udf_new_block` (UNALLOC_TABLE) — allocation
  for new file blocks.
- NULL callers: extent update and prealloc discard; they do not hold
  `s_alloc_mutex` for this free.

Step 5.3: TRACE CALLEES
Record: `udf_next_aext` / `udf_write_aext` (unlink descriptors), then
either `udf_free_blocks` or out-parameter. `udf_free_blocks` dispatches
to bitmap or table; deadlock is table-only
(`UDF_PART_FLAG_UNALLOC_TABLE`).

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace-reachable: write/sendfile on a writable UDF mount with
a table-managed partition and an AED block that becomes empty. Confirmed
by syzbot C repro. Not interrupt context.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same file already special-cases add-side recursion
(`udf_table_free_blocks` must not call `udf_add_aext()` under the
mutex). This is the matching delete-side hole. Bitmap allocator does not
take this path.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Local tree is `v7.3-rc4-27-gf0100363d8c37` (`make kernelversion`
7.3.0-rc4). UDF table allocator, `s_alloc_mutex`, and `udf_delete_aext`
→ `udf_free_blocks` all exist in this lineage. Pre-image of
`31e5e0c8c8e2` shows the exact deadlock (`udf_free_blocks` under the
mutex). Bug introduced ~2006–2007, long before 7.3.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: On this tree the change matches current `fs/udf/` (commit is
already an ancestor). No missing helpers. Would apply as a small
prototype-plus-call-site edit.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No earlier different deadlock fix for this path. `31e5e0c8c8e2`
is the fix (`git merge-base --is-ancestor 31e5e0c8c8e2 HEAD` → yes).
That is the original mainline merge, not a reason to treat the bug as
unfix-worthy.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [fs/udf] [IMPORTANT]. Not mm/core, but a shipped writable
filesystem. Deadlock/DoS on mount+write is in-scope for stable.
CONFIG_UDF_FS.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature (code from 2.6 era) with ongoing hardening. Not staging.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Users of writable UDF with unallocated-space *tables* (not
bitmaps), including crafted images. Optical/ISO/USB-style UDF. Config-
specific (`CONFIG_UDF_FS`).

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Mount UDF, write/sendfile so prealloc/new_block deletes an
extent that empties an AED. Not every write; needs table partition +
that extent layout. Syzbot reproduced it. Unprivileged mount is
typically false; still a hang/DoS after a privileged mount of untrusted
media.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: [self-deadlock / RT WARNING+EDEADLK] [CRITICAL]. Non-RT: task
stuck in `mutex_lock`. RT: detected recursive deadlock. Hung writer; can
make the filesystem/unmount path unusable.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record: Benefit high (prevents hang on a real, reproduced path). Risk
low (~30 lines, UDF-internal, NULL callers unchanged, lock dropped
before re-entry). Ratio strongly favors applying it.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real recursive mutex deadlock; non-RT hang, RT splat
- syzbot, C repro, prio:high, DoS
- Reachable from sendfile/write
- Small, contained, internal-only signature change
- Same rule as existing add-side comment
- Maintainer Jan Kara applied it
- Bug is decades old; this tree has the UDF path

AGAINST:
- Trigger needs table-managed UDF and a specific AED layout (narrower
  than “every UDF write”)
- Usually needs privilege to mount
- Sashiko noted pre-existing ignored returns / bh leak (not this patch;
  not a reason to skip the deadlock fix)

UNRESOLVED:
- lore.kernel.org/stable search (403)
- Direct lore HTML fetch (403); thread obtained via b4 mbox instead

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — logic matches add-side; syzbot +
   maintainer apply
2. Fixes a real bug that affects users? PASS — deadlock on
   write/sendfile, C repro
3. Important issue? PASS — hang/deadlock, CRITICAL
4. Small and contained? PASS — +29/−7, four UDF files
5. No new features or APIs? PASS — internal `udf_delete_aext` out-
   parameter only
6. Can apply to the local tree? PASS — UDF code present; patch is the
   natural fix for this tree’s allocator

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None needed (not a device ID / quirk / DT / docs). It is a
normal deadlock bugfix.

Step 9.4: MAKE YOUR DECISION
This tree is 7.3-rc4 mainline with full UDF table allocation. The
deadlock is real, old, and user-reachable. The fix is small and correct.
It should be applied on this tree’s stable lineage.

Verification:
- [Phase 1] Tags: syzbot Reported-by/Closes/Link; Jan Kara SOB; no
  Fixes/Cc-stable
- [Phase 2] Diff: +29/−7; defer `udf_free_blocks` after `mutex_unlock`
  in two table allocators; NULL at other callers
- [Phase 2] Pre-fix `31e5e0c8c8e2^`: `udf_delete_aext` always called
  `udf_free_blocks` when `epos.bh != oepos.bh`
- [Phase 2] `s_alloc_mutex` is `struct mutex` in `fs/udf/udf_sb.h:154`
  (non-recursive)
- [Phase 2] `udf_free_blocks` table branch at `balloc.c:685-687` takes
  `udf_table_free_blocks` which locks the same mutex at line 376
- [Phase 3] Blame: mutex `1e7933defd0fce` (2006); free-on-delete present
  by `cb00ea3528eb3` (2007)
- [Phase 3] `git merge-base --is-ancestor 31e5e0c8c8e2 HEAD` → yes; `git
  describe --contains` → `v7.3-rc1~118^2~14`
- [Phase 3] No follow-up that replaces this locking approach
- [Phase 4] `b4 dig -c 31e5e0c8c8e2`: v1 only; Jan Kara accepted;
  Sashiko flags were pre-existing
- [Phase 4] syzbot: WARNING in udf_free_blocks, C repro, prio:high, DoS
- [Phase 5] Call chain: sendfile → `udf_write_begin` → `udf_get_block` →
  `inode_getblk` → `udf_prealloc_blocks` (verified in inode.c / file.c)
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4; UDF table path present
- [Phase 8] Failure mode: self-deadlock / RT -EDEADLK, severity CRITICAL
- UNVERIFIED: lore.kernel.org/stable HTML (403); does not change the
  deadlock evidence

The patch prevents a hard hang on a syzbot-reproduced UDF write path, is
small, and matches how this allocator already avoids add-side recursion.

**YES**

 fs/udf/balloc.c   | 12 ++++++++++--
 fs/udf/inode.c    | 19 ++++++++++++++++---
 fs/udf/truncate.c |  2 +-
 fs/udf/udfdecl.h  |  3 ++-
 4 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index cc6dc6e1d84de..30cec56001491 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -502,6 +502,8 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 	int8_t etype = -1;
 	struct udf_inode_info *iinfo;
 	int ret = 0;
+	/* AED block freed by udf_delete_aext(), released after unlock */
+	struct kernel_lb_addr freed = { .partitionReferenceNum = 0xFFFF };
 
 	if (first_block >= sbi->s_partmaps[partition].s_partition_len)
 		return 0;
@@ -541,7 +543,7 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 			udf_write_aext(table, &epos, &eloc,
 					(etype << 30) | elen, 1);
 		} else
-			udf_delete_aext(table, epos);
+			udf_delete_aext(table, epos, &freed);
 	} else {
 		alloc_count = 0;
 	}
@@ -552,6 +554,8 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 	if (alloc_count)
 		udf_add_free_space(sb, partition, -alloc_count);
 	mutex_unlock(&sbi->s_alloc_mutex);
+	if (freed.partitionReferenceNum != 0xFFFF)
+		udf_free_blocks(sb, table, &freed, 0, 1);
 	return alloc_count;
 }
 
@@ -560,6 +564,8 @@ static udf_pblk_t udf_table_new_block(struct super_block *sb,
 			       uint32_t goal, int *err)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
+	/* AED block freed by udf_delete_aext(), released after unlock */
+	struct kernel_lb_addr freed = { .partitionReferenceNum = 0xFFFF };
 	uint32_t spread = 0xFFFFFFFF, nspread = 0xFFFFFFFF;
 	udf_pblk_t newblock = 0;
 	uint32_t adsize;
@@ -643,12 +649,14 @@ static udf_pblk_t udf_table_new_block(struct super_block *sb,
 	if (goal_elen)
 		udf_write_aext(table, &goal_epos, &goal_eloc, goal_elen, 1);
 	else
-		udf_delete_aext(table, goal_epos);
+		udf_delete_aext(table, goal_epos, &freed);
 	brelse(goal_epos.bh);
 
 	udf_add_free_space(sb, partition, -1);
 
 	mutex_unlock(&sbi->s_alloc_mutex);
+	if (freed.partitionReferenceNum != 0xFFFF)
+		udf_free_blocks(sb, table, &freed, 0, 1);
 	*err = 0;
 	return newblock;
 }
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 05d4e95ba3c61..6a0c66d706295 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1217,7 +1217,7 @@ static int udf_update_extents(struct inode *inode, struct kernel_long_ad *laarr,
 
 	if (startnum > endnum) {
 		for (i = 0; i < (startnum - endnum); i++)
-			udf_delete_aext(inode, *epos);
+			udf_delete_aext(inode, *epos, NULL);
 	} else if (startnum < endnum) {
 		for (i = 0; i < (endnum - startnum); i++) {
 			err = udf_insert_aext(inode, *epos,
@@ -2348,7 +2348,8 @@ static int udf_insert_aext(struct inode *inode, struct extent_position epos,
 	return ret;
 }
 
-int8_t udf_delete_aext(struct inode *inode, struct extent_position epos)
+int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
+			struct kernel_lb_addr *freed)
 {
 	struct extent_position oepos;
 	int adsize;
@@ -2398,7 +2399,19 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos)
 	elen = 0;
 
 	if (epos.bh != oepos.bh) {
-		udf_free_blocks(inode->i_sb, inode, &epos.block, 0, 1);
+		/*
+		 * The block that held the now-empty allocation extent must be
+		 * returned to free space.  When the caller already holds
+		 * s_alloc_mutex (the space-table allocator in balloc.c),
+		 * freeing it inline would recurse through udf_free_blocks()
+		 * into udf_table_free_blocks() and deadlock re-acquiring
+		 * s_alloc_mutex.  In that case report the block to the caller,
+		 *  which frees it after dropping the lock.
+		 */
+		if (freed)
+			*freed = epos.block;
+		else
+			udf_free_blocks(inode->i_sb, inode, &epos.block, 0, 1);
 		udf_write_aext(inode, &oepos, &eloc, elen, 1);
 		udf_write_aext(inode, &oepos, &eloc, elen, 1);
 		if (!oepos.bh) {
diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index b4071c9cf8c95..da5a61306390c 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -159,7 +159,7 @@ void udf_discard_prealloc(struct inode *inode)
 
 	if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
 		lbcount -= elen;
-		udf_delete_aext(inode, prev_epos);
+		udf_delete_aext(inode, prev_epos, NULL);
 		udf_free_blocks(inode->i_sb, inode, &eloc, 0,
 				DIV_ROUND_UP(elen, bsize));
 	}
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index d159f20d61e89..db261d743b7f1 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -169,7 +169,8 @@ extern int udf_add_aext(struct inode *, struct extent_position *,
 			struct kernel_lb_addr *, uint32_t, int);
 extern void udf_write_aext(struct inode *, struct extent_position *,
 			   struct kernel_lb_addr *, uint32_t, int);
-extern int8_t udf_delete_aext(struct inode *, struct extent_position);
+extern int8_t udf_delete_aext(struct inode *, struct extent_position,
+			       struct kernel_lb_addr *);
 extern int udf_next_aext(struct inode *inode, struct extent_position *epos,
 			 struct kernel_lb_addr *eloc, uint32_t *elen,
 			 int8_t *etype, int inc);
-- 
2.53.0

