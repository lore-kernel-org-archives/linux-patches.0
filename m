Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DBD426EC5;
	Tue, 28 Apr 2026 10:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372993; cv=none; b=FNYV6OkEeLCg7wLLOfUbq1cinVAH4dczLw11bDFVTf6bSGsLF+Iii/KcPjtfT+mxpfVidRbV+eHAElvigQ65dQ0DGvi/U4Hm0HiC4jJ6XErDsEOLPqUxoiglbWRQiyQHdVZttyEDrmIskrJD2xqjdu58SDYMBGquMgyxcPNakwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372993; c=relaxed/simple;
	bh=bn9BG1xFIwrKA9cgpSumkeRJ223KThOF7nGz7UGmzE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=etn9fvABP9rStLZTPKXfu5z2SIN8lG6Jwm+4Pm7F1/1QNuz/LruwL8y9Y21zipNBdA5mrLuMyM0dH8cmsMvFGNK8ZTNGJkwDogu8oEr7rSUoKTdpFrc2tbD3hf7OhbTOTS2w30AYhRtja4EyU7l7HrmMU1x+6ZpBZIppI4N+Bx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uHsGBr4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uHsGBr4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464ADC2BCB6;
	Tue, 28 Apr 2026 10:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372993;
	bh=bn9BG1xFIwrKA9cgpSumkeRJ223KThOF7nGz7UGmzE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHsGBr4PbhAfiFSSa7iNfOUhcT8JMtwWFCVhcDwriGIOQEjZLF/3/6Zb2i0Mg3ayb
	 Mxb4Wsdi6uSLgbTy96ARXNlZ1uWoalh7pac/XxEpd+C2BlpcYcrcg6dXxSyLrPcz3d
	 t++E4BFy4549DDkwH0rsIQBTruOw/4MA5JG137bGGL4hw3UGJEa4Py8SwdRQiumF8J
	 MAEtBmEQH8Yg35h3ShnTTlVWqh3HnerUeGsLELsndr/nBQUAUz6ttDvPkbV6UaSvRW
	 B2ptrpEXrFkqbUXbsx4JtIQBMOQhURJHdqBWswE9q/RBnPA66W4fUa3iorHC52Soxk
	 yDUoz6nIB+2nw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+7adcddaeeb860e5d3f2f@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] ntfs3: fix memory leak in indx_create_allocate()
Date: Tue, 28 Apr 2026 06:41:20 -0400
Message-ID: <20260428104133.2858589-69-sashal@kernel.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit 87ac077d6ea8613b7c1debdf3b5e92c78618fd23 ]

When indx_create_allocate() fails after
attr_allocate_clusters() succeeds, run_deallocate()
frees the disk clusters but never frees the memory
allocated by run_add_entry() via kvmalloc() for the
runs_tree structure.

Fix this by adding run_close() at the out: label to
free the run.runs memory on all error paths. The
success path is unaffected as it returns 0 directly
without going through out:, transferring ownership
of the run memory to indx->alloc_run via memcpy().

Reported-by: syzbot+7adcddaeeb860e5d3f2f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7adcddaeeb860e5d3f2f
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to provide the complete analysis.

## Complete 9-Phase Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 - Subject Line**
- Record: `[ntfs3]` `[fix]` memory leak in `indx_create_allocate()`.
  Clear, unambiguous fix language.

**Step 1.2 - Commit Message Tags**
- Record:
  - Reported-by: `syzbot+7adcddaeeb860e5d3f2f@syzkaller.appspotmail.com`
    (syzkaller fuzzer-found, reproducible)
  - Closes:
    `https://syzkaller.appspot.com/bug?extid=7adcddaeeb860e5d3f2f`
    (syzbot link)
  - Signed-off-by: Deepanshu Kartikey (author) and Konstantin Komarov
    (ntfs3 maintainer)
  - No Fixes: tag (noted as expected for review candidates)
  - No Cc: stable (noted as expected for review candidates)

