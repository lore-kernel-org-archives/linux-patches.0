Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB413F20F9;
	Mon, 20 Apr 2026 13:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691539; cv=none; b=B8KS9l3PUyMoF3TjmW2OucseHwkp+ARb0/CKELPtB6MzsZoowqZ7/U82Z3nrQZ9cEUP3T860hdSHBfTVhayVPPtZTAR0C5rOxGckYx97h1FIggPeqaA00yyovgt+M+jcvi3eCo8EtmvveNTQJpn031BQWwmYTgNyvNEhMUT14LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691539; c=relaxed/simple;
	bh=mzxNC9YRLn4u+RpEuA0OtJbQaCMXAJ2IE4AKUcQlA7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BUvLLUUR0o0VIX+c4e3xgTqmxZ+HtK4jLItMN/L9VsoKQNnbvPxvAxsWPSmokvHPRi2zj/u8ouflDOotsN/foDBAB0cw2x0diHTD/KznY1qsb9pKNYkF41PSIBLb/12Mfo0NQZYX18AHPJys8baN/fo0VCDbB56A1vgFvBUcmhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebISv1Ze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebISv1Ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F48C19425;
	Mon, 20 Apr 2026 13:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691539;
	bh=mzxNC9YRLn4u+RpEuA0OtJbQaCMXAJ2IE4AKUcQlA7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebISv1ZeJTpC3B6TfMViT9RhVQyoLW+DDVIOH3Ieg3v5ZNib51Hp2alUm8nJPmVWV
	 SQWYg0BLCUyel9dN4dlbMaZVo/uSNyvIKUO0MjDNatXbqdV6WymAA4m8MsiWyHEPLT
	 B0hSR2pfFV/yVHqtL4v9eCkd/AsoISOmqHdqM3+2PKac+s6PGtRWb+pVZfl1HsKbgP
	 +oSaYjP7SPWlsrd9p2Qex1Cq04mUrXL6s361Cp33Z/wiwlZ7bJkYKtLKmfZahMIWyf
	 saWAc/8e2YKUmjNAGtaBfimWTg7gSBPSg18vzbtpXEfvXIFSR+6g2aMBEpUzgIn6vS
	 sUYiBraAWRLkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yun Zhou <yun.zhou@windriver.com>,
	syzbot+4d0a0feb49c5138cac46@syzkaller.appspotmail.com,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	shaggy@kernel.org,
	jfs-discussion@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] jfs: fix corrupted list in dbUpdatePMap
Date: Mon, 20 Apr 2026 09:18:03 -0400
Message-ID: <20260420132314.1023554-89-sashal@kernel.org>
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

[ Upstream commit 3c778ec882084626ac915d6c6ec88aff87b82221 ]

This patch resolves the "list_add corruption. next is NULL" Oops
reported by syzkaller in dbUpdatePMap(). The root cause is uninitialized
synclist nodes in struct metapage and struct TxBlock, plus improper list
node removal using list_del() (which leaves nodes in an invalid state).

This fixes the following Oops reported by syzkaller.

list_add corruption. next is NULL.
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:28!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 122 Comm: jfsCommit Not tainted syzkaller #0
PREEMPT_{RT,(full)}
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 10/02/2025
RIP: 0010:__list_add_valid_or_report+0xc3/0x130 lib/list_debug.c:27
Code: 4c 89 f2 48 89 d9 e8 0c 88 a4 fc 90 0f 0b 48 c7 c7 20 de 3d 8b e8
fd 87 a4 fc 90 0f 0b 48 c7 c7 c0 de 3d 8b e8 ee 87 a4 fc 90 <0f> 0b 48
89 df e8 13 c3 7d fd 42 80 7c 2d 00 00 74 08 4c 89 e7 e8
RSP: 0018:ffffc9000395fa20 EFLAGS: 00010246
RAX: 0000000000000022 RBX: 0000000000000000 RCX: 270c5dfadb559700
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00000000000f0000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffff5200072bee9 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000004 R15: 1ffff92000632266
FS:  0000000000000000(0000) GS:ffff888126ef9000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056341fdb86c0 CR3: 0000000040a18000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __list_add_valid include/linux/list.h:96 [inline]
 __list_add include/linux/list.h:158 [inline]
 list_add include/linux/list.h:177 [inline]
 dbUpdatePMap+0x7e4/0xeb0 fs/jfs/jfs_dmap.c:577
 txAllocPMap+0x57d/0x6b0 fs/jfs/jfs_txnmgr.c:2426
 txUpdateMap+0x81e/0x9c0 fs/jfs/jfs_txnmgr.c:2364
 txLazyCommit fs/jfs/jfs_txnmgr.c:2665 [inline]
 jfs_lazycommit+0x3f1/0xa10 fs/jfs/jfs_txnmgr.c:2734
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---

