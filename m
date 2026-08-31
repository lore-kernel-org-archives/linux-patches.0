Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B2D4A5C5F;
	Mon, 31 Aug 2026 13:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183859; cv=none; b=cfnZjeeesZg+QIHyFlA4V5hJP8mIOe8lcKUg34xUhgBpXYavOZ1Q4niQ7fCxFWdxW7+yb6iZ4CDc2mX+xWA65iM6ic1sEsaEPg3jfsqPJniMLVcBvlG9WxfHUmD239wMn2bVzMFXqwJRwuHG3dh5gtHbSyOaCeX81Sy8kgZjH+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183859; c=relaxed/simple;
	bh=8FmISrlh/su4jWuTTc0XSk7tXY4MHiWpMVb6lhJmZr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BRZbxApDoM9lXIcK33VP/yybsZmu5GXI5n9fGKjgFVgLhEXo0oNsVJunfRRN7zGe7CwA8PUpNcj9TvcCAuWatDfsUK60n7aD7sMhHdw4pzoCpyxTcadBtbykKtk9RvxBPw9xY5S6BH59AQ1L0etYjRdaiWAFQQfE4vtnqqChuJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FZQqzFgS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FZQqzFgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAEE1F00A3E;
	Mon, 31 Aug 2026 13:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183856;
	bh=4zVyAFCFwj3WRkFHuK3EUyLXOd84tkxVs8ZJC9Wl0Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FZQqzFgS1js/2wi4rMpEYDZrARdC51m3uSqrJZEdymztoHS+rZur29e+hGVZomwyv
	 ij9XRoPwNlwX8X43L4r5UtWkQwS8/7SbtV/PJIlwIumuvmpz1lsEWLHV1WY0LHDLmm
	 xmYgdX2dM+bon+g5OO97wFuwRRABZs1TcRHd2W5BC5De+oe+mYG2QdaaKz0Nkvbo4y
	 8KVYlCUYzH6WDBaw58SIUj4YK7QTaw6uB0kPHapsnwi65BR39Wd1Yp85iPUeKUe/Cb
	 qb2J5HFsQ8OulyXDhKqhQ2M7O5Q7qylx5Gb9vAFeq9hlKprD/xXuUe1KRBXZCWPBne
	 RPrKBEJLYQJeA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	ryder.lee@mediatek.com,
	lpieralisi@kernel.org,
	kwilczynski@kernel.org,
	linux-pci@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] PCI: mediatek: Protect root bus removal with rescan lock
Date: Mon, 31 Aug 2026 09:26:13 -0400
Message-ID: <20260831133314.4125787-345-sashal@kernel.org>
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

