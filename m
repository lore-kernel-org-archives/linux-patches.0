Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1C7480331;
	Mon, 31 Aug 2026 13:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183478; cv=none; b=X0QWmHWCnAwWRTDsHMs3w8KF2l7odUCFeG1DZk3zXkzaMvEUSnIcClqq1nZDozs7lamwITMNy5PbXP5z3oSPfCU0ow0eym8ugnLUZyRycGdkyswZ0lZ3jy7kRAcTq4KSlL1ziKke+hz9D5KfJmAKE331N6ydRKEwc7rBbu3a2UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183478; c=relaxed/simple;
	bh=NPSNlMd2dyiS+0NW6Z4zhLy5239fLsj646Pe7Hx53Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AzHiMnNkGNAqR0VR5T43WSVJm8dreeVX0iE25WhrFGwRibfBXfJsVILCM+VrAZWE4obt0rwEYtog9jhLcR7/KB2PHLQhb1Dha0ZNH7G3RLMk/SS6LorT799qOXUCH8mMeUQDM/1OO2NM+WMYWRtd7V77HoPOCtkVRWbTcByZW4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jI+ndjq7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jI+ndjq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91401F000E9;
	Mon, 31 Aug 2026 13:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183476;
	bh=7omeuAaScmWAEKQyvgrvSICA5UGv4oMV1eMMTqvJPYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jI+ndjq7u3ZUMSoMFriKK50SK0rT+OqOQG/T58vyVFih+C+S6/B0wpPNops+cc5kX
	 4L06Yb7ErsT70j9AVo/XIdgejxHoD0n0tCMhk2aDYpOgw91PdJfC0x20z31ywcm06F
	 RSAW8XlXXfXnkaKVRgVDC1JA7+5KKjqbf3JRiZnTW7o3DMtzkERNxNrSlHqfrWMx3B
	 /dqqK8oPF7xqi2lk9EvoiCF4KIgfYfHmW6VwONB0CjskAzlklKxEWe7G3zgEayNbci
	 R2v5l42XXA+DHPE1/DTYV5oUtmRkYs7wuJ1e0iw9UJNN3p+b3apMjKyNVvEJmIw+RR
	 HUO/HTJWcCJzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	shawn.lin@rock-chips.com,
	lpieralisi@kernel.org,
	kwilczynski@kernel.org,
	heiko@sntech.de,
	linux-pci@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] PCI: rockchip: Protect root bus removal with rescan lock
Date: Mon, 31 Aug 2026 09:22:27 -0400
Message-ID: <20260831133314.4125787-119-sashal@kernel.org>
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

