Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230B7455184;
	Mon, 31 Aug 2026 13:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183791; cv=none; b=FOXobOWT3+Q/r5/NpINNHqBNL2v/T7CFCvEI3i+7gSi0SThIgoiftf5eP8eH1vvzjxQw5XVuZY6myeMkJUGMt6kNqdGrD39NQWYr4RSwBQSAcp9Se+Iu+Sj5fQrHln19wwWiPFu2PA+8PB9H4n0R2sWbBxUT781xVuvvl1fRUGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183791; c=relaxed/simple;
	bh=pL1Yc3xTvlbnNo3FX0+ig4mMRcemswBveKhGXi5hKWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GO0cNLaBRQJAc1USmJVR/H6sZDnmnIBw6TWDGIZUt/syCj8/3H0TTUUBWhUzzeS3bm+JiN7OZjOVRq+ItloEfRLXYUHbBQtO+hJxWfrAofs2ZkDWGNpMgVAfYZxq9Wu7GC0Z+wh2k8gDTMD3uV45ATp8iPEI3/AWDpk5kAZxm58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CCBWdQ62; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CCBWdQ62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDF71F00ADB;
	Mon, 31 Aug 2026 13:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183787;
	bh=tiyjUwbVJ1UGixWRWWEAuiMC2zC1WC4mW4hbnJB74h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCBWdQ62/Q40XO4AMRcsKMF97oVQ6MQLTI+AwlTewlSy2oqvvEANVQnR1Ah9ZaTBP
	 51WEZmVXUyiAGfrI+y1EhUwkQv2ybfep8NHaqH7Q7g0XWPHeU2h/tNlhOpQTHNS67r
	 tKOLHN9Ye0p6Fgx6orU7e2TN1qVOmqEjDHaqa6vm0v9JxxKdF9W0NFsAjFiABwHj5r
	 JeO1rSRxL6DLGQ79LmrDxt82NBEMnSPh4JFY+mggUjB5ExdOBtZ5FVHlHJp4MkV6r3
	 A7pkg2U46VHS060fga+o5Cwgo2k4vMgcaM0NMj1bmR1gbcA58ly8FJ1BiM0a8xE6sS
	 JHktqf/QcjrIQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bjorn Helgaas <helgaas@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] PCI: Wait for device readiness after D3hot -> D0uninitialized transition
Date: Mon, 31 Aug 2026 09:25:32 -0400
Message-ID: <20260831133314.4125787-304-sashal@kernel.org>
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

From: Bjorn Helgaas <helgaas@kernel.org>

[ Upstream commit 41167a1e98536b4baf0846fd259c8124bd1c4e1b ]

For a device that advertises No_Soft_Reset == 0, a transition from D3hot to
D0uninitialized is a soft reset, and the resulting internal device state is
undefined.

Per PCIe r7.0, sec 2.3.1, a transition from D3hot to D0uninitialized
mandates a minimum 10 ms delay before accessing the device. Following this
delay, the device is permitted to respond to initial configuration requests
with a Request Retry Status (RRS) completion status if it needs more time
to initialize.

Call pci_dev_wait() after pci_power_up() performs a D3hot->D0uninitialized
transition to ensure the device is ready to accept config accesses, as is
done after the similar transition in pci_pm_reset().

If the device is already ready, this is essentially a no-op except for one
additional config read.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Link: https://patch.msgid.link/20260518191220.636213-3-bhelgaas@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: PCI D3hot→D0 Readiness Wait

**Local tree:** `v6.18.43` (Linux 6.18.43)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[PCI]` `[Wait]` — After a D3hot→D0uninitialized power
transition, wait for the device to become configuration-ready before
proceeding.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Bjorn Helgaas `<bhelgaas@google.com>` (author, PCI
  maintainer)
- **Reviewed-by:** Rafael J. Wysocki `<rafael@kernel.org>` (PM
  maintainer)
- **Link:**
  https://patch.msgid.link/20260518191220.636213-3-bhelgaas@google.com
- No Fixes:, Reported-by:, Tested-by:, Cc: stable, or syzbot tags
- Notable: Reviewed by the ACPI/PM maintainer; part of a 2-patch v2
  series (patch 2/2)

### Step 1.3: Body Analysis
**Record:**
- **Bug:** After D3hot→D0uninitialized (soft reset when `No_Soft_Reset
  == 0`), the kernel waits the mandatory 10 ms (`pci_dev_d3_sleep`) but
  does not poll until the device stops returning Request Retry Status
  (RRS) or error responses.
- **Symptom:** Premature config-space access after power-up; BAR restore
  / state reads may see `~0` (`PCI_ERROR_RESPONSE`) or RRS, causing
  resume/probe failures.
- **Root cause:** `pci_power_up()` lacked the `pci_dev_wait()` call that
  `pci_pm_reset()` already performs after the same transition.
- **Spec reference:** PCIe r7.0 §2.3.1.

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit, well-described correctness bug fix
for a spec-mandated timing gap, not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/pci/pci.c` (+22 / -2 lines in series; this commit
  ~20 net lines)
