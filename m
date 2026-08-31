Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2288F572672;
	Mon, 31 Aug 2026 13:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184132; cv=none; b=qXba0rTC3XA3YJ5peX8ial6VY2cqqqEtu0Vn3k9hzgMh8kBDyl+gNDrt56xv4Mq5m2ApHwz9Zd90EG2YzFRI2nnBa02QZYzEiRm11RF01DzQfWfuG4qbHRvvzJ3SKkBtJM8S3Z5fyRXkKnWxEF2NSB7Ii2WC6cNMUJ8LYURAPNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184132; c=relaxed/simple;
	bh=1KeNuuyqLcH9vUjKg/oWgSfTXZZDy1XWtee9MW4S4e8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jRdRp1LzTXJmQEtfuWWu5g60wC83bLm5BthXSNvBCSvKmiQDamPDgvU6ZJkJJWKyjGYqOkkua1eu3JGkBd02gKtZgWU487M7fD1qXsiXuDb2sFXfmp7U9V2eSgW7gi/lVYCZS4D1eb5TApF0b2PIWmennX1OqSSCkL2KVUcnKiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HrQRVHJy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HrQRVHJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A9B1F00ACA;
	Mon, 31 Aug 2026 13:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184129;
	bh=4XpzPWRoQGI3w2t017OesPnubq7Sn2y171fQixsOjZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HrQRVHJyzY9YgtSfeTNq05FH2Zeqq4fniuB8E8FMDYbcXRFNlldeItVxO4G6FQ2lq
	 ndOdgYcG5IL40zYvozlGRYIDVZy9N/1kuNVIEyl5v8UVvnn1pZ1Um+tJy3NYkQyNzL
	 tdz+xzFa+FMx1HXG6dohxPop0IpH4qfcpdQxpmcloY/6Nsndc7vMxbbE80tTKjQy5+
	 /IRSikofYTJ9IaOkfYvX6lamJtN4gWpJmhDFaFGqGXiJJO8/uK7ioAbOR0JxCjP6hy
	 pXu/rjBz1U2Vda59rANLLHJNohhIpZt9VIWlg1wUTeI0T9iDthPVZ1WfLEmvwgXOKw
	 gRgRghuBP1VRg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yunxiang Li <Yunxiang.Li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu/ras: add ras_suspend callback and use it for cp_ecc_error_irq
Date: Mon, 31 Aug 2026 09:28:57 -0400
Message-ID: <20260831133314.4125787-509-sashal@kernel.org>
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

From: Yunxiang Li <Yunxiang.Li@amd.com>

[ Upstream commit e3829992dd9fa0a82511af4f01733fc854cd15a5 ]

cp_ecc_error_irq is acquired in amdgpu_gfx_ras_late_init() but
released in gfx_v9_0_hw_fini(), so the put site has to query
amdgpu_irq_enabled() because the get is skipped on SR-IOV VF.

ras_late_init / ras_fini have no suspend counterpart, so move the
put to amdgpu_gfx_ras_suspend() / amdgpu_gfx_ras_fini() and add a
matching ras_suspend callback that is invoked from
amdgpu_ras_suspend() before disable_all_features().  The get and
put now sit in the same place and check the same condition (not
VF, funcs registered), no refcount querying needed.

An active flag gates ras_fini so the
suspend-then-unload-without-resume path falls into
amdgpu_ras_block_late_fini_default() instead of double-releasing
what ras_suspend already cleaned up.

Drop the cp_ecc_error_irq put from gfx_v9_0_hw_fini().  gfx_v8_0
manages cp_ecc_error_irq locally and is unaffected; no other GFX
generation has this IRQ.

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/amdgpu/ras: add ras_suspend callback
and use it for cp_ecc_error_irq`

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`)
**Upstream commit:** `e3829992dd9fa` (not present in this tree; cherry-
pick applies cleanly)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject parse**
Record: `[drm/amdgpu/ras]` — **add** (lifecycle fix disguised as
infrastructure) — add `ras_suspend` callback and relocate
`cp_ecc_error_irq` put to match its get site.

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>` (author)
- `Acked-by: Alex Deucher <alexander.deucher@amd.com>` (subsystem
  maintainer)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (committer)
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable@vger.kernel.org`,
  `Tested-by:`, or `Reviewed-by:`

Notable: maintainer Ack from Alex Deucher is a strong quality signal.

