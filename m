Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A243BED78;
	Mon, 20 Apr 2026 13:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691569; cv=none; b=JiXZaV6qAEz3ldltDhOX/Q9z3HitKo6LNsSQhJryAsODU6WMWV0xEr0DpyXz4OvtysXIQIGfWmitqNXsNA/b3bAqjD512Gbs9H3/7pgB4wN8Vo/Pb34NeFX3zFW/vl5DEWNtmJV30OTxBHkrqyO/Esr8F1HzyT4hnGG21jWjofs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691569; c=relaxed/simple;
	bh=SJCCV0RuN9QdhST71zCkxmMQ+9pbQKyDd/uaEnagZ8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIm2xj2e0CB/KxEMBevpcmQo2ECkyjT+FDm3bf+c+scgWBUkxAVnIqDtTqTqWfqNquFRnz5q2xt/PVviwA7iAYHNME+pLdvZP0TNG+yGeQxpFIbwIY8WhRyv2IeXldS7juh06HHM5lqMeJQSQhx3SzIddTLIK6oKyz8q/1jk24s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d22nDM6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d22nDM6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA362C2BCB6;
	Mon, 20 Apr 2026 13:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691568;
	bh=SJCCV0RuN9QdhST71zCkxmMQ+9pbQKyDd/uaEnagZ8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d22nDM6bEvkny/UtwPN4twZSu0+aSPmIDiWMdPCBwn6a3IVU7/AS42gS3U7YvE7hD
	 dPdhECfp8urmmR+KiBZBAzP8EStc2hLTFea4X5nfUKbnQX3dGAjm4szXVUp/nMALEl
	 aE1y3QVxAclNWE8Ot0MqqD6dsLMt7Az2gyRkdpq+Z7qhU+h8K7ACR4sFdeFDS4BTHE
	 s19bC04O8BjuKf4v5K+2ioyjmd3GNOH7O2V/lS/OUOJpFMEAmVY05yR4JmTG0x8+ph
	 Pkmgbi7M/Tz/dp7xf1TzrEyvlnfzEHUoOuJruWFrYsMSiUfIFePtkWmFIWOgKfWmLq
	 zBQCAwbVeYFWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] PCI: Allow all bus devices to use the same slot
Date: Mon, 20 Apr 2026 09:18:19 -0400
Message-ID: <20260420132314.1023554-105-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 102c8b26b54e363f85c4c86099ca049a0a76bb58 ]

A PCIe hotplug slot applies to the entire secondary bus. Thus, pciehp only
allocates a single hotplug_slot for the bridge to that bus. The existing
PCI slot, though, would only match to functions on device 0, meaning any
devices beyond that, e.g., ARI functions, are not matched to any slot even
though they share it. A slot reset will break all the missing devices
because the handling skips them.

For example, ARI devices with more than 8 functions fail because their
state is not properly handled, nor is the attached driver notified of the
reset. In the best case, the device will appear unresponsive to the driver,
resulting in unexpected errors. A worse possibility may panic the kernel if
in-flight transactions trigger hardware reported errors like this real
observation:

  vfio-pci 0000:01:00.0: resetting
  vfio-pci 0000:01:00.0: reset done
  {1}[Hardware Error]:  Error 1, type: fatal
  {1}[Hardware Error]:   section_type: PCIe error
  {1}[Hardware Error]:   port_type: 0, PCIe end point
  {1}[Hardware Error]:   version: 0.2
  {1}[Hardware Error]:   command: 0x0140, status: 0x0010
  {1}[Hardware Error]:   device_id: 0000:01:01.0
  {1}[Hardware Error]:   slot: 0
  {1}[Hardware Error]:   secondary_bus: 0x00
  {1}[Hardware Error]:   vendor_id: 0x1d9b, device_id: 0x0207
  {1}[Hardware Error]:   class_code: 020000
  {1}[Hardware Error]:   bridge: secondary_status: 0x0000, control: 0x0000
  {1}[Hardware Error]:   aer_cor_status: 0x00008000, aer_cor_mask: 0x00002000
  {1}[Hardware Error]:   aer_uncor_status: 0x00010000, aer_uncor_mask: 0x00100000
  {1}[Hardware Error]:   aer_uncor_severity: 0x006f6030
  {1}[Hardware Error]:   TLP Header: 0a412800 00192080 60000004 00000004
  GHES: Fatal hardware error but panic disabled
  Kernel panic - not syncing: GHES: Fatal hardware error

