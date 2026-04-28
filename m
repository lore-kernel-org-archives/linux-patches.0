Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826F33FBEA5;
	Tue, 28 Apr 2026 10:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372926; cv=none; b=Frkkc6rpx9t3NYkaeewJtQ+S0jEdK6gzBRMIKHB4FnuQjrlyAdrGXiakpPudFt1E5thGD1/1GzchkPVLLzxB928resAYrbU4LFEHvPgT6Vnwh97i4SvH4Nv45Ad1FVrl/tDbVKhXwRQ5XGExfu3WfNTELGRjvu+rHKptIDpOPO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372926; c=relaxed/simple;
	bh=8ng4dot3qiCc7ux6lPau8GDpfH70KFn1x3Azyx4Tj/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2uviH44LY/7PAyxjvJOk77fbOPHJIr5plx0c90WVESdT7+ZcQjzBj17ReWGCqPm7K6csKMOLmCPZBDbJWp8Qid53UfZGyCbmr/z0pKwdknQVpg0h7AaJ6VvnujKPyp1ChRQRl4kdcXVBP9gnahtZQ9Q+1mJHeKhynxOaGW7UeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y5FuVDiM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y5FuVDiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA87C2BCB5;
	Tue, 28 Apr 2026 10:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372926;
	bh=8ng4dot3qiCc7ux6lPau8GDpfH70KFn1x3Azyx4Tj/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5FuVDiMhmkyZ3nIxDcTS6xkxWyloWmeSf23lrgQ2fp1tnb1fIzv69qAVzhyQWrlG
	 APaFUnjF18QdCdH07o6SlRjGyh9FRQZgdvXokN2lFYEuT6xGhlEzMyd7o4CBbQziyR
	 O82gh4cO2HF6suPPYObmo3ss3IZu3PzeywdWBU3ZdKEoGBOYsqlru3RHRL3RXVx4dp
	 S1PdwdEfu7g/c8lVNXZv32pmPxSc2oJJiP5bS6Li4t5guDvkBMuTtqWaMI7lX4qUCP
	 G+RIdfzb1ViBIhyfXzUzQ/sUW8ieWaFWhKhS0ezC6Ut6QhSqrfN92+GWebFJtar5js
	 uRowlWTEqHcuA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zizhi Wo <wozizhi@huawei.com>,
	Zizhi Wo <wozizhi@huaweicloud.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	bcrl@kvack.org,
	viro@zeniv.linux.org.uk,
	linux-aio@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] fs: aio: set VMA_DONTCOPY_BIT in mmap to fix NULL-pointer-dereference error
Date: Tue, 28 Apr 2026 06:40:34 -0400
Message-ID: <20260428104133.2858589-23-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit c03ce4173c7bffe1e7477f905a09b015d4000d3c ]

[BUG]
Recently, our internal syzkaller testing uncovered a null pointer
dereference issue:
BUG: kernel NULL pointer dereference, address: 0000000000000000
...
[   51.111664]  filemap_read_folio+0x25/0xe0
[   51.112410]  filemap_fault+0xad7/0x1250
[   51.113112]  __do_fault+0x4b/0x460
[   51.113699]  do_pte_missing+0x5bc/0x1db0
[   51.114250]  ? __pte_offset_map+0x23/0x170
[   51.114822]  __handle_mm_fault+0x9f8/0x1680
[   51.115408]  handle_mm_fault+0x24c/0x570
[   51.115958]  do_user_addr_fault+0x226/0xa50
...
Crash analysis showed the file involved was an AIO ring file.

[CAUSE]
	PARENT process		CHILD process
t=0	io_setup(1, &ctx)
	[access ctx addr]
	fork()
	io_destroy
	  vm_munmap // not affect child vma
	  percpu_ref_put
	  ...
	    put_aio_ring_file
t=1				[access ctx addr]	// pagefault
				...
				  __do_fault
				    filemap_fault
				      max_idx = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE)
t=2	      truncate_setsize
	        truncate_pagecache
t=3				      filemap_get_folio	// no folio, create folio
				      __filemap_get_folio(..., FGP_CREAT, ...)	// page_not_uptodate
				      filemap_read_folio(file, mapping->a_ops->read_folio, folio) // oops!

At t=0, the parent process calls io_setup and then fork. The child process
gets its own VMA but without any PTEs. The parent then calls io_destroy.
Before i_size is truncated to 0, at t=1 the child process accesses this AIO
ctx address and triggers a pagefault. After the max_idx check passes, at
t=2 the parent calls truncate_setsize and truncate_pagecache. At t=3 the
child fails to obtain the folio, falls into the "page_not_uptodate" path,
and hits this problem because AIO does not implement "read_folio".

