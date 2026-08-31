Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84E7420469;
	Mon, 31 Aug 2026 13:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183203; cv=none; b=omSHlFeFajjGVnkPMZ5J2dVQP8JWNDu/RgVALaZJDorvOGvGmWI6RF+Q9tcM/FuY9fbFuzOGrBHAXbSG68mxQ+Y/CGRI8Tgg2qvy3hveOaLpP5+CKH6AyF5CvRRv3v4ZwwDrqSHoRmYaUZXMf3dX+eoVW0QTHNGezXLLu/L4Njw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183203; c=relaxed/simple;
	bh=74tR+vzgnULBR0ZG/+wMuuddELvqUNbck9Y2L51OrqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VEp1XqNHVlKckgSuD0fIUcyUCatg+V9bu7KQKuM/T7Hy3B9A90UXQUJoMMguq+PJNcOilukw2siODdX25WK1KfzTuCs1w9BBhNwFL6mDvg8ojj4VHAplSY4K7QhF8jBwNC6kdbZ6avvoj7RwGJDcNaK6/x96jA6RYd7lHHid8nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KSJ29o3h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KSJ29o3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DCB1F00A3F;
	Mon, 31 Aug 2026 13:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183200;
	bh=yjVcWilnbKfrt4r4Cp7FH7KSRSeVdy116MkJ3Ry0ex4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSJ29o3hrLrybTucbQu8eaX2d+w5Z4Bn57nDSp29bK3msbrjs0FECVkLtRq2tGSVk
	 RtSLUt4gxSAZVZZu/Eo/cbSdv3JgVxV7mUQ1GPKXfXjiln347VWeMB50pjyvKYmZQO
	 yOwj/JR943bXBeK8iA9rEK3EZbU4a6FRiF0DAvou7OF7g4Qqz6dnpRRwNOMPoG8itY
	 bbmILQICK8SE2BXao2CAxOUkwotmCLDGhry2pM9I0oat/M+NDdGDjqsTd9vy/gPf3k
	 /dMsDa2DHWKrPOBwGV6n5TEspg2ZwROvb3GN+4MN9G/f9KfztI69C9nTyzLnc9AVRz
	 77wNH4r4Uk9Kw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	daire.mcnamara@microchip.com,
	lpieralisi@kernel.org,
	kwilczynski@kernel.org,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] PCI: plda: Protect root bus removal with rescan lock
Date: Mon, 31 Aug 2026 09:20:32 -0400
Message-ID: <20260831133314.4125787-4-sashal@kernel.org>
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

