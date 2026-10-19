Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD58A54FEA5;
	Mon, 19 Oct 2026 13:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418218; cv=none; b=jiPr+LYacBCtrQIze0pFg6ZJJjU/JKLyHPdmZfTe+AI1XcXaQMIcp/cBI6hoQDCXZesSc2Lcgi302K0ul+OaSUEZ5/r2FBg9Mr+WACtzCHyAULuXeg1s9sH8wdTzQ2ajlB+M0wJmZsxAgkmmlBjg6r3X/rkSgYGhcs7oCJEsnS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418218; c=relaxed/simple;
	bh=C2NHdwmkdP+R0GfepbhFteRJdcXzzHx4S7tYxJwWVxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rFTrPVSKOTpQFFgK2/09TVy1O6xujWnbpN3bydsi7hVn78aIefgtRtqwqGvp7UE0a8YMsCxOVqlxjMBYPms/JXZcBXTdR7hA5NoxlKOjZ06n+tesV/XaGGNPIO/wg3/9q/fyZQ2edc/pBIXYHr/Avi4ww6X0uPHZUkrlqPYWY1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oc5d6Uoq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oc5d6Uoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3225E1F000C7;
	Mon, 19 Oct 2026 13:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418211;
	bh=DyG2ttCOyqXPCZbpZC5m/iC13lqRJk3G9Hi3hmoWeCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oc5d6UoqFpu0ZYwcKfA7fVpYVLV6hsxFzvTNSx3vNM4KMDy9OXB/QzTh+VvnjfAqN
	 QBPptDw2s+6gDxMqCLzrse8lfBTP8lh36TETE4W5XZWL115PQYSlKl73Z/1T/t8iTQ
	 YLudFJ82+xldZlJjjyIhOLs/cEzSaMThoXWQggQyp7wOC+V3dCb3Dqcgpkoq2OKFrJ
	 qf3xP9RxE8ppgX6xOcdamIwNlr2XV7MuwVpPUCQb2qsbdOuYmdwKAPBp39lD7vy8Re
	 xtah0Vwx91328VIVip8VZEVzAunbnijW1YZxeu03e9eYtMsdr1hSdpu3q9ORAciwO8
	 72tRdNOuxI90A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vasant Hegde <vasant.hegde@amd.com>,
	Gaultier Delbarre <Gaultier.Delbarre@amd.com>,
	Wei Huang <wei.huang2@amd.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	joro@8bytes.org,
	will@kernel.org,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] iommu/amd: Fix missing CMD_COMPLETE_PPR response for invalid PPR requests
Date: Mon, 19 Oct 2026 09:46:22 -0400
Message-ID: <20261019135441.1420968-91-sashal@kernel.org>
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

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit bc1f5ec826bfa510e7138e2be5aad23907850874 ]

The AMD IOMMU spec, requires the host to respond with a CMD_COMPLETE_PPR
command when an EVENT_TYPE_INV_PPR_REQ event is received with the RX bit
cleared. This response was missing in the current implementation, leaving
invalid PPR requests unacknowledged.

Introduce amd_iommu_report_ppr_err() to handle EVENT_TYPE_INV_PPR_REQ
events. The new function logs the invalid PPR request and when the RX
bit is cleared, sends CMD_COMPLETE_PPR response.

Reported-by: Gaultier Delbarre <Gaultier.Delbarre@amd.com>
Co-developed-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Ankit Soni <Ankit.Soni@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: the INV_PPR_REQ path is in this 6.12 tree, the
completion helper already exists, and the fix is a small spec-compliance
change to stop PRI stalls.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[iommu/amd] [Fix] missing CMD_COMPLETE_PPR response for
invalid PPR requests.** The subject is an explicit bug fix in the AMD
IOMMU driver: invalid PPR (Page Request) events were logged but not
acknowledged to hardware.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Reported-by:** Gaultier Delbarre (AMD) — real hardware/spec issue
  found inside AMD, not a theoretical cleanup.
- **Co-developed-by / Signed-off-by:** Wei Huang (AMD), Vasant Hegde
  (AMD IOMMU maintainer/author).