**Step 1.3 — Body analysis**
Record:
- **Bug:** `cp_ecc_error_irq` is acquired in
  `amdgpu_gfx_ras_late_init()` but released in `gfx_v9_0_hw_fini()`,
  with mismatched conditions (get skipped on SR-IOV VF; put uses broader
  RAS-support check).
- **Symptom:** `amdgpu_irq_put()` called when IRQ was never acquired →
  `WARN_ON(!amdgpu_irq_enabled())` in `amdgpu_irq.c:637`.
- **Root cause:** No suspend counterpart to `ras_late_init`/`ras_fini`;
  get/put live in different subsystems with different guards.
- **Fix approach:** Add `ras_suspend` callback, move put to
  `amdgpu_gfx_ras_suspend()`/`amdgpu_gfx_ras_fini()` with matching `!VF
  && funcs` condition; add `active` flag to avoid double-release on
  suspend-then-unload path.

**Step 1.4 — Hidden bug fix?**
Record: **Yes.** Despite "add callback" wording, this is a reference-
counting / lifecycle bug fix. It corrects asymmetric IRQ get/put that
can trigger kernel warnings and incorrect teardown ordering.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record:
| File | Change |
|------|--------|
| `amdgpu_gfx.c` | +26/-4 |
| `amdgpu_gfx.h` | +3/-1 |
| `amdgpu_ras.c` | +32/-4 |
| `amdgpu_ras.h` | +1 |
| `gfx_v9_0.c` | -2 |
| **Total** | +53/-11, 5 files |

Functions modified: `amdgpu_gfx_ras_late_init`, new
`amdgpu_gfx_ras_suspend`, new `amdgpu_gfx_ras_fini`,
`amdgpu_gfx_ras_sw_init`, `amdgpu_ras_suspend`, `amdgpu_ras_late_init`,
`amdgpu_ras_fini`, `gfx_v9_0_hw_fini`.

Scope: **single-subsystem, surgical** (amdgpu RAS/GFX9).

**Step 2.2 — Code flow per hunk**

| Hunk | Before → After |
|------|----------------|
| `amdgpu_gfx_ras_late_init` | VF early-return then separate `irq_get` →
combined `!VF && funcs` guard for `irq_get` |
| New `amdgpu_gfx_ras_suspend` | No suspend cleanup → `irq_put` with
same guard as get |
| New `amdgpu_gfx_ras_fini` | No gfx-specific fini (header-only orphan
declaration) → `irq_put` + `amdgpu_ras_block_late_fini` |
| `amdgpu_gfx_ras_sw_init` | Only sets `ras_late_init` → also sets
default `ras_suspend` and `ras_fini` |
| `amdgpu_ras_suspend` | Only disables RAS features → iterates blocks,
calls `ras_suspend`, clears `active` |
| `amdgpu_ras_late_init` | No tracking → sets `node->active = true`
after successful late_init |
| `amdgpu_ras_fini` | Always calls custom `ras_fini` if supported →
gated by `ras_node->active` to avoid double-cleanup after suspend |
| `gfx_v9_0_hw_fini` | `irq_put(cp_ecc_error_irq)` if RAS supported →
removed (now handled in RAS layer) |

**Step 2.3 — Bug mechanism**
Record: **Reference counting / resource lifecycle bug.**
- Get: `amdgpu_irq_get()` in `amdgpu_gfx_ras_late_init()` — only when
  `!amdgpu_sriov_vf(adev) && cp_ecc_error_irq.funcs`.
- Put (current tree): `amdgpu_irq_put()` in `gfx_v9_0_hw_fini()` — when
  `amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__GFX)` only.
- On SR-IOV VF with RAS telemetry enabled, late_init runs (see
  `amdgpu_ras_late_init` VF check) but gfx `irq_get` is skipped; hw_fini
  still calls `irq_put` before the VF early-return → `WARN_ON` in
  `amdgpu_irq_put()`.

**Step 2.4 — Fix quality**
Record: Fix is **obviously correct** — symmetric get/put with identical
conditions, proper suspend hook, `active` flag prevents double-release.
Minimal regression risk: no blocks currently register custom `ras_fini`
in this tree (verified via grep), so the `active` flag behavior only
affects the newly registered gfx callbacks.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**
Record:
- `gfx_v9_0_hw_fini` put lines: `d97b02bb9c7aa` (May 2023) — prior fix
  for put-without-get when legacy GFX RAS disabled; did not fix VF
  condition mismatch.
- `irq_get` in `amdgpu_gfx_ras_late_init`: `6caeee7a708c0` (Sep 2019).
- Buggy asymmetric lifecycle present since **v5.x** era; still present
  in **6.18.44**.

