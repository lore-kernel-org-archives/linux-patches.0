Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB5057983D;
	Mon, 31 Aug 2026 13:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184161; cv=none; b=iA1jnzGyaSdCrykNbZS3FPzLRgAKIdXcdBp3O+UNLvq/sTYDnuUXQPRM+X0P+ejvAWTzISOy9vz9JGEXo3n48fkekxDBY4yNJIPdDIP1DH+cpKvtNa5jdCmMCUYBdsyv+2kdEx7M3wu6lrMu3U8StRDl8PpETV2Ms0ZNRRk34MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184161; c=relaxed/simple;
	bh=Xswt+y1hLefFnxkk2F+3xP6YV6N12Vs7Vsbu/twIh/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CQvlAMIf+Z5UAQ7s2DW6j3rjZ5ivNLbJ3t/jtKg9WtGadptATkU3d/LHzMCMe4Zz0yXxEXDVAUAcvD9B3WXauVb0wYF4WHO+dR9JeSZwl1dlzQhFc6r1j7LwgNgoNATlPmi0BTt2k5myPy4irpnsQmNiwCSuBRfI8jvosotnNQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PKAyjcyw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PKAyjcyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F5E1F00A3E;
	Mon, 31 Aug 2026 13:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184158;
	bh=VfJs/Gcp0CX9jHDu0u3nFy+bIdQiOz97/siV7vNDj2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PKAyjcywnLwT/1XdXrwLO2nMhtWa0SMeHbyFxXqAp9VBHyqr6eKrC8iAXqxkwJYdK
	 MNZ40YjFMFOikwUN+ivOjTJjbJ9DNqHbmDigqw48ghHBDFwcNzx1cPH4TSNYPXOAFC
	 Tc8WVx57q1e8oq/6eUgRcwvvwGWGR18mNkYbIkEtQVVcZYNhwFWJZugNL5tKrEB98R
	 9pmZEDMkNlZs9ff4RF1q4NzvjKS4NsZeDeErslAkxoZHCnMfi1m2dUrmEAS1BrqG5P
	 HG7Aqlg4JaEyGBK30LFuLySKYAuRk9//ZBIM0rIhvPNvwKlvbxX46knurAxcfAimPL
	 g7hM8sbepL9NQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen Pei <cp0613@linux.alibaba.com>,
	Alison Schofield <alison.schofield@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ACPI: scan: Honor _DEP for ACPI0016 PCI/CXL host bridge
Date: Mon, 31 Aug 2026 09:29:14 -0400
Message-ID: <20260831133314.4125787-526-sashal@kernel.org>
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

From: Chen Pei <cp0613@linux.alibaba.com>

[ Upstream commit bf5418a5fe63f35da35941ae896d5df121d95ffc ]

CXL root devices (ACPI0017) declare _DEP on their parent ACPI0016
PCI/CXL host bridge so that cxl_acpi probes only after acpi_pci_root
has attached the PCI root and registered it for acpi_pci_find_root().
However, acpi_dev_ready_for_enumeration() only consults dep_unmet
when the supplier's HID is on acpi_honor_dep_ids[]; otherwise the
dependency is silently ignored.

Without honoring the dependency, cxl_acpi can probe before the PCI
root is ready. The resulting CXL topology is broken: decoder targets
read as 0 and no port/endpoint devices appear under
/sys/bus/cxl/devices/.