- **Reviewed-by:** Ankit Soni (AMD).
- **Signed-off-by:** Joerg Roedel (IOMMU maintainer).
- **No Fixes: tag** (expected for this review pipeline).
- **No Cc: stable** (expected).
- **No syzbot, Link, Tested-by, or Acked-by.**
- Ignore any pipeline-added Sasha Levin SOB / Upstream commit markers.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** AMD IOMMU spec requires the host to issue `CMD_COMPLETE_PPR`
  when an `EVENT_TYPE_INV_PPR_REQ` event arrives with the RX bit
  **cleared**. The driver only printed `INVALID_PPR_REQUEST` and
  returned.
- **Symptom:** Invalid PPR/PRI requests stay unacknowledged. The device
  keeps the outstanding page-request slot; further PRI traffic can stall
  (DMA/GPU/SVA hang), rather than a kernel oops.
- **Root cause:** Event-log handler treated INV_PPR_REQ as log-only; the
  completion path used for valid PPR (`amd_iommu_complete_ppr()`) was
  never invoked.
- **Fix:** New `amd_iommu_report_ppr_err()` logs the event and, if RX=0,
  sends `CMD_COMPLETE_PPR` with `IOMMU_PAGE_RESP_FAILURE`.
- **Version info in message:** none.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not a hidden fix.** The subject and body state a spec-mandated
missing hardware response. This is a protocol/hang fix, not a style
cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- `drivers/iommu/amd/amd_iommu_types.h`: +1 (`EVENT_FLAG_PPR_RX 0x001`).
- `drivers/iommu/amd/iommu.c`: ~+33/-6. New
  `amd_iommu_report_ppr_err()`; `iommu_print_event()` INV_PPR_REQ case
  now calls it; unused local `tag` removed.
- **Scope:** single-driver surgical fix. ~38 lines net. No API/ABI
  change.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** `iommu_print_event()` on type 0x9 extracted PASID/tag,
  `dev_err()`, break. No IOMMU command.
- **After:** same log, then if `!(flags & EVENT_FLAG_PPR_RX)` look up
  the PCI device, check IOMMU private data, call existing
  `amd_iommu_complete_ppr(..., IOMMU_PAGE_RESP_FAILURE, tag)`.
- **Path:** threaded IRQ event-log poll (`amd_iommu_int_thread_evtlog` →
  `iommu_poll_events` → `iommu_print_event`), not a syscall hot path.
  Error/exception path for invalid hardware page requests.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Hardware protocol / hang (logic/correctness).** Missing
command on an exception event. Analogous to Intel VT-d
`handle_bad_prq_event()`, which already submits a page-group response
for invalid PRQ. Not UAF/leak/race/overflow.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Obviously correct** for the common case: RX=0 → complete with
  FAILURE using the same helper as `ppr.c` already uses for “nobody
  cared” PPR entries.
- **Minimal:** one flag, one helper, one call-site change.
- **Regression risk: low.** Patterns match existing event/PPR handling
  (`pci_get_domain_bus_and_slot` + `pci_dev_put` already used from
  `amd_iommu_report_page_fault()` in this same function).
  `iommu_queue_command()` takes `iommu->lock` with
  `raw_spin_lock_irqsave`; `iommu_print_event()` does not hold that
  lock.
- **Known incompleteness (accepted in the committed form):** if
  `pci_get_domain_bus_and_slot()` fails or there is no IOMMU priv, it
  still returns without COMPLETE_PPR. Ankit Soni raised that on list;
  the committed diff still has those early returns, and Ankit still
  Reviewed-by. Those are devices not in the PCI tree / not bound — the
  PRI-using devices this matters for have both.
- **Follow-up in the same series (not this commit):** patch 4 rate-
  limits the log; patch 5 fixes GN derivation (`pri_tlp` vs v2 page-
  table). This commit uses existing `amd_iommu_complete_ppr()` (GN from
  `pri_tlp`), which is already how every COMPLETE_PPR in **this** tree
  is built. Not a new regression vs current 6.12 behavior.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- INV_PPR_REQ case introduced in **e7f63ffc1bf19** (“iommu/amd: Update
  logging information for new event type”, 2018-05-01, Gary R Hook) —
  log-only from the start.