Reported-by: syzbot+4d0a0feb49c5138cac46@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4d0a0feb49c5138cac46
Tested-by: syzbot+4d0a0feb49c5138cac46@syzkaller.appspotmail.com
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed to produce the complete analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** `jfs` (JFS filesystem)
- **Action verb:** "fix" — directly claims to fix a bug
- **Summary:** Fixes corrupted list in `dbUpdatePMap` by initializing
  list nodes and using safe deletion

### Step 1.2: Tags
- **Reported-by:**
  `syzbot+4d0a0feb49c5138cac46@syzkaller.appspotmail.com` — fuzzer-
  found, reproducible
- **Closes:**
  `https://syzkaller.appspot.com/bug?extid=4d0a0feb49c5138cac46` —
  syzbot link
- **Tested-by:** `syzbot+4d0a0feb49c5138cac46@syzkaller.appspotmail.com`
  — syzbot confirmed the fix
- **Signed-off-by:** Yun Zhou (author), Dave Kleikamp (JFS maintainer
  committed it)
- No Fixes: tag, no Cc: stable — expected for manual review

### Step 1.3: Commit Body
The commit describes a **kernel BUG/oops** in
`__list_add_valid_or_report` triggered from `dbUpdatePMap()`. The root
cause is two-fold:
1. **Uninitialized `synclist` nodes** in `struct metapage` and `struct
   tblock` — `next`/`prev` pointers are NULL/garbage
2. **Improper `list_del()`** usage that poisons nodes (sets `next` =
   `LIST_POISON1`), making subsequent `list_add()` fail when the node is
   reused

The crash is triggered in the `jfsCommit` kernel thread during
transaction commit via `jfs_lazycommit -> txLazyCommit -> txUpdateMap ->
txAllocPMap -> dbUpdatePMap`.

### Step 1.4: Hidden Bug Fix Detection
This is NOT a hidden bug fix — it is an explicit, well-documented crash
fix with full stack trace and syzbot confirmation.

Record: **Explicit bug fix for a kernel BUG/oops (crash)**

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed:** 2 files (`fs/jfs/jfs_metapage.c`,
  `fs/jfs/jfs_txnmgr.c`)
- **Lines added:** 3 lines
- **Lines changed:** 2 lines (`list_del` → `list_del_init`)
- **Functions modified:**
  - `alloc_metapage()` — +1 line: `INIT_LIST_HEAD(&mp->synclist)`
  - `remove_from_logsync()` — changed `list_del` to `list_del_init`
  - `txInit()` — +1 line: `INIT_LIST_HEAD(&TxBlock[k].synclist)`
  - `txUnlock()` — changed `list_del` to `list_del_init`
- **Scope:** Single-subsystem surgical fix, 5 changed lines total

### Step 2.2: Code Flow Changes
1. **`alloc_metapage()`**: Before: `mp->synclist` left uninitialized
   after allocation. After: `synclist` is properly initialized to an
   empty list head.
2. **`txInit()`**: Before: `TxBlock[k].synclist` left uninitialized.
   After: each tblock's `synclist` initialized during transaction
   manager setup.
3. **`remove_from_logsync()`**: Before: `list_del(&mp->synclist)`
   poisons the node. After: `list_del_init(&mp->synclist)` resets to
   clean empty state.