Allow a slot to be created to claim all devices on a bus, not just a
matching device. This is done by introducing a sentinel value, named
PCI_SLOT_ALL_DEVICES, which then has the PCI slot match to any device on
the bus. This fixes slot resets for pciehp.

Since 0xff already has special meaning, the chosen value for this new
feature is 0xfe. This will not clash with any actual slot number since they
are limited to 5 bits.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/20260217160836.2709885-3-kbusch@meta.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a comprehensive understanding. Let me compile my final
analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: PCI (pciehp hotplug)
- Action verb: "Allow" - describes enabling a new behavior
- Summary: Enables PCIe hotplug slot to match ALL bus devices, not just
  device 0
- Record: [PCI/pciehp] [Allow] [bus-wide slot matching for ARI device
  reset handling]

**Step 1.2: Tags**
- Signed-off-by: Keith Busch <kbusch@kernel.org> (author, prolific PCI
  contributor)
- Signed-off-by: Bjorn Helgaas <bhelgaas@google.com> (PCI subsystem
  maintainer)
- Reviewed-by: Dan Williams <dan.j.williams@intel.com> (Intel PCI/CXL
  expert)
- Link:
  https://patch.msgid.link/20260217160836.2709885-3-kbusch@meta.com
  (patch 3 of a series)
- No Fixes: tag, no Cc: stable, no Reported-by - all expected for
  autosel candidates
- Record: Strong author+reviewer pedigree. Accepted through PCI
  maintainer tree.

**Step 1.3: Commit Body**
- Bug: pciehp allocates a single hotplug_slot for the bridge, but only
  matches device 0. ARI devices with >8 functions have functions
  appearing to be on different PCI_SLOT() values. These are not matched
  to the slot.
- Symptom: Slot reset skips unmatched devices - drivers not notified,
  state not saved/restored. This causes hardware errors, device
  unresponsiveness, and **kernel panic** from fatal PCIe AER errors.
- Real observed failure: Hardware Error with `Kernel panic - not
  syncing: GHES: Fatal hardware error` shown for a vfio-pci device at
  0000:01:01.0 during reset of 0000:01:00.0.
- Record: Bug is kernel panic during slot reset of ARI devices. Root
  cause is slot matching only covers device 0.

**Step 1.4: Hidden Bug Fix Detection**
- Despite the "Allow" verb (sounds feature-like), this fixes a concrete
  kernel panic. The commit includes a full hardware error trace showing
  the panic.
- Record: This IS a bug fix, clearly demonstrated by the panic trace.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- `include/linux/pci.h`: +8 lines (define + comment), 1 line changed
  (struct comment)
- `drivers/pci/hotplug/pciehp_core.c`: 2 lines changed (0 ->
  PCI_SLOT_ALL_DEVICES)
- `drivers/pci/slot.c`: +8 lines (new sysfs case), 3 conditionals
  changed, ~12 lines doc updates
- Total: ~20-25 functional lines, rest documentation. 3 files changed.
- Functions modified: `init_slot()`, `address_read_file()`,
  `pci_slot_release()`, `pci_dev_assign_slot()`, `pci_create_slot()`
- Record: Small-to-medium scope, well-contained to slot management code.

**Step 2.2: Code Flow Changes**
1. `pci.h`: Adds `PCI_SLOT_ALL_DEVICES 0xfe` sentinel constant
2. `pciehp_core.c init_slot()`: Changes slot number from `0` to
   `PCI_SLOT_ALL_DEVICES`
3. `slot.c pci_slot_release()`: Adds `slot->number ==
   PCI_SLOT_ALL_DEVICES ||` check - ensures ALL bus devices get
   `dev->slot = NULL` on release
4. `slot.c pci_dev_assign_slot()`: Same pattern - ensures ALL bus
   devices get `dev->slot = slot` during assignment
5. `slot.c pci_create_slot()`: Same pattern - ensures ALL devices on bus
   get `dev->slot` at creation
6. `slot.c address_read_file()`: New sysfs case for PCI_SLOT_ALL_DEVICES
   emitting `0` for device number (backward compatible)