- PASID extraction: 470eb3b31134ad (Suravee, 2019).
- Log format: later Vasant Hegde updates (b36a5b0f1cedbb / pci_seg).
- Buggy behavior (log, no COMPLETE_PPR) has been in-tree for years,
  including this 6.12 checkout.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** The missing response became operationally
important once PRI/PPR completion existed: **978d626b8f1a2**
(“iommu/amd: Add IO page fault notifier handler”, Wei Huang, 2024-04-18)
added `amd_iommu_complete_ppr()` and PPR log handling. That commit **is
an ancestor of HEAD**.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- This commit is **patch 3/5** of “iommu/amd: PRI related cleanup and
  fixes” (Vasant Hegde, 2026-07-27).
  1. Device ID in invalid PASID log — **already in this tree**
     (`5a5cd58b1533e`).
  2. `PPR_TAG_LAST_PAGE()` macro — cleanup; **not required** for this
     patch.
  3. **This fix** — missing COMPLETE_PPR.
  4. Rate-limit INVALID_PPR_REQUEST — depends on 3; current 6.12 already
     logs unbounded `dev_err` here, so 3 alone is not a log-flood
     regression.
  5. GN bit in COMPLETE_PPR — separate correctness fix; refactors
     `amd_iommu_complete_ppr()`.
- Recent `iommu.c` churn is attach/flush locking, not this event case.
  **Standalone for the bug it fixes.**

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Vasant Hegde is the AMD IOMMU driver author on this tree (many
`drivers/iommu/amd/` commits). Wei Huang added the 2024 IOPF/PPR
notifier. This is a maintainer-area fix, not a drive-by.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: **Can apply standalone on this tree.** Required symbols all
exist:
- `amd_iommu_complete_ppr()` (`iommu.c` ~1827, declared in
  `amd_iommu.h`)
- `PPR_PASID()`, `IOMMU_PAGE_RESP_FAILURE`,
  `pci_get_domain_bus_and_slot`, `dev_iommu_priv_get`, `iommu->pci_seg`
- `EVENT_TYPE_INV_PPR_REQ` case already present
- Patches 2/4/5 not required for this change to compile or to send a
  completion.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- Series: [PATCH 0/5] iommu/amd: PRI related cleanup and fixes, Vasant
  Hegde, 2026-07-27.
- Patch 3: https://ratatoskr.run/linux-iommu/2026/07/17321958
- Cover: https://ratatoskr.run/linux-iommu/2026/07/17321955
- Review: https://ratatoskr.run/linux-iommu/2026/07/17327932 (Ankit
  Soni, 2026-07-28): suggested issuing COMPLETE_PPR even when
  `pdev`/priv is missing, via
  `build_complete_ppr()`/`iommu_queue_command()`. **No NAK.** Committed
  code matches v1 (early returns kept) and carries Ankit’s Reviewed-by.
- **UNVERIFIED:** `b4 dig -c` needs a SHA not in this checkout. `b4
  mbox` of msgid `26cfa307-6c33-41f9-a7a0-fbf202b38a00@amd.com` returned
  an unrelated IRT-cache thread. lore.kernel.org search URLs returned
  **403**. No evidence of a later v2 that replaced this diff.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: Recipients/maintainers on the series include Joerg Roedel (SOB
on the commit), Ankit Soni (Reviewed-by), Wei Huang (co-developer).
Appropriate AMD IOMMU reviewers.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: Reporter is AMD (Gaultier Delbarre). No public syzbot/bugzilla
link. This is spec non-compliance observed on AMD hardware/firmware, not
a fuzzer crash.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: 5-patch PRI series. Patch 1 already backported here. 2 is
cosmetic. 3 is the hang/protocol fix. 4 is log-rate-limit on top of 3. 5
is GN-bit correctness for all COMPLETE_PPR, plus using event-flag GN on
this new path. **This commit is self-contained;** 5 is a nice follow-up,
not a hard apply dependency.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: **UNVERIFIED** — lore.kernel.org/stable returned 403. No local
`git log --grep=CMD_COMPLETE_PPR` hits in this tree.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: Added `amd_iommu_report_ppr_err()`. Modified
`iommu_print_event()`. Calls existing `amd_iommu_complete_ppr()`.

**Step 5.2: TRACE CALLERS**

