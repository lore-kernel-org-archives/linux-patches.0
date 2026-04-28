Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04F3413221;
	Tue, 28 Apr 2026 10:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372972; cv=none; b=sJt7Lir+GTfv1bWZRdbJhLcIH0/FteQLy4bINKsvCNK004KXKnD79YreGARx7xnLZnSKXck+Qk2hsYIsxH3OjUhTdMCRQTZjkAui7lv0IlN1VUghiNiUb2vzBLomLOJoW/ZGjRujdT2HVLa0cWpMxp6dTfcyLpuP0lhhhLYN53w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372972; c=relaxed/simple;
	bh=WG1aZEtlaChURH5tQWWR04QdRV9xU25WVloCetGhuL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=keWK5L1tgElOKvqE7OdV0djVl6End60S9Kh4Fdn/VibW25ad+Lif+c08Odf/lswszRwzVVXeF6g2iJaMdi3JixkXLLvtoyOqdsVib62OW1yQNrCoGyqdH/ZFNmkdMdL5KBIMA9mqhmj9ATrMvHd2ggU7nzYjmO6EiTBJhnshk7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e0wt0I0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e0wt0I0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F6DC2BCF5;
	Tue, 28 Apr 2026 10:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372972;
	bh=WG1aZEtlaChURH5tQWWR04QdRV9xU25WVloCetGhuL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0wt0I0j7aZU4QAarex/bWcy2UXt4vgzfrhza72LFswEcF4WLIKRgQtX5nf3eRx1M
	 9FLInTzplEKqvITiNXX6hdMoAEIfWkLmX2wjFYIb/ZC0xN7hEKhrtYHphprK3CEMif
	 5AyhjcYw4kDqVRnVsTf2920Tmh6VJubCjnlCg4S5D9L/4rhENUruP4n2EUA1OVj76p
	 zjzhAKdu/AThDrOyVnnEwpBtb7gNtDsYYYo1RSv+XyYOgReH6K+u7tcGO1hxxRssZF
	 A9opYpi6fHNUvGQ40Asx/TF/26Z71dcjpu4nFauIgTKGDAg1ERU1uaEKSZh1929opS
	 4ygRu+rmuWwog==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Siwei He <siwei.he@amd.com>,
	Philip Yang <philip.yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	Xinhui.Pan@amd.com,
	airlied@gmail.com,
	daniel@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] drm/amdgpu: OR init_pte_flags into invalid leaf PTE updates
Date: Tue, 28 Apr 2026 06:41:05 -0400
Message-ID: <20260428104133.2858589-54-sashal@kernel.org>
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

From: Siwei He <siwei.he@amd.com>

[ Upstream commit 778bf584f2fb0a2b09594f568faf400bf6858091 ]

Invalid leaf clears that only set AMDGPU_PTE_EXECUTABLE match the old
GMC9 fault-priority workaround but omit adev->gmc.init_pte_flags.
On GFX12 that includes AMDGPU_PTE_IS_PTE; without it, some cleared
PTEs can fault as no-retry and bypass the SVM/XNACK handler when a
VA is reused after a BO unmap.

Apply init_pte_flags in amdgpu_vm_pte_update_flags() alongside
EXECUTABLE so range-driven clears (e.g. amdgpu_vm_clear_freed) match
amdgpu_vm_pt_clear() for leaf templates.

Signed-off-by: Siwei He <siwei.he@amd.com>
Reviewed-by: Philip Yang <philip.yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9d47b2c36b9a6c6b844c33cab407a5d7ad102234)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis.

## Phase 1: Commit Message Forensics

**Step 1.1 - Subject Line Parse**
- Subsystem: `drm/amdgpu` (AMD GPU driver, virtual memory page table
  code)
- Action verb: "OR" (operator), implies a missing flag combination → bug
  fix
- Record: `drm/amdgpu` adds `init_pte_flags` to invalid leaf PTE updates
  to match `amdgpu_vm_pt_clear()` behavior

