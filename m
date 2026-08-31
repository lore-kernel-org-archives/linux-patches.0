Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40A043CE45;
	Mon, 31 Aug 2026 13:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183223; cv=none; b=gFQ6EOiqs9dqz+zLYez8oeoasew7pFpZC74EPjAKneOOkJzwgQO9r71k9WmoVK2SpRLR6M33dPpWoQnXtiqh+sGGGaP1DU5qq5qHV0FK9uGDXn+RizA8bi4ah8DXclZPWaw4B/WW4I5KKLunBRItZG3DyrIDTMFeMTe7jaIjWz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183223; c=relaxed/simple;
	bh=Tl1v/cimUpoFpd5bYni/skBDPyh2oGsc1aCdnnKwfac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JMiXovpJs2Xxkvw1hWtY8y3HbVkjwiUoMr080CgBfKweNeYF+jjNS7BVH/a9N1vn9QYJd2FdhjN/Z6lt5cnRBW7kVAv71FGiWOuHwEpGBN9WnyWbsi2WUMYFzFnFsQEfSDiSjwGbHaJXr8iMCh9G09H4AMHIZj8hdueO6xcJ8Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RfXbVWKN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RfXbVWKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4331F00A3E;
	Mon, 31 Aug 2026 13:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183220;
	bh=NbhIsQ5XWGPMR7qzfTNPMiqgmyRfRwNggMAQWX1gIkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RfXbVWKN7hRB05tSZjwvMHAERLJrnq4e5/ZRanFkZ/jaFJ8rAkkVP/wHJ4ivHpke1
	 69tlD1d5Vih7zyHZrgI0FRtwx/DDjyy1JFLucETu+9lb0f1wdWNuI72D426T3vCc8o
	 rR+x5zTR8bf2NWozqIxKUjWpEZUuxho4TZVxKwH6B3JBWIq/UCa9Ur5Hs89QkP71he
	 I7hCBWXmk9jj2eQS+10haB6u+foEUOj0i7KjiSRIaw+eHh2bYjYRefQzPVyNiI5xy2
	 SWHoK5dsP2+rLxgtS0dWwHW5RQQ3biLKOKUbRb1jZ6EnaPA/s7aod4kjkwpSZ9GXl+
	 G1EdqsuJaYYPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] PCI: Avoid FLR for MediaTek MT7925 WiFi
Date: Mon, 31 Aug 2026 09:20:45 -0400
Message-ID: <20260831133314.4125787-17-sashal@kernel.org>
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

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

[ Upstream commit 9f22b92259bb5ac43e2b9007103787d4418fec56 ]

The MediaTek MT7925 WiFi device advertises FLR capability, but it does not
work correctly. This manifests in VFIO passthrough scenarios. Normal VM
operation works fine, including clean shutdown/reboot. However, when the VM
terminates uncleanly (crash, force-off), VFIO attempts to reset the device
before it can be assigned to another VM. Because FLR is broken, the reset
fails, preventing reuse.