Record:
- `iommu_print_event()` ← `iommu_poll_events()` ←
  `amd_iommu_int_thread_evtlog()` / `amd_iommu_int_thread()` (threaded
  IRQ).
- `amd_iommu_complete_ppr()` already called from
  `iommu_call_iopf_notifier()` and `amd_iommu_page_response()` in
  `ppr.c` (same IRQ-thread class for PPR log).

**Step 5.3: TRACE CALLEES**

Record: `PPR_PASID()`, `pci_get_domain_bus_and_slot()`,
`dev_iommu_priv_get()`, `amd_iommu_complete_ppr()` →
`build_complete_ppr()` + `iommu_queue_command()` (command buffer, may
`udelay` under `iommu->lock` on full buffer — existing behavior).

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: **Reachable in production** on AMD IOMMU hardware with PPR
(Guest Translation + PPR + EPHSUP: `amd_iommu_gt_ppr_supported()`). PPR
log is enabled in `enable_iommus_ppr()`. PRI is enabled on SVA-capable
domain attach (`pdev_enable_caps()`). Userspace/devices that use
SVA/PASID/PRI (AMD GPU SVM, some VFIO) can generate PPR; invalid ones
produce INV_PPR_REQ in the event log. Not a syscall bug; a device
DMA/PRI stall.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: `ppr.c` already completes invalid/unhandled PPR log entries with
`IOMMU_PAGE_RESP_FAILURE`. Intel `handle_bad_prq_event()` always
responds to invalid PRQ when LPIG is set. This patch closes the AMD
event-log gap for the same class of bug.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** Local tree is **6.12.111** (`p-6.12-3-gc504cf0baa3d8`,
Makefile VERSION/PATCHLEVEL/SUBLEVEL 6/12/111).

```973:979:drivers/iommu/amd/iommu.c
        case EVENT_TYPE_INV_PPR_REQ:
                pasid = PPR_PASID(*((u64 *)__evt));
                tag = event[1] & 0x03FF;
                dev_err(dev, "Event logged [INVALID_PPR_REQUEST ...
                break;
```

No `EVENT_FLAG_PPR_RX`, no `amd_iommu_report_ppr_err()`. Bug introduced
as log-only in 2018; completion helper present since 978d626b8f1a2 (in
this tree).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Expected apply: clean or trivial context.** 6.12
`iommu_print_event()` lacks a later `ctrl = readq(MMIO_CONTROL_OFFSET)`
local that appears in the mainline hunk context; the INV_PPR_REQ case,
`report_page_fault` insertion point, and `EVENT_FLAG_I` site match. No
conflicting local change to this switch arm.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No existing COMPLETE_PPR on INV_PPR_REQ. Related:
`5a5cd58b1533e` (series patch 1, log-only), `1de4443f85e44` (pci_dev_put
after PPR faults). **This specific bug is unfixed here.**

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **drivers/iommu/amd** — **IMPORTANT** (not core mm/VFS). AMD
IOMMU is default DMA isolation on AMD x86; PRI/PPR is a subset
(SVA/IOPF), but a hung PRI-capable device (GPU) is user-visible.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Actively maintained in 6.12 (flush, attach locking, SNP log
sizes, PPR). Mature driver; this event type is old. Fix is not for
brand-new code missing from 6.12.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Platform/config-specific:** AMD IOMMU + PPR/PRI-capable
devices (SVA/PASID). Not every AMD desktop, but real 6.12 users
(ROCm/KFD SVM, IOMMU page-fault devices).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Hardware logs INV_PPR_REQ (invalid PRI/PPR). RX=0 means software
**must** complete. Trigger is device-generated, not a userspace syscall.
Unprivileged code on an SVA-bound device can cause invalid page
requests. Timing: not a race; missing response every time RX=0.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **Device/PRI hang (HIGH), not a kernel panic.** Unacked PRI
consumes outstanding page-request slots (PRI enable uses 32 outstanding
in `pdev_enable_cap_pri()`). Device DMA can stall; GPU/compute jobs
hang. Matches stable-rules “hang” / hardware protocol failure. Reporter
is AMD — they saw it.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit: high** for AMD PRI/SVA users (prevents stuck page-request
  state).
