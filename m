Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8583E527FAA;
	Mon, 19 Oct 2026 14:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418587; cv=none; b=j+OkeiCOa28UbS8kJPtXxtNmWGKhbmS+u5xoOHn5VWwNmmLUz2z4t0toHphZg6jz0+N4g3Rme3sCftPIsgBnHK0e990izhDBFjC+8ccnC4WZgouPvuRF/RgjxhkhKIIkJhe8WYGAoLKgh85SIBZkPYjEXrnrdcckxzndTGJRef4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418587; c=relaxed/simple;
	bh=d9eepzugWI0eUsprizuLyTYM4VZZkzItQzOh5hLgaR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jLH6rNbRCoaxgbThfT8rly9I8ThNX+bDyo1f7prHhIZ4+wjkb6QqceLo0KXLEHksDRhOU2xyoHKvKeKxIW7QSTgheTwFc0c8xE+atLuBawHu9ijZQyNj42AQc6f9Jew4nBM+K+UtKHD92Gx3yqJQ2fa/i7nf6yzUEmCZA1yQQe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jcz1ymW9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jcz1ymW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D225F1F000C8;
	Mon, 19 Oct 2026 14:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418584;
	bh=CDjR9sIeBIVMIP3tYtRtKI3jJr7u4QaCOiCocgrDXlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jcz1ymW912+DbiFVhANSyAxx+I2dAnTeYIqh349+wMkT94s90GK0ENPikGvJ2nzfM
	 BFKNI6MESCeNglQajoV8GzSggDxe/Pa76IYoY2Fs+1YsNZegGzAkqaJHdVUt55jqRj
	 PjXbIdoi1SVLF8aPdL0+ZBgASlgyGhGPnUpSkzCiAPWnrPT5Nb1zSmab2R+6eDWU6i
	 S6FQU+xWtq93ZYqsKPgBmOsCgIxoRpwW7s+DGdumnocg/5q+LMa/j7Pds2eQb+tmVx
	 8X10o2IEFNndvU653YSwFZdQIe2woAfKlsjx7cGLkZ1ar8Is5lEKpeN4vynEjMvix9
	 5reAvoCIzC7eg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] drm/amdgpu: Gate debugfs MMIO access on kernel lockdown
Date: Mon, 19 Oct 2026 09:50:42 -0400
Message-ID: <20261019135441.1420968-351-sashal@kernel.org>
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

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit 17ac73b24006700f50972d37e297dec1f523c14a ]

amdgpu_regs, amdgpu_regs2, and related debugfs nodes allow
arbitrary MMIO read/write via RREG32/WREG32 without checking
security_locked_down(). On kernel_lockdown=integrity systems
this bypasses the same restrictions as /dev/mem and PCI config
space sysfs.

Check LOCKDOWN_PCI_ACCESS (matching pci-sysfs) at the entry of every
debugfs handler that performs direct register access.

v2: Use consistent check as per previous check to use
LOCKDOWN_DEBUGFS(Lijo)

v3: Do not create any entry from amdgpu_debugfs_regs_init() if
LOCKDOWN_PCI_ACCESS is active and log once. (Lijo)

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject line**
Record: `[drm/amdgpu] [Gate] Restrict debugfs MMIO register nodes when
kernel lockdown is active`

**Step 1.2 — Tags**
Record:
- `Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>` (AMD drm/amdgpu
  reviewer)
- `Signed-off-by: Asad Kamal <asad.kamal@amd.com>` (author)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (amdgpu
  maintainer)
- No `Fixes:`, no `Reported-by:`, no `Cc: stable` (absence expected)
- No syzbot / CVE / bugzilla link
- Changelog notes: v2 suggested `LOCKDOWN_DEBUGFS`; v3 switched to
  skipping node creation under `LOCKDOWN_PCI_ACCESS`

**Step 1.3 — Body**
Record:
- **Bug:** `amdgpu_regs`, `amdgpu_regs2`, and related debugfs nodes
  allow arbitrary GPU MMIO via `RREG32`/`WREG32` with no
  `security_locked_down()` check.
