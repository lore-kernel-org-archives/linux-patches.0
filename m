Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E7D52CCCB;
	Mon, 19 Oct 2026 13:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418361; cv=none; b=S4b7lIevukSGzovJiPgZyiBrgGOnMREpPls5LIzJ2Tyee6zxORBr7moSe6RNooL9mmlfzn+hXftDtFDmZmRsN+NMfN+LgGal4gxek4yskWr3gbCkanarWvlN0ALcwsUtrGVLxug9BNcie97C7X80paJUevKubLJxjsH91Kfkuvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418361; c=relaxed/simple;
	bh=EKWuKuX0iCOyHfYPQ5DESSjbXZnnoeG9yYAC7X9LLp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I7JAwPCzqvBwuG0CPBRMLOJtWA+xPVkLlr3dZAAIvU9xqz0NOWm18ohK2W1gvA/e6OzLTe+qOo1Qq+AGR6vv+r5R7MEppicVPzJPrijX03EF2DPW5/bG2FbDR1QzXHftb9zX7m1JPCMJSKfknUMsqmx5hBl6Otauehgof/hpKrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JIZhZDGG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JIZhZDGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA2B1F000C9;
	Mon, 19 Oct 2026 13:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418358;
	bh=4TmTuNRLh5iEaT4jqCfrRa0q278JAVTbcj4SloXq1Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIZhZDGGFaB3xZDybFoO304e+Ne2hEdwjfCvk+nbyoHr5KXdFBKWW8iyghEPu8VvW
	 BJYhGEfNXYvFbPorkenU4YZBAwdzAu74/iX901EILT3phx1vO3iB+nt5vQAP+wDo8k
	 EP53zjJE5KboC08CTxzsHrp35cDfyIKlPIeP3v5YAaMZkz8asjceBURURU7iAxrqGM
	 OTX4KSYo2EDUm4cj/+s7Bg97RnROMcF45ayTFSWTkVSWcE0C4zPjlD5jkaeZOPMuz9
	 SZe3GaTCZUm1Xqus4NQeFGpVI2l86U0wJJrfH0hOBPq6eaUGyAKL2jewiyJxGeEPaT
	 t0nB5D3eTMh4w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Farhan Ali <alifm@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] PCI: Avoid saving config space state if inaccessible
Date: Mon, 19 Oct 2026 09:48:02 -0400
Message-ID: <20261019135441.1420968-191-sashal@kernel.org>
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

From: Farhan Ali <alifm@linux.ibm.com>

[ Upstream commit e18d1abc3bff0a24a5299f3c150ab9546e9439aa ]

The current reset process saves the device's config space state before
reset and restores it afterward. However errors may occur unexpectedly and
it may then be impossible to save config space because the device may be
inaccessible (e.g. DPC). This results in saving invalid values that get
written back to the device during state restoration.

With a reset we want to recover/restore the device into a functional state.
So avoid saving the state of the config space when the device config space
is inaccessible.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
[bhelgaas: comment]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260805165518.794-4-alifm@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111**. The buggy reset-time save path is
present here; this is a small, self-contained PCI error-recovery fix for
that path.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[PCI]** **[Avoid]** Avoid saving config space state if
inaccessible. “Avoid” here is a bug-fix verb: skip a save that would
capture invalid `~0` values.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Farhan Ali \<alifm@linux.ibm.com\> (author)
- Signed-off-by: Bjorn Helgaas \<bhelgaas@google.com\> (PCI maintainer;
  also `[bhelgaas: comment]`)
- Reviewed-by: Niklas Schnelle \<schnelle@linux.ibm.com\>
- Reviewed-by: Bjorn Helgaas \<bhelgaas@google.com\>
- Link:
  https://patch.msgid.link/20260805165518.794-4-alifm@linux.ibm.com
- No Fixes:, Reported-by:, Tested-by:, or Cc: stable (absence expected
  for this review)