**Step 1.3 - Commit Body Analysis**
- Record: Bug description: When `indx_create_allocate()` fails after
  `attr_allocate_clusters()` has succeeded, `run_deallocate()` only
  frees the on-disk clusters but NOT the memory that `run_add_entry()`
  allocated via `kvmalloc()` for the `runs_tree.runs` array. Failure
  mode: kernel memory leak (reachable via unprivileged syscall). Author
  correctly identifies the root cause and explains why the success path
  is unaffected.

**Step 1.4 - Hidden Bug Fix Detection**
- Record: Not a hidden fix - explicitly labeled "fix memory leak".

### PHASE 2: DIFF ANALYSIS

**Step 2.1 - Inventory**
- Record: 1 file, 1 line added, 0 lines removed. Single-file surgical
  fix. Only `indx_create_allocate()` is modified.

**Step 2.2 - Code Flow Change**
- Record: Before: The `out:` label only contained `return err;`. After:
  `run_close(&run);` is invoked before return. `run_close()` does
  `kvfree(run->runs); memset(run, 0, sizeof(*run));` - this frees the
  allocated runs array. The success path returns via `return 0` at line
  1475 BEFORE the `out:` label, after doing `memcpy(&indx->alloc_run,
  &run, sizeof(run));` to transfer ownership.

**Step 2.3 - Bug Mechanism**
- Record: Category (a) + (c): error path / resource leak fix,
  specifically a missing deallocation. `run_add_entry()` at
  `fs/ntfs3/run.c:390` calls `kvmalloc(bytes, GFP_KERNEL)` storing
  pointer in `run->runs`. `run_deallocate()` at `fs/ntfs3/fsntfs.c:2550`
  only frees on-disk clusters via `mark_as_free_ex()` - verified it does
  NOT touch `run->runs`. Therefore every error path that goes through
  `out:` (3 of them: the direct `attr_allocate_clusters` failure plus
  the `out1` and `out2` fallthroughs) leaks the kvmalloc allocation.
  `run_close()` is safe on a `run_init`'d (all-zero) run because
  `kvfree(NULL)` is a no-op.

**Step 2.4 - Fix Quality**
- Record: Fix quality is excellent. Obviously correct: `run_close` is
  idempotent/safe on NULL, so adding it unconditionally at `out:` cannot
  introduce regressions. No API changes, no new locking, no new
  allocations. Zero regression risk.

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 - Blame**
- Record: The `out:` label with `return err;` structure and the
  `runs_tree run; run_init(&run);` pattern are from commit
  `f7464060f7ab9a` (Linus Torvalds, 2021-09-04) - the initial ntfs3
  merge for v5.15-rc1. Thus the bug has existed since v5.15 and affects
  every stable tree that includes ntfs3.

**Step 3.2 - Fixes: tag**
- Record: No Fixes: tag in the commit. Root-cause commit (first ntfs3
  merge) is `f7464060f7ab9a`, which is v5.15-rc1~94 and obviously
  present in all stable trees ≥ 5.15.

**Step 3.3 - File History**
- Record: `fs/ntfs3/index.c` has 37 commits since v5.15. Immediate prior
  change was `3a2141b2f1c34 fs/ntfs3: resolve compare function in public
  index APIs` (unrelated). The `out:` sequence itself has been untouched
  since initial merge. Related historical fixes include `b8155e95de38b
  fs/ntfs3: Fix error handling in indx_insert_into_root()` (different
  function, similar class of bug) and `ccc4e86d1c242 fs/ntfs3: Prevent
  memory leaks in add sub record` (another recent syzbot memory leak
  fix). This is a standalone patch, NOT part of a series.

**Step 3.4 - Author's Other Commits**
- Record: Deepanshu Kartikey has submitted multiple fuzzer-found bug
  fixes across ntfs3, ext4, gfs2, netfs, mac80211, atm, comedi, etc. A
  regular kernel contributor who focuses on bug fixes rather than new
  features. Patch was applied by Konstantin Komarov - the ntfs3
  maintainer.

