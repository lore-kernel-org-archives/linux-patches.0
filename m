Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790363FB06F;
	Tue, 28 Apr 2026 10:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372923; cv=none; b=RnTGZqUPZGH6bCDhUAaTnIbKDTlQvnKTsmRFWNxAd9KEs5L66xCmIUvN2g3/bvKcUD6/pftDDO+W//0vjiKBB6kUFCneb+V1DDqyYeo99xatuzO6/krBueMr6pLsgE1wZcYji8g9zPxXWJsDS+9IjQF6R25bpCwPx6Nx4TISv2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372923; c=relaxed/simple;
	bh=IWgk6c08JwxdVMmPxZP98UUe6irZGszbjLSjSALOJ2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UZeM3M7xb6oSeMFX4ZZm9hwsfvs7SGeZK+KWMC+ZG44ZUPzD+JleNWAvJT1jzA1hxyvsZ/79o0yfIS67YOrsCmzYt9i4oOC1W5KgRWM4qR58L01KFO3E0nvbw/FWyO7jg5gtDBj9voga/hCb2mplVRURIlhAs7hMO/xwlNmWGY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ou+ugdfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ou+ugdfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F41AC2BCB9;
	Tue, 28 Apr 2026 10:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372923;
	bh=IWgk6c08JwxdVMmPxZP98UUe6irZGszbjLSjSALOJ2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ou+ugdfp/kyNvBP/KfzN9p3B7XmADKNnIViOMxNkBc2SkWuD1mQbciolHctqaixkz
	 X0SHx2twYixbBBdO6Ha990nKpo9ObYfxtsBpRNLUNbOCCaa25GChq0wbLp7Zl0yb4I
	 tFUiQZwDrfv1gYQJHQhzN/y/9usbXP66lo3nVCoI0kB2e4rrmgebEvst5jClB2/SMq
	 V5pkU4xfHXRsvJH3hBCzpkb6Vu7XsP4evX6BwpBFgz7OavPVDXRiM5VCl9JTmcgyaa
	 p+nmv3+D0nbzUhfRppSwexyQk0VEuldr9n7SItut0yNur/thMqxiwyZj8iuvXJFEOB
	 KR7eRtQJNk3tg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] fs/ntfs3: fix potential double iput on d_make_root() failure
Date: Tue, 28 Apr 2026 06:40:32 -0400
Message-ID: <20260428104133.2858589-21-sashal@kernel.org>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit d1062683bf6b560b31f287eb0ebde4841bc72376 ]

d_make_root() consumes the reference to the passed inode: it either
attaches it to the newly created dentry on success, or drops it via
iput() on failure.

In the error path, the code currently does:
    sb->s_root = d_make_root(inode);
    if (!sb->s_root)
        goto put_inode_out;

which leads to a second iput(inode) in put_inode_out. This results in
a double iput and may trigger a use-after-free if the inode gets freed
after the first iput().

Fix this by jumping directly to the common cleanup path, avoiding the
extra iput(inode).

Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to complete a comprehensive analysis.

# Phase-by-Phase Analysis

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line parsing**
Record: subsystem = `fs/ntfs3`; action verb = `fix`; summary = "fix
potential double iput on d_make_root() failure".

**Step 1.2 — All commit message tags**
Record:
- No `Fixes:` tag (absence is expected — reason for manual review).
- No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Acked-by:`.
- No `Link:`.
- No `Cc: stable`.
- `Signed-off-by:` Zhan Xusheng (author) and Konstantin Komarov (ntfs3
  maintainer who applied it).

**Step 1.3 — Commit body**
Record: Author describes the VFS contract for `d_make_root()` — it
consumes the inode reference on both success and failure (on failure it
calls `iput()` internally). The ntfs3 error path jumps to the
`put_inode_out` label, which calls `iput(inode)` again, giving a double
`iput`. Consequence: "may trigger a use-after-free if the inode gets
freed after the first iput()". Root cause is a misunderstanding of
`d_make_root()` semantics.

**Step 1.4 — Hidden bug fix detection**
Record: Not hidden — explicitly "fix". Author correctly identifies the
VFS-API contract violation.

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record: Single file `fs/ntfs3/super.c`, one function
`ntfs_fill_super()`, one line changed (`goto put_inode_out` → `goto
out`). Net diff: 1 insertion, 1 deletion. Scope: surgical single-line
fix.

**Step 2.2 — Code flow change**
Record:
- BEFORE: if `d_make_root()` returns NULL, jump to `put_inode_out:`
  which does `iput(inode);` then falls through to `out:`.
- AFTER: if `d_make_root()` returns NULL, jump directly to `out:`,
  skipping the extra `iput()`.

**Step 2.3 — Bug mechanism**
Record: Category = (d) Memory safety / double-free. Verified
`d_make_root()` semantics against `fs/dcache.c`:

```2042:2054:fs/dcache.c
struct dentry *d_make_root(struct inode *root_inode)
{
        struct dentry *res = NULL;