Add ACPI0016 to acpi_honor_dep_ids[] so the _DEP declared by ACPI0017
is enforced. This relies on the preceding patch ("ACPI: PCI: clear
_DEP dependencies after PCI root bridge attach"), which releases the
dependency once the PCI root is fully enumerated; the two patches
must be applied together.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260526025118.38935-3-cp0613@linux.alibaba.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ACPI: scan: Honor _DEP for ACPI0016 PCI/CXL
host bridge

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, `make kernelversion`
= 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ACPI: scan]` `[Honor]` — Enforce ACPI `_DEP` dependency
for ACPI0016 (CXL/PCIe host bridge) so ACPI0017 (CXL root) consumers
wait for PCI root attach.

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Fixes: | None |
| Reported-by: | None |
| Tested-by: | Alison Schofield \<alison.schofield@intel.com\> |
| Reviewed-by: | Alison Schofield \<alison.schofield@intel.com\> |
| Link: |
https://patch.msgid.link/20260526025118.38935-3-cp0613@linux.alibaba.com
|
| Signed-off-by: | Chen Pei, Rafael J. Wysocki |

**Notable:** Intel CXL maintainer tested and reviewed. No syzbot. No
explicit `Cc: stable`.

### Step 1.3: Body analysis
**Record:**
- **Bug:** ACPI0017 (CXL root) declares `_DEP` on parent ACPI0016, but
  `acpi_dev_ready_for_enumeration()` ignores it because ACPI0016 is not
  in `acpi_honor_dep_ids[]`.
- **Symptom:** `cxl_acpi` probes before `acpi_pci_root` registers the
  PCI root → `acpi_pci_find_root()` returns NULL → broken CXL topology
  (decoder targets = 0, no devices under `/sys/bus/cxl/devices/`).
- **Root cause:** `_DEP` silently ignored for ACPI0016 suppliers.
- **Dependency:** Must be applied with preceding patch "ACPI: PCI: clear
  _DEP dependencies after PCI root bridge attach" (upstream
  `3a59c3b772e5d`).
- **Version info:** None explicit; cover letter says x86 is usually
  masked by link order; RISC-V is affected.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit, well-described functional bug fix
disguised as a one-line allowlist addition.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/acpi/scan.c` (+1 line)
- **Functions:** None modified; only `acpi_honor_dep_ids[]` data changed
- **Scope:** Single-file, surgical (1 insertion)

### Step 2.2: Code flow change
**Record:**
- **Before:** When ACPI0017 declares `_DEP` on ACPI0016,
  `acpi_scan_add_dep()` sets `dep->honor_dep = false` (ACPI0016 not in
  list) → `acpi_dev_ready_for_enumeration()` never blocks on `dep_unmet`
  → CXL root probes early.
- **After:** ACPI0016 in honor list → `honor_dep = true` → consumer
  ACPI0017 blocked until supplier clears dependency.
- **Path affected:** ACPI device enumeration / attach path in
  `acpi_bus_check_add()` via `acpi_dev_ready_for_enumeration()`.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / correctness — probe ordering / dependency
  enforcement
- **Mechanism:** ACPI `_DEP` declared in firmware is parsed but not
  enforced unless supplier HID is on `acpi_honor_dep_ids[]`. Early
  `cxl_acpi_probe()` calls `to_cxl_host_bridge()` →
  `acpi_pci_find_root()` fails → host bridges skipped silently.

### Step 2.4: Fix quality
**Record:**
- **Quality:** Obviously correct; mirrors existing entries (PNP0C0F,
  RSCV*, INTC*).
- **Regression risk:** Applying **this patch alone** without the
  prerequisite would permanently block ACPI0017 enumeration (confirmed
  in lore review by Alison Schofield). Both patches must ship together.
- **Risk of combined series:** Very low — follows `pci_link.c` / `ec.c`
  pattern already in tree.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `acpi_honor_dep_ids[]` introduced by `9d9bcae47fd5a` (2021,
INT3472 camera PMIC deps). PNP0C0F added by `2cb9155d116c4` (2024,
pci_link dep series). ACPI0016 handling in `pci_root.c` since
`241d26bc26add` (2022). CXL ACPI root since `4812be97c015b`. Bug has
been latent since honor-list mechanism existed without ACPI0016 entry.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Related pending stable commits on `autosel` branch:
- `b52e0117014b6` — ACPI: PCI: Clear _DEP dependencies after PCI root
  bridge attach (prerequisite)