[ Upstream commit 4e4f9745f016c1631d00a4035b06f6e75d449e01 ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-10-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: PCI: plda: Protect root bus removal with
rescan lock

**Local tree:** `v6.18.44-1-g2736c32da98b9` (Linux 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[PCI: plda]` `[Protect]` — Add `pci_rescan_remove_lock`
protection around root bus teardown in the PLDA PCIe host driver.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none in this commit (series cover references
  sashiko-bot review)
- **Acked-by:** — none
- **Link:** `https://patch.msgid.link/20260521161822.132996-10-
  18255117159@163.com`
- **Cc: stable:** — none
- **Signed-off-by:** Hans Zhang, Manivannan Sadhasivam, Bjorn Helgaas
  (ignore any pipeline-added SOBs)

Notable: No syzbot/user crash report; issue identified by code-review
pattern (series cover letter cites sashiko-bot).

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `plda_pcie_host_deinit()` calls `pci_stop_root_bus()` /
  `pci_remove_root_bus()` without holding `pci_rescan_remove_lock`.
- **Symptom:** Race with concurrent sysfs-triggered PCI rescan or
  hotplug/remove → use-after-free or system crash.
- **Root cause:** Missing lock acquisition that other PCI host drivers
  already use.
- **Version info:** None in commit message.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — this is an explicit synchronization/race
fix, not cleanup or optimization.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **File:** `drivers/pci/controller/plda/pcie-plda-host.c` (+2 lines)
- **Function:** `plda_pcie_host_deinit()`
- **Scope:** Single-file, surgical fix (2 insertions)

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Before:** Root bus stop/remove ran unlocked during driver teardown.
- **After:** `pci_lock_rescan_remove()` held for the entire
  `pci_stop_root_bus()` + `pci_remove_root_bus()` sequence, then
  unlocked.
- **Path affected:** Platform driver remove / module unload error path
  via `starfive_pcie_remove()` → `plda_pcie_host_deinit()`.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:** **Category:** Synchronization / race condition.

**Mechanism:** Sysfs rescan/remove paths (`rescan_store`,
`dev_rescan_store`, `bus_rescan_store`, `remove_store`) all take
`pci_lock_rescan_remove()` (verified in `drivers/pci/pci-sysfs.c`).
`pci_stop_root_bus()` / `pci_remove_root_bus()` tear down the same
bus/device lists without that lock in `plda_pcie_host_deinit()`,
creating a concurrent teardown vs. rescan/remove window.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- **Quality:** Obviously correct; matches `pci_host_common_remove()`,
  `mtk_pcie_remove()`, `pci_aardvark` remove, etc.
- **Risk:** Very low — standard mutex pair, no API change, no logic
  change beyond serialization.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:**
- Buggy `pci_stop_root_bus()` / `pci_remove_root_bus()` calls introduced
  in **76c9113968079** (`PCI: plda: Add host init/deinit and map bus
  functions`, May 28 2024).
- Present in this 6.18.44 tree without the lock.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag. N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:**
- Part of a 9-patch series (`[PATCH 0/9] PCI: controller: Add missing
  rescan lock around root bus removal`) fixing the same pattern in
  cadence, dwc, altera, brcmstb, iproc, mediatek, rockchip, vmd, and
  plda.
- Cover letter states: *"Each patch is independent and targets a
  specific controller driver."*
- Related precedent: **1d59d474e1cb7** (`PCI: Hold rescan lock while
  adding devices during host probe`) — real NULL deref crash from
  missing rescan lock during concurrent PCI operations.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Hans Zhang authored the full 9-driver series. PCI
maintainers (Bjorn Helgaas) committed related PCI work in this tree. No
Hans Zhang commits currently in this tree's plda path (series not yet
merged here).

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** **Standalone.** Only requires existing
`pci_lock_rescan_remove()` / `pci_unlock_rescan_remove()` (present since
**9d16947b75831**, Jan 2014). No structural prerequisites.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:**
- `b4 dig -c <sha>`: N/A — commit not in this tree.
- Local mbox `20260522_18255117159_pci_controller_add_missing_rescan_loc
  k_around_root_bus_removal.mbx` contains full series.
- Cover letter references sashiko-bot review asking whether unlocked
  root bus removal can race with sysfs rescan/hotplug.
- WebFetch of patch.msgid.link: blocked by anti-bot page (could not read
  live thread).

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** Cover letter CC'd linux-pci; bot review prompted the series.
Final commit SOBs include Manivannan Sadhasivam and Bjorn Helgaas. Full
maintainer thread not verified live.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No user crash report or syzbot link for plda specifically.
Issue identified by code-review pattern matching against known PCI
locking requirements.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** 9-patch series; each driver patch is independent per cover
letter. Other drivers in this tree (dwc, cadence, altera, etc.) have the
**same unfixed pattern** — this commit only addresses plda.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Not searched (no stable nomination found in local mbox).
Absence of `Cc: stable` is not a negative signal per review
instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `plda_pcie_host_deinit()` — only function modified.

### Step 5.2: TRACE CALLERS
**Record:**
- **Caller:** `starfive_pcie_remove()` in
  `drivers/pci/controller/plda/pcie-starfive.c` (platform `.remove`
  callback).
- **Context:** Driver unbind, module unload, platform device removal —
  can overlap with root-initiated sysfs PCI operations.

### Step 5.3: TRACE CALLEES
**Record:** `pci_lock_rescan_remove()`, `pci_stop_root_bus()`,
`pci_remove_root_bus()`, `pci_unlock_rescan_remove()`, then
`plda_pcie_irq_domain_deinit()` and optional `host_deinit`.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:**
- `platform_driver.remove` → `plda_pcie_host_deinit()` → unlocked bus
  teardown.
- Concurrent path: root writes to `/sys/bus/pci/rescan`,
  `/sys/.../remove`, or per-device rescan while StarFive PCIe driver is
  being removed.
- **Reachability:** Requires `CONFIG_PCIE_STARFIVE_HOST` (StarFive
  JH7110 / COMPILE_TEST). Sysfs triggers require root; driver remove can
  also happen during reboot/module unload.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** Same missing-lock pattern exists in dwc, cadence, altera,
brcmstb, iproc, mediatek (non-gen3), rockchip, vmd in this tree.
**Correct pattern** already present in `pci_host_common_remove()`,
`mtk_pcie_remove()` (gen3), `pci_aardvark`, `pci_mvebu`, `pci-hyperv`.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** Current code at lines 641–644 of `pcie-plda-
host.c`:

```641:644:drivers/pci/controller/plda/pcie-plda-host.c
void plda_pcie_host_deinit(struct plda_pcie_rp *port)
{
        pci_stop_root_bus(port->bridge->bus);
        pci_remove_root_bus(port->bridge->bus);
```

Bug present since **76c9113968079** (May 2024), well before 6.18.y
branched.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** **Clean apply expected** — 2-line addition with no
surrounding churn in recent plda history. Latest plda-host change:
`882569dca6646`.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** **No** — `git log --grep="plda: Protect root bus"` returned
nothing. Fix not yet in this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **Subsystem:** `drivers/pci/controller/plda` (PCI host
controller). **Criticality:** IMPORTANT — PCI core synchronization;
crash/UAF on affected hardware.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** PLDA code actively maintained (MSI domain switch, affinity,
microchip integration in 6.17–6.18). StarFive driver added May 2024,
merged via pci-v6.12-changes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** **Platform-specific** — users of `CONFIG_PCIE_STARFIVE_HOST`
(StarFive JH7110 RISC-V boards). Microchip PLDA users go through
`pci_host_common_remove()` which already holds the lock.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:**
- **Trigger:** Concurrent PLDA host driver removal and sysfs PCI
  rescan/remove on the same bus hierarchy.
- **Likelihood:** Uncommon but realistic (admin scripts, hotplug
  testing, driver rebind during PCI maintenance).
- **Unprivileged trigger:** No direct userspace trigger without
  root/CAP_SYS_ADMIN for sysfs PCI ops.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** **Use-after-free / kernel crash** — severity **HIGH**
(potential **CRITICAL** on affected systems). Matches documented PCI
subsystem race class; similar missing-lock bug caused a real oops in
**1d59d474e1cb7**.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** Prevents crashes/UAF on StarFive JH7110 stable
  deployments during driver teardown.
- **Risk:** Minimal — 2-line lock pair, established pattern, no behavior
  change except correct serialization.
- **Ratio:** Strong benefit, negligible risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Real synchronization bug in existing code path
- Documented PCI race class with UAF/crash consequences
- 2-line fix matching multiple in-tree precedents
- Bug present since `plda_pcie_host_deinit()` was added (2024)
- Standalone, applies cleanly to 6.18.44
- PCI maintainer sign-off (Bjorn Helgaas)
- Prior stable-worthy precedent: **1d59d474e1cb7** (rescan lock crash
  fix)

**AGAINST backport:**
- No explicit user crash report for plda
- Affects niche embedded platform (StarFive JH7110 only in this tree)
- Sysfs race requires privileged access

**UNRESOLVED:**
- Full lore.kernel.org review thread (WebFetch blocked)
- Whether commit has landed in mainline (not in this checkout)

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — matches established in-tree
   pattern; no Tested-by but fix is trivially verifiable.
2. Fixes a real bug? **PASS** — missing lock on bus teardown vs. sysfs
   rescan/remove.
3. Important issue? **PASS** — UAF/crash (HIGH severity).
4. Small and contained? **PASS** — 2 lines, 1 function.
5. No new features or APIs? **PASS** — synchronization only.
6. Can apply to local tree? **PASS** — buggy code confirmed present;
   infrastructure exists.

### Step 9.3: EXCEPTION CATEGORIES
**Record:** None (not a quirk, device ID, DT, build, or docs fix).
Standard bug fix.

### Step 9.4: DECISION RATIONALE

For Linux **6.18.y**, `plda_pcie_host_deinit()` removes a root PCI bus
without holding `pci_rescan_remove_lock`, while sysfs rescan/remove
paths hold that same lock. This is a known PCI race pattern that can
cause use-after-free and kernel crashes. The fix is a minimal 2-line
addition that mirrors `pci_host_common_remove()` and other corrected
drivers. It is standalone, applies cleanly, and addresses a real
stability issue on StarFive JH7110 systems using
`CONFIG_PCIE_STARFIVE_HOST`.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
  and local mbox cover letter.
- **[Phase 2]** Read current `pcie-plda-host.c` lines 641–651; confirmed
  2-line lock addition matches diff.
- **[Phase 2]** Read `drivers/pci/remove.c` — `pci_stop_root_bus()` /
  `pci_remove_root_bus()` have no internal lock.
- **[Phase 2]** Read `drivers/pci/pci-sysfs.c` lines 461–541 —
  rescan/remove stores use `pci_lock_rescan_remove()`.
- **[Phase 3]** `git describe HEAD` → v6.18.44; Makefile confirms
  6.18.44.
- **[Phase 3]** `git blame` lines 641–644 → introduced in
  **76c9113968079** (2024-03-28).
- **[Phase 3]** `git show 76c9113968079` — added
  `plda_pcie_host_deinit()`.
- **[Phase 3]** `git show 9d16947b75831` — `pci_lock_rescan_remove()`
  added 2014.
- **[Phase 3]** `git show 1d59d474e1cb7` — precedent crash from missing
  rescan lock.
- **[Phase 3]** `git log --grep="plda: Protect root bus"` — no match
  (fix not in tree).
- **[Phase 4]** Read local mbox `20260522_18255117159_pci_controller_add
  _missing_rescan_lock_around_root_bus_removal.mbx` — series context and
  bot review.
- **[Phase 4]** `b4 dig -c 76c9113968079` — found unrelated plda init
  thread (not this patch).
- **[Phase 4]** WebFetch patch.msgid.link — blocked (UNVERIFIED live
  thread).
- **[Phase 5]** `grep plda_pcie_host_deinit` — single caller:
  `starfive_pcie_remove()`.
- **[Phase 5]** `grep pci_lock_rescan_remove drivers/pci/controller/` —
  confirmed correct pattern in host-common, mtk-gen3, aardvark, mvebu,
  hyperv; missing in plda.
- **[Phase 6]** Buggy code confirmed present in 6.18.44 checkout.
- **[Phase 6]** Read `drivers/pci/controller/plda/Kconfig` — StarFive
  selects `PCIE_PLDA_HOST`; Microchip uses `PCI_HOST_COMMON` (already
  locked).
- **[Phase 7]** `git log --oneline -5 drivers/pci/controller/plda/pcie-
  starfive.c` — driver present since **39b91eb40c6aa** (May 2024).
- **[Phase 8]** Failure mode UAF/crash inferred from commit message, PCI
  probe.c comment (lines 3536–3539), and **1d59d474e1cb7** precedent —
  no plda-specific crash report (UNVERIFIED user impact).

**YES**The git history check finished successfully. It confirmed the
missing lock has been in `plda_pcie_host_deinit()` since commit
`76c9113968079` (May 2024), and that the fix is not yet in this 6.18.44
tree.

**Verdict: YES** — backport this commit. It’s a small, correct race fix
(UAF/crash risk during root bus removal vs. sysfs rescan) that matches
the pattern already used in `pci_host_common_remove()` and similar
drivers.

 drivers/pci/controller/plda/pcie-plda-host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/plda/pcie-plda-host.c b/drivers/pci/controller/plda/pcie-plda-host.c
index 3c2f683830107..f9a34f323ad8c 100644
--- a/drivers/pci/controller/plda/pcie-plda-host.c
+++ b/drivers/pci/controller/plda/pcie-plda-host.c
@@ -640,8 +640,10 @@ EXPORT_SYMBOL_GPL(plda_pcie_host_init);
 
 void plda_pcie_host_deinit(struct plda_pcie_rp *port)
 {
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(port->bridge->bus);
 	pci_remove_root_bus(port->bridge->bus);
+	pci_unlock_rescan_remove();
 
 	plda_pcie_irq_domain_deinit(port);
 
-- 
2.53.0

