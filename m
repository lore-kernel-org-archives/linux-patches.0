Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF47B478E5F;
	Mon, 20 Apr 2026 13:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691853; cv=none; b=u2uFXR0/oSiWQo6VCQYf/ohfTjn25Sw14GC+39GwhpMV++t6DVdFo0KIIQ5pHUuaGLjoHADfN6lG4Wz8/GCJFOyKB+t8YZzWq8T85PC9ZgxSyXnGcWrXbWJJO8W3AKLcJj3d04wuMYB1PndROuCa/uNr0uTSUFw65rhO2IvjIfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691853; c=relaxed/simple;
	bh=4xiw5v4GHgFwfDMt4EGl/NU/LMF7cjo7fJz6cVUfIqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=py8NfhpFvfmls10CFaJF+7vfO6yvXRtQLs4H44hEYSMGbjJB4jZgKrtS73osq65RVkrHii0LPObu6lAdlfZYGm4uRUe9mGn2aKRKL05kvQbvG84vqfZfJb8UIjnRVbMTtGSpNhvjl6Yo1cUMqwyx6JfKCamfS91Qp+mf0W122Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dY7JVugp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dY7JVugp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CB4C19425;
	Mon, 20 Apr 2026 13:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691852;
	bh=4xiw5v4GHgFwfDMt4EGl/NU/LMF7cjo7fJz6cVUfIqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dY7JVugpjsAyMhWviSBKV3MNPuSy8IWnJprkOX4G7A+KgTlXGOFdrO+Ht7KyRaA8f
	 DSnjCQIyB9BAMJrIVl5s6j62EXBe2jGbEo9IoSh6hHcFOXb89a3qM6FtZxQCS9jR/M
	 7RNdgN+ndOWT8RFYloTlcLwBuQbbeo61siu6v9zmshdfInqg5MQRRP9o32x5J+tG7E
	 XUomDRxOVx2aGVxQ0OgDAYpkGuMLAV5kNBcG9/8xfUclg29UojZBF4WAmP2GBIq4or
	 QQ/8J34tSlzc5uwSK7Av7KBiME22/oCdF/aM7D1y6RZKp4eWm4E/tZxh4FsgyrRkpO
	 nb8i/pF6dZ9hg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jesse Zhang <Jesse.Zhang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] drm/amdgpu: guard atom_context in devcoredump VBIOS dump
Date: Mon, 20 Apr 2026 09:20:26 -0400
Message-ID: <20260420132314.1023554-232-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
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

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 557fa5a453c9ccb49a22f30a7ad0545573d434b7 ]

During GPU reset coredump generation, amdgpu_devcoredump_fw_info() unconditionally
dereferences adev->mode_info.atom_context to print VBIOS fields. On reset/teardown
paths this pointer can be NULL, causing a kernel page fault from the deferred
coredump workqueue.

Fix by checking ctx before printing VBIOS fields:

if ctx is valid, print full VBIOS information as before;
This prevents NULL-dereference crashes while preserving coredump output.