- `82dbacca5220e` — this commit (upstream `bf5418a5fe63f`)

Neither is in current HEAD (`6.18.44`). Part of a 2-patch series (v1,
May 26 2026).

### Step 3.4: Author context
**Record:** Chen Pei (Alibaba). Series reviewed/tested by Alison
Schofield (Intel CXL maintainer) and Reviewed-by Dave Jiang on lore
thread.

### Step 3.5: Dependencies
**Record:** **Hard dependency** on patch 1
(`acpi_dev_clear_dependencies()` in `acpi_pci_root_add()`). Prerequisite
not in tree. Both patches apply cleanly (`git apply --check` passed).
Standalone application of this commit alone is harmful.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c bf5418a5fe63f` → https://patch.msgid.link/20260526025118.38
  935-3-cp0613@linux.alibaba.com
- Series v1, 2 patches, May 26 2026
- Cover letter explains twofold root cause and mandatory pairing

### Step 4.2: Reviewers
**Record:** CC'd: rafael@kernel.org, bhelgaas@google.com,
djbw@kernel.org, linux-cxl@, linux-acpi@, linux-pci@. Alison Schofield:
Tested-by + Reviewed-by for series. Dave Jiang: Reviewed-by.

### Step 4.3: Bug report
**Record:** No external bugzilla/syzbot. Cover letter documents
reproducible failure: decoder targets = 0, empty
`/sys/bus/cxl/devices/`. Trigger on RISC-V where `acpi_pci_root` vs
`cxl_acpi` link order is not guaranteed.

### Step 4.4: Series context
**Record:** 2-patch series; both required. Applying only patch 2 "would
prevent cxl_acpi from ever probing on ACPI0016 systems" (Alison
Schofield review in mbox).

### Step 4.5: Stable list history
**Record:** No stable@ discussion found in mbox thread. Not a negative
signal per instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `acpi_honor_dep_ids[]` (data), consumed by
`acpi_scan_add_dep()`, `acpi_scan_dep_init()`,
`acpi_dev_ready_for_enumeration()`.

### Step 5.2: Callers
**Record:**
- `acpi_dev_ready_for_enumeration()` called from `acpi_bus_check_add()`
  (scan.c:2288) — core ACPI enumeration path; also `i2c-core-acpi.c`.
- `cxl_acpi_probe()` (drivers/cxl/acpi.c) depends on
  `acpi_pci_find_root()` via `to_cxl_host_bridge()` and
  `add_host_bridge_dport()`.

### Step 5.3: Callees
**Record:** Honor flag flows to `dep->honor_dep` →
`adev->flags.honor_deps` → checked in
`acpi_dev_ready_for_enumeration()`. Clearing via
`acpi_dev_clear_dependencies()` (prerequisite patch).

### Step 5.4: Reachability
**Record:** Triggered at boot during ACPI enumeration on systems with
ACPI0016 + ACPI0017 in DSDT. Affects `CONFIG_CXL_BUS` platforms.
Userspace cannot directly trigger; firmware-defined topology. Common on
CXL-capable servers, especially RISC-V.

### Step 5.5: Similar patterns
**Record:** Identical pattern to PNP0C0F (`2cb9155d116c4`): honor
supplier in list + `acpi_dev_clear_dependencies()` after probe.
Precedent already in 6.18.44.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **YES.** `drivers/acpi/scan.c` lines 857–868 —
`acpi_honor_dep_ids[]` lacks ACPI0016. `drivers/cxl/acpi.c` has ACPI0017
probe path. `drivers/acpi/pci_root.c` handles ACPI0016 but does not call
`acpi_dev_clear_dependencies()`. Full buggy state confirmed in 6.18.44.

### Step 6.2: Backport complications
**Record:** Clean apply for both patches (`git apply --check` exit 0).
No conflicts expected. Minor context: line after PNP0C0F entry.

### Step 6.3: Related fixes already present?
**Record:** Prerequisite infrastructure exists
(`acpi_dev_clear_dependencies`, honor_dep mechanism, pci_link
clear_deps). Neither fix from this series is in HEAD. No duplicate fix
found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **IMPORTANT** — ACPI core enumeration + CXL driver. Not
universal, but critical for CXL memory users on affected platforms.

### Step 7.2: Activity
**Record:** ACPI scan and CXL actively maintained in 6.18.y (recent
commits: `19b3691ec9402`, `7f0a53c2b94ca` on scan.c; multiple CXL
commits).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** CXL-capable systems with ACPI0016 host bridges and ACPI0017
root devices — primarily non-x86 (RISC-V called out), but any platform
where probe order differs from x86 link order.

### Step 8.2: Trigger conditions
**Record:** Boot-time ACPI enumeration when ACPI0017 `_DEP` points to
ACPI0016 and `cxl_acpi` probes before `acpi_pci_root` completes. Non-
deterministic on RISC-V; masked on typical x86 by built-in link order.

### Step 8.3: Failure mode severity
**Record:** Complete CXL enumeration failure — no port/endpoint devices,
decoder targets = 0. **Severity: HIGH** for affected CXL users (hardware
non-functional); **MEDIUM** overall (platform-specific, x86 often
unaffected). Not a crash/oops, but total loss of CXL functionality.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected CXL platforms — restores working CXL
  topology
- **Risk:** VERY LOW for combined 2-patch series (5 lines total,
  established pattern)
- **Ratio:** Strongly favorable when both patches applied together

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real, reproducible hardware enablement bug on CXL/ACPI platforms
- Intel CXL maintainer tested and reviewed
- Minimal, obviously correct change (1 line)
- All infrastructure present in 6.18.44
- Applies cleanly; direct precedent (PNP0C0F/pci_link series in tree)
- Prerequisite patch equally small and follows existing
  `ec.c`/`pci_link.c` pattern

**AGAINST backport:**
- Requires paired prerequisite commit (cannot apply alone)
- Bug masked on most x86 systems
- Very new (upstream June 2026, not yet in 6.18.44)
- Niche hardware population (CXL + ACPI0016/0017)

**Unresolved:** No production deployment data beyond Intel testing.

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — 1-line allowlist;
Tested-by/Reviewed-by Intel CXL maintainer |
| 2. Fixes real bug affecting users? | **PASS** — CXL devices missing on
affected platforms |
| 3. Important issue? | **PASS** — complete CXL enumeration failure
(HIGH for affected users) |
| 4. Small and contained? | **PASS** — 1 line (+ 4 lines prerequisite) |
| 5. No new features/APIs? | **PASS** — enforcement of existing ACPI
`_DEP` mechanism |
| 6. Can apply to local tree? | **PASS** — both patches apply cleanly;
prerequisite must accompany |

### Step 9.3: Exception categories
**Record:** Hardware enablement / probe-order fix for existing CXL ACPI
driver — analogous to USB/PCI quirks and prior PNP0C0F `_DEP` fix.

### Step 9.4: Decision rationale

This commit fixes a genuine ACPI probe-ordering bug that leaves CXL
hardware completely non-functional on platforms (notably RISC-V) where
`cxl_acpi` can run before `acpi_pci_root` finishes. The change is
minimal, follows an established in-tree pattern, and has maintainer
review and testing.

**Critical operational note:** This commit MUST be backported together
with its prerequisite (`ACPI: PCI: Clear _DEP dependencies after PCI
root bridge attach`, upstream `3a59c3b772e5d`). Applying this patch
alone would block `cxl_acpi` from ever probing on ACPI0016 systems, as
explicitly warned in the lore review.

For the 6.18.44 tree, where the buggy code is present and CXL ACPI
support is fully integrated, backporting both patches of this series is
appropriate.

---

## Verification

- [Phase 1] Parsed subject, tags; found Tested-by/Reviewed-by Alison
  Schofield, Link to patch series
- [Phase 1] Cover letter describes broken CXL topology, decoder targets
  = 0
- [Phase 2] Diff: +1 line to `acpi_honor_dep_ids[]` in
  `drivers/acpi/scan.c`
- [Phase 2] Read `acpi_dev_ready_for_enumeration()` at scan.c:2470–2476
  — honors `dep_unmet` only when `honor_deps` set
- [Phase 2] Read `acpi_scan_add_dep()` at scan.c:2035–2036 — sets
  `honor_dep` from list
- [Phase 2] Read `to_cxl_host_bridge()` at cxl/acpi.c:523–533 — requires
  `acpi_pci_find_root()`
- [Phase 3] `git describe HEAD` → v6.18.44
- [Phase 3] `acpi_honor_dep_ids` mechanism from `9d9bcae47fd5a`, in tree
- [Phase 3] ACPI0016 in `pci_root.c` from `241d26bc26add`, in tree
- [Phase 3] CXL ACPI0017 driver from `4812be97c015b`, in tree
- [Phase 3] Commit `bf5418a5fe63f` NOT in HEAD; prerequisite
  `3a59c3b772e5d` NOT in HEAD
- [Phase 3] Both on `autosel` branch as `82dbacca5220e` and
  `b52e0117014b6`
- [Phase 4] `b4 dig -c bf5418a5fe63f` → lore URL; v1 2-patch series
- [Phase 4] `b4 dig -w` → CC'd rafael, bhelgaas, djbw, linux-cxl, linux-
  acpi, linux-pci
- [Phase 4] mbox: Alison Schofield Tested-by/Reviewed-by; warns patch 2
  alone blocks cxl_acpi
- [Phase 4] mbox: RISC-V probe-order issue documented; x86 usually
  masked
- [Phase 5] `acpi_dev_ready_for_enumeration` callers: scan.c:2288,
  i2c-core-acpi.c:155
- [Phase 5] `pci_link.c:751` has `acpi_dev_clear_dependencies()` —
  precedent confirmed
- [Phase 6] Read scan.c:857–868 — ACPI0016 absent from honor list in
  6.18.44
- [Phase 6] Read pci_root.c:760–762 — no `acpi_dev_clear_dependencies()`
  call
- [Phase 6] `git apply --check` for both patches → exit 0 (clean apply)
- [Phase 7] CXL Kconfig exists at `drivers/cxl/Kconfig` (CONFIG_CXL_BUS)
- [Phase 8] Failure mode: complete CXL enumeration failure, not kernel
  crash

**YES**The background searches finished and line up with the earlier
analysis:

- **Git history grep** for ACPI0016-related commits in `drivers/acpi/`
  only turned up the older CXL host-bridge work (`241d26bc26add` — CXL
  `_OSC` handling). Neither of the two `_DEP` fixes showed up in that
  narrow search because they aren’t in the current `6.18.44` HEAD yet.
- **`autosel` branch search** found both patches from the series:
  - `b52e0117014b6` — ACPI: PCI: Clear _DEP dependencies after PCI root
    bridge attach (prerequisite)
  - `82dbacca5220e` — ACPI: scan: Honor _DEP for ACPI0016 PCI/CXL host
    bridge (the commit under review)

That confirms the verdict: **YES**, but only as a pair — the
prerequisite must be backported together with this one-patch change to
`acpi_honor_dep_ids[]`.

 drivers/acpi/scan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 16704c2a730c0..a1c8609185d07 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -865,6 +865,7 @@ static const char * const acpi_honor_dep_ids[] = {
 	"RSCV0005", /* RISC-V SBI MPXY MBOX */
 	"RSCV0006", /* RISC-V RPMI SYSMSI */
 	"PNP0C0F",  /* PCI Link Device */
+	"ACPI0016", /* CXL/PCIe host bridge: CXL root (ACPI0017) depends on PCI root attach */
 	NULL
 };
 
-- 
2.53.0