- Ignore pipeline markers (none in the provided message except the
  evaluation context)

Notable: PCI maintainer both reviewed and applied it. The msgid is **v23
3/5** of “Error recovery for vfio-pci devices on s390x” (cover is `-1`,
so `-4` is patch 3/5).

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Reset saves config space, then restores it. If the device is
  inaccessible (example given: DPC), reads return `~0`. Those invalid
  values are saved and later written back.
- **Symptom:** After reset/error recovery the device is programmed with
  garbage (invalid BARs / Command register), so it does not come back
  functional.
- **Root cause:** Unconditional `pci_save_state()` in the reset path
  while config space may already be gone.
- **Fix:** Do not save (or disable via Command) when config space is
  inaccessible.
- **Versions:** None stated; DPC/AER reset is long-standing.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. This is an explicit correctness fix for invalid
save/restore during error recovery.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/pci/pci.c` only (~+24 lines, 0 removed)
- New helper: `pci_dev_config_accessible()`
- Modified: `pci_dev_save_and_disable()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Helper:** Read dword at `PCI_COMMAND` (Command + Status). If
  `PCI_POSSIBLE_ERROR(val)` (`== ~0`), warn and return false. Uses
  Command/Status rather than Vendor/Device ID because VFs can
  legitimately read as `~0` there.
- **`pci_dev_save_and_disable` before:** After
  `pci_set_power_state(D0)`, always `pci_save_state()` then write
  `PCI_COMMAND_INTX_DISABLE`.
- **After:** If config is inaccessible, return without saving or writing
  Command. `reset_prepare` and D0 wake still run.
- Path: reset / error-recovery, not probe or normal PM suspend.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Logic / correctness** in error recovery.
- Broken: inaccessible config → `pci_save_state()` fills
  `saved_config_space[]` with `~0` and sets `state_saved`.
  `pci_restore_state()` later writes that back (BARs `0xFFFFFFFF`,
  Command `0xFFFF`).
- Fix: skip that overwrite so restore uses the last good snapshot
  (enumeration-time save in this tree, or a driver’s later
  `pci_save_state()`).

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: same `PCI_POSSIBLE_ERROR` heuristic already used
  across PCI.
- Minimal: one check, no API change.
- Residual race is documented (device can disappear between check and
  save); that is pre-existing, not introduced.
- False positive (`Command|Status` actually `0xFFFFFFFF` on a live
  device) is vanishingly unlikely; Status reserved bits typically read
  0.
- Skipping the Command disable when inaccessible is a no-op: that write
  would not land anyway.
- Regression risk: **low**. Healthy reset path is unchanged.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Unconditional `pci_save_state()` in `pci_dev_save_and_disable()` comes
  from Alex Williamson, 2013 (`77cb985ad4acbe` / `a6cbaadea0af9`).
- Function itself dates to Keith Busch 2014 / Christoph Hellwig 2017.
- Bug is old; it became more important after enumeration-time save +
  always-restore.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Related in-tree commit **`58130e7ce6cb6`**
(`PCI/ERR: Ensure error recoverability at all times`, upstream
`a2f1e22390ac`) is an ancestor of HEAD. It:
- Calls `pci_save_state()` at device add (`drivers/pci/bus.c`)
- Removes the `if (!dev->state_saved) return;` in `pci_restore_state()`

Verified in this checkout: `pci_save_state(dev)` at
`pci_bus_add_device()` (placement later adjusted by `f8f55a226aab4`).
Restore no longer bails on `state_saved`. So a garbage reset-time save
**will** be restored. This patch is what keeps that snapshot valid when
DPC has already isolated the device.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Same series, already in this tree: **`1872805e97043`** `PCI/MSI:
  Enable memory decoding before restoring MSI-X messages` (v23 5/5, `Cc:
  stable`).
- Not in this tree: v23 1/5 slot placeholder, 2/5 s390 per-function
  slots, **this 3/5**, 4/5 “Fail FLR when config space inaccessible”.