- **Symptom:** On `lockdown=integrity` (Secure Boot distros), this
  bypasses the same class of restriction as `/dev/mem` and PCI BAR
  sysfs.
- **Claimed fix:** Check `LOCKDOWN_PCI_ACCESS` on every MMIO debugfs
  handler.
- **Actual v3:** Do not create those nodes at init if lockdown is
  already active; log once.
- Body still describes v1 (per-handler checks). That is stale vs the
  committed patch.

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. It is an explicit security-policy fix (lockdown
bypass). The “gate/do not create” wording is the fix, not cleanup.

---

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- File: `drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c`
- `+7` lines (include + 5-line early return)
- Function: `amdgpu_debugfs_regs_init()`
- Scope: single-file surgical change

**Step 2.2 — Code flow**
Record:
- **Before:** Probe always creates `amdgpu_regs`, `amdgpu_regs2`,
  `amdgpu_regs_{didt,pcie,smc}`, `amdgpu_gprwave`, `amdgpu_wave`,
  `amdgpu_gpr`, `amdgpu_gca_config`, `amdgpu_sensors`, `amdgpu_gfxoff*`
  under the DRM debugfs root, mode `0400`.
- **After:** If `security_locked_down(LOCKDOWN_PCI_ACCESS)` is true at
  init, skip creation, log, return 0.
- Path: driver probe / debugfs init, not a hot path.

**Step 2.3 — Bug mechanism**
Record: **Security / lockdown bypass**, not UAF/leak/race.

Verified in `fs/debugfs/file.c` `debugfs_locked_down()`:
- Files whose mode has only read bits (`0400`/`0444`), opened O_RDONLY,
  with no ioctl/mmap, are **allowed even under lockdown**.
- `amdgpu_debugfs_regs_fops` (and didt/pcie/smc) have `.read`/`.write`
  but **no** ioctl/mmap, so a read open is allowed.
- The read handler then does `RREG32()`. With bit 62/61 in the offset it
  also calls `amdgpu_gfx_select_se_sh()` /
  `amdgpu_gfx_select_me_pipe_q()`, which **write GPU index registers**
  as a side effect of a read.
- Writes through debugfs are already blocked: `FMODE_WRITE` fails the
  heuristic and `LOCKDOWN_DEBUGFS` denies the open.
- `amdgpu_regs2` / `amdgpu_gprwave` have `.unlocked_ioctl`, so generic
  debugfs lockdown already blocks those; the hole is the plain MMIO read
  files.

This matches PCI BAR mmap (`pci_mmap_resource()` checks
`LOCKDOWN_PCI_ACCESS`) and `/dev/mem` (`LOCKDOWN_DEV_MEM`). PCI config
**reads** are not blocked; BAR/MMIO is.

**Step 2.4 — Fix quality**
Record:
- Obviously correct for the boot-time Secure Boot case (lockdown is
  already on before amdgpu probes).
- Incomplete if lockdown is raised later via
  `/sys/kernel/security/lockdown` after the driver loaded (init-time
  only). Lockdown is one-way and Secure Boot enables it at boot, so the
  common case is covered.
- Slightly broad: also skips sensors/gfxoff/gca_config, not only MMIO.
- Regression risk is low: only locked-down systems lose debugfs register
  nodes. UMR already warns when lockdown is not `none`.
- No new APIs or data structures.

---

## Phase 3: Git history

**Step 3.1 — Blame**
Record:
- `amdgpu_debugfs_regs_init()` introduced in `75758255dc0fae` (Alex
  Deucher, 2017-12-14, “move debugfs functions to their own file”).
- Mode `0444` → `0400` in `c0cfd2e652553` (2024-10-23); that only
  dropped world-read. `0400` still passes the debugfs lockdown read
  heuristic.
- The missing lockdown check is as old as the interface itself.

**Step 3.2 — Fixes: tag**
Record: None. Not applicable.

**Step 3.3 — Related file history**
Record: Recent debugfs work is additive (gfxoff, pagetable, sched
masks). No prerequisite refactor. Standalone. v1 was per-handler checks;
v3 is self-contained.

