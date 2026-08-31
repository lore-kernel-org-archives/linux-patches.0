Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530F64A99CF;
	Mon, 31 Aug 2026 13:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183978; cv=none; b=glKpulZLDNSPifUvABDjk9Kmb6AYuDvOrO98BBjkw5YsZ6NBygAQfzQGyWi6JCUWdbrMlUcdk/qYJaxVOA3k0tDVHbZwVOZAsknhkdbbAlofzphvOaPIuzj3qhE3LXRq8VuGBuTmAOC/6Ekqf+Ke1dJeEy2CUprsG+1HcOlhwRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183978; c=relaxed/simple;
	bh=EIxTSjY1a9DpIBHGBQ7WoZ038xzqtVxhhud28bdE+kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tCNnCqPuuSylaG3ILQibNttVFa7k8J/ERuVDojED2Vf4jCpKtSkvRXFUVvBKk9Xq5jNt8c6LQSnCzdMuBJCd3JG5arSviV5xPo81xT8S8r/bcbPcwNeBKgmZJYFAS+LjlPbnfvdTQNyscrAaRsBX62RjG4CO4g69HUW3WqVTDa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iuQOydXp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iuQOydXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE281F00A3E;
	Mon, 31 Aug 2026 13:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183975;
	bh=VuuTfQsSlsnIRKrUr/mDOL2bAkwlXnRRMmPO/GFFYPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iuQOydXpKQt7a1jrYnXvxz7aQoIBCAIFNAv8EO+fBl9su81MHY8w4LofBu/My120O
	 HfxrnjWbBjI9EIMnOnAbhove+XB7itONKmPObfJ8BBqywYenmcucJkIlYPVTh/0z0A
	 ps1dPvhLbgt3Owl/Pc24DurbtbBTtexTy9LRjri94Iw+AGgVCCxauPZA0qOLCCTw5p
	 20KwhhSloo5K6hqhVASUKB35Mb4EJl9l/olv96/HlXBA4Qr8cFmkozXPAezRsJqnw4
	 w5rg67QthsQRBYGHGuYJL5oF3jZtmzLZPd/iHKocBv6uL5OJjV7cCUos1poqzORyKs
	 10sUmsRrufMyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	sstabellini@kernel.org,
	xen-devel@lists.xenproject.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] xen/gntalloc: validate grant count before allocation
Date: Mon, 31 Aug 2026 09:27:23 -0400
Message-ID: <20260831133314.4125787-415-sashal@kernel.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 2299822f3f466b5dcad2377bf63986199f881a6b ]

gntalloc_ioctl_alloc() allocates the grant-id array before checking
whether the requested count fits within the global grant limit. Counts
above that limit cannot succeed, so reject them before the
user-controlled allocation reaches kcalloc().

Use a subtraction-based check while holding gref_mutex so adding the
requested count cannot wrap. Also cast the count before advancing the
per-file index so the page-size multiplication is performed in 64-bit
arithmetic.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260626223805.43781-3-alhouseenyousef@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[xen/gntalloc] [validate] validate grant count before
allocation` — ioctl input validation and overflow-safety fix in the Xen
grant allocator.

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>` (author)
- `Reviewed-by: Juergen Gross <jgross@suse.com>` (Xen maintainer —
  strong quality signal)
