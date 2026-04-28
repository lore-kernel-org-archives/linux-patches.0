Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B300A3FFAA2;
	Tue, 28 Apr 2026 10:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372940; cv=none; b=l/SVGjE07laaGYXRIrHBY3JsPyXHvRuijfg32tX7D1RC+HvjN+gMAN3TkmRlhfKxyBgGlbw79RGEApSBA0Bq9XBjgUghCI8bZsSLfFK77d2WRhQ1lvvs0Pt99Lzo95UfTG/+k0gP+UVlzhhgs6N9ZDS8GGkH2hu+AVjbOFA0kIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372940; c=relaxed/simple;
	bh=mH1G/KvtfkdJy2QETS04LHXi6qAjjxxK16T9wR1DqXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IAOtQBk/ke2AwiMErZKNJ3cfAoupEA0xNfa1lq6JLHsjAGP2e32Hc9y9mvynLrZAzb6YV1akJjdYa581poFVHK/miUxGBrIa/92AM7CSNu5KlBYGZEW+X1JpVjrbo4ZjYb6x/s3fLK4gsj3EoZ8CmHAjUTKgMZg9FZQP7lFyPTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JNyx+WIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JNyx+WIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CBDC4AF09;
	Tue, 28 Apr 2026 10:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372940;
	bh=mH1G/KvtfkdJy2QETS04LHXi6qAjjxxK16T9wR1DqXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNyx+WIQn9u7wGQGZ1FiHbBXABMh7vteWvUTClTcPMI9I6XB3CsyBMbZyJIVin86V
	 w1AdKIBpQNi4ZznXZnfG1vIPQnQIrq5pkrz1LPf++xHIBXb2hiE/Dd6zc/scjZF4oG
	 lTk1BxXF+occeIB+s3YGO5R/eXnrEEmEB0Ah/LDsLe2GvJpkVmGQMDHGjYTf/LHht1
	 M2Aa86rPYgWSbwn0ZgnJBa9I87QNpcbmyoz9nPGLBFWZnPBAUfojRV/eyYtLxh6hXD
	 hafpqZmIeoqFTuwx/EU5o6Y8yG3/ws2VPJM6StjGRRtGIJ++xJPieC2TlNu/MhyzdR
	 C2N/vxRoXBc+A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zizhi Wo <wozizhi@huawei.com>,
	Zizhi Wo <wozizhi@huaweicloud.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	viro@zeniv.linux.org.uk,
	bcrl@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-aio@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] fs: aio: reject partial mremap to avoid Null-pointer-dereference error
Date: Tue, 28 Apr 2026 06:40:44 -0400
Message-ID: <20260428104133.2858589-33-sashal@kernel.org>
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

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 3adf7ae18bf42601246031002287c103a27df307 ]

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
...
Crash analysis showed the file involved was an AIO ring file. The
phenomenon triggered is the same as the issue described in [1].

[CAUSE]
Consider the following scenario: userspace sets up an AIO context via
io_setup(), which creates a VMA covering the entire ring buffer. Then
userspace calls mremap() with the AIO ring address as the source, a smaller
old_len (less than the full ring size), MREMAP_MAYMOVE set, and without
MREMAP_DONTUNMAP. The kernel will relocate the requested portion to a new
destination address.

During this move, __split_vma() splits the original AIO ring VMA. The
requested portion is unmapped from the source and re-established at the
destination, while the remainder stays at the original source address as
an orphan VMA. The aio_ring_mremap() callback fires on the new destination
VMA, updating ctx->mmap_base to the destination address. But the callback
is unaware that only a partial region was moved and that an orphan VMA
still exists at the source:

  source(AIO):
  +-------------------+---------------------+
  |  moved to dest    |  orphan VMA (AIO)   |
  +-------------------+---------------------+
  A                 A+partial_len        A+ctx->mmap_size

  dest:
  +-------------------+
  |  moved VMA (AIO)  |
  +-------------------+
  B                 B+partial_len

Later, io_destroy() calls vm_munmap(ctx->mmap_base, ctx->mmap_size), which
unmaps the destination. This not only fails to unmap the orphan VMA at the
source, but also overshoots the destination VMA and may unmap unrelated
mappings adjacent to it! After put_aio_ring_file() calls truncate_setsize()
to remove all pages from the pagecache, any subsequent access to the orphan
VMA triggers filemap_fault(), which calls a_ops->read_folio(). Since aio
does not implement read_folio, this results in a NULL pointer dereference.

