Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3438858B6C7;
	Mon, 31 Aug 2026 13:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184235; cv=none; b=NjVr19e+EqQRH3xNHaPZJ7ZE9ohM0xs3yT5cXbbOlOy+KTTLAT2XIHRJEnRKeYuDxzXTcVso48YH+RRzWwCmSIo9L4K75TJf5zN7w7oNDFI4uZLpScy50FeXKqZ6KAmrC/4mN6Wt21nswYx/SyR/il/BJsLLMQkSo/g+eT1DtQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184235; c=relaxed/simple;
	bh=Wcghe1FVJIscBa5KOWBEgGmrrpcV3pXkLc3/u2Ln1JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TGs7gJriUzat+Q6a90SR0/JDgY0YPb2fXAUWXXEZw/YloHlgX6MuhHIxxQPxZjepnPjneQ1brYBe/i2TO3emTVJz8XauxVJSTBnfj8OefRFG/0EaqL2jIKhN14kBqaY0cwywG69S/Bzql6uHwqC2qkDkZRpcl9k45egxTfJ4Vms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SnhtfPUh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SnhtfPUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B781F00A3E;
	Mon, 31 Aug 2026 13:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184232;
	bh=GWWRbb5fx/50qNvFfhxhjVCsZ2dC5kuRKeGuqJBIxak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SnhtfPUhVX74L1ZiyCv6GpdPBCNNhURN5zDrCnYxj9ZKVh7BVKduUlVx1BXs1rms9
	 lNrfZvFtQCtrgz+ZFA19cvg6WDXOYIYAPo23lCftcmlYqqvo+XyTfOFFYhlz7f6sVB
	 Esj+JDdXaTquKP0qlALYL8xI5IQ+bJIqRshmtD1mZloQ8Yai5owpTyll6cfZ9Er+6C
	 7MxUFCe66q9tw2la0wtz1bGIf+XEawLHnl8bS40sMvyed+XYI/8x70BZhZ3aYCLIJu
	 woxU6SJ3g0e+XwpU6sUnYXFieRap8Joy/1G29h4KVQZFs9kQlRDZdrTW57YPd+twgX
	 vNbBXNQdkJtHQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	jingoohan1@gmail.com,
	lpieralisi@kernel.org,
	kwilczynski@kernel.org,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] PCI: dwc: Protect root bus removal with rescan lock
Date: Mon, 31 Aug 2026 09:29:58 -0400
Message-ID: <20260831133314.4125787-570-sashal@kernel.org>
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

