Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E015CDB61;
	Mon, 19 Oct 2026 14:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418475; cv=none; b=kTSci+y6GnS/qZ7WlZ+RqXzBgF8L9sfOvlmP3AGjqbGFplKG9eprbkzEpgd5sH5DrXk0k3wVDqt//XehL1JxF5fgtKTQDgIsShzKXAbgccqn9C32EhJe6aWsF38LE4VqjPw2M9KLySxqIBvX64lIpL1GM8iF6vNWiRUJ+05Ic3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418475; c=relaxed/simple;
	bh=m2IWMHyjga/ETqf9LajO6RZajKBzIVFyJukmVdyWobQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iK00+5+EHaCnEC8mj5aCWr3ohsMaAlVkVp8D/nIj2LX6plXO8tgYOl+n2pXOnEA2IzOkhkZDltmWeu7ogtrgVNrxHx6VyEDT4TBCFczrUO1aubbQ2CVkijmhk+MQB1VhBu7CumL3Ms0/4E6zHy0t6pKbi2xMHTi0Nuf+qPPNIiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rk579FSo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rk579FSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500BC1F000C7;
	Mon, 19 Oct 2026 14:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418473;
	bh=zAT/vqPrTnKluzUDLYA49M6qLx/XMcxvjF6X9vSlybg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rk579FSo4GQhON0xdqbu/iSBrb+CJXJUwOVf5l+RCRPP593tpBEqfGK8j0XfKrPoA
	 vmw4dWm1cMn1DcTy/dD+Gbr+A3lTIEFEv1jjOWb6a28+gvbWDtqUZl4Uq6Tf9iu2T2
	 geosC8fXVRui5Hy2EgQU+PuHBe9u8LsZ3N/xMYDRqNknord6yh4m2CZlV1yu375Xhe
	 YHgQr2HfXxEUtNPZSodYDD+bZJF2G1ECFsJw2B+lHe5THYnUIBAvHHRlL4Ot2yyUi7
	 COgQHx1TowaaexH8CO7xdazXcAJbecqVfnloN9s4u5gWEeGo8DBRczcbkQy9HO1gm4
	 V4bThF6sBd/pg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peixin Xie <peixin.xie@linux.spacemit.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ACPI: scan: Defer device power initialization
Date: Mon, 19 Oct 2026 09:49:24 -0400
Message-ID: <20261019135441.1420968-273-sashal@kernel.org>
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

From: Peixin Xie <peixin.xie@linux.spacemit.com>

[ Upstream commit dc948f8b384a516ac5c471eb9382959f838e02f4 ]

acpi_bus_get_power_flags() initializes the device power state while the
ACPI device object is being created, before checking whether the device
is ready for enumeration.

If enumeration is deferred, acpi_bus_attach() clears the initialized and
power_manageable flags. When the dependency is later satisfied,
acpi_bus_init_power() is called again and takes additional references to
the power resources used by the device. These references prevent the
resources from being turned off when the device enters D3.

This issue was reproduced on a SpacemiT K3 RISC-V Pico-ITX. The affected
device uses a power resource through _PR0 and has an automatically
derived dependency on its interrupt controller.

The initial power initialization acquires a power resource reference.
The device is then deferred, but that reference is not dropped. When
the dependency becomes available, power initialization acquires another
reference. Consequently, entering D3 only drops the reference count
from 2 to 1 and _OFF is not evaluated:

 [    0.314611] ACPI Debug:  "I2P2 _STA"
 [    0.318260] ACPI: \_SB_.I2P2: ACPI: PM: Power resource is on
 [    0.323998] ACPI: \_SB_.I2P2: New power resource
 [    0.382108] ACPI Debug:  "I2P2 _STA"
 [    0.478964] ACPI Debug:  "I2P2 _ON"
 [    0.482498] ACPI: \_SB_.I2P2: ACPI: PM: Power resource turned on
 [    0.488597] ACPI Debug:  "I2C2, PS0"
 [    0.863170] ACPI: \_SB_.I2P2: ACPI: PM: Power resource already on
 [    0.873686] ACPI Debug:  "I2C2, PS0"
 [    2.416055] ACPI Debug:  "I2C2, PS3"
 [    2.423397] ACPI: \_SB_.I2P2: ACPI: PM: Power resource still in use