[Fix]
Fix this by marking the AIO ring buffer VMA with VM_DONTCOPY so
that fork()'s dup_mmap() skips it entirely. This is the correct
semantic because:

1) The child's ioctx_table is already reset to NULL by mm_init_aio() during
fork(), so the child has no AIO context and no way to perform any AIO
operations on this mapping.
2) The AIO ring VMA is only meaningful in conjunction with its associated
kioctx, which is never inherited across fork(). So child process with no
AIO context has no legitimate reason to access the ring buffer. Delivering
SIGSEGV on such an erroneous access is preferable to a kernel crash.

Signed-off-by: Zizhi Wo <wozizhi@huaweicloud.com>
Link: https://patch.msgid.link/20260413010814.548568-1-wozizhi@huawei.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my investigation, I now have enough information to provide a
comprehensive analysis.

## Complete Phase-by-Phase Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 - Subject Line:**
- Record: `[fs: aio]` `[set VMA_DONTCOPY_BIT]` - indicates fix; title
  explicitly says "to fix NULL-pointer-dereference error"

**Step 1.2 - Tags:**
- Record:
  - Signed-off-by: Zizhi Wo (author from Huawei)
  - Link:
    https://patch.msgid.link/20260413010814.548568-1-wozizhi@huawei.com
  - Reviewed-by: Jan Kara (SUSE, MM/filesystems reviewer)
  - Signed-off-by: Christian Brauner (VFS maintainer)
  - No explicit Cc: stable, no Fixes: tag (expected for this evaluation
    pipeline)

**Step 1.3 - Commit Body:**
- Record: The body describes an internal syzkaller-discovered NULL
  pointer deref reproducible by a fork()+io_destroy race. A detailed
  timing diagram shows 4 time steps (t=0..t=3) explaining the race
  between parent's io_destroy() teardown and child's page fault on the
  inherited AIO ring VMA. The kernel crash stack trace shows:
  `do_user_addr_fault -> handle_mm_fault -> __handle_mm_fault ->
  do_pte_missing -> __do_fault -> filemap_fault -> filemap_read_folio` -
  oops at `a_ops->read_folio` (NULL).

**Step 1.4 - Hidden bug fixes:**
- Record: Not hidden - the subject explicitly says "to fix NULL-pointer-
  dereference error". This is a clear bug fix.

### PHASE 2: DIFF ANALYSIS

**Step 2.1 - Inventory:**
- Record: One file modified (`fs/aio.c`), 1 line changed (+1/-1), single
  function `aio_ring_mmap_prepare()`. Surgical, minimal scope.

**Step 2.2 - Code flow:**
- Record: Before: VMA created with `VMA_DONTEXPAND_BIT` only. After: VMA
  created with both `VMA_DONTEXPAND_BIT` and `VMA_DONTCOPY_BIT`. Affects
  fork()'s `dup_mmap()` behavior: child will not inherit this VMA.

**Step 2.3 - Bug mechanism:**
- Record: Category (h) Hardware-semantic fix / (d) Memory safety.
  Mechanism: Preventing fork()-time VMA duplication of the AIO ring
  buffer, eliminating the race window where child holds a VMA to a ring
  file while parent tears it down.

**Step 2.4 - Fix quality:**
- Record: Obviously correct, minimal, surgical. Risk of regression
  extremely low - the only behavioral change is that child processes
  cannot access the parent's AIO ring (which was never semantically
  valid - see `mm_init_aio()` which already zeros `ioctx_table` in
  child).

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 - Blame the buggy code:**
- Record: The AIO ring mmap hook is ancient (pre-2.6.12). The `.fault =
  filemap_fault` vm_op was added in mid-2010s. The fundamental bug (fork
  copies VMA but child has no AIO context) has existed essentially since
  AIO ring was made mappable. Verified via `git log --follow fs/aio.c`
  showing AIO predates the current git history (from Linux-2.6.12-rc2).

**Step 3.2 - Follow Fixes: tag:**
- Record: No Fixes: tag. The bug is essentially inherent to the AIO ring
  design from the start.

