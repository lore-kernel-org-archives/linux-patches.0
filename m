Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD50F459AFC;
	Mon, 31 Aug 2026 13:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183290; cv=none; b=HVN6gu7OiM2bk68AgdRdOlDfTkuRjQ/A7IVd2+LxqMk8JUCe422rCLK+5pIQlNAUffovrqYV0CC2SuBWaRmRsVRE3qC3EB8Eojn3J90vmrHIuGh7XNDR2nRBo/FQsXzjXSeF1AXfPokkaQreWJbP/FmMfpqtPDypfC6dWdNyIwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183290; c=relaxed/simple;
	bh=TWTekj89miw1K0rfAJArYJpEzMAq2gQ/4T0vpcyUAl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xd1JlVYtZ0F978t2LsZ7vw7us8o/ZdjmMEyw0w5cpAuUsDwdZfo2rP2QNdqXJWfUBDxER8p6QcVgO9QF1TrM6T9KkUuxR0gRT2KBfSCXFL+oPJwN1da4x075wdMFSLUrC7Fa3siH5iPojFfd8GsPO1KqChSQhrRX9g8a3bUvqq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vhurul7X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vhurul7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525D81F00ACF;
	Mon, 31 Aug 2026 13:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183287;
	bh=8H4D6esrqEhZzO5igNe5K5dyRdu+n361wC3B0JmmHn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vhurul7XerXXIZZ5kv9LEJf5Eugy34fLK5wWdImNHhUV74IAOzJlL8Z1b88R6LmRU
	 NF1YNykG8Dn5ttwig0jWaGC6W2I/x0hz+isgARZlzXD8MXX64zcK12mwPPgTl/5EyF
	 vq3CP1vdX5wxlwKg3N6YyE+8IRFDBqHH4WBUiHRy96mmFLVqcDa94QRCtntGKFRzLS
	 xoOyZwAIIn2+D/Kqgns88AakhY+EJwjyFqekI8Z0KQqGZvMO3ZYAvlnD7OYbHvi2Wx
	 6Ybu4SiT2CNnI0XJb7LQRCnRbGuW7a5ikCMRxIjLQengjTLOlwoxgwMA0ApcDoOinN
	 kNpLzkkqUjUIA==
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
Subject: [PATCH AUTOSEL 6.18-5.10] PCI: altera: Protect root bus removal with rescan lock
Date: Mon, 31 Aug 2026 09:21:26 -0400
Message-ID: <20260831133314.4125787-58-sashal@kernel.org>
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