Observed page fault log:
[  667.933329] RIP: 0010:amdgpu_devcoredump_format+0x780/0xc00 [amdgpu]
[  667.941517] amdgpu 0002:01:00.0: Dumping IP State
[  667.949660] Code: 8d 57 74 48 c7 c6 01 65 9f c2 48 8d 7d 98 e8 97 96 7a ff 49 8d 97 b4 00 00 00 48 c7 c6 18 65 9f c2 48 8d 7d 98 e8 80 96 7a ff <41> 8b 97 f4 00 00 00 48 c7 c6 2f 65 9f c2 48 8d 7d 98 e8 69 96 7a
[  667.949666] RSP: 0018:ffffc9002302bd50 EFLAGS: 00010246
[  667.949673] RAX: 0000000000000000 RBX: ffff888110600000 RCX: 0000000000000000
[  667.949676] RDX: 000000000000a9b5 RSI: 0000000000000405 RDI: 000000000000a999
[  667.949680] RBP: ffffc9002302be00 R08: ffffffffc09c3084 R09: ffffffffc09c3085
[  667.949684] R10: 0000000000000000 R11: 0000000000000004 R12: 00000000000048e0
[  667.993908] amdgpu 0002:01:00.0: Dumping IP State Completed
[  667.994229] R13: 0000000000000025 R14: 000000000000000c R15: 0000000000000000
[  667.994233] FS:  0000000000000000(0000) GS:ffff88c44c2c9000(0000) knlGS:0000000000000000
[  668.000076] amdgpu 0002:01:00.0: [drm] AMDGPU device coredump file has been created
[  668.008025] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  668.008030] CR2: 00000000000000f4 CR3: 000000011195f001 CR4: 0000000000770ef0
[  668.008035] PKRU: 55555554
[  668.008040] Call Trace:
[  668.008045]  <TASK>
[  668.016010] amdgpu 0002:01:00.0: [drm] Check your /sys/class/drm/card16/device/devcoredump/data
[  668.023967]  ? srso_alias_return_thunk+0x5/0xfbef5
[  668.023988]  ? __pfx___drm_printfn_coredump+0x10/0x10 [drm]
[  668.031950] amdgpu 0003:01:00.0: Dumping IP State
[  668.038159]  ? __pfx___drm_puts_coredump+0x10/0x10 [drm]
[  668.083017] amdgpu 0003:01:00.0: Dumping IP State Completed
[  668.083824]  amdgpu_devcoredump_deferred_work+0x26/0xc0 [amdgpu]
[  668.086163] amdgpu 0003:01:00.0: [drm] AMDGPU device coredump file has been created
[  668.095863]  process_scheduled_works+0xa6/0x420
[  668.095880]  worker_thread+0x12a/0x270
[  668.101223] amdgpu 0003:01:00.0: [drm] Check your /sys/class/drm/card24/device/devcoredump/data
[  668.107441]  kthread+0x10d/0x230
[  668.107451]  ? __pfx_worker_thread+0x10/0x10
[  668.107458]  ? __pfx_kthread+0x10/0x10
[  668.112709] amdgpu 0000:01:00.0: ring vcn_unified_1 timeout, signaled seq=9, emitted seq=10
[  668.118630]  ret_from_fork+0x17c/0x1f0
[  668.118640]  ? __pfx_kthread+0x10/0x10
[  668.118647]  ret_from_fork_asm+0x1a/0x30

Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis. Let
me compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `drm/amdgpu`
- Action verb: "guard" — implies adding a missing safety check, which is
  a bug fix pattern
- Summary: Guard `atom_context` in devcoredump VBIOS dump to prevent
  NULL dereference

**Step 1.2: Tags**
- `Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>` — AMD GPU subsystem
  reviewer
- `Suggested-by: Lijo Lazar <lijo.lazar@amd.com>` — the fix approach was
  suggested by a maintainer