- `Signed-off-by: Juergen Gross <jgross@suse.com>`
- `Message-ID: <20260626223805.43781-3-alhouseenyousef@gmail.com>`
  (patch 2/2 of v2 series)
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable@vger.kernel.org`, or
  `Tested-by:` tags

**Step 1.3 — Body analysis**
Record:
- **Bug:** `gntalloc_ioctl_alloc()` calls `kcalloc(op.count, ...)`
  before verifying `op.count` against the global grant limit.
- **Symptom:** User-controlled counts above the limit still reach kernel
  allocation; limit enforcement uses addition with mixed signed/unsigned
  types that can wrap; `priv->index` advance uses 32-bit multiply.
- **Failure modes:** Unnecessary kernel allocations (memory
  pressure/DoS), potential limit-check bypass via wrap, corrupted per-
  file mmap index.
- **Root cause:** Validation ordering and unsafe arithmetic on user-
  supplied `op.count` (`__u32`).

**Step 1.4 — Hidden bug fix?**
Record: **Yes.** Although the subject says "validate," this is a real
bug fix: premature allocation, integer-overflow-prone limit check, and
32-bit multiply before 64-bit assignment.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- 1 file: `drivers/xen/gntalloc.c` (+11 / -2 net)
- Function modified: `gntalloc_ioctl_alloc()`
- Scope: single-file, surgical ioctl-path fix

**Step 2.2 — Code flow per hunk**

| Hunk | Before | After |
|------|--------|-------|
| Early check | `kcalloc()` immediately after `copy_from_user()` |
Snapshot `limit` with `READ_ONCE()`, reject `op.count > limit` with
`-ENOSPC` before any allocation |
| Locked limit check | `gref_size + op.count > limit` | Subtraction:
`gref_size > limit_snapshot \|\| op.count > limit_snapshot - gref_size`
under `gref_mutex` |
| Index advance | `priv->index += op.count * PAGE_SIZE` (32-bit
multiply) | `priv->index += (uint64_t)op.count * PAGE_SIZE` |

Record: Normal ioctl path and error paths affected; early rejection
avoids `kcalloc`/`kfree` on doomed requests.

**Step 2.3 — Bug mechanism**
Record:
- **Category:** Input validation + integer overflow / type-safety
- **Mechanism 1:** User `count` drives `kcalloc()` before limit
  enforcement → kmem pressure DoS on `/dev/xen/gntalloc`
- **Mechanism 2:** `gref_size + op.count > limit` mixes `int` counters
  with `uint32_t` count; addition can wrap, potentially bypassing limit
  and reaching `add_grefs()`'s `for (i = 0; i < op->count; i++)` loop
- **Mechanism 3:** `op.count * PAGE_SIZE` computed in 32-bit arithmetic
  before widening to `uint64_t priv->index`

**Step 2.4 — Fix quality**
Record: Minimal, obviously correct, no API changes. Early check is
cheap. Subtraction check is standard overflow-safe idiom.
`READ_ONCE(limit)` snapshots admin-tunable limit. Regression risk:
**low** — only tightens validation; legitimate allocations within limit
unchanged.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: Buggy lines in `gntalloc_ioctl_alloc()` trace to `5d324e5159d9e`
in this shallow checkout (file unchanged since tree root). The ioctl
allocation pattern is long-standing driver code, not a recent
regression.

**Step 3.2 — Fixes: tag**
Record: Not applicable — no `Fixes:` tag present.

**Step 3.3 — Related file history**
Record: Shallow tree shows only merge commit touching
`drivers/xen/gntalloc.c`. IOCTL path with `kcalloc`-before-limit pattern
is present at HEAD.

**Step 3.4 — Author context**
Record: Yousef Alhouseen submitted the v2 series. Juergen Gross (active
Xen maintainer; recent xen commits in tree include `xen/privcmd`
security fixes) reviewed and signed off.

**Step 3.5 — Dependencies**
Record: **Series dependency identified.** Cover letter ([openwall v2
0/2](https://lists.openwall.net/linux-kernel/2026/06/26/2112)) states
patch 1/2 (`xen/gntalloc: make grant counters unsigned`) is a
prerequisite for overflow-safe unsigned arithmetic. **This commit (2/2)
applies cleanly standalone** to the current tree (`git apply --check`
succeeded). Patch 1/2 is a 3-line companion change (`int` → `unsigned
int` for `limit`/`gref_size`, `module_param(limit, uint, ...)`). Not a
hard blocker for backporting this patch, but both should ideally ship
together for a complete fix.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record: `b4 dig -c <sha>` unavailable (commit not in local tree). Found
via openwall:
- Cover: https://lists.openwall.net/linux-kernel/2026/06/26/2112
- Patch 1/2: https://lists.openwall.net/linux-kernel/2026/06/26/2113
- Patch 2/2 (this commit): https://lists.openwall.net/linux-
  kernel/2026/06/26/2114
- v2 split unsigned-type changes into prerequisite per maintainer
  feedback

**Step 4.2 — Reviewers**
Record: To: Juergen Gross, Stefano Stabellini, Oleksandr Tyshchenko; Cc:
xen-devel, linux-kernel. Juergen Gross reviewed.

**Step 4.3 — Bug report**
Record: No external bug report or syzbot link. Issue identified by code
review / proactive hardening.

**Step 4.4 — Series context**
Record: 2-patch v2 series, same file. Patch 1 prepares unsigned
counters; patch 2 adds validation. Both are small and complementary.

**Step 4.5 — Stable list**
Record: No stable-list discussion found. lore.kernel.org returned 403
(bot protection); openwall used instead.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `gntalloc_ioctl_alloc()` (modified); related: `add_grefs()`,
`do_cleanup()`.

**Step 5.2 — Callers**
Record: `gntalloc_ioctl()` → `case IOCTL_GNTALLOC_ALLOC_GREF` →
`gntalloc_ioctl_alloc()`. Reachable from userspace via `ioctl()` on
`/dev/xen/gntalloc` (`miscdevice`, name `"xen/gntalloc"`).

**Step 5.3 — Callees**
Record: `copy_from_user`, `kcalloc`, `mutex_lock/unlock`, `do_cleanup`,
`add_grefs` (allocates pages, grants foreign access in a loop over
`op->count`), `copy_to_user`, `kfree`.

**Step 5.4 — Reachability**
Record: Userspace ioctl on Xen systems with
`CONFIG_XEN_GRANT_DEV_ALLOC`. Kconfig: "Allows userspace processes to
create pages with access granted to other domains." Impact surface: Xen
dom0 / Xen PV frontends using grant allocation — not universal, but
ioctl is explicitly user-facing.

**Step 5.5 — Similar patterns**
Record: No other instances of this exact bug pattern in `gntalloc.c`.
The `add_grefs()` loop makes a bypassed limit check especially dangerous
(unbounded iteration + per-page allocations).

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Buggy code present?**
Record: **Yes.** Local tree is `v6.18.44-1-g2736c32da98b9` / `6.18.44`.
At HEAD, `gntalloc_ioctl_alloc()` still does `kcalloc()` before limit
check, uses `gref_size + op.count > limit`, and `priv->index += op.count
* PAGE_SIZE`. `limit`/`gref_size` are `static int`.

**Step 6.2 — Backport complications**
Record: **Clean apply** — `git apply --check` on the provided diff
succeeded with no conflicts.

**Step 6.3 — Related fixes already present?**
Record: No — `git log --grep="gntalloc"` and `--grep="validate grant
count"` returned nothing. Fix not yet in this tree.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**
Record: `drivers/xen/` — Xen grant-table userspace interface.
Criticality: **IMPORTANT** for Xen deployments (dom0, paravirt
frontends); **PERIPHERAL** relative to all Linux users.

