Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9FF52FE30;
	Mon, 31 Aug 2026 13:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183896; cv=none; b=BTQKVB17R87+JEbTSm7iUuyOCHiwuVk/XUkFrAk4VDO+XFnE4uTuB4FOZdPoN0+0/UMLTkX1k3HPb6KYbUTfMlJdw3Z0y+S4eSC5lReInXyxgxVpkyVVnL96oP+kGil9Mae+S8QQQC9IYZ0LxTofCUhr6XILNqPrlZPtrZcc7GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183896; c=relaxed/simple;
	bh=pWVrIfQqLAccbmTRp9KFZ50pC0QRAdK48IRU5dqnAvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rbLXkD4fdxCaAyGs4vERvHgE8IjnDaD6T2XN1bAJ58KD92V0RvhgzBwRRUfSXI/HlTmg0AcHEiD33lpTmEbFlLZzzw6pF9ceV2yM0bmbPZA4FMFW/Ggla9q75Xvm61HaDa/eHkc2NpnirlnnjYTA1q1Mya0ANgND7PMA1+fXwXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SoyNZTR6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SoyNZTR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6220A1F00ACF;
	Mon, 31 Aug 2026 13:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183893;
	bh=LvMxCM6wRPBIoXKwbKzfHcKD7X2x3OPIJ+Qrdx73ImU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SoyNZTR64vnljVC5xAae8pXLnmaI4W6J1QpPuXuB10yTQVyPoZK5i46O4l5ddjmww
	 OC7RUjR0pFfATF/ALvsfjqKmwzJ85iUc8pVA33lh7baOzIOmG2bRmPHA8Nhm5KuMdM
	 93xunY3cdkfjEXQC6UkiQqZCDgNLpFmfYamSOgNX2WzeHEJAYClWa+eiV63mVup1fj
	 W2y0z97ZEbYkx6bit+yDNzCQu6jSXgocwlfa29ahmEqzGaX1S4L5nI/vTXH0Uq9+Qd
	 RJ+A+4MBgxM1dctQz0slmEYk3J6EAGRMIymkfZGORVV8SCPkriSxEcDu6N3wjt62Td
	 P/uel6YnCEmrA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	gfs2@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] dlm: add usercopy whitelist to dlm_cb cache
Date: Mon, 31 Aug 2026 09:26:34 -0400
Message-ID: <20260831133314.4125787-366-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit b5314f2c6654a3616fd72777deb1ca766cc50618 ]

The dlm_cb slab cache is created with kmem_cache_create(), which
provides no usercopy whitelist. When a callback carries LVB data,
dlm_user_add_ast() copies the LVB into the inline lvbptr[] array within
the slab-allocated struct dlm_callback and redirects ua->lksb.sb_lvbptr
to point to it. copy_result_to_user() then calls copy_to_user() with
this pointer. With CONFIG_HARDENED_USERCOPY enabled, this triggers
usercopy_abort().

Switch to kmem_cache_create_usercopy() with a whitelist covering the
lvbptr field.

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Acked-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `dlm: add usercopy whitelist to dlm_cb
cache`

