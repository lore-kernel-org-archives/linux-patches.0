Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ADC45BD4B;
	Mon, 31 Aug 2026 13:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183871; cv=none; b=q1AMydEgNo5TgFzOhNafaZ0hamG8Arrofp1Pm/OGsQjUrcuSuGr8XV1F9s87ecTsSqtbqiqg5WYy/g/D3YxXF5fegUv0h6aB8FnMQKtVQjYYDSxXiYM5Y4TSri9xifI6vrp2fc3JeD7g2eLb4gKtIHJj4h5rVqIkB89aqAmEDxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183871; c=relaxed/simple;
	bh=Ao37EIblClKsI64UZh4Rf9c3dxPcaTaWgJgo2jQolik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QVlZS4Od721W7M+oPfdb4aWsagVTERXttk6sHIzin6nydDnBbPo59kTH+XM7fIgtnSAvoE0qTsHJDpTVYiHZ58Lx0qlNN/C/bWY4nyaZ0X7bqlPgUc55cdy3r5cQmrbB6mqMyW6VKGjU8UwHn3h3fSc5Naay8x6ZZ2wd4Tr35uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bx+aaz9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bx+aaz9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CCC1F00ADE;
	Mon, 31 Aug 2026 13:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183868;
	bh=pf4ekvd+NEY5JRo6Eblbsd81JMP2cKd6vW/zi5iBGsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bx+aaz9nHhkBpGa5xWfv3n7LQ7ysIEkP0sOVQagFKPcxUNiAXHJSWoZvBCZ/cEqe7
	 N5ebTjqc3ODCICDFVpp+D8Wc/Ktqzzp3XgHUFU5A54rlSLvSSuhWyYs5w6ZSPA3B31
	 SLWQs4LXM2ZRq9vRUzcPM+q/QE+7v8Cv3qD0Mpo4FRti3TrTLJmvBydu3A6RFSb6Og
	 ff78H6GmJLhKuP397owtGivchW753jAIiyWwwfxCtI6a2/vhltSCurnGSiLodh5NfI
	 UzIJtLc07vJhgLg4LAhnwbJyORK1JJeGajJy8j9kZKjToiTx6ZrCNBkB+lO/IjFCt5
	 2UwGg1zWOlI5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] drm/amdgpu: Use system unbound workqueue for soft IH ring
Date: Mon, 31 Aug 2026 09:26:19 -0400
Message-ID: <20260831133314.4125787-351-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit ba2977dcce72127986fbad76c4c67f134e2f69ae ]

Allow the kernel to dispatch the soft IH work on other CPUs.

Otherwise it can happen that the soft IH ring fills up
before it actually starts processing anything, which
can easily happen with retry page faults, in which case
the CP repeatedly spams the CPU with a lot of interrupts.

This significantly improves retry page fault handling on
GPUs that don't have the filter CAM and must rely on
software based filtering.

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3cdff3c8b93c2834977224d9c2b201fc334dd184)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: drm/amdgpu: Use system unbound workqueue for
soft IH ring

**Local tree:** `v6.18.44` (Makefile: 6.18.44)
**Fix commit:** `3cdff3c8b93c` (on `linux-next/master`, **not** an
ancestor of current HEAD — bug still present locally)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse subject line
**Record:** `[drm/amdgpu]` — no explicit verb; implied **fix/improve** —
**Use system unbound workqueue for soft IH ring**

### Step 1.2: Parse commit message tags
**Record:**
- **Reviewed-by:** Tvrtko Ursulin \<tvrtko.ursulin@igalia.com\>
- **Signed-off-by:** Timur Kristóf, Alex Deucher
- **No** Fixes:, Reported-by:, Tested-by:, Acked-by:, Link:, Cc:
  stable@vger.kernel.org
- Notable: Reviewed-by from Igalia amdgpu contributor; no syzbot/user
  bug report

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** Soft IH ring can fill before its work item runs; CP floods
  the CPU with interrupts during retry page faults.
- **Symptom:** Soft IH ring overflow / interrupt storm; degraded or
  broken retry page fault handling on GPUs without hardware filter CAM
  (software filtering only).
- **Root cause (author):** `schedule_work()` dispatches on a CPU-bound
  workqueue; work stays pinned on the IRQ CPU and cannot run while that
  CPU is saturated with interrupts.
- **Fix:** `queue_work(system_unbound_wq, ...)` allows processing on
  another CPU.
- **Version info:** None in message.

### Step 1.4: Detect hidden bug fixes
**Record:** **Yes — functional bug fix disguised as scheduling
improvement.** Ring fill-up before processing means dropped interrupt
vectors and failed page-fault handling, not merely slower performance.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory changes
**Record:**
- **Files:** `drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c` (+1 / −1)
- **Function:** `amdgpu_irq_delegate()`
- **Scope:** Single-file, single-line surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** `schedule_work(&adev->irq.ih_soft_work)` → queues on
  `system_wq` (CPU-bound).
- **After:** `queue_work(system_unbound_wq, &adev->irq.ih_soft_work)` →
  can run on any CPU.