- **Risk: low** (~30 lines, existing helper, same IRQ-thread context as
  PPR completion, no lock-order novelty vs `report_page_fault`).
- **Ratio:** favorable. Worst extra load is queuing COMPLETE_PPR under a
  PPR flood; spec requires that, and command-buffer timeout already
  exists.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real spec bug: missing `CMD_COMPLETE_PPR` for INV_PPR_REQ with RX=0.
- User-visible hang (PRI/DMA stall), reported by AMD.
- Buggy log-only path exists in this 6.12 tree; completion helper
  already here.
- Small, obviously correct, uses existing `amd_iommu_complete_ppr()`.
- Reviewed by AMD; SOB from Joerg Roedel.
- Intel already answers invalid PRQ the same way.
- No new APIs/features.

**AGAINST:**
- Not a kernel oops/UAF; only PRI-capable AMD devices.
- Series follow-ups 4 (ratelimit) and 5 (GN bit) are not in this commit;
  5 says `pri_tlp` is the wrong GN source — but that is **already** how
  6.12 completes all PPRs.
- Corner-case still skips completion without `pdev`/priv.
- No Fixes:/Cc: stable (not a negative per pipeline rules).

**UNRESOLVED:**
- Exact mainline SHA (`b4 dig -c` not possible without it).
- Stable-list discussion (lore 403).
- Whether a v2 addressed Ankit’s always-complete suggestion (committed
  diff matches v1).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — spec-aligned; AMD-
   developed/reviewed; Joerg SOB. (Tested-by not in message; author +
   reviewer are the hardware vendor.)
2. Fixes a real bug that affects users? **PASS** — unacked invalid PPR;
   Reported-by AMD.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   hang / hardware protocol stall (HIGH), not cosmetic.
4. Small and contained? **PASS** — ~30 lines, two files, one driver.
5. No new features or APIs? **PASS** — uses existing complete-PPR
   command.
6. Can apply to the local tree? **PASS** — buggy code and helpers
   present; apply should be clean or trivial context.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/doc exception. Qualifies as a
**normal hang/protocol bug fix**.

**Step 9.4: MAKE YOUR DECISION**

This should be backported to **this** 6.12.y tree. The INV_PPR_REQ
handler has never sent COMPLETE_PPR; 6.12 already has PRI/PPR completion
for the PPR log. The patch is small, uses that helper, and prevents
device-side PRI stalls on AMD IOMMU.

The problem is a missing hardware response, not a new feature. Stable
users with AMD IOMMU + PRI/SVA can hang outstanding page requests; the
fix is ~30 lines and matches code already used from `ppr.c`. Patch 5 (GN
bit) is a separate improvement already latent in 6.12’s `pri_tlp` usage
and is not required for this commit to help.

Verification:
- [Phase 1] Parsed tags: Reported-by Gaultier Delbarre (AMD); Co-
  developed-by Wei Huang; SOB Vasant Hegde + Joerg Roedel; Reviewed-by
  Ankit Soni; no Fixes/Cc:stable/syzbot.
- [Phase 2] Diff: +EVENT_FLAG_PPR_RX; new amd_iommu_report_ppr_err();
  INV_PPR_REQ calls complete_ppr on RX=0; ~33/-6 lines.
- [Phase 3] git blame 973-979 iommu.c: e7f63ffc1bf19 (2018) introduced
  log-only INV_PPR_REQ.
- [Phase 3] 978d626b8f1a2 is ancestor of HEAD (`git merge-base --is-
  ancestor` succeeded); amd_iommu_complete_ppr exists at iommu.c:1827.
- [Phase 3] git log --oneline --grep=CMD_COMPLETE_PPR --
  drivers/iommu/amd/: empty (fix not in this tree).
- [Phase 3] Series patch 1 already present: 5a5cd58b1533e.
- [Phase 4] Ratatoskr: series 0/5 17321955, patch 3 17321958, Ankit
  review 17327932 (corner case, no NAK).
- [Phase 4] b4 dig -c: **UNVERIFIED** (SHA not in tree). b4 mbox of
  26cfa307-… pulled the wrong thread.
- [Phase 4] lore.kernel.org and lore stable search: **UNVERIFIED** (HTTP
  403).
