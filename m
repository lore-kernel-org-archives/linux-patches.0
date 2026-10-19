Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B9B5D2A15;
	Mon, 19 Oct 2026 14:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418497; cv=none; b=EM3KGdSTvmZx50X1CVE66vdhYjmNoYqC8F/NYo3kg0cKRi1BH8JhFBiwVhtpZxIQdNhDpgEeeH1FAG15GDVlBG5t5x4UfQjJlqjyl9EgIH1UM7FYEAP5eYCAo8BxdDpJKnJ6LWSmPNZR8LXJMejWVhaq4I7GDW+QP1ymEPQjA0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418497; c=relaxed/simple;
	bh=RbSzruvk7tdPZGBe2uxzDrFkG4eYkkVPyWyLNyqEUfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s1NQI/EU+PHXIv8GDGkTkZuwC0PGpPAN6n/uiSXUjEev5fLF13oQGfhRyBD6k4IyvUcRpAl/wengjUB+NWFaU9SZheGql8jgAOYZH0rPWwZKJtGSJKXc4MNMl5lvxmfN5VNiyr1Wi+chuz6UACdR3pu6mKi0idClxKcslGfQvi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ku55ul+Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ku55ul+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF8A1F000C8;
	Mon, 19 Oct 2026 14:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418494;
	bh=C4uLmbh3UY4Wvc/ua3+aKR6tqdcVCGj3zhapadbwh/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ku55ul+YpKeAWoCfIDFM70b/xeErKDSm28cs/wmFhTJFW8SrrZKjSSKhNLC6CXIyz
	 HCep7TQ4FMHzMNr/4K9x8M0xohyn7+2TacrT1CzpcptxsLb1wQOUMprF6stpeOpL1q
	 LtuuQJ5yAJ38xrTldpPvocEGjo36MbD2v2ajeXx4y72r0o8chatabYxI99OpP4t5BE
	 Y/NRPGQPcnNsIO7FlmYXL6m4GxZ6WP/NVrm0RosmmWhk/LQsDNVHwkGxE53ndKKx3B
	 H9/1A5luRpI71nwXkwbFsQGl+hFn6aKbUXg2xfkQFTz/91atTISxrZ1G07I6M9WBL7
	 9uWMQAZmUaPCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ali Alaei <ali.alaei.tabatabaei@gmail.com>,
	Lin Mohan <linmhwork@outlook.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	nirmal.patel@linux.intel.com,
	lpieralisi@kernel.org,
	kwilczynski@kernel.org,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] PCI: vmd: Handle BUS_RESTRICT_CFG value 3 for Arrow Lake-HX
Date: Mon, 19 Oct 2026 09:49:39 -0400
Message-ID: <20261019135441.1420968-288-sashal@kernel.org>
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

From: Ali Alaei <ali.alaei.tabatabaei@gmail.com>

[ Upstream commit 72b32eccbcd591b9606edacf3bd7c455176d7660 ]

On Intel Arrow Lake-HX systems (e.g. Core Ultra 9 275HX on Acer Predator
PH16-73), the VMD controller reports BUS_RESTRICT_CFG = 3 in the VMCONFIG
register. The existing switch statement only handled values 0, 1, and 2,
causing vmd_get_bus_number_start() to return -ENODEV and aborting the
entire VMD probe. This leaves NVMe drives behind the VMD controller
invisible to the kernel.

Hardware registers (VMCAP/VMCONFIG at offsets 0x40/0x44):

  VMD 0000:00:0e.0 (8086:ad0b): VMCAP=0x000f, VMCONFIG=0x03b8
  BUS_RESTRICT_CFG(0x03b8) = (0x03b8 >> 8) & 0x3 = 3

Add cfg=3 as a fallthrough to cfg=2, setting busn_start=224, which is
the correct bus number base for this hardware.

Also add a PCI_POSSIBLE_ERROR() guard after reading VMCONFIG: a failed
config space read returns 0xFFFF, and BUS_RESTRICT_CFG(0xFFFF) = 3,
so without this guard a removed or errored device would falsely match
the new case 3 instead of being caught as an error.

Reported-by: Lin Mohan <linmhwork@outlook.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221137 # Arrow-Lake-S
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221136 # Arrow-Lake-S
Signed-off-by: Ali Alaei <ali.alaei.tabatabaei@gmail.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260628143450.92492-1-ali.alaei.tabatabaei@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3.0-rc4**. This commit is a three-line VMD
hardware workaround: Arrow Lake reports `BUS_RESTRICT_CFG=3`, probe used
to abort with `-ENODEV`, and NVMe behind VMD disappeared. That is a
real, user-visible bug and is appropriate for this tree.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[PCI: vmd]** **[Handle]** Handle `BUS_RESTRICT_CFG` value 3
for Arrow Lake-HX so VMD probe no longer fails.

