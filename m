Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F8C57F1D4;
	Mon, 19 Oct 2026 13:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418377; cv=none; b=tL6R65icECMcusUe8qHc+fsgPa12SjSpgMzrvd0TyKQjR5aW68Vycx+Qr7Z+LLJjkJdse60yJ2xoEnT2m1BHIivcDzw0aIiqSAem6GMr3HiOdIJjlSdqMu+xl6i0NlTWqTWMhaN/fMWA0NhYIjE2MGRdSJpDaLTAgiF44UnrMCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418377; c=relaxed/simple;
	bh=zdUu7Pa3R0nWdibcX3fSzDt30RkviElr22Mu3trSmI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pmxlsgsT52AN8FAJrjkdLn50xZChM1R112pEH8obcxh8AsIGmbIMD7ctMru6qccXepH2Yt85QdqzI+hJnc8QQB3B6TVFKwTj2X5g0OTWGvnMkgj0v6nzghbGYY9Grp0ZbBTqInY/O7orJHcNHRtVUomvDYfVG3O2AySx7JeBULE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JPnRF1GP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JPnRF1GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721321F000C6;
	Mon, 19 Oct 2026 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418374;
	bh=sfRI21tM8GKpi9JyhhzyNsGEjmrs1KBd1sUu9/RDHzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JPnRF1GPTi8HdVOF0Cx9fNWKGXzN5EqkEHPW7gN5SrVoRY3FaB9NGmS2fIaMQd1Dp
	 oz3lkdx+LauwRnDyEaRi/udi6T8sPMUzfI5hmAEcJB+MgKIGt+DLgnkvGrKJ0g0O/t
	 JuU/Eg4AQsT1YygrEDUD15CCIAi2XgUZcIMA8sJXDFAUTZir7Og16V0AOqMu8o/CZH
	 v5lYIwipQAExavi7WlQnU5AMfhz0dutmKx41pJktMJBUXfQaG2KOPV9l6xwfPVyG96
	 EC2wPK7gh76pJi/am9FLV7/Vc3SM3jP+4GPFsv3GZEzIrcJtld5v0XufHVnmmfRmEb
	 5CGBerXRMb6fw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brian Norris <briannorris@chromium.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] PCI/portdrv: Allow probing even without child services
Date: Mon, 19 Oct 2026 09:48:14 -0400
Message-ID: <20261019135441.1420968-203-sashal@kernel.org>
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

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 834171efeefffb1a0f2136f32e76669bbc11db86 ]

The PCIe port driver fails to probe if it finds no child services,
presumably under the assumption that the driver is not useful in that case.
However, the driver *can* still be useful for power management support --
namely, it still configures the port for runtime PM / D3, which may be
important for allowing a bridge to enter low power modes.

Thus, allow probe to succeed even if no IRQs and no child services are
available. This also mirrors existing behavior for ports that don't support
any portdrv services (PCIe hotplug, AER, DPC, PME, bwctrl), where we'd also
probe successfully.

