Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB5D4D3BC1;
	Mon, 19 Oct 2026 14:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418517; cv=none; b=QmPWIxhiS9Oj/OjgEuFRlcYAnnYX/r3vgF4fplPnEJMqC0hnJ6AkR+TEViJTbpdxbnZNHjawF4GuuGCr9jEBXWcUEuB4Z57a+EABd5eEyJTr5zsrYI4P5l58iSFPmPZsBPDrpB2jH+M0B0i9A17zDCU2JpR3hDBZ0dewCOL74JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418517; c=relaxed/simple;
	bh=QTirHrIn1Zc4NgTjLu0XMpXGjojBjDEi/jkUjkhP+xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JJ8ymA6z4Eb8WIcI+/4VJxaEaXSotxRSd8WxsEYZVSXKvKWiF/USwihF4si4OOrmdl1WcDEDGT4q++OJ1mKk6NJf4/DqdYB1RFG5hEiyEORMUTiDK96CTpGtvhTgKnSW6/eO9jJqV5fxziO0YskdhevFaZK6kvny7CTMx1iiSSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aPmLKmmy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPmLKmmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE7C1F000C7;
	Mon, 19 Oct 2026 14:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418514;
	bh=FfMEqOk9tEAGb7JSgvHuG1mrEWOKhoUT079PF0wQ09Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aPmLKmmyA1ZlDfopwxi6ieXbvagkYrtwhQyCun9izbbgET1l3+uWQqEw9Ibos6ngR
	 BxLFrGanZ1/sKrDFKs4pUqSi8467Ie/13aNgdrXjVcAHT0iEtaJhOX7pH3bvOKeIG2
	 8lxKulmNUplHkWW6LhTBC4RAItxoKvC5if+e5X+44c3ziIMWlU8jCzt92TkmUt1eFF
	 YELhQgsyra/79IVHs63cxegJZTT6Ija8qyjXyKm6N/c+xBxlrXlet4ixYl/VG2nem4
	 1C9dlJtHIN3AtScgSzyFuLBIBgIs9VFbtCEhIwsabCZxC+EfH/CPjBzUk28s6sGN/6
	 kK0/1Ww9d0NYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	dwmw2@infradead.org,
	joro@8bytes.org,
	will@kernel.org,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] iommu/vt-d: Fix CACHE_TAG_NESTING_DEVTLB polluting shared variables in flush loop
Date: Mon, 19 Oct 2026 09:49:53 -0400
Message-ID: <20261019135441.1420968-302-sashal@kernel.org>
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

From: Guanghui Feng <guanghuifeng@linux.alibaba.com>

[ Upstream commit 3846e469c1ba1407260066070bff5c88ee39a4c7 ]

In cache_tag_flush_range(), the CACHE_TAG_NESTING_DEVTLB case modifies the
shared local variables 'addr' and 'mask' before falling through to
CACHE_TAG_DEVTLB. This causes all subsequent CACHE_TAG_DEVTLB entries in
the same loop iteration to incorrectly use the full-range flush parameters
(addr=0, mask=MAX_AGAW_PFN_WIDTH) instead of the precisely calculated PSI
range. This is not the intended behavior, as regular DEVTLB entries should
always perform targeted range-based invalidation.

Fix this by having CACHE_TAG_NESTING_DEVTLB directly call
cache_tag_flush_devtlb_psi() with the full-range constants and break,
instead of modifying shared variables and falling through. This ensures
CACHE_TAG_DEVTLB always uses the original calculated addr and mask for
precise range flush.

This change slightly affects trace_cache_tag_flush_range() behavior.
Previously, after addr/mask were overwritten, the tracepoint could record
a full-range flush even when the caller requested a narrower range.

The tracepoint should reflect caller intent. Although this helper may
widen the actual hardware invalidation range for implementation reasons,
that does not change what the caller requested, so logging the requested
range is the correct behavior.

