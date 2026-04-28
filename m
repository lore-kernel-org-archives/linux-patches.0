Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF583402B81;
	Tue, 28 Apr 2026 10:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372950; cv=none; b=G8ONPiRAr1ntbMzPERs3/elDPqkI1jDMWF2SO1XfmT+pDE0GsBNZKYlguadtngt+q5zxc11O43H0gwky1PvhaIiOMX2zmPlGZHCbABgfoZ4O4Ho4Qf9NYzPH0FCLPFc9/4l8LYKQz/tn4Ts3KQyWx96TZ5xwCH4CGfUxndvE9zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372950; c=relaxed/simple;
	bh=JWAIoKg/Cr1lfraiiSe1c5jzVlDYbauvtYBwYcJIuwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pD6YjcP/JeUFx5ivKwZ4bkTyEJh87zH8cJoQwFXpnhv2UH37vjK7JMcAfTAzw4Cuo1rfHzuhwUIvGvPLvscqGLe6/FSLmiy7Mvp/lsXH+mb2ECUAE7nJUo6Vr4Hx3TWfPkOJ47XrpUrn+7PungKmH+3Ecvg/tcCGiHbTCvU0YrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LPybdSBb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LPybdSBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6293BC2BCF4;
	Tue, 28 Apr 2026 10:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372950;
	bh=JWAIoKg/Cr1lfraiiSe1c5jzVlDYbauvtYBwYcJIuwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LPybdSBbVzyHBtOXEtGibSrhgW54PwBho97LaVy1PHkNLZcY4uyEG2ZL2lKVNBW4D
	 sLoKnHZF0+o0TajhUz2d0zfSG4PPk+0O4F/2DlDikquBZsRTBb2mZ+dSNwae38n+S7
	 rA59hlMScbYFUbZ8gSwS7OVIrlxMkqs4Z3wmR+eMx7O/EsD0Tys91ZmwLymT1xNVao
	 JKfniaJU67Acq1WRkC3JlWjEUz/TAWW3QUbwgE80AHwkoNSwCvsUHI1bgPoMzLbalR
	 J1B8+50qeVQJBFg/6rikWnxFxZODSWSD0/g7Zard5a+eaWzQzFHLdwNkK+hIR6vjxd
	 BpyYa82HTLAaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>,
	jaharkes@cs.cmu.edu,
	coda@cs.cmu.edu,
	codalist@coda.cs.cmu.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] coda_flag_children(): fix a UAF
Date: Tue, 28 Apr 2026 06:40:51 -0400
Message-ID: <20260428104133.2858589-40-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit e252ed8988578f01da5a4f5aa4c2269f96f03951 ]

if de goes negative right under us, there's nothing to prevent inode
getting freed just as we call coda_flag_inode().  We are not holding
->d_lock, so it's not impossible.  Not going to be reproducible on
bare hardware unless it's a realtime config, but it could happen on KVM.

Trivial to fix - just hold rcu_read_lock() over that loop.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my investigation, here's my full analysis:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line parsing**
- Subsystem: `fs/coda`
- Action verb: "fix" (explicit UAF fix)
- Record: [coda] [fix] [UAF in `coda_flag_children()` when dentries go
  negative concurrently]

**Step 1.2 — Tags**
- Signed-off-by: Al Viro (VFS maintainer / dcache expert)
- No Fixes:, Cc: stable, Reported-by:, Tested-by:, or Link: tags
- Record: Only author SOB. No formal stable nomination, no reporter, no
  test witness.

**Step 1.3 — Body text**
- Bug: iterating parent's children under parent's `->d_lock`; child's
  `d_inode` can be cleared (go negative) concurrently and then freed; we
  may dereference a freed inode in `coda_flag_inode()`.
- Author states: "not reproducible on bare hardware unless it's a
  realtime config, but it could happen on KVM"
- Symptom: UAF on `struct inode` accessed via `ITOC(inode)` inside
  `coda_flag_inode()`.