**Step 3.2 — Fixes: tag**
Record: Not applicable (no `Fixes:` tag). Related prior fix
`d97b02bb9c7aa` is in this tree but incomplete for the VF/get-put
mismatch.

**Step 3.3 — File history**
Record: Part of 2-patch series `[PATCH 0/2] drm/amdgpu: balance GFX IRQ
get/put across init/suspend/fini`. This commit is **patch 1/2** and is
**self-contained** for `cp_ecc_error_irq`. Patch 2/2 (`9117d8be850ba` on
master) addresses fault/EOP IRQs separately and is **not a
prerequisite**.

**Step 3.4 — Author context**
Record: Yunxiang Li is an AMD contributor. Alex Deucher (maintainer)
Acked and committed.

**Step 3.5 — Dependencies**
Record: **Standalone.** Cherry-pick to 6.18.44 applies cleanly with
auto-merge. No prerequisite commits required.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original discussion**
Record:
- URL:
  https://patch.msgid.link/20260527233504.1830940-2-Yunxiang.Li@amd.com
- Series: v1 only (no v2/v3 revisions found)
- Patch 1/2 of 2-patch series

**Step 4.2 — Reviewers**
Record: CC'd to `amd-gfx@lists.freedesktop.org`, Alex Deucher, Christian
König. Alex Deucher Acked.

**Step 4.3 — Bug report**
Record: No external bug report or syzbot link. Mechanism is documented
in commit message; similar prior bug (`d97b02bb9c7aa`) had stack trace
from `gfx_v9_0_hw_fini` → `amdgpu_irq_put` during suspend.

**Step 4.4 — Related patches**
Record: Patch 2/2 (`drm/amdgpu/gfx: move fault and EOP IRQ get/put to
hw_init/hw_fini`) is independent. Not required for this fix.

**Step 4.5 — Stable list history**
Record: No `Cc: stable` nomination found in thread. Not a negative
signal per instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**
Record: `amdgpu_gfx_ras_late_init`, `amdgpu_gfx_ras_suspend`,
`amdgpu_gfx_ras_fini`, `amdgpu_ras_suspend`, `amdgpu_ras_late_init`,
`amdgpu_ras_fini`, `gfx_v9_0_hw_fini`, `amdgpu_irq_get`,
`amdgpu_irq_put`.

**Step 5.2 — Callers**
Record:
- `amdgpu_ras_suspend` ← `amdgpu_device_suspend()` (line 5261) —
  **system suspend path**
- `gfx_v9_0_hw_fini` ← `gfx_v9_0_suspend` ← `amdgpu_ip_block_suspend` ←
  `amdgpu_device_ip_suspend_phase2` — **suspend and driver unload**
- `amdgpu_ras_late_init` ← `amdgpu_device_ip_late_init` — boot and
  **resume** (line 5365)
- `amdgpu_ras_fini` ← `amdgpu_device_ip_fini` — driver unload

**Step 5.3 — Key callees**
Record: `amdgpu_irq_get/put` (atomic refcount on `enabled_types`),
`amdgpu_ras_block_late_fini`, `amdgpu_ras_disable_all_features`.

**Step 5.4 — Reachability**
Record: **Yes, reachable from normal operations:**
- System suspend/resume (laptop, server)
- SR-IOV VF with RAS telemetry
- Driver unload after suspend (no resume)
- Config: `CONFIG_DRM_AMDGPU` + GFX9 hardware + RAS enabled

**Step 5.5 — Similar patterns**
Record: Prior fix `d97b02bb9c7aa` addressed same `amdgpu_irq_put` WARN
class for different condition (`amdgpu_ras_is_supported` vs actually
enabled). Patch 2/2 in the series addresses similar get/put split for
other GFX IRQs.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

**Step 6.1 — Buggy code exists?**
Record: **Yes.** Current 6.18.44 tree has:
- `irq_get` in `amdgpu_gfx_ras_late_init` with VF skip (lines 937-943)
- `irq_put` in `gfx_v9_0_hw_fini` with only `amdgpu_ras_is_supported`
  guard (lines 4087-4088)
- No `ras_suspend` callback infrastructure
- Orphan `amdgpu_gfx_ras_fini` declaration in header with no
  implementation

**Step 6.2 — Backport complications**
Record: **Clean apply** — tested via `git cherry-pick --no-commit
e3829992dd9fa`, auto-merged all 5 files.