[ Upstream commit 0bd9611587bb494c33566d825fe34b2705e4b167 ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-8-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse the Subject Line
**Record:** `[PCI: rockchip] [Protect] Protect root bus removal with
rescan lock` — subsystem is Rockchip PCIe host controller; action is
synchronization/protection (bug fix).

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Fixes:** none
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:**
  `https://patch.msgid.link/20260521161822.132996-8-18255117159@163.com`
- **Cc: stable:** none
- **Signed-off-by:** Hans Zhang, Manivannan Sadhasivam, Bjorn Helgaas
  (ignore pipeline-added SOBs per instructions)

Notable: Signed-off-by from PCI maintainer Bjorn Helgaas. No syzbot or
user bug reports.

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug:** `rockchip_pcie_remove()` tears down the root bus without
  holding the global PCI rescan/remove mutex, allowing concurrent sysfs-
  driven rescan or hotplug to operate on the same bus hierarchy.
- **Symptom:** Use-after-free or system crash.
- **Root cause:** Missing `pci_lock_rescan_remove()` /
  `pci_unlock_rescan_remove()` around `pci_stop_root_bus()` +
  `pci_remove_root_bus()`.
- **Version info:** None in commit message.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not disguised — explicitly a race-condition / crash fix, not
cleanup or optimization.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory the Changes
**Record:**
- **Files:** `drivers/pci/controller/pcie-rockchip-host.c` (+2 lines)
- **Functions:** `rockchip_pcie_remove()`
- **Scope:** Single-file, surgical fix (2 lines added)

### Step 2.2: Code Flow Change
**Record:**
- **Hunk (remove path):** Before — `pci_stop_root_bus()` and
  `pci_remove_root_bus()` run unlocked. After — same calls wrapped in
  `pci_lock_rescan_remove()` / `pci_unlock_rescan_remove()`. Affects
  driver remove / module-unbind path only.

### Step 2.3: Identify Bug Mechanism
**Record:** **Category:** Synchronization / race condition.
**Mechanism:** Concurrent sysfs PCI rescan (`/sys/bus/pci/rescan`, per-
device `rescan`, `remove`) or hotplug can walk/modify the bus device
list while `rockchip_pcie_remove()` is tearing it down without the
global mutex that sysfs paths already hold.

### Step 2.4: Assess Fix Quality
**Record:** Obviously correct — matches the established pattern in
`pci_host_common_remove()`, `mtk_pcie_remove()`, `mvebu` and `aardvark`
remove paths. Minimal, no API changes. **Regression risk:** Very low;
mutex is the same one used everywhere else for this purpose.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame Changed Lines
**Record:** `pci_stop_root_bus()` / `pci_remove_root_bus()` in
`rockchip_pcie_remove()` introduced by Rob Herring (2020-05-22, commit
`f473182c7524dd`). Remove function itself dates to Shawn Lin
(2018-05-09). Driver added 2016 (`e77f847df54c6`). Bug has been present
since the stop/remove calls were added without locking.

### Step 3.2: Follow Fixes: Tag
**Record:** No `Fixes:` tag present — N/A.

### Step 3.3: File History for Related Changes
**Record:** Part of a 9-patch series "[PATCH 0/9] PCI: controller: Add
missing rescan lock around root bus removal" (local mbox). Each patch is
independent per cover letter. `pci_lock_rescan_remove()` infrastructure
added in 2014 (`9d16947b75831`). `pci_host_common_remove()` has used the
lock since 2018 (`01fcb7f777a9f`). Fix is **not** yet merged in this
tree (grep shows no lock in rockchip remove; `git log --grep` for
subject returned empty).

### Step 3.4: Author's Other Commits
**Record:** Hans Zhang is an active PCI contributor (cadence, dwc
capability-search series, etc.). Not the Rockchip driver author; fixing
a cross-driver synchronization gap.

### Step 3.5: Prerequisites
**Record:** No dependencies. `pci_lock_rescan_remove()` /
`pci_unlock_rescan_remove()` exist in this tree (since 2014). Driver
includes `../pci.h` → `<linux/pci.h>`, so no new includes needed.
Standalone, applies cleanly.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig` could not be run on an unmerged commit hash. Used
local mbox `20260522_18255117159_pci_controller_add_missing_rescan_lock_
around_root_bus_removal.mbx`. Cover letter explains race with sysfs
rescan/hotplug → UAF/crash. References sashiko-bot review flagging the
same pattern in cadence code. **No review replies** in the mbox (patches
only). WebFetch of lore URL blocked by bot protection.

### Step 4.2: Reviewers
**Record:** Cover letter only; no Reviewed-by/Acked-by in thread. Commit
has SOB from Manivannan Sadhasivam and Bjorn Helgaas (PCI maintainer).

### Step 4.3: Bug Report
**Record:** No external bug report, syzbot, or KASAN trace. Issue
identified by code review / bot review of the pattern.

### Step 4.4: Related Patches
**Record:** 9-patch series for cadence, dwc, altera, brcmstb, iproc,
mediatek, rockchip, vmd, plda. Each independent. Rockchip is patch 7/9.

### Step 4.5: Stable Mailing List
**Record:** No stable-list discussion found in available sources.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `rockchip_pcie_remove()` — only function modified.

### Step 5.2: Trace Callers
**Record:** Called via `.remove = rockchip_pcie_remove` in
`rockchip_pcie_driver`, registered with `module_platform_driver()`.
Triggers on platform device removal: module unload (`rmmod` if built as
module), driver unbind, or platform teardown.

### Step 5.3: Trace Callees
**Record:** `pci_lock_rescan_remove()`, `pci_stop_root_bus()`,
`pci_remove_root_bus()`, `pci_unlock_rescan_remove()`, then
`irq_domain_remove()`, clock/regulator cleanup.

### Step 5.4: Call Chain / Reachability
**Record:** Race is between `rockchip_pcie_remove()` and sysfs paths in
`pci-sysfs.c` (`rescan_store`, `dev_rescan_store`, `remove_store`,
`bus_rescan_store`) — all hold `pci_lock_rescan_remove()`. An admin
writing to `/sys/bus/pci/rescan` (or per-bus/device rescan/remove) while
the driver is being removed can hit the race. Reachable on any Rockchip
system with `CONFIG_PCIE_ROCKCHIP_HOST`.

### Step 5.5: Similar Patterns
**Record:** Controllers **with** lock: `pci-host-common.c`, `pcie-
mediatek-gen3.c`, `pci-mvebu.c`, `pci-aardvark.c`, `pci-hyperv.c`.
Controllers **without** lock (same bug class): rockchip, cadence, dwc,
altera, brcmstb, iproc, mediatek (non-gen3), vmd, plda, tegra, etc.
Rockchip is a clear oversight relative to the common pattern.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Does Buggy Code Exist?
**Record:** **Yes.** Tree is **v6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`, `make kernelversion` → `6.18.44`).
`rockchip_pcie_remove()` at lines 1015–1016 calls `pci_stop_root_bus()`
/ `pci_remove_root_bus()` **without** the lock. Driver present since
v4.8 era; bug since ~2020.