**Step 2.3: Bug Mechanism**
- Category: Logic/correctness bug in slot matching
- What was broken: `PCI_SLOT(dev->devfn) == slot->number` only matches
  device 0. ARI functions >=8 have `PCI_SLOT(devfn) != 0`.
- How the fix works: The sentinel `PCI_SLOT_ALL_DEVICES` makes all
  comparisons match any device on the bus.
- Impact chain: `pci_dev_assign_slot()` skips ARI devices -> `dev->slot
  == NULL` -> `pci_slot_lock/save/restore` skips them (checks
  `!dev->slot || dev->slot != slot`) -> state not saved during reset ->
  hardware errors -> kernel panic

**Step 2.4: Fix Quality**
- Obviously correct: Yes - the matching logic is straightforward
- Minimal: Mostly - introduces a new constant as mechanism, but the
  functional changes are small
- Regression risk: Very low - the new code path only triggers when
  `slot->number == PCI_SLOT_ALL_DEVICES`, which only pciehp sets
- Record: High quality fix, well-reviewed, low regression risk.

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- `slot.c` line 76 (`PCI_SLOT(dev->devfn) == slot->number`): from commit
  cef354db0d7a72 (2008)
- `slot.c` line 169 (pci_dev_assign_slot): from cef354db0d7a72 (2008)
- `pciehp_core.c` line 82 (passing `0`): from 774d446b0f9222 (2018),
  originally from even earlier
- The buggy slot matching logic has been present since 2008 - it exists
  in ALL stable trees.
- Record: Buggy code from 2008, present in all active stable trees.

**Step 3.2: No Fixes: tag to follow** - Expected for autosel candidates.

**Step 3.3: File History**
- Recent changes to slot.c include treewide allocator changes (non-
  conflicting) and minor hotplug cleanups
- The pci_slot_lock() fix (1f5e57c622b4d) is already in 7.0, which was a
  prerequisite from the same author
- Record: File has low recent churn. Prerequisite slot lock fix already
  present.

**Step 3.4: Author Assessment**
- Keith Busch is a major PCI/NVMe subsystem contributor at Meta
- Has 30+ commits to `drivers/pci/` in this tree, focusing on error
  recovery and reset handling
- Record: Author is a key subsystem expert.

**Step 3.5: Dependencies**
- This is patch 3 of a series (msgid ...-3). The v2 series had 4
  patches. Patches 1+2 from v2 are in 7.0 (trylock fix + slot lock fix).
  Patches 3+4 from v2 were NOT applied (they took a different approach:
  removing slot-specific lock/unlock).
- The Feb 17 series (v3?) evolved the approach. This patch introduces
  PCI_SLOT_ALL_DEVICES instead of removing slot-specific functions.
- This patch is self-contained: it only modifies slot matching in slot.c
  and the init call in pciehp_core.c. The existing pci.c code
  (`dev->slot != slot` checks) works automatically once `dev->slot` is
  correctly assigned.
- Record: Self-contained, no additional dependencies beyond what's
  already in 7.0.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original Patch Discussion**
- b4 dig found the v2 series at
  https://patch.msgid.link/20260130165953.751063-3-kbusch@meta.com
- The v2 thread shows this was a 4-patch series: trylock fix, slot lock
  fix, remove slot-specific functions, make reset_subordinate hotplug
  safe
- The "Allow all bus devices" commit (Feb 17) is from a later revision
  that changed approach
- Dan Williams reviewed patches 3 and 4 of v2, providing feedback that
  led to the evolved approach
- Record: Series went through multiple revisions with review feedback
  incorporated.

**Step 4.2: Reviewers**
- Dan Williams (Intel, CXL/PCI expert) - Reviewed-by
- Bjorn Helgaas (PCI maintainer) - accepted and signed off
- Record: Key PCI maintainers reviewed and approved.

**Step 4.3: Bug Report**
- No external bug report link, but the commit message contains a real
  panic trace from production hardware
- The error shows vfio-pci resetting 0000:01:00.0, then device
  0000:01:01.0 (ARI function) triggering fatal hardware error
- Record: Real-world production failure documented in commit message.