This change is a bit more important after commit f5cd8a929c82 ("PCI: dwc:
Remove MSI/MSIX capability for Root Port if iMSI-RX is used as MSI
controller"), because it's common for some DWC-based systems to:

  1. have only the "aer" and "pcie_pme" port services available and

  2. not define legacy INTx interrupts properly in their device tree.

After commit f5cd8a929c82, such systems may fail pcie_init_service_irqs()
and so exit with -ENODEV.

Link: https://lore.kernel.org/all/nyada24tqwlkzdceyoxbzitzygvp4elvj5oajnqdwb33xkcdwk@76vnrx45fsfd/
Signed-off-by: Brian Norris <briannorris@chromium.org>
[bhelgaas: reorder pcie_port_device_register() decls per Lukas]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Link: https://patch.msgid.link/20260722160942.v4.1.I5fd5d83f518681b3949d8ab2f16ba8244fd3e774@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to judge this against 7.3-rc4: the probe-fail path, the
DWC IRQ regression, and the mailing-list review are all in this tree.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[PCI/portdrv] [Allow] [succeed probe when no child port
services can be registered, so runtime PM/D3 still works]`

- Subsystem: `PCI/portdrv` (PCIe port bus driver)
- Action verb: **Allow** — relaxing an overly strict probe failure, not
  adding an API
- Claimed intent: keep `pcieport` bound even with no
  AER/PME/hotplug/DPC/bwctrl children

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Link: https://lore.kernel.org/all/nyada24tqwlkzdceyoxbzitzygvp4elvj5o
  ajnqdwb33xkcdwk@76vnrx45fsfd/` — DWC iMSI-RX discussion where the
  probe-fail side effect was first identified
- `Signed-off-by: Brian Norris <briannorris@chromium.org>` (author)
- `[bhelgaas: reorder pcie_port_device_register() decls per Lukas]`
- `Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>` (PCI maintainer)
- `Reviewed-by: Lukas Wunner <lukas@wunner.de>` (PCI PM reviewer)
- `Link: https://patch.msgid.link/20260722160942.v4.1.I5fd5d83f518681b39
  49d8ab2f16ba8244fd3e774@changeid` (v4 submission)

Absent (expected): `Fixes:`, `Cc: stable@vger.kernel.org`, `Reported-
by:`, `Tested-by:`

Notable: maintainer SOB + expert Reviewed-by; no syzbot; Chrome OS
author implies real hardware.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `pcie_port_device_register()` returns an error (`-ENODEV` or
  IRQ-init errno) if no child services register, so `pcieport` does not
  bind.
- **Symptom:** Root/downstream ports never get portdrv runtime PM
  (`pm_runtime_allow` / autosuspend), so the bridge may never enter D3.
- **Root cause:** Probe treated “no child services” as “driver is
  useless.” That is wrong: PM lives on the parent `pcieport` driver, not
  on AER/PME children. It is also inconsistent with the existing `if
  (!capabilities) return 0` path.
- **Version info:** Called out as more important after `f5cd8a929c82`
  (DWC: strip RP MSI/MSI-X when iMSI-RX is the MSI controller). On DWC
  boards with only AER+PME and no working INTx in DT,
  `pcie_init_service_irqs()` fails and the whole port driver exits.
- **Author’s mechanism:** Always succeed after `pci_enable_device()`;
  drop failed services from the capability mask; if none remain, free
  IRQ vectors and `pci_clear_master()`, but do not
  `pci_disable_device()` / return error.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Yes, a real probe/PM failure framed as “allow.”** It is not
style cleanup. “Allow probing” here means “stop returning `-ENODEV` when
the driver still has a job (runtime PM).” That is a functional fix,
especially as a follow-on to `f5cd8a929c82`.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/pci/pcie/portdrv.c` — **+14 / −14** (net 0)
- Function: `pcie_port_device_register()` only
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record (before → after), all in `pcie_port_device_register()`:

1. IRQ init fails and no hotplug left: `goto error_disable` →
   `pci_disable_device()` + return error → **`goto out`, still return
   0**.
2. Service loop: count successes in `nr_service`; if zero, `goto
   error_cleanup_irqs` → **on `pcie_device_init()` failure, clear that
   service bit; never fail the whole register**.
3. Success path: return 0 with bus-master + IRQs kept even if unused →
   **`out:` if `!capabilities`, `pci_free_irq_vectors()` +
   `pci_clear_master()`**.
4. Error path `pci_disable_device()` + `return status` **removed**.
   Probe now fails only if `pci_enable_device()` fails.
   `pcie_portdrv_remove()` still calls `pci_disable_device()`, so
   enable/disable stays balanced when probe succeeds.

Normal path with working IRQs and at least one service: unchanged (still
`return 0` with master + IRQs).

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** logic/correctness (wrong probe failure) + hardware
  workaround for DWC platforms that lose INTx after MSI cap removal
- **Mechanism:** “no child devices” was treated as fatal; that skipped
  `pcie_portdrv_probe()`’s runtime-PM setup (`pci_bridge_d3_possible()`
  → autosuspend/`pm_runtime_allow`). After `f5cd8a929c82`, that path is
  hit on common DWC RPs that only advertise AER/PME and have no usable
  INTx.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** High after v4. v1 ignored `pcie_device_init()` errors and
  leaked IRQ vectors; v4 checks the return, clears failed bits, and
  frees unused vectors. Matches the long-standing `!capabilities`
  success path.
- **Regression risk:** Low–medium, contained.
  - Lukas noted they no longer `pci_disable_device()` immediately on
    IRQ-init failure; that is intentional (device stays bound). Remove
    still disables.
  - Enabling runtime D3 without a PME *service* does not newly break PME
    IRQs: those IRQs already failed, so PME children never bound before
    either.
  - LS7A bus-master caveat was called out as **pre-existing**, not
    introduced here.
- No public API / data-structure change.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Fail-if-zero-services (`status = -ENODEV; nr_service`) introduced in
  **`40717c39b1e6c`** (“PCI: portdrv: minor cleanup…”, 2009).
- IRQ-fail → `error_disable` from **`075b7d363c675`** (2022 revert of
  “Do not setup IRQs if there are no users”).
- `if (!capabilities) return 0` from **`eca67315e0e0d`** (2011).
- Buggy policy has been in-tree for many years; the **acute trigger** is
  `f5cd8a929c82` (2025-12-18, in **v7.0**).

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No `Fixes:` tag.** Related commit `f5cd8a929c82` **is** an
ancestor of this HEAD (`git merge-base --is-ancestor` exit 0). It is in
v7.0, not v6.19.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record (recent `portdrv.c`):
- `834171efeefff` — this commit (in **v7.3-rc1**)
- Later: `97ca178c899d0` PCI/DPC change — unrelated
- No follow-up fix series from Brian Norris on `drivers/pci/`
- **Standalone**, not patch N/M of a required series (subject is `[PATCH
  v4]`, single patch)

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Brian Norris is a Chromium OS PCI contributor (Tested-
by/Reviewed-by on the DWC MSI patch). Not the PCI maintainer; **Bjorn
Helgaas applied it**, **Lukas Wunner reviewed it**. Only this portdrv
commit from him in the recent window.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: **None required.** The patch only rearranges existing
`pci_enable_device` / `pcie_init_service_irqs` / `pcie_device_init` /
`pci_free_irq_vectors` / `pci_clear_master`. It does not depend on
applying `f5cd8a929c82` first; that commit only raises the importance.
**Can apply standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **v4 (applied):** https://patch.msgid.link/20260722160942.v4.1.I5fd5d8
  3f518681b3949d8ab2f16ba8244fd3e774@changeid
- Revisions: **v1 2026-01-09 → v2 2026-02-09 → v3 2026-05-08 → v4
  2026-07-22** (applied version is latest)
- Bjorn: “Applied to pci/portdrv for v7.3”
- **No NAKs.** Review iterated on IRQ leak, `pcie_device_init()` errors,
  and `pci_set_master()` timing (v3 deferred master; v4 reverted that
  after MSI-drop concern)
- **No reviewer Cc: stable** found
- `b4 dig` lore fetch returned 503; discussion recovered from
  openwall/LKML/gnuweeb mirrors

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: To/Cc included **Bjorn Helgaas**, **Lukas Wunner**, **Manivannan
Sadhasivam**, `linux-pci@`. Right maintainers. Lukas **Reviewed-by** on
v4 (Christmas-tree nit; Bjorn reordered decls).

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: Origin is review of DWC patch 3/5 (`f5cd8a929c82`). Brian
Norris: platforms without INTx make `pcie_init_service_irqs()` fail,
**“the port won’t be configured for runtime PM and won’t ever enter
D3.”** Mani: **“Sounds logical”** because register already returns 0
when there are no port capabilities. **Severity:** functional PM/probe
failure on DWC/Chromium test devices, not a panic.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Standalone. `b4 dig -a` also listed Qiang Yu’s DWC 5-patch
series because of the lore Link; that is the *motivation*, not a
prerequisite series for this diff.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: **No stable@ discussion found** for this subject. Not a negative
signal (no automatic `Cc: stable`).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `pcie_port_device_register()` modified. Related:
`pcie_init_service_irqs()`, `pcie_device_init()`,
`pcie_portdrv_probe()`, `pcie_portdrv_remove()`.

**Step 5.2: TRACE CALLERS**

Record:
- `pcie_port_device_register()` ← only `pcie_portdrv_probe()`
- `pcie_portdrv_probe()` is `.probe` of `pcie_portdriver`
  (`"pcieport"`), `device_initcall`
- Context: **PCI enumeration of every Root Port / Upstream / Downstream
  / RCEC** — common boot path, not an obscure ioctl
- `semcode` not available; callers confirmed with `git grep`

**Step 5.3: TRACE CALLEES**

Record: `pci_enable_device`, `get_port_device_capability`,
`pci_set_master`, `pcie_init_service_irqs` (`pci_alloc_irq_vectors` MSI
then INTx), `pcie_device_init` (`device_register` of service devices),
`pci_free_irq_vectors`, `pci_clear_master`. After success, probe sets
DPM flags and runtime autosuspend when `pci_bridge_d3_possible()`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Boot/hotplug enumeration → `pcieport` probe → register services
→ PM setup. **Reachable without userspace.** Trigger on DWC: iMSI-RX MSI
controller + missing/broken INTx in DT → `pci_alloc_irq_vectors(...,
PCI_IRQ_INTX)` fails → previously whole probe failed.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same file already succeeds when `get_port_device_capability()`
is 0. This change makes the IRQ-fail / all-`pcie_device_init`-fail paths
match that. No sibling drivers with the same `nr_service` pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Local tree: **`v7.3-rc4-27-gf0100363d8c37`**, `VERSION=7 PATCHLEVEL=3
  SUBLEVEL=0 EXTRAVERSION=-rc4` (`make kernelversion` → `7.3.0-rc4`)
- Current `pcie_port_device_register()` **already contains this fix**
  (landed **v7.3-rc1**, `834171efeefff`; ancestor of HEAD)
- Pre-fix failure policy existed here until 7.3-rc1; **`f5cd8a929c82` is
  in this tree (v7.0)**
- Buggy path: `drivers/pci/pcie/portdrv.c` `pcie_port_device_register()`
  — fail when IRQ init fails and no HP, or when `nr_service == 0`

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** on this tree’s pre-fix `portdrv.c` (single
function, same structure). No conflicting later edits that would block
it. `kzalloc_obj` in `pcie_device_init` is pre-existing, not part of
this diff.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: This *is* the fix. No alternate/earlier version of the same
change. No follow-up reverting or tightening it.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM**

Record: **PCI Express port driver** (`drivers/pci/pcie/portdrv.c`).
**IMPORTANT** — not mm/core, but every PCIe Root Port uses `pcieport`
for AER/PME/hotplug **and** bridge runtime D3.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Actively maintained (Helgaas). Recent portdrv work besides this:
DPC on downstream ports, bus-type conversions. Mature driver; this is a
policy fix, not churn in new code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver-specific / platform-specific.** All systems with PCIe
ports run this probe; the *bug* bites when services exist on paper but
IRQs cannot be allocated — especially **DWC iMSI-RX hosts without
working INTx** (Qualcomm/Chrome OS class). Also any port whose child
`device_register` all fail.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- Trigger: port has AER/PME/etc. capability bits, but
  `pcie_init_service_irqs()` fails (no MSI after cap strip, INTx
  missing), **or** every `pcie_device_init()` fails
- Common on affected DWC boards at **every boot**
- Not a userspace-triggerable security path; enumeration-time
- Not a race

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:
- **Failure:** `pcieport` probe fails (`-ENODEV` / IRQ errno). No
  portdrv runtime PM. Bridges stay out of D3 (higher power). AER/PME
  children would not have IRQs anyway, so those services were already
  dead; the extra damage was losing **parent** PM.
- **Severity: MEDIUM** (functional probe/PM failure, not
  oops/corruption/deadlock). Still user-visible on real hardware, and a
  **regression relative to `f5cd8a929c82`** which this tree has.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** Restores `pcieport` bind + bridge D3/runtime PM on
  affected DWC/embedded systems; removes a 15-year inconsistent failure.
  **Medium–high** for those platforms.
- **Risk:** ~14-line change in one probe function; hot path is unchanged
  when services work. Reviewed through v4. **Low.**
- **Ratio:** Benefit outweighs risk on this tree because
  **`f5cd8a929c82` is present**.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real probe failure, not theoretical; Chrome OS/DWC hardware, described
  on list
- Regression amplifier `f5cd8a929c82` **is in this 7.3 tree**
- Small, contained, obviously correct after v4
- PCI maintainer applied; Lukas Wunner Reviewed-by
- Aligns IRQ-fail path with existing `!capabilities` success
- No new API; `pcie_portdrv_remove()` still `pci_disable_device()`
- Frees leftover IRQ vectors (addresses Lukas’s SG2042-style vector hog)

**AGAINST:**
- Not crash/UAF/corruption/deadlock
- Verb is “Allow” — policy change vs classic sanitizer bug
- No `Fixes:` / no stable nomination in review
- Lukas noted enable/disable lifetime questions (not a NAK)
- Missing INTx is also a DT/platform gap; this is a kernel workaround

**UNRESOLVED:**
- Full lore.kernel.org threads 503/403; used mirrors (verified author,
  v1–v4, reviews)
- Exact Chromebook/SoC model list beyond “current test devices” not in
  the patch

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — v4, Helgaas + Wunner,
   applied to 7.3
2. Fixes a real bug that affects users? **PASS** — portdrv fails to
   bind; no RP runtime D3 on DWC without INTx
3. Important issue? **PASS** (MEDIUM, but a **probe/PM regression**
   after a commit that is in this tree — driver never attaches)
4. Small and contained? **PASS** — 14/14 lines, one function
5. No new features or APIs? **PASS** — same driver, looser failure
   condition; no sysfs/module param
6. Can apply to the local tree? **PASS** — code and trigger both exist
   here; patch is the current function body

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk table/DT/build/doc exception. It is a
**driver probe/PM correctness fix** (related to a hardware IRQ-fallback
limitation).

**Step 9.4: DECISION**

This tree is **7.3-rc4**. It contains both the DWC MSI-cap removal that
makes `pcie_init_service_irqs()` fail on some RPs and the port driver
that used to treat that as a fatal probe error. The result is a real,
boot-time `pcieport` bind failure and missing bridge D3, not a cleanup.
The change is small, reviewed, and matches behavior the driver already
had when *no* services were advertised.

That meets stable criteria for **this** tree.

---

### What the commit solves (for this tree)

After `f5cd8a929c82` (in v7.0, present here), DWC root ports using iMSI-
RX lose MSI and must use INTx. If DT does not provide INTx, IRQ init
fails. Old `pcie_port_device_register()` then disabled the device and
returned an error, so **`pcieport` never bound** and **runtime PM/D3 was
never enabled** — even though child AER/PME devices were impossible
anyway without IRQs. The parent driver is still the one that programs
autosuspend. Succeeding probe (and cleaning unused IRQs/master) restores
that.

### Risk vs benefit

Low risk (probe error path only when services cannot start; working
AER/PME/hotplug path unchanged) vs medium benefit (ports actually enter
low power; driver attaches). Reviewed caveats do not block it.

### Concerns

None that block a backport here: no missing prerequisites, no series
dependency, no API change. Lukas’s `pci_disable_device` note is handled
by `pcie_portdrv_remove()`.

---

### Verification

- **[Phase 1]** Parsed tags: two `Link:`s, SOB Norris + Helgaas,
  Reviewed-by Wunner; no Fixes/stable/syzbot
- **[Phase 1]** Body: probe `-ENODEV` vs PM; cites `f5cd8a929c82`
- **[Phase 2]** Diff: +14/−14 in `pcie_port_device_register()`; drop
  `error_disable`/`nr_service`; always return 0 after enable
- **[Phase 2]** Confirmed `pcie_portdrv_probe()` PM setup only runs if
  register succeeds (lines 701–720)
- **[Phase 2]** Confirmed `pcie_portdrv_remove()` still
  `pci_disable_device()` (line 736)
- **[Phase 3]** `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`;
  Makefile 7.3.0-rc4
- **[Phase 3]** `git show 834171efeefff` — candidate SHA
  `834171efeefffb1a0f2136f32e76669bbc11db86`
- **[Phase 3]** Blame parent: `40717c39b1e6c` (2009 nr_service),
  `075b7d363c675` (IRQ fail path), `eca67315e0e0d` (no-caps return 0)
- **[Phase 3]** `git merge-base --is-ancestor f5cd8a929c82 HEAD` → 0
  (present); not in v6.19; in v7.0
- **[Phase 3]** `git merge-base --is-ancestor 834171efeefff HEAD` → 0;
  `git describe --contains` → `v7.3-rc1~71^2~30^2`
- **[Phase 3]** No later Norris PCI follow-ups; standalone
- **[Phase 4]** `b4 dig -c 834171efeefff` — v4 msgid; lore 503
- **[Phase 4]** `b4 dig -a` — v1..v4 of this patch (plus unrelated DWC
  series via Link)
- **[Phase 4]** Openwall: Bjorn applied for v7.3; Lukas v4 Reviewed-by +
  LS7A/enable caveats
- **[Phase 4]** gnuweeb: original DWC thread; Norris reports D3 loss;
  Mani agrees success-with-no-services
- **[Phase 4]** WebSearch stable@ — no hits for this subject
- **[Phase 5]** Callers: only `pcie_portdrv_probe` → `pcieport` PCI
  driver; semcode unavailable
- **[Phase 5]** `pcie_init_service_irqs()` INTx fallback returns
  `-ENODEV` if `pci_alloc_irq_vectors(..., PCI_IRQ_INTX)` fails
- **[Phase 6]** Buggy fail path existed until 7.3-rc1; trigger commit in
  this tree
- **[Phase 8]** Failure mode: probe fail + no bridge D3, severity
  MEDIUM; regression given `f5cd8a929c82`
- **UNVERIFIED:** live lore.kernel.org HTML (403/503); exact product
  names beyond “test devices”

**YES**

 drivers/pci/pcie/portdrv.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/pcie/portdrv.c b/drivers/pci/pcie/portdrv.c
index a0991da482136..91d1482221a8c 100644
--- a/drivers/pci/pcie/portdrv.c
+++ b/drivers/pci/pcie/portdrv.c
@@ -330,8 +330,8 @@ static int pcie_device_init(struct pci_dev *pdev, int service, int irq)
  */
 static int pcie_port_device_register(struct pci_dev *dev)
 {
-	int status, capabilities, i, nr_service;
 	int irqs[PCIE_PORT_DEVICE_MAXSERVICES];
+	int status, capabilities, i;
 
 	/* Enable PCI Express port device */
 	status = pci_enable_device(dev);
@@ -355,29 +355,29 @@ static int pcie_port_device_register(struct pci_dev *dev)
 	if (status) {
 		capabilities &= PCIE_PORT_SERVICE_HP;
 		if (!capabilities)
-			goto error_disable;
+			goto out;
 	}
 
 	/* Allocate child services if any */
-	status = -ENODEV;
-	nr_service = 0;
 	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
 		int service = 1 << i;
 		if (!(capabilities & service))
 			continue;
-		if (!pcie_device_init(dev, service, irqs[i]))
-			nr_service++;
+		if (pcie_device_init(dev, service, irqs[i]))
+			capabilities &= ~service;
 	}
-	if (!nr_service)
-		goto error_cleanup_irqs;
 
-	return 0;
+out:
+	/*
+	 * With no child services, we shouldn't need bus mastering or any IRQ
+	 * vectors we allocated.
+	 */
+	if (!capabilities) {
+		pci_free_irq_vectors(dev);
+		pci_clear_master(dev);
+	}
 
-error_cleanup_irqs:
-	pci_free_irq_vectors(dev);
-error_disable:
-	pci_disable_device(dev);
-	return status;
+	return 0;
 }
 
 typedef int (*pcie_callback_t)(struct pcie_device *);
-- 
2.53.0