**Step 7.2 — Activity**
Record: Xen subsystem actively maintained; recent security fixes in
related xen drivers (`privcmd`, `sys-hypervisor`) in this tree.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Xen systems with `CONFIG_XEN_GRANT_DEV_ALLOC` (default `m`),
users/processes that can open `/dev/xen/gntalloc` and issue
`IOCTL_GNTALLOC_ALLOC_GREF`.

**Step 8.2 — Trigger conditions**
Record:
- **Common:** `op.count > limit` (default 1024) → unnecessary `kcalloc`
  before `-ENOSPC`; repeatable for memory pressure
- **Less common:** Large `limit` module parameter + crafted counts →
  addition wrap bypassing limit → massive `add_grefs()` loop
- **Less common:** Large `op.count` with raised limit → 32-bit `op.count
  * PAGE_SIZE` wrap corrupting `priv->index`
- Unprivileged users need device access; still a valid hardening for any
  caller with ioctl access

**Step 8.3 — Failure severity**
Record:
- Memory pressure / DoS from premature allocations: **MEDIUM-HIGH**
- Limit bypass → huge grant allocation loop: **CRITICAL** (hang/OOM) if
  triggerable
- Index corruption: **HIGH** (broken mmap offsets / grant bookkeeping)
- Overall: **HIGH** for affected Xen configurations

**Step 8.4 — Risk vs benefit**
Record:
- **Benefit:** HIGH for Xen users — closes validation gap on user-facing
  ioctl
- **Risk:** LOW — 11 lines, no behavior change for valid requests within
  limit
- **Ratio:** Strong benefit, low risk

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR backport:**
- Fixes real bugs (premature user-sized allocation, overflow-prone limit
  check, 32-bit multiply)
- Small, surgical, maintainer-reviewed
- Applies cleanly to 6.18.44
- Buggy code confirmed present in this tree
- User-facing ioctl path on Xen systems
- Companion patch 1/2 is tiny and should accompany for complete
  unsigned-counter hardening

**AGAINST backport:**
- Xen-specific; not all stable users run Xen
- No syzbot/user crash report (proactive fix)
- Ideally paired with patch 1/2 for full unsigned arithmetic story
  (minor concern, not a blocker)

**Unresolved:** Whether reviewers explicitly nominated for stable (no
thread replies fetched beyond cover/patch text).

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — logic is straightforward;
   reviewed by Juergen Gross; no `Tested-by`
2. Fixes real bug affecting users? **PASS** — ioctl validation /
   overflow issues on Xen grant allocator
3. Important issue? **PASS** — DoS, potential limit bypass, index
   corruption (HIGH severity on Xen)