**Step 1.4 — Hidden fix detection**
- The subject explicitly uses "fix" and names "UAF". This is an explicit
  memory-safety fix.

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
- 1 file, 2 lines added (rcu_read_lock/rcu_read_unlock), 0 removed. Pure
  surgical diff.

**Step 2.2 — Code flow**
- Before: `spin_lock(parent->d_lock); iterate children; access
  de->d_inode via d_inode_rcu(); call coda_flag_inode(); spin_unlock;`
- After: same, but with an explicit
  `rcu_read_lock()`/`rcu_read_unlock()` wrapping the iteration.

**Step 2.3 — Bug mechanism**
- Classification: (b) synchronization / (d) memory-safety — adds RCU
  read-side critical section over a loop that reads an RCU-published
  pointer (`d_inode_rcu()` returns `READ_ONCE(dentry->d_inode)`), and
  dereferences the returned inode via `coda_flag_inode()`.
- The parent's `d_lock` stabilizes the children list, but does NOT hold
  the children's own `d_lock`, so the child's `->d_inode` can transition
  to NULL and the inode be released to RCU.
- Record: Claimed UAF closed by explicit RCU read-side critical section.

**Step 2.4 — Fix quality**
- Adding rcu_read_lock around existing code is strictly additive /
  defensive; zero regression surface. No new APIs, no lock ordering
  change, no allocations.

## Phase 3: Git History Investigation

**Step 3.1 — blame / when was this code introduced**
- `d_inode_rcu(de)`-based form introduced by `b31559f8e471f`
  ("coda_flag_children(): cope with dentries turning negative", Nov
  2023, v6.8-rc1).
- Hlist form (`d_children` / `d_sib`) introduced by `da549bdd15c29`
  ("dentry: switch the lists of children to hlist", v6.8-rc1).
- Older kernels (≤ v6.7) used `list_for_each_entry(&parent->d_subdirs,
  d_child)` with plain `d_inode(de)`; they have the same underlying UAF
  potential but via a different expression.

**Step 3.2 — Follow Fixes: tag**
- None supplied. Logically, the referent would be `b31559f8e471f` (v6.8)
  which introduced the current form that this patch hardens. That commit
  is in all stable trees ≥ 6.8.

**Step 3.3 — File history**
- Very low churn. Only dcache-wide mechanical conversions touched it
  since 2023.

**Step 3.4 — Author**
- Al Viro = the VFS / dcache maintainer. Extremely high authority on
  dentry locking and RCU.

**Step 3.5 — Dependencies**
- None in the series that affect this hunk. The cover letter confirms:
  patches 1 and 2 touch `fs/coda/dir.c` only and are independent
  cleanups.

## Phase 4: Mailing List / External Research

**Step 4.1 — Original submission**
- b4 dig failed because lore.kernel.org is currently behind an anti-bot
  page. Fell back to yhbt.net mirror.
- Found posting: "[PATCH 3/3] coda_flag_children(): fix a UAF", Al Viro,
  2026-04-05, linux-fsdevel. No v2/later revisions; single post, merged
  as-is in vfs.git `#work.coda`, pulled via "[git pull] coda dcache-
  related cleanups and fixes" on 2026-04-21.
- Cover letter: "coda_flag_children() is holding ->d_lock on parent
  while iterating through the list of its children; that's fine, but
  that does not protect ->d_inode of individual children. Hold
  rcu_read_lock() over the entire loop to prevent UAF there..."

**Step 4.2 — Reviewers**
- CC list: linux-fsdevel, Christian Brauner (VFS co-maintainer), Jan
  Kara (VFS reviewer), Jan Harkes (Coda maintainer). No recorded NAK or
  objection in the archive; series was subsequently pulled into Linus's
  tree via Al's pull request.

**Step 4.3 — Bug report**
- No Reported-by, no Link, no syzbot, no bugzilla. This is a maintainer-
  initiated audit fix, not a response to a user report.

**Step 4.4 — Related patches**
- Sibling patches 1/3 and 2/3 are independent dcache cleanups; this
  patch is self-contained.

