Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060823A7F71;
	Mon, 20 Apr 2026 13:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690974; cv=none; b=Ce2V6tM81wKbNqARrRSW9LrTcN0aKtvL4vJxLWIiwgOIgy6T07kTWsAZm+sSRfIm5UbafdjZ3D2jjSj0URjCJ+1KA4ljRUrpWYmDCgTBwhwOWq3bnqMWdox/IAm8VTaCyjsJzLGpvbgagC75j384RzB5y4q3cRxRUxZJugj4S+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690974; c=relaxed/simple;
	bh=7wvmA6qzUSdsbGyXey2C/opKsngNLL4M7rqpkTGQq4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HnV9yJjNKAOnLClpOvqzUH96E+/bVCOQWTczYb32fYMNB5M1DbdCRzJ90BK7KoIQ7stHwquYY3mxkt8c/ZtSBQTKm7tlMPTWqtEIlmEAogp5qDc42A7/9io2P6MhTayMDVza/HUsNTkU/O4gVi2N6VA0oX+UeNI/YbW1XfDyxLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P202Hfgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P202Hfgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6081C2BCB8;
	Mon, 20 Apr 2026 13:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690973;
	bh=7wvmA6qzUSdsbGyXey2C/opKsngNLL4M7rqpkTGQq4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P202HfgzOZh94o+7xvRkrmpaifNaWcPgdoiEJ5xD80cRblwzgJrneHbJwsh1JYy1U
	 8wQZvvjvjBuOGa8Ks/uSYKwqVxtl6G9UwwhRq0ywyVqY7/88r5PL7AiceLdkbsaWIh
	 oeeP4/l6EfUdKgD02dR2vWBc1z6bh6VUNjL4sO+Pcs04crTrhQkCABxRTiTbs//Xpa
	 RM3PJ7CNAZ1DdzjwkyA19uX9bNJ3KR+IIl+NJvkS7lB+HT5H+qZLOYlV6B6vfC8f7z
	 gWCeMKPJEQtuy5DV8WOTabrOCRhgZ4Oe89q/LiHw/PpPw1RHQad18aEuX1NFc9RPnE
	 Y+xEQ1GKACTig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>,
	devel@lists.orangefs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] orangefs: add usercopy whitelist to orangefs_op_cache
Date: Mon, 20 Apr 2026 09:08:06 -0400
Message-ID: <20260420131539.986432-20-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
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

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit f855f4ab123b2b9c93465288c03fbb07a5903bb3 ]

orangefs_op_cache is created with kmem_cache_create(), which provides
no usercopy whitelist. orangefs_devreq_read() copies the tag and upcall
fields directly from slab objects to userspace via copy_to_user(). With
CONFIG_HARDENED_USERCOPY enabled, this triggers usercopy_abort().

Switch to kmem_cache_create_usercopy() with a whitelist covering the
tag and upcall fields, matching the pattern already used by
orangefs_inode_cache in super.c.

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to write up the complete analysis.

## Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 - Subject line parsing:**
Record: subsystem = `orangefs`, action verb = `add`, summary = "adds a
usercopy whitelist to the orangefs_op_cache slab so that copy_to_user()
from cache objects does not trigger the hardened-usercopy check."

**Step 1.2 - Tags:**
- Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu> (author)
- Signed-off-by: Mike Marshall <hubcap@omnibond.com> (orangefs
  maintainer)
- No Fixes:, no Cc: stable, no Reported-by:, no Reviewed-by:, no Tested-
  by:, no Link:
Record: Minimal tag set. Maintainer SOB present (Mike Marshall maintains
fs/orangefs/).

**Step 1.3 - Body analysis:**
Record: Claims that `orangefs_devreq_read()` performs `copy_to_user()`
on fields inside a slab-allocated `orangefs_kernel_op_s`. Because the
cache was created without a usercopy whitelist, the hardened-usercopy
check rejects the copy and calls `usercopy_abort()` (which `BUG()`s).
Fix: switch to `kmem_cache_create_usercopy()` with a whitelist that
spans from `tag` through end of `upcall`.

**Step 1.4 - Hidden bug fix detection:**
Record: Although the subject uses "add" not "fix", the body explicitly
says "this triggers usercopy_abort()" - this is clearly a bug fix
against a kernel panic, not a feature addition.

### PHASE 2: DIFF ANALYSIS