- **Path:** Called from `amdgpu_irq_delegate()` after writing an IV to
  the soft IH ring; triggered during retry page faults on GPUs using
  software filtering (gmc_v9/v10/v11/v12).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / scheduling deadlock (interrupt storm + work
  starvation).
- **Mechanism:** IRQ handler delegates to soft IH ring and schedules
  bound work on the same CPU. Under retry page-fault storms, IRQs keep
  arriving before work runs; `amdgpu_ih_ring_write()` can reach `wptr ==
  rptr` and stop advancing the write pointer — IVs are written but not
  committed/processed.

### Step 2.4: Fix quality
**Record:**
- **Quality:** Obviously correct; mirrors existing amdgpu usage of
  `system_unbound_wq` in `amdgpu_reset.c`, `amdgpu_device.c`,
  `aldebaran.c`.
- **Regression risk:** Very low. `queue_work()` deduplicates already-
  queued work; same `work_struct` and handler unchanged.
- **No API, lock-order, or structural changes.**

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:**
- `amdgpu_irq_delegate()` introduced in `26f32a377eedd` (Oct 2020,
  Christian König) — soft IH infrastructure.
- `schedule_work()` line dates to that same commit; present in this tree
  since 6.18 base.
- Bug has existed since soft IH ring was added (~5.10+ era).

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:**
- Related: `bf80d34b6c58a` "Increase soft IH ring size" (symptom
  mitigation, not root cause).
- `318e431b306e9` "Enable IH retry CAM on GFX9" — hardware path; this
  fix targets GPUs **without** retry CAM.
- Part of series `[PATCH 3/3]` but **standalone** — patches 1/3 and 2/3
  touch different concerns (ih6.1 version, HW register access).

### Step 3.4: Author context
**Record:** Timur Kristóf — active amdgpu contributor; Alex Deucher
merged. Tvrtko Ursulin reviewed.

### Step 3.5: Dependencies
**Record:** **No dependencies.** One-line change; `system_unbound_wq` is
a core kernel symbol. Applies cleanly to current `amdgpu_irq.c`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **b4 dig URL:** https://patch.msgid.link/20260513170849.27061-4-
  timur.kristof@gmail.com
- **Series:** v1 only (May 13, 2026); committed version matches
  submission.
- **Review:** Reviewed-by: Tvrtko Ursulin in thread.
- **No** stable@vger nomination, NAKs, or objections found in mbox.

### Step 4.2: Reviewers
**Record:** CC'd: amd-gfx, Alex Deucher, Christian König, Marek Olšák,
Natalie Vock, Melissa Wen, amir.shetaia@amd.com.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Issue identified by
developer from retry page-fault behavior.

### Step 4.4: Related patches
**Record:** Same series includes patch 2/3 "Don't perturb HW registers
when accessing soft IH ring" — separate fix, not required for this one.

### Step 4.5: Stable list history
**Record:** Not searched separately; no stable nomination in patch
thread. Not a negative signal per instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `amdgpu_irq_delegate()`, `amdgpu_irq_handle_ih_soft()`,
`amdgpu_ih_ring_write()`, `amdgpu_ih_process()`

### Step 5.2: Callers of `amdgpu_irq_delegate()`
**Record:** Called from retry-fault paths in:
- `gmc_v9_0.c` (lines 589, 611)
- `gmc_v10_0.c` (line 128)
- `gmc_v11_0.c` (line 127)
- `gmc_v12_0.c` (line 120)

Triggered when `entry->ih == &adev->irq.ih` during retry page faults.

### Step 5.3: Callees
**Record:** `amdgpu_ih_ring_write()` writes IV to soft ring; work
handler calls `amdgpu_ih_process()` → `amdgpu_irq_dispatch()` → GMC
fault handler → `amdgpu_vm_handle_fault()`.

### Step 5.4: Reachability
**Record:**
- **Call chain:** HW IRQ → `amdgpu_irq_handler` → IH processing → GMC
  fault handler → `amdgpu_irq_delegate` → work scheduling.
- **Reachable:** Yes — normal GPU compute/HMM/SVM page-fault path on
  Navi/Vega/GFX9+ without hardware retry CAM.
- Only `vega20_ih.c` sets `retry_cam_enabled = true`; all other soft-IH
  GPUs use software filtering path.

### Step 5.5: Similar patterns
**Record:** amdgpu already uses `queue_work(system_unbound_wq, ...)` for
reset/XGMI work to avoid CPU pinning — same rationale.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy code in tree?
**Record:** **Yes.** `amdgpu_irq.c:515` still has
`schedule_work(&adev->irq.ih_soft_work)`. Soft IH infrastructure present
since 2020; retry page-fault delegation paths present in
gmc_v9/v10/v11/v12.

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — identical one-line substitution
at same location. No structural divergence in this function vs. linux-
next.

### Step 6.3: Related fixes already present?
**Record:** `bf80d34b6c58a` (increase soft IH ring size) is present —
mitigates but does not fix scheduling starvation. This fix is **not**
yet in 6.18.44.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/gpu/drm/amd/amdgpu** — IMPORTANT. Affects AMD GPU
users on compute and graphics workloads with recoverable page faults.