**Step 4.5 — Historical context (IMPORTANT)**
- The prior commit `b31559f8e471f` originally included
  rcu_read_lock/unlock (v3 posting, lkml 2023/11/24). Linus Torvalds
  requested the rcu_read_lock be dropped, arguing spinlocks are implied
  RCU read-side critical sections. Paul E. McKenney confirmed ("Yes,
  spinlocks are implied RCU read-side critical sections. Even in -rt,
  where non-raw spinlocks are preemptible, courtesy of ...
  __rt_spin_lock ... rcu_read_lock()"). The
  Documentation/RCU/rcu_dereference.rst was later updated by McKenney to
  spell this out.
- The 2026 patch re-adds the rcu_read_lock Al originally wanted. Per the
  commit message, the concern is reproducibility on realtime / KVM
  configurations. Even under Paul McKenney's rule, the fix is strictly
  redundant-but-correct on all configs and defensive against future
  changes in that area.

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
- Modified function: `coda_flag_children()` (static, in
  fs/coda/cache.c).

**Step 5.2 — Callers**
- `coda_flag_children()` → called only from `coda_flag_inode_children()`
  (static caller in same file).
- `coda_flag_inode_children()` called from:
  - `fs/coda/dir.c::coda_revalidate_inode()` (invalidation path on
    attribute revalidation)
  - `fs/coda/upcall.c::coda_process_downcall()` under `CODA_ZAPDIR` and
    `CODA_PURGEFID` cases — invoked when the Coda userspace cache
    manager (Venus) issues downcalls to invalidate cached entries.
- Reachability: triggered any time Venus sends a ZAPDIR/PURGEFID
  downcall, or on attribute revalidation. For systems actually running
  Coda, this is a normal, frequently-exercised path.

**Step 5.3 — Callees**
- `coda_flag_inode()` (inline) accesses `ITOC(inode)->c_lock` and
  modifies `cii->c_flags`. It derefs `inode` via container_of arithmetic
  for the lock access.

**Step 5.4 — Call chain reachability**
- Reachable from userspace Coda client requests and from VFS
  revalidation. Requires Coda filesystem to be mounted.

**Step 5.5 — Similar patterns**
- No other sites in fs/coda iterating children without rcu_read_lock
  (it's the only such loop in this filesystem).

## Phase 6: Stable Tree Analysis

**Step 6.1 — Code existence in stable**
- The hlist-based, `d_inode_rcu`-based form that this patch modifies
  exists in 6.8+ (including LTS 6.12.y+). The UAF window itself
  conceptually exists all the way back to when `coda_flag_children()`
  was first written, but the textual diff needs 6.8+ for a clean apply.
- For older stable branches (6.6.y, 6.1.y, etc.) the context would need
  manual adjustment (different list/member names, different inode-
  accessor), but the logical fix (wrap in rcu_read_lock) still applies.

**Step 6.2 — Backport complications**
- Clean apply on any stable branch with hlist_children form (6.8+). For
  older (6.6, 6.1) would require a contextual port.

**Step 6.3 — Related fixes in stable**
- None.

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem & criticality**
- `fs/coda/` — Coda distributed filesystem client. PERIPHERAL — niche,
  used in research/academic contexts, rarely in production.

**Step 7.2 — Activity**
- Low churn subsystem; a handful of commits per release and almost all
  are mechanical treewide changes by VFS.

## Phase 8: Impact and Risk

**Step 8.1 — Who is affected**
- Only users who actually mount a Coda filesystem. Very small
  population.

**Step 8.2 — Trigger conditions**
- Race window: (a) Coda is mounted and active; (b) Venus issues a
  ZAPDIR/PURGEFID or attribute revalidation happens; (c) a child dentry
  is transitioning to negative concurrently; (d) its inode is the last
  reference and gets queued for RCU free.
- Per author: NOT reproducible on bare hardware outside PREEMPT_RT;
  possibly reproducible on KVM.
- In practice, the prior Linus/McKenney analysis argues the implicit RCU
  read-side critical section of `spin_lock()` (including the explicit
  `rcu_read_lock()` inside `__rt_spin_lock()` on PREEMPT_RT) already
  provides the needed protection. So this fix is arguably
  defensive/redundant, though explicitly correct.

**Step 8.3 — Failure mode severity**
- If the race were actually exploitable: UAF on `struct inode` → memory
  corruption / crash. Severity CRITICAL in principle. But the actual
  exploitability is uncertain (see Phase 4.5).

**Step 8.4 — Benefit / risk**
- Benefit: LOW-MEDIUM. Strictly defensive hardening of an RCU-protected
  loop; may be redundant given spinlock ↔ RCU semantics. Affects only
  Coda users.
- Risk: VERY LOW. +2 lines (rcu_read_lock/unlock), no new allocations,
  no new locks, can't introduce deadlock or perf issue in a cold path.
- Ratio: Fine to include (risk ≈ 0), but with limited user-visible
  benefit.

## Phase 9: Synthesis

**Step 9.1 — Evidence**
- FOR: Al Viro's explicit "fix a UAF" label; tiny, surgical diff; author
  is VFS maintainer; trivially safe; even if the implicit-RCU argument
  holds, the explicit form is more defensive.
- AGAINST: No Fixes/Cc-stable/Reported-by tags; no syzbot, no bugzilla,
  no crash report; author admits "not reproducible on bare hardware
  unless it's a realtime config"; prior discussion (Linus + McKenney,
  Nov 2023) concluded rcu_read_lock is redundant on this exact code
  because spinlocks imply RCU read-side critical sections; Coda is a
  niche filesystem.
- UNRESOLVED: I could not verify whether a real crash was observed in
  KVM/RT that motivated this re-addition; the commit message provides
  only an analytical argument.

**Step 9.2 — Stable rules**
1. Obviously correct and tested: YES (trivially correct)
2. Fixes a real bug: BORDERLINE — labeled UAF, but author himself
   qualifies it as only realistic under RT/KVM; prior maintainer
   discussion argued it's already covered
3. Important issue: Only if the bug is genuinely exploitable; UAF label
   means yes in principle
4. Small and contained: YES (+2 lines)
5. No new features/APIs: YES
6. Applies to stable: Clean apply on 6.8+; would need contextual port on
   older

**Step 9.3 — Exception category**
- Doesn't cleanly fit a hard "auto-YES" exception (not a device ID, not
  a DT update, not a build fix, not a pure doc fix). It is a memory-
  safety hardening marked UAF by the author.