**Step 3.3 - Related changes:**
- Record: Previously, commit `81e9d6f864765` ("aio: fix mremap after
  fork null-deref", 2023, in v6.3) fixed an adjacent fork+AIO NULL-
  deref. That commit was `Cc: stable` tagged and backported. A follow-up
  commit `3adf7ae18bf42` ("fs: aio: reject partial mremap...") by the
  same author fixes yet another NULL-deref in the same family (also
  reviewed by Jan Kara). These demonstrate a pattern of fork+AIO race
  bugs.

**Step 3.4 - Author:**
- Record: Zizhi Wo is a regular Huawei kernel contributor, working on
  filesystem issues. Also authored the related `3adf7ae18bf42` mremap
  fix.

**Step 3.5 - Dependencies:**
- Record: None. The fix is self-contained. The `VM_DONTCOPY` flag has
  been part of `dup_mmap()` logic for many years (mm/mmap.c), checked
  via `mpnt->vm_flags & VM_DONTCOPY`.

### PHASE 4: MAILING LIST RESEARCH

**Step 4.1 - Original discussion:**
- Record: `b4 dig -c c03ce4173c7bf` found the original submission at htt
  ps://lore.kernel.org/all/20260413010814.548568-1-wozizhi@huawei.com/ -
  v1 only (no later revisions needed). Jan Kara's review comment
  (retrieved via b4 dig -m): "*I agree it would have to be a rather
  contrived setup to rely on AIO ringbuffer being inherited by
  fork(2)... AIO ringbuffer is mostly a legacy thing these days... So
  I'm OK with trying this simple fix and seeing whether somebody
  complains.*" - No NAKs, no stable nomination but no objection to the
  approach.

**Step 4.2 - Reviewers:**
- Record: CC'd: viro (VFS), jack (Jan Kara - MM/FS), brauner (VFS
  maintainer), bcrl (AIO original maintainer), linux-fsdevel, linux-aio,
  yangerkun, chengzhihao1. Plus Jan Kara added Jens Axboe for awareness.
  Appropriate review coverage.

**Step 4.3 - Bug report:**
- Record: Found by Huawei internal syzkaller (fuzzer). Reproducible
  kernel NULL pointer dereference - not theoretical.

