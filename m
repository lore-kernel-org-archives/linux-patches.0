Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6011D4B5CD1;
	Mon, 31 Aug 2026 13:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184379; cv=none; b=h+QfPwogCYbK6l3rCIZ4jmM113Me1Rh8hdl/jDCdRuPAGei7kbOQnWwmFt4WohXqJAy+v9FNUqEdFnK8z5EP+BrcbWhkoifQKyWJqMTIG6+6us6k4Y2g4VgBo7lmAkQ8Xi9lpEgdAU/lHKuA4lsjsNrHzIdAHXohKj5ZaQQpD0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184379; c=relaxed/simple;
	bh=vPZwDHvCl0UvoVa6vZba7WM0FsaIr4gjgJ5uDGtZu6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eHogdKJpdtF1rqncGqOsrb6sJywq63YK9c1Qy33YIDB1JLLNGJm7zI7RLYQ/k+PPcU/UZcPd9f0rWqQEflAZyNq+sGP4pqcSnB4VGfPGTe4l05rHAXkGg+s80bYxMc34LiFvdpF4bGfaJefNCHmm8+SkviaCMpRK+Janv7gUqf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fFaniP5O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fFaniP5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BBE1F000E9;
	Mon, 31 Aug 2026 13:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184377;
	bh=DtZxmLvCsMtoIG8f2Rt3cQyCzEDVhJyq6BhHLkq4LkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fFaniP5ORkDm3qpNhb/I3fYfQWNehDvhlZczoYbg2YWgK0h+SvMVooeW8MF4uQlLu
	 FC4FqdAUFtGhJTLcTcuUNPUmleGuVEnsKIfEMqcTFKVX7dK6YFH6uzjj9J8k3S/QPE
	 CXjcq8yrfB9FiRgMrEYaLW2GzmD0slnVVGa1l2vKUGQTNISScLWkPUU5vApamkbs4D
	 2HTRvo9oddZg8dTEGtUFxEh3K6etm/Bq5WffTkT1rKJUJfczP7fe63V0TYIXH9tbBU
	 ToMowI2RR3edqneK0znhcDgomwIbhyQnoRIPYbIHg3seAieW9LGTYAIoNTMgAdG0ce
	 aSwQTNeBvhe5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	lpieralisi@kernel.org,
	kwilczynski@kernel.org,
	rjui@broadcom.com,
	sbranden@broadcom.com,
	linux-pci@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] PCI: iproc: Protect root bus removal with rescan lock
Date: Mon, 31 Aug 2026 09:31:25 -0400
Message-ID: <20260831133314.4125787-657-sashal@kernel.org>
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