**Step 2.1 - Inventory:**
Record: 1 file, `fs/orangefs/orangefs-cache.c`, +5/-1 lines. Modifies
only `op_cache_initialize()`. Single-file surgical fix.

**Step 2.2 - Code flow change:**
Record: Before: `op_cache = kmem_cache_create(...)` - cache has
useroffset=0, usersize=0 (non-usercopy). After: `op_cache =
kmem_cache_create_usercopy(..., useroffset=offsetof(tag),
usersize=offsetof(upcall)+sizeof(upcall)-offsetof(tag), ...)`. The
whitelist starts at `tag` and extends through the end of `upcall`.

**Step 2.3 - Bug mechanism:**
Record: Hardware/runtime safety fix - slab usercopy whitelist.
`orangefs_devreq_read()` (fs/orangefs/devorangefs-req.c lines 287-294)
does two `copy_to_user()` calls from `cur_op` (slab object):
1. `&cur_op->tag`, size `sizeof(__u64)`
2. `&cur_op->upcall`, size `sizeof(struct orangefs_upcall_s)`

Without whitelist, `__check_heap_object()` in mm/slub.c compares offset
against `s->useroffset`/`s->usersize` (both 0 here) and fails →
`usercopy_abort()` → `BUG()`. The new whitelist covers both copies (tag
at offsetof(tag), upcall at offsetof(upcall); whitelist spans
`[offsetof(tag), offsetof(upcall)+sizeof(upcall))`).

**Step 2.4 - Fix quality:**
Record: Obviously correct - mirrors the pre-existing pattern for
`orangefs_inode_cache` in `fs/orangefs/super.c:642` (commit
6b330623e5690). Tiny scope. Only concern: added lines use mixed
tabs+space indentation (5 tabs + space) that is inconsistent with
existing 4-tab alignment; purely cosmetic, no functional impact. No
regression risk from the change itself - `kmem_cache_create_usercopy()`
is the explicit API for this case, established since v4.16.

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 - Blame:**
Record: The buggy `kmem_cache_create()` for `op_cache` dates back to
575e946125f70 ("Orangefs: change pvfs2 filenames to orangefs", v4.6-rc1,
Dec 2015) when the file was renamed; the code pattern has been present
since OrangeFS was first merged into the kernel in v4.6. Bug exists in
all stable trees.