**Step 1.2 - Tags Inventory**
- Signed-off-by: Siwei He (author)
- Reviewed-by: Philip Yang (AMD/amdkfd maintainer)
- Signed-off-by: Alex Deucher (DRM/amdgpu maintainer)
- `(cherry picked from commit 9d47b2c36b9a6c6b844c33cab407a5d7ad102234)`
  — already merged upstream
- No Fixes:, no Cc: stable, no syzbot/Reported-by (expected per pipeline
  rules)
- Record: Reviewed and signed by relevant subsystem maintainers; cherry
  pick from upstream

**Step 1.3 - Commit Body Analysis**
- Bug description: leaf PTE clears that only set `AMDGPU_PTE_EXECUTABLE`
  omit `adev->gmc.init_pte_flags`
- Affected hardware: GFX12 (where `init_pte_flags` includes
  `AMDGPU_PTE_IS_PTE`)
- Symptom: cleared PTEs can fault as no-retry and bypass SVM/XNACK
  handler when VA is reused after BO unmap
- Root cause: code template inconsistency between `amdgpu_vm_pt_clear()`
  (already updated) and `amdgpu_vm_pte_update_flags()` (range-driven
  clear path used by e.g., `amdgpu_vm_clear_freed`)
- Record: clearly states bug mechanism; affects real GFX12 hardware
  running SVM/XNACK after BO unmap → VA reuse

**Step 1.4 - Hidden Bug Fix Detection**
- Although not titled "fix", the body explicitly describes a fault-
  handler bypass on GFX12 — this IS a bug fix
- Record: explicit bug fix (not hidden)

## Phase 2: Diff Analysis

**Step 2.1 - Inventory**
- Single file: `drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c`
- Hunks: 1; lines: net +1 (statement extended), comment expanded
- Function modified: `amdgpu_vm_pte_update_flags()`
- Scope: surgical, single-line semantic change in one function
- Record: tiny single-file fix, ~2 lines of logic change

**Step 2.2 - Code Flow Change**
- Before: when handling an invalid leaf clear (`level==PTB && !VALID &&
  !PRT`), `flags |= AMDGPU_PTE_EXECUTABLE`
- After: `flags |= AMDGPU_PTE_EXECUTABLE | adev->gmc.init_pte_flags`
- On GFX12.1, `init_pte_flags = AMDGPU_PTE_IS_PTE`; on GMC9 it's 0 (no
  behavior change there)
- Record: aligns the leaf-clear template with `amdgpu_vm_pt_clear()`
  (line 416 already does the same)

**Step 2.3 - Bug Mechanism**
- Category: Logic/correctness fix → consistency between two clear paths
- Mechanism: template mismatch on GFX12 page table clears caused PTEs to
  be marked without `IS_PTE`, leading to no-retry faults that bypass the
  SVM/XNACK fault handler
- Record: same template now used in both leaf-clear sites; this is a
  hardware-correctness fix

**Step 2.4 - Fix Quality**
- Obviously correct: mirrors existing pattern at line 416 of same file
  (`amdgpu_vm_pt_clear`)
- Minimal/surgical: a single OR with a per-ASIC field that defaults to 0
- Regression risk: very low — on non-GFX12 hardware `init_pte_flags ==
  0`, so behavior is unchanged
- Record: high quality, low regression risk

## Phase 3: Git History Investigation

**Step 3.1 - Blame**
- The buggy line existed before, but the *omission* was created by
  `db29ddf6505f3` ("drm/amdgpu: Add per-ASIC PTE init flag", Apr 24,
  2025) which added `init_pte_flags` and applied it in
  `amdgpu_vm_pt_clear()` only — not in `amdgpu_vm_pte_update_flags()`
- Record: bug introduced by db29ddf6505f3

**Step 3.2 - Fixes Target**
- No explicit `Fixes:` tag in this commit, but the underlying fault-
  handler-bypass bug requires `init_pte_flags` to exist, which only
  appeared in `db29ddf6505f3`
- That commit lands in v7.0-rc1 (verified: `git tag --contains
  db29ddf6505f3` shows v7.0-rc1+ only)
- Record: bug only exists in v7.0+; older stable trees do not have
  `init_pte_flags`