4. Small and contained? **PASS** — 1 file, ~13 lines changed
5. No new features/APIs? **PASS** — validation only
6. Can apply to local tree? **PASS** — verified clean apply

**Step 9.3 — Exception category**
Record: None (standard bug fix, not device ID/quirk/docs/build).

**Step 9.4 — Decision rationale**
This commit should be backported to the local **6.18.44** stable tree.
The buggy ioctl ordering and arithmetic are present, the fix is minimal
and maintainer-reviewed, and the failure modes (kmem pressure, limit
bypass, index corruption) are meaningful on Xen systems. Backport patch
1/2 (`make grant counters unsigned`) alongside this commit for the
complete v2 series.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 1] Identified patch as 2/2 via Message-ID `43781-3`
- [Phase 2] Read current `gntalloc_ioctl_alloc()` at HEAD — confirmed
  buggy ordering
- [Phase 2] Verified `limit`/`gref_size` are `static int`, `op.count` is
  `__u32`, `priv->index` is `uint64_t`
- [Phase 2] Verified `kcalloc` uses `check_mul_overflow` in
  `include/linux/slab.h`
- [Phase 3] `git blame -L 283,302 drivers/xen/gntalloc.c` — lines from
  `5d324e5159d9e`
- [Phase 3] `git log --oneline -20 -- drivers/xen/gntalloc.c` — shallow
  history
- [Phase 3] `git log --grep` for gntalloc/validate — no existing fix in
  tree
- [Phase 4] `b4 dig -c 3218686be45b8` — no result (commit not in tree)
- [Phase 4] Fetched openwall cover + patches 1/2 and 2/2 — confirmed v2
  series and prerequisite note
- [Phase 4] lore.kernel.org — 403 Forbidden (unverified for reviewer
  stable nominations)
- [Phase 5] Traced call chain: `gntalloc_ioctl` → `gntalloc_ioctl_alloc`
- [Phase 5] Confirmed miscdevice `"xen/gntalloc"` registration
- [Phase 5] Read `add_grefs()` — loops `op->count` times with page alloc
  + grant setup
- [Phase 6] `git describe HEAD` → `v6.18.44-1-g2736c32da98b9`; `make
  kernelversion` → `6.18.44`
- [Phase 6] `git apply --check` on provided diff — **clean apply**
- [Phase 6] Confirmed pre-fix code via `git show
  HEAD:drivers/xen/gntalloc.c`
- [Phase 7] Read `drivers/xen/Kconfig` `XEN_GRANT_DEV_ALLOC` —
  userspace-facing, default `m`
- [Phase 8] Assessed severity from code paths (not from unverified crash
  reports)

**YES**

 drivers/xen/gntalloc.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/gntalloc.c b/drivers/xen/gntalloc.c
index f93f73ecefeee..462f67dc32751 100644
--- a/drivers/xen/gntalloc.c
+++ b/drivers/xen/gntalloc.c
@@ -272,6 +272,7 @@ static long gntalloc_ioctl_alloc(struct gntalloc_file_private_data *priv,
 	int rc = 0;
 	struct ioctl_gntalloc_alloc_gref op;
 	uint32_t *gref_ids;
+	unsigned int limit_snapshot;
 
 	pr_debug("%s: priv %p\n", __func__, priv);
 
@@ -280,6 +281,12 @@ static long gntalloc_ioctl_alloc(struct gntalloc_file_private_data *priv,
 		goto out;
 	}
 
+	limit_snapshot = READ_ONCE(limit);
+	if (op.count > limit_snapshot) {
+		rc = -ENOSPC;
+		goto out;
+	}
+
 	gref_ids = kcalloc(op.count, sizeof(gref_ids[0]), GFP_KERNEL);
 	if (!gref_ids) {
 		rc = -ENOMEM;
@@ -292,14 +299,16 @@ static long gntalloc_ioctl_alloc(struct gntalloc_file_private_data *priv,
 	 * are about to enforce, removing them here is a good idea.
 	 */
 	do_cleanup();
-	if (gref_size + op.count > limit) {
+	limit_snapshot = READ_ONCE(limit);
+	if (gref_size > limit_snapshot ||
+	    op.count > limit_snapshot - gref_size) {
 		mutex_unlock(&gref_mutex);
 		rc = -ENOSPC;
 		goto out_free;
 	}
 	gref_size += op.count;
 	op.index = priv->index;
-	priv->index += op.count * PAGE_SIZE;
+	priv->index += (uint64_t)op.count * PAGE_SIZE;
 	mutex_unlock(&gref_mutex);
 
 	rc = add_grefs(&op, gref_ids, priv);
-- 
2.53.0