[FIX]
Note that expanding mremap (new_len > old_len) is already rejected because
AIO ring VMAs are created with VM_DONTEXPAND. The only problematic case is
a partial move where "old_len == new_len" but both are smaller than the
full ring size.

Fix this by checking in aio_ring_mremap() that the new VMA covers the
entire ring. This ensures the AIO ring is always moved as a whole,
preventing orphan VMAs and the subsequent crash.

[1]: https://lore.kernel.org/all/20260413010814.548568-1-wozizhi@huawei.com/

Signed-off-by: Zizhi Wo <wozizhi@huaweicloud.com>
Link: https://patch.msgid.link/20260418060634.3713620-1-wozizhi@huaweicloud.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information I need. Let me provide my analysis.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 - Subject line parse**
- Record: Subsystem `fs: aio:`, verb "reject" (defensive fix), summary:
  reject partial mremap on the AIO ring VMA to avoid a NULL-pointer
  dereference.

**Step 1.2 - Tags**
- Record:
  - `Signed-off-by: Zizhi Wo <wozizhi@huaweicloud.com>` (author)
  - `Link: https://patch.msgid.link/20260418060634.3713620-1-
    wozizhi@huaweicloud.com`
  - `Reviewed-by: Jan Kara <jack@suse.cz>` (well-known VFS/FS reviewer)
  - `Signed-off-by: Christian Brauner <brauner@kernel.org>` (VFS
    maintainer, applied to vfs.fixes)
  - No `Fixes:` tag, no `Cc: stable`, no syzbot `Reported-by`. Commit
    message mentions "our internal syzkaller testing" so it is a fuzzer-
    found, reproducible bug even though it is not on the public syzbot
    instance.
  - Mentions related issue `[1]: https://lore.kernel.org/all/20260413010
    814.548568-1-wozizhi@huawei.com/` — the earlier NULL-deref fix in
    this series (commit `c03ce4173c7bf` using `VMA_DONTCOPY_BIT` for the
    fork-after-io_setup() variant).

**Step 1.3 - Body analysis**
- Record: Bug is a NULL pointer dereference caused by `filemap_fault()`
  calling `a_ops->read_folio` (NULL for AIO ring mapping). The root
  cause is that `mremap()` can partially move an AIO ring VMA (when
  `old_len == new_len` but smaller than the full ring), splitting it
  into a moved destination VMA + an orphan source VMA.
  `aio_ring_mremap()` blindly updates `ctx->mmap_base` to the
  destination, leaving the orphan untracked. Later `io_destroy()` calls
  `vm_munmap(ctx->mmap_base, ctx->mmap_size)` which (a) fails to unmap
  the orphan, and (b) overshoots the destination VMA, possibly unmapping
  adjacent user mappings. The orphan survives
  `put_aio_ring_file()`/`truncate_setsize()`, then any access faults
  into `filemap_fault` → `read_folio` (NULL) → kernel oops. Failure mode
  is a kernel NULL-deref oops, plus potential silent unmap of unrelated
  user mappings.

**Step 1.4 - Hidden fix detection**
- Record: Not disguised — the commit is explicitly framed as a fix for a
  NULL pointer dereference crash. The "reject" verb and BUG/CAUSE/FIX
  structure make it a clear bug fix.

## PHASE 2: DIFF ANALYSIS

**Step 2.1 - Inventory**
- Record: Single file `fs/aio.c`, +2/-1, a single hunk inside
  `aio_ring_mremap()`. Scope classification: minimal single-file
  surgical fix.

**Step 2.2 - Code flow change**
- Record: Before:

```354:384:fs/aio.c
static int aio_ring_mremap(struct vm_area_struct *vma)
{
        ...
        for (i = 0; i < table->nr; i++) {
                struct kioctx *ctx;

                ctx = rcu_dereference(table->table[i]);
                if (ctx && ctx->aio_ring_file == file) {
                        if (!atomic_read(&ctx->dead)) {
                                ctx->user_id = ctx->mmap_base =
vma->vm_start;
                                res = 0;
                        }
                        break;
                }
        }
        ...
}
```

  After, the inner `if` now also requires `ctx->mmap_size ==
(vma->vm_end - vma->vm_start)`. When that condition fails, `res` stays
`-EINVAL` which is returned to the mremap path. `move_vma()`
(mm/mremap.c) then reverts the page-table move and returns an error to
userspace.