**Step 9.4 — Decision**
- The commit is explicitly marked as a UAF fix by the VFS maintainer, is
  minimal and strictly safe, and touches a well-understood RCU pattern.
  The backport cost is essentially zero, and if the author's hazard
  analysis is correct (even for the narrow RT/KVM case), having it in
  stable prevents a real memory-safety issue for those configurations.
  Stable maintainers generally err on the side of taking trivially-safe
  memory-safety patches from trusted maintainers.

## Verification

- [Phase 1] Parsed subject and body: explicit UAF fix; no Fixes/Cc-
  stable/Reported-by/Link tags; only author SOB.
- [Phase 2] Read `fs/coda/cache.c` current source (lines 91-103)
  confirming the pre-patch loop uses `spin_lock(&parent->d_lock)` with
  `d_inode_rcu(de)` only.
- [Phase 2] Read `fs/coda/coda_linux.h:82-93` to confirm
  `coda_flag_inode()` dereferences the inode via `ITOC(inode)`; a freed
  inode here would be a real UAF.
- [Phase 3] git log on `fs/coda/cache.c`: found the two relevant
  predecessor commits `b31559f8e471f` (Nov 2023) and `da549bdd15c29`
  (Nov 2023).
- [Phase 3] `git describe --contains b31559f8e471f` → `v6.8-rc1~...`,
  confirming the hlist/d_inode_rcu form lives in v6.8+.
- [Phase 3] `git show v6.7:fs/coda/cache.c` confirmed the older list-
  based form in 6.7.y and earlier.