4. **`txUnlock()`**: Before: `list_del(&tblk->synclist)` poisons the
   node. After: `list_del_init(&tblk->synclist)` resets to clean empty
   state.

### Step 2.3: Bug Mechanism
**Category:** Uninitialized data + improper list state management

The crash scenario:
1. A `metapage` is allocated via `alloc_metapage()` → `synclist.next`
   and `synclist.prev` are uninitialized (NULL or garbage)
2. Code path reaches `dbUpdatePMap()` at line 577:
   `list_add(&mp->synclist, &tblk->synclist)`
3. `list_add()` validates that `next != NULL` → BUG because
   `tblk->synclist.next` is NULL (uninitialized)

Alternative scenario:
1. A node is on the logsync list, then removed with `list_del()` → `next
   = LIST_POISON1`
2. The node is reused, and `list_add()` is called → `next =
   LIST_POISON1` triggers BUG

### Step 2.4: Fix Quality
- **Obviously correct:** Yes — `INIT_LIST_HEAD` is the standard
  initialization for list nodes; `list_del_init` is the standard safe
  deletion for reusable nodes
- **Minimal/surgical:** Yes — 5 effective lines changed
- **Regression risk:** Essentially zero — these are the textbook correct
  patterns for Linux list operations
- **Red flags:** None

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
- `alloc_metapage()`: The initialization code was written by David
  Rientjes in commit `ee1462458cb543` (2015), but the function itself
  dates to `1da177e4c3f41` (original Linux import, 2005). The `synclist`
  member was never initialized here.
- `remove_from_logsync()`: Written by Dave Kleikamp in `7fab479bebb96b`
  (2005-05-02). Uses `list_del` since the beginning.
- `txInit()`: TxBlock init loop from `1da177e4c3f41` (original, 2005),
  recently refactored by `300b072df72694` (2025) to fix waitqueue
  initialization. The `synclist` was never initialized in the loop.
- `txUnlock()`: `list_del(&tblk->synclist)` from `1da177e4c3f41`
  (original, 2005).

**The bug has existed since the initial kernel git history (v2.6.12,
2005).** Every stable tree is affected.

### Step 3.2: Fixes Tag
No Fixes: tag present (expected).