**Step 6.3 — Related fixes already present?**
Record: `d97b02bb9c7aa` (partial fix) is in tree. This commit is not
duplicated; it completes the lifecycle fix.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 — Subsystem criticality**
Record: `drivers/gpu/drm/amd/amdgpu` — **IMPORTANT** (AMD GPU driver,
widely deployed on desktops, laptops, servers, cloud VF).

**Step 7.2 — Activity**
Record: Actively maintained; RAS subsystem receives regular fixes in
6.18.y.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 — Who is affected**
Record: Users of **AMD GFX9 GPUs** with **RAS enabled** — especially
**SR-IOV virtual functions** with RAS telemetry, and any system using
suspend/resume with RAS.

**Step 8.2 — Trigger conditions**
Record:
- SR-IOV VF + RAS telemetry + suspend → **high likelihood** of
  `amdgpu_irq_put` WARN
- Suspend → unload without resume with new `ras_fini` → potential double
  `irq_put` without `active` flag
- Non-VF suspend/resume works today but has architectural fragility

**Step 8.3 — Failure mode severity**
Record: `WARN_ON` in `amdgpu_irq_put` during suspend — **MEDIUM**
(kernel warning, incorrect IRQ state; not typically a panic but
indicates broken refcounting). Suspend-then-unload double-release —
**MEDIUM-HIGH** (refcount underflow / further WARNs).

**Step 8.4 — Risk-benefit**
Record:
- **Benefit:** HIGH for enterprise VF/cloud; MEDIUM for general amdgpu
  suspend users
- **Risk:** LOW — 53 lines, localized, maintainer-acked, applies
  cleanly, no custom `ras_fini` handlers exist in tree to be disrupted
- **Ratio:** Favorable

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence summary**

| FOR backport | AGAINST backport |
|---|---|
| Fixes real refcounting/lifecycle bug | Part of 2-patch series (but
patch 1 is self-contained) |
| Triggerable on suspend (common path) | No syzbot/user report attached
|
| SR-IOV VF path clearly broken in current code | WARN severity, not
panic |
| Maintainer Acked-by Alex Deucher | |
| Applies cleanly to 6.18.44 | |
| Small, contained (53 lines) | |
| Similar prior fix (`d97b02`) was stable material | |
| Resume path re-acquires via `amdgpu_ras_late_init` in
`amdgpu_device_resume` | |

**Step 9.2 — Stable rules checklist**

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — symmetric lifecycle,
maintainer ack; no explicit Tested-by |
| 2. Fixes real bug affecting users? | **PASS** — VF suspend WARN,
suspend/unload edge case |
| 3. Important issue? | **PASS** — MEDIUM severity (WARN, IRQ refcount
corruption class) |
| 4. Small and contained? | **PASS** — 5 files, 53 insertions |
| 5. No new features/APIs? | **PASS** — internal driver callback only |
| 6. Can apply to local tree? | **PASS** — clean cherry-pick verified |

**Step 9.3 — Exception categories**
Record: None (not device ID, quirk, DT, build fix, or docs).

**Step 9.4 — Decision rationale**
This commit fixes a longstanding asymmetric IRQ lifecycle in the amdgpu
RAS/GFX9 path that can trigger `WARN_ON` during system suspend on SR-IOV
VFs and creates fragile teardown on suspend-then-unload. The fix is
small, maintainer-reviewed, applies cleanly to 6.18.44, and the affected
code is present in this tree. The benefit outweighs the low regression
risk.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified hidden refcounting
  bug
- [Phase 2] Analyzed all 5 file diffs; classified as reference-
  counting/lifecycle fix
- [Phase 3] `git blame` on `gfx_v9_0.c:4087-4088` → `d97b02bb9c7aa`
  (2023); `irq_get` introduced `6caeee7a708c0` (2019); both ancestors in
  tree
- [Phase 3] `git log --grep` found commit `e3829992dd9fa` on
  `origin/master`; not ancestor of HEAD (not in 6.18.44)
- [Phase 3] Confirmed patch 1/2 is standalone; patch 2/2
  (`9117d8be850ba`) is separate
- [Phase 4] `b4 dig -c e3829992dd9fa` →
  https://patch.msgid.link/20260527233504.1830940-2-Yunxiang.Li@amd.com
- [Phase 4] `b4 dig -a` → v1 only
- [Phase 4] `b4 dig -w` → CC: amd-gfx, Alex Deucher, Christian König
- [Phase 4] No stable nomination in thread
- [Phase 5] Traced callers: `amdgpu_device_suspend` →
  `amdgpu_ras_suspend`; `gfx_v9_0_suspend` → `gfx_v9_0_hw_fini`