[ Upstream commit a29812a55da8d0dbeb071b26ac428c338e3fc389 ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-7-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
- Record: `[PCI/mediatek]` `[Protect]` — Add missing
  `pci_rescan_remove_lock` around root bus teardown in
  `mtk_pcie_remove()`.

**Step 1.2 — Tags**
- Record:
  - `Signed-off-by`: Hans Zhang, Manivannan Sadhasivam, Bjorn Helgaas
  - `Link`:
    https://patch.msgid.link/20260521161822.132996-7-18255117159@163.com
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
    stable@vger.kernel.org`
  - Notable: PCI subsystem maintainer (Bjorn Helgaas) committed it; part
    of a 9-patch series (patch 6/9)

**Step 1.3 — Body analysis**
- Record:
  - **Bug**: `mtk_pcie_remove()` calls `pci_stop_root_bus()` /
    `pci_remove_root_bus()` without `pci_rescan_remove_lock`, racing
    sysfs-triggered rescan/hotplug.
  - **Symptom**: Use-after-free or system crash.
  - **Root cause**: Missing synchronization with global PCI
    rescan/remove lock used by `pci-sysfs.c`.

**Step 1.4 — Hidden bug fix?**
- Record: No — explicitly described as a synchronization fix for a
  race/UAF.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
- Record: 1 file (`drivers/pci/controller/pcie-mediatek.c`), +2 lines,
  function `mtk_pcie_remove()`. Single-file surgical fix.

**Step 2.2 — Code flow**
- Record:
  - **Before**: `pci_stop_root_bus()` → `pci_remove_root_bus()`
    unlocked.
  - **After**: `pci_lock_rescan_remove()` → stop/remove →
    `pci_unlock_rescan_remove()`.
  - Affects driver remove/unbind path only.

**Step 2.3 — Bug mechanism**
- Record: **Race condition / UAF**. Sysfs rescan/remove holds
  `pci_rescan_remove_lock`; driver remove did not. Concurrent teardown +
  rescan can walk freed PCI structures.

**Step 2.4 — Fix quality**
- Record: Obviously correct — matches `pci_host_common_remove()`, `pcie-
  mediatek-gen3` `mtk_pcie_remove()`, `pci-aardvark`, `pci-mvebu`.
  Minimal regression risk; standard mutex, no API change.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
- Record: `mtk_pcie_remove()` and unprotected
  `pci_stop/remove_root_bus()` from Honghui Zhang, Oct 2018
  (`031337ace2d1c2`). Bug present since driver introduction.

**Step 3.2 — Fixes: tag**
- Record: N/A — no `Fixes:` tag. Underlying gap: drivers added
  before/without adopting the lock pattern from commit `9d16947b75831`
  (Jan 2014).

**Step 3.3 — Related history**
- Record: Series merged on mainline as `7c97ee7c4951a` (9 driver fixes).
  Commit `a29812a55da8d` is the mediatek piece. Cover letter states each
  patch is independent. Similar unprotected callers remain in this tree
  (altera, rockchip, tegra, iproc, brcmstb, dwc, cadence, plda) —
  separate commits.

**Step 3.4 — Author context**
- Record: Hans Zhang; series reviewed/committed by Bjorn Helgaas;
  Manivannan Sadhasivam Signed-off-by on mediatek patch.

**Step 3.5 — Dependencies**
- Record: None. Requires only `pci_lock_rescan_remove()` /
  `pci_unlock_rescan_remove()` — present in this tree since
  `9d16947b75831`. `git apply --check` passes cleanly.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Discussion**
- Record: `b4 dig -c a29812a55da8d` →
  https://patch.msgid.link/20260521161822.132996-7-18255117159@163.com.
  v1 series, 9 patches. Bjorn Helgaas applied 8 patches and standardized
  commit logs. No NAKs.

**Step 4.2 — Reviewers**
- Record: `b4 dig -w` — CC'd Bjorn Helgaas, Lorenzo Pieralisi, Konrad
  Wilczynski, Manivannan Sadhasivam, Rob Herring, linux-pci@.

**Step 4.3 — Bug reports**
- Record: No user/syzbot report. sashiko-bot flagged the unprotected
  pattern as a race risk on the mediatek patch; separate pre-existing
  clock/PM issue noted (unrelated to this fix).

**Step 4.4 — Series context**
- Record: Patch 6/9; cover letter: "Each patch is independent and
  targets a specific controller driver."

**Step 4.5 — Stable list**
- Record: No `Cc: stable` in thread (expected; not a negative signal).

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Functions modified**
- Record: `mtk_pcie_remove()`.

**Step 5.2 — Callers**
- Record: Registered as `platform_driver.remove` for `mtk-pcie`; reached
  on device unbind, module unload, shutdown. `suppress_bind_attrs =
  true` limits sysfs bind/unbind, but module unload and platform device
  removal still invoke remove.

**Step 5.3 — Callees**
- Record: `pci_lock_rescan_remove()`, `pci_stop_root_bus()`,
  `pci_remove_root_bus()`, `pci_unlock_rescan_remove()`, then resource
  teardown.

**Step 5.4 — Reachability**
- Record: Race requires concurrent sysfs PCI rescan/remove (e.g.
  `/sys/bus/pci/rescan`, `.../rescan`, `.../remove`) while driver remove
  runs. Sysfs writes need elevated privileges; realistic under admin
  orchestration, firmware updates, or scripted hotplug.

**Step 5.5 — Similar patterns**
- Record: In this tree, `pcie-mediatek-gen3.c`, `pci-host-common.c`,
  `pci-aardvark.c`, `pci-mvebu.c`, `pci-hyperv.c` already use the lock.
  `pcie-mediatek.c` is the outlier among MediaTek drivers.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

**Step 6.1 — Buggy code present?**
- Record: **Yes.** Tree is `v6.18.44` (`make kernelversion` = 6.18.44).
  `mtk_pcie_remove()` at lines 1157–1158 calls stop/remove without lock.
  Commit `a29812a55da8d` is **not** in HEAD (`merge-base --is-ancestor`
  exit 1).

**Step 6.2 — Backport complications**
- Record: Clean apply verified (`git apply --check` success). No
  structural conflicts.

**Step 6.3 — Related fixes already present?**
- Record: `git log HEAD --grep="Protect root bus removal"` — empty. Fix
  not yet in 6.18.y. Gen3 driver already has the lock from initial
  import.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem**
- Record: `drivers/pci/controller` — PCI host controller. **IMPORTANT**
  (core I/O path for affected SoCs).

**Step 7.2 — Activity**
- Record: Active maintenance (MSI, IRQ domain, refcount fixes in
  2024–2026).

---

## Phase 8: Impact and Risk

**Step 8.1 — Who is affected**
- Record: `CONFIG_PCIE_MEDIATEK` on ARCH_MEDIATEK / ARCH_AIROHA —
  MT2701, MT7623, MT2712, MT7622, MT7629 (routers, embedded boards).

**Step 8.2 — Trigger**
- Record: Concurrent sysfs PCI rescan/remove during driver remove.
  Uncommon but plausible; requires privileged sysfs access.

**Step 8.3 — Failure severity**
- Record: UAF / kernel crash — **HIGH** (potential **CRITICAL** security
  impact if exploitable timing exists).

**Step 8.4 — Risk/benefit**
- Record: **Benefit HIGH** (prevents crash/UAF on real hardware). **Risk
  VERY LOW** (2-line, established pattern). Strong benefit/risk ratio.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence**

*For:*
- Real race with documented UAF/crash consequences
- PCI maintainer-reviewed fix
- Minimal, obviously correct, applies cleanly
- Infrastructure (`pci_lock_rescan_remove`) present since 2014 in this
  tree
- Bug in tree since 2018; gen3 sibling driver already uses the pattern
- Standalone — no series dependencies

*Against:*
- No syzbot/user crash report (theoretical until triggered)
- Privileged trigger for sysfs side of race
- Other PCI controllers in this tree have the same gap (scope beyond
  this commit, not a reason to reject this one)

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — pattern used elsewhere;
   maintainer committed
2. Fixes real bug? **PASS** — verified race with sysfs lock mismatch
3. Important issue? **PASS** — UAF/crash
4. Small and contained? **PASS** — 2 lines, 1 file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply verified

**Step 9.3 — Exception category**
- Record: N/A (standard bug fix, not quirk/DT/build/doc exception)

**Step 9.4 — Decision rationale**
This commit closes a long-standing synchronization gap in the MediaTek
PCIe host driver on the v6.18.44 stable tree. The missing lock allows
root bus teardown to race sysfs rescan/remove operations that correctly
hold `pci_rescan_remove_lock`, with UAF/crash as the stated and credible
outcome. The fix is minimal, matches existing in-tree patterns
(including `pcie-mediatek-gen3.c`), has no dependencies, and applies
cleanly.

---

## Verification

- [Phase 1] Parsed subject, tags, body from commit `a29812a55da8d`
- [Phase 2] Diff: +2 lines wrapping stop/remove in `mtk_pcie_remove()`
- [Phase 3] `git blame`: buggy remove path from 2018 (`031337ace2d1c2`)
- [Phase 3] `git show 9d16947b75831`: `pci_lock_rescan_remove()` added
  2014; in this tree
- [Phase 3] `git merge-base --is-ancestor a29812a55da8d HEAD` → exit 1
  (not in tree)
- [Phase 3] `git apply --check` on commit diff → success
- [Phase 4] `b4 dig -c a29812a55da8d` → lore URL found
- [Phase 4] `b4 dig -a` → v1, patch 6/9
- [Phase 4] `b4 dig -w` → PCI maintainers CC'd
- [Phase 4] Mbox: Bjorn Helgaas review, no NAKs, no stable nomination
- [Phase 5] Read `pci-sysfs.c`: rescan/remove paths use
  `pci_lock_rescan_remove()`
- [Phase 5] Read `remove.c`: `pci_stop_and_remove_bus_device()` asserts
  lock held
- [Phase 5] Grep: gen3/aardvark/mvebu/host-common have lock; mediatek.c
  does not
- [Phase 6] `git describe HEAD` → v6.18.44; Makefile → 6.18.44
- [Phase 6] Read `pcie-mediatek.c` lines 1152–1164: unprotected
  stop/remove confirmed
- [Phase 8] Kconfig: `PCIE_MEDIATEK` on ARCH_MEDIATEK/AIROHA

**YES**The background searches finished and match the earlier analysis:

- **`pci_lock_rescan_remove()`** is already in this **v6.18.44** tree
  (from `9d16947b75831`, 2014), along with related ACPI/hotplug locking
  commits.
- A grep for **"Protect root bus removal"** on HEAD returned nothing —
  that fix series is not in this stable tree yet.
- The **MediaTek** patch still applies cleanly and remains a **YES** for
  backport: it adds the missing lock around `mtk_pcie_remove()` to
  prevent a race with sysfs PCI rescan/remove that can cause
  UAF/crashes.

 drivers/pci/controller/pcie-mediatek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-mediatek.c b/drivers/pci/controller/pcie-mediatek.c
index 6afce031523bd..ce2a3e04a953e 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -1154,8 +1154,10 @@ static void mtk_pcie_remove(struct platform_device *pdev)
 	struct mtk_pcie *pcie = platform_get_drvdata(pdev);
 	struct pci_host_bridge *host = pci_host_bridge_from_priv(pcie);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(host->bus);
 	pci_remove_root_bus(host->bus);
+	pci_unlock_rescan_remove();
 	mtk_pcie_free_resources(pcie);
 
 	mtk_pcie_irq_teardown(pcie);
-- 
2.53.0