**Local tree:** `v6.18.43-1-gc7f0dac02d232` (kernel version **6.18.43**)
**Upstream commit:** `b5314f2c6654a`
**Stable-prepared commit (not in HEAD):** `82278e846311c`

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[dlm]` `[add]` — Add a usercopy whitelist to the `dlm_cb`
slab cache so `copy_to_user()` from inline LVB data in slab-allocated
`struct dlm_callback` objects is permitted under
`CONFIG_HARDENED_USERCOPY`.

### Step 1.2: Parse all commit message tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** Alexander Aring `<aahringo@redhat.com>` (DLM maintainer)
- **Link:** — none
- **Cc: stable:** — none
- **Signed-off-by:** Ziyi Guo (author), Alexander Aring, David Teigland;
  ignore pipeline-added Sasha Levin SOB

Notable: maintainer Acked-by, no syzbot/fuzzer report.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** `dlm_cb` cache created with `kmem_cache_create()` has no
  usercopy whitelist. When an AST callback carries LVB data,
  `dlm_user_add_ast()` copies LVB into inline `lvbptr[]` inside a slab
  `struct dlm_callback` and repoints `ua->lksb.sb_lvbptr` to it.
  `copy_result_to_user()` then `copy_to_user()`s from that pointer.
- **Symptom:** With `CONFIG_HARDENED_USERCOPY`, this triggers
  `usercopy_abort()`.
- **Root cause:** Slab object pointer used for userspace copy without
  declaring a usercopy-whitelisted region at cache creation time.
- **Version info:** none in message.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — this is an explicit bug fix. The failure
mode (`usercopy_abort()` → `BUG()`) is a kernel panic, not a cosmetic
cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `fs/dlm/memory.c` (+3 / -1)
- **Function:** `dlm_memory_init()`
- **Scope:** Single-file, surgical fix (4 net lines)

### Step 2.2: Code flow change per hunk
**Record:**
- **Before:** `cb_cache = kmem_cache_create("dlm_cb", ...)` — no
  usercopy region declared.
- **After:** `cb_cache = kmem_cache_create_usercopy("dlm_cb", ...,
  offsetof(struct dlm_callback, lvbptr), sizeof_field(struct
  dlm_callback, lvbptr), ...)` — whitelists only the `lvbptr[]` field
  for userspace copies.
- **Path affected:** Init-time cache creation; runtime path is userspace
  DLM AST delivery with LVB copy.

### Step 2.3: Bug mechanism
**Record:** **Category:** Memory safety / hardened usercopy enforcement.
**Mechanism:** `copy_to_user()` from `cb->lvbptr` (inside SLUB object)
fails `__check_object_size()` in `mm/slub.c` because the cache has no
`useroffset`/`usersize`, leading to `usercopy_abort("SLUB object",
"dlm_cb", ...)`.

Verified call chain:
1. `dlm_add_cb()` → `dlm_user_add_ast()` (user locks)
2. `dlm_user_add_ast()` sets `cb->lkb_lksb->sb_lvbptr = cb->lvbptr` when
   `copy_lvb` is true
3. `device_read()` → `copy_result_to_user()` → `copy_to_user(buf+len,
   ua->lksb.sb_lvbptr, DLM_USER_LVB_LEN)`

### Step 2.4: Fix quality assessment
**Record:** Fix is obviously correct and minimal. Whitelisting only
`lvbptr[]` is the established kernel pattern (same author fixed orangefs
identically). Low regression risk — only expands permitted copy region
for the exact field intentionally copied to userspace. No lock-order or
API changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the changed lines
**Record:** Current `cb_cache` creation at lines 51–53 blame to
`5d324e5159d9e` (v6.18-rc8 import). Inline `lvbptr[DLM_USER_LVB_LEN]` in
`struct dlm_callback` and the `copy_lvb` redirect in
`dlm_user_add_ast()` are present in this tree at the same baseline.
Exact introduction commit of inline `lvbptr` not recoverable from this
tree's shallow `fs/dlm/` history.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Fix commit `82278e846311c` exists in repo but is **not** an
ancestor of HEAD. Upstream mainline commit `b5314f2c6654a`. Nearby
upstream DLM commit `a1ed04430f805` (SRCU list change) is unrelated.
This usercopy fix is standalone within its 2/4 series position.

### Step 3.4: Author's other commits
**Record:** Ziyi Guo authored the same class of fix for orangefs
(`f855f4ab123b2`). Alexander Aring (Acked-by) is DLM maintainer who
resent the patch in v7.1-rc1 series.

### Step 3.5: Dependencies
**Record:** No dependencies. Patch is 2/4 in a series but only touches
`memory.c` cache creation; does not require patch 1/4 (SRCU hlist
change). `git apply --check` on the diff against current tree:
**APPLY_OK**.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** `b4 dig -c 82278e846311c` →
https://patch.msgid.link/20260427155935.2415989-3-aahringo@redhat.com
**Series revisions:** v1 from Ziyi Guo (2026-02-12); v7.1-rc1 resend
(2026-04-27, patch 2/4).
**Reviewer feedback:** No replies in saved mbox with stable nominations,
NAKs, or Tested-by.

### Step 4.2: Reviewers from b4 dig -w
**Record:** CC'd: Alexander Aring, teigland@redhat.com,
gfs2@lists.linux.dev. Appropriate DLM/GFS2 audience; maintainer Acked-by
present.

### Step 4.3: Bug report search
**Record:** No Reported-by, syzbot, or bugzilla links. Bug is logically
reproducible: any DLM userspace client reading AST results with LVB on a
`CONFIG_HARDENED_USERCOPY=y` kernel.

### Step 4.4: Related patches / series
**Record:** Part of 4-patch DLM series; this patch is self-contained.
Same bug class as orangefs usercopy whitelist fix by same author.

### Step 4.5: Stable mailing list
**Record:** No stable-list discussion found in saved mbox thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `dlm_memory_init()` (modified); affected runtime:
`dlm_allocate_cb()`, `dlm_user_add_ast()`, `copy_result_to_user()`,
`device_read()`.

### Step 5.2: Callers
**Record:**
- `dlm_allocate_cb()` ← `dlm_get_cb()` ← `dlm_user_add_ast()`
- `dlm_user_add_ast()` ← `dlm_add_cb()` when `DLM_DFL_USER_BIT` set
  (userspace locks)
- `device_read()` ← DLM char device `read` ioctl path (`/dev/dlm_*`),
  userspace syscall

### Step 5.3: Callees
**Record:** `kmem_cache_create_usercopy()`, `kmem_cache_alloc()`,
`copy_to_user()`, `memcpy()`.

### Step 5.4: Call chain / reachability
**Record:** Userspace opens DLM device → lock with `DLM_LKF_VALBLK` →
AST completion with LVB copy needed (`dlm_may_skip_callback()` sets
`copy_lvb=1` for user locks) → userspace `read()` on device →
`copy_to_user()` from slab `lvbptr`. **Reachable from userspace** via
DLM device read on clusters using GFS2/DLM userspace (CONFIG_DLM=m/y).

### Step 5.5: Similar patterns
**Record:** Identical pattern in `fs/orangefs/orangefs-cache.c`,
`net/core/skbuff.c`, `kernel/fork.c`, etc. Well-established hardened-
usercopy fix approach.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.43)

### Step 6.1: Does buggy code exist?
**Record:** **YES.** `fs/dlm/memory.c` lines 51–53 still use
`kmem_cache_create()`. `struct dlm_callback` has `unsigned char
lvbptr[DLM_USER_LVB_LEN]` at `dlm_internal.h:236`. `dlm_user_add_ast()`
redirect at `user.c:223–226`. Fix commit `82278e846311c` is **not** in
HEAD.

### Step 6.2: Backport complications
**Record:** **Clean apply** — verified with `git apply --check`. No
conflicting changes in `fs/dlm/memory.c`.

### Step 6.3: Related fixes already present?
**Record:** None. `git log --grep='usercopy whitelist' -- fs/dlm/`
returns nothing on HEAD.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **fs/dlm** — Distributed Lock Manager. **IMPORTANT** for
cluster filesystem users (GFS2, OCFS2, corosync/pacemaker stacks). Not
universal like mm/net core, but critical for cluster deployments.

### Step 7.2: Subsystem activity
**Record:** DLM actively maintained (Red Hat/David Teigland tree).
Recent upstream usercopy fix in 2026.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of DLM userspace API (`CONFIG_DLM`) on kernels built
with `CONFIG_HARDENED_USERCOPY=y`. Affects cluster nodes running GFS2
and similar workloads using value-block (LVB) locks.

### Step 8.2: Trigger conditions
**Record:**
- `CONFIG_DLM` enabled
- `CONFIG_HARDENED_USERCOPY` enabled (present in multiple arch
  defconfigs; default-on when `HARDENED_USERCOPY_DEFAULT_ON` is set)
- Userspace lock operation with LVB (`DLM_LKF_VALBLK`)
- AST completion where LVB must be copied back (`copy_lvb=1`)
- Userspace `read()` on DLM device to receive AST

**Likelihood:** Real for hardened cluster kernels using LVB locks — not
theoretical.

### Step 8.3: Failure mode severity
**Record:** `usercopy_abort()` in `mm/usercopy.c:86–102` calls `BUG()` —
**kernel panic**. **Severity: CRITICAL.**

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — prevents kernel panic on legitimate DLM userspace
  operation
- **Risk:** VERY LOW — 3-line whitelist addition, field-scoped,
  maintainer-acked, proven pattern
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Real bug with kernel panic (`BUG()` via `usercopy_abort`)
- Userspace-reachable via DLM device read
- Small, surgical, maintainer-acked fix
- Applies cleanly to 6.18.43
- Buggy code confirmed present; fix not yet applied
- Same fix class already accepted upstream (orangefs precedent)

**AGAINST backport:**
- Requires `CONFIG_DLM` + `CONFIG_HARDENED_USERCOPY` (not all kernels)
- No explicit user/syzbot report in commit message
- Part of a 4-patch series (but this patch is standalone)

**Unresolved:** Exact kernel version that introduced inline `lvbptr`
(not needed for decision — code is in 6.18.43).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mechanism clear; maintainer
   Acked-by; no Tested-by
2. Fixes real bug? **PASS** — hardened usercopy abort on valid DLM
   operation
3. Important issue? **PASS** — kernel panic (CRITICAL)
4. Small and contained? **PASS** — 4 lines, 1 file
5. No new features/APIs? **PASS** — internal cache metadata only
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception categories
**Record:** None directly, but this is a hardened-usercopy compatibility
fix analogous to accepted build/runtime fixes for
`CONFIG_HARDENED_USERCOPY` users.

### Step 9.4: Decision rationale
For **6.18.43**, the buggy code path exists, the failure mode is a
kernel panic on a legitimate userspace DLM operation when hardened
usercopy is enabled, and the fix is minimal, maintainer-reviewed, and
applies cleanly. This meets all stable-kernel criteria.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user query and `git
  show b5314f2c6654a`
- **[Phase 2]** Read diff; traced `dlm_user_add_ast()` →
  `copy_result_to_user()` in `fs/dlm/user.c`
- **[Phase 2]** Confirmed `usercopy_abort()` calls `BUG()` in
  `mm/usercopy.c:86–102`
- **[Phase 2]** Confirmed SLUB usercopy check in `mm/slub.c:8275–8281`
- **[Phase 3]** `git describe HEAD` → v6.18.43; fix `82278e846311c` NOT
  ancestor of HEAD
- **[Phase 3]** `git apply --check` on patch → APPLY_OK
- **[Phase 3]** `git blame` on `lvbptr` field and copy path — present in
  tree
- **[Phase 4]** `b4 dig -c 82278e846311c` → lore URL found
- **[Phase 4]** `b4 dig -a` → v1 and v7.1-rc1 revisions
- **[Phase 4]** `b4 dig -w` → maintainers CC'd
- **[Phase 4]** Saved mbox `/tmp/dlm_usercopy.mbox` — no stable/Tested-
  by/NAK replies
- **[Phase 5]** Traced callers: `dlm_add_cb` → `dlm_user_add_ast`;
  `device_read` → `copy_result_to_user`
- **[Phase 5]** Verified `copy_lvb` set in `dlm_may_skip_callback()` for
  user LVB casts (`ast.c:101–108`)
- **[Phase 6]** `fs/dlm/memory.c` still uses `kmem_cache_create()`
  without usercopy whitelist
- **[Phase 6]** `struct dlm_callback.lvbptr[DLM_USER_LVB_LEN]` at
  `dlm_internal.h:236`
- **[Phase 7]** `CONFIG_DLM` in `fs/dlm/Kconfig`; `DLM_USER_LVB_LEN` =
  32 in `include/uapi/linux/dlm_device.h`
- **[Phase 8]** `CONFIG_HARDENED_USERCOPY` documented in
  `security/Kconfig.hardening`; enabled in multiple arch defconfigs
- **UNVERIFIED:** Exact commit that introduced inline `lvbptr` (shallow
  `fs/dlm/` history in this tree)

**YES****Verdict: YES** — backport to this tree (6.18.43).

The DLM `dlm_cb` slab cache lacks a usercopy whitelist. When userspace
AST callbacks copy LVB data from the inline `lvbptr[]` field in a slab-
allocated `struct dlm_callback`, `copy_to_user()` under
`CONFIG_HARDENED_USERCOPY` triggers `usercopy_abort()` → `BUG()` (kernel
panic). The fix switches to `kmem_cache_create_usercopy()` whitelisting
only `lvbptr[]` — a 4-line, maintainer-acked change that applies cleanly
and is not yet in HEAD.The check confirmed commit `82278e846311c` is
**not** in the current 6.18.43 tree — the fix still needs to be
backported. That supports the **YES** verdict from the earlier analysis.

 fs/dlm/memory.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/dlm/memory.c b/fs/dlm/memory.c
index 5c35cc67aca4c..ee55994ce90d8 100644
--- a/fs/dlm/memory.c
+++ b/fs/dlm/memory.c
@@ -48,8 +48,10 @@ int __init dlm_memory_init(void)
 	if (!rsb_cache)
 		goto rsb;
 
-	cb_cache = kmem_cache_create("dlm_cb", sizeof(struct dlm_callback),
+	cb_cache = kmem_cache_create_usercopy("dlm_cb", sizeof(struct dlm_callback),
 				     __alignof__(struct dlm_callback), 0,
+					 offsetof(struct dlm_callback, lvbptr),
+					 sizeof_field(struct dlm_callback, lvbptr),
 				     NULL);
 	if (!cb_cache)
 		goto cb;
-- 
2.53.0