**Step 4.4-4.5**: Lore site behind Anubis protection, but b4 dig
provided series information.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Functions**
Modified: `init_slot()`, `address_read_file()`, `pci_slot_release()`,
`pci_dev_assign_slot()`, `pci_create_slot()`

**Step 5.2: Callers**
- `pci_dev_assign_slot()` called from `pci_setup_device()` in probe.c -
  called during EVERY device enumeration
- `pci_create_slot()` called from pciehp init and other hotplug drivers
- The reset path uses `dev->slot` pointer in: `pci_slot_resettable()`,
  `pci_slot_lock()`, `pci_slot_unlock()`, `pci_slot_trylock()`,
  `pci_slot_save_and_disable_locked()`, `pci_slot_restore_locked()`
- `pci_reset_bus()` is called from VFIO, error recovery, and other reset
  paths
- Record: Highly reachable code paths. Reset triggered from userspace
  via VFIO.

**Step 5.3-5.5**: The fix ensures all devices on a pciehp bus get
`dev->slot` assigned, which propagates to all existing slot iteration
functions without any changes to pci.c.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable**
- The slot matching code (`PCI_SLOT(dev->devfn) == slot->number`) exists
  since 2008 - present in ALL active stable trees
- pciehp passing `0` as slot_nr exists since at least 2018 (commit
  774d446b0f9222)
- Record: Bug exists in all stable trees from 5.x through 7.0.

**Step 6.2: Backport Complications**
- The 7.0 tree has some treewide refactoring (kmalloc -> kmalloc_obj)
  that might cause minor context conflicts
- The core changes should apply cleanly with minor adjustments
- Record: Minor conflicts possible, but straightforward to resolve.

**Step 6.3: No related fixes already in stable for this specific
issue.**

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
- PCI core / pciehp - CORE subsystem
- Affects all systems with PCIe hotplug and ARI-capable devices
- Common in: VFIO/SR-IOV virtualization, datacenter hardware
- Record: [PCI/hotplug] [CORE/IMPORTANT]

## PHASE 8: IMPACT AND RISK

**Step 8.1: Affected Users**
- Users with PCIe ARI devices (multi-function devices with >8 functions)
  undergoing slot reset
- Common in VFIO/SR-IOV scenarios in datacenters and virtualization
- Record: Important user population (datacenter, virtualization)

**Step 8.2: Trigger Conditions**
- Triggered by slot reset (VFIO reset, error recovery, hotplug events)
- Can be triggered from userspace via VFIO
- The VFIO use case is common in production
- Record: Realistic trigger, reachable from userspace

**Step 8.3: Failure Mode**
- Kernel panic from fatal hardware error (GHES)
- Device unresponsiveness, unexpected driver errors
- Record: CRITICAL severity - kernel panic

**Step 8.4: Risk-Benefit**
- BENEFIT: Very high - prevents kernel panic in production VFIO/ARI
  scenarios
- RISK: Low - changes are well-contained, only affect slots with
  PCI_SLOT_ALL_DEVICES, backward compatible sysfs output
- Record: Strong benefit/risk ratio

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**
FOR backporting:
- Fixes documented kernel panic with real hardware error trace
- Affects production VFIO/SR-IOV users with ARI devices
- Author is key PCI contributor, reviewed by Dan Williams, accepted by
  Bjorn Helgaas
- Self-contained fix, no dependencies on other unmerged patches
- Low regression risk - new code path only for PCI_SLOT_ALL_DEVICES
  slots
- Buggy code present since 2008 - affects all stable trees
- The sysfs change preserves backward compatibility

AGAINST backporting:
- Introduces new `PCI_SLOT_ALL_DEVICES` constant (new kernel-internal
  API)
- Adds new semantics to `pci_create_slot()` (bus-wide slots)
- Part of a multi-patch series (patch 3), though self-contained
- Not purely surgical - includes documentation and sysfs behavior
  changes
- No Fixes: tag (expected for autosel)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? YES - reviewed by Dan Williams,
   accepted by Bjorn Helgaas
2. Fixes a real bug? YES - kernel panic during ARI device slot reset
3. Important issue? YES - kernel panic (CRITICAL severity)
4. Small and contained? YES (borderline) - ~25 functional lines, 3
   files, well-contained scope
5. No new features/APIs? BORDERLINE - `PCI_SLOT_ALL_DEVICES` is new but
   is mechanism for bug fix, not a user-facing feature