**Step 3.4 — Author**
Record: Asad Kamal is an AMD contributor (other amdgpu/pm fixes in this
tree). Reviewed by Lijo Lazar; merged by Alex Deucher.

**Step 3.5 — Dependencies**
Record: Needs `security_locked_down()`, `LOCKDOWN_PCI_ACCESS`,
`drm_info()`, `amdgpu_debugfs_regs_init()`. All exist in this tree.
`linux/security.h` stub returns 0 when `CONFIG_SECURITY` is off. Can
apply standalone.

---

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
Record:
- `b4 dig -c 17ac73b24006700f50972d37e297dec1f523c14a` →
  https://patch.msgid.link/20260603114459.938031-1-asad.kamal@amd.com
- v1 2026-05-29 (per-handler `LOCKDOWN_PCI_ACCESS`)
- v2 2026-06-03 (Lijo: `LOCKDOWN_DEBUGFS`)
- v3 2026-06-03 (Lijo: skip creating nodes; log once) — this is what
  landed
- lore.kernel.org fetch returned 403; discussion read via mail-
  archive/search

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: `amd-gfx@lists.freedesktop.org`, Lijo Lazar, Hawking Zhang, Le
Ma, Shiwu Zhang, Alex Deucher, Kevin Yang Wang, Tom StDenis. Right
maintainers.

**Step 4.3 — Bug report**
Record: No external reporter/CVE. Author analysis plus list review.
Nicolas Bouchinet (lockdown LSM, ANSSI) confirmed the read-path gap vs
`debugfs_locked_down()`, then argued reads belong at
**confidentiality**, not `LOCKDOWN_PCI_ACCESS`. Asad kept PCI_ACCESS by
analogy to `pci_mmap_resource()` and `/dev/mem`. Patch still merged.

**Step 4.4 — Series**
Record: Standalone, not patch N/M. No follow-up on this file except
unrelated gfxoff message IDs.

**Step 4.5 — Stable list**
Record: No lore.kernel.org/stable discussion found for this subject.

---

## Phase 5: Semantic / call graph

**Step 5.1 — Functions**
Record: `amdgpu_debugfs_regs_init()` only.

**Step 5.2 — Callers**
Record: `amdgpu_debugfs_init()` → `amdgpu_debugfs_init()` in
`amdgpu_drv.c` (~2477) during device init. One probe-time path.

**Step 5.3 — Callees**
Record: `security_locked_down(LOCKDOWN_PCI_ACCESS)`, `drm_info()`, then
(if allowed) `debugfs_create_file()`.

**Step 5.4 — Reachability**
Record: Needs `CONFIG_DEBUG_FS`, mounted debugfs, and a privileged open
of `0400` nodes. Lockdown’s model is uid-0 vs ring-0, so root-only is
the intended attacker. Distro Secure Boot kernels enable
lockdown=integrity at boot.

**Step 5.5 — Similar patterns**
Record: Same hook in `drivers/pci/pci-sysfs.c` (mmap/write),
`drivers/pci/proc.c`, `drivers/cxl/core/mbox.c`. No other drm driver in
this tree uses it.

---

## Phase 6: This tree (6.18.y)

**Step 6.1 — Buggy code present?**
Record: **Yes.** This checkout is **6.18.53** (`git describe HEAD` →
`v6.18.53-5049-g0f0bdc2b0dffb`, `VERSION=6` `PATCHLEVEL=18`
`SUBLEVEL=53`).
- `amdgpu_debugfs_regs_init()` exists and (without this patch) creates
  MMIO nodes with no lockdown check.
- `LOCKDOWN_PCI_ACCESS` is in `include/linux/security.h`.
- Generic debugfs lockdown is in `fs/debugfs/file.c`.
- The hole is not something introduced after 6.18 branched.

**Step 6.2 — Backport difficulty**
Record: **Clean apply.** Parent context matches: no `linux/security.h`,
same `for` loop and `S_IFREG | 0400`. User-supplied mainline context
mentioned `amdgpu_userq.h`; that header is **not** required here.