- **Function modified:** `pci_power_up()`
- **Scope:** Single-file, surgical fix in one function

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (comment block):** Documents platform vs. PM-capability
  power-up paths.
- **Hunk 2 (D3hot branch):**
  - **Before:** `pci_dev_d3_sleep(dev);` then immediately mark device
    D0.
  - **After:** `pci_dev_d3_sleep(dev);` then, if soft-reset applies
    (`!(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET)`), call `pci_dev_wait()`. On
    failure, set `current_state = PCI_D3cold` and return `-EIO`.
- **Affected path:** D3hot→D0 power-up error/normal resume path inside
  `pci_power_up()`.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic / spec-compliance / timing correctness fix
- **Mechanism:** After mandatory 10 ms delay, device may still respond
  with RRS or synthesized `~0` on config reads. Without polling via
  `pci_dev_wait()`, subsequent `pci_restore_bars()` /
  `pci_restore_state()` can operate on garbage. The fix mirrors the
  existing `pci_pm_reset()` pattern at line 4456.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** High — reuses proven `pci_dev_wait()` infrastructure
  already used for FLR, AF_FLR, and `pci_pm_reset()`.
- **Regression risk:** Very low — if device is already ready, one extra
  config read (author's own statement). Worst case adds up to 60 s wait
  on genuinely broken hardware, then clean `-EIO` failure instead of
  proceeding with bad state.
- **No API changes, no new symbols.**

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Lines 1349–1352 in this tree (`pci_dev_d3_sleep` only, no
wait) are present in current `pci_power_up()`. `pci_dev_wait()` exists
at line 1209 and is already called from `pci_pm_reset()` at line 4456.
This tree's git history is shallow (single upstream-marker commit per
file), so exact introduction SHA of the missing wait cannot be
determined locally.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related Changes
**Record:** Part of v2 2-patch series by Bjorn Helgaas (May 2026):
1. `PCI: Log device readiness timeouts as errors` — changes `pci_warn` →
   `pci_err` in `pci_dev_wait()` timeout path
2. **This commit** — adds `pci_dev_wait()` to `pci_power_up()`

Patch 2 is standalone; patch 1 is a logging improvement only.

### Step 3.4: Author Context
**Record:** Bjorn Helgaas is the PCI subsystem maintainer. Rafael
Wysocki (PM maintainer) reviewed. Author applied series to `pci/reset`
for v7.2 per mailing list follow-up.

### Step 3.5: Dependencies
**Record:** No code dependencies on patch 1/2. Requires only existing
`pci_dev_wait()`, `pci_dev_d3_sleep()`, `PCIE_RESET_READY_POLL_MS`, and
`PCI_PM_CTRL_NO_SOFT_RESET` — all present in this 6.18.43 tree. **Can
apply standalone: YES.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- Series cover: https://lkml.iu.edu/2605.2/03907.html
- This patch (v2 2/2): https://lkml.iu.edu/2605.2/03911.html
- v1 was a single-patch submission (May 14, 2026); v2 added error
  handling and companion logging patch
- No NAKs found; maintainer applied to `pci/reset` for v7.2
- No explicit "Cc: stable" nomination found in available threads

### Step 4.2: Reviewers
**Record:** CC list included Rafael Wysocki, Lukas Wunner, Mika
Westerberg, Alex Williamson, Mario Limonciello, and other PCI/PM
experts. Rafael Wysocki provided Reviewed-by.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Bug identified via
spec compliance analysis and inconsistency with `pci_pm_reset()`
behavior.

### Step 4.4: Series Context
**Record:** 2-patch series; only patch 2/2 is under review. Patch 1 is
optional for functionality.

### Step 4.5: Stable List History
**Record:** No stable-list discussion found for this specific fix.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `pci_power_up()` (modified), `pci_dev_wait()` (called),
`pci_set_full_power_state()` (caller),
`pci_pm_power_up_and_verify_state()` (direct caller)

### Step 5.2: Callers of `pci_power_up()`
**Record:**
1. `pci_set_full_power_state()` → `__pci_set_power_state()` when `state
   == PCI_D0` — **system/runtime resume path** (`pci_set_power_state()`
   is widely used across drivers)