To address this, remove the early acpi_bus_init_power() call and leave
regular ACPI device objects uninitialized until acpi_bus_attach() runs
after the device is ready for enumeration.

Power resource objects are initialized through acpi_add_power_resource()
and do not require the generic initialization in acpi_bus_attach(), so
mark them as initialized there.

After the change, device power state initialization is deferred until its
dependency is met. Since no reference is acquired before then, the power
resource left on by firmware is turned off as unused after the namespace
scan. Once the dependency is met, the resource is turned on once for the
device and is turned off normally when the device later enters D3:

 [    0.314628] ACPI Debug:  "I2P2 _STA"
 [    0.318277] ACPI: \_SB_.I2P2: ACPI: PM: Power resource is on
 [    0.324016] ACPI: \_SB_.I2P2: New power resource
 [    0.382118] ACPI Debug:  "I2P2 _STA"
 [    0.496116] ACPI: \_SB_.I2P2: ACPI: PM: Turning OFF
 [    0.501081] ACPI Debug:  "I2P2 _OFF"
 [    0.504705] ACPI: \_SB_.I2P2: ACPI: PM: Power resource turned off
 [    1.415899] ACPI Debug:  "I2P2 _ON"
 [    1.418866] ACPI: \_SB_.I2P2: ACPI: PM: Power resource turned on
 [    1.424947] ACPI Debug:  "I2C2, PS0"
 [    2.647655] ACPI Debug:  "I2C2, PS3"
 [    2.654856] ACPI Debug:  "I2P2 _OFF"
 [    2.654866] ACPI: \_SB_.I2P2: ACPI: PM: Power resource turned off

This also avoids powering up devices before their dependencies are
available.