If the actual invalidation range sent to hardware is needed, it is already
visible via the qi_submit trace event, which records the invalidation
descriptors emitted by the driver.

Signed-off-by: Guanghui Feng <guanghuifeng@linux.alibaba.com>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The remaining thread parse confirms two vendors independently hit the
same flush-loop bug. I’ll wrap the nine-phase analysis against this 6.12
tree only.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[iommu/vt-d] [Fix] [CACHE_TAG_NESTING_DEVTLB mutates shared
`addr`/`mask` in `cache_tag_flush_range()`, so later tags in the same
loop use a full-range flush instead of the calculated PSI range]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Signed-off-by:** Guanghui Feng (author, Alibaba), Guixin Liu
  (Alibaba), Lu Baolu (Intel VT-d maintainer), Joerg Roedel (IOMMU
  maintainer)
- **No Fixes:** tag (expected for this review pipeline)
- **No Cc: stable** (expected)
- **No Reported-by / Tested-by / Reviewed-by / Acked-by / Link** on the
  committed message
- Independent earlier submission of the same bug exists (Baidu; see
  Phase 4)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** In `cache_tag_flush_range()`, `CACHE_TAG_NESTING_DEVTLB`
  writes `addr = 0` and `mask = MAX_AGAW_PFN_WIDTH` then `fallthrough`s
  into `CACHE_TAG_DEVTLB`. Those locals are computed once before the
  loop, so every later tag sees the full-range values.
- **Symptom:** Regular DevTLB (and, in this tree, later IOTLB)
  invalidations become global/full-range instead of the caller’s PSI
  range. Tracepoint can also log a full-range flush when the caller
  asked for a narrower range.
- **Version info:** None in the message. Introduced with cache-tag
  helpers (v6.11); present in this 6.12 tree.
- **Root cause:** Shared loop variables overwritten for one tag type,
  then reused for all later tags.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not hidden.** Subject and body are an explicit logic-bug fix.
The extra tracepoint paragraph is a side effect of stopping the
overwrite, not the reason for the change.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `drivers/iommu/intel/cache.c` only
- **Net:** 2 insertions, 3 deletions (5-line change)
- **Function:** `cache_tag_flush_range()`
- **Scope:** single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** `CACHE_TAG_NESTING_DEVTLB` mutates `addr`/`mask`, falls
  through, flushes that tag as a full DevTLB, and leaves the mutated
  values for later iterations.
- **After:** That case calls `cache_tag_flush_devtlb_psi(domain, tag, 0,
  MAX_AGAW_PFN_WIDTH)` and `break`s. Later
  `CACHE_TAG_DEVTLB`/`CACHE_TAG_IOTLB` tags keep the original PSI
  `addr`/`mask`.
- **Path:** mapping-change invalidation (`intel_iommu_tlb_sync`,
  superpage switch, SVM range invalidate), not probe/error-only.

Verified in this checkout (`cache.c` 437–478): the buggy `addr = 0; mask
= MAX_AGAW_PFN_WIDTH; fallthrough;` is present.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[Logic / correctness]** Shared loop state is clobbered. Nested
DevTLB still needs a full device-cache flush (comment is unchanged). The
fallthrough was a convenient way to reuse the DevTLB helper and
accidentally changed flush parameters for every later tag.

Consequence in this tree:
- Later `CACHE_TAG_DEVTLB`: full-range Dev-IOTLB instead of PSI (over-
  invalidation).
- Later `CACHE_TAG_IOTLB` / `CACHE_TAG_NESTING_IOTLB`:
  `cache_tag_flush_iotlb(..., addr, pages, mask, ih)` with `addr=0`,
  `mask=MAX_AGAW_PFN_WIDTH` (52) and original `pages`. On the nest-
  parent S2 domain (`use_first_level` is false; see Phase 5/6) that
  typically becomes domain-selective IOTLB (`mask > cap_max_amask_val`)
  — still covering, but far broader than PSI.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: **Obviously correct.** Same full-range DevTLB flush for nesting,