- [Phase 3] Confirmed e252ed8988578 is on the local `fs-next` branch
  only; not yet in v7.0.
- [Phase 4] b4 dig failed (lore anti-bot); fell back to
  https://yhbt.net/lore/linux-fsdevel/, found the exact [PATCH 3/3]
  submission and [PATCH 0/3] cover letter dated 2026-04-05; found the
  pull request dated 2026-04-21 containing this commit going to Linus.
- [Phase 4] Retrieved full thread of the 2023 predecessor
  (lkml.rescloud.iu.edu/2311.3/00022.html, /01035.html, /01094.html)
  showing Linus + Paul McKenney concluding spinlocks imply RCU read-side
  critical sections (even PREEMPT_RT).
- [Phase 4] Read `kernel/locking/spinlock_rt.c` lines 46-52 confirming
  `__rt_spin_lock()` explicitly calls `rcu_read_lock()`.
- [Phase 4] Read `include/linux/dcache.h:544` confirming `d_inode_rcu()`
  is a plain `READ_ONCE()` (no rcu lockdep check).
- [Phase 5] grep `coda_flag_inode_children` → called from
  `fs/coda/dir.c` (revalidation) and `fs/coda/upcall.c`
  (CODA_ZAPDIR/CODA_PURGEFID downcalls).
- [Phase 5] Confirmed `coda_flag_children` is static with a single
  caller inside this file.
- [Phase 6] Patch context (`hlist_for_each_entry` on
  `&parent->d_children`, `d_sib`) only exists in 6.8+. Clean apply to ≥
  6.8; older stable would need contextual port.
- [Phase 6] `fs/inode.c::destroy_inode` uses `call_rcu(&inode->i_rcu,
  i_callback)` — standard RCU free path, so rcu_read_lock does protect
  against it.
- [Phase 7] `fs/coda/` identified as PERIPHERAL/niche filesystem.
- [Phase 8] Failure mode if race triggers: UAF on inode accessed from
  `coda_flag_inode()` — CRITICAL severity if triggerable; per Paul
  McKenney 2023 analysis, likely not actually triggerable; per Al Viro
  2026, possibly triggerable on KVM/RT.
- UNVERIFIED: Whether any real-world crash was observed that motivated
  re-adding rcu_read_lock; no syzbot, no bugzilla link, no Reported-by.
- UNVERIFIED: Whether Paul McKenney's 2023 rule has any corner-case
  exception that would actually leave a UAF window here.

## Summary

This is a two-line, strictly additive hardening that the VFS maintainer
explicitly labels as a UAF fix. The underlying hazard (dereferencing an
inode after the child dentry goes negative and the inode is freed via
call_rcu) is real in principle. A prior mailing-list discussion
concluded the existing `spin_lock(&parent->d_lock)` already provides
implicit RCU read-side protection, and Al Viro accepted that in 2023. Al
is now re-adding the explicit rcu_read_lock, motivated by hard-to-
reproduce scenarios on PREEMPT_RT / KVM. The fix is trivially safe,
cannot regress anything, and applies cleanly to 6.8+ stable trees. Given
the explicit UAF label from a core maintainer, the extremely low risk,
and stable's general policy of accepting small, safe memory-safety
hardenings, this is appropriate for stable.

**YES**

 fs/coda/cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/coda/cache.c b/fs/coda/cache.c
index 970f0022ec528..2451312963004 100644
--- a/fs/coda/cache.c
+++ b/fs/coda/cache.c
@@ -93,12 +93,14 @@ static void coda_flag_children(struct dentry *parent, int flag)
 	struct dentry *de;
 
 	spin_lock(&parent->d_lock);
+	rcu_read_lock();
 	hlist_for_each_entry(de, &parent->d_children, d_sib) {
 		struct inode *inode = d_inode_rcu(de);
 		/* don't know what to do with negative dentries */
 		if (inode)
 			coda_flag_inode(inode, flag);
 	}
+	rcu_read_unlock();
 	spin_unlock(&parent->d_lock);
 }
 
-- 
2.53.0