- `Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>` — author, regular
  AMD GPU contributor
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` — AMD GPU
  subsystem maintainer who committed it
- No Fixes: tag (expected for autosel candidates)
- No Cc: stable (expected)

**Step 1.3: Commit Body**
- Bug: During GPU reset coredump generation,
  `amdgpu_devcoredump_fw_info()` unconditionally dereferences
  `adev->mode_info.atom_context` (via local `ctx` variable) to print
  VBIOS fields. On reset/teardown paths, this pointer can be NULL.
- Symptom: Kernel page fault from deferred coredump workqueue. The crash
  log with `CR2: 00000000000000f4` confirms access at offset 0xf4 from a
  NULL pointer.
- The RIP points to `amdgpu_devcoredump_format+0x780` and the call trace
  shows `amdgpu_devcoredump_deferred_work` → `process_scheduled_works` →
  `worker_thread`.

**Step 1.4: Hidden Bug Fix Detection**
- Not hidden — this is an explicit, documented crash fix with a full
  kernel oops log.

Record: This is a clear NULL pointer dereference fix with observed crash
evidence.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files changed: 1 (`drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c`)
- Lines: +10, -6 (net +4 lines)
- Functions modified: `amdgpu_devcoredump_fw_info()`
- Scope: Single-file surgical fix

**Step 2.2: Code Flow Change**
- BEFORE: Lines 190-195 unconditionally dereference `ctx->name`,
  `ctx->vbios_pn`, `ctx->version`, `ctx->vbios_ver_str`, `ctx->date`
- AFTER: Wrapped in `if (adev->bios)` — if BIOS is available, print full
  VBIOS info; if not, print "VBIOS Information: NA"

**Step 2.3: Bug Mechanism**
Category: **Memory safety — NULL pointer dereference**
- `ctx` is assigned at line 79: `struct atom_context *ctx =
  adev->mode_info.atom_context;`
- `atom_context` is set to NULL by `amdgpu_atombios_fini()` (line 1882
  of `amdgpu_atombios.c`) during teardown
- `adev->bios` is set to NULL by `amdgpu_bios_release()` (line 90 of
  `amdgpu_bios.c`)
- Both are called from `amdgpu_device_fini_sw()` at lines 4984-4988 of
  `amdgpu_device.c`
- The guard uses `adev->bios` because Lijo explained that if BIOS is
  unavailable (skip_bios platforms), atom_context won't exist — this is
  a non-error case

**Step 2.4: Fix Quality**
- Obviously correct: simple NULL guard
- Minimal and surgical: only the VBIOS section is wrapped
- No regression risk: doesn't change any logic, just prevents access to
  NULL pointer
- The `adev->bios` check is the correct proxy per maintainer guidance

Record: Clean NULL guard fix, 4 net lines added, zero regression risk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- Lines 190 (header print) introduced by commit `6a0e1bafd70fe5` (Sunil
  Khatri, 2024-03-26) — "drm/amdgpu: add IP's FW information to
  devcoredump"
- Lines 191-195 (ctx dereferences) introduced by commit `3c858cf65e9a2c`
  (Sunil Khatri, 2024-04-12) — "drm/amdgpu: add missing vbios version
  from devcoredump"
- Both first appeared in `v6.10-rc1`

**Step 3.2: Fixes tag**
- No Fixes: tag present. Based on analysis, would fix `3c858cf65e9a2c`
  which added the `ctx->*` dereferences.

**Step 3.3: File History**
- 14 commits to this file since `6a0e1bafd70fe5`, mostly feature
  additions (IP dump, ring buffer info, device info)
- No prior fix for this specific NULL dereference

**Step 3.4: Author**
- Jesse Zhang is a regular AMD GPU contributor (10 recent commits to
  amdgpu subsystem found)
- Fix was suggested and reviewed by Lijo Lazar (AMD GPU maintainer)

**Step 3.5: Dependencies**
- Standalone fix, no dependencies on other patches

Record: Buggy code from v6.10-rc1. Fix is standalone with no
prerequisites.

---

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Patch Discussion**
Found the full evolution on amd-gfx mailing list:
- **V1**: Checked `ctx` directly before VBIOS access
- **V2** (mail-archive.com/amd-
  gfx@lists.freedesktop.org/msg139678.html): Still checked `ctx`, added
  `!adev->bios` check per Lijo's initial feedback
- **Lijo's V2 review**: "On a second check, this cannot happen when
  vbios is available. Driver load will fail in that case. In other
  cases, we operate without VBIOS. For them, probably this may be
  avoided altogether (preferred) or mark the section as NA." Suggested
  `drm_printf(p, "\nVBIOS Information: NA\n");`
- **V3 (committed)**: Jesse incorporated Lijo's feedback — checks
  `adev->bios` and prints "VBIOS Information: NA"

**Step 4.2: Reviewers**
- Lijo Lazar (AMD GPU reviewer) reviewed all versions and provided the
  fix approach
- Alex Deucher (AMD GPU maintainer) signed off and committed

**Step 4.3: Bug Report**
- No external bug report link, but the commit includes a complete kernel
  oops log, confirming reproduction

Record: Patch went through 3 revisions with constructive review. Final
version incorporates maintainer's preferred approach.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
- `amdgpu_devcoredump_fw_info()` — static helper to print firmware info
  in coredump

**Step 5.2: Callers**
- Called from `amdgpu_devcoredump_read()` (line 266 in 7.0 tree), which
  is the devcoredump read callback passed to `dev_coredumpm()`
- Triggered when the devcoredump deferred work runs or when userspace
  reads `/sys/class/drm/cardN/device/devcoredump/data`

**Step 5.3: Trigger Path**
- GPU reset → `amdgpu_coredump()` → `dev_coredumpm()` → (later) deferred
  work or userspace read → `amdgpu_devcoredump_read()` →
  `amdgpu_devcoredump_fw_info()` → **CRASH** if atom_context is NULL

**Step 5.4: Reachability**
- GPU resets happen automatically on GPU hang recovery — very common for
  AMDGPU users
- The coredump path is always active when `CONFIG_DEV_COREDUMP` is
  enabled (default in most distros)

Record: The crash path is reachable from normal GPU hang recovery
operations.

---

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable**
- The buggy code was introduced in v6.10-rc1
- Affects all stable trees from 6.10 onwards: 6.10.y, 6.11.y, 6.12.y,
  6.13.y, 6.14.y, and this 7.0 tree

**Step 6.2: Backport Complications**
- The actual changed code (VBIOS section in
  `amdgpu_devcoredump_fw_info()`) is identical in the 7.0 tree and the
  upstream version
- The diff's trailing context shows `amdgpu_devcoredump_format` but the
  7.0 tree has `amdgpu_devcoredump_read` — this is just context, not the
  changed hunk, so it only requires minor fuzz adjustment

**Step 6.3: Related Fixes Already in Stable**
- No related fixes found for this specific issue

Record: Fix applies to all stable trees 6.10+. Minor context adjustment
needed for 7.0 tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
- `drm/amdgpu` — AMD GPU driver
- Criticality: **IMPORTANT** — AMDGPU is one of the most widely used GPU
  drivers (all AMD Radeon GPUs, both discrete and integrated)

**Step 7.2: Activity**
- Very actively developed subsystem with frequent commits

Record: IMPORTANT subsystem affecting a large user base.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
- All users with AMD GPUs running kernels 6.10+ with
  `CONFIG_DEV_COREDUMP` enabled (most distros)

**Step 8.2: Trigger Conditions**
- GPU hang → automatic reset → coredump generation with `atom_context`
  already freed
- GPU hangs and resets are common real-world events
- Does not require unprivileged user action (happens automatically)

**Step 8.3: Failure Mode**
- Kernel page fault (oops) from workqueue context
- CR2: 0xf4 — NULL pointer dereference at struct offset 0xf4
- Severity: **HIGH** (kernel oops, system instability)

**Step 8.4: Risk-Benefit Ratio**
- **Benefit**: HIGH — prevents kernel crash during GPU reset recovery
- **Risk**: VERY LOW — 10-line NULL guard, single function, reviewed by
  maintainer, obviously correct
- **Ratio**: Strongly favorable for backporting

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**

FOR backporting:
- Fixes a real, observed kernel oops (full stack trace provided)
- Small, surgical fix (4 net lines changed in one function)
- Reviewed and suggested by AMD GPU maintainer (Lijo Lazar)
- Signed off by subsystem maintainer (Alex Deucher)
- Went through 3 review revisions — well-vetted
- Affects widely-used AMDGPU driver
- Bug present since v6.10 — affects all active stable trees
- Zero regression risk — just a NULL guard
- Standalone fix with no dependencies

AGAINST backporting:
- None identified
- Minor context adjustment may be needed for backport (function name in
  trailing context differs)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — simple NULL guard, reviewed
   by maintainer
2. Fixes a real bug? **YES** — kernel oops during GPU reset
3. Important issue? **YES** — kernel crash (oops)
4. Small and contained? **YES** — 10 lines changed, single file, single
   function
5. No new features or APIs? **YES** — only adds a safety check
6. Can apply to stable? **YES** — with minor context adjustment

**Step 9.3: Exception Categories**
- Not an exception category; this is a standard bug fix that qualifies
  on its own merits.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by and Suggested-by from Lijo Lazar
  (AMD reviewer), Signed-off-by from Alex Deucher (maintainer)
- [Phase 2] Diff analysis: wraps 6 `ctx->*` dereferences with `if
  (adev->bios)` guard in `amdgpu_devcoredump_fw_info()`
- [Phase 3] git blame: buggy dereferences introduced in commits
  `6a0e1bafd70fe5` and `3c858cf65e9a2c`, both in v6.10-rc1
- [Phase 3] `git describe --contains 6a0e1bafd70fe5`: confirmed
  `v6.10-rc1~148^2~21^2~118`
- [Phase 3] `git describe --contains 3c858cf65e9a2c`: confirmed
  `v6.10-rc1~148^2~19^2~49`
- [Phase 4] mail-archive.com V2 thread: Lijo reviewed, suggested
  `adev->bios` check and "NA" fallback
- [Phase 4] mail-archive.com Jesse's response: confirmed V3 incorporates
  Lijo's feedback
- [Phase 5] Grep for `amdgpu_devcoredump_fw_info` callers: called from
  `amdgpu_devcoredump_read()` line 266
- [Phase 5] Grep for `amdgpu_atombios_fini`: confirmed `atom_context =
  NULL` at line 1882 of `amdgpu_atombios.c`
- [Phase 5] Grep for `amdgpu_bios_release`: confirmed `adev->bios =
  NULL` at line 90 of `amdgpu_bios.c`
- [Phase 5] Confirmed both called from `amdgpu_device.c` lines 4984-4988
  during teardown
- [Phase 6] Code exists in 7.0 tree — lines 190-195 of
  `amdgpu_dev_coredump.c` show identical buggy code
- [Phase 6] Function name difference in context (`format` vs `read`) is
  only in trailing context, not the changed hunk
- [Phase 8] Failure mode: NULL deref → kernel oops from workqueue during
  GPU reset, severity HIGH

---

The fix is small, surgical, obviously correct, well-reviewed by AMD GPU
maintainers, and prevents a real kernel oops triggered during normal GPU
reset recovery. It meets all stable kernel criteria with minimal risk.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c
index c38e7371bafce..fed4e73d3492f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c
@@ -187,12 +187,16 @@ static void amdgpu_devcoredump_fw_info(struct amdgpu_device *adev,
 	drm_printf(p, "VPE feature version: %u, fw version: 0x%08x\n",
 		   adev->vpe.feature_version, adev->vpe.fw_version);
 
-	drm_printf(p, "\nVBIOS Information\n");
-	drm_printf(p, "vbios name       : %s\n", ctx->name);
-	drm_printf(p, "vbios pn         : %s\n", ctx->vbios_pn);
-	drm_printf(p, "vbios version    : %d\n", ctx->version);
-	drm_printf(p, "vbios ver_str    : %s\n", ctx->vbios_ver_str);
-	drm_printf(p, "vbios date       : %s\n", ctx->date);
+	if (adev->bios) {
+		drm_printf(p, "\nVBIOS Information\n");
+		drm_printf(p, "vbios name       : %s\n", ctx->name);
+		drm_printf(p, "vbios pn         : %s\n", ctx->vbios_pn);
+		drm_printf(p, "vbios version    : %d\n", ctx->version);
+		drm_printf(p, "vbios ver_str    : %s\n", ctx->vbios_ver_str);
+		drm_printf(p, "vbios date       : %s\n", ctx->date);
+	}else {
+		drm_printf(p, "\nVBIOS Information: NA\n");
+	}
 }
 
 static ssize_t
-- 
2.53.0