2. `pci_pm_power_up_and_verify_state()` → called from:
   - `pci_pm_init()` — boot enumeration (devices left in D3hot by BIOS)
   - `pci_pm_default_resume_early()` — suspend resume
   - `pci_pm_thaw_noirq()` — hibernate thaw

### Step 5.3: Callees
**Record:** `platform_pci_set_power_state()`,
`pci_read/write_config_word()`, `pci_dev_d3_sleep()`, `pci_dev_wait()` —
all standard PCI PM primitives.

### Step 5.4: Reachability
**Record:** Triggered on every D3hot→D0 transition through
`pci_power_up()` for devices without `No_Soft_Reset`. This is a
**common** path during suspend/resume, hibernate, and boot. Userspace
can indirectly trigger via runtime PM (`pci_set_power_state`).

### Step 5.5: Similar Patterns
**Record:** `pci_pm_reset()` at lines 4448–4456 already does
`pci_dev_d3_sleep()` + `pci_dev_wait()` after D3hot→D0. This commit
closes the same gap in `pci_power_up()`.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.43)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Current `pci_power_up()` at lines 1349–1350:

```1349:1352:drivers/pci/pci.c
        if (state == PCI_D3hot)
                pci_dev_d3_sleep(dev);
        else if (state == PCI_D2)
                udelay(PCI_PM_D2_DELAY);
```

No `pci_dev_wait()` call. `pci_dev_wait()` and `pci_pm_reset()`'s
correct usage both exist in this tree.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** No refactoring conflicts visible.
`pci_power_up()` structure matches the patch base (`5a9af0bb2c71` index
in patch matches current code layout).

### Step 6.3: Related Fixes Already Present?
**Record:** No — `git log --grep` found no prior "device readiness" or
equivalent fix in this tree. Patch 1 (warn→err) also not present (line
1261 still uses `pci_warn`).

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **PCI core** (`drivers/pci/pci.c`) — **CORE** subsystem.
Affects all PCI/PCIe devices on resume and boot.

### Step 7.2: Activity Level
**Record:** Mature, actively maintained subsystem. PM paths are long-
standing; this is a gap in an established code path, not new subsystem
code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** All systems with PCI devices that:
- Support native PM (`pm_cap` present)
- Have `No_Soft_Reset == 0` (soft reset on D3hot→D0)
- Need more than 10 ms to become configuration-ready after soft reset

This includes many laptops (BIOS leaves devices in D3hot at boot, per
existing comment at lines 1402–1405) and suspend/resume scenarios.

### Step 8.2: Trigger Conditions
**Record:**
- **When:** D3hot→D0 power-up via `pci_power_up()` with soft-reset
  semantics
- **Likelihood:** Intermittent — depends on device initialization time;
  more likely on slower devices or under load
- **Userspace trigger:** Indirect via runtime PM resume; unprivileged
  users can trigger device PM on assigned devices

### Step 8.3: Failure Mode Severity
**Record:**
- **Failure mode:** Failed resume, incorrect BAR restoration, driver
  probe failure, possible oops if driver proceeds with bad config
- **Severity:** **HIGH** for affected devices (resume failure renders
  hardware unusable until reboot); **MEDIUM** population-wide (only
  soft-reset-capable devices that are slow to initialize)

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — fixes real resume/boot failures on affected
  hardware; aligns with PCIe spec and existing `pci_pm_reset()` behavior
- **Risk:** VERY LOW — minimal diff, proven helper, no-op on ready
  devices
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes a real spec-compliance bug in a core resume path
- Can cause suspend/resume and boot failures on affected PCI devices
- Small, surgical, obviously correct (mirrors `pci_pm_reset()`)
- PCI maintainer authorship + PM maintainer review
- All required infrastructure exists in 6.18.43
- Buggy code confirmed present in this tree

**AGAINST backport:**
- No user bug reports or syzbot reproduction (theoretical/spec-driven
  fix)
- Part of 2-patch series (patch 1 is logging-only, not required)
- Adds latency (up to 60 s) only on genuinely broken/unresponsive
  devices

**Unresolved:** Exact kernel version when `pci_power_up()` was
introduced without the wait (shallow git history in this stable tree).

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mirrors existing
   `pci_pm_reset()` pattern; reviewed by PM maintainer
2. Fixes a real bug affecting users? **PASS** — spec-mandated readiness
   gap on D3hot→D0 resume
3. Important issue? **PASS** — resume/probe failures (HIGH for affected
   devices)
4. Small and contained? **PASS** — ~20 lines, one function, one file
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code and all dependencies
   present in 6.18.43

### Step 9.3: Exception Categories
**Record:** None (not a quirk/DT/build/doc fix — a core correctness bug
fix).