6. Can apply to stable? YES with possible minor context adjustments

**Step 9.3: Exception Categories**
- This is a hardware workaround/fix category - fixing slot reset to
  properly handle ARI devices

**Step 9.4: Decision**
The kernel panic severity, production impact (VFIO/ARI), strong
authorship/review, self-contained nature, and backward compatibility
outweigh the concern about the new internal constant. The
`PCI_SLOT_ALL_DEVICES` define is the minimal mechanism needed to fix
this bug correctly.

## Verification

- [Phase 1] Parsed tags: Keith Busch (author), Bjorn Helgaas (maintainer
  SOB), Dan Williams (Reviewed-by), Link to v3 series patch 3
- [Phase 2] Diff analysis: ~25 functional lines across 3 files. New
  PCI_SLOT_ALL_DEVICES constant, 3 conditional changes in slot.c, 1 init
  change in pciehp_core.c, sysfs backward-compatible change
- [Phase 3] git blame: Buggy slot matching in slot.c from commit
  cef354db0d7a72 (2008), pciehp passing 0 from commit 774d446b0f9222
  (2018)
- [Phase 3] git log author: Keith Busch has 30+ PCI commits including
  error recovery and reset handling
- [Phase 3] git log: Slot lock fix (1f5e57c622b4d) already in 7.0; v2
  patches 3+4 not applied (different approach evolved)
- [Phase 4] b4 dig -c 1f5e57c622b4d: Found v2 series [PATCHv2 0/4] pci:
  slot handling fixes at lore
- [Phase 4] b4 dig -a: Series went through at least v2 (Jan 30) and v3+
  (Feb 17) revisions
- [Phase 4] Thread review: Dan Williams reviewed the series, patches 1+2
  merged, 3+4 replaced by this new approach
- [Phase 5] pci_dev_assign_slot() called from pci_setup_device() during
  every device probe
- [Phase 5] pci_reset_bus() reachable from VFIO userspace and error
  recovery - confirms user reachability
- [Phase 5] pci.c slot iteration uses `dev->slot != slot` pointer
  comparison - works automatically once dev->slot correctly assigned
- [Phase 6] Buggy code exists in all stable trees (code from 2008/2018)
- [Phase 6] Minor context conflicts possible from treewide refactoring
- [Phase 8] Failure mode: kernel panic from GHES fatal hardware error -
  severity CRITICAL
- UNVERIFIED: Could not access lore.kernel.org directly due to Anubis
  protection for detailed discussion review
- UNVERIFIED: Exact series composition for the v3 (Feb 17) submission
  beyond patch 3

**YES**

 drivers/pci/hotplug/pciehp_core.c |  3 ++-
 drivers/pci/slot.c                | 31 +++++++++++++++++++++++++++----
 include/linux/pci.h               | 10 +++++++++-
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 1e9158d7bac75..2cafd3b26f344 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -79,7 +79,8 @@ static int init_slot(struct controller *ctrl)
 	snprintf(name, SLOT_NAME_SIZE, "%u", PSN(ctrl));
 
 	retval = pci_hp_initialize(&ctrl->hotplug_slot,
-				   ctrl->pcie->port->subordinate, 0, name);
+				   ctrl->pcie->port->subordinate,
+				   PCI_SLOT_ALL_DEVICES, name);
 	if (retval) {
 		ctrl_err(ctrl, "pci_hp_initialize failed: error %d\n", retval);
 		kfree(ops);
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 787311614e5b6..e0b7fb43423c9 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -42,6 +42,15 @@ static ssize_t address_read_file(struct pci_slot *slot, char *buf)
 				  pci_domain_nr(slot->bus),
 				  slot->bus->number);
 