Subsystem: PCI VMD controller (`drivers/pci/controller/vmd.c`). Verb
“Handle” is a bug-fix verb: previously-unhandled hardware encoding.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Reported-by:** Lin Mohan `<linmhwork@outlook.com>` (real user; also
  the bugzilla reporter)
- **Closes:** https://bugzilla.kernel.org/show_bug.cgi?id=221137 (Arrow-
  Lake-S)
- **Closes:** https://bugzilla.kernel.org/show_bug.cgi?id=221136 (Arrow-
  Lake-S)
- **Signed-off-by:** Ali Alaei (author); Manivannan Sadhasivam (PCI
  host/endpoint maintainer, applied); Bjorn Helgaas (PCI subsystem
  maintainer, committed)
- **Link:** https://patch.msgid.link/20260628143450.92492-1-
  ali.alaei.tabatabaei@gmail.com
- **No Fixes:** tag (expected for this review)
- **No Cc: stable** (expected)
- Ignored pipeline SOBs if present; none from Sasha Levin on this commit

Notable: two independent Closes tags plus a Reported-by, plus PCI
maintainer SOBs.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** On Arrow Lake-HX (Core Ultra 9 275HX, Acer Predator PH16-73),
  VMD `8086:ad0b` reports `VMCONFIG=0x03b8` so `BUS_RESTRICT_CFG =
  (0x03b8 >> 8) & 0x3 = 3`. The switch only handled 0/1/2, so
  `vmd_get_bus_number_start()` returned `-ENODEV` and probe aborted.
- **Symptom:** NVMe behind VMD is invisible.
- **Root cause:** New 2-bit encoding (value 3) treated as unknown.
  `BUS_RESTRICT_CFG` is only 2 bits, so 3 is a legal value, not
  “reserved garbage.”
- **Fix:** Treat cfg=3 like cfg=2 (`busn_start=224`). Guard
  `pci_read_config_word()` with `PCI_POSSIBLE_ERROR()` because a failed
  read is `0xFFFF` and `BUS_RESTRICT_CFG(0xFFFF)=3`, which would now
  look valid.