### Step 3.3: File History
- `300b072df72694` ("jfs: fix uninitialized waitqueue in transaction
  manager") is a closely related fix in the same init loop, already in
  this tree. This commit changes the for-loop context that the patch
  under review modifies.

### Step 3.4: Author
- Yun Zhou is from Wind River — a systems company with kernel expertise.
- Dave Kleikamp (JFS maintainer) signed off and committed it.

### Step 3.5: Dependencies
- The `jfs_txnmgr.c` hunk depends on `300b072df72694` being present for
  clean context (the separate init loop). This commit is already in the
  7.0 stable tree.
- The `jfs_metapage.c` hunks are independent and should apply cleanly to
  all stable trees.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
- b4 dig could not find a match (lore is protected by Anubis anti-bot).
- Syzbot page shows the patch went through two versions: v1 on
  2025-11-07, v2 on 2025-11-09.

### Step 4.2: Reviewers
- Committed by Dave Kleikamp (JFS maintainer) — the appropriate person.

### Step 4.3: Bug Report
From syzbot:
- **First crash:** 165 days ago, **last crash:** 2 days ago (still
  actively crashing)
- **Reproducer:** C reproducer available
- **Affected stable trees:** linux-5.15 (0/3 patched), linux-6.1 (0/3
  patched), linux-6.6 (0/2 patched), linux-4.19 (0/1 patched)
- **Fix confirmed:** `3c778ec88208` in mainline, patched on 21 upstream
  CI configurations

### Step 4.5: Stable Discussion
The syzbot report explicitly lists this bug as unpatched across all
stable trees, confirming the backport is needed.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
- `alloc_metapage()` — allocates metapage structures from mempool
- `remove_from_logsync()` — removes a metapage from the logsync list
- `txInit()` — initializes transaction manager at mount time
- `txUnlock()` — unlocks transaction blocks during commit

### Step 5.2: Callers
- `alloc_metapage()` is called from `__get_metapage()` which is called
  for every JFS metadata read
- `remove_from_logsync()` called from `last_write_complete()`,
  `release_metapage()`, `__invalidate_metapages()` — all common JFS
  operations
- `list_add(&mp->synclist, &tblk->synclist)` at line 577 of `jfs_dmap.c`
  and line 2831 of `jfs_imap.c` — called during transaction commit for
  allocation map updates

### Step 5.4: Reachability
The crash path is: `jfs_lazycommit (kthread) → txLazyCommit →
txUpdateMap → txAllocPMap → dbUpdatePMap → list_add`. This is triggered
during normal JFS transaction commits — any write operation on a JFS
filesystem can trigger it.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code in Stable Trees
The buggy code dates to the original kernel (2005). **Every stable
tree** that supports JFS is affected. Syzbot confirms active crashes on
5.15, 6.1, and 6.6 stable trees.

### Step 6.2: Backport Complications
- For the 7.0 tree: should apply cleanly — `300b072df72694` (dependency
  for context) is already present.
- For older trees (6.6, 6.1, 5.15): the `txInit()` loop context differs
  (single combined loop), requiring minor context adjustment. The
  `jfs_metapage.c` changes (INIT_LIST_HEAD in alloc_metapage,
  list_del_init in remove_from_logsync) and the `txUnlock()`
  list_del_init change should apply cleanly.

### Step 6.3: Related Fixes Already in Stable
None. Syzbot explicitly shows 0/N patched for all stable trees.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
- **Subsystem:** JFS (Journaled File System) — `fs/jfs/`
- **Criticality:** IMPORTANT — filesystem, data corruption/loss risk,
  used in real-world deployments

### Step 7.2: Activity
JFS is a mature/stable subsystem with infrequent changes. The bug has
been present since 2005.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
All users of the JFS filesystem on any kernel version.

### Step 8.2: Trigger Conditions
Any write operation on a JFS filesystem that triggers transaction
commit. The syzbot reproducer demonstrates it's reliably triggerable. No
special privileges needed beyond filesystem access.

### Step 8.3: Failure Mode
**CRITICAL** — `kernel BUG()` / `invalid opcode: 0000 [#1]` / kernel
oops. The system crashes.

### Step 8.4: Risk-Benefit
- **Benefit:** VERY HIGH — prevents kernel crash on every JFS
  filesystem, actively exploitable by syzbot, unpatched across all
  stable trees
- **Risk:** VERY LOW — 5 lines of changes using well-known, textbook-
  correct patterns (`INIT_LIST_HEAD`, `list_del_init`)
- **Ratio:** Extremely favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes an active kernel BUG/oops crash (CRITICAL severity)
- Reported and reproduced by syzbot with C reproducer
- Actively crashing on multiple stable trees (5.15, 6.1, 6.6) — all
  listed as 0/N patched
- Bug has existed since 2005 (original kernel source)
- Tested by syzbot confirming the fix works
- Committed by JFS maintainer Dave Kleikamp
- Extremely small (5 effective line changes) and surgical
- Uses textbook-correct patterns (INIT_LIST_HEAD, list_del_init)
- Zero regression risk

**AGAINST backporting:**
- None identified

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES — uses standard list API
   patterns, syzbot-tested
2. **Fixes a real bug?** YES — kernel crash on JFS writes
3. **Important issue?** YES — kernel BUG/oops (crash)
4. **Small and contained?** YES — 5 lines across 2 files in same
   subsystem
5. **No new features or APIs?** YES — pure bug fix
6. **Can apply to stable?** YES — cleanly for 7.0; minor context
   adjustment for older trees

### Step 9.3: Exception Categories
Not applicable — this is a straightforward bug fix, not an exception
category.

### Step 9.4: Decision
This is an unambiguous YES. It fixes a kernel crash (BUG/oops) found by
syzbot, confirmed with a reproducer, actively crashing on all stable
trees, with a minimal 5-line fix using correct patterns, committed by
the subsystem maintainer.

---

## Verification

- [Phase 1] Parsed tags: Reported-by syzbot, Tested-by syzbot, Closes
  syzkaller link, signed by JFS maintainer
- [Phase 2] Diff analysis: 3 lines added (2x INIT_LIST_HEAD), 2 lines
  changed (list_del → list_del_init)
- [Phase 3] git blame: buggy code from `1da177e4c3f41` (v2.6.12, 2005)
  and `7fab479bebb96b` (2005) — present in all stable trees
- [Phase 3] git show 300b072df72694: confirmed prerequisite commit (loop
  refactor) is in 7.0 tree
- [Phase 3] Grep for INIT_LIST_HEAD of synclist: confirmed none existed
  before this patch (only `log->synclist` was initialized)
- [Phase 3] Grep for list_add(&mp->synclist): confirmed 2 call sites
  (jfs_dmap.c:577, jfs_imap.c:2831)
- [Phase 3] Grep for list_del(&mp->synclist) and
  list_del(&tblk->synclist): confirmed both use `list_del` (not
  `list_del_init`) pre-patch
- [Phase 4] Syzbot bug page: confirmed fix commit 3c778ec88208 in
  mainline, 0/N patched on stable 5.15/6.1/6.6
- [Phase 4] Syzbot: first crash 165d ago, last 2d ago — still actively
  crashing
- [Phase 4] b4 dig: could not find lore match (Anubis anti-bot
  protection); syzbot page shows v1 and v2 patch submissions
- [Phase 5] Traced call chain: `jfs_lazycommit → txLazyCommit →
  txUpdateMap → txAllocPMap → dbUpdatePMap → list_add` — triggered
  during normal JFS writes
- [Phase 5] alloc_metapage() called from __get_metapage() — every JFS
  metadata read
- [Phase 6] Bug exists in all stable trees (code from 2005); syzbot
  confirms active crashes on 5.15, 6.1, 6.6
- [Phase 6] For 7.0: should apply cleanly (300b072df72694 present)
- [Phase 8] Failure mode: kernel BUG/oops (invalid opcode), severity
  CRITICAL
- [Phase 8] Risk: VERY LOW — 5 lines, textbook patterns, zero regression
  potential

**YES**

 fs/jfs/jfs_metapage.c | 3 ++-
 fs/jfs/jfs_txnmgr.c   | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index 64c6eaa7f3f26..78dd8a1b29b7d 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -270,6 +270,7 @@ static inline struct metapage *alloc_metapage(gfp_t gfp_mask)
 		mp->clsn = 0;
 		mp->log = NULL;
 		init_waitqueue_head(&mp->wait);
+		INIT_LIST_HEAD(&mp->synclist);
 	}
 	return mp;
 }
@@ -379,7 +380,7 @@ static void remove_from_logsync(struct metapage *mp)
 		mp->lsn = 0;
 		mp->clsn = 0;
 		log->count--;
-		list_del(&mp->synclist);
+		list_del_init(&mp->synclist);
 	}
 	LOGSYNC_UNLOCK(log, flags);
 }
diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index c16578af3a77e..083dbbb0c3268 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -275,6 +275,7 @@ int txInit(void)
 	for (k = 0; k < nTxBlock; k++) {
 		init_waitqueue_head(&TxBlock[k].gcwait);
 		init_waitqueue_head(&TxBlock[k].waitor);
+		INIT_LIST_HEAD(&TxBlock[k].synclist);
 	}
 
 	for (k = 1; k < nTxBlock - 1; k++) {
@@ -974,7 +975,7 @@ static void txUnlock(struct tblock * tblk)
 	if (tblk->lsn) {
 		LOGSYNC_LOCK(log, flags);
 		log->count--;
-		list_del(&tblk->synclist);
+		list_del_init(&tblk->synclist);
 		LOGSYNC_UNLOCK(log, flags);
 	}
 }
-- 
2.53.0