- Recent `pci.c` churn is unrelated (D3hot wait, ASPM, ACS, slot
  locking).

This patch is **standalone**. 1/5 and 2/5 are s390 slot work. 4/5 *uses*
`pci_dev_config_accessible()` but is not required for the save-garbage
fix. 5/5 already landed independently.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Farhan Ali (IBM) works on s390 PCI / vfio. In this tree the
related MSI-X restore fix is already present. Helgaas (subsystem
maintainer) reviewed and applied.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Needs `PCI_POSSIBLE_ERROR` — present in `include/linux/pci.h`.
- Needs `pci_find_dvsec_capability` only as an insertion landmark —
  present at `drivers/pci/pci.c:762`.
- Needs `pci_dev_save_and_disable` / `pci_save_state` — present.
- `device_lock_assert` / `pci_warn(..., "resetting")` in the *upstream
  context* are **not** in 6.12; they are context-only, not part of this
  change. Insertion is after `pci_set_power_state(dev, PCI_D0)`, which
  matches this tree.
- Can apply standalone: **yes**.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 5e14afc4aa192` failed (that string is a **blob** hash from
  the candidate diff, not a commit).
- `b4 mbox` on msgid `20260805165518.794-4-alifm@linux.ibm.com`:
  23-message thread saved.
- Lore/cover: v23 0/5 “Error recovery for vfio-pci devices on s390x”;
  this is **3/5**.
- Earlier revisions (v9) tried to **never** save at reset (rely only on
  enumeration save). Reviewers (Helgaas / Alex Williamson) rejected that
  because normal resets must capture current driver-programmed state.
  v22/v23 compromise: skip save **only** when config reads as `~0`.
- Helgaas rewrote the comment on apply (`[bhelgaas: comment]`).
  Functional code matches v23.
- Sashiko: low `const char *msg` nit only. No NAK on this patch.
- No reviewer asked for Cc: stable on **this** patch (unlike 2/5 and
  5/5). That is not a negative for this evaluation.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: linux-pci via Helgaas; Niklas Schnelle (s390 PCI). Right
maintainers.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Motivated by s390 vfio-pci DPC/error
recovery (IBM). Mechanism is generic for any AER/DPC isolation, not
s390-only.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: v23 1–5 as above. 4/5 adds the same helper use in `pcie_flr()`;
Helgaas was lukewarm on that racy FLR-only check but still merged this
save-path patch. 5/5 already in 6.12.111.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable WebFetch returned 403. **UNVERIFIED**
whether stable@ discussed this exact subject. 5/5 from the same series
*was* explicitly Cc: stable and is already here.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `pci_dev_config_accessible()` (new),
`pci_dev_save_and_disable()` (modified).

**Step 5.2: TRACE CALLERS**
Record: `pci_dev_save_and_disable()` is static; callers in this tree:
- `pci_reset_function()` — sysfs/`EXPORT` function reset
- `pci_reset_function_locked()`
- `pci_try_reset_function()`
- `pci_bus_save_and_disable_locked()` ← `__pci_reset_bus()`
- `pci_slot_save_and_disable_locked()` ← `__pci_reset_slot()`

AER uses `pci_bus_error_reset()` → slot reset or bus reset, which
save/disable then restore. Userspace can also hit this via
`/sys/bus/pci/devices/.../reset`.

**Step 5.3: TRACE CALLEES**
Record: `pci_read_config_dword`, `PCI_POSSIBLE_ERROR`, `pci_warn`; then
existing `pci_save_state` / Command write.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: User-reachable via sysfs reset and via AER/DPC error IRQs. DPC
is the cited case: config reads `~0` while containment is active, then
reset+restore. **Yes, reachable.**

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `PCI_POSSIBLE_ERROR` already used in `pci.c` PM paths, DPC,
probe, hotplug. 4/5 of this series reuses the new helper for FLR; not in
this tree yet and not required for this verdict.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `pci_dev_save_and_disable()` at
`drivers/pci/pci.c:5047` still does unconditional `pci_save_state()`
after D0. `pci_dev_config_accessible()` does **not** exist. `make
kernelversion` / Makefile: **6.12.111**. Bug introduced with 2013 reset
save/disable; still here.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply / trivial context.** Helper can sit after existing
`pci_find_dvsec_capability()`. The three-line guard goes after
`pci_set_power_state(dev, PCI_D0)` before `pci_save_state(dev)` —
identical here. Upstream context lines (`device_lock_assert`,
`"resetting"` warn) are later mainline-only and are not part of this
patch.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: Enumeration save + always-restore (**`58130e7ce6cb6`**) is here;
without this patch it can restore **poisoned** `~0` state after DPC.
MSI-X Memory-enable restore (**`1872805e97043`**) is here. No substitute
for this skip-save check.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **PCI core** (`drivers/pci/pci.c`). **IMPORTANT** (all PCI
devices; error recovery and function reset). Not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature core with ongoing AER/DPC/reset work. This is a targeted
recovery fix, not a refactor.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: PCI error recovery (AER/DPC) and anyone resetting a device whose
config is gone. Originally s390 vfio-pci passthrough; same path is
generic. Config-specific: PCI + AER/DPC/reset users (common on servers).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: DPC/containment or other inaccessible config during reset. Not
every boot; when it hits, recovery is the path that should restore the
device. Unprivileged users can trigger sysfs reset only with privilege;
AER/DPC is hardware-driven.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Restore of `~0` → invalid BARs, Command all-ones (I/O, MMIO, bus
master, SERR). Device stays broken after “recovery”; possible further
URs / bad DMA. **Severity: HIGH** (failed recovery, device unusable;
bus-master with junk BARs is worse than a leak).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit: HIGH** — preserves last good config through DPC/reset;
  completes recoverability that `58130e7ce6cb6` already shipped in this
  tree.
- **Risk: LOW** — ~24 lines, established heuristic, healthy devices
  unchanged.
- **Ratio:** strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real bug: save/restore of `~0` config during inaccessible reset (DPC).
- Failure is failed PCI recovery and a device left misprogrammed.
- Small, obviously correct, reviewed by Helgaas and Schnelle.
- Buggy code and insertion points exist in 6.12.111.
- Enumeration-time save already in this tree; this patch prevents
  clobbering it.
- Same series’ 5/5 already backported here.
- Standalone vs s390 slot patches.

AGAINST:
- No Cc: stable / Fixes: on this commit (expected; not a veto).
- Trigger is error recovery, not the hot path.
- Check is racy (documented); Helgaas still merged it.
- 4/5 (fail FLR) not included; incomplete vs full series, but this hunk
  still fixes the save-poisoning bug on its own.

UNRESOLVED:
- Stable-list thread 403; could not confirm prior stable@ discussion.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — Helgaas+Schnelle Reviewed-
   by; heuristic already in-tree.
2. Fixes a real bug that affects users? **PASS** — DPC/error recovery
   restores garbage config.
3. Important issue? **PASS** — HIGH: recovery failure / device left with
   invalid BARs and Command.
4. Small and contained? **PASS** — one file, ~24 lines.
5. No new features or APIs? **PASS** — static helper + guard.
6. Can apply to the local tree? **PASS** — same functions and insertion
   point in 6.12.111.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not an ID/quirk/DT/build/docs exception. Ordinary important bug
fix.

**Step 9.4: MAKE YOUR DECISION**
Backport. It prevents writing invalid `~0` config back after reset when
the device is already inaccessible, which is exactly the DPC/AER
recovery case this 6.12 tree already tries to support via enumeration-
time save.

------------------------------------------------
What the commit solves for this tree
------------------------------------------------
On 6.12.111, reset still always calls `pci_save_state()` in
`pci_dev_save_and_disable()`. If config reads as `~0` (DPC), that
poisons `saved_config_space`. `pci_restore_state()` no longer refuses
restore (`58130e7ce6cb6`), so those values get programmed back. Skipping
the save keeps the enumeration (or last good) snapshot.

Risk vs benefit: low risk, high benefit. No new API. Apply is clean
aside from unrelated later context around `device_lock_assert`.

------------------------------------------------
Verification
------------------------------------------------
- [Phase 1] Subject/tags parsed from the candidate message; Link msgid
  is v23 3/5.
- [Phase 2] Diff: helper + 3-line guard in `pci_dev_save_and_disable`;
  `pci_save_state()` in this tree writes `saved_config_space[]` and sets
  `state_saved` with no accessibility check.
- [Phase 3] `git describe` / `make kernelversion`: p-6.12-3 /
  **6.12.111**.
- [Phase 3] `git blame -L 5047,5076 drivers/pci/pci.c`: unconditional
  save from 2013 Williamson commits.
- [Phase 3] `git merge-base --is-ancestor 58130e7ce6cb6 HEAD`: yes;
  enumeration save + restore-always.
- [Phase 3] `git merge-base --is-ancestor 1872805e97043 HEAD`: yes;
  series 5/5 already here.
- [Phase 3] `git log --grep='Avoid saving config'` on `drivers/pci/`:
  this fix **not** present.
- [Phase 4] `b4 mbox` msgid 20260805165518.794-4: 23 msgs; Helgaas
  Reviewed-by; no NAK on 3/5.
- [Phase 4] Cover letter: PCI slice of vfio-pci s390 error recovery; v9
  “never save at reset” was rejected.
- [Phase 4] lore.kernel.org/stable: **UNVERIFIED** (HTTP 403).
- [Phase 5] Callers of `pci_dev_save_and_disable` traced in `pci.c`; AER
  `pci_bus_error_reset` → slot/bus reset save/restore.
- [Phase 6] `pci_find_dvsec_capability` at line 762;
  `PCI_POSSIBLE_ERROR` in `include/linux/pci.h`; `PCI_COMMAND` is 0x04.
- [Phase 6] `pcie_flr()` in this tree has no accessibility check (4/5
  not required for this verdict).
- UNVERIFIED: whether Command+Status can be legitimate `0xFFFFFFFF` on
  some broken device (kernel-wide heuristic already accepts that risk).

**YES**

 drivers/pci/pci.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 264213aa7630b..16942779e6ebd 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -725,6 +725,28 @@ u16 pci_find_dvsec_capability(struct pci_dev *dev, u16 vendor, u16 dvsec)
 }
 EXPORT_SYMBOL_GPL(pci_find_dvsec_capability);
 
+static bool pci_dev_config_accessible(struct pci_dev *dev, char *msg)
+{
+	u32 val;
+
+	/*
+	 * If a device's config space is inaccessible, reads typically
+	 * return ~0.  Since Device and Vendor ID are always ~0 for VFs,
+	 * check the Command and Status registers instead.
+	 *
+	 * N.B. This is racy because the device may become inaccessible
+	 * before the next access.
+	 */
+	pci_read_config_dword(dev, PCI_COMMAND, &val);
+	if (PCI_POSSIBLE_ERROR(val)) {
+		pci_warn(dev, "Device config space inaccessible; unable to %s\n",
+				msg);
+		return false;
+	}
+
+	return true;
+}
+
 /**
  * pci_find_parent_resource - return resource region of parent bus of given
  *			      region
@@ -5009,6 +5031,9 @@ static void pci_dev_save_and_disable(struct pci_dev *dev)
 	 */
 	pci_set_power_state(dev, PCI_D0);
 
+	if (!pci_dev_config_accessible(dev, "save state"))
+		return;
+
 	pci_save_state(dev);
 	/*
 	 * Disable the device by clearing the Command register, except for
-- 
2.53.0