**Step 2.3 - Bug mechanism**
- Record: Category (g) correctness / missing validation in an mmap
  callback. Mechanism: `aio_ring_mremap()` accepted a post-split
  destination VMA smaller than `ctx->mmap_size` and silently updated
  `ctx->mmap_base`, desynchronizing the AIO bookkeeping from VMA
  reality. The fix adds a size check so the AIO ring can only be
  remapped as a whole.

**Step 2.4 - Fix quality**
- Record: The fix is obviously correct. It preserves the existing error-
  path semantics (`-EINVAL`), and `move_vma()` already has the revert
  path that relies on ->mremap returning an error (verified in
  `mm/mremap.c:1215-1232`). Because `move_vma()` undoes the page-table
  move on error and completes the unmap of the new VMA, the user sees a
  normal mremap failure. No deadlock or new locking is introduced. Zero
  regression risk for any user who is not currently intentionally
  partially-remapping an AIO ring (and any such caller was already
  setting themselves up for a crash).

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 - Blame**
- Record: `git blame` on the changed lines shows the `if
  (!atomic_read(&ctx->dead))` block was added by `b2edffdd912b4` (Al
  Viro, Apr 2015, "fix mremap() vs. ioctx_kill() race"), and
  `aio_ring_mremap()` itself was introduced by `e4a0d3e720e7e` (Pavel
  Emelyanov, Sep 2014, "aio: Make it possible to remap aio ring", first
  released in v3.19). The buggy omission (no ring-size check) has
  existed since the callback was introduced — more than 10 years.
  Present in every currently-supported stable tree.

**Step 3.2 - Fixes: tag**
- Record: No `Fixes:` tag is present. Logically the original bug source
  is `e4a0d3e720e7e` (the callback introduction). That commit is in all
  stable trees (v3.19+).

