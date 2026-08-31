Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096094749FA;
	Mon, 31 Aug 2026 13:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184340; cv=none; b=PWfi+Nav29EJs5q9GFV844LSsb3geu+9nc6g4khMfBM2726eFHn8ymO1N6nJEPbWE852LkrF87p/BLNWtIPB/ARfwJfzoD05rixEDcuRif+gfh/KIEzEDZUTLctMiOiSRn2AO1umhX7tfSQaXK/4qsoaHi524dAmJBYR/OKAeE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184340; c=relaxed/simple;
	bh=KJK3ycfqUwN1KDk7Ki5klCghE4HY+wFirozkycJ1jTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FGEpGftJ2jOjLuZdqpBcLy3l7kWci1Zz6a32XRCDhfwHXb4yh+0QEXEShzF7+yBAidma6HV79YrbdodGkEzlq8lZlUX1CE8a9PpQV0v61JFqYJWjEEv0Zlnz1BXBH1J3RQ2Gh7y12Tl4iT41dUuYQi0JdsV9ojytzHkzlS43Mgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZE8Mi7A5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZE8Mi7A5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F651F000E9;
	Mon, 31 Aug 2026 13:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184337;
	bh=l6e8MCFDdZ45iyK12XDZh0vNZV6G6YO/jnD4tg1Cyk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZE8Mi7A5yg/6WplFYswVtgx7NgZkOyrUEk9jxNraymfyeTyZYxLA34mCYA2k6pTBZ
	 bElGVpLAZUCM/75XaoVEUmGEJh2+6156p6Q9D+kWeuAzvRdpdvp3565VsdUDSJHNrB
	 sBkp3aljiURPVEyFj+8Yf32EAalUL05vEvDECWiDhNISI6EqX0ldEy/t4WEWE9mS34
	 xabs/xqwHUXRViLoaDUApRmUPihUsLNXNENBEnOjV95MWUw0WNkhh7ads92bextwoi
	 0aodmWhgRfniPmq2AEK9wEBqE0IFr9CUE6Y6LO+SMW7fPMubdJ4o3TmLyzhQcDR/8o
	 IYsFR9PdUQdEQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] PCI: Stop setting cached power state to 'unknown' on unbind
Date: Mon, 31 Aug 2026 09:31:02 -0400
Message-ID: <20260831133314.4125787-634-sashal@kernel.org>
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

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit d462c8e89e84bfb6417e6b4c88e0cb7cc747ba41 ]