**Step 3.5 - Dependencies**
- Record: Standalone, no dependencies. The fix uses `run_close()` which
  is a stable inline helper in `fs/ntfs3/ntfs_fs.h` from the initial
  ntfs3 merge. No new APIs used.

### PHASE 4: MAILING LIST RESEARCH

**Step 4.1 - Original Patch Discussion**
- Record: b4 dig found submission at `https://lore.kernel.org/all/202603
  21050143.1117500-1-kartikey406@gmail.com`. v1 is the only revision;
  the committed version is unchanged from v1 (same diff). Submission
  2026-03-21, committed 2026-03-23.

**Step 4.2 - Recipients**
- Record: Original recipients per b4 dig -w: Konstantin Komarov
  (almaz.alexandrovich@paragon-software.com - ntfs3 maintainer),
  ntfs3@lists.linux.dev, linux-kernel@vger.kernel.org, syzbot reporter.
  Correct audience.

**Step 4.3 - Bug Report**
- Record: Syzbot report at
  https://syzkaller.appspot.com/bug?extid=7adcddaeeb860e5d3f2f confirms:
  - Title: "memory leak in run_add_entry (2)"
  - Has syz repro AND C repro
  - Reproducible stack: `__x64_sys_link -> filename_linkat -> vfs_link
    -> ntfs_link -> ntfs_link_inode -> ni_add_name -> indx_insert_entry
    -> indx_insert_into_root -> indx_create_allocate ->
    attr_allocate_clusters -> run_add_entry`
  - Syzbot marks this commit as the fix and confirms it's patched
  - Reachable via `link(2)` syscall → unprivileged userspace trigger

**Step 4.4 - Series Context**
- Record: b4 dig -a shows only one revision (v1) - single standalone
  patch, not a series.

**Step 4.5 - Stable Discussion**
- Record: Thread discussion (from saved mbox): Konstantin's reply on
  2026-04-01 "Your patch is being tested internally. I'll follow up" and
  on 2026-04-02 "Your patch is applied, thanks for your work." No
  reviewer asked for Cc: stable explicitly, but no objections or
  concerns were raised either. No NAKs. Maintainer tested before
  applying.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 - Key Functions**
- Record: `indx_create_allocate()` is the only function modified.

**Step 5.2 - Callers**
- Record: `indx_create_allocate()` called from exactly one place:
  `indx_insert_into_root()` at `fs/ntfs3/index.c:1705`.
  `indx_insert_into_root()` is called from `indx_insert_entry()`, which
  is called from directory operations including `ni_add_name()` (from
  link/rename/create operations). Thus this code is reachable from
  common filesystem syscalls on any ntfs3-mounted volume.

**Step 5.3 - Callees**
- Record: Key callees: `run_init`, `attr_allocate_clusters` (calls
  `run_add_entry` which does the `kvmalloc`), `ni_insert_nonresident`,
  `ni_insert_resident`, `run_deallocate`, `run_close` (the newly added
  fix).

**Step 5.4 - Call Chain (Reachability)**
- Record: Confirmed userspace reachable: `link(2)` → `__x64_sys_link` →
  `vfs_link` → `ntfs_link` → ... → `indx_create_allocate()`. Syzbot's C
  reproducer triggers the leak from an unprivileged process. Memory
  exhaustion attack vector exists.

**Step 5.5 - Similar Patterns**
- Record: Several recent ntfs3 memory leak fixes follow the same pattern
  (e.g., `ccc4e86d1c242 fs/ntfs3: Prevent memory leaks in add sub
  record` - another syzbot-reported ntfs3 leak). The ntfs3 driver has a
  history of these error-path resource leak fixes, which is common in
  newer filesystems.

### PHASE 6: STABLE TREE ANALYSIS

**Step 6.1 - Code in Stable**
- Record: ntfs3 was merged in v5.15 (`f7464060f7ab9a`). The buggy
  `indx_create_allocate()` exists in ALL stable trees from 5.15.y
  onward: 5.15.y, 6.1.y, 6.6.y, 6.12.y, etc.