**Step 6.3 — Related fixes already here?**
Record: No other lockdown check on these nodes besides this change.
Generic debugfs lockdown does **not** cover `amdgpu_regs` reads.

---

## Phase 7: Subsystem context

**Step 7.1**
Record: `drivers/gpu/drm/amd/amdgpu` — **IMPORTANT** (very common GPU
driver). Security impact is lockdown policy, not all users of amdgpu.

**Step 7.2**
Record: Actively developed, but this function dates to 2017. Mature
interface, late lockdown hole.

---

## Phase 8: Impact and risk

**Step 8.1 — Who**
Record: AMD GPU systems with `CONFIG_DEBUG_FS`, debugfs mounted, and
kernel lockdown (Secure Boot integrity is the usual distro case).

**Step 8.2 — Trigger**
Record: Root reads `/sys/kernel/debug/dri/0/amdgpu_regs` (or siblings)
while lockdown=integrity. Not unprivileged. Timing-independent.

**Step 8.3 — Failure mode**
Record: **HIGH** security-policy bypass (not a panic). Arbitrary GPU
MMIO read; bank-select path writes GRBM/SRBM. Same class of access
lockdown blocks for PCI BAR mmap and `/dev/mem`.

**Step 8.4 — Risk/benefit**
Record:
- **Benefit:** Closes a real uid-0 lockdown hole on common Secure Boot +
  amdgpu boxes.
- **Risk:** Very low (7 lines, probe-only, no-op without lockdown).
  Worst case: debug/UMR register nodes missing under lockdown, which is
  intended.
- **Ratio:** Favorable.

---

## Phase 9: Synthesis

**Step 9.1 — Evidence**

**For:**
- Real lockdown bypass: debugfs heuristic allows read of `0400` MMIO
  files; handlers then `RREG32` and can write index registers.
- Same restriction as PCI BAR mmap / `/dev/mem`.
- Small, obviously correct, maintainer-reviewed (Lijo + Alex).
- All symbols exist in 6.18.53; applies cleanly.
- Lockdown is an important production security feature (Secure Boot
  distros).

**Against:**
- Not a crash/UAF/corruption.
- debugfs + root.
- Init-time check misses lockdown enabled after probe.
- Disables some non-MMIO nodes in the same array.
- LSM reviewer preferred confidentiality-level for pure reads; commit
  message still describes v1.
- No CVE / no in-the-wild report.

**Unresolved:** Full last Nicolas reply after Asad kept PCI_ACCESS was
not fetched (403 on lore). Does not change the code or that it was
merged.

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — 7-line early return; UMR
   impact acked on list.
2. Real bug affecting users? **PASS** — lockdown bypass on Secure Boot +
   amdgpu + debugfs.
3. Important (crash/security/corruption/deadlock)? **PASS** — security
   policy hole (HIGH, not panic).
4. Small and contained? **PASS** — one file, +7.
5. No new features/APIs? **PASS** — restricts existing debugfs under
   existing lockdown.
6. Applies to this tree? **PASS** — 6.18.53 has the nodes, APIs, and
   matching context.

**Step 9.3 — Exception category**
Record: None (not a device ID/quirk/DT/build/docs fix). Qualifies as a
security bug fix.

**Step 9.4 — Decision**
This should be backported to **this** 6.18.53 tree. The hole is in code
that has been here for years, the APIs are present, and the patch is a
minimal lockdown check at the existing init site. Residual limits (init-
time vs open-time; slightly wide node list) are not reasons to keep the
bypass on locked-down production kernels.

---

## What the commit solves for stable users

On kernels with lockdown=integrity (typical Secure Boot), generic
debugfs still allows reading `amdgpu_regs` because mode `0400` looks
“read-only.” That file is not a log; it is unmediated GPU BAR MMIO,
including index-register writes on crafted reads. Stable users on
locked-down distro kernels should not have that path.

## Risk vs benefit

Benefit is closing a lockdown hole for a widely used GPU driver. Risk is
a probe-time skip of debugfs register nodes only when lockdown is
already on.