When a PCI device is unbound from its driver, pci_device_remove() sets the
cached power state in pci_dev->current_state to PCI_UNKNOWN.  This was
introduced by commit 2449e06a5696 ("PCI: reset pci device state to unknown
state for resume") to invalidate the cached power state in case the system
is subsequently put to sleep.

For bound devices, the cached power state is set to PCI_UNKNOWN in
pci_pm_suspend_noirq(), immediately before entering system sleep.

Extend to unbound devices for consistency.

This obviates the need to change the cached power state on unbind, so stop
doing so.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/af7d11d3ceb231acc90829f7a5c8400c2446744f.1776415510.git.lukas@wunner.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[PCI]` `[Stop]` — Stop setting cached power state to
`PCI_UNKNOWN` on driver unbind; move invalidation to the system-suspend
path for driverless devices.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Lukas Wunner `<lukas@wunner.de>` (author)
- **Signed-off-by:** Bjorn Helgaas `<bhelgaas@google.com>` (PCI
  maintainer)
- **Reviewed-by:** Mario Limonciello (AMD) `<superm1@kernel.org>`
- **Link:** https://patch.msgid.link/af7d11d3ceb231acc90829f7a5c8400c244
  6744f.1776415510.git.lukas@wunner.de
- **No** Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org,
  or syzbot tags
- Notable: PCI subsystem maintainer sign-off; AMD reviewer found no
  corner cases

### Step 1.3: Body Analysis
**Record:**
- **Bug described:** On driver unbind, `pci_device_remove()` sets
  `pci_dev->current_state = PCI_UNKNOWN` while hardware may still be in
  D0. Bound devices only invalidate the cache in
  `pci_pm_suspend_noirq()` right before sleep. Driverless/unbound
  devices on the `!pm` suspend path skipped that invalidation.
- **Symptom/failure mode:** Stale cached power state after
  suspend/resume can cause `pci_set_power_state(dev, PCI_D0)` to return
  early (believing the device is already in D0) when hardware is
  actually in D3 — the same class of failure as bugzilla #6024 fixed by
  commit 2449e06a5696.
- **Version info:** References 2449e06a5696 (2006); commit d462c8e89e84
  landed in mainline April 2026.
- **Root cause:** PCI_UNKNOWN invalidation was done at unbind time (too
  early) and was missing from the `!pm` branch of
  `pci_pm_suspend_noirq()`.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes. Described as “consistency,” but it closes a real PM
correctness gap: driverless PCI devices on S2RAM suspend never had their
cached state invalidated, and prematurely setting UNKNOWN at unbind left
cache ≠ hardware between unbind and suspend.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/pci/pci-driver.c` (+2 / −8 lines)
- **Functions:** `pci_device_remove()`, `pci_pm_suspend_noirq()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Changes
**Record:**
- **Hunk 1 (`pci_device_remove`):** Before — set `PCI_UNKNOWN` on unbind
  if cached state was D0. After — remove that; cached state stays
  accurate while hardware is still D0.
- **Hunk 2 (`pci_pm_suspend_noirq`):** Before — `!pm` path
  (`pci_save_state` then `goto Fixup`) skipped
  `pci_pm_set_unknown_state()`. After — `goto set_unknown` ensures
  driverless devices also invalidate cache immediately before sleep,
  same as bound devices.

### Step 2.3: Bug Mechanism
**Record:** **Logic / correctness fix (PCI PM cache coherency).**
`pci_set_power_state()` early-returns when `dev->current_state == state`
(see `__pci_set_power_state()` at line 1545 in `pci.c`). Stale D0 after
BIOS changes hardware to D3 during suspend prevents powering the device
back up on driver bind — identical mechanism to bugzilla #6024.

### Step 2.4: Fix Quality
**Record:** Minimal, obviously correct, mirrors existing bound-device
behavior. Low regression risk: only moves UNKNOWN invalidation from
unbind to suspend_noirq; hibernate path (`pci_pm_freeze_noirq`) already
called `pci_pm_set_unknown_state()` for all devices.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Unbind-time `PCI_UNKNOWN` logic traces to 2449e06a5696
(“PCI: reset pci device state to unknown state for resume”, 2006). That
commit is present in this tree. `pci_pm_set_unknown_state()` exists at
line 606 in current `pci-driver.c`.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag. Referenced commit 2449e06a5696 is in
this tree and introduced the unbind-time behavior this patch refines.

### Step 3.3: Related Changes
**Record:** Related recent fix: 382895a288515 “PCI/PM: Reinstate
clearing state_saved in legacy and !PM codepaths” (already in 6.18.43).
No patch-series dependency; standalone 1/1 commit (d462c8e89e84).

### Step 3.4: Author Context
**Record:** Lukas Wunner is a regular PCI/PM contributor. Bjorn Helgaas
(PCI maintainer) applied and signed off. No other related commits from
this author in the immediate `pci-driver.c` history of this tree.

### Step 3.5: Dependencies
**Record:** No prerequisites. Requires only existing
`pci_pm_set_unknown_state()` and `pci_pm_suspend_noirq()` `!pm` path —
all present in Linux 6.18.43. Patch applies cleanly (`git apply --check`
passed).

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** b4 dig found thread at https://patch.msgid.link/af7d11d3ceb2
31acc90829f7a5c8400c2446744f.1776415510.git.lukas@wunner.de. Single v1
patch; Bjorn applied to `pci/pm`; Mario Limonciello Reviewed-by with no
corner cases found. No stable nomination or NAKs.

### Step 4.2: Reviewers
**Record:** b4 dig -w: To/Cc included Bjorn Helgaas, Rafael Wysocki,
Mario Limonciello, Alex Williamson, linux-pci@vger.kernel.org.

### Step 4.3: Bug Reports
**Record:** No new bug report. Commit references historical bugzilla
#6024 class via 2449e06a5696. No syzbot link.

### Step 4.4: Series Context
**Record:** Standalone patch, not part of a multi-patch series.

### Step 4.5: Stable List History
**Record:** lore.kernel.org blocked by bot protection; no stable-list
discussion found via b4 mbox thread.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `pci_device_remove()`, `pci_pm_suspend_noirq()`,
`pci_pm_set_unknown_state()`, `pci_set_power_state()` /
`__pci_set_power_state()`.

### Step 5.2: Callers
**Record:** `pci_device_remove` — PCI bus `.remove` callback (sysfs
unbind, module unload). `pci_pm_suspend_noirq` — PCI bus
`.suspend_noirq` for every PCI device during system suspend.

### Step 5.3: Callees
**Record:** `pci_save_state()`, `pci_pm_set_unknown_state()`,
`pci_fixup_device()`, `pci_prepare_to_sleep()` (bound path only).

### Step 5.4: Reachability
**Record:** Any PCI device without a bound driver (or driver without PM
ops) going through system suspend hits the `!pm` path. Users can trigger
via S3/S2RAM; driver bind after resume via `modprobe` or sysfs is
common. Reachable without privileges for suspend; driver bind typically
requires root.

### Step 5.5: Similar Patterns
**Record:** `pci_pm_freeze_noirq()` already calls
`pci_pm_set_unknown_state()` unconditionally (line 1098). Suspend path
was inconsistent for driverless devices.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Tree is **Linux 6.18.43** (`git describe HEAD` →
v6.18.43). Buggy code confirmed at lines 497–498 (unbind UNKNOWN) and
line 874 (`goto Fixup` skipping `pci_pm_set_unknown_state` for `!pm`).

### Step 6.2: Backport Complications
**Record:** Patch applies cleanly with no modifications. No significant
refactoring conflicts in this area of 6.18.43.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent fix in this tree. Commit d462c8e89e84 is not
in 6.18.43.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem / Criticality
**Record:** **drivers/pci** — CORE subsystem. PCI PM affects virtually
all systems.

### Step 7.2: Activity
**Record:** Actively maintained; recent PM fix 382895a288515 already
backported to this tree.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Systems with PCI devices that are driverless at suspend time
(never probed, intentionally unbound, or drivers without PM ops) that
later get a driver bound after resume.

### Step 8.2: Trigger Conditions
**Record:** System suspend (S2RAM) → resume → driver bind. Uncommon but
realistic for manual sysfs bind/unbind workflows and devices without in-
tree drivers. Not security-relevant; requires suspend cycle.

### Step 8.3: Failure Mode Severity
**Record:** Device fails to power up / probe after resume (stale D0
cache). **Severity: MEDIUM-HIGH** for affected users (hardware non-
functional), but not a kernel crash, deadlock, or data corruption.

### Step 8.4: Risk-Benefit
**Record:** **Benefit:** MEDIUM — fixes latent PM bug for driverless
devices; improves cache accuracy between unbind and suspend. **Risk:**
VERY LOW — 10-line change, maintainer-reviewed, net deletion of code.
**Ratio:** Favorable.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes real PCI PM cache bug for driverless devices on S2RAM suspend
  (same failure class as bugzilla #6024)
- Stops incorrect premature UNKNOWN at unbind while hardware is still D0
- Tiny, surgical, PCI maintainer + AMD reviewed
- Applies cleanly to 6.18.43
- Aligns suspend path with existing hibernate path behavior

**AGAINST backport:**
- No explicit user bug report or syzbot hit
- Failure is device malfunction, not kernel oops/panic
- Described primarily as “consistency” in commit message
- No stable nomination in review thread

**Unresolved:** None material to the decision.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — minimal diff, maintainer-
   reviewed, corner-case review done
2. Fixes a real bug affecting users? **PASS** — stale power-state cache
   prevents device power-up after suspend+bind
3. Important issue? **PASS (moderate)** — device non-functionality after
   suspend, same class as historical PCI PM bug
4. Small and contained? **PASS** — 1 file, 10 lines
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception Categories
**Record:** None (not a quirk, device ID, DT, or build fix).

### Step 9.4: Problem Summary for Stable Users

This commit fixes a gap in PCI core suspend handling: devices without a
driver (or without PM callbacks) never had their cached power state
invalidated before sleep, while bound devices did. After suspend/resume,
if the BIOS changes the hardware power state, the kernel can believe the
device is still in D0 and skip the transition back to D0 when a driver
is later bound — leaving hardware dead. The patch also stops marking the
cache as UNKNOWN at unbind time when hardware is still in D0, deferring
invalidation to `pci_pm_suspend_noirq()` where bound devices already do
it.

For Linux 6.18.43, the buggy code is present, prerequisites exist, and
the patch applies cleanly with very low risk.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message and
  kernel.org (d462c8e89e84)
- [Phase 1] Confirmed no Reported-by/syzbot/Fixes:/Cc: stable tags
- [Phase 2] Diff analysis: 2 insertions, 8 deletions in `pci-driver.c`;
  two functions modified
- [Phase 2] Read `__pci_set_power_state()` early-return at line 1545 in
  `pci.c`
- [Phase 3] `git describe HEAD` → v6.18.43; Makefile VERSION 6.18.43
- [Phase 3] `git show 2449e06a5696` — original unbind UNKNOWN logic and
  bugzilla #6024 context
- [Phase 3] `git blame` lines 493–498 — unbind UNKNOWN code present
- [Phase 3] Confirmed `pci_pm_set_unknown_state()` at line 606 in local
  tree
- [Phase 4] `b4 dig -c d462c8e89e84` — found lore thread URL
- [Phase 4] `b4 dig -w` — reviewers/maintainers CC'd
- [Phase 4] Downloaded mbox: Bjorn applied, Mario Reviewed-by, no stable
  nomination
- [Phase 4] lore.kernel.org direct fetch blocked (403/bot protection)
- [Phase 5] Traced `pci_pm_suspend_noirq` `!pm` → `goto Fixup` at line
  874 (buggy)
- [Phase 5] Confirmed `pci_pm_freeze_noirq` already sets UNKNOWN at line
  1098
- [Phase 6] Buggy code at lines 497–498 and 874 confirmed in 6.18.43
- [Phase 6] `git apply --check` on upstream patch — applies cleanly
- [Phase 6] Commit d462c8e89e84 not in 6.18.43 tree
- [Phase 8] Failure mode: stale D0 → device won't power up on driver
  bind; severity MEDIUM-HIGH for affected cases

**YES**The background searches finished and line up with the earlier
analysis:

- **Local tree (6.18.43):** The fix is **not** present. The buggy paths
  are still there — `PCI_UNKNOWN` is set on unbind, and the `!pm` branch
  in `pci_pm_suspend_noirq()` still skips `pci_pm_set_unknown_state()`.
- **Mainline (kernel.org):** The commit is **d462c8e89e84** (“PCI: Stop
  setting cached power state to 'unknown' on unbind”), merged April 27,
  2026 via the `pci/pm` branch.

That confirms the patch is a valid backport candidate for this tree and
applies cleanly. **Verdict remains YES.**

 drivers/pci/pci-driver.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index f9ead94d5ebb6..1219f39b1c69b 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -490,13 +490,6 @@ static void pci_device_remove(struct device *dev)
 	/* Undo the runtime PM settings in local_pci_probe() */
 	pm_runtime_put_sync(dev);
 
-	/*
-	 * If the device is still on, set the power state as "unknown",
-	 * since it might change by the next time we load the driver.
-	 */
-	if (pci_dev->current_state == PCI_D0)
-		pci_dev->current_state = PCI_UNKNOWN;
-
 	/*
 	 * We would love to complain here if pci_dev->is_enabled is set, that
 	 * the driver should have called pci_disable_device(), but the
@@ -871,7 +864,7 @@ static int pci_pm_suspend_noirq(struct device *dev)
 
 	if (!pm) {
 		pci_save_state(pci_dev);
-		goto Fixup;
+		goto set_unknown;
 	}
 
 	if (pm->suspend_noirq) {
@@ -923,6 +916,7 @@ static int pci_pm_suspend_noirq(struct device *dev)
 		goto Fixup;
 	}
 
+set_unknown:
 	pci_pm_set_unknown_state(pci_dev);
 
 	/*
-- 
2.53.0