**Step 6.2 - Backport Difficulty**
- Record: The `out:` block `run_deallocate(sbi, &run, false); out:
  return err;` has been unchanged since initial merge. The patch adds
  one line at the out: label. Expected clean application to all stable
  trees with no adjustments needed. Minor surrounding line-number
  differences are possible but the hunk context (`run_deallocate(...)`
  just above `out:` above `return err`) is stable.

**Step 6.3 - Related Fixes in Stable**
- Record: No earlier/alternative fix for this specific bug exists - the
  syzbot report is fresh (first crash 31 days before patched per the
  syzbot dashboard).

### PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1 - Subsystem**
- Record: fs/ntfs3/ - Read-Write NTFS filesystem driver. Criticality:
  IMPORTANT (used by many dual-boot setups, external NTFS-formatted
  drives). Filesystem bugs especially leaks/corruptions directly impact
  users.

**Step 7.2 - Subsystem Activity**
- Record: ntfs3 is actively developed and receives regular fixes
  (including security/fuzzer-found issues). 37 commits to index.c alone
  since v5.15.

### PHASE 8: IMPACT AND RISK

**Step 8.1 - Who is Affected**
- Record: All ntfs3 users on stable kernels 5.15+. Trigger requires a
  mounted ntfs3 filesystem plus the ability to create/link files that
  trigger index allocation.

**Step 8.2 - Trigger Conditions**
- Record: Syzbot reproducer uses `link(2)` syscall on an ntfs3
  filesystem; bug triggers when `indx_create_allocate()` takes any of
  its three error paths after `run_add_entry` has allocated memory.
  Unprivileged user on a system with ntfs3 mounted (e.g., USB drive) can
  trigger. Repeated triggering leaks kernel memory → potential DoS.

**Step 8.3 - Failure Mode Severity**
- Record: Failure mode: kernel memory leak. Severity: MEDIUM (kmemleak
  report, no immediate crash, but exploitable for kernel-memory
  exhaustion DoS from unprivileged user on systems with writable ntfs3
  mounts). Not critical per-trigger but real security relevance.

**Step 8.4 - Risk/Benefit**
- Record:
  - Benefit: Fixes a syzbot-confirmed, reproducible leak triggerable
    from userspace. Medium-to-high benefit for stable users (especially
    those with ntfs3 mounted by default, like many distros).
  - Risk: Very low. 1-line addition of `kvfree` helper at error-path
    return. Fix cannot regress because `run_close` on a zero-initialized
    run is a no-op. No locking changes, no allocation, no behavioral
    differences on the success path.
  - Ratio: Strongly favors backporting.

### PHASE 9: SYNTHESIS

**Evidence FOR backporting:**
- Reported by syzbot with a C reproducer (fuzzer-confirmed,
  reproducible)