- [Phase 5] Read `amdgpu_irq_put` at `amdgpu_irq.c:637` —
  `WARN_ON(!amdgpu_irq_enabled())`
- [Phase 5] Grep: no `.ras_fini =` assignments in tree (no custom
  ras_fini handlers)
- [Phase 6] `git describe HEAD` → v6.18.44; buggy code confirmed at
  `amdgpu_gfx.c:937-943`, `gfx_v9_0.c:4087-4088`
- [Phase 6] `git cherry-pick --no-commit e3829992dd9fa` → clean auto-
  merge on all 5 files
- [Phase 6] `amdgpu_device_resume` calls `amdgpu_device_ip_late_init` →
  `amdgpu_ras_late_init` (re-acquires IRQ on resume)
- [Phase 8] Failure mode: WARN_ON during VF suspend — MEDIUM severity

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 26 ++++++++++++++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h |  3 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 32 +++++++++++++++++++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h |  1 +
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c   |  2 --
 5 files changed, 53 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index 40e7482980692..46c0b986db51d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -934,10 +934,7 @@ int amdgpu_gfx_ras_late_init(struct amdgpu_device *adev, struct ras_common_if *r
 		if (r)
 			return r;
 
-		if (amdgpu_sriov_vf(adev))
-			return r;
-
-		if (adev->gfx.cp_ecc_error_irq.funcs) {
+		if (!amdgpu_sriov_vf(adev) && adev->gfx.cp_ecc_error_irq.funcs) {
 			r = amdgpu_irq_get(adev, &adev->gfx.cp_ecc_error_irq, 0);
 			if (r)
 				goto late_fini;
@@ -952,6 +949,21 @@ int amdgpu_gfx_ras_late_init(struct amdgpu_device *adev, struct ras_common_if *r
 	return r;
 }
 
+void amdgpu_gfx_ras_suspend(struct amdgpu_device *adev,
+			    struct ras_common_if *ras_block)
+{
+	if (!amdgpu_sriov_vf(adev) && adev->gfx.cp_ecc_error_irq.funcs)
+		amdgpu_irq_put(adev, &adev->gfx.cp_ecc_error_irq, 0);
+}
+
+void amdgpu_gfx_ras_fini(struct amdgpu_device *adev,
+			 struct ras_common_if *ras_block)
+{
+	if (!amdgpu_sriov_vf(adev) && adev->gfx.cp_ecc_error_irq.funcs)
+		amdgpu_irq_put(adev, &adev->gfx.cp_ecc_error_irq, 0);
+	amdgpu_ras_block_late_fini(adev, ras_block);
+}
+
 int amdgpu_gfx_ras_sw_init(struct amdgpu_device *adev)
 {
 	int err = 0;
@@ -980,6 +992,12 @@ int amdgpu_gfx_ras_sw_init(struct amdgpu_device *adev)
 	if (!ras->ras_block.ras_late_init)
 		ras->ras_block.ras_late_init = amdgpu_gfx_ras_late_init;
 
+	if (!ras->ras_block.ras_suspend)
+		ras->ras_block.ras_suspend = amdgpu_gfx_ras_suspend;
+
+	if (!ras->ras_block.ras_fini)
+		ras->ras_block.ras_fini = amdgpu_gfx_ras_fini;
+
 	/* If not defined special ras_cb function, use default ras_cb */
 	if (!ras->ras_block.ras_cb)
 		ras->ras_block.ras_cb = amdgpu_gfx_process_ras_data_cb;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
index fb5f7a0ee029f..8949037b62a43 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
@@ -603,7 +603,8 @@ void amdgpu_gfx_off_ctrl(struct amdgpu_device *adev, bool enable);
 void amdgpu_gfx_off_ctrl_immediate(struct amdgpu_device *adev, bool enable);
 int amdgpu_get_gfx_off_status(struct amdgpu_device *adev, uint32_t *value);
 int amdgpu_gfx_ras_late_init(struct amdgpu_device *adev, struct ras_common_if *ras_block);
-void amdgpu_gfx_ras_fini(struct amdgpu_device *adev);
+void amdgpu_gfx_ras_suspend(struct amdgpu_device *adev, struct ras_common_if *ras_block);
+void amdgpu_gfx_ras_fini(struct amdgpu_device *adev, struct ras_common_if *ras_block);
 int amdgpu_get_gfx_off_entrycount(struct amdgpu_device *adev, u64 *value);
 int amdgpu_get_gfx_off_residency(struct amdgpu_device *adev, u32 *residency);
 int amdgpu_set_gfx_off_residency(struct amdgpu_device *adev, bool value);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 4c1a65fffede7..16ae44e131ad4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -92,6 +92,9 @@ struct amdgpu_ras_block_list {
 	struct list_head node;
 
 	struct amdgpu_ras_block_object *ras_obj;
+
+	/* set by ras_late_init, cleared by ras_suspend/ras_fini */
+	bool active;
 };
 
 const char *get_ras_block_str(struct ras_common_if *ras_block)
@@ -4392,10 +4395,23 @@ void amdgpu_ras_resume(struct amdgpu_device *adev)
 void amdgpu_ras_suspend(struct amdgpu_device *adev)
 {
 	struct amdgpu_ras *con = amdgpu_ras_get_context(adev);
+	struct amdgpu_ras_block_list *node;
+	struct amdgpu_ras_block_object *obj;
 
 	if (!adev->ras_enabled || !con)
 		return;
 
+	/* run per-block ras_suspend before tearing down the RAS context */
+	list_for_each_entry(node, &adev->ras_list, node) {
+		if (!node->active)
+			continue;
+
+		obj = node->ras_obj;
+		if (obj && obj->ras_suspend)
+			obj->ras_suspend(adev, &obj->ras_comm);
+		node->active = false;
+	}
+
 	amdgpu_ras_disable_all_features(adev, 0);
 	/* Make sure all ras objects are disabled. */
 	if (AMDGPU_RAS_GET_FEATURES(con->features))
@@ -4449,8 +4465,15 @@ int amdgpu_ras_late_init(struct amdgpu_device *adev)
 					obj->ras_comm.name, r);
 				return r;
 			}
-		} else
-			amdgpu_ras_block_late_init_default(adev, &obj->ras_comm);
+		} else {
+			r = amdgpu_ras_block_late_init_default(adev, &obj->ras_comm);
+			if (r) {
+				dev_err(adev->dev, "%s failed to execute ras_block_late_init_default! ret:%d\n",
+					obj->ras_comm.name, r);
+				return r;
+			}
+		}
+		node->active = true;
 	}
 
 	return 0;