- [Phase 5] Callers: amd_iommu_int_thread_evtlog → iommu_poll_events →
  iommu_print_event (threaded IRQ). complete_ppr already used from ppr.c
  in the PPR IRQ thread.
- [Phase 5] Intel analog: handle_bad_prq_event() in
  drivers/iommu/intel/prq.c submits QI page-group response.
- [Phase 6] git describe HEAD: p-6.12-3-gc504cf0baa3d8; make
  kernelversion: 6.12.111; buggy INV_PPR_REQ case present;
  EVENT_FLAG_PPR_RX absent.
- [Phase 6] 6.12 iommu_print_event lacks later `ctrl` MMIO read;
  INV_PPR_REQ hunk still matches.
- [Phase 7] Subsystem drivers/iommu/amd, IMPORTANT, actively maintained.
- [Phase 8] Failure mode: unacked PRI → device hang; severity HIGH;
  trigger AMD PPR/PRI hardware.
- UNVERIFIED: mainline SHA; v2 of series; stable@ discussion.

**YES**

 drivers/iommu/amd/amd_iommu_types.h |  1 +
 drivers/iommu/amd/iommu.c           | 38 ++++++++++++++++++++++++-----
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index dee077bd149b7..5f43a0fcdd1e3 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -158,6 +158,7 @@
 #define EVENT_FLAGS_SHIFT	0x10
 #define EVENT_FLAG_RW		0x020
 #define EVENT_FLAG_I		0x008
+#define EVENT_FLAG_PPR_RX	0x001
 
 /* feature control bits */
 #define CONTROL_IOMMU_EN	0
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e64e6da08a5f7..49587eafc0a8f 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -883,10 +883,40 @@ static void amd_iommu_report_page_fault(struct amd_iommu *iommu,
 		pci_dev_put(pdev);
 }
 
+static void amd_iommu_report_ppr_err(struct amd_iommu *iommu, volatile u32 *event,
+				     u16 devid, u64 address, int flags)
+{
+	struct pci_dev *pdev;
+	struct device *dev = iommu->iommu.dev;
+	u32 pasid = PPR_PASID(*((u64 *)event));
+	int tag = event[1] & 0x03FF;
+
+	dev_err(dev, "Event logged [INVALID_PPR_REQUEST device=%04x:%02x:%02x.%x pasid=0x%05x address=0x%llx flags=0x%04x tag=0x%03x]\n",
+		iommu->pci_seg->id, PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+		pasid, address, flags, tag);
+
+	/* Skip COMPLETE_PPR_REQUEST response if RX=1 */
+	if (flags & EVENT_FLAG_PPR_RX)
+		return;
+
+	pdev = pci_get_domain_bus_and_slot(iommu->pci_seg->id, PCI_BUS_NUM(devid),
+					   devid & 0xff);
+	if (!pdev)
+		return;
+
+	if (!dev_iommu_priv_get(&pdev->dev)) {
+		pci_dev_put(pdev);
+		return;
+	}
+
+	amd_iommu_complete_ppr(&pdev->dev, pasid, IOMMU_PAGE_RESP_FAILURE, tag);
+	pci_dev_put(pdev);
+}
+
 static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 {
 	struct device *dev = iommu->iommu.dev;
-	int type, devid, flags, tag;
+	int type, devid, flags;
 	volatile u32 *event = __evt;
 	int count = 0;
 	u64 address, ctrl;
@@ -960,11 +990,7 @@ static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 		amd_iommu_report_rmp_hw_error(iommu, event);
 		break;
 	case EVENT_TYPE_INV_PPR_REQ:
-		pasid = PPR_PASID(*((u64 *)__evt));
-		tag = event[1] & 0x03FF;
-		dev_err(dev, "Event logged [INVALID_PPR_REQUEST device=%04x:%02x:%02x.%x pasid=0x%05x address=0x%llx flags=0x%04x tag=0x%03x]\n",
-			iommu->pci_seg->id, PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-			pasid, address, flags, tag);
+		amd_iommu_report_ppr_err(iommu, event, devid, address, flags);
 		break;
 	default:
 		dev_err(dev, "Event logged [UNKNOWN event[0]=0x%08x event[1]=0x%08x event[2]=0x%08x event[3]=0x%08x\n",
-- 
2.53.0