[ Upstream commit 26335696498ab502e907a556e97c7039bc80a87e ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-3-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[PCI: dwc]` `[Protect]` — Add synchronization around root
bus teardown in the DesignWare PCIe host controller to prevent races
with concurrent PCI rescan/hotplug.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Link:**
  `https://patch.msgid.link/20260521161822.132996-3-18255117159@163.com`
- **Signed-off-by:** Hans Zhang `<18255117159@163.com>`
- **Signed-off-by:** Manivannan Sadhasivam `<mani@kernel.org>`
- **Signed-off-by:** Bjorn Helgaas `<bhelgaas@google.com>` (with
  `[bhelgaas: commit log]`)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org`
- Notable: PCI maintainer (Bjorn Helgaas) committed; DWC maintainer
  (Mani) signed off. No syzbot or user crash report in the message
  itself.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `dw_pcie_host_deinit()` stops and removes the root bus
  without holding `pci_rescan_remove_lock`.
- **Symptom:** Race with concurrent sysfs-triggered PCI rescan or
  hotplug; may cause use-after-free or system crashes.
- **Root cause:** `pci_stop_root_bus()` / `pci_remove_root_bus()` are
  not serialized against sysfs paths that already take
  `pci_lock_rescan_remove()`.
- **Version info:** None in the message.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not hidden — this is an explicit synchronization bug fix.
The “protect” wording and UAF/crash description clearly indicate a real
concurrency defect, not cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `drivers/pci/controller/dwc/pcie-designware-host.c` (+2
  lines)
- **Function:** `dw_pcie_host_deinit()`
- **Scope:** Single-file, surgical fix (2 insertions around existing
  calls)

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Hunk (deinit path):**
  - **Before:** `pci_stop_root_bus()` and `pci_remove_root_bus()` run
    unlocked during driver teardown.
  - **After:** Same operations run under `pci_lock_rescan_remove()` /
    `pci_unlock_rescan_remove()`.
  - **Path affected:** Platform driver remove / module unload / probe
    error cleanup via `dw_pcie_host_deinit()`.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Category:** Race condition / synchronization bug (can manifest as
  UAF or crash).
- **Mechanism:** Sysfs rescan/remove (`rescan_store`, `remove_store`,
  `bus_rescan_store` in `pci-sysfs.c`) holds `pci_rescan_remove_lock`.
  DWC host teardown did not, so two threads could concurrently mutate
  the same PCI bus/device tree.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- **Quality:** Obviously correct; matches the established pattern in
  `pci_host_common_remove()`, `pci-aardvark.c`, `pci-mvebu.c`, `pci-
  hyperv.c`, etc.
- **Regression risk:** Very low. The lock is a global PCI mutex already
  used widely; holding it only around bus stop/remove is the intended
  usage documented in `probe.c`.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:**
- `pci_stop_root_bus()` / `pci_remove_root_bus()` in
  `dw_pcie_host_deinit()` introduced in commit `5808d43e7c91b2` (Rob
  Herring, Aug 2020).
- `dw_pcie_host_deinit()` itself dates to 2019.
- **Bug present since:** ~2020 in this function; DWC host code never had
  the rescan lock (`git log -S 'pci_lock_rescan_remove' -- pcie-
  designware-host.c` returned empty).

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag. N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:**
- Related fix in-tree: `1d59d474e1cb7` — “PCI: Hold rescan lock while
  adding devices during host probe” (Oct 2024), with a documented NULL
  deref crash from concurrent probe vs. sysfs remove.
- This commit is patch **2/9** in series “PCI: controller: Add missing
  rescan lock around root bus removal”; cover letter states **each patch
  is independent**.
- Fix is **not yet merged** in this tree (current `pcie-designware-
  host.c` still lacks the lock).

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Hans Zhang is an active PCI contributor (capability-search
refactors, cadence/dwc work). This series is a targeted locking fix, not
part of a larger refactor.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:**
- **Dependency:** `pci_lock_rescan_remove()` API from `9d16947b75831`
  (Jan 2014) — **present in this tree**.
- **Standalone:** Yes; no structural/API prerequisites beyond the
  existing lock helpers.
- Buggy code (`5808d43e7c91b2`) is also an ancestor of HEAD.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:**
- `b4 dig -c` failed (commit not in local history yet).
- Local mbox/cover files found: `20260522_18255117159_pci_controller_add
  _missing_rescan_lock_around_root_bus_removal.{cover,mbx}`.
- **Series:** 9 independent patches; this is patch 2/9 (DWC).
- **Cover letter context:** Bot review on a separate cadence patch
  flagged the same missing-lock pattern; author submitted this series to
  fix all affected controllers.
- **Lore URL fetch:** Blocked by Anubis anti-bot on lore.kernel.org.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** From commit message: Manivannan Sadhasivam (DWC maintainer)
SOB; Bjorn Helgaas (PCI maintainer) committed. `b4 dig -w` not available
for this unreleased commit.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No `Reported-by:` or crash trace in this specific patch.
Precedent crash documented in `1d59d474e1cb7` for the **probe/add** side
of the same locking gap. This fix addresses the symmetric **remove**
side.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** 8 sibling patches fix the same pattern in cadence, altera,
brcmstb, iproc, mediatek, rockchip, vmd, plda. Each is independently
backportable.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Not searched (lore blocked). No stable-list discussion found
in local mbox files.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `dw_pcie_host_deinit()` — only function modified.

### Step 5.2: TRACE CALLERS
**Record:** `dw_pcie_host_deinit()` is called from multiple DWC-based
platform drivers:
- `pcie-tegra194.c` (`tegra_pcie_deinit_controller()` → platform
  `.remove` and probe error path)
- `pcie-stm32.c`, `pcie-rcar-gen4.c`, `pci-meson.c`, `pci-dra7xx.c`,
  `pcie-bt1.c`, `pci-exynos.c`, `pcie-kirin.c`, `pcie-intel-gw.c`
- **Context:** Driver remove, module unload, and probe failure cleanup
  on embedded/SoC platforms using Synopsys DWC PCIe.

### Step 5.3: TRACE CALLEES
**Record:** Key callees in the critical section:
- `pci_stop_root_bus()` — stops child devices, releases host bridge
  driver
- `pci_remove_root_bus()` — removes child devices, deletes host bridge
  from device model
- Both documented to require the rescan/remove lock when racing with
  sysfs operations.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:**
- **Trigger A:** Platform device remove / module rmmod →
  `dw_pcie_host_deinit()` → unlocked bus teardown.
- **Trigger B (concurrent):** Root/admin writes to
  `/sys/bus/pci/rescan`, `/sys/bus/pci/devices/.../remove`, or per-bus
  rescan sysfs → `pci_lock_rescan_remove()` → bus mutation.
- **Userspace reachability:** Sysfs PCI operations require privileges;
  race is realistic during driver unbind/rebind, hotplug, or admin
  tooling — not merely theoretical.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** In this tree, several controllers already protect removal
with the lock (`pci-host-common.c`, `pci-aardvark.c`, `pci-mvebu.c`,
`pcie-mediatek-gen3.c`, `pci-hyperv.c`). DWC and others listed in the
series do **not** — inconsistent, known-bad pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:**
- **Tree:** `v6.18.44` (`stable/linux-6.18.y`, detached HEAD at
  `2736c32da98b9`)
- **Buggy code:** **YES** — `pcie-designware-host.c:709-710` calls
  `pci_stop_root_bus()` / `pci_remove_root_bus()` without locking.
- **Bug age:** Present since ~2020; not a post-6.18 regression.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** **Clean apply expected** — 2-line addition with no context
conflicts. File has recent churn but the `dw_pcie_host_deinit()`
teardown block is stable and matches the patch hunk.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** Probe-side rescan lock fix (`1d59d474e1cb7`) is in-tree.
Remove-side DWC fix is **not** present. No duplicate fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **PCI / DWC host controller drivers** — **IMPORTANT**.
Affects many ARM/embedded SoC platforms (Tegra, STM32, Kirin, Meson,
Exynos, R-Car, etc.), not universal but widely deployed.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** PCI controller code is actively maintained; recent related
stable-worthy fix (`1d59d474e1cb7`) shows the subsystem maintainers
treat rescan-lock gaps as real crash bugs.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** Users of DWC-based PCIe host controllers on platforms using
`dw_pcie_host_deinit()` — embedded ARM servers/devices, Tegra, various
SoCs. Config-dependent on `CONFIG_PCIE_DW_HOST` and specific platform
drivers.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:**
- **Trigger:** Concurrent root bus removal (driver unload/remove) with
  sysfs PCI rescan/remove/hotplug.
- **Likelihood:** Uncommon but realistic during driver rebinding,
  development, or admin maintenance.
- **Unprivileged trigger:** No direct unprivileged sysfs access; race
  still matters for system stability under privileged operations.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:**
- **Failure mode:** Use-after-free, NULL pointer dereference, kernel
  oops/crash during concurrent bus teardown.
- **Severity:** **CRITICAL** (system crash; potential memory
  corruption).

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** **High** — prevents crashes on a common PCIe IP block
  across many platforms; aligns DWC with already-fixed controllers.
- **Risk:** **Very low** — 2-line, established locking pattern, no
  API/behavior change beyond proper serialization.
- **Ratio:** Strong benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Real race between bus removal and sysfs rescan/remove paths.
- Documented failure modes (UAF/crash) in commit message; strong
  precedent in `1d59d474e1cb7`.
- Tiny, obviously correct fix matching multiple in-tree controllers.
- Buggy code present in v6.18.44; prerequisites
  (`pci_lock_rescan_remove`) present.
- Standalone patch; maintainer-reviewed.
- Affects widely used DWC PCIe host path on many embedded platforms.

**AGAINST backporting:**
- No explicit user crash report or syzbot entry for this specific patch.
- Race requires concurrent privileged sysfs activity (somewhat
  uncommon).
- Part of a 9-patch series (though each patch is independent).

**UNRESOLVED:**
- Full lore.kernel.org review thread (blocked by anti-bot).
- No independent `Tested-by:` on this specific DWC patch.

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — pattern is standard;
   maintainer SOBs; no test report but fix is trivial and well-
   precedented.
2. Fixes a real bug? **PASS** — missing lock on a documented race path.
3. Important issue? **PASS** — UAF/kernel crash potential
   (**CRITICAL**).
4. Small and contained? **PASS** — 2 lines, one function.
5. No new features or APIs? **PASS** — uses existing lock API only.
6. Can apply to the local tree? **PASS** — buggy code and API both
   present; clean apply expected.

### Step 9.3: EXCEPTION CATEGORIES
**Record:** None (not a quirk/DT/build/docs fix). This is a core
synchronization bug fix.

### Step 9.4: DECISION RATIONALE

For **linux-6.18.y** (`v6.18.44`), `dw_pcie_host_deinit()` removes the
root PCI bus without the global rescan/remove lock that sysfs PCI
operations already use. That is the same class of defect already fixed
on the probe/add path (`1d59d474e1cb7`) and already handled correctly in
several other PCI host controller drivers in this tree. The fix is
minimal, self-contained, and prevents realistic kernel crashes during
driver teardown on DWC-based platforms.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; no Fixes/Reported-by;
  maintainer SOBs present.
- **[Phase 2]** Confirmed diff: +2 lines wrapping
  `pci_stop/remove_root_bus` in `dw_pcie_host_deinit()`.
- **[Phase 3]** `git blame`: buggy calls from `5808d43e7c91b2` (2020);
  `git log -S`: DWC never had rescan lock.
- **[Phase 3]** `git merge-base --is-ancestor`: `9d16947b75831` YES,
  `5808d43e7c91b2` YES.
- **[Phase 3]** Related fix `1d59d474e1cb7` confirmed in tree with crash
  stack trace.
- **[Phase 3]** `git log --grep`: fix not merged in this tree.
- **[Phase 4]** Read local mbox/cover for series context; patch 2/9,
  independent patches stated.
- **[Phase 4]** `b4 dig -c`: failed (commit not in tree); lore fetch
  blocked.
- **[Phase 5]** `grep dw_pcie_host_deinit(`: 9 platform driver call
  sites verified.
- **[Phase 5]** Read `pci-sysfs.c`: rescan/remove paths use
  `pci_lock_rescan_remove()`.
- **[Phase 5]** Read `pci-host-common.c`, `probe.c`: lock pattern and
  API confirmed.
- **[Phase 5]** `grep pci_lock_rescan_remove` in
  `drivers/pci/controller/`: multiple drivers already protected; DWC
  not.
- **[Phase 6]** `git describe HEAD`: `v6.18.44-1-g2736c32da98b9`;
  `Makefile`: 6.18.44.
- **[Phase 6]** Read `pcie-designware-host.c:703-724`: buggy code
  confirmed present.
- **[Phase 8]** Traced `tegra_pcie_dw_remove` →
  `tegra_pcie_deinit_controller` → `dw_pcie_host_deinit`.

**YES**The analysis is complete: **backport this commit to
linux-6.18.y**.

`dw_pcie_host_deinit()` in `pcie-designware-host.c` removes the root PCI
bus without `pci_lock_rescan_remove()`, which can race with sysfs
rescan/remove and cause UAF or kernel crashes. The fix is two lines,
matches patterns already used in other PCI host drivers in this tree,
and applies cleanly to v6.18.44 where the bug is still present.

**YES**

 drivers/pci/controller/dwc/pcie-designware-host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 48e4a887bb1bb..d5c24098c3dd3 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -706,8 +706,10 @@ void dw_pcie_host_deinit(struct dw_pcie_rp *pp)
 
 	dwc_pcie_debugfs_deinit(pci);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(pp->bridge->bus);
 	pci_remove_root_bus(pp->bridge->bus);
+	pci_unlock_rescan_remove();
 
 	dw_pcie_stop_link(pci);
 
-- 
2.53.0