- **Version info in message:** none beyond Arrow Lake-HX/S hardware.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not hidden. Explicit hardware-handling bug: probe fails, disks
missing. The error-read guard is a real correctness fix that became
necessary once case 3 was valid.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/pci/controller/vmd.c` (+3 lines)
- Function: `vmd_get_bus_number_start()`
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** After `pci_read_config_word(VMCONFIG)`, switch on bits
  [9:8]. 0→bus 0, 1→128, 2→224, anything else (including 3) → `pci_err`
  + `-ENODEV`.
- **After:** If the word is `0xFFFF`, return `-ENODEV`. Case 3 falls
  through to case 2 (`busn_start=224`).
- Path: VMD probe / domain setup, not a hot path and not an optional
  debug path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** Hardware workaround / logic correctness (unhandled
  register encoding), plus error-path guard.
- **Mechanism:** Firmware programs Dynamic Bus Offset / restriction mode
  3. Driver rejected it, so the VMD domain never came up and child NVMe
  never enumerated.
- **Secondary:** Without the `PCI_POSSIBLE_ERROR()` check, a dead device
  (`0xFFFF`) would now be accepted as mode 3.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** Minimal and locally obvious. Mask is `& 0x3`, so 3 is the
  last encoding; mapping it to the existing 224–255 window matches cfg=2
  and matches the author’s dump plus tester reports.
- **Regression risk:** Low. Only devices that actually report cfg=3
  change behavior (they used to fail probe). Other encodings unchanged.
  The `0xFFFF` guard restores the old “abort on bad read” behavior for
  the new case.
- **Caveat (verified, not blocking):** An older Intel series treated
  cfg=3 as a *second* root bus (BUS0=224, BUS1=225). That series is
  **not** in this tree (`bus1_rootbus` / `VMD_FEAT_HAS_BUS1_ROOTBUS`
  absent). This 3-line mapping was tested on real Arrow Lake-HX and
  confirmed by the Arrow Lake-S bugzilla reporter. PCI maintainers
  merged it.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Switch and helper: **`2e1224183b1bec`** (“PCI: vmd: Create bus offset
  configuration helper”, Jon Derrick, 2020) — first in **v5.10-rc1**.
- Even earlier, **`51f939b11cb1c`** / related bus-restriction decode
  treated case 3 as `"Unknown Bus Offset Setting"` + `-ENODEV` on
  purpose.
- Buggy “3 is unknown” behavior has been in the driver for years; it
  only bit users once Arrow Lake firmware started programming 3.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Not applicable. Introduction of the
incomplete switch is `2e1224183b1bec` (v5.10). Device ID `8086:ad0b`
added in **`57a128acaba02`** (“Add DID 8086:7D0B and 8086:AD0B for Intel
MTL SKUs”, ~v6.0). `PCI_POSSIBLE_ERROR` from **`57bdeef471668`**
(~v5.17).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Later on the same file: `2162572d34c50` (_OSC flags in guests),
  `55aa45154fe48` (Nova Lake / Dunlow IDs). Neither is a prerequisite or
  a revert.
- Parent `b030905bf5a64` (BIOS-enumerated devices) does **not** change
  this switch; this commit is standalone.
- Not a “patch X/Y” series.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Ali Alaei’s only commit under `drivers/pci/controller/` is this
one. Applied by Mani, committed by Bjorn. Intel VMD maintainers (Nirmal
Patel, Jonathan Derrick) were CCed on v3; no NAK in the thread.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: None required. Uses existing `vmd_get_bus_number_start()`,
existing `BUS_RESTRICT_CFG()`, existing `PCI_POSSIBLE_ERROR()`. Can
apply standalone on this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **Lore (via b4 dig):** https://patch.msgid.link/20260628143450.92492-
  1-ali.alaei.tabatabaei@gmail.com
- **Revisions:** v1 (2026-06-04, case 3 only) → v2 (same day, add
  `PCI_POSSIBLE_ERROR`) → **v3 applied** (changelog placement + CC VMD
  maintainers)
- v1 review (sashiko-bot) flagged exactly the `0xFFFF` → case 3 issue;
  v2/v3 addressed it.
- Mani: style/CC nits on v2; **“Applied, thanks!”** on v3.
- Bjorn: asked whether it closes bugzilla 221136, noted lack of public
  spec, wanted Intel VMD maintainers to comment; still merged and added
  Reported-by/Closes.
- **No NAK.** No reviewer asked for Cc: stable (absence expected).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (b4 dig -w): linux-pci, Bjorn Helgaas, Lorenzo Pieralisi, Nirmal
Patel, Jonathan Derrick, Krzysztof Wilczyński, Manivannan Sadhasivam,
Rob Herring. Right lists and maintainers.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record:
- Bugzilla fetches returned **403**; full bug text **UNVERIFIED**.
- On-list, Lin Mohan confirmed both 221137 and 221136 are the same Mode
  3 / Dynamic Bus Offset issue, including on `8086:09ab` Arrow Lake-S,
  and asked for Closes tags after merge.
- Author tested Acer Predator PH16-73 / Core Ultra 9 275HX /
  `8086:ad0b`.
- Multiple users/platforms: **HX laptop + S desktop**.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Standalone 1/1. Older Intel “second rootbus” series on spinics
is a large new feature and is **not** in this tree; not a dependency of
this 3-line workaround.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search returned **403**. **UNVERIFIED**
whether stable@ already discussed it. No evidence in the pci thread of a
reason to keep it out of stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `vmd_get_bus_number_start()` only.

**Step 5.2: TRACE CALLERS**

Record:
- Called from `vmd_prepare_offsets_and_bus()` when
  `VMD_FEAT_HAS_BUS_RESTRICTIONS`.
- That is called from `vmd_enable_domain()`.
- That is called from `vmd_probe()`.
- Probe path during PCI enumeration of the VMD device. Not IRQ/hot path.

`VMD_FEATS_CLIENT` includes `VMD_FEAT_HAS_BUS_RESTRICTIONS`. Device
`0xad0b` uses `VMD_FEATS_CLIENT`. Several other client IDs do too, so
any of those that firmware sets to cfg=3 hit this.

**Step 5.3: TRACE CALLEES**

Record: `pci_read_config_word()` (VMCAP 0x40, VMCONFIG 0x44),
`PCI_POSSIBLE_ERROR()`, `pci_err()` on unknown values.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Boot / device probe. Reachable whenever VMD is enabled (RST/VMD
in firmware) on affected Intel client platforms. Unprivileged users do
not trigger it via a syscall; they just lose NVMe. **User-visible and
common on those laptops.**

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same `PCI_POSSIBLE_ERROR()` pattern already used in
`vmd_get_phys_offsets()` for VMLOCK. No other unhandled
`BUS_RESTRICT_CFG` sites.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- `git describe HEAD` → **v7.3-rc4-27-gf0100363d8c37**
- `make kernelversion` → **7.3.0-rc4**
- `vmd_get_bus_number_start()` is present; `0xad0b` is in `vmd_ids[]`;
  `PCI_POSSIBLE_ERROR` is in `include/linux/pci.h`.
- Bug introduced with the 0/1/2-only switch (v5.10 helper); manifests on
  Arrow Lake once those IDs exist (~v6.0+).
- **Yes, the bug exists in this lineage.**

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** on this tree. Hunk is isolated to the helper;
surrounding refactor (`vmd_prepare_offsets_and_bus`) does not overlap.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No other commit implements cfg=3. No revert. No dual-rootbus
substitute.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **PCI controller / Intel VMD.** Criticality **IMPORTANT** (not
core mm/vfs, but VMD is how many Intel laptops expose NVMe).
`CONFIG_VMD` depends on `PCI_MSI && X86_64`.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Actively maintained (new device IDs, BIOS-scan feature, _OSC
guest fix). The **switch itself** has been stable since 2020; this is a
late hardware encoding, not churn in the helper.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver-specific / platform-specific:** x86_64 systems with
Intel VMD and firmware `BUS_RESTRICT_CFG=3` (Arrow Lake-HX confirmed;
Arrow Lake-S reporter confirmed). Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Every boot on affected machines with VMD enabled. Not a race.
Not unprivileged-exploit; **storage simply missing.**

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: VMD probe fails (`-ENODEV`); NVMe behind VMD never appears.
**HIGH** (loss of boot/root/data disks on common Intel client hardware).
Not a panic, but production-breaking.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** High for affected users (NVMe works).
- **Risk:** Very low (3 lines, probe-only, existing mapping, error-read
  guard).
- **Ratio:** Strongly in favor of applying it on this tree.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**For:**
- Real bug: VMD probe abort, NVMe invisible.
- Confirmed on Arrow Lake-HX (author) and Arrow Lake-S (bugzilla
  reporter).
- 3-line, obviously correct mapping of a 2-bit field.
- Extra `PCI_POSSIBLE_ERROR()` prevents a new false-positive on
  `0xFFFF`.
- PCI maintainers applied/committed; v1 review hole fixed in v2/v3.
- Fits the stable **hardware quirk / existing-device enablement**
  exception.
- All helpers and IDs exist in **this** 7.3.0-rc4 tree; no missing
  prerequisites.

**Against:**
- Not a crash/UAF/security bug.
- No public VMD spec for mode 3; Bjorn noted a “new mode” might someday
  need more than a fallthrough (dual-rootbus series never landed here).
- Intel VMD maintainers were CCed but did not ack in the saved thread.

**Unresolved:**
- Full bugzilla pages (HTTP 403).
- stable@ archive search (HTTP 403).
- Whether every cfg=3 platform only needs bus 224 (empirically yes for
  the reported machines).

Those gaps do not outweigh the hardware reports and the size of the fix.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — register dump, author test,
   reporter confirmation, v3 review.
2. Fixes a real bug that affects users? **PASS** — NVMe missing on
   shipping Arrow Lake systems.
3. Important issue? **PASS** — HIGH: boot/storage devices not enumerated
   (not a panic, but not cosmetic).
4. Small and contained? **PASS** — +3 lines, one function.
5. No new features or APIs? **PASS** — no new ABI; handles a value the
   existing 2-bit field can already produce.
6. Can apply to the local tree? **PASS** — helper, IDs, and
   `PCI_POSSIBLE_ERROR` all present; apply is clean.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **Hardware quirk/workaround** (and the same class as device-ID
enablement): existing driver, existing PCI ID, firmware encoding the
driver rejected, so the device did not work.

**Step 9.4: MAKE YOUR DECISION**

This tree is 7.3.0-rc4. The VMD driver, Arrow Lake DID `0xad0b`, bus-
restriction feature flag, and the old 0/1/2-only switch all exist here.
The patch is a small, tested workaround that restores NVMe on affected
Intel VMD systems. It should be applied to this tree.

### What the commit solves
`BUS_RESTRICT_CFG` is two bits. Arrow Lake programs **3**. The driver
treated 3 as unknown, failed VMD probe, and hid NVMe. Mapping 3 to the
existing bus-224 window, and rejecting `0xFFFF` config reads, is the
correct local fix.

### Stable rules
Meets all six criteria. It is a hardware workaround, not a new API.

### Risk vs benefit
Benefit is high (disks appear). Risk is very low (three lines, probe-
only).

### Concerns
Dual-rootbus would be a large new feature and is not in this tree; it is
not required for the reported machines. `PCI_POSSIBLE_ERROR` is already
here, so no extra backport of that helper is needed on this tree.

---

## Verification
- **[Phase 1]** Parsed commit `72b32eccbcd59`: Reported-by Lin Mohan;
  Closes 221137/221136; SOB Ali Alaei, Mani, Bjorn Helgaas; Link to
  msgid 20260628143450.92492-1; no Fixes/Cc-stable.
- **[Phase 2]** Diff: +3 lines in `vmd_get_bus_number_start()`:
  `PCI_POSSIBLE_ERROR` + `case 3:` fallthrough to `busn_start=224`.
- **[Phase 2]** Confirmed `BUS_RESTRICT_CFG` is `((vmcfg >> 8) & 0x3)`
  in `vmd.c:32`; `0xFFFF` → 3.
- **[Phase 3]** `git blame`: switch from `2e1224183b1bec` (v5.10-rc1);
  case 3 lines from this commit.
- **[Phase 3]** `0xad0b` added in `57a128acaba02`; `PCI_POSSIBLE_ERROR`
  in `57bdeef471668` (~v5.17); present in `include/linux/pci.h:179`.
- **[Phase 3]** `git log --oneline -20 -- drivers/pci/controller/vmd.c`:
  no revert; later commits are IDs/_OSC only.
- **[Phase 3]** Author has no other VMD commits.
- **[Phase 4]** `b4 dig -c 72b32eccbcd59`: v3 at
  patch.msgid.link/20260628143450.92492-1-ali.alaei.tabatabaei@gmail.com
- **[Phase 4]** `b4 dig -a`: v1 → v2 → v3; v3 is what was applied.
- **[Phase 4]** `b4 dig -w`: linux-pci + Helgaas, Pieralisi, Patel,
  Derrick, Wilczyński, Sadhasivam, Herring.
- **[Phase 4]** mbox: Mani applied; Bjorn discussed bugzilla; Lin Mohan
  confirmed both bugs; sashiko-bot caught the `0xFFFF` issue on v1.
- **[Phase 4]** Bugzilla WebFetch 403 — full bug text UNVERIFIED;
  reporter confirmation verified from mbox.
- **[Phase 4]** lore.kernel.org/stable 403 — UNVERIFIED.
- **[Phase 5]** Call chain: `vmd_probe` → `vmd_enable_domain` →
  `vmd_prepare_offsets_and_bus` → `vmd_get_bus_number_start`.
- **[Phase 5]** `0xad0b` in `vmd_ids[]` with `VMD_FEATS_CLIENT`
  including `VMD_FEAT_HAS_BUS_RESTRICTIONS`.
- **[Phase 5]** No `bus1_rootbus` in this tree.
- **[Phase 6]** `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4.
- **[Phase 6]** `git merge-base --is-ancestor 72b32eccbcd59 HEAD`: yes;
  first contained in **v7.3-rc1**; not in v7.2.