[ Upstream commit a6a64e150f12ad5391e0a0d60f6a3d119b06ce50 ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-6-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[PCI: iproc]` `[Protect]` — Add missing
`pci_rescan_remove_lock` protection around root bus teardown in
`iproc_pcie_remove()`.

### Step 1.2: Commit Message Tags
**Record:**
- **Link:**
  `https://patch.msgid.link/20260521161822.132996-6-18255117159@163.com`
- **Signed-off-by:** Hans Zhang, Manivannan Sadhasivam, Bjorn Helgaas
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or `Reviewed-by:` tags
- Notable: absence of `Fixes:`/`Cc: stable` is expected for manual
  review; not a negative signal

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** `iproc_pcie_remove()` calls `pci_stop_root_bus()` /
  `pci_remove_root_bus()` without holding the global PCI rescan/remove
  mutex
- **Symptom:** Race with concurrent sysfs-triggered PCI rescan or
  hotplug → use-after-free or system crash
- **Root cause:** Driver teardown and sysfs rescan/remove paths can run
  concurrently on the same bus hierarchy without synchronization
- **Version info:** None in commit message

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — explicitly a synchronization bug fix.
Matches a well-established PCI core pattern (`pci_lock_rescan_remove()`
/ `pci_unlock_rescan_remove()`).

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **File:** `drivers/pci/controller/pcie-iproc.c` (+2 lines)
- **Function:** `iproc_pcie_remove()`
- **Scope:** Single-file, surgical fix (2 insertions)

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `pci_stop_root_bus()` → `pci_remove_root_bus()` with no
  lock
- **After:** `pci_lock_rescan_remove()` → stop/remove →
  `pci_unlock_rescan_remove()`
- **Path:** Driver remove (platform unbind, BCMA remove, module unload)

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Race condition / potential UAF
- **Mechanism:** `pci-sysfs.c` rescan/remove handlers (`rescan_store`,
  `dev_rescan_store`, `remove_store`, `bus_rescan_store`) hold
  `pci_rescan_remove_lock`. `iproc_pcie_remove()` did not. Concurrent
  sysfs operations and driver removal can corrupt or free PCI bus/device
  structures still in use.

### Step 2.4: Fix Quality
**Record:**
- Obviously correct — identical to `pci_host_common_remove()`, `pci-
  aardvark`, `pci-mvebu`, `pcie-mediatek-gen3`, `pci-hyperv`, and others
- Minimal, no API changes
- **Regression risk:** Very low; only serializes an already-required
  critical section

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- `iproc_pcie_remove()` dates to Ray Jui (2015); `pci_stop_root_bus()` /
  `pci_remove_root_bus()` added in `81ce3cf4a246d` (2020, "PCI: iproc:
  Use pci_host_probe()")
- Unprotected removal pattern present since 2020 in this tree

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag

### Step 3.3: Related File History
**Record:**
- Part of 9-patch series "[PATCH 0/9] PCI: controller: Add missing
  rescan lock around root bus removal"
- Cover letter states each patch is independent
- Same missing-lock pattern exists in several sibling drivers (cadence,
  dwc, altera, brcmstb, mediatek, rockchip, vmd, plda) — not yet fixed
  in this 6.18.44 tree

### Step 3.4: Author Context
**Record:** Hans Zhang is an active PCI contributor (cadence/dwc
capability search, etc.). Patch signed by PCI maintainer Bjorn Helgaas.

### Step 3.5: Dependencies
**Record:** None. `pci_lock_rescan_remove()` /
`pci_unlock_rescan_remove()` exist in this tree since commit
`9d16947b75831` (2014). `pcie-iproc.c` already includes `<linux/pci.h>`.
Standalone backport.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- Commit not in local tree; `b4 dig -c` could not match it
- Local mbox/cover files available in workspace
- Cover letter lore reference: `https://lore.kernel.org/linux-
  pci/20260519132017.63E1BC2BCB3@smtp.kernel.org/` (sashiko-bot review
  flagging the missing-lock pattern)
- Series: v1, 9 independent patches, May 22 2026
- **UNVERIFIED:** Full lore thread replies (Anubis blocked WebFetch on
  lore.kernel.org)

### Step 4.2: Reviewers
**Record:** Cover letter references automated sashiko-bot review
identifying the race. Bjorn Helgaas committed. **UNVERIFIED:** Full
recipient list via `b4 dig -w` (commit not in tree).

### Step 4.3: Bug Reports
**Record:** No syzbot or user bug reports. Issue identified via code
review / pattern analysis (same class of bug Rafael Wysocki documented
in `9d16947b75831`).

### Step 4.4: Related Patches
**Record:** 8 sibling patches in the same series for other host
controllers; each independent.

### Step 4.5: Stable List History
**Record:** **UNVERIFIED** — could not search lore stable list
(blocked). No stable nomination found in local cover letter.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `iproc_pcie_remove()` (modified)

### Step 5.2: Callers
**Record:**
- `iproc_pltfm_pcie_remove()` in `pcie-iproc-platform.c` (platform
  driver `.remove`)
- `iproc_bcma_pcie_remove()` in `pcie-iproc-bcma.c` (BCMA driver
  `.remove`)
- Triggered on device unbind, module unload, shutdown

### Step 5.3: Callees
**Record:** `pci_lock_rescan_remove()`, `pci_stop_root_bus()`,
`pci_remove_root_bus()`, `pci_unlock_rescan_remove()`, then MSI/PHY
cleanup

### Step 5.4: Reachability
**Record:**
- Driver remove is reachable on Broadcom iProc platforms
  (`CONFIG_PCIE_IPROC_PLATFORM`, `CONFIG_PCIE_IPROC_BCMA`)
- Concurrent sysfs PCI rescan/remove requires appropriate privileges
  (typically root), but is realistic during admin operations, hotplug
  testing, or scripted teardown
- Race window is real when both paths run concurrently

### Step 5.5: Similar Patterns
**Record:** Multiple controllers already use this lock pattern. `pcie-
iproc.c` is an outlier. `pci_stop_and_remove_bus_device()` asserts
`lockdep_assert_held(&pci_rescan_remove_lock)` — sysfs remove uses the
locked variant; host driver remove did not.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Buggy Code Exists?
**Record:** **YES.** At lines 1543–1544 of `drivers/pci/controller/pcie-
iproc.c`, `iproc_pcie_remove()` calls `pci_stop_root_bus()` /
`pci_remove_root_bus()` without the lock. Fix is **not** yet applied in
this tree (`git describe HEAD` → `v6.18.44-1-g2736c32da98b9`).

### Step 6.2: Backport Complications
**Record:** Clean apply expected — 2-line addition, no structural
conflicts. `pci_lock_rescan_remove` API unchanged.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent fix for iproc in this tree. `pci-host-
common.c`, `pci-aardvark.c`, `pci-mvebu.c`, `pcie-mediatek-gen3.c`
already hold the lock.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem and Criticality
**Record:** `drivers/pci/controller/` — **IMPORTANT** (PCI host
controller; affects platform-specific hardware but uses core PCI
infrastructure shared with sysfs paths)

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; recent iproc commit `f37f2f804796e` in
this tree.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of Broadcom iProc PCIe (`ARCH_BCM_IPROC`, BCM5301X
BCMA). Not universal, but real production embedded/SoC deployments.

### Step 8.2: Trigger Conditions
**Record:** Driver remove/unbind concurrent with sysfs PCI rescan or
device removal. Uncommon but plausible under admin maintenance, module
reload, or testing. Requires privileges for sysfs side.

### Step 8.3: Failure Mode Severity
**Record:** Use-after-free / kernel crash — **HIGH** (potential
**CRITICAL** if exploited, though sysfs access limits practical
exploitability)

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Prevents real race/UAF during teardown on affected
  hardware
- **Risk:** Minimal — 2 lines matching established PCI convention
- **Ratio:** Strongly favorable

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes a real synchronization bug (race with sysfs PCI operations)
- Failure mode is UAF/system crash
- Fix is 2 lines, obviously correct, matches multiple existing drivers
  in this tree
- Bug has existed since 2020 when iproc adopted `pci_remove_root_bus()`
- No dependencies; API present since 2014
- Buggy code confirmed present in 6.18.44
- PCI maintainer committed the patch

**AGAINST backport:**
- No syzbot/user crash report (theoretical/code-review finding)
- Affects specific hardware platform only
- Part of a 9-patch series (but explicitly independent)

**Unresolved:**
- Full lore review thread and stable-list discussion (WebFetch blocked)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — matches established pattern;
   no functional change beyond serialization
2. Fixes a real bug? **PASS** — documented race with sysfs PCI paths
3. Important issue? **PASS** — UAF/crash severity HIGH
4. Small and contained? **PASS** — 2 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code present, clean apply
   expected

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision Rationale

For Linux **6.18.44**, `iproc_pcie_remove()` lacks the PCI rescan/remove
lock that sysfs PCI operations already use. This is a long-standing
oversight relative to the locking contract introduced in 2014 and
followed by `pci-host-common` and several other host drivers in this
tree. The fix is minimal, self-contained, and prevents a realistic race
during driver teardown that can cause use-after-free or crashes. It
meets all stable kernel criteria.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message and local mbox
- **[Phase 2]** Confirmed diff: +2 lines in `iproc_pcie_remove()`
  wrapping stop/remove with lock
- **[Phase 3]** `git describe HEAD`: v6.18.44; `git blame`: unprotected
  pattern since `81ce3cf4a246d` (2020)
- **[Phase 3]** `git show 9d16947b75831`: `pci_lock_rescan_remove()`
  introduced 2014, present in tree
- **[Phase 3]** Read local cover letter: 9-patch independent series,
  sashiko-bot flagged race
- **[Phase 4]** `b4 dig -c HEAD`: no match (commit not in tree)
- **[Phase 4]** Read `20260522_...rescan_lock...cover` and `.mbx`:
  series context and bot review
- **[Phase 4]** WebFetch lore/patch.msgid.link: blocked by Anubis —
  **UNVERIFIED** thread replies
- **[Phase 5]** `grep iproc_pcie_remove`: callers in `pcie-iproc-
  platform.c`, `pcie-iproc-bcma.c`
- **[Phase 5]** Read `pci-sysfs.c`: rescan/remove paths hold
  `pci_lock_rescan_remove()`
- **[Phase 5]** Read `pci-host-common.c`, `pci-aardvark.c`, `pci-
  mvebu.c`: established lock pattern
- **[Phase 5]** Read `remove.c`: `pci_stop_and_remove_bus_device()`
  asserts lock held
- **[Phase 6]** Read `pcie-iproc.c` lines 1539–1549: buggy code
  confirmed, fix absent
- **[Phase 6]** `grep CONFIG_PCIE_IPROC` in Kconfig: Broadcom iProc
  platforms
- **[Phase 8]** Assessed severity: UAF/crash, HIGH

**YES**

 drivers/pci/controller/pcie-iproc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-iproc.c b/drivers/pci/controller/pcie-iproc.c
index 5aa677f81e4fa..61dcb232757fb 100644
--- a/drivers/pci/controller/pcie-iproc.c
+++ b/drivers/pci/controller/pcie-iproc.c
@@ -1540,8 +1540,10 @@ void iproc_pcie_remove(struct iproc_pcie *pcie)
 {
 	struct pci_host_bridge *host = pci_host_bridge_from_priv(pcie);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(host->bus);
 	pci_remove_root_bus(host->bus);
+	pci_unlock_rescan_remove();
 
 	iproc_pcie_msi_disable(pcie);
 
-- 
2.53.0