without mutating shared locals. No new locking, APIs, or data
structures. Regression risk is low: nested DevTLB still gets a full
flush; other tags get the range the caller computed. Tracepoint then
logs the requested range, which is the stated intent.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Buggy `addr`/`mask`/`fallthrough` introduced in **`c4d27ffaa8eb0`**
  (“iommu/vt-d: Add cache tag invalidation helpers”, Lu Baolu,
  2024-04-24).
- **`git describe --contains c4d27ffaa8eb0`:**
  `x86_boot_for_v6.11_rc1~...` → first appeared in **v6.11**.
- **`git merge-base --is-ancestor c4d27ffaa8eb0 HEAD`:** yes. Present
  for the whole 6.12 lifetime.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Equivalent “buggy commit” is `c4d27ffaa8eb0`,
which is in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record (recent `drivers/iommu/intel/cache.c`):
- `ffd774c34774f` qi_batch NULL with nested parent
- `705c1cdf1e73c` batched cache invalidation
- `3297d047cd7f5` refactor IOTLB/Dev-IOTLB flush (this is why 6.12’s
  `cache_tag_flush_iotlb` still takes `pages`)
- `c4d27ffaa8eb0` original helpers (bug intro)

Standalone fix, not patch 2/3 of a functional series. It was later
folded as 03/19 in “Intel IOMMU updates for v7.3”, but it does not
depend on the other patches in that pull.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Guanghui Feng has `31fd1e0281621` (“Fix intel iommu iotlb sync
hardlockup and retry”) in this Intel IOMMU tree. Guixin Liu has no other
hits here. Lu Baolu is the VT-d maintainer and signed off. Two vendors
independently posted the same bug (Alibaba and Baidu).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: **No functional prerequisites.**
`cache_tag_flush_devtlb_psi(domain, tag, addr, mask)` exists here with
that signature. Surrounding context differs (`pages` still passed to
IOTLB flush and the tracepoint; `cache_tag_flush_all` is still its own
loop, not a wrapper). The 3-line change backports with a context tweak,
not extra commits.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- Original: Message-ID
  `20260623060122.3796325-1-guanghuifeng@linux.alibaba.com`
  (2026-06-23), 3-message thread via `b4 mbox`.
- Lu Baolu (2026-06-27): same issue already posted by Baidu:
  `https://lore.kernel.org/linux-
  iommu/20260605003950.1720-1-lirongqing@baidu.com/`
- Lu Baolu (2026-07-27): **“Queued for v7.3-rc1.”**
- No NAKs. No reviewer concern about correctness.
- v2 of the Intel pull added the tracepoint clarification; the code
  change is unchanged from v1.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: Recipients were the IOMMU maintainers (Woodhouse, Lu, Roedel,
Deacon, Murphy) and `iommu@lists.linux.dev`. Lu Baolu signed off and
queued it; Joerg applied it. No separate Reviewed-by on the committed
text. Kevin Tian was CCed on the pull, not recorded as a reviewer of
this hunk.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot/bugzilla. **Two independent vendor patches:**
1. Li RongQing (Baidu), 2026-06-05: “Prevent variable pollution in
   `cache_tag_flush_range()`” — per-iteration `flush_addr`/`flush_mask`
   copies, including the IOTLB path.
2. Guanghui Feng (Alibaba), 2026-06-23 — the version that landed (direct
   full-range call + `break`).

Baidu pinged after 12 days; Lu queued it. That is “bothers people,” not
a theoretical review nit.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Landed as **03/19** of Lu Baolu’s “Intel IOMMU updates for
v7.3”. Other patches in that series are unrelated (UCTP, tboot, context
teardown, etc.). This hunk is self-contained. Several *other* fixes from
that pull are already in this `pending-6.12` tree; this one is not.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: `lore.kernel.org/stable` fetch returned 403. **UNVERIFIED**
whether stable@ already discussed this specific subject. No evidence it
was rejected for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: `cache_tag_flush_range()`; helper `cache_tag_flush_devtlb_psi()`
(unchanged).