This is similar to its predecessor MT7922 (see 81f64e925c29 ("PCI: Avoid
FLR for Mediatek MT7922 WiFi")), but with different symptoms.  The MT7922
issue manifests as config read failures (returning ~0) after FLR. The
MT7925 shows different behavior: config reads work correctly after FLR, but
firmware communication fails.

First VM start with MT7925 works fine:

  mt7925e 0000:08:00.0: ASIC revision: 79250000
  mt7925e 0000:08:00.0: WM Firmware Version: ____000000, Build Time: 20260106153120

After force reset or VM crash, when VFIO attempts FLR to reset the device
for reassignment, firmware initialization fails:

  mt7925e 0000:08:00.0: ASIC revision: 79250000
  mt7925e 0000:08:00.0: Message 00000010 (seq 1) timeout
  mt7925e 0000:08:00.0: Failed to get patch semaphore
  [Repeats with increasing sequence numbers 2-10]
  mt7925e 0000:08:00.0: hardware init failed

The driver cannot acquire the patch semaphore needed for firmware
initialization, indicating that FLR does not properly reset the firmware
state. The device remains in this broken state until physical power cycle.

Disable FLR for MT7925 so the PCI core falls back to other reset methods,
e.g., Secondary Bus Reset, which successfully resets the device and allows
reinitialization for VFIO passthrough reuse.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260522070646.203115-1-jtornosm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[PCI] [avoid] Avoid FLR for MediaTek MT7925 WiFi — disable
broken Function Level Reset so PCI core falls back to Secondary Bus
Reset`

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Jose Ignacio Tornos Martinez
  `<jtornosm@redhat.com>` (author)
- **Signed-off-by:** Bjorn Helgaas `<bhelgaas@google.com>` (PCI
  maintainer)
- **Reviewed-by:** Manivannan Sadhasivam `<mani@kernel.org>` (MediaTek
  wireless maintainer)
- **Link:**
  https://patch.msgid.link/20260522070646.203115-1-jtornosm@redhat.com
- No Fixes:, Reported-by:, Tested-by:, Cc: stable, or syzbot tags
- Notable: PCI subsystem maintainer sign-off + MediaTek maintainer
  review; references prior MT7922 quirk commit `81f64e925c29`

### Step 1.3: Body analysis
**Record:**
- **Bug:** MT7925 advertises PCIe FLR capability but FLR does not
  correctly reset firmware state
- **Symptom:** After unclean VM termination (crash/force-off), VFIO
  triggers FLR to reset the device before reassignment; firmware init
  fails with patch-semaphore timeouts; device stays broken until
  physical power cycle
- **Normal use unaffected:** Clean VM shutdown/reboot and host-driver
  operation work fine
- **Root cause:** FLR completes from PCI core’s perspective (config
  reads succeed), so no fallback to SBR; firmware state is not properly
  reset
- **Fix:** Set `PCI_DEV_FLAGS_NO_FLR_RESET` via existing `quirk_no_flr`
  for device ID `0x7925`
- **Precedent:** MT7922 (`0x0616`) has the same quirk since commit
  `81f64e925c29` (present in this tree)

### Step 1.4: Hidden bug fix?
**Record:** Not disguised — this is an explicit hardware quirk for
broken FLR. It prevents a real device-stuck failure in VFIO passthrough
scenarios.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/pci/quirks.c` only (+2 lines of code, +1 comment
  line)
- **Functions:** `quirk_no_flr()` (unchanged); new
  `DECLARE_PCI_FIXUP_EARLY` for `PCI_VENDOR_ID_MEDIATEK, 0x7925`
- **Scope:** Single-file surgical hardware-quirk addition

### Step 2.2: Code flow change
**Record:**
- **Before:** MT7925 uses FLR when VFIO/PCI core resets the device; FLR
  appears successful but leaves firmware in a bad state
- **After:** Early boot quirk sets `PCI_DEV_FLAGS_NO_FLR_RESET`;
  `pcie_reset_flr()` / `pci_af_flr()` return `-ENOTTY`;
  `__pci_reset_function_locked()` falls through to bus reset (SBR),
  which works

### Step 2.3: Bug mechanism
**Record:** **Category (h): Hardware workaround / PCI quirk**
- Broken FLR on MT7925 leaves firmware state inconsistent
- Unlike MT7922 (config reads fail after FLR, eventually timing out to
  SBR), MT7925 config reads succeed after FLR, so the reset chain never
  falls back — device remains broken

### Step 2.4: Fix quality
**Record:**
- **Quality:** High — identical pattern to MT7922 and other devices in
  the same `quirk_no_flr` block
- **Regression risk:** Very low — only affects MT7925 reset path; SBR is
  the known-working fallback
- **No unrelated changes**

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `quirk_no_flr` block and MT7922 entry (`0x0616`) introduced by
  `81f64e925c29` (2025-02-12, Bjorn Helgaas)
- MT7925 quirk line (`0x7925`) is **not** in this tree yet

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag. Bug is inherent broken hardware FLR
behavior, not a regression from a specific kernel commit.

### Step 3.3: Related file history
**Record:**
- `81f64e925c29` — MT7922 FLR quirk (in tree, was Cc’d stable)
- Recent `quirks.c` changes in 6.18.44 are unrelated PCI quirks (link
  retraining, BW controller, bus-reset avoidance)
- Standalone one-commit fix, not part of a series

### Step 3.4: Author context
**Record:** Jose Ignacio Tornos Martinez (Red Hat); co-signed by PCI
maintainer Bjorn Helgaas. MT7922 quirk was authored by Bjorn Helgaas
with Tested-by from QubesOS developer.

### Step 3.5: Dependencies
**Record:**
- Requires existing `quirk_no_flr` infrastructure — **present** in this
  tree
- Requires MT7925 PCI device support — **present**
  (`drivers/net/wireless/mediatek/mt76/mt7925/pci.c`, device ID
  `0x7925`)
- No prerequisite commits needed; applies standalone

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1–4.5: Lore / b4 dig
**Record:**
- `b4 dig -c <hash>`: **N/A** — commit not in this checkout; no commit
  hash available
- WebFetch/curl to lore.kernel.org and patch.msgid.link: **blocked** by
  Anubis bot protection; could not read thread
- From commit message only: Reviewed-by Manivannan Sadhasivam; Link to
  patch submission
- **UNVERIFIED:** Whether reviewers explicitly nominated for stable in
  the mailing list thread

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `quirk_no_flr()` (early fixup), `pcie_reset_flr()`,
`pci_af_flr()`, `__pci_reset_function_locked()`

### Step 5.2: Callers
**Record:**
- `quirk_no_flr` runs at `DECLARE_PCI_FIXUP_EARLY` during PCI
  enumeration
- `PCI_DEV_FLAGS_NO_FLR_RESET` checked in `pcie_reset_flr()` and
  `pci_af_flr()` (`drivers/pci/pci.c:4357, 4379`)
- `__pci_reset_function_locked()` iterates reset methods; FLR skipped →
  bus reset used (`drivers/pci/pci.c:5008-5067`)
- VFIO calls `__pci_reset_function_locked()` on device release/reset
  (`drivers/vfio/pci/vfio_pci_core.c:707`)

### Step 5.3: Callees
**Record:** Quirk only sets `dev->dev_flags |=
PCI_DEV_FLAGS_NO_FLR_RESET`; reset path uses existing PCI reset
machinery

### Step 5.4: Reachability
**Record:**
- Trigger: VFIO PCI passthrough + unclean VM termination (crash/force-
  off)
- Requires `CONFIG_VFIO_PCI` + `CONFIG_MT7925E` + MT7925 hardware
- Not a general syscall path, but a documented, reproducible VFIO
  workflow

### Step 5.5: Similar patterns
**Record:** MT7922 (`0x0616`), AMD USB/audio controllers, Intel 82579,
SolidRun SNET — all use the same `quirk_no_flr` mechanism in this file

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:**
- **Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`,
  `make kernelversion` → `6.18.44`)
- MT7925 driver present since `c948b5da6bbec` (2023-09-30), ancestor of
  HEAD
- MT7922 FLR quirk present (`0x0616` at `quirks.c:5578`)
- **MT7925 FLR quirk absent** — `0x7925` not in `quirks.c`; commit not
  applied
- Bug is reachable: hardware advertises FLR, kernel will use it without
  this quirk

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — two-line addition to existing
quirk block with no structural changes

### Step 6.3: Related fixes already present?
**Record:** MT7922 quirk (`81f64e925c29`) is in tree; no MT7925-specific
FLR fix present

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **PCI core quirks** — IMPORTANT for PCI/VFIO virtualization
users with MT7925 hardware

### Step 7.2: Activity
**Record:** `quirks.c` actively maintained; FLR quirks are a well-
established pattern in this subsystem

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of MT7925 PCIe WiFi (`mt7925e`) with VFIO PCI
passthrough — config-specific but real production use (e.g., QubesOS-
style setups)

### Step 8.2: Trigger conditions
**Record:** VFIO-assigned MT7925 + unclean VM shutdown; not every boot,
but reproducible and common in VM crash scenarios; requires privileges
to use VFIO

### Step 8.3: Failure mode severity
**Record:** Device stuck in broken state until **physical power cycle**;
firmware init permanently fails on reassignment. **Severity: HIGH** for
affected users (not kernel oops, but hardware effectively bricked until
reboot/power-cycle)

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for VFIO + MT7925 users — restores device
  reusability after unclean VM exit
- **Risk:** VERY LOW — 2-line quirk, proven pattern, PCI maintainer
  authored/reviewed
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real hardware bug with documented failure logs in commit message
- Device unusable until power cycle after VFIO FLR — serious for
  virtualization users
- Trivial 2-line PCI quirk, same pattern as MT7922 (already in this
  tree, was stable-nominated)
- PCI maintainer (Bjorn Helgaas) sign-off; MediaTek maintainer review
- MT7925 driver and PCI device ID `0x7925` both present in 6.18.44
- Classic stable exception: hardware quirk/workaround

**AGAINST backport:**
- Only affects VFIO passthrough path, not normal host-driver operation
- Narrow hardware population (MT7925 PCIe specifically)
- No syzbot/fuzzer report or Cc: stable tag (expected for manual review)

**UNRESOLVED:**
- Mailing list thread content (lore blocked)
- Whether explicit stable nomination appeared in review thread

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — identical to in-tree MT7922
   quirk; maintainer-reviewed
2. Fixes a real bug affecting users? **PASS** — VFIO device stuck after
   unclean VM exit
3. Important issue? **PASS** — hardware effectively bricked until power
   cycle (HIGH for affected users)
4. Small and contained? **PASS** — 2 lines in one file
5. No new features or APIs? **PASS** — PCI quirk only
6. Can apply to local tree? **PASS** — infrastructure and hardware
   support both present

### Step 9.3: Exception category
**Record:** **Hardware quirk/workaround** — explicitly allowed for
stable

### Step 9.4: Decision rationale

For **Linux 6.18.44**, this commit should be backported. The MT7925 PCIe
driver and device ID are in this tree, the `quirk_no_flr` mechanism is
established (including the MT7922 precedent), and without this quirk
VFIO users with MT7925 hardware hit a broken FLR path that leaves the
device unusable until a physical power cycle. The fix is minimal,
follows an existing in-tree pattern, and carries negligible regression
risk.

---

## Verification

- [Phase 1] Parsed commit message: PCI FLR quirk for MT7925; tags: SOB
  (author + Bjorn Helgaas), Reviewed-by Manivannan Sadhasivam, Link to
  patch
- [Phase 2] Diff: +1 comment line, +1
  `DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_MEDIATEK, 0x7925,
  quirk_no_flr)` in `drivers/pci/quirks.c`
- [Phase 3] `git blame` line 5578: MT7922 quirk from `81f64e925c29`
  (2025-02-12)
- [Phase 3] `git show 81f64e925c29`: MT7922 quirk had Cc:
  stable@vger.kernel.org
- [Phase 3] `git merge-base --is-ancestor 81f64e925c29 HEAD`: MT7922
  quirk is in tree
- [Phase 3] `git merge-base --is-ancestor c948b5da6bbec HEAD`: MT7925
  driver is in tree
- [Phase 3] `c948b5da6bbec` dated 2023-09-30: initial MT7925 driver
- [Phase 4] `b4 dig`: N/A — commit hash not in checkout
- [Phase 4] WebFetch/curl lore.kernel.org: **FAILED** (bot protection)
- [Phase 5] `grep PCI_DEV_FLAGS_NO_FLR_RESET`: used in `pci.c:4357,
  4379`
- [Phase 5] Read `pci_reset_fn_methods`: FLR before bus reset in reset
  chain
- [Phase 5] VFIO calls `__pci_reset_function_locked` at
  `vfio_pci_core.c:707`
- [Phase 6] `git describe HEAD` → `v6.18.44`; `make kernelversion` →
  `6.18.44`
- [Phase 6] `grep 0x7925 drivers/pci/quirks.c`: **NOT FOUND** — quirk
  absent
- [Phase 6] `mt7925/pci.c:14`: `PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK,
  0x7925)` confirmed
- [Phase 6] Read `quirks.c:5558-5586`: `quirk_no_flr` block with MT7922,
  no MT7925
- [Phase 8] Failure mode from commit message: firmware init fails,
  device stuck until power cycle

**YES**

 drivers/pci/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index f6001be94955e..88d4a3f76bf3b 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5564,6 +5564,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x443, quirk_intel_qat_vf_cap);
  * Intel 82579LM Gigabit Ethernet Controller 0x1502
  * Intel 82579V Gigabit Ethernet Controller 0x1503
  * Mediatek MT7922 802.11ax PCI Express Wireless Network Adapter
+ * Mediatek MT7925 802.11be PCI Express Wireless Network Adapter
  */
 static void quirk_no_flr(struct pci_dev *dev)
 {
@@ -5576,6 +5577,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x7901, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_MEDIATEK, 0x0616, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_MEDIATEK, 0x7925, quirk_no_flr);
 
 /* FLR may cause the SolidRun SNET DPU (rev 0x1) to hang */
 static void quirk_no_flr_snet(struct pci_dev *dev)
-- 
2.53.0