**Step 3.3 - File history**
- Record: The parent commits `c03ce4173c7bf` ("fs: aio: set
  VMA_DONTCOPY_BIT…") and `3833d335d7be8` ("aio: Stop using
  i_private_data…") are newer aio changes. The fork-variant fix
  `c03ce4173c7bf` (April 13) and this mremap-variant fix (April 18) form
  a closely related 2-piece series addressing AIO-ring NULL deref
  scenarios. This patch is standalone and does NOT depend on
  `c03ce4173c7bf` — each fix targets a distinct scenario (fork vs.
  mremap). The prior analogous precedent is `81e9d6f864765` ("aio: fix
  mremap after fork null-deref", Jan 2023), which was explicitly `Cc:
  stable` and backported. It was itself a NULL-deref fix in the same
  `aio_ring_mremap()` function.

**Step 3.4 - Author**
- Record: Zizhi Wo (Huawei) is a frequent, experienced fs-subsystem
  contributor (cachefiles NULL-deref fixes, ext4, xfs, netfs/fscache).
  Reviewed-by Jan Kara is a top-tier VFS maintainer. Signed-off-by
  Christian Brauner (VFS maintainer) applied it to `vfs.fixes`. The
  chain of trust is strong.

**Step 3.5 - Dependencies**
- Record: Standalone fix. The only fields it depends on
  (`ctx->mmap_size`, `vma->vm_start`, `vma->vm_end`, `ctx->dead`) exist
  unchanged in every stable branch checked
  (5.10/5.15/6.1/6.6/6.12/6.17/6.18/6.19). No prerequisite commit
  needed.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 - Original submission**
- Record: `b4 dig -c 3adf7ae18bf42` → https://patch.msgid.link/202604180
  60634.3713620-1-wozizhi@huaweicloud.com ; `b4 dig -a` shows only v1 —
  applied as-is, no rework or NAK.

**Step 4.2 - Reviewers**
- Record: `b4 dig -w` shows the patch was addressed to Al Viro, Jan
  Kara, Christian Brauner, Benjamin LaHaise (aio maintainer), Jens
  Axboe, linux-fsdevel, linux-aio, linux-kernel — all appropriate
  maintainers and lists. Jan Kara replied with `Reviewed-by`. Christian
  Brauner applied it to `vfs.fixes`.

**Step 4.3 - Bug report**
- Record: Internal Huawei syzkaller testing uncovered the issue. Stack
  trace provided (`filemap_read_folio → filemap_fault → __do_fault →
  do_pte_missing → __handle_mm_fault`). Same symptom family as the
  earlier `[1]` thread. No external public bugzilla or syzbot URL.

**Step 4.4 - Series context**
- Record: There is a logical 2-piece "AIO ring NULL-deref" pair: (i)
  fork-related `c03ce4173c7bf` VMA_DONTCOPY fix, (ii) this mremap-
  related fix. They are independent; either may be applied without the
  other. Both were reviewed by Jan Kara and applied by Christian
  Brauner.

**Step 4.5 - Stable mailing list**
- Record: Could not fetch lore.kernel.org directly (Anubis anti-bot
  challenge). No `Cc: stable` was placed on the original posting;
  reviewer did not explicitly request stable. However, the substantially
  similar earlier fix `81e9d6f864765` had `Cc: stable@vger.kernel.org`
  and was backported.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 - Functions**
- Record: The only function touched is `aio_ring_mremap()` (a
  `vm_operations_struct.mremap` callback).

**Step 5.2 - Callers**
- Record: Called from `move_vma()` in `mm/mremap.c` (line 1216: `err =
  vma->vm_ops->mremap(new_vma);`). That is invoked from the `mremap(2)`
  syscall path. Directly reachable from an unprivileged user's
  `mremap()` syscall on any AIO ring they have mapped — i.e., high
  reachability.

**Step 5.3 - Callees**
- Record: The function only reads `ctx->dead`, `ctx->aio_ring_file`, and
  now `ctx->mmap_size`, plus writes `ctx->user_id` and `ctx->mmap_base`.
  No new allocations, no locks, no RCU changes introduced. The new check
  is pure arithmetic.

**Step 5.4 - Call chain reachability**
- Record: The bug is reachable from userspace via an ordinary
  `io_setup()` + `mremap(addr, old_len, new_len=old_len, MREMAP_MAYMOVE,
  new_addr)` with `old_len < ctx->mmap_size`. No privileges required.
  This is clearly user-triggerable DoS / potential corruption of
  adjacent mappings.

**Step 5.5 - Similar patterns**
- Record: The earlier `81e9d6f864765` fix and `c03ce4173c7bf` DONTCOPY
  fix address sibling NULL-deref scenarios in the same AIO-ring file-
  backed mapping. The pattern of the AIO ring being fragile when VMA
  bookkeeping diverges from kioctx bookkeeping is well-established; each
  leak has been plugged over the years.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1 - Code in stable?**
- Record: Verified across `stable-
  push/linux-{5.10,5.15,6.1,6.6,6.12,6.17,6.18,6.19}.y`. In every
  branch, `aio_ring_mremap()` contains the identical pre-patch block:

```text
if (ctx && ctx->aio_ring_file == file) {
    if (!atomic_read(&ctx->dead)) {
        ctx->user_id = ctx->mmap_base = vma->vm_start;
```

  The `ctx->mmap_size` field also exists unchanged in all these
branches.

**Step 6.2 - Backport complications**
- Record: Patch should apply cleanly or with trivial offset-only fuzzing
  on every active stable tree (5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y,
  6.17.y, 6.18.y, 6.19.y). The two-line addition uses only pre-existing
  struct fields and a pre-existing `vma` argument. No adjustment needed.

**Step 6.3 - Related fixes already in stable?**
- Record: Prior `81e9d6f864765` (mremap after fork null-deref) is
  already in stable; this is a complementary fix for a different mremap
  scenario.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 - Subsystem criticality**
- Record: `fs/aio.c` is the kernel AIO implementation — used by libaio,
  databases (MySQL/MariaDB/PostgreSQL via libaio), storage benchmarks,
  and many userspace libraries. Criticality: IMPORTANT (widely used core
  fs/IO code, affects many servers and containers).

**Step 7.2 - Subsystem activity**
- Record: Active — several recent commits (credential guards,
  `i_private_data` removal, alloc conversions). The aio_ring_mremap area
  itself sees occasional fix traffic (roughly one fix every few years)
  whenever a new VMA-manipulation edge case is discovered.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 - Affected users**
- Record: Any user running a kernel where a local unprivileged user can
  perform `io_setup()` + `mremap()`. That is essentially every Linux
  system. AIO is enabled by default in every distro kernel.

**Step 8.2 - Trigger conditions**
- Record: Unprivileged user calls `io_setup()`; then calls `mremap(addr,
  old_len, new_len, MREMAP_MAYMOVE, new_addr)` where `old_len ==
  new_len` and `old_len < ctx->mmap_size`. No hardware or race needed —
  deterministic. Internal syzkaller reproduced it.

**Step 8.3 - Failure mode severity**
- Record: CRITICAL. Two distinct bad outcomes:
  1. Kernel NULL-pointer dereference oops (system crash / availability
     loss).
  2. `vm_munmap(ctx->mmap_base, ctx->mmap_size)` overshoot can unmap
     *unrelated user mappings* adjacent to the destination VMA — i.e.,
     memory corruption of an unprivileged user's other mappings,
     reachable without privileges. This is a local DoS / potentially
     security-relevant issue.

**Step 8.4 - Risk-benefit**
- Record:
  - Benefit: prevents kernel NULL-deref oops and prevents unrelated mmap
    regions from being silently torn down, both triggerable by
    unprivileged userspace. Very high benefit.
  - Risk: two lines, pure size check, pre-existing `-EINVAL` error path
    already exercised in normal failure cases, no new locks, no ABI
    change. `move_vma()` already handles ->mremap returning an error by
    reverting. Very low risk.
  - Ratio: strongly favorable.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 - Evidence**
- For backport:
  - Fixes a deterministic, unprivileged-triggerable kernel NULL-pointer
    dereference (KASAN/BUG).
  - Also fixes a potential silent tear-down of unrelated user mappings
    by `vm_munmap()` overshoot.
  - Bug exists since v3.19 (2014) — present in every active stable tree.
  - Fix is 2 lines in a single function, obviously correct, with an
    existing error-revert path already in place.
  - Found via (internal) syzkaller — concrete, reproducible.
  - Reviewed by a top VFS maintainer (Jan Kara) and applied by VFS
    maintainer (Christian Brauner).
  - Author has a solid track record of filesystem bug fixes.
  - Prior analogous NULL-deref fix in the same function
    (`81e9d6f864765`) was `Cc: stable` and backported.
  - Applies cleanly to every active stable branch (verified by reading
    each branch's `aio_ring_mremap`).
- Against backport:
  - No `Cc: stable` tag (but the question brief explicitly says this is
    not a negative signal).
  - No `Fixes:` tag (same caveat).
  - No public syzbot ID; only "internal syzkaller".
  - None of these are technical objections.
- Unresolved:
  - UNVERIFIED: Could not fetch lore.kernel.org discussion pages
    directly (Anubis) to confirm no follow-up concerns; the saved mbox
    thread shows only Jan Kara's `Reviewed-by` and Christian Brauner's
    "Applied to vfs.fixes" — no objections captured there.

**Step 9.2 - Stable rules**
1. Obviously correct and tested? YES — reviewed and applied by
   maintainers; found by fuzzing; logic trivial.
2. Real bug, users affected? YES — unprivileged userspace can crash the
   kernel.
3. Important issue (crash/security/corruption/deadlock)? YES — NULL-
   deref oops + potential unmap of unrelated mappings.
4. Small and contained? YES — 2 lines, one function.
5. No new features/APIs? YES — pure validation.
6. Applies to stable? YES — verified structurally for
   5.10/5.15/6.1/6.6/6.12/6.17/6.18/6.19.

**Step 9.3 - Exceptions**
- Not a device-ID/quirk/DT/build/doc fix, but it squarely meets the core
  stable criteria on its own merits.

**Step 9.4 - Decision**
- All criteria for stable inclusion are met. The fix is minimal,
  surgical, addresses an unprivileged-triggerable kernel crash path that
  has existed since 2014, and has been vetted by appropriate
  maintainers. Backport.

## Verification

- [Phase 1] `git show 3adf7ae18bf42` — extracted all tags: Signed-off-
  by, Link, Reviewed-by (Jan Kara), Signed-off-by (Christian Brauner).
  No Fixes:, no Cc: stable, no syzbot Reported-by.
- [Phase 2] Read `fs/aio.c` lines 354–393 — confirmed single hunk, 2
  adds / 1 change; the new condition is `ctx->mmap_size == (vma->vm_end
  - vma->vm_start)`.
- [Phase 2] Read `mm/mremap.c` lines 1215–1232 — confirmed that when
  `vm_ops->mremap` returns an error, `move_vma()` reverts the page-table
  move, so returning `-EINVAL` is a safe abort.
- [Phase 2] Read `mm/mremap.c` lines 1700–1741 — confirmed
  MREMAP_DONTUNMAP is blocked by VM_DONTEXPAND and expansion is blocked
  by VM_DONTEXPAND, so only the "partial move with old_len == new_len"
  case reaches aio_ring_mremap, matching the commit message.
- [Phase 3] `git blame -L 365,380 fs/aio.c` — confirmed introduction
  lineage: e4a0d3e720e7e (2014, v3.19) for the callback, b2edffdd912b4
  (2015) for the `dead` check.
- [Phase 3] `git describe --contains e4a0d3e720e7e5` →
  `v3.19-rc1~83^2~1` — bug exists since v3.19.
- [Phase 3] `git show 81e9d6f8647650` — confirmed prior similar NULL-
  deref fix in same function was `Cc: stable@vger.kernel.org`.
- [Phase 3] `git log --oneline 3adf7ae18bf42~5..3adf7ae18bf42` —
  confirmed the related commit c03ce4173c7bf is the sibling fix from the
  same author, independent of this one.
- [Phase 4] `b4 dig -c 3adf7ae18bf42` → https://patch.msgid.link/2026041
  8060634.3713620-1-wozizhi@huaweicloud.com ; `b4 dig -a` shows v1 only.
- [Phase 4] `b4 dig -c 3adf7ae18bf42 -w` — confirmed To: Viro, Jan Kara,
  Christian Brauner, Benjamin LaHaise (aio maintainer), Jens Axboe; Cc:
  linux-fsdevel, linux-aio, linux-kernel.
- [Phase 4] Saved thread mbox and read it — Jan Kara's Reviewed-by;
  Christian Brauner's "Applied to vfs.fixes". No objections or follow-
  ups.
- [Phase 5] Grep for callers of `aio_ring_mremap` — reached via
  `vm_ops->mremap(new_vma)` in `mm/mremap.c:1216`, i.e., the `mremap(2)`
  syscall. Unprivileged userspace reach confirmed.
- [Phase 6] `git show stable-
  push/linux-{5.10,5.15,6.1,6.6,6.12,6.17,6.18,6.19}.y:fs/aio.c` —
  confirmed the identical pre-patch `aio_ring_mremap()` block in every
  active stable tree; `ctx->mmap_size` field exists in each.
- [Phase 6] Verified VM_DONTEXPAND is still applied to the AIO ring VMA
  in every stable branch, so the commit's premise (only the partial-move
  case matters) also holds in stable.
- [Phase 7] File path `fs/aio.c` → IMPORTANT subsystem (AIO, widely used
  by userspace libaio).
- [Phase 8] Trigger analysis via commit message + mremap.c read →
  unprivileged deterministic trigger.
- UNVERIFIED: Could not fetch live lore.kernel.org HTML (Anubis anti-
  bot); relied on the mbox that b4 already retrieved, which did not show
  any objections.
- UNVERIFIED: Did not independently execute the syzkaller reproducer;
  relied on author's description plus maintainer review.

The fix is small, surgical, reviewed by a VFS maintainer, and addresses
an unprivileged-triggerable NULL-pointer dereference that also risks
silent unmap of unrelated user mappings. The buggy code is present,
identically, in every active stable tree going back to 5.10, and the
patch applies trivially. All stable-kernel-rules criteria are met.

**YES**

 fs/aio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 6d436f8b3f349..b8a163d90bfaf 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -369,7 +369,8 @@ static int aio_ring_mremap(struct vm_area_struct *vma)
 
 		ctx = rcu_dereference(table->table[i]);
 		if (ctx && ctx->aio_ring_file == file) {
-			if (!atomic_read(&ctx->dead)) {
+			if (!atomic_read(&ctx->dead) &&
+			    (ctx->mmap_size == (vma->vm_end - vma->vm_start))) {
 				ctx->user_id = ctx->mmap_base = vma->vm_start;
 				res = 0;
 			}
-- 
2.53.0