**Step 5.2: TRACE CALLERS**

Record (this tree):
- `intel_iommu_tlb_sync()` in `iommu.c` — unmap/Iotlb gather; **common
  VFIO/iommufd map change path**
- `switch_to_super_page()` in `iommu.c`
- `intel_nested_cache_invalidate_user()` in `nested.c` — flushes the
  **nested S1 domain** (IOTLB/DEVTLB only; NESTING tags live on S2)
- `intel_arch_invalidate_secondary_tlbs()` in `svm.c` — SVA

The pollution matters when the domain being flushed **has
`CACHE_TAG_NESTING_DEVTLB` on its list**, i.e. the **S2 nest-parent**,
on S2 map changes (`intel_iommu_tlb_sync` on that domain).

**Step 5.3: TRACE CALLEES**

Record: `calculate_psi_aligned_address` → lock → per-tag
`cache_tag_flush_iotlb` / `cache_tag_flush_devtlb_psi` →
`qi_batch_add_*` / `qi_submit_sync`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Nested attach (`cache_tag_assign_domain`) puts NESTING_* tags on
`domain->s2_domain`. Nest parent is allocated with
`paging_domain_alloc(dev, false)` so **`use_first_level` is false**.
Userspace (iommufd/VFIO nested vIOMMU) changing S2 mappings triggers
`intel_iommu_tlb_sync` → `cache_tag_flush_range` on S2. **Reachable from
VM/device assignment, not a debug-only path.**

Tag order (`list_add_tail`): per nested ATS device, `NESTING_IOTLB` then
`NESTING_DEVTLB`. With **two or more** nested ATS devices, after the
first `NESTING_DEVTLB`, later IOTLB/DEVTLB tags see polluted
`addr`/`mask`. Mixed host-on-S2 + nested-on-S2 with nested attached
first is the `CACHE_TAG_DEVTLB` case the commit describes.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: `cache_tag_flush_all()` in this tree already handles
`CACHE_TAG_DEVTLB` and `CACHE_TAG_NESTING_DEVTLB` together via
`cache_tag_flush_devtlb_all()` **without** mutating shared range locals.
`cache_tag_flush_range_np()` does not touch DevTLB. The range path is
the inconsistent one.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- **Tree:** `pending-6.12`, `git describe HEAD` =
  `p-6.12-3-gc504cf0baa3d8`, `make kernelversion` = **6.12.111**
- Buggy code: `drivers/iommu/intel/cache.c` lines 458–468
- Introduced v6.11 (`c4d27ffaa8eb0`), **before** 6.12 branched
- `git log --grep='polluting shared'` on this path: **empty** — fix
  **not** already applied

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Minor context rework, not a redesign.** This tree still has:
- `cache_tag_flush_iotlb(domain, tag, addr, pages, mask, ih)`
- `trace_cache_tag_flush_range(tag, start, end, addr, pages, mask)`
- a full `cache_tag_flush_all()` loop

Mainline hunk context dropped `pages` and collapsed
`cache_tag_flush_all` into a wrapper. The three changed lines
(`addr`/`mask`/`fallthrough` → direct call + `break`) match this file
as-is.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No equivalent fix. `fallthrough` at line 468 is still the only
one in this file.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: **Intel VT-d IOMMU cache invalidation.** Criticality:
**IMPORTANT** (DMA isolation / nested virtualization). Not core mm/VFS,
but wrong Dev-IOTLB/IOTLB parameters affect VFIO/iommufd nested guests
with ATS devices.

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: Actively maintained; this `pending-6.12` branch already carries
other VT-d fixes from the same v7.3 era pull. Cache-tag code has been
stable in structure since 6.11 aside from batching.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: **Config/driver-specific:** `CONFIG_INTEL_IOMMU` + nested
translation (`IOMMU_HWPT_ALLOC_NEST_PARENT` / iommufd nested) + ATS
devices so `CACHE_TAG_*DEVTLB` tags exist. Typical cloud VFIO/vIOMMU.
Not every 6.12 box.