**Step 3.3 - File History**
- Last commit on `amdgpu_vm_pt.c`: `db29ddf6505f3` (the very commit that
  introduced the inconsistency)
- Record: this fix immediately follows the bug-introducing commit;
  standalone, no prerequisite missing

**Step 3.4 - Author**
- Siwei He (AMD developer) — the upstream cherry-pick is reviewed by
  Philip Yang and signed by Alex Deucher (amdgpu maintainer)
- Record: properly vetted by amdgpu maintainership

**Step 3.5 - Dependencies**
- Requires `adev->gmc.init_pte_flags` — present in v7.0+ via
  `db29ddf6505f3`
- No other dependency
- Record: standalone fix in v7.0; not applicable to pre-v7.0 stable
  trees

## Phase 4: Mailing List / External Research

- `b4 dig -c 9d47b2c36b9a6c6b844c33cab407a5d7ad102234` — SHA not present
  in local repo (cherry-pick hash from a tree this repo doesn't have)
- `b4 dig -c db29ddf6505f3` — no lore match found
- `lore.kernel.org` direct fetch blocked by Anubis bot challenge / 403
  from raw curl — could not retrieve discussion
- Record: UNVERIFIED — could not retrieve the original lore discussion
  thread; relying on the in-tree review trail (Reviewed-by Philip Yang,
  Signed-off-by Alex Deucher)

## Phase 5: Code Semantic Analysis

**Step 5.1 - Functions in Diff**
- `amdgpu_vm_pte_update_flags()`

**Step 5.2 - Callers**
- Called from `amdgpu_vm_update_ptes()` (line 909 in the same file)
- That is called from `amdgpu_vm_update_range()` in `amdgpu_vm.c`
- `amdgpu_vm_update_range()` is called from many sites:
  `amdgpu_vm_clear_freed` (line 1573, with flags=0 → exact bug path),
  `amdgpu_vm_bo_update`, `amdgpu_gem_va_ioctl`, etc.
- Record: the buggy path is reached on EVERY BO unmap that places
  mappings on `vm->freed`

**Step 5.3 - Callees**
- Calls `update_funcs->update()` to write PTEs
- Record: writes the actual page table entries — direct hardware effect

**Step 5.4 - Reachability**
- `amdgpu_vm_clear_freed` runs from normal GEM unmap/CS paths and from
  KFD memory paths
- Triggerable by any user/process unmapping a GPU buffer with a VA that
  gets reused
- Record: trivially reachable from userspace via standard amdgpu/KFD
  ioctls

**Step 5.5 - Similar Patterns**
- Only two leaf-clear template sites; the other one
  (`amdgpu_vm_pt_clear` line 416) was already updated to use
  `init_pte_flags`. This patch makes the second site consistent.
- Record: closes the only remaining inconsistent site

## Phase 6: Cross-Referencing & Stable Tree Analysis

**Step 6.1 - Bug Presence in Stable Trees**
- `init_pte_flags` field exists only in v7.0+ — verified by `git tag
  --contains db29ddf6505f3` showing earliest tag `v7.0-rc1`
- Pre-v7.0 stable trees (6.6.y, 6.1.y, 5.15.y, 5.10.y) do NOT have this
  field, so this fix does not apply there and the specific bug being
  addressed does not exist in that form there
- Record: target stable tree for this fix is v7.0.y (matches workspace
  path `linux-autosel-7.0`)

**Step 6.2 - Backport Difficulty**
- `amdgpu_vm_pte_update_flags()` exists unchanged in v7.0.y; the diff
  applies cleanly
- Record: clean apply to 7.0.y

**Step 6.3 - Related Fixes Already In Stable**
- The companion fix at `amdgpu_vm_pt_clear()` (line 416) is part of
  `db29ddf6505f3` which is in v7.0
- This commit is the second half of that fix
- Record: 7.0.y already has half of the pattern; this patch completes it

## Phase 7: Subsystem Context

**Step 7.1 - Subsystem Criticality**
- `drivers/gpu/drm/amd/amdgpu` — important driver subsystem (large user
  base for AMD GPUs)
- This specific code path: GFX12 (RDNA4 / RX 9000 series) SVM/XNACK —
  real shipping consumer hardware
- Record: IMPORTANT (driver-specific, affects current AMD hardware)

**Step 7.2 - Activity**
- amdgpu is a very active subsystem with frequent fixes
- Record: highly active; fixes-quickly-integrated subsystem

## Phase 8: Impact and Risk Assessment

**Step 8.1 - Affected Users**
- GFX12.1 (RDNA4 / RX 9000 series) hardware users running compute
  workloads with SVM/XNACK enabled (ROCm, HIP, OpenCL, etc.)
- Record: driver-specific (GFX12 only with SVM); on other ASICs
  `init_pte_flags == 0` so no behavior change

**Step 8.2 - Trigger**
- Trigger: any unmap of a GPU buffer where the VA later gets reused
- Reachable from unprivileged user code via standard amdgpu/KFD ioctls
- Common in compute workloads that allocate/free buffers
- Record: easily triggered from userspace; common in real workloads

**Step 8.3 - Severity**
- Failure mode: PTEs faulting as no-retry that bypass the SVM/XNACK
  handler — the handler is what makes SVM-on-demand actually work, so
  its bypass leads to incorrect fault behavior on GPU memory accesses
- Severity: HIGH for affected users (broken SVM/XNACK semantics on new
  HW); MEDIUM-CRITICAL depending on workload (silent incorrect access
  vs. application failure)
- Record: HIGH severity for GFX12 SVM users

**Step 8.4 - Risk/Benefit**
- Benefit: high — fixes broken SVM on current shipping AMD hardware
- Risk: very low — single OR with a field that is 0 on every other ASIC;
  mirrors a sibling site already in the tree
- Record: clear net positive for backport

## Phase 9: Final Synthesis

**Evidence FOR backport**
- Real bug on real shipping GFX12 hardware (RX 9000 / RDNA4) with
  SVM/XNACK
- Trivial 2-line fix; mirrors existing pattern (`amdgpu_vm_pt_clear`) at
  line 416 of the same file
- Reviewed by Philip Yang (amdkfd) and signed by Alex Deucher (amdgpu
  maintainer)
- Buggy template inconsistency was introduced in v7.0-rc1 by
  `db29ddf6505f3`; lands cleanly in v7.0.y
- On non-GFX12 ASICs `init_pte_flags == 0` → guaranteed no behavior
  change there
- Reachable via standard userspace ioctls (BO unmap → VA reuse)

**Evidence AGAINST backport**
- No `Fixes:` or `Cc: stable` tag (expected per pipeline rules; not a
  negative signal)
- Lore discussion could not be fetched for further verification
  (UNVERIFIED)
- Does NOT apply to pre-v7.0 stable trees (no `init_pte_flags` field
  there); only relevant to 7.0.y

**Stable Rules Checklist**
1. Obviously correct & tested: yes — mirrors a sibling site, very small
   change, signed off by maintainers
2. Fixes a real bug: yes — fault-handler bypass on GFX12 SVM/XNACK
3. Important issue: yes — broken VA-reuse semantics on shipping hardware
4. Small and contained: yes — single hunk, ~2 lines logic
5. No new features/APIs: yes — pure consistency fix
6. Applies to stable: yes for 7.0.y (clean), N/A for older

**Decision**
This is a small, surgical, maintainer-reviewed fix that closes a
hardware-correctness gap on shipping AMD GPUs (GFX12 SVM/XNACK) by
mirroring an already-applied pattern in the same file. The matching
companion fix is already in 7.0, so this completes that work. Risk is
essentially nil on non-GFX12 hardware (zero OR'd in).

## Verification

- [Phase 1] Parsed commit message tags and body: identified Reviewed-by
  Philip Yang, Signed-off-by Alex Deucher; no syzbot, no Fixes
  (expected)
- [Phase 2] Read diff and surrounding code at `amdgpu_vm_pt.c:679-721`:
  confirmed single hunk in `amdgpu_vm_pte_update_flags()`, change is
  `flags |= AMDGPU_PTE_EXECUTABLE | adev->gmc.init_pte_flags`
- [Phase 2] Read `amdgpu_vm_pt.c:361-418` to verify the sibling site
  `amdgpu_vm_pt_clear()` already uses the same template at line 416
  (`flags = AMDGPU_PTE_EXECUTABLE | adev->gmc.init_pte_flags`)
- [Phase 3] `git log --oneline --grep="PTE init flag" master` → found
  `db29ddf6505f3`
- [Phase 3] `git show db29ddf6505f3` → confirmed it added
  `init_pte_flags` field, set `init_pte_flags = AMDGPU_PTE_IS_PTE` for
  GFX12.1, and updated only `amdgpu_vm_pt_clear()` (not
  `amdgpu_vm_pte_update_flags()`)
- [Phase 3] `git tag --contains db29ddf6505f3` → earliest tag `v7.0-rc1`
  — confirms bug lives in v7.0+ only
- [Phase 3] `git log --oneline --
  drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c` → no other intermediate
  fixes between `db29ddf6505f3` and HEAD
- [Phase 4] `b4 dig -c 9d47b2c36b9a6c6b844c33cab407a5d7ad102234` → SHA
  not in this repo (cherry-pick hash from elsewhere)
- [Phase 4] `b4 dig -c db29ddf6505f3` → no lore match found
- [Phase 4] WebFetch / curl to lore.kernel.org → blocked by Anubis bot
  challenge / 403 — UNVERIFIED for original mailing list discussion
  content
- [Phase 5] `Grep AMDGPU_PTE_EXECUTABLE` and `Grep AMDGPU_PTE_IS_PTE`
  and `Grep init_pte_flags` across `drivers/gpu/drm/amd` → confirmed
  only two leaf-clear template sites; `init_pte_flags` is only set non-
  zero for GFX12.1 (`gmc_v12_0.c:643`)
- [Phase 5] Read `amdgpu_vm_pt.c:880-921` → verified caller chain:
  `amdgpu_vm_update_ptes` → `amdgpu_vm_pte_update_flags`
- [Phase 5] `Grep amdgpu_vm_clear_freed` and read
  `amdgpu_vm.c:1548-1577` → confirmed `amdgpu_vm_clear_freed` calls
  `amdgpu_vm_update_range` with flags=0, hitting the patched `else if`
  branch
- [Phase 6] `git tag --contains db29ddf6505f3` → confirms
  `init_pte_flags` only in v7.0+; older stable trees lack the field, fix
  is not applicable to them
- [Phase 6] Read of HEAD source confirms `amdgpu_vm_pte_update_flags`
  exists unchanged in v7.0.1 → diff applies cleanly
- [Phase 8] Bug mechanism verified via commit body + code: leaf-clear
  template inconsistency on GFX12 → no-retry faults bypass SVM/XNACK
  handler on VA reuse
- UNVERIFIED: original lore discussion (lore blocked by anti-bot)
- UNVERIFIED: independent reproduction reports / bug-report links (none
  in commit body)

The fix is small, obviously correct, addresses a real hardware-
correctness bug on current AMD GPUs, mirrors a sibling site already in
v7.0, and is essentially a no-op on non-GFX12 ASICs. It is appropriate
for the v7.0.y stable tree.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
index 31a437ce95704..a930f1522f962 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
@@ -693,8 +693,11 @@ static void amdgpu_vm_pte_update_flags(struct amdgpu_vm_update_params *params,
 		   !(flags & AMDGPU_PTE_VALID) &&
 		   !(flags & AMDGPU_PTE_PRT_FLAG(params->adev))) {
 
-		/* Workaround for fault priority problem on GMC9 */
-		flags |= AMDGPU_PTE_EXECUTABLE;
+		/* Workaround for fault priority problem on GMC9 and GFX12,
+		 * EXECUTABLE for GMC9 fault priority and init_pte_flags
+		 * (e.g. AMDGPU_PTE_IS_PTE on GFX12)
+		 */
+		flags |= AMDGPU_PTE_EXECUTABLE | adev->gmc.init_pte_flags;
 	}
 
 	/*
-- 
2.53.0