+	/*
+	 * Preserve legacy ABI expectations that hotplug drivers that manage
+	 * multiple devices per slot emit 0 for the device number.
+	 */
+	if (slot->number == PCI_SLOT_ALL_DEVICES)
+		return sysfs_emit(buf, "%04x:%02x:00\n",
+				  pci_domain_nr(slot->bus),
+				  slot->bus->number);
+
 	return sysfs_emit(buf, "%04x:%02x:%02x\n",
 			  pci_domain_nr(slot->bus),
 			  slot->bus->number,
@@ -73,7 +82,8 @@ static void pci_slot_release(struct kobject *kobj)
 
 	down_read(&pci_bus_sem);
 	list_for_each_entry(dev, &slot->bus->devices, bus_list)
-		if (PCI_SLOT(dev->devfn) == slot->number)
+		if (slot->number == PCI_SLOT_ALL_DEVICES ||
+		    PCI_SLOT(dev->devfn) == slot->number)
 			dev->slot = NULL;
 	up_read(&pci_bus_sem);
 
@@ -166,7 +176,8 @@ void pci_dev_assign_slot(struct pci_dev *dev)
 
 	mutex_lock(&pci_slot_mutex);
 	list_for_each_entry(slot, &dev->bus->slots, list)
-		if (PCI_SLOT(dev->devfn) == slot->number)
+		if (slot->number == PCI_SLOT_ALL_DEVICES ||
+		    PCI_SLOT(dev->devfn) == slot->number)
 			dev->slot = slot;
 	mutex_unlock(&pci_slot_mutex);
 }
@@ -188,7 +199,8 @@ static struct pci_slot *get_slot(struct pci_bus *parent, int slot_nr)
 /**
  * pci_create_slot - create or increment refcount for physical PCI slot
  * @parent: struct pci_bus of parent bridge
- * @slot_nr: PCI_SLOT(pci_dev->devfn) or -1 for placeholder
+ * @slot_nr: PCI_SLOT(pci_dev->devfn), -1 for placeholder, or
+ *	PCI_SLOT_ALL_DEVICES
  * @name: user visible string presented in /sys/bus/pci/slots/<name>
  * @hotplug: set if caller is hotplug driver, NULL otherwise
  *
@@ -222,6 +234,16 @@ static struct pci_slot *get_slot(struct pci_bus *parent, int slot_nr)
  * consist solely of a dddd:bb tuple, where dddd is the PCI domain of the
  * %struct pci_bus and bb is the bus number. In other words, the devfn of
  * the 'placeholder' slot will not be displayed.
+ *
+ * Bus-wide slots:
+ * For PCIe hotplug, the physical slot encompasses the entire secondary
+ * bus, not just a single device number. If the device supports ARI and ARI
+ * Forwarding is enabled in the upstream bridge, a multi-function device
+ * may include functions that appear to have several different device
+ * numbers, i.e., PCI_SLOT() values.  Pass @slot_nr == PCI_SLOT_ALL_DEVICES
+ * to create a slot that matches all devices on the bus. Unlike placeholder
+ * slots, bus-wide slots go through normal slot lookup and reuse existing
+ * slots if present.
  */
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 				 const char *name,
@@ -285,7 +307,8 @@ struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 
 	down_read(&pci_bus_sem);
 	list_for_each_entry(dev, &parent->devices, bus_list)
-		if (PCI_SLOT(dev->devfn) == slot_nr)
+		if (slot_nr == PCI_SLOT_ALL_DEVICES ||
+		    PCI_SLOT(dev->devfn) == slot_nr)
 			dev->slot = slot;
 	up_read(&pci_bus_sem);
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 1c270f1d51230..5ae2dfdb2d6f3 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -72,12 +72,20 @@
 /* return bus from PCI devid = ((u16)bus_number) << 8) | devfn */
 #define PCI_BUS_NUM(x) (((x) >> 8) & 0xff)
 
+/*
+ * PCI_SLOT_ALL_DEVICES indicates a slot that covers all devices on the bus.
+ * Used for PCIe hotplug where the physical slot is the entire secondary bus,
+ * and, if ARI Forwarding is enabled, functions may appear to be on multiple
+ * devices.
+ */
+#define PCI_SLOT_ALL_DEVICES	0xfe
+
 /* pci_slot represents a physical slot */
 struct pci_slot {
 	struct pci_bus		*bus;		/* Bus this slot is on */
 	struct list_head	list;		/* Node in list of slots */
 	struct hotplug_slot	*hotplug;	/* Hotplug info (move here) */
-	unsigned char		number;		/* PCI_SLOT(pci_dev->devfn) */
+	unsigned char		number;		/* Device nr, or PCI_SLOT_ALL_DEVICES */
 	struct kobject		kobj;
 };
 
-- 
2.53.0