**Step 8.2: TRIGGER CONDITIONS**

Record: S2 mapping changes while nested ATS devices are attached and
more than one relevant cache tag follows a `NESTING_DEVTLB` on the list
(multiple nested ATS devices, or nested-then-host on the same S2).
Privileged/VMM path (iommufd), not an unprivileged syscall smash. Easy
to hit in production nested setups; two cloud vendors filed it
independently.

**Step 8.3: FAILURE MODE SEVERITY**

Record: **Wrong IOMMU invalidation parameters → overly broad IOTLB/Dev-
IOTLB flushes** (global Device-TLB / domain-selective IOTLB instead of
PSI).

Verified **not** stale-translation under-invalidation on this tree’s
nest parent: S2 is `paging_domain_alloc(dev, false)`, so the first-level
`piotlb(addr=0, original pages)` mis-flush does not apply.

Severity: **MEDIUM–HIGH** for nested ATS (I/O stalls, ATS storms, lost
PSI benefit on a hot unmap path). Not oops/corruption in the verified
6.12 S2 path. Matches stable-rules **“oh, that's not good”** and, given
Baidu+Alibaba, a **notable performance/correctness issue that bothers
production users**.

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit:** Restore intended PSI DevTLB/IOTLB invalidation on nested
  S2 flushes; avoid global ATS invalidation for later devices; tiny,
  local change.
- **Risk:** Very low (3 lines, same helper, nesting still full-flushes).
- **Ratio:** Favorable for 6.12-stable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real logic bug in VT-d nested cache invalidation, present since v6.11,
  in this 6.12.111 tree
- Two independent vendor reports (Baidu 2026-06-05, Alibaba 2026-06-23);
  maintainer queued it
- 5-line, obviously correct; no new API
- User-visible extra global Device-TLB/IOTLB invalidations on nested S2
  map updates
- `cache_tag_flush_all()` already avoided this pattern; range path did
  not
- No functional dependencies missing here

**AGAINST:**
- Not a crash, UAF, or proven stale-TLB corruption on this tree’s S2
  path (error is conservative over-flush)
- Nested+ATS is not universal
- Hunk needs a small context backport (`pages` / `cache_tag_flush_all`
  shape)
- No Fixes/Cc: stable on the commit (not a negative per the pipeline
  rules)

**UNRESOLVED:**
- lore.kernel.org HTTP 403; stable@ history not fetched (thread
  recovered via `b4 mbox`)
- Exact mainline SHA not in this checkout (no `git log --all`)

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — maintainer queued; two
   vendors; trivial control-flow fix
2. Fixes a real bug that affects users? **PASS** — Baidu and Alibaba
   both submitted it
3. Important issue? **PASS** (with the documented “oh, that's not good”
   / notable nested-ATS invalidation impact) — not oops/corruption here,
   but wrong IOMMU flush parameters on a production nested path
4. Small and contained? **PASS** — 5 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — buggy lines exist; needs
   minor context adjustment, not missing helpers

**Step 9.3: EXCEPTION CATEGORIES**

Record: None (not a device ID/quirk/DT/build/doc exception). Qualifies
as a normal small bugfix.

**Step 9.4: DECISION**

This 6.12 tree has the bug. The fix is a three-line control-flow
correction in Intel VT-d nested invalidation. It does not need later
refactors. Over-flush is still a real, production-visible IOMMU bug
(independent Alibaba and Baidu reports), and the patch is the lowest-
risk way to restore the intended PSI range. It should be backported
here.

---

## What the commit solves (for 6.12)