### Step 7.2: Subsystem activity
**Record:** Actively developed; interrupt and page-fault paths receive
frequent fixes in this tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** AMD GPU users on ASICs with soft IH ring and **without**
hardware retry CAM (most Navi, Vega10, GFX9, etc. — everything except
Vega20 in this tree). Config: `CONFIG_DRM_AMDGPU`.

### Step 8.2: Trigger conditions
**Record:**
- **When:** Retry page-fault storms (GPU compute, HMM, large sparse
  mappings).
- **Likelihood:** Can occur under normal heavy GPU workloads, not exotic
  edge case.
- **Unprivileged trigger:** Indirectly yes — userspace GPU workloads
  trigger page faults.

### Step 8.3: Failure mode severity
**Record:**
- Soft IH ring overflow → dropped interrupt vectors → page faults not
  handled.
- Interrupt storm → CPU saturation, possible soft lockup.
- GPU hang / application failure on affected workloads.
- **Severity: HIGH** (functional breakage + system responsiveness
  impact; not proven kernel panic but can cause hangs).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected AMD GPU users — restores correct retry
  page-fault handling.
- **Risk:** VERY LOW — one-line, established pattern, reviewed.
- **Ratio:** Strong benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real scheduling starvation bug causing soft IH ring overflow.
- Affects common AMD GPUs (Navi, Vega10, GFX9, etc.) on retry page
  faults.
- Can cause interrupt storms and broken page-fault recovery.
- One-line, obviously correct, reviewed.
- Bug present since 2020; code exists in 6.18.44.
- Standalone, no dependencies.

**AGAINST backport:**
- No user bug report or syzbot confirmation (developer-found).
- Patch 3/3 of a series (but functionally independent).
- Framed as "improves" handling — but mechanism is ring overflow /
  dropped IVs.

**Unresolved:** No quantitative data on how often users hit this in
production.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — reviewed, logical fix,
   established amdgpu pattern.
2. Fixes real bug affecting users? **PASS** — ring overflow and
   interrupt storm on retry page faults.
3. Important issue? **PASS** — HIGH: GPU hangs, CPU saturation, dropped
   fault handling.
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features/APIs? **PASS**.
6. Can apply to local tree? **PASS** — buggy code present; clean apply.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision rationale

For **6.18.y**, the soft IH ring and retry page-fault delegation code
are present and still use CPU-bound `schedule_work()`. Under retry page-
fault load on GPUs without hardware filter CAM, the soft IH work cannot
run on the IRQ-saturated CPU, the ring fills, IVs are dropped, and the
system can be flooded with interrupts. Switching to `system_unbound_wq`
is a minimal, reviewed fix already used elsewhere in amdgpu. This meets
stable criteria: real bug, important user impact, tiny contained change,
no new APIs.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; no Fixes:/Reported-
  by:/syzbot.
- **[Phase 2]** Diff: 1-line change in `amdgpu_irq_delegate()`; read
  `amdgpu_ih_ring_write()` overflow behavior (lines 162–169).
- **[Phase 3]** `git describe HEAD` → v6.18.44; `git blame` →
  `26f32a377eedd` (2020); `git merge-base --is-ancestor` → fix NOT in
  HEAD.
- **[Phase 3]** Related commits: `bf80d34b6c58a`, `318e431b306e9`,
  `26f32a377eedd`.
- **[Phase 4]** `b4 dig -c 3cdff3c` → lore URL; `b4 dig -a` → v1 series;
  `b4 dig -w` → maintainers CC'd; mbox → Reviewed-by Tvrtko Ursulin, no
  stable/NAK.
- **[Phase 5]** `grep amdgpu_irq_delegate` → 4 GMC files; `grep
  retry_cam_enabled` → only `vega20_ih.c` sets true.
- **[Phase 5]** Read `gmc_v9_0.c:583–621`, `gmc_v10_0.c:115–137`,
  `amdgpu_ih.c:150–169`, `amdgpu_irq.c:510–516`.
- **[Phase 5]** `grep system_unbound_wq` in amdgpu → prior usage in
  reset/device code.
- **[Phase 6]** Confirmed `schedule_work` at `amdgpu_irq.c:515` in
  current tree.
- **[Phase 6]** Fix commit only on `linux-next/master`, not ancestor of
  HEAD.
- **[Phase 8]** Assessed severity from ring-overflow + interrupt-storm
  mechanism in code.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
index 8d7f97eed5a90..ccc378233bc5a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -512,7 +512,7 @@ void amdgpu_irq_delegate(struct amdgpu_device *adev,
 			 unsigned int num_dw)
 {
 	amdgpu_ih_ring_write(adev, &adev->irq.ih_soft, entry->iv_entry, num_dw);
-	schedule_work(&adev->irq.ih_soft_work);
+	queue_work(system_unbound_wq, &adev->irq.ih_soft_work);
 }
 
 /**
-- 
2.53.0