- **[Phase 7]** `CONFIG_VMD` in `drivers/pci/controller/Kconfig`;
  MAINTAINERS: Nirmal Patel / Jonathan Derrick.
- **[Phase 8]** Failure mode: VMD probe `-ENODEV` → NVMe not enumerated;
  severity HIGH.
- **UNVERIFIED:** Full bugzilla 221136/221137 bodies; any stable@
  thread; whether cfg=3 ever needs a second root bus on unreported SKUs.

**YES**

 drivers/pci/controller/vmd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index b4b62b9ccc45a..5d3e6cc7e4feb 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -656,6 +656,8 @@ static int vmd_get_bus_number_start(struct vmd_dev *vmd)
 	pci_read_config_word(dev, PCI_REG_VMCAP, &reg);
 	if (BUS_RESTRICT_CAP(reg)) {
 		pci_read_config_word(dev, PCI_REG_VMCONFIG, &reg);
+		if (PCI_POSSIBLE_ERROR(reg))
+			return -ENODEV;
 
 		switch (BUS_RESTRICT_CFG(reg)) {
 		case 0:
@@ -664,6 +666,7 @@ static int vmd_get_bus_number_start(struct vmd_dev *vmd)
 		case 1:
 			vmd->busn_start = 128;
 			break;
+		case 3:
 		case 2:
 			vmd->busn_start = 224;
 			break;
-- 
2.53.0