        if (root_inode) {
                res = d_alloc_anon(root_inode->i_sb);
                if (res)
                        d_instantiate(res, root_inode);
                else
                        iput(root_inode);
        }
        return res;
}
```

When `d_alloc_anon()` fails, `d_make_root()` calls `iput(root_inode)`
and returns NULL. The caller must not call `iput()` again. The ntfs3
code was violating this, producing a double `iput`.

**Step 2.4 — Fix quality**
Record: Obviously correct. Minimal. Zero regression risk: it only
removes an extra `iput()` that is already performed inside
`d_make_root()`. The only behavior change is replacing a guaranteed
double-`iput`/UAF with the correct single release.

## PHASE 3: GIT HISTORY

**Step 3.1 — Blame**
Record: The buggy `goto put_inode_out` on `d_make_root()` failure was
introduced in `9b75450d6c580` ("fs/ntfs3: Fix memory leak if fill_super
failed", 2021-09-28). `git describe --contains 9b75450d6c580` =
`v5.15-rc6~33^2~6`, i.e., the bug has been present since the very first
released kernel that contained ntfs3 (v5.15).

**Step 3.2 — Fixes: tag**
Record: No `Fixes:` tag in the commit, but via `git log -L` I confirmed
the buggy construct was introduced by `9b75450d6c580`. That commit is in
v5.15 and therefore exists in every currently maintained stable tree.

**Step 3.3 — Related changes in file**
Record: `put_inode_out` was specifically reintroduced around the same
timeframe and further exercised by `c1ca8ef0262b2` ("fs/ntfs3: Add null
pointer check for inode operations", 2022). Not part of a series.
Standalone fix.

**Step 3.4 — Author**
Record: Author Zhan Xusheng has several small fixes merged previously
(timers, staging, sched/fair). Not the ntfs3 maintainer, but the
maintainer (Konstantin Komarov) explicitly applied the patch.

**Step 3.5 — Dependencies**
Record: None. Single-line edit inside pre-existing error handling. Self-
contained.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1 — Original patch discussion**
Record: `b4 dig -c d1062683bf6b5` matched by patch-id to the single v1
submission at `https://lore.kernel.org/all/20260326091232.92760-1-
zhanxusheng@xiaomi.com/`. I downloaded the full thread to
`/tmp/ntfs3_double_iput.mbox` and read it.

Key review comments:
- **Al Viro** (VFS maintainer) responded on 2026-04-04 confirming the
  mechanism and went further: "Matter of fact, the whole `put_inode_out`
  should go; if you *ever* get an inode with NULL ->i_op, it's a bug."
  Al did NOT NAK the patch — he pointed at an additional, deeper problem
  that is outside the scope of this fix.
- **Konstantin Komarov** (ntfs3 maintainer) replied on 2026-04-07:
  "Thanks for the patch. It was applied. I'm going to take a closer look
  at this problem."

**Step 4.2 — Reviewers**
Record: `b4 dig -w` shows recipients: Konstantin Komarov (ntfs3
maintainer), linux-kernel, Zhan Xusheng. Review came from both the
subsystem maintainer and Al Viro (VFS maintainer).

**Step 4.3 — Bug report**
Record: No linked syzbot / bugzilla report — the bug was found by code
inspection of the `d_make_root()` contract.

**Step 4.4 — Related patches**
Record: `b4 dig -a` shows only v1 applied. Standalone, not part of a
multi-patch series.

**Step 4.5 — Stable mailing list**
Record: N/A (web access blocked by Anubis), but not needed — evidence
from the lore thread is conclusive.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**
Record: Only `ntfs_fill_super()` is touched.

**Step 5.2 — Callers**
Record: `ntfs_fill_super()` is the standard
`fs_context_operations::get_tree` implementation, invoked through
`get_tree_bdev()`, ultimately reachable from the `mount(2)` /
`fsopen(2)` / `fsmount(2)` syscalls. Reachable from any privileged user
(CAP_SYS_ADMIN) that can mount NTFS, plus increasingly from unprivileged
contexts on some distro setups (e.g., mount helpers) and automounters
handling removable NTFS media.

**Step 5.3 — Callees**
Record: The affected branch is purely error-path cleanup:
`d_make_root()` → (fails) → `iput(inode)` was being called twice. No
locks held across the double `iput`.

**Step 5.4 — Reachability**
Record: The failure path requires `d_make_root()` → `d_alloc_anon()` to
return NULL, which happens under memory pressure (kmem allocation
failure). Real, not theoretical; any fuzzer that injects allocation
faults (fail_nth/FAULT_INJECTION) at mount time can hit it.

**Step 5.5 — Similar patterns**
Record: A semantically identical fix was already applied to erofs back
in 2019 (`94832d9399217` "staging: erofs: fix potential double iput in
erofs_read_super()"). This confirms the pattern as a recognized,
backport-worthy bug class.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1 — Does the buggy code exist in stable?**
Record: Verified via `git show vTAG:fs/ntfs3/super.c` for v5.15, v6.1,
v6.6, v6.12 — the exact `goto put_inode_out;` pattern on `d_make_root()`
failure is present in all of them. ntfs3 did not exist before v5.15, so
no older stable tree is affected.

**Step 6.2 — Backport complications**
Record: The lines around the change are stable across the tags; the fix
is a 1-line modification to an unchanged region of code. Should apply
cleanly to all stable trees ≥5.15 with zero or trivial conflict
resolution.

**Step 6.3 — Related fixes already in stable?**
Record: None found. This is the first fix for this specific bug.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1 — Subsystem**
Record: `fs/ntfs3` = filesystem driver. Criticality = IMPORTANT (widely
used by distros for NTFS support on removable media and dual-boot
systems).

**Step 7.2 — Activity**
Record: Actively maintained (Konstantin Komarov regularly submits
patches, per `git log`).

## PHASE 8: IMPACT/RISK

**Step 8.1 — Affected users**
Record: Users mounting NTFS volumes with the ntfs3 driver under memory
pressure, plus any fault-injection testing of the mount path. Stable
users on 5.15.y / 6.1.y / 6.6.y / 6.12.y all affected.

**Step 8.2 — Trigger conditions**
Record: Requires `d_alloc_anon()` allocation failure during NTFS mount
(memory pressure or fault injection). Rare in typical use but certainly
reachable; also a reliable fuzzer target.

**Step 8.3 — Failure mode severity**
Record: Double `iput()` → `iput_final()` → `evict()` on an already-freed
inode → use-after-free / kernel crash / potential exploitation. Severity
= HIGH (memory safety bug in privileged mount path).

**Step 8.4 — Risk vs benefit**
Record: BENEFIT = eliminate a real UAF on a clean reachable error path;
also removes the only reviewer-identified memory-safety issue from that
code. RISK = essentially zero: a single label change that removes an
extra `iput()`, which is strictly correct per the VFS API contract.
Endorsed implicitly by Al Viro. Excellent ratio.

## PHASE 9: SYNTHESIS

**Step 9.1 — Evidence**
- FOR: real double-iput / UAF bug, present since v5.15 in all stable
  trees, one-line surgical fix, correct per VFS contract (verified in
  `fs/dcache.c`), applied by subsystem maintainer, acknowledged by VFS
  maintainer Al Viro, same pattern previously backported for erofs,
  reachable from the `mount(2)` syscall, no dependencies.
- AGAINST: No `Fixes:` tag (expected for review); no `Cc: stable` tag
  (expected for review); trigger is allocation failure in
  `d_alloc_anon()` (rare but real). None of these are technical reasons
  to reject.

**Step 9.2 — Stable rules**
1. Obviously correct and tested: YES (trivially correct, applied
   upstream, VFS-contract-conformant).
2. Fixes a real bug: YES (double `iput` → UAF).
3. Important issue: YES (memory safety).
4. Small and contained: YES (1 line).
5. No new features/APIs: YES.
6. Applies to stable trees: YES (verified the surrounding code is
   identical in 5.15/6.1/6.6/6.12).

**Step 9.3 — Exception category**
Not needed — this is a standard bug fix under criterion #3 (serious
crash / memory safety).

**Step 9.4 — Decision**
All evidence supports backporting.

---

## Verification

- [Phase 1] Read commit message; no tags present other than two `Signed-
  off-by:`. Verified no `Fixes:` / `Cc: stable` / `Reported-by:` tags.
- [Phase 2] Inspected the diff — 1 insertion, 1 deletion, one label
  change in error path.
- [Phase 2] Verified `d_make_root()` consumes the inode reference on
  failure by reading `fs/dcache.c:2042-2054` — it calls
  `iput(root_inode)` when `d_alloc_anon()` returns NULL.
- [Phase 2] Read `fs/ntfs3/super.c:1670-1717` to confirm the actual
  `put_inode_out:` label does `iput(inode);` unconditionally, proving
  the double-iput.
- [Phase 3] `git log --oneline -S "put_inode_out" -- fs/ntfs3/super.c`
  and `git log -L` on the changed code block identified `9b75450d6c580`
  as the commit that introduced the buggy `goto put_inode_out`.
- [Phase 3] `git describe --contains 9b75450d6c580` = `v5.15-rc6~33^2~6`
  → bug lives in all stable trees from v5.15 onward.
- [Phase 3] `git describe --contains 82cae269cfa95` =
  `v5.15-rc1~94^2~34` — confirms ntfs3 first appeared in v5.15 (no
  earlier stable affected).
- [Phase 4] `b4 dig -c d1062683bf6b5` found single v1 submission at lore
  URL `.../20260326091232.92760-1-zhanxusheng@xiaomi.com/`.
- [Phase 4] `b4 dig -c d1062683bf6b5 -a` confirmed only one series
  revision (v1).
- [Phase 4] `b4 dig -c d1062683bf6b5 -w` confirmed original recipients
  include maintainer Konstantin Komarov.
- [Phase 4] Read the downloaded mbox `/tmp/ntfs3_double_iput.mbox`:
  found Al Viro (VFS maintainer) acknowledging the bug mechanism and
  Konstantin Komarov confirming "It was applied".
- [Phase 5] Confirmed identical pattern was fixed for erofs in
  `94832d9399217` — pre-existing backport precedent.
- [Phase 6] Verified the buggy `goto put_inode_out;` on `d_make_root()`
  failure is literally present at v5.15, v6.1, v6.6, v6.12 by `git show
  vTAG:fs/ntfs3/super.c` on each tag.
- [Phase 6] Confirmed fix applies cleanly — only a label change on an
  unchanged surrounding block.
- [Phase 8] Failure mode verified: `iput()` twice on the same inode
  after the first may have dropped the last reference → UAF. Severity
  HIGH.
- UNVERIFIED: The exact frequency of `d_alloc_anon()` returning NULL in
  the wild — not relevant to stable decision because fault-injection and
  OOM paths can both trigger it.

---

## Decision rationale

This is a textbook stable candidate:
- 1-line, provably correct fix based directly on a well-known VFS API
  contract.
- Addresses a double-`iput`/UAF memory safety bug reachable from the
  `mount(2)` syscall.
- Bug present in every currently maintained stable tree (5.15.y, 6.1.y,
  6.6.y, 6.12.y and newer).
- Validated by the ntfs3 maintainer (applied it) and confirmed by VFS
  maintainer Al Viro.
- Identical pattern was previously treated as stable material in other
  filesystems.
- Zero regression risk — it removes an extra `iput` that is already
  performed by `d_make_root()`.

**YES**

 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 174a7cb202a08..d0dad15076ca2 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1673,7 +1673,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_root = d_make_root(inode);
 	if (!sb->s_root) {
 		err = -ENOMEM;
-		goto put_inode_out;
+		goto out;
 	}
 
 	if (boot2) {
-- 
2.53.0