## Concerns

- Does not re-check on each open if lockdown is enabled after probe.
- Commit text still talks about per-handler checks.
- Those do not block a clean backport to this tree.

---

## Verification
- [Phase 1] Parsed tags: Reviewed-by Lijo Lazar; SOB Asad Kamal + Alex
  Deucher; no Fixes/Reported-by/Cc:stable
- [Phase 1] Body vs v3: claimed per-handler checks; committed code is
  init-time skip
- [Phase 2] Diff: +`#include <linux/security.h>` and 5-line
  `LOCKDOWN_PCI_ACCESS` guard in `amdgpu_debugfs_regs_init()`
- [Phase 2] `debugfs_locked_down()` in `fs/debugfs/file.c:267-283`:
  `0400` + O_RDONLY + no ioctl allows open; writes blocked via
  `FMODE_WRITE`
- [Phase 2] `amdgpu_debugfs_regs_fops` has read/write, no ioctl;
  `regs2`/`gprwave` have `unlocked_ioctl`
- [Phase 2] Read path `amdgpu_debugfs_process_reg_op()`: `RREG32`;
  bank/ring bits call `amdgpu_gfx_select_se_sh` /
  `amdgpu_gfx_select_me_pipe_q`
- [Phase 2] `pci_mmap_resource()` and `pci_write_resource_io()` use
  `LOCKDOWN_PCI_ACCESS`; `pci_read_config` does not
- [Phase 3] `git blame`: `amdgpu_debugfs_regs_init` from
  `75758255dc0fae` (2017); mode `0400` from `c0cfd2e652553` (2024)
- [Phase 3] No `Fixes:` tag
- [Phase 3] Author has other amdgpu commits; no series dependency
- [Phase 4] `b4 dig -c 17ac73b240067…`: v1/v2/v3; landed v3 msgid
  `20260603114459.938031-1-asad.kamal@amd.com`
- [Phase 4] `b4 dig -w`: amd-gfx + Deucher/Lijo/StDenis
- [Phase 4] mail-archive: Lijo R-b; StDenis UMR OK; Bouchinet read-path
  analysis + confidentiality debate
- [Phase 4] lore.kernel.org WebFetch: 403; stable search: no hits
- [Phase 5] Caller: `amdgpu_debugfs_init()` ← `amdgpu_drv.c:2477` probe
- [Phase 6] `git describe HEAD`: `v6.18.53-5049-g0f0bdc2b0dffb`; `make
  kernelversion`: 6.18.53
- [Phase 6] Parent of the change has the same loop/`0400` and no
  `security.h` — clean apply
- [Phase 6] `security_locked_down` / `LOCKDOWN_PCI_ACCESS` / `drm_info`
  present; stub returns 0 without `CONFIG_SECURITY`
- [Phase 8] Failure: lockdown bypass, severity HIGH (security), not
  crash
- UNVERIFIED: complete last Bouchinet mail after Asad’s “keep
  PCI_ACCESS” reply (lore 403)

The fix is small, surgical, applies to this 6.18 tree, and closes a real
kernel-lockdown bypass.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
index cda4696d2dd49..1679ad7d39780 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -26,6 +26,7 @@
 #include <linux/kthread.h>
 #include <linux/pci.h>
 #include <linux/uaccess.h>
+#include <linux/security.h>
 #include <linux/pm_runtime.h>
 
 #include "amdgpu.h"
@@ -1661,6 +1662,12 @@ int amdgpu_debugfs_regs_init(struct amdgpu_device *adev)
 	struct dentry *ent, *root = minor->debugfs_root;
 	unsigned int i;
 
+	if (security_locked_down(LOCKDOWN_PCI_ACCESS)) {
+		drm_info(adev_to_drm(adev),
+			 "amdgpu: HW debugfs nodes disabled (kernel lockdown)\n");
+		return 0;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(debugfs_regs); i++) {
 		ent = debugfs_create_file(debugfs_regs_names[i],
 					  S_IFREG | 0400, root,
-- 
2.53.0