@@ -4487,11 +4510,12 @@ int amdgpu_ras_fini(struct amdgpu_device *adev)
 	list_for_each_entry_safe(ras_node, tmp, &adev->ras_list, node) {
 		if (ras_node->ras_obj) {
 			obj = ras_node->ras_obj;
-			if (amdgpu_ras_is_supported(adev, obj->ras_comm.block) &&
-			    obj->ras_fini)
+			/* fall back to default cleanup if ras_suspend already ran */
+			if (ras_node->active && obj->ras_fini)
 				obj->ras_fini(adev, &obj->ras_comm);
 			else
 				amdgpu_ras_block_late_fini_default(adev, &obj->ras_comm);
+			ras_node->active = false;
 		}
 
 		/* Clear ras blocks from ras_list and free ras block list node */
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
index 6cf0dfd38be8b..8160c4d598543 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
@@ -731,6 +731,7 @@ struct amdgpu_ras_block_object {
 	int (*ras_block_match)(struct amdgpu_ras_block_object *block_obj,
 				enum amdgpu_ras_block block, uint32_t sub_block_index);
 	int (*ras_late_init)(struct amdgpu_device *adev, struct ras_common_if *ras_block);
+	void (*ras_suspend)(struct amdgpu_device *adev, struct ras_common_if *ras_block);
 	void (*ras_fini)(struct amdgpu_device *adev, struct ras_common_if *ras_block);
 	ras_ih_cb ras_cb;
 	const struct amdgpu_ras_block_hw_ops *hw_ops;
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index c5549a5abcd43..9d7214bcaadb9 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -4084,8 +4084,6 @@ static int gfx_v9_0_hw_fini(struct amdgpu_ip_block *ip_block)
 {
 	struct amdgpu_device *adev = ip_block->adev;
 
-	if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__GFX))
-		amdgpu_irq_put(adev, &adev->gfx.cp_ecc_error_irq, 0);
 	amdgpu_irq_put(adev, &adev->gfx.priv_reg_irq, 0);
 	amdgpu_irq_put(adev, &adev->gfx.priv_inst_irq, 0);
 	amdgpu_irq_put(adev, &adev->gfx.bad_op_irq, 0);
-- 
2.53.0

