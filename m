Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857A35437DC;
	Mon, 31 Aug 2026 13:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183967; cv=none; b=XDKQHd6GCZy4nH6nhD2u3DkNN4XRzVNn6mdS/MzfFSGt80ku1Mmg5g5TGQx3aovto2/9f2sHhcfRBz4y2qbt7UwS7DzBrexmeC/WbqVjV3zKShBMh6acwfAuxbU1foF5JyiyiWnd55Uq+XPBf+RyJ2q3EpcHNTmyz40jpjseLSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183967; c=relaxed/simple;
	bh=OUfVN+GTiougq4j02QoJoWo+ELfHrBQLfVVpGOZn2Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tJDFK+zcoBPoZo3ynvLZ3DZ+ubcOmqq+41NPxWzFbx09Va0i5v+vtEX8IE4KApBTuR6IzZGRwQyvHasdGu1vZQX1mAlBxLnSLC+vK0Ldd9U++DPLSkUwNu0Ej9hATO7cM7xyCFb8JhU5RA5AqcX+2l8jdy7zYBVh+Rb93KM8xN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4bahObr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4bahObr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EFD1F00A3D;
	Mon, 31 Aug 2026 13:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183964;
	bh=CsKuVl9t2r+9keaNno2zOge1SpbypJ/7oakk7iJlZVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4bahObrzrkHEZWX10X1JCxuaXTcxMdDUb/nUm31sUrq3dBokdGAsK0ea2yMcFvA2
	 3+fmTOzeG2RBeHBJntGi72vP46+42xCWcvn8YdLMhpQQ17ag2RfwBhhLc3uPNKupVW
	 tA0cBfcZ0hmnwMgZdq9xvab6Cljan2MQYXC2iM66tK7dkHOZboydkoR+IoJNPAmq4n
	 u/Ok0OvQvFnR44sUzWFwL5Gcqk9t+xJOU3azizUlEMF64cPTWnLDmrKGkEVVwO3fXK
	 QHOBaXHxkW6ValZPzFq3VdUG206NG49zTIUrK+7nR7gjukV3Y3nYy0J/J7LHnf5bnT
	 lSUcjjs7O4kdA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	lpieralisi@kernel.org,
	kwilczynski@kernel.org,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] PCI: cadence: Protect root bus removal with rescan lock
Date: Mon, 31 Aug 2026 09:27:16 -0400
Message-ID: <20260831133314.4125787-408-sashal@kernel.org>
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

From: Hans Zhang <18255117159@163.com>