**Step 3.2 - Fixes: tag:**
Record: No Fixes: tag in the patch. However, by analogy with
2a71a1a8d0ed7 (net sock hardened usercopy panic, Dec 2025), the root
cause trace is 6d07d1cd300f ("usercopy: Restrict non-usercopy caches to
size 0", v4.16-rc1, 2018) - this changed the default usercopy region to
0, making caches without a whitelist reject all copies. Strict
enforcement (no fallback) came with 53944f171a89d ("mm: remove
HARDENED_USERCOPY_FALLBACK", v5.16-rc1). Both exist in all currently
supported stable trees.

**Step 3.3 - File history:**
Record: `fs/orangefs/orangefs-cache.c` has been very quiet: last change
before this was 3635d000f04b7 ("fs/orangefs: remove
ORANGEFS_CACHE_CREATE_FLAGS", in v6.12) - this replaced the
`ORANGEFS_CACHE_CREATE_FLAGS` argument with `0`. In stable trees ≤6.6,
the `flags` argument is `ORANGEFS_CACHE_CREATE_FLAGS`, so a tiny
backport adjustment is needed there. Standalone patch, not part of a
series.

**Step 3.4 - Author context:**
Record: Ziyi Guo has no prior orangefs commits in the repo. Mike
Marshall is the orangefs subsystem maintainer (per MAINTAINERS) and
added his SOB, indicating maintainer acceptance.

**Step 3.5 - Dependencies:**
Record: None. `kmem_cache_create_usercopy()` has existed since v4.16
(2db51b1a3e ~). `offsetof()` and the struct layout exist unchanged in
all stable trees.

### PHASE 4: MAILING LIST RESEARCH

**Step 4.1 - b4 dig:**
Record: b4 dig found the original submission at https://lore.kernel.org/
all/20260212020806.2522161-1-n7l8m4@u.northwestern.edu/. Only one
revision (v1); no later iterations.

**Step 4.2 - Reviewers:**
Record: CCed: Mike Marshall (maintainer), Martin Brandenburg (co-
maintainer), devel@lists.orangefs.org, linux-kernel. Saved thread has
only the submission email - no visible public review response, but Mike
Marshall added his SOB which indicates maintainer acceptance.
(lore.kernel.org is behind Anubis bot-protection so could not
independently fetch web thread view; mbox download via b4 dig succeeded
and showed only the patch.)

**Step 4.3 - Bug report:**
Record: No Reported-by or Link: tag. No external bug report referenced.

**Step 4.4 - Related patches:**
Record: Single-patch submission. Strong analog exists: 43e7e284fc77b
("cifs: Fix the smbd_response slab to allow usercopy", 2025) and
2a71a1a8d0ed7 ("net: sock: fix hardened usercopy panic in
sock_recv_errqueue", Dec 2025) both fix the same class of hardened-
usercopy BUG() in other subsystems. The CIFS fix was already backported
(present in `stable-push/linux-6.12.y`).

**Step 4.5 - Stable ML:**
Record: Not searched further because lore.kernel.org is protected by
bot-challenge. UNVERIFIED: No independent evidence of prior stable
discussion.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 - Key functions:**
Record: `op_cache_initialize()` (one-time init at module load).

**Step 5.2 - Callers of affected code:**
Record: `op_cache_initialize()` is called from `orangefs_init()` in
`fs/orangefs/orangefs-mod.c` at module init. `op_cache` itself is used
by `op_alloc()` (allocates every upcall op) and `op_release()` (frees
them). Used on every VFS operation that requires communication with the
userspace daemon.

**Step 5.3 - Callees:**
Record: `kmem_cache_create_usercopy()` - core slab API, present since
v4.16.

**Step 5.4 - Reachability:**
Record: Bug is trigger path is `orangefs_devreq_read()` at
fs/orangefs/devorangefs-req.c:287-294. Reachable from userspace `read()`
syscall on `/dev/pvfs2-req` by the pvfs2-client-core daemon on every
orangefs upcall (every VFS op → every file/dir access). With
CONFIG_HARDENED_USERCOPY=y and no fallback (v5.16+), the very first read
after mounting orangefs BUG()s the kernel.

**Step 5.5 - Similar patterns:**
Record: `orangefs_inode_cache` in `fs/orangefs/super.c:642` uses the
same `kmem_cache_create_usercopy()` pattern (commit 6b330623e5690,
v4.16). This patch completes what was an incomplete conversion -
`op_cache` was overlooked in the original 2017 work.

### PHASE 6: CROSS-REFERENCING STABLE

**Step 6.1 - Bug in stable trees:**
Record: Verified the buggy `op_cache = kmem_cache_create(...)` line is
present in `stable-push/linux-5.10.y`, `linux-5.15.y`, `linux-6.1.y`,
`linux-6.6.y`, `linux-6.12.y`, `linux-6.17.y`, `linux-6.18.y`,
`linux-6.19.y` via `git show <branch>:fs/orangefs/orangefs-cache.c`.
Hard-panic semantics active on v5.16+ stable (linux-6.1, 6.6, 6.12,
6.17, 6.18, 6.19). On 5.10/5.15, the old fallback would emit a warning
instead of BUG() - less severe but still undesirable.

**Step 6.2 - Backport complications:**
Record: For stable trees ≤6.6, the `flags` parameter is
`ORANGEFS_CACHE_CREATE_FLAGS` instead of `0` - trivial one-word
adjustment. File has seen minimal churn since v4.6. Expected apply:
6.12+ = nearly clean; ≤6.6 = tiny context adjustment.

**Step 6.3 - Related fixes in stable:**
Record: No orangefs-specific usercopy fix already in stable. Related
precedent: `43e7e284fc77b` ("cifs: Fix the smbd_response slab to allow
usercopy") is in `stable-push/linux-6.12.y` as 87dcc7e33fc3d -
confirming this class of fix is accepted in stable.

### PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1 - Criticality:**
Record: `fs/orangefs/` - filesystem driver. PERIPHERAL criticality
(niche distributed filesystem used mostly in HPC). However, any user who
does use it is guaranteed to hit this on a hardened kernel.

**Step 7.2 - Activity:**
Record: Low-activity subsystem with a responsive maintainer (Mike
Marshall). The file `orangefs-cache.c` itself is essentially frozen
(last change in v6.12 was cosmetic).

### PHASE 8: IMPACT / RISK

**Step 8.1 - Affected users:**
Record: Anyone running orangefs on a kernel with
`CONFIG_HARDENED_USERCOPY=y` (default in many distros) on v5.16+.
Affects everyone using orangefs on those kernels.

**Step 8.2 - Trigger conditions:**
Record: Unconditional - triggered on the very first read() from
`/dev/pvfs2-req` after orangefs mounts and the client daemon starts.
This happens at every orangefs mount. No privilege required beyond
what's already needed to run pvfs2-client-core (typically root). The bug
is 100% reproducible on affected kernels.

**Step 8.3 - Failure mode severity:**
Record: `usercopy_abort()` → `BUG()` → kernel panic on filesystem
mount/use. CRITICAL.

**Step 8.4 - Risk/benefit:**
Record: BENEFIT = High for orangefs users on hardened kernels (unusable
otherwise); zero impact for everyone else. RISK = Very low: 4 lines, API
has existed since v4.16, exact-same pattern already in same subsystem
(super.c). No chance of breaking anything because
`kmem_cache_create_usercopy()` with a non-zero whitelist only relaxes
the hardened-usercopy check on specific offsets - it cannot produce new
failures.

### PHASE 9: SYNTHESIS

**Evidence FOR backporting:**
- Fixes a kernel panic (`BUG()` from `usercopy_abort()`).
- 100% reproducible on orangefs + CONFIG_HARDENED_USERCOPY=y + kernel
  ≥5.16.
- Tiny, surgical 4-line change.
- Directly mirrors existing, established pattern in the same driver's
  super.c.
- Maintainer (Mike Marshall) has signed off.
- Matches precedent of 43e7e284fc77b (cifs) and 2a71a1a8d0ed7 (net sock)
  usercopy whitelist fixes that are stable material.
- Affected code has been in place since v4.6; bug exposure since v5.16
  removed fallback.

**Evidence AGAINST backporting:**
- No Fixes:, no Cc: stable, no Reported-by: (typical for candidate
  review - not disqualifying).
- No public reviewer feedback captured (only v1, but maintainer SOB
  present).
- Commit not yet in mainline master (currently only in `fs-next`) -
  needs to land first; this is candidate pre-review.
- OrangeFS is niche; user population is small.

**Stable rules checklist:**
1. Obviously correct and tested? - Correct yes (mirrors super.c).
   Tested: relies on author's testing; no explicit Tested-by, but very
   mechanical change.
2. Real bug? - YES, kernel panic.
3. Important? - YES, CRITICAL (panic).
4. Small/contained? - YES, +5/-1 in one function.
5. No new feature/API? - YES, purely a slab-config change.
6. Applies cleanly? - YES to ≥6.12; needs trivial flag adjustment for
   ≤6.6.

**Exception category:** Hardware/runtime quirk-equivalent for userspace
API plumbing. Fixes a panic.

## Verification

- [Phase 1] Parsed tags: verified only SOB tags present (author +
  maintainer). No Fixes:, Cc: stable, Reported-by:, Link:.
- [Phase 1] Author verification: confirmed Mike Marshall's SOB indicates
  maintainer acceptance (he is the orangefs maintainer).
- [Phase 2] Diff inspection: confirmed +5/-1 lines in single function
  `op_cache_initialize()` of `fs/orangefs/orangefs-cache.c`.
- [Phase 2] Confirmed `orangefs_devreq_read()` at
  `fs/orangefs/devorangefs-req.c:287-294` does
  `copy_to_user(&cur_op->tag, sizeof(__u64))` and
  `copy_to_user(&cur_op->upcall, sizeof(struct orangefs_upcall_s))` from
  slab memory.
- [Phase 2] Confirmed whitelist math: useroffset = offsetof(tag),
  usersize = offsetof(upcall) + sizeof(upcall) - offsetof(tag), which
  covers both copies (verified struct layout in `fs/orangefs/orangefs-
  kernel.h:109-135`).
- [Phase 2] Inspected `mm/slub.c:8044` `__check_heap_object()`:
  confirmed it calls `usercopy_abort()` (which is `__noreturn` per
  `mm/usercopy.c:86`) when offset/size fall outside
  `s->useroffset`/`s->usersize`.
- [Phase 3] git log file history: verified `op_cache =
  kmem_cache_create(...)` pattern has been there since OrangeFS was
  added. Last change 3635d000f04b7 in v6.12 removed
  ORANGEFS_CACHE_CREATE_FLAGS.
- [Phase 3] git describe 575e946125f70 → v4.6-rc1 (confirms OrangeFS
  merge window).
- [Phase 3] git describe 53944f171a89d → v5.16-rc1 (confirms when strict
  enforcement began).
- [Phase 4] `b4 dig -c f855f4ab123b2 -m /tmp/orangefs_thread.mbox`:
  found and saved the thread (lore URL: https://lore.kernel.org/all/2026
  0212020806.2522161-1-n7l8m4@u.northwestern.edu/).
- [Phase 4] `b4 dig -c ... -a`: only v1 exists.
- [Phase 4] `b4 dig -c ... -w`: Maintainer Mike Marshall and co-
  maintainer Martin Brandenburg were CCed. devel@lists.orangefs.org and
  linux-kernel were CCed.
- [Phase 4] Saved mbox: only the patch email; no public reply.
  UNVERIFIED: Cannot independently fetch web view of lore thread (Anubis
  bot-challenge blocks WebFetch).
- [Phase 4] Cross-ref: verified similar fixes 43e7e284fc77b (cifs) and
  2a71a1a8d0ed7 (net) exist and address same BUG() class.
- [Phase 5] `grep` + `Read` verified `orangefs_inode_cache` in
  `fs/orangefs/super.c:642` already uses `kmem_cache_create_usercopy()`
  - confirming the pattern is accepted.
- [Phase 5] Reachability: `orangefs_devreq_read` is reached from a
  userspace `read()` on `/dev/pvfs2-req`. Triggered on every upcall read
  by pvfs2-client-core.
- [Phase 6] `git show <branch>:fs/orangefs/orangefs-cache.c` for stable-
  push 5.10, 5.15, 6.1, 6.6, 6.12, 6.17, 6.18, 6.19: verified buggy
  `kmem_cache_create("orangefs_op_cache", ...)` is present in all of
  them.
- [Phase 6] Verified 43e7e284fc77b cifs fix was backported
  (87dcc7e33fc3d in 6.12.y) - confirms precedent.
- [Phase 7] Subsystem context: verified Mike Marshall is orangefs
  maintainer; fs/orangefs/ has low churn.
- [Phase 8] Failure mode: confirmed `usercopy_abort` is `__noreturn` →
  `BUG()` → panic. Severity CRITICAL verified.
- [Phase 9] Commit is in `fs-next` only, not yet in `master`. UNVERIFIED
  at this moment: final upstream landing SHA (will be assigned when
  Torvalds pulls).
- UNVERIFIED: No public reviewer response could be retrieved (lore
  Anubis challenge). Maintainer SOB is the primary acceptance signal.
- UNVERIFIED: No direct user bug report or Reported-by reference; impact
  assessment rests on code analysis, not a real-world crash log.

## Decision

This is a textbook stable candidate: a 4-line, obviously-correct, low-
risk change that fixes a guaranteed kernel panic on any system running
OrangeFS with `CONFIG_HARDENED_USERCOPY=y` (very common in modern
distros) on kernels ≥ v5.16. The fix mirrors the existing whitelist
already present on `orangefs_inode_cache` in the same driver, and
follows precedent of recently-backported identical-class fixes (cifs
smbd_response, net sock_recv_errqueue). Backport needs at most a trivial
`0` → `ORANGEFS_CACHE_CREATE_FLAGS` adjustment for stable ≤6.6. Benefit
clearly outweighs risk.

**YES**

 fs/orangefs/orangefs-cache.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/orangefs/orangefs-cache.c b/fs/orangefs/orangefs-cache.c
index e75e173a91862..0bdb99e897447 100644
--- a/fs/orangefs/orangefs-cache.c
+++ b/fs/orangefs/orangefs-cache.c
@@ -19,10 +19,14 @@ static struct kmem_cache *op_cache;
 
 int op_cache_initialize(void)
 {
-	op_cache = kmem_cache_create("orangefs_op_cache",
+	op_cache = kmem_cache_create_usercopy("orangefs_op_cache",
 				     sizeof(struct orangefs_kernel_op_s),
 				     0,
 				     0,
+					 offsetof(struct orangefs_kernel_op_s, tag),
+					 offsetof(struct orangefs_kernel_op_s, upcall) +
+					     sizeof(struct orangefs_upcall_s) -
+						 offsetof(struct orangefs_kernel_op_s, tag),
 				     NULL);
 
 	if (!op_cache) {
-- 
2.53.0