### Step 6.2: Backport Complications
**Record:** **Clean apply** — 2-line addition, no structural changes, no
conflicts expected.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent fix in this tree. `git log --grep="Protect
root bus removal"` returned empty. Mediatek-gen3, mvebu, aardvark, pci-
host-common already have the lock; rockchip does not.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** **drivers/pci/controller** — IMPORTANT. PCI core affects
device enumeration and all downstream PCI devices on Rockchip SoCs
(RK3399, RK3568, etc.).

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; recent rockchip commits in this tree
(link speed, error logging, reset timing).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of Rockchip SoCs with `CONFIG_PCIE_ROCKCHIP_HOST`
(depends on `ARCH_ROCKCHIP`). Embedded/ARM boards using the legacy
Rockchip AXI PCIe host controller.

### Step 8.2: Trigger Conditions
**Record:** Driver remove/unbind concurrent with PCI sysfs rescan or
remove (typically root). Uncommon in steady state but realistic during
module reload, driver unbind testing, or admin sysfs operations.
Requires privileges for sysfs writes; remove path can be triggered by
module unload or device unbind.

### Step 8.3: Failure Mode Severity
**Record:** UAF / kernel crash — **HIGH** (potential **CRITICAL**
depending on exploitability of the freed PCI structures).

### Step 8.4: Risk-Benefit
**Record:** **Benefit:** HIGH — prevents real crashes on a long-standing
code path. **Risk:** VERY LOW — 2-line addition using existing, well-
tested API, matching multiple peer drivers. **Ratio:** Strongly favors
backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real synchronization bug with documented crash/UAF consequence
- Matches PCI core documentation: rescan/remove must run under
  `pci_rescan_remove_lock` (comment in `probe.c` lines 3536–3538)
- Peer drivers already use this pattern; rockchip is an outlier
- 2-line, obviously correct fix
- Buggy code confirmed present in v6.18.44 tree
- Driver has been in production kernels for years
- Signed-off-by PCI maintainer

**AGAINST backport:**
- No user-reported crash or syzbot reproducer (theoretical/code-review
  finding)