[ Upstream commit a8759c8ac48c0419f5899e95a6ffc611b07c965b ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-4-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: PCI: altera: Protect root bus removal with
rescan lock

**Local tree:** `v6.18.44-1-g2736c32da98b9` (kernel 6.18.44)
**Fix commit on mainline:** `a8759c8ac48c0` — **not present in this
tree**
**Buggy code:** present since `ec15c4d0d5d2e` (2019, "PCI: altera: Allow
building as module")

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[PCI: altera]` `[Protect]` — Protect root bus removal with
rescan lock during driver teardown.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Hans Zhang `<18255117159@163.com>` (author)
- **Signed-off-by:** Manivannan Sadhasivam `<mani@kernel.org>` (PCI
  maintainer reviewer)
- **Signed-off-by:** Bjorn Helgaas `<bhelgaas@google.com>` (PCI
  maintainer, committer)
- **Link:**
  `https://patch.msgid.link/20260521161822.132996-4-18255117159@163.com`
- No Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org
- Notable: maintainer sign-offs from PCI subsystem; no syzbot or user
  crash report

### Step 1.3: Body analysis
**Record:**
- **Bug:** `altera_pcie_remove()` calls `pci_stop_root_bus()` /
  `pci_remove_root_bus()` without holding `pci_rescan_remove_lock`.
- **Symptom:** Race with concurrent sysfs-triggered PCI rescan or
  hotplug → use-after-free or system crash.
- **Root cause:** Root bus teardown and sysfs rescan/remove paths can
  run concurrently on the same bus topology.
- **Version info:** None explicit; bug dates to 2019 module-support
  commit in this tree.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit synchronization bug fix, not
disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/pci/controller/pcie-altera.c` (+2 lines)
- **Function:** `altera_pcie_remove()`
- **Scope:** Single-file, surgical fix (2 insertions)

### Step 2.2: Code flow change
**Record:**
- **Before:** `pci_stop_root_bus()` → `pci_remove_root_bus()` →
  `altera_pcie_irq_teardown()` with no lock.
- **After:** Same sequence wrapped in `pci_lock_rescan_remove()` /
  `pci_unlock_rescan_remove()`.
- **Path affected:** Platform driver `.remove` callback (module unload /
  device unbind).

### Step 2.3: Bug mechanism
**Record:** **Category: synchronization / race condition.**
- Sysfs rescan (`rescan_store`, `dev_rescan_store` in `pci-sysfs.c`)
  holds `pci_rescan_remove_lock`.
- `altera_pcie_remove()` did not, so teardown and rescan could
  interleave on the same bus.
- `pci_stop_and_remove_bus_device()` uses
  `lockdep_assert_held(&pci_rescan_remove_lock)` — the PCI core expects
  this lock for bus mutation; root-bus removal should follow the same
  rule.

### Step 2.4: Fix quality
**Record:**
- **Quality:** High — matches `pci-aardvark.c`, `pci-mvebu.c`, `pci-
  host-common.c`, `pci-hyperv.c`, `pcie-mediatek-gen3.c`.
- **Regression risk:** Very low — standard mutex, no API change, IRQ
  teardown stays outside the lock (same as other drivers).
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Buggy `pci_stop_root_bus`/`pci_remove_root_bus` calls introduced in
  `ec15c4d0d5d2e` (Ley Foon Tan, 2019-04-24).
- Function signature updated in `3a610560aa4fc` (2023) — void remove
  callback; lock omission unchanged.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:**
- Part of 9-patch series `[PATCH 0/9] PCI: controller: Add missing
  rescan lock around root bus removal` (Hans Zhang, May 2026).
- Cover letter: **"Each patch is independent."**
- Merged to mainline as `a8759c8ac48c0` via `7c97ee7c4951a` (Merge
  branch 'pci/controller/rescan_lock').
- Related precedent: `1d59d474e1cb7` "PCI: Hold rescan lock while adding
  devices during host probe" — **present in this tree**; documents a
  real NULL-deref crash from missing rescan lock.

### Step 3.4: Author context
**Record:** Hans Zhang — active PCI contributor (cadence, dwc capability
search, etc.). Patch reviewed/signed by PCI maintainers.

### Step 3.5: Dependencies
**Record:** None.
- `pci_lock_rescan_remove()` exists since `9d16947b75831` (2014) — **in
  this tree**.
- `<linux/pci.h>` already included in `pcie-altera.c`.
- Standalone; applies cleanly to current `pcie-altera.c`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c` failed (commit not in HEAD).
- Local mbox/cover: `20260522_18255117159_pci_controller_add_missing_res
  can_lock_around_root_bus_removal.{cover,mbx}`.
- Cover letter explains race with sysfs rescan/hotplug → UAF/crash.
- Triggered by sashiko-bot review of a related cadence patch asking
  whether root bus teardown needs the lock.
- Lore fetch blocked (Anubis bot protection) — discussion content taken
  from local mbox.

### Step 4.2: Reviewers
**Record:** Signed-off-by Manivannan Sadhasivam and Bjorn Helgaas.
Series sent to linux-pci.

### Step 4.3: Bug report
**Record:** No syzbot, bugzilla, or user crash report for Altera
specifically. Cover letter and `1d59d474e1cb7` provide class-of-bug
evidence in PCI core.

### Step 4.4: Series context
**Record:** Patch 3/9; independent per cover letter. Other drivers in
series (cadence, dwc, brcmstb, etc.) have the same bug pattern.

### Step 4.5: Stable list
**Record:** Not searched (lore blocked). No stable nomination found in
local mbox.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `altera_pcie_remove()` only.

### Step 5.2: Callers
**Record:** Called from platform driver framework on:
- `rmmod` (driver is tristate module since 2019)
- platform device unbind
- Module unload is an explicit design goal for post-boot FPGA
  programming.

### Step 5.3: Callees
**Record:** `pci_lock_rescan_remove()`, `pci_stop_root_bus()`,
`pci_remove_root_bus()`, `pci_unlock_rescan_remove()`,
`altera_pcie_irq_teardown()`.

### Step 5.4: Reachability
**Record:**
- Unprivileged users can trigger sysfs PCI rescan
  (`/sys/bus/pci/rescan`, per-device `rescan`).
- Root can unload the module (`rmmod`).
- Concurrent rescan + unload is the race window — realistic on FPGA
  systems that reload bitstreams.
- **Userspace-reachable rescan path:** yes (with appropriate
  privileges).

### Step 5.5: Similar patterns
**Record:** Same missing-lock pattern in cadence, dwc, brcmstb, iproc,
mediatek, rockchip, plda, vmd (series). Already-fixed examples:
aardvark, mvebu, host-common, hyperv, mediatek-gen3.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current HEAD at lines 1078–1079:

```1073:1081:drivers/pci/controller/pcie-altera.c
static void altera_pcie_remove(struct platform_device *pdev)
{
        struct altera_pcie *pcie = platform_get_drvdata(pdev);
        struct pci_host_bridge *bridge =
pci_host_bridge_from_priv(pcie);

        pci_stop_root_bus(bridge->bus);
        pci_remove_root_bus(bridge->bus);
        altera_pcie_irq_teardown(pcie);
}
```

No `pci_lock_rescan_remove()`. Bug present since v4.19-era module
support.

### Step 6.2: Backport complications
**Record:** **Clean apply** — 2-line addition, no conflicts expected.
`git show a8759c8ac48c0` matches current file context.

### Step 6.3: Related fixes already present?
**Record:** `1d59d474e1cb7` (probe-side rescan lock) is in tree. Altera-
specific remove-path fix (`a8759c8ac48c0`) is **not** in tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **PERIPHERAL** — `CONFIG_PCIE_ALTERA` host controller for
Altera/Intel FPGA (ARM, ARM64, NIOS2). Not universal, but crash/UAF
severity is high when triggered.

### Step 7.2: Activity
**Record:** Moderately active — recent probe leak fix (`09c43b7b7d29c`),
Agilex support, IRQ domain updates.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users with `CONFIG_PCIE_ALTERA` on Altera/Intel FPGA PCIe
platforms who unload/reload the driver while PCI sysfs rescan or hotplug
runs.

### Step 8.2: Trigger conditions
**Record:**
- Concurrent `altera_pcie_remove()` and sysfs `rescan` or `remove` on
  the same bus.
- More likely than average because the driver is a module for post-boot
  FPGA loading.
- Requires root for module unload; rescan also typically root.
- **Likelihood:** uncommon but realistic on target hardware.

### Step 8.3: Failure mode severity
**Record:** **HIGH** — UAF and kernel crash (per commit message and PCI
subsystem precedent in `1d59d474e1cb7`).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents crash/UAF on supported FPGA platforms during
  driver teardown.
- **Risk:** Very low — 2 lines, established pattern, no behavior change
  beyond serialization.
- **Ratio:** Favorable for backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR:**
- Real synchronization bug with documented PCI class-of-crash precedent
- UAF/crash failure mode
- Minimal, obviously correct fix matching multiple peer drivers
- Bug present in this tree since 2019
- No dependencies; clean apply
- Maintainer-reviewed (Helgaas, Sadhasivam)
- Driver explicitly supports module unload scenarios

**AGAINST:**
- No Altera-specific crash report or syzbot hit
- Niche driver (`CONFIG_PCIE_ALTERA`)
- Race needs concurrent unload + rescan

**UNRESOLVED:**
- Lore thread not readable (bot protection); relied on local mbox
- No independent runtime test evidence for Altera specifically

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — matches established PCI
pattern; maintainer-reviewed |
| 2. Fixes real bug affecting users? | **PASS** — race on module unload
vs sysfs rescan |
| 3. Important issue? | **PASS** — UAF/crash (HIGH severity) |
| 4. Small and contained? | **PASS** — 2 lines, one function |
| 5. No new features/APIs? | **PASS** — synchronization only |
| 6. Can apply to local tree? | **PASS** — clean apply, APIs present |

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
race-condition fix.

### Step 9.4: Decision rationale
This is a missing-lock race in root bus teardown — the same class of bug
that caused a documented crash in `1d59d474e1cb7`, already in 6.18.y.
The Altera driver has lacked this protection since module support was
added in 2019. The fix is trivial, follows peer drivers, and prevents
UAF/crash on FPGA platforms where module reload is an intended use case.
Niche scope is offset by high severity and very low backport risk.

---

## Verification

- **[Phase 1]** `git show a8759c8ac48c0`: parsed subject, tags, body
- **[Phase 1]** Local mbox/cover: series context, bot review,
  independent patches
- **[Phase 2]** Diff: +2 lines in `altera_pcie_remove()`
- **[Phase 2]** `drivers/pci/remove.c:143`:
  `lockdep_assert_held(&pci_rescan_remove_lock)` on bus removal helpers
- **[Phase 2]** `drivers/pci/pci-sysfs.c:470,504,539`: sysfs rescan
  holds same lock
- **[Phase 3]** `git blame -L 1073,1081`: bug from `ec15c4d0d5d2e`
  (2019)
- **[Phase 3]** `git show 9d16947b75831`: lock API since 2014
- **[Phase 3]** `git show 1d59d474e1cb7`: related crash from missing
  lock; in tree
- **[Phase 3]** `git log master --grep="Protect root bus removal"`: fix
  `a8759c8ac48c0` on mainline
- **[Phase 3]** `git merge-base --is-ancestor a8759c8ac48c0 HEAD`: fix
  NOT in HEAD
- **[Phase 4]** `b4 dig`: failed; used local mbox instead
- **[Phase 4]** WebFetch lore: blocked by Anubis
- **[Phase 5]** `grep pci_lock_rescan_remove drivers/pci/controller/`:
  peer drivers use same pattern
- **[Phase 5]** `Kconfig`: `PCIE_ALTERA` tristate, ARM/ARM64/NIOS2
- **[Phase 6]** `git describe HEAD`: v6.18.44
- **[Phase 6]** Read `pcie-altera.c:1073-1081`: buggy code confirmed in
  HEAD
- **[Phase 6]** `git show master:.../pcie-altera.c`: fix confirmed on
  mainline
- **[Phase 8]** `ec15c4d0d5d2e` commit message: module support for post-
  boot FPGA load

**YES**The background checks finished and match what we already
concluded:

- **Altera history:** `pcie-altera.c` has never used
  `pci_lock_rescan_remove()`; the missing lock goes back to the 2019
  module-support commit. The lock API itself has been in the tree since
  2014.
- **Mainline status:** The fix landed on `master` via merge
  `7c97ee7c4951a` (`PCI: altera: Protect root bus removal with rescan
  lock`, `a8759c8ac48c0`). It is **not** in your current `v6.18.44`
  checkout.

**Verdict remains YES** for backporting to this 6.18.y tree — small,
obviously correct race fix with crash/UAF potential, and it should apply
cleanly.

 drivers/pci/controller/pcie-altera.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-altera.c b/drivers/pci/controller/pcie-altera.c
index 76f3823d96139..8ef56e2fabcfb 100644
--- a/drivers/pci/controller/pcie-altera.c
+++ b/drivers/pci/controller/pcie-altera.c
@@ -1075,8 +1075,10 @@ static void altera_pcie_remove(struct platform_device *pdev)
 	struct altera_pcie *pcie = platform_get_drvdata(pdev);
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(pcie);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(bridge->bus);
 	pci_remove_root_bus(bridge->bus);
+	pci_unlock_rescan_remove();
 	altera_pcie_irq_teardown(pcie);
 }
 
-- 
2.53.0