**Step 4.4 - Related patches:**
- Record: Follow-up `3adf7ae18bf42` ("fs: aio: reject partial
  mremap...") addresses a related but different NULL-deref in the same
  subsystem. Independent fix.

**Step 4.5 - Stable list history:**
- Record: No explicit stable mailing list discussion found. However, the
  precedent (81e9d6f864765) of fork-related AIO fix being backported
  supports that this is stable material.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 - Key functions:**
- Record: `aio_ring_mmap_prepare()` is the only function modified.

**Step 5.2 - Callers:**
- Record: Called by VFS mmap logic via `f_op->mmap_prepare` during
  `mmap()` on the AIO ring file. Reachable from `io_setup(2)` syscall
  via `aio_setup_ring() -> do_mmap(aio_ring_file, ...)`. Reachable by
  any unprivileged process that can do io_setup().

**Step 5.3 - Callees:**
- Record: `vma_desc_set_flags()` - setting VMA flags during mmap
  preparation. No side effects other than flag setting.

**Step 5.4 - Call chain:**
- Record: Bug path reachable from userspace:
  1. User calls `io_setup(2)` -> mmap of AIO ring VMA
  2. User calls `fork(2)` -> child inherits VMA (before this fix)
  3. User (child) touches the VMA address -> triggers fault
  4. User (parent) calls `io_destroy(2)` concurrently -> race triggers
     NULL deref
  All reachable by unprivileged userspace.

**Step 5.5 - Similar patterns:**
- Record: Verified via Grep that `VM_DONTCOPY` is used in several kernel
  subsystems (android/binder.c, KFD, xen, infiniband, etc.) for VMAs
  that shouldn't be inherited by fork. The AIO ring is semantically the
  same class - it's associated with parent-specific kernel state.

### PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1 - Buggy code in stable trees:**
- Record: Verified by examining `fs/aio.c` in each stable tree:
  - `stable/linux-5.10.y`: Uses `vma->vm_flags |= VM_DONTEXPAND;` (no
    VM_DONTCOPY)
  - `stable/linux-5.15.y`: Uses `vma->vm_flags |= VM_DONTEXPAND;`
  - `stable/linux-6.1.y`: Uses `vma->vm_flags |= VM_DONTEXPAND;`
  - `stable/linux-6.6.y`: Uses `vm_flags_set(vma, VM_DONTEXPAND);`
  - `stable/linux-6.12.y`: Uses `vm_flags_set(vma, VM_DONTEXPAND);`
  - `stable/linux-6.17.y`, `6.18.y`, `6.19.y`: Uses `desc->vm_flags |=
    VM_DONTEXPAND;`

  All stable trees are missing VM_DONTCOPY and vulnerable to the bug.

**Step 6.2 - Backport complications:**
- Record: The upstream patch uses `vma_desc_set_flags(desc,
  VMA_DONTEXPAND_BIT, VMA_DONTCOPY_BIT)` which was introduced in 7.0
  (master). For each stable tree, the fix needs adaptation:
  - 5.10-6.1: `vma->vm_flags |= VM_DONTEXPAND | VM_DONTCOPY;`
  - 6.6-6.12: `vm_flags_set(vma, VM_DONTEXPAND | VM_DONTCOPY);`
  - 6.17-6.19: `desc->vm_flags |= VM_DONTEXPAND | VM_DONTCOPY;`

  Minor textual adjustment needed but semantically identical.

**Step 6.3 - Related fixes in stable:**
- Record: Commit `81e9d6f864765` ("aio: fix mremap after fork null-
  deref") was backported to stable (verified present in
  stable/linux-5.10.y as `c261f798f7baa` and in stable/linux-6.6.y as
  `81e9d6f864765`). That confirms the AIO+fork class of bugs has been
  considered stable-worthy before.

### PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 - Subsystem:**
- Record: `fs/aio.c` - AIO filesystem interface. IMPORTANT criticality -
  not in the hot path for most users (io_uring is newer), but AIO is
  widely used by legacy applications, databases (Oracle, MySQL), and
  libaio consumers. Still heavily supported.

**Step 7.2 - Activity:**
- Record: AIO is mature/stable subsystem. Low activity (mostly
  maintenance) - the bug has likely been present for years without being
  hit due to the unusual trigger (fork after io_setup is uncommon).

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 - Affected users:**
- Record: Any system using AIO where a process that called io_setup()
  then forks (e.g., databases, async I/O applications with forking). The
  fork+AIO combination is unusual but legitimate.

**Step 8.2 - Trigger conditions:**
- Record: Race between parent's io_destroy() and child's page fault on
  inherited ring. Triggerable by unprivileged userspace. Timing-
  dependent but demonstrated via syzkaller (reproducible). No special
  privileges needed.

**Step 8.3 - Failure mode severity:**
- Record: Kernel NULL pointer dereference - CRITICAL. System crash
  (oops), potential panic depending on config. Triggerable by
  unprivileged userspace - this borders on security concern (DoS).

**Step 8.4 - Risk-benefit:**
- Record:
  - BENEFIT: Prevents kernel NULL deref crash triggerable by
    unprivileged userspace. HIGH benefit.
  - RISK: 1-line flag change. VM_DONTCOPY means child doesn't inherit
    parent's AIO ring - semantically correct since `mm_init_aio()`
    already clears the child's `ioctx_table`. Verified in kernel/fork.c:
    `mm_init_aio() { mm->ioctx_table = NULL; }`. Very low risk.

### PHASE 9: FINAL SYNTHESIS

**Step 9.1 - Evidence:**
- FOR: Fixes real kernel NULL deref; found by syzkaller (reproducible);
  reviewed by Jan Kara; 1-line surgical change; semantically correct
  (child has no AIO context); precedent of similar fork+AIO fix being
  backported (`81e9d6f864765`); triggerable by unprivileged userspace
  (crash = DoS).
- AGAINST: Requires backport adjustment for older stable trees (API
  evolved from `vma->vm_flags |=` to `vm_flags_set()` to
  `desc->vm_flags` to `vma_desc_set_flags()`). However this is a trivial
  textual adjustment.

**Step 9.2 - Stable rules checklist:**
1. Obviously correct and tested? YES - reviewed by Jan Kara, logic
   verified
2. Fixes a real bug? YES - syzkaller-reproducible NULL deref
3. Important issue? YES - CRITICAL: NULL pointer deref = kernel crash
4. Small and contained? YES - 1 line
5. No new features? YES - just adds a flag
6. Can apply to stable? YES with minor textual adjustment per kernel
   version

**Step 9.3 - Exception categories:**
- Not applicable - this is a direct bug fix for a kernel NULL deref.

**Step 9.4 - Decision:** The fix clearly meets all stable criteria:
obviously correct, fixes a real (syzkaller-reproducible) kernel crash,
very small (1 line), no new APIs. The bug is triggerable by unprivileged
userspace via fork+io_setup/io_destroy race, making it a serious issue
worthy of backport. The only complication is the 4 slightly different
forms needed for different stable trees, but each is a trivial
adaptation.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Jan Kara, Signed-off-by Christian
  Brauner (VFS maintainer), Link to lore patch submission
- [Phase 2] Diff analysis: verified via `git show c03ce4173c7bf` -
  single 1-line change in `aio_ring_mmap_prepare()` adding
  VMA_DONTCOPY_BIT
- [Phase 3] Checked file history `git log --oneline -- fs/aio.c` - aio.c
  is pre-2.6.12 (ancient), the ring mmap code has existed for over a
  decade
- [Phase 3] Found related earlier fix `81e9d6f864765` "aio: fix mremap
  after fork null-deref" with explicit `Cc: <stable@vger.kernel.org>` -
  established precedent
- [Phase 4] `b4 dig -c c03ce4173c7bf -a`: single version (v1) - applied
  as-is, no revisions needed
- [Phase 4] `b4 dig -c c03ce4173c7bf -w`: verified maintainers CC'd
  (viro, jack, brauner, bcrl, linux-fsdevel, linux-aio)
- [Phase 4] `b4 dig -m /tmp/aio_patch.mbox`: Jan Kara's review approved
  the approach, called AIO ring "mostly a legacy thing", no NAKs
- [Phase 5] Verified `VMA_DONTCOPY_BIT` = 17 via
  `DECLARE_VMA_BIT(DONTCOPY, 17)` in include/linux/mm.h;
  `vma_desc_set_flags` expands to `vma_desc_set_flags_mask(desc,
  mk_vma_flags(__VA_ARGS__))`
- [Phase 5] Verified `mm_init_aio` in kernel/fork.c: `mm->ioctx_table =
  NULL;` - child has no AIO context, confirming semantic correctness
- [Phase 5] Verified `VM_DONTCOPY` handling in mm/mmap.c dup_mmap: `if
  (mpnt->vm_flags & VM_DONTCOPY) { ... continue; }` - VMA is skipped
  during fork
- [Phase 6] Read code from each stable tree's `fs/aio.c`:
  - 5.10.y line 369-373: `vma->vm_flags |= VM_DONTEXPAND`
  - 5.15.y line 368-373: `vma->vm_flags |= VM_DONTEXPAND`
  - 6.1.y line 395-400: `vma->vm_flags |= VM_DONTEXPAND`
  - 6.6.y line 395-400: `vm_flags_set(vma, VM_DONTEXPAND)`
  - 6.12.y line 395-400: `vm_flags_set(vma, VM_DONTEXPAND)`
  - 6.17.y/6.18.y/6.19.y line 395-400: `desc->vm_flags |= VM_DONTEXPAND`
  None have VM_DONTCOPY - all are vulnerable.
- [Phase 6] Verified related `81e9d6f864765` is in stable via `git log
  stable/linux-5.10.y` (as `c261f798f7baa`) and stable/linux-6.6.y
- [Phase 7] Subsystem identified as fs/aio (filesystem, async I/O) -
  IMPORTANT criticality level
- [Phase 8] Failure mode: NULL deref at `filemap_read_folio` when
  accessing `a_ops->read_folio` (not implemented by AIO) - confirmed
  from stack trace in commit message
- UNVERIFIED: Whether the original syzkaller reproducer is public
  (Huawei internal testing, report not public)
- UNVERIFIED: Exact date when the bug first became exploitable (depends
  on when filemap_fault path was used for this VMA, which has been
  present since aio ring was mappable - approximately since 2013)

## Conclusion

This is a small, surgical bug fix for a kernel NULL pointer dereference
that can be triggered by unprivileged userspace via a fork+AIO race. The
fix is semantically correct (child has no AIO context, so the VMA
shouldn't be inherited), was reviewed by Jan Kara, and has an
established precedent of related fork+AIO fixes being backported to
stable. The only caveat is that each stable tree needs a minor textual
adaptation due to API evolution (from `vma->vm_flags |=` to
`vm_flags_set()` to `vma_desc_set_flags()`), but the one-line semantic
change applies cleanly in every case.

**YES**

 fs/aio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index a07bdd1aaaa60..6d436f8b3f349 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -394,7 +394,7 @@ static const struct vm_operations_struct aio_ring_vm_ops = {
 
 static int aio_ring_mmap_prepare(struct vm_area_desc *desc)
 {
-	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT);
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTCOPY_BIT);
 	desc->vm_ops = &aio_ring_vm_ops;
 	return 0;
 }
-- 
2.53.0