[ Upstream commit 713331969ce89489c84af917058df6d9910cff97 ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-2-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[PCI: cadence] [Protect] Root bus removal must hold the
global PCI rescan/remove mutex during teardown.`

### Step 1.2: Commit message tags
**Record:**
- **Fixes:** none
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none (in commit message; cover letter references
  sashiko-bot review)
- **Acked-by:** none
- **Link:**
  https://patch.msgid.link/20260521161822.132996-2-18255117159@163.com
- **Cc: stable:** none
- **Signed-off-by:** Hans Zhang, Manivannan Sadhasivam, Bjorn Helgaas
  (ignore pipeline-added SOBs)

Notable: no syzbot/user crash report; motivation comes from code review
and subsystem locking rules.

### Step 1.3: Commit body analysis
**Record:**
- **Bug:** `cdns_pcie_host_disable()` calls `pci_stop_root_bus()` /
  `pci_remove_root_bus()` without `pci_rescan_remove_lock`.
- **Symptom:** Race with concurrent sysfs PCI rescan or hotplug/remove;
  author cites possible UAF or system crash.
- **Root cause:** Root-bus teardown is not serialized with sysfs-driven
  rescan/remove paths that take the same lock.
- **Version info:** none in commit message.

### Step 1.4: Hidden bug fix detection
**Record:** Yes. Despite “Protect” rather than “fix”, this is a
synchronization bug fix, not cleanup or a feature. It matches the
established pattern used elsewhere in PCI host drivers.

---

## Phase 2: Diff Analysis

### Step 2.1: Change inventory
**Record:**
- **Files:** `drivers/pci/controller/cadence/pcie-cadence-host.c` (+2
  lines)
- **Function:** `cdns_pcie_host_disable()`
- **Scope:** Single-file, surgical fix (2 lines)

### Step 2.2: Code flow change
**Record:**
- **Before:** `pci_stop_root_bus()` → `pci_remove_root_bus()` with no
  lock.
- **After:** `pci_lock_rescan_remove()` wraps those calls, then
  `pci_unlock_rescan_remove()`.
- **Path:** Driver teardown / module unload (`j721e_pcie_remove()`,
  `sg2042_pcie_remove()`).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Race condition / missing synchronization.
- **Mechanism:** Sysfs rescan/remove holds `pci_rescan_remove_lock` (see
  `rescan_store`, `dev_rescan_store`, `remove_store` in `pci-sysfs.c`).
  Cadence host disable did not, so teardown could interleave with sysfs
  operations on the same bus hierarchy.

### Step 2.4: Fix quality
**Record:**
- **Quality:** High. Matches `pci_host_common_remove()` and
  `mtk_pcie_remove()`.
- **Regression risk:** Very low. Standard mutex already used across PCI
  core and many host drivers.
- **Red flags:** None.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- Unlocked `pci_stop_root_bus()` / `pci_remove_root_bus()` introduced in
  **47f25da6c5ea5** (“PCI: cadence-host: Introduce
  cdns_pcie_host_disable() helper for cleanup”, 2025-04-17).
- Present in this tree (6.18.44).

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Bug introduced by 47f25da6c5ea5 when
the helper was added without the lock.

### Step 3.3: Related file history
**Record:**
- **47f25da6c5ea5:** introduced `cdns_pcie_host_disable()`.
- **a2790bf81f0f7:** J721E module support uses the helper on remove.
- **1c72774df0284:** SG2042 driver uses it on remove.
- **1d59d474e1cb7:** probe-side rescan-lock fix with real crash trace
  (related pattern).
- **60e7b5aa85712:** lockdep assert added because this lock is required
  for removal paths.
- Fix commit is **not** merged in this tree yet.

### Step 3.4: Author context
**Record:** Hans Zhang has recent PCI controller patches. Mani
Sadhasivam and Bjorn Helgaas are PCI maintainers. Patch is part of a
9-patch series; cover letter says each patch is independent.

### Step 3.5: Dependencies
**Record:** None.
- `pci_lock_rescan_remove()` / `pci_unlock_rescan_remove()` exist and
  are exported.
- `cdns_pcie_host_disable()` exists in this tree.
- `pcie-cadence.h` includes `<linux/pci.h>`.
- Standalone backport.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:**
- Local mbox/cover: `20260522_18255117159_pci_controller_add_missing_res
  can_lock_around_root_bus_removal.{cover,mbx}`
- Series: **[PATCH 1/9]** for cadence; 9 independent controller-driver
  fixes.
- Cover cites sashiko-bot review asking whether unlocked teardown can
  race.
- `b4 dig` on HEAD did not match this commit (not merged yet).
- lore.kernel.org fetch returned 403 from this environment.

### Step 4.2: Reviewers
**Record:** Cover references sashiko-bot review thread. No explicit
maintainer stable nomination found in local mbox. Signed-off-by includes
PCI maintainers.

### Step 4.3: Bug report
**Record:** No user crash report or syzbot link for cadence
specifically. Precedent: **1d59d474e1cb7** documents a real NULL-deref
crash from the same class of race on the probe/add side.

### Step 4.4: Related patches
**Record:** 8 sibling patches for dwc, altera, brcmstb, iproc, mediatek,
rockchip, vmd, plda. Independent; cadence patch does not require them.

### Step 4.5: Stable list
**Record:** No stable-list discussion found (lore inaccessible; local
mbox has no `Cc: stable`).

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `cdns_pcie_host_disable()` modified.

### Step 5.2: Callers
**Record:**
- `sg2042_pcie_remove()` — platform driver `.remove`
- `j721e_pcie_remove()` — platform driver `.remove` (RC mode)

Both run on driver unbind/module unload; can overlap with root-
privileged sysfs PCI operations.

### Step 5.3: Callees
**Record:** `pci_host_bridge_from_priv()`, `pci_stop_root_bus()`,
`pci_remove_root_bus()`, then `cdns_pcie_host_deinit()`,
`cdns_pcie_host_link_disable()`.

### Step 5.4: Reachability
**Record:**
- Trigger: driver remove/unbind while another context does sysfs
  `rescan` or `remove` on the same PCI hierarchy.
- Sysfs paths are root-accessible; concurrent admin activity during
  driver unload is realistic on embedded systems using Cadence PCIe (TI
  J721E, Sophgo SG2042).

### Step 5.5: Similar patterns
**Record:** Correct pattern already used in:
- `pci_host_common_remove()` (`pci-host-common.c:105-108`)
- `mtk_pcie_remove()` (`pcie-mediatek-gen3.c:1222-1225`)
- Many hotplug/EEH paths

Cadence was an outlier missing the lock.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current `cdns_pcie_host_disable()` at lines 618-628
in `pcie-cadence-host.c` lacks the lock. Tree: **v6.18.44** (`git
describe HEAD` → `v6.18.44-1-g2736c32da98b9`).

### Step 6.2: Backport complications
**Record:** Clean apply expected — 2-line addition in one function. No
conflicting changes seen.

### Step 6.3: Related fixes already present?
**Record:** Probe-side lock fix (1d59d474e1cb7) and lockdep assert
(60e7b5aa85712) are in tree. Cadence removal-side fix is **not**.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem criticality
**Record:** `drivers/pci/controller/cadence` — **IMPORTANT** (PCI host
controller). Affects embedded platforms with Cadence PCIe RC (J721E,
SG2042, etc.), not universal desktop paths.

### Step 7.2: Subsystem activity
**Record:** Active — recent cadence commits (module support, SG2042,
capability search, ops checks).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Users of Cadence PCIe host controller drivers built as
modules or unbound during runtime, especially J721E and SG2042
platforms.

### Step 8.2: Trigger conditions
**Record:**
- Concurrent sysfs PCI rescan/remove and host driver teardown.
- Uncommon but plausible under admin automation or test scripts.
- Root can trigger sysfs paths; unprivileged users cannot directly, but
  crashes affect the whole system.

### Step 8.3: Failure mode severity
**Record:** UAF / kernel crash — **HIGH** (potential **CRITICAL** if
exploited or during production teardown). No cadence-specific crash log,
but PCI core documents this lock requirement and a similar race already
produced a crash on the add path.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Medium-high for affected platforms; prevents a known
  class of PCI race.
- **Risk:** Very low — 2 lines, established pattern.
- **Ratio:** Favorable for backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real missing synchronization on PCI root-bus removal.
- Matches documented PCI locking rules and peer drivers.
- Small, obviously correct, standalone.
- Buggy code exists in 6.18.44 since 47f25da6c5ea5.
- Same subsystem already fixed probe-side race with documented crash
  (1d59d474e1cb7).
- lockdep enforcement (60e7b5aa85712) shows maintainers treat this lock
  as mandatory.

**AGAINST backport:**
- No concrete crash report for cadence specifically.
- Race needs concurrent sysfs activity during driver remove.
- Exposure window starts only from April 2025 when
  `cdns_pcie_host_disable()` was added.

**Unresolved:**
- Full lore review thread not readable here (403).
- No Tested-by on the patch itself.

The unresolved items are not enough to override the clear
synchronization defect.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — matches existing PCI
   patterns; no Tested-by.
2. Fixes a real bug? **PASS** — missing lock on documented-required
   path.
3. Important issue? **PASS** — race can cause UAF/crash (HIGH).
4. Small and contained? **PASS** — 2 lines, one function.
5. No new features/APIs? **PASS**.
6. Can apply to local tree? **PASS** — prerequisites present; clean
   apply expected.

### Step 9.3: Exception categories
**Record:** None (not quirk/DT/build/docs). Standard bug-fix
synchronization.

### Step 9.4: Decision rationale

For **linux-6.18.y** (this checkout), `cdns_pcie_host_disable()`
performs root-bus teardown without `pci_rescan_remove_lock`, while sysfs
rescan/remove and many other PCI paths hold that lock. That is a real
race with crash/UAF potential, introduced when the helper was added in
47f25da6c5ea5. The fix is minimal, follows `pci_host_common_remove()`
and other host drivers, and needs no dependencies. PCI maintainers have
already treated this lock as mandatory elsewhere in the subsystem.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message and local mbox.
- **[Phase 1]** Read cover letter in `20260522_18255117159_pci_controlle
  r_add_missing_rescan_lock_around_root_bus_removal.cover`.
- **[Phase 2]** Confirmed diff: +2 lines around `pci_stop_root_bus()` /
  `pci_remove_root_bus()` in `cdns_pcie_host_disable()`.
- **[Phase 2]** Read current `cdns_pcie_host_disable()` at lines 618-628
  — no lock present.
- **[Phase 3]** `git describe HEAD` → v6.18.44; Makefile
  VERSION/PATCHLEVEL/SUBLEVEL = 6.18.44.
- **[Phase 3]** `git blame -L 618,628` → 47f25da6c5ea5 introduced
  unlocked removal.
- **[Phase 3]** `git merge-base --is-ancestor 47f25da6c5ea5 HEAD` →
  ancestor confirmed.
- **[Phase 3]** `git show 1d59d474e1cb7` → probe-side rescan lock fix
  with crash trace.
- **[Phase 3]** `git show 60e7b5aa85712` → lockdep assert on removal
  paths.
- **[Phase 3]** `git log --oneline -S cdns_pcie_host_disable` → callers
  in j721e/sg2042.
- **[Phase 4]** Read local mbox patch 1/9; series is 9 independent
  patches.
- **[Phase 4]** `b4 dig -c HEAD` — no match (commit not merged).
- **[Phase 4]** lore.kernel.org curl — 403 Forbidden (discussion not
  fully verified online).
- **[Phase 5]** Grep callers: `pci-j721e.c:670`, `pcie-sg2042.c:80`.
- **[Phase 5]** Read `pci-sysfs.c` rescan/remove stores — they take
  `pci_lock_rescan_remove()`.
- **[Phase 5]** Read `pci_host_common_remove()` and `mtk_pcie_remove()`
  — correct locking pattern.
- **[Phase 5]** Read `probe.c:3536-3552` — documents mutex requirement
  for rescan/removal.
- **[Phase 6]** Buggy code confirmed present; fix not merged (`git log
  --grep="Protect root bus removal"` — empty).
- **[Phase 6]** `pcie-cadence.h` includes `<linux/pci.h>` — lock APIs
  available.
- **UNVERIFIED:** Whether any production system has hit this specific
  cadence crash (no report found).

**YES**The analysis is done for **linux-6.18.y** (`v6.18.44`).

**Verdict: YES** — backport this commit.

`cdns_pcie_host_disable()` tears down the root bus without
`pci_rescan_remove_lock`, while sysfs rescan/remove and other PCI paths
use that lock. That can race on driver remove/unbind (J721E, SG2042) and
lead to crashes or use-after-free. The fix is two lines, matches
patterns like `pci_host_common_remove()`, and applies cleanly here; the
buggy path has been present since `cdns_pcie_host_disable()` was added
in 47f25da6c5ea5.

 drivers/pci/controller/cadence/pcie-cadence-host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-host.c b/drivers/pci/controller/cadence/pcie-cadence-host.c
index fffd63d6665e8..c8daa5847c0f3 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-host.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-host.c
@@ -620,8 +620,10 @@ void cdns_pcie_host_disable(struct cdns_pcie_rc *rc)
 	struct pci_host_bridge *bridge;
 
 	bridge = pci_host_bridge_from_priv(rc);
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(bridge->bus);
 	pci_remove_root_bus(bridge->bus);
+	pci_unlock_rescan_remove();
 
 	cdns_pcie_host_deinit(rc);
 	cdns_pcie_host_link_disable(rc);
-- 
2.53.0