- Part of a 9-patch series (but each patch is independent)

**Unresolved:** No runtime crash report; lore thread review discussion
unavailable (bot-blocked).

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — pattern proven across
   multiple drivers; no Tested-by but change is trivial.
2. Fixes a real bug? **PASS** — missing mutex on a documented-required
   code path.
3. Important issue? **PASS** — UAF/system crash.
4. Small and contained? **PASS** — 2 lines, one function.
5. No new features/APIs? **PASS** — synchronization only.
6. Can apply to local tree? **PASS** — APIs and buggy code both present.

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision Rationale

This commit closes a long-standing race in `rockchip_pcie_remove()`
where root bus teardown was not serialized against sysfs PCI
rescan/remove operations. The PCI core has required this mutex since
2014, and the generic host-common remove path has used it since 2018.
Rockchip was simply missed. The fix is minimal, follows established
convention, and prevents crashes on Rockchip platforms during driver
removal concurrent with PCI sysfs operations. For the v6.18.44 tree
being evaluated, the buggy code is present and the fix applies cleanly.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; no Fixes:/Reported-by/syzbot
- **[Phase 2]** Diff: +2 lines in `rockchip_pcie_remove()` wrapping
  stop/remove with lock
- **[Phase 3]** `git describe HEAD` → v6.18.44; `git blame` →
  stop/remove added f473182c (2020); driver since e77f847df54c6 (2016)
- **[Phase 3]** `git show 9d16947b75831` → lock API added 2014; `git
  blame pci-host-common.c` → lock in remove since 01fcb7f777a9f (2018)
- **[Phase 3]** `git log --grep="Protect root bus removal"` → empty (not
  merged)
- **[Phase 4]** Read local mbox cover + patch 7/9; 9 independent
  patches; sashiko-bot race comment verified
- **[Phase 4]** WebFetch lore URL → blocked; b4 dig on unmerged commit →
  N/A
- **[Phase 5]** `grep pci_lock_rescan_remove drivers/pci/controller/` →
  rockchip absent; mvebu/aardvark/mediatek-gen3/hyperv present
- **[Phase 5]** Read `pci-sysfs.c` rescan/remove stores — all hold lock
- **[Phase 5]** Read `probe.c:3536-3552` — documents lock requirement
- **[Phase 6]** Read `rockchip_pcie_remove()` lines 1009–1016 — buggy
  code confirmed in tree
- **[Phase 6]** `Kconfig` → `PCIE_ROCKCHIP_HOST` tristate,
  `ARCH_ROCKCHIP`
- **[Phase 8]** Race between remove and sysfs rescan → UAF/crash per
  commit message and PCI core design

**YES**The background checks finished and match what the analysis
already assumed:

- **Search for commit in tree:** `b4 dig` on HEAD didn’t match this
  patch; `git log --grep` for the subject also found nothing. The fix
  isn’t in this tree yet.
- **Check if fix already merged:** `git log --grep="rockchip.*rescan
  lock"` and `--grep="Protect root bus removal"` both returned empty —
  confirmed not merged in v6.18.44.

**Verdict stands: YES** — backport the 2-line `pci_lock_rescan_remove()`
wrap in `rockchip_pcie_remove()` to close the sysfs rescan/remove race.

 drivers/pci/controller/pcie-rockchip-host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-rockchip-host.c b/drivers/pci/controller/pcie-rockchip-host.c
index ee1822ca01db3..d203c4876d304 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -1012,8 +1012,10 @@ static void rockchip_pcie_remove(struct platform_device *pdev)
 	struct rockchip_pcie *rockchip = dev_get_drvdata(dev);
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(rockchip);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(bridge->bus);
 	pci_remove_root_bus(bridge->bus);
+	pci_unlock_rescan_remove();
 	irq_domain_remove(rockchip->irq_domain);
 
 	rockchip_pcie_deinit_phys(rockchip);
-- 
2.53.0