`cache_tag_flush_range()` computes one PSI `addr`/`mask`, then walks
every cache tag. Nested DevTLB must flush the whole device cache, so the
original code stuffed `addr=0` / `mask=MAX_AGAW_PFN_WIDTH` into those
shared locals and fell through. Later tags on that S2 domain (other
nested ATS devices, or regular DevTLB) then issued a full-range
invalidation instead of the range the caller asked for. On 6.12 that is
extra-wide IOTLB/Dev-IOTLB traffic, not a verified stale-mapping hole,
but it is incorrect invalidation on the nested map-update path.

## Risk vs benefit

Benefit is restoring targeted invalidation for a path cloud VFIO/iommufd
actually uses. Risk is a 3-line change that keeps the nested full flush
and only stops clobbering later tags.

## Concerns

Backport cannot be a blind `git am` of the mainline hunk: this tree
still passes `pages` into `cache_tag_flush_iotlb` and the tracepoint,
and `cache_tag_flush_all()` is still a separate loop. Edit only the
`CACHE_TAG_NESTING_DEVTLB` arm.

---

Verification:
- [Phase 1] Parsed tags: SOBs Feng/Liu/Lu/Roedel; no Fixes/Reported-
  by/Cc:stable
- [Phase 2] Diff: 2+/3- in `cache_tag_flush_range()`; replace
  mutate+fallthrough with direct `cache_tag_flush_devtlb_psi(..., 0,
  MAX_AGAW_PFN_WIDTH)` + break
- [Phase 2] Read `cache.c` 437–510 in this tree: buggy fallthrough still
  at 466–468
- [Phase 3] `git blame`: intro `c4d27ffaa8eb0` (v6.11); `git merge-base
  --is-ancestor` yes
- [Phase 3] `git log --grep='polluting shared'` on path: not present
- [Phase 3] `cache_tag_flush_iotlb` still has `pages` (`3297d047cd7f5`);
  no missing helper
- [Phase 4] `b4 mbox` original thread: Lu notes Baidu duplicate; queued
  for v7.3-rc1; no NAK
- [Phase 4] Baidu thread `20260605003950.1720-1-lirongqing@baidu.com`:
  same bug, IOTLB path included
- [Phase 4] UNVERIFIED: lore.kernel.org/stable HTTP 403
- [Phase 5] Callers: `intel_iommu_tlb_sync`, `switch_to_super_page`,
  nested user invalidate, SVM
- [Phase 5] Nest parent: `paging_domain_alloc(dev, false)` at
  `iommu.c:3606` → `use_first_level` false
- [Phase 5] NESTING tags assigned to `domain->s2_domain` in
  `cache_tag_assign_domain()`
- [Phase 6] `git describe HEAD` p-6.12-3-gc504cf0baa3d8; `make
  kernelversion` 6.12.111
- [Phase 8] Failure mode: over-wide DevTLB/IOTLB invalidation; not
  verified as under-invalidate on this S2 path
- UNVERIFIED: mainline SHA (commit not in this checkout; `--all` not
  used)

**YES**

 drivers/iommu/intel/cache.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c
index 385ae5cfb30d4..e6bc730fac3b0 100644
--- a/drivers/iommu/intel/cache.c
+++ b/drivers/iommu/intel/cache.c
@@ -468,9 +468,8 @@ void cache_tag_flush_range(struct dmar_domain *domain, unsigned long start,
 			 * affected by a change in S2. So just flush the entire
 			 * device cache.
 			 */
-			addr = 0;
-			mask = MAX_AGAW_PFN_WIDTH;
-			fallthrough;
+			cache_tag_flush_devtlb_psi(domain, tag, 0, MAX_AGAW_PFN_WIDTH);
+			break;
 		case CACHE_TAG_DEVTLB:
 			cache_tag_flush_devtlb_psi(domain, tag, addr, mask);
 			break;
-- 
2.53.0