- Reachable from unprivileged userspace via `link(2)` syscall
- Buggy code present since v5.15 (affects all active stable branches)
- Fix is 1 line, obviously correct, maintainer-tested before apply
- Fix path (`run_close` on init'd/NULL run) is trivially safe
- Clean applies expected across all stable trees (stable hunk context)
- Fits the "resource leak in error paths" pattern that's classic stable
  material
- Reviewed/applied by subsystem maintainer (Konstantin Komarov)

**Evidence AGAINST backporting:**
- No Fixes: tag or Cc: stable in original submission (expected - this is
  precisely the review-candidate category)
- Leak is not catastrophic per-event (gradual kernel memory consumption)
- No Reviewed-by/Tested-by tags in-tree (but syzbot confirmed the fix
  works, and maintainer stated it was internally tested)

**Stable Rules Checklist:**
1. Obviously correct and tested: YES (trivial fix; syzbot confirmed;
   maintainer tested)
2. Fixes a real bug affecting users: YES (syzbot reproducible from
   unprivileged syscall)
3. Important issue: YES (kernel memory leak exploitable by unprivileged
   user = DoS vector)
4. Small and contained: YES (1 line, 1 file)
5. No new features/APIs: YES (uses existing `run_close` helper)
6. Applies to stable: YES (clean apply expected)

**Exception category:** Not needed - this is a straightforward bug fix.

## Verification

- [Phase 1] Parsed tags: confirmed Reported-by: syzbot, Closes link to
  syzkaller. No Fixes/Cc:stable tags (expected).
- [Phase 2] Read diff via `git show 87ac077d6ea86`: confirmed +1 line
  (`run_close(&run);`) at `out:` label, nothing else.
- [Phase 2] Read `fs/ntfs3/ntfs_fs.h:1002-1006`: verified `run_close` =
  `kvfree(run->runs); memset(run,0,...);` - safe on init'd run.
- [Phase 2] Read `fs/ntfs3/run.c:310-403`: verified `run_add_entry` at
  line 390 calls `kvmalloc(bytes, GFP_KERNEL)` into `run->runs`.
- [Phase 2] Read `fs/ntfs3/fsntfs.c:2550-2564`: verified
  `run_deallocate` only frees on-disk clusters, does NOT free
  `run->runs`.
- [Phase 3] `git blame` on `fs/ntfs3/index.c` lines 1430-1485: buggy
  structure present since `f7464060f7ab9a` (Linus, 2021-09-04).
- [Phase 3] `git describe --contains f7464060f7ab9a`: confirmed
  v5.15-rc1~94 → bug present from v5.15 onward.
- [Phase 3] `git log --author="Deepanshu Kartikey"`: confirmed author is
  a prolific bug-fix contributor.
- [Phase 4] `b4 dig -c 87ac077d6ea86`: found submission at
  `lore.kernel.org/all/20260321050143.1117500-1-kartikey406@gmail.com`.
- [Phase 4] `b4 dig -a`: only 1 revision (v1).
- [Phase 4] `b4 dig -w`: recipients include ntfs3 maintainer and ML.
- [Phase 4] WebFetch syzkaller dashboard: confirmed reproducible (C
  repro), commit is marked as the fix, patched across all syzbot
  managers.
- [Phase 4] Read saved mbox thread: confirmed maintainer tested
  internally and applied; no NAKs, no stable nomination requests.
- [Phase 5] `grep indx_create_allocate` in fs/ntfs3: only 1 caller
  (`indx_insert_into_root` at line 1705).
- [Phase 5] Syzkaller stack trace confirms reachability:
  `__x64_sys_link` → ... → `run_add_entry`.
- [Phase 6] `git log -- fs/ntfs3/index.c`: `out:` block unchanged since
  initial merge → clean stable backport expected.
- [Phase 6] Similar fixes in `ccc4e86d1c242` and `b8155e95de38b` show
  this class of patch is routinely accepted.
- [Phase 8] Severity assessment grounded in: syzbot kmemleak reporter,
  unprivileged-user reachability, repeatable trigger.
- UNVERIFIED: Did not test actual `git am` of the patch onto each stable
  branch; assessed clean-apply by context analysis only.
- UNVERIFIED: Exact behavior of per-distro ntfs3 default-mount policy
  (minor impact on "who's affected" scope).

## Decision Rationale

This is a textbook stable-tree candidate: a one-line fix for a syzbot-
reproducible memory leak that is reachable from an unprivileged
`link(2)` syscall on ntfs3. The bug is present in every stable tree from
v5.15 forward, the fix is obviously correct (adds a safe idempotent
cleanup call on the error path while leaving the success path
untouched), it was applied by the subsystem maintainer after internal
testing, and the risk of regression is essentially zero. These are
exactly the criteria the stable rules prioritize: small, contained,
fixes a real bug, and obviously correct.

**YES**

 fs/ntfs3/index.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 97f06c26fe1a6..11f59d7b9ea45 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1481,6 +1481,7 @@ static int indx_create_allocate(struct ntfs_index *indx, struct ntfs_inode *ni,
 	run_deallocate(sbi, &run, false);
 
 out:
+	run_close(&run);
 	return err;
 }
 
-- 
2.53.0