Signed-off-by: Peixin Xie <peixin.xie@linux.spacemit.com>
[ rjw: Changelog edits ]
Link: https://patch.msgid.link/20260820-acpi-power-resource-ref-fix-v2-1-29818173ea13@linux.spacemit.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is 6.12.111. The buggy ACPI power-init path is present
here, so the rest of this is whether the leak is backport-worthy for
this checkout.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[ACPI: scan:] [Defer] [device power initialization]`
Subsystem ACPI scan/PM. “Defer” is a timing change that the body
presents as a leak fix, not a feature.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Peixin Xie \<peixin.xie@linux.spacemit.com\> (author)
- `[ rjw: Changelog edits ]` — ACPI maintainer edited the changelog
- Link: https://patch.msgid.link/20260820-acpi-power-resource-ref-
  fix-v2-1-29818173ea13@linux.spacemit.com
- Signed-off-by: Rafael J. Wysocki \<rafael.j.wysocki@intel.com\>
  (ACPI/PM maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable (absence is expected)
- Ignore any pipeline “Upstream commit” / Sasha Levin SOB if present

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: `acpi_bus_get_power_flags()` calls `acpi_bus_init_power()` while
  the ACPI device is created, before readiness for enumeration. If
  attach defers the device, it clears `initialized` and
  `power_manageable` without dropping power-resource refs. Later re-init
  takes a second ref. D3 then drops 2→1 and `_OFF` is never evaluated.
- Symptom: power resource “still in use”; device stays powered in D3.
  Reproduced on SpacemiT K3 RISC-V Pico-ITX (I2C with `_PR0`, auto-dep
  on interrupt controller). Logs show `_ON` twice, then `_PS3` without
  `_OFF`.
- Root cause: leaked power-resource `ref_count` across deferred
  enumeration.
- Fix: drop the early `acpi_bus_init_power()`; leave `initialized` false
  until `acpi_bus_attach()` after the device is ready; mark power-
  resource objects `initialized` in `acpi_add_power_resource()`. Side
  effect: firmware-on unused resources can be turned off after namespace
  scan, then turned on once when the dependency is met.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: This is an explicit bug fix (unbalanced power-resource refs),
not a disguised cleanup. The subject says “Defer” because that is the
mechanism.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `drivers/acpi/power.c`: +1 (`device->flags.initialized = true` in
  `acpi_add_power_resource()`)
- `drivers/acpi/scan.c`: −4 (remove `acpi_bus_init_power()` from
  `acpi_bus_get_power_flags()`; remove `initialized = true` from
  `acpi_init_device_object()`)
- Functions: `acpi_add_power_resource`, `acpi_bus_get_power_flags`,
  `acpi_init_device_object`
- Scope: single-subsystem, surgical (~5 lines)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Hunk 1 (`power.c`): power-resource objects skip generic attach init;
  they must still be marked initialized so later `acpi_bus_attach()`
  does not treat them as uninitialized ACPI devices.
- Hunk 2 (`acpi_bus_get_power_flags`): still discovers `_PRx`/`_PSx` and
  fills state lists, but no longer takes refs / evaluates `_ON` at
  object-creation time.
- Hunk 3 (`acpi_init_device_object`): `initialized` stays false
  (kzalloc-zeroed) until attach. Existing attach path already does:
  - not ready → leave uninitialized, clear `power_manageable`
  - ready && `!initialized` → `acpi_bus_init_power()` once, then set
    `initialized`

Before: init at create (ref=1) → defer (flags cleared, ref still 1) →
later init (ref=2) → D3 (ref=1, no `_OFF`).
After: no early ref → defer → later init (ref=1) → D3 (ref=0, `_OFF`).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: Reference-counting / resource leak (ACPI power-resource
`ref_count`, not kmalloc). `acpi_power_on_unlocked()` does
`ref_count++`; `acpi_power_off_unlocked()` only calls `_OFF` when count
hits 0. Extra init leaves a sticky ref so D3 never turns the resource
off. Category: logic/correctness + PM refcount.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct relative to the attach-time init path that has
existed since 2015 (`1b1f3e1699a988`). Minimal. Regression risk is the
global move of first `acpi_bus_init_power()` from add to attach for
every ACPI device, plus unused resources of deferred devices being
turned off after scan (existing DMI quirks already cover platforms that
cannot tolerate that). For devices ready immediately, attach still runs
in the same `acpi_bus_scan()` before driver probe, so common x86/ACPI
paths stay equivalent. Power-resource `initialized=true` is required so
walk-of-children attach does not mis-init those objects. Early devices
that skip `acpi_bus_attach()` (fixed power/sleep button, ECDT EC)
typically have no `_PR0`/`_PS0`; `acpi_device_enumerated()` was already
false because `visited` is unset — verified no change there.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Early `acpi_bus_init_power()` in `acpi_bus_get_power_flags`:
  `1b1f3e1699a988` (2015-01-05, “ACPI / PM: Fix PM initialization for
  devices that are not present”) — in this tree.
- `initialized = true` in `acpi_init_device_object`: `202317a573b20d`
  (2013-11-22) — in this tree.
- Attach-time re-init: same 2015 commit.
- The leak becomes reachable when enumeration is deferred *and* the
  device is still present (`acpi_dev_ready_for_enumeration()` can fail
  on `honor_deps && dep_unmet` while `acpi_device_is_present()` is
  true). Honor-deps: `9d9bcae47fd5a` (2021, INT3472). RISC-V PLIC/APLIC
  on the honor list: `15f210f43e95f` (2024-08-27) — ancestor of v6.12
  and of HEAD.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. The interaction is old init (2013–2015) plus
deferred enumeration (2021, much wider on RISC-V ACPI in 6.12).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `scan.c` work is honor-list and dep-scan
(`15f210f43e95f`, `b38c61f1f394d`, `0dae3d96ca011`). Recent `power.c`
work includes unused-resource DMI quirks (`d08fb559b4557`,
`9b04d99788cf4`). This patch is standalone, not “2/N”. v1 was a
different approach (forced D3cold on defer); v2 replaced it.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: No prior Peixin Xie ACPI commits in this tree. The design is
Rafael’s (v1 review), and he applied v2.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Uses existing `acpi_bus_attach()` uninitialized path.
`acpi_init_device_object()` callers in this tree are only
`acpi_add_single_object()` and `acpi_add_power_resource()`. No missing
helpers. Standalone; applies to this tree.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- v2 lore msgid: `20260820-acpi-power-resource-ref-
  fix-v2-1-29818173ea13@linux.spacemit.com`
- v1: `20260811-acpi-power-resource-ref-
  fix-v1-1-828f1c383831@linux.spacemit.com`
- v1: drop refs by `acpi_power_transition(..., D3_COLD)` on the not-
  ready path. Rafael: pointless to power up then immediately down; drop
  early `acpi_bus_init_power()` and init once when ready.
- Author tested that on SpacemiT K3; runtime suspend/resume balanced.
- Rafael then asked to clear `initialized` in
  `acpi_init_device_object()` and set it in `acpi_add_power_resource()`
  (exactly v2).
- v2 reply from Rafael: “Applied as 7.3-rc material, thanks!” No NAK. No
  reviewer Cc: stable.
- Base-commit on the patch: `d58772d8520c7ef247c4b95c9bd76d3a25da9ff5`
  (mainline-era, not this branch).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: To/Cc: Rafael J. Wysocki, Len Brown, Yixun Lan, linux-acpi,
linux-kernel, linux-riscv, spacemit. Maintainer designed and applied it.
No extra Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Hardware report from the author with
before/after ACPI Debug traces (I2C2/I2P2 in v2; USBD.PDPR in v1). Real-
world, not theoretical.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Single-patch series, v1→v2 only. No extra patches required for
the leak itself.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No stable@ discussion found for this msgid. Not a reason to
reject.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `acpi_bus_get_power_flags`, `acpi_init_device_object`,
`acpi_add_power_resource`. Callers of the removed init:
`acpi_bus_init_power` still from `acpi_bus_attach` and
`acpi_device_update_power`.

**Step 5.2: TRACE CALLERS**
Record:
- `acpi_bus_get_power_flags()` ← `acpi_add_single_object()` during
  namespace scan.
- `acpi_init_device_object()` ← `acpi_add_single_object()`,
  `acpi_add_power_resource()`.
- `acpi_bus_attach()` ← `acpi_bus_scan()` (pass 1),
  `acpi_scan_clear_dep_fn()` (deferred), hotplug attach.
- `acpi_scan_add_dep()` sets `honor_dep` when the supplier HID is in
  `acpi_honor_dep_ids` (PLIC `RSCV0001`, APLIC `RSCV0002`, INT3472,
  IVSC, PNP0C0F, ACPI0016, …). RISC-V `arch_acpi_add_auto_dep()` adds
  GSI/PLIC deps for devices with interrupts.

**Step 5.3: TRACE CALLEES**
Record: `acpi_bus_init_power()` → `acpi_device_get_power()` →
`acpi_power_on_resources()` → `acpi_power_on_list()` →
`acpi_power_on_unlocked()` (`ref_count++`, maybe `_ON`). End of
`acpi_scan_init()` calls `acpi_turn_off_unused_power_resources()` only
for `ref_count==0`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Boot ACPI scan, no userspace needed. On RISC-V ACPI, any GSI
consumer depending on PLIC/APLIC is deferred; if it also has `_PR0`, the
leak fires (I2C and USB in the reports). On x86, INT3472/IVSC camera
`_DEP` devices with power resources are the same class. Reachable on
real hardware in this tree.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same extra-ref pattern is unique to “init, then clear flags
without dropping refs.” Wakeup-resource refcount has had its own stable-
worthy fixes historically; this patch does not touch that.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes.
- Tree: `pending-6.12`, `git describe` `p-6.12-3-gc504cf0baa3d8`, `make
  kernelversion` **6.12.111**
- `drivers/acpi/scan.c:1160-1161` still calls `acpi_bus_init_power()`
  from `acpi_bus_get_power_flags()`
- `scan.c:1844` still sets `initialized = true` at object creation
- `scan.c:2298-2315` still clears flags on defer and re-inits if
  `!initialized`
- `power.c` `acpi_add_power_resource()` does **not** set `initialized`
- Subject not in `git log` on these files — not already applied
- RISC-V honor list + `arch_acpi_add_auto_dep()` are in this tree
  (`15f210f43e95f` is ancestor of v6.12)

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. The three contexts match. Mainline `kzalloc_obj` vs
this tree’s `kzalloc` is outside the hunk. Extra `strcpy` of name/class
in this tree is also outside the hunk.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No alternate fix. Unused-resource DMI quirks are unrelated (they
skip turning unused resources off).

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: ACPI scan + ACPI PM (`drivers/acpi/scan.c`,
`drivers/acpi/power.c`). IMPORTANT: not mm/scheduler, but ACPI device PM
on every ACPI platform. Broken D3/runtime-PM for deferred devices.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature core with ongoing honor-dep/RISC-V work in 6.11–6.12.
This is a bug in that shipped 6.12 behavior, not a new 7.3-only
subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Config/platform-specific, but not a toy driver. Trigger: ACPI
device with `_PR0`/`_PS0` power resources **and** deferred enumeration
(`honor_deps && dep_unmet`). Populations: RISC-V ACPI (PLIC/APLIC auto-
dep — 6.12 feature); Intel camera `_DEP` (INT3472/IVSC); PCI link / CXL
host-bridge honor list. Unaffected: devices enumerated immediately
(typical x86).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every boot on matching firmware. Not a race. Not unprivileged-
syscall. Common on RISC-V ACPI boards with powered I2C/USB; less common
on generic x86.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Power-resource ref leak → `_OFF` skipped → rails stay on in D3;
runtime suspend does not actually power the device. Not
oops/corruption/CVE. Severity **HIGH** for PM correctness and
battery/embedded power; **MEDIUM** as a generic “will this brick 6.12
laptops?” risk. Author’s logs match the code (`still in use` is the
`ref_count != 0` debug in `acpi_power_off_unlocked()`).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: HIGH for RISC-V ACPI 6.12 users and any honor-dep + `_PR0`
  device; restores D3/`_OFF` and avoids powering devices before deps
  exist.
- Risk: LOW. Five lines, maintainer-designed, uses the existing attach
  init path. Common (non-deferred) devices only shift init from add to
  attach in the same scan, before probe.
- Ratio: benefit > risk for this tree because 6.12 shipped RISC-V auto-
  deps that make the leak easy to hit.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, reproduced leak; D3 does not turn resources off
- Buggy code and RISC-V honor-dep trigger are in 6.12.111
- Small, obviously correct, standalone
- ACPI maintainer specified v2 and applied it
- Tested with before/after traces
- Applies cleanly here

AGAINST:
- Not crash/security/filesystem corruption
- Changes first power-init timing for all ACPI devices
- Unused resources of deferred devices may `_OFF` after scan (intended;
  DMI quirks exist for broken firmware)
- No Cc: stable (not a negative per rules)
- Relatively new mainline (7.3-rc, ~Aug 2026)

UNRESOLVED:
- Mainline SHA not in this checkout (cannot `merge-base` the upstream
  commit). Not needed: the diff matches local code.
- No evidence of a revert in the month after apply (lore v2 thread is
  apply-only).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — maintainer-designed;
   hardware logs.
2. Real bug that affects users? **PASS** — SpacemiT K3; any RISC-V ACPI
   `_PR0` + PLIC dep.
3. Important issue? **PASS** — sticky power resources break runtime
   D3/`_OFF`; serious PM bug, not a crash. Matches “etc.” for production
   PM.
4. Small and contained? **PASS** — 5 lines, two ACPI files.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — contexts match; bug exists
   here.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID/quirk/DT/build/docs add). Qualifies as a
normal bugfix.

**Step 9.4: MAKE YOUR DECISION**
This tree added RISC-V interrupt-controller honor deps. Combined with
early `acpi_bus_init_power()`, deferred present devices leak power-
resource refs and cannot leave D0 electrically. The fix is the attach-
time init path this tree already has, plus marking power-resource
objects initialized. That is appropriate for 6.12.y.

Verification:
- [Phase 1] Parsed tags: author SOB, Rafael SOB + changelog edits, lore
  Link; no Fixes/Cc:stable/syzbot
- [Phase 2] Diff: −4/+1; remove early init; delay `initialized`; set it
  in `acpi_add_power_resource()`
- [Phase 2] Confirmed `acpi_power_on_unlocked`/`acpi_power_off_unlocked`
  refcount vs “still in use” log
- [Phase 3] `git describe HEAD` / `make kernelversion`: p-6.12-3 /
  6.12.111
- [Phase 3] blame: early init `1b1f3e1699a988` (2015); `initialized`
  `202317a573b20d` (2013)
- [Phase 3] `git merge-base --is-ancestor 15f210f43e95f HEAD` and
  `v6.12`: YES (RISC-V honor list)
- [Phase 3] `git merge-base --is-ancestor 9d9bcae47fd5a HEAD`: YES
  (INT3472 honor)
- [Phase 3] `git log --grep="Defer device power initialization" --
  drivers/acpi/`: empty (not applied)
- [Phase 4] `b4 mbox` v2: Rafael “Applied as 7.3-rc material”
- [Phase 4] `b4 mbox` v1: Rafael requested this approach; author
  confirmed K3
- [Phase 5] callers: `acpi_add_single_object` → get_power_flags; attach
  re-init; RISC-V `arch_acpi_add_auto_dep` → `acpi_scan_add_dep` with
  PLIC/APLIC honor_dep
- [Phase 6] local `scan.c:1160` and `1844` still buggy; `power.c` lacks
  `initialized = true`
- [Phase 6] three hunks match this tree (clean apply)
- [Phase 8] failure: D3 does not `_OFF`; severity HIGH for PM, not oops
- UNVERIFIED: exact mainline SHA in torvalds.git (git.kernel.org HTML
  blocked); does not affect the local-tree decision

**YES**

 drivers/acpi/power.c | 1 +
 drivers/acpi/scan.c  | 4 ----
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 6d16740e1d70a..0d9c3fcf895ff 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -959,6 +959,7 @@ struct acpi_device *acpi_add_power_resource(acpi_handle handle)
 	strscpy(acpi_device_class(device), ACPI_POWER_CLASS);
 	device->power.state = ACPI_STATE_UNKNOWN;
 	device->flags.match_driver = true;
+	device->flags.initialized = true;
 
 	/* Evaluate the object to get the system level and resource order. */
 	status = acpi_evaluate_object(handle, NULL, NULL, &buffer);
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 7f9dd2704f638..e049fcfee2a84 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1144,9 +1144,6 @@ static void acpi_bus_get_power_flags(struct acpi_device *device)
 		if (!list_empty(&device->power.states[ACPI_STATE_D3_HOT].resources))
 			device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
 	}
-
-	if (acpi_bus_init_power(device))
-		device->flags.power_manageable = 0;
 }
 
 static void acpi_bus_get_flags(struct acpi_device *device)
@@ -1826,7 +1823,6 @@ void acpi_init_device_object(struct acpi_device *device, acpi_handle handle,
 	acpi_init_properties(device);
 	acpi_bus_get_flags(device);
 	device->flags.match_driver = false;
-	device->flags.initialized = true;
 	device->flags.enumeration_by_parent =
 		acpi_device_enumeration_by_parent(device);
 	acpi_device_clear_enumerated(device);
-- 
2.53.0