### Step 9.4: Decision Rationale

This commit closes a long-standing gap where `pci_power_up()` — used on
boot, suspend resume, and hibernate thaw — did not wait for device
readiness after a D3hot→D0 soft reset, even though `pci_pm_reset()`
already did. The fix is minimal, uses existing infrastructure, has
maintainer review, and addresses a real failure mode (premature config
access after power-up) that can break device resume on affected
hardware. The risk of backporting is negligible since ready devices pay
only one extra config read.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 1]** Confirmed Reviewed-by: Rafael Wysocki; no
  syzbot/Reported-by
- **[Phase 2]** Read current `pci_power_up()` at lines 1303–1360:
  missing `pci_dev_wait()` confirmed
- **[Phase 2]** Read `pci_pm_reset()` at lines 4429–4457: has
  `pci_dev_wait()` after D3hot→D0
- **[Phase 2]** Read `pci_dev_wait()` at lines 1209–1290: polling logic
  with 60 s timeout confirmed
- **[Phase 3]** `git describe HEAD`: v6.18.43-1-gc7f0dac02d232
- **[Phase 3]** `git blame -L 1340,1365 drivers/pci/pci.c`: D3hot branch
  lacks wait
- **[Phase 3]** `git log --grep`: no prior fix for this issue in tree
- **[Phase 4]** Web search: found v2 series cover at
  lkml.iu.edu/2605.2/03907.html
- **[Phase 4]** Web search: found patch 2/2 at
  lkml.iu.edu/2605.2/03911.html — diff matches provided commit
- **[Phase 4]** Web search: found patch 1/2 at
  lkml.iu.edu/2605.2/03901.html — logging only, not a prerequisite
- **[Phase 4]** Web search: maintainer applied to pci/reset for v7.2
  (openwall list, May 22 2026)
- **[Phase 4]** lore.kernel.org direct fetch: 403 Forbidden (used
  lkml.iu.edu mirror instead)
- **[Phase 4]** b4 dig: no commit hash available in tree (commit not yet
  applied); could not run `b4 dig -c`
- **[Phase 5]** `grep pci_power_up`: callers in
  `pci_set_full_power_state()`, `pci_pm_power_up_and_verify_state()`
- **[Phase 5]** Read `pci-driver.c` lines 541–572, 1103–1118:
  resume/thaw paths call `pci_pm_power_up_and_verify_state()`
- **[Phase 5]** Read `pci.c` line 3196: boot path `pci_pm_init()` calls
  `pci_pm_power_up_and_verify_state()`
- **[Phase 6]** Confirmed `PCI_PM_CTRL_NO_SOFT_RESET`,
  `PCIE_RESET_READY_POLL_MS`, `pci_dev_d3_sleep()` all exist
- **[Phase 6]** Line 1261 still has `pci_warn` (patch 1 not applied) —
  patch 2 applies independently
- **[Phase 8]** Assessed failure mode: resume/probe failure on slow-to-
  initialize soft-reset devices

**YES**

 drivers/pci/pci.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 439045ab69319..c533111186f70 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1305,7 +1305,18 @@ int pci_power_up(struct pci_dev *dev)
 	bool need_restore;
 	pci_power_t state;
 	u16 pmcsr;
+	int ret;
 
+	/*
+	 * When setting power state to D0, platform_pci_set_power_state()
+	 * ensures main power is on.  If it puts the device in D0, it also
+	 * completes any required delays after the transition; if it leaves
+	 * the device in D1, D2, or D3hot, we use the PM Capability to
+	 * transition to D0.
+	 *
+	 * In all cases, the device is either Configuration-Ready or
+	 * inaccessible upon return.
+	 */
 	platform_pci_set_power_state(dev, PCI_D0);
 
 	if (!dev->pm_cap) {
@@ -1346,10 +1357,19 @@ int pci_power_up(struct pci_dev *dev)
 	pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, 0);
 
 	/* Mandatory transition delays; see PCI PM 1.2. */
-	if (state == PCI_D3hot)
+	if (state == PCI_D3hot) {
 		pci_dev_d3_sleep(dev);
-	else if (state == PCI_D2)
+		if (!(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET)) {
+			ret = pci_dev_wait(dev, "power up D3hot->D0uninitialized",
+					   PCIE_RESET_READY_POLL_MS);
+			if (ret) {
+				dev->current_state = PCI_D3cold;
+				return -EIO;
+			}
+		}
+	} else if (state == PCI_D2) {
 		udelay(PCI_PM_D2_DELAY);
+	}
 
 end:
 	dev->current_state = PCI_D0;
-- 
2.53.0

