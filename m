Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C878448BBE;
	Mon, 31 Aug 2026 13:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183248; cv=none; b=VOKXyqUcox0wNTn0npa+5d3NEIy3wWD5CmX4IMS6CinTcM4aR+me0j7dQqRMLyFLlfuFYA9jEfZrBfKK6OFnxKG22ALu9o3bUubo0qgUmnMyoubB8Jlbi0AiOgUp7eQCS8UzeNLzvq/60cqH3wSFEreiD2trWVf/3pxQDF+PS18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183248; c=relaxed/simple;
	bh=oZZmzJJaTC1OwMdUzjYrScl+rw6YCf3MDagZizbQnsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qq/wN9v8RQOvQTzqure3yWPH7jU9zHT7qMKsK4+JFwp+3SHaZW4z+/pI/l4nTZ6ukh6fLvA24zV3BbQljhwHqI8hUf8zlXUro99QNZj3Xc1631C4ufGJj+cpmz+WlfEBbgg2Dni3mrxrAySoYOG5JGCBnQFQ4Xmm52xdPYO+0ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CDVkqgiE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CDVkqgiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DCE1F00A3E;
	Mon, 31 Aug 2026 13:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183246;
	bh=kHkJAFP3+2eSRsAQlstSfJJhNWEBKMr8y/tJjJW4lcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDVkqgiE0gW7jhdNwLWNP/cPHMwHM1kj4o8pMGUzqXo71eXwFO+crKeeEZBIH0MVD
	 RblHaT6TddOn1xw6x7wYWDGSJ3c5/gnIEUzC+2ozsim6W76yDBvym+GpILtDEzyR6S
	 55J5GazywQvNy7YAd6AKqLi6NzxPRiSw3qPMiKkcBLlZ/gotc+Vp2f+J2iLFVO60Fs
	 ljmPSeEFKlVJXGWqpa/bfdRVNWlH0YPSgxyIfXMVMfTICv4X6rcmtOkInQht8/T1tA
	 jAgN1L8czY136PRhZ+Eki7MTqSJEN0RdVMnwiPG9mQIXDipRASx1ROV9nYC4E+RnMH
	 LbjQ6mlVARCWA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] bus: fsl-mc: wait for the MC firmware to complete its boot
Date: Mon, 31 Aug 2026 09:21:01 -0400
Message-ID: <20260831133314.4125787-33-sashal@kernel.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 208858b1b48eba83d073542372329cf8ed606526 ]

There are use cases in which the Management Complex firmware boot
process is started by the bootloader which does not wait for the boot to
complete. This is mainly done in order to reduce the overall boot time
of a DPAA2 based SoC.

In this kind of circumstance, the fsl-mc bus driver needs to make sure
that the MC firmware boot process is finished before proceeding to the
usual operations such as interrogating the firmware to gather all
existent DPAA2 objects, creating the fsl-mc devices on the bus etc.

Add this kind of check early in the boot process of the fsl-mc bus and
defer the probe in case the firmware is still in its boot process.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20260401144508.3062019-1-ioana.ciornei@nxp.com
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[bus: fsl-mc]` `[wait]` — Ensure the Management Complex
(MC) firmware has finished booting before the fsl-mc bus driver proceeds
with DPAA2 enumeration.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Ioana Ciornei `<ioana.ciornei@nxp.com>` (author)
- **Link:** https://lore.kernel.org/r/20260401144508.3062019-1-
  ioana.ciornei@nxp.com
- **Signed-off-by:** Christophe Leroy (CS GROUP) `<chleroy@kernel.org>`
  (committer/ack)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: NXP author, FSL maintainer committer; no fuzzer or user bug
  reports

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Bootloaders on DPAA2 SoCs may start MC firmware boot
  asynchronously (to shorten boot time) without waiting for completion.
- **Symptom:** `fsl_mc_bus_probe()` talks to MC firmware (version query,
  DPRC enumeration, device creation) before firmware is ready → MC I/O
  fails.
- **Failure mode:** Without `-EPROBE_DEFER`, probe fails permanently;
  DPAA2 networking/storage/crypto does not come up.
- **Root cause:** Driver assumed MC firmware was ready at probe time; no
  GSR (Global Status Register) boot-complete check.
- **Version info:** None in message; fix targets all trees with the
  existing probe path.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — described as a synchronization improvement, but it
fixes a real boot race. Without it, `mc_get_version()` and later MC
portal calls run against firmware still booting, causing hard probe
failure instead of deferred retry.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/bus/fsl-mc/fsl-mc-bus.c` only (+46 lines, 0
  removed)
- **Functions added:** `fsl_mc_read_gsr()`, `fsl_mc_firmware_check()`
- **Function modified:** `fsl_mc_bus_probe()` — adds call after GCR1
  resume
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (defines):** Adds `FSL_MC_GSR` (offset 0x8) and bit masks for
  boot-done, MCS status, and boot code.
- **Hunk 2 (`fsl_mc_firmware_check`):**
  - Before: No firmware readiness check.
  - After: Reads GSR; if boot code `0xDD` → `-EOPNOTSUPP` (DPL never
    started); if `BOOT_DONE` clear → `-EPROBE_DEFER`; if MCS error bits
    set → `-EINVAL`.
- **Hunk 3 (`fsl_mc_bus_probe`):**
  - Before: After GCR1 resume, immediately opens MC portal and calls
    `mc_get_version()`.
  - After: Calls `fsl_mc_firmware_check()` first; only proceeds on
    success.

### Step 2.3: Bug Mechanism
**Record:** **Category:** Logic / timing race (boot synchronization).
**Mechanism:** Probe races ahead of asynchronous MC firmware boot
started by the bootloader. Fix polls hardware GSR and uses
`-EPROBE_DEFER` so the driver core retries once firmware is ready.

### Step 2.4: Fix Quality
**Record:** Fix is minimal and follows established kernel patterns
(`EPROBE_DEFER`, hardware status register). Low regression risk on real
DPAA2 hardware (GSR register is part of the existing MC control register
block at `IORESOURCE_MEM` index 1). Minor note:
`fsl_mc_firmware_check()` is called outside `if (mc->fsl_mc_regs)` —
would NULL-deref if register resource 1 is absent, but all in-tree DPAA2
DT bindings provide both `reg` regions and the same resource is already
required for GCR1 pause/resume logic.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Probe path without GSR check dates to Jakub Kicinski merge
`e7fa5c80defe0` (Jan 2021). GCR1 pause/resume added by Laurentiu Tudor
`f8cfa9bbab338b` / `8c97a4fc1b348` (Jul 2021). Buggy “assume firmware
ready” behavior has been present since probe was written; async-
bootloader scenario was never handled.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related File History
**Record:** Recent stable-tree changes to this file include error-
handling fixes (`b662f91e216fd`), UAF fix (`1d6bd6183e723`),
`platform_get_resource()` check (`25f526507b8cc`). Commit
`208858b1b48eb` is standalone (v1 only, no series). On mainline but not
yet in `stable/linux-6.18.y`.

### Step 3.4: Author Context
**Record:** Ioana Ciornei is an active NXP contributor to fsl-mc
(endpoint, userspace support, command whitelist commits visible in this
tree). Christophe Leroy is the FSL/soc maintainer who applied the patch.

### Step 3.5: Dependencies
**Record:** No prerequisites. Uses existing `mc->fsl_mc_regs`,
`platform_get_drvdata()`, and `readl()`. Applies cleanly to this tree
(`git apply --check` passed). Standalone.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** `b4 dig -c 208858b1b48eb` →
https://patch.msgid.link/20260401144508.3062019-1-ioana.ciornei@nxp.com.
Single v1 submission (Apr 1, 2026). Maintainer reply: “Applied, thanks!”
— no NAKs, no stable nomination, no review objections.

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: To/Cc included `chleroy@kernel.org`, `linuxppc-
dev@lists.ozlabs.org`, `linux-kernel@vger.kernel.org`. Appropriate
maintainers CC'd.

### Step 4.3: Bug Report
**Record:** N/A — no Reported-by or external bug link. Issue is
described as a known bootloader optimization use case from NXP.

### Step 4.4: Related Patches
**Record:** Standalone patch, not part of a multi-patch series. Related
historical context: 2021 GCR1 pause/resume series addressed the opposite
timing problem (MC running too early before IOMMU).

### Step 4.5: Stable List
**Record:** Not searched on lore stable list; no stable nomination found
in the patch thread.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `fsl_mc_firmware_check()`, `fsl_mc_read_gsr()`,
`fsl_mc_bus_probe()`

### Step 5.2: Callers
**Record:** `fsl_mc_bus_probe()` is the `platform_driver.probe` callback
for `fsl_mc_bus_driver` — invoked during platform device enumeration at
boot on DPAA2 SoCs (DT: `fsl,qoriq-mc`; ACPI: `NXP0008`).

### Step 5.3: Callees
**Record:** `readl()` on `mc->fsl_mc_regs + FSL_MC_GSR`;
`platform_get_drvdata()`; `dev_err()` / `dev_dbg()`.

### Step 5.4: Reachability
**Record:** Triggered on every boot of DPAA2 hardware when
`CONFIG_FSL_MC_BUS=y/m`. Bootloader async MC start is the trigger
condition. Affects init path, not a hot path. Userspace cannot directly
trigger, but all DPAA2 I/O depends on successful probe.

### Step 5.5: Similar Patterns
**Record:** Existing `EPROBE_DEFER` usage in same file for ACPI DMA
deferral (`f8cfa9bbab338b`, line 1053). GCR1 pause/resume in bus
notifier and probe handles complementary MC/IOMMU timing. This fix
completes the boot-synchronization story for the async-bootloader case.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Local tree is **v6.18.43** (`stable/linux-6.18.y`).
`fsl_mc_firmware_check` / `FSL_MC_GSR` are **not** present (grep found
no matches). `fsl_mc_bus_probe()` at lines 1069–1091 proceeds directly
from GCR1 resume to `fsl_create_mc_io()` / `mc_get_version()` with no
boot-complete check.

### Step 6.2: Backport Complications
**Record:** **Clean apply** — `git apply --check` on commit
`208858b1b48eb` succeeded with no conflicts. Probe structure matches
mainline.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent GSR boot-check fix in this tree. Prerequisite
infrastructure (`fsl_mc_regs`, GCR1 defines, bus notifier) all present
since 2021.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** **Subsystem:** `drivers/bus/fsl-mc` (NXP QorIQ DPAA2 bus).
**Criticality:** IMPORTANT for DPAA2 platforms — root bus for all DPAA2
objects (DPMAC networking, DPNI, DPIO, crypto, etc.). Not universal, but
essential on affected enterprise/embedded SoCs (LS1088, LS2088, LX2160,
etc.).

### Step 7.2: Subsystem Activity
**Record:** Moderately active — recent stable fixes include UAF, double-
free, error-handling. MC/IOMMU boot synchronization has been an ongoing
concern since 2021.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Platform-specific — users of NXP QorIQ DPAA2 SoCs with
bootloaders that start MC firmware boot without waiting. All
DPAA2-dependent functionality is affected when the race loses.

### Step 8.2: Trigger Conditions
**Record:** Boot-time race when bootloader optimizes boot time by not
waiting for MC firmware. Reasonably likely on newer/fast-boot
configurations. Not userspace-triggerable; not a security issue.

### Step 8.3: Failure Severity
**Record:** **Probe failure → DPAA2 subsystem non-functional** (no
network, no DPAA2 devices enumerated). Without `-EPROBE_DEFER`, failure
is permanent for that boot. **Severity: HIGH** for affected platforms
(functional boot failure of core I/O subsystem).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for DPAA2 users with async-boot bootloaders —
  restores reliable boot.
- **Risk:** LOW — 46 lines, hardware register read, standard defer
  pattern, applies cleanly.
- **Ratio:** Strong benefit, low risk.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes real boot race on DPAA2 SoCs
- Prevents permanent probe failure and broken DPAA2 I/O
- Small, self-contained, applies cleanly to v6.18.43
- Uses standard `-EPROBE_DEFER` mechanism
- Buggy code confirmed present in this tree since 2021
- NXP developer + FSL maintainer authorship
- Analogous to prior stable-worthy MC/IOMMU boot timing fixes

**AGAINST backport:**
- Platform-specific (DPAA2 only) — but stable routinely takes such fixes
- No syzbot/user bug report — but mechanism is clear from code and
  commit message
- `fsl_mc_firmware_check()` called even when `mc->fsl_mc_regs` may be
  NULL — mitigated by all real DPAA2 bindings providing resource index 1

**Unresolved:** No independent user crash reports; impact verified by
code analysis and NXP description only.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — hardware GSR check +
   EPROBE_DEFER is standard; maintainer applied without objection.
2. Fixes a real bug? **PASS** — boot race causes MC I/O failure before
   firmware ready.
3. Important issue? **PASS** — HIGH: DPAA2 probe failure, core I/O
   broken on affected SoCs.
4. Small and contained? **PASS** — 46 lines, one file.
5. No new features/APIs? **PASS** — synchronization fix only.
6. Can apply to local tree? **PASS** — clean apply verified.

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs). Qualifies
as a hardware boot-synchronization bug fix.

### Step 9.4: Decision Rationale
For **linux-6.18.y (v6.18.43)**, the fsl-mc bus driver lacks any MC
firmware boot-complete check. When bootloaders start MC firmware
asynchronously, probe races ahead and fails MC portal operations —
without `-EPROBE_DEFER` this is a permanent boot failure for the entire
DPAA2 subsystem. The fix is small, obviously correct, self-contained,
and applies cleanly. Platform-specific scope is normal for stable DPAA2
fixes.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from `git show
  208858b1b48eb`
- **[Phase 1]** Confirmed no Fixes:/Reported-by:/Cc: stable tags
- **[Phase 2]** Full diff analyzed: +46 lines in `fsl-mc-bus.c`, two new
  functions, one probe call site
- **[Phase 3]** `git describe HEAD` → v6.18.43; tree on
  `stable/linux-6.18.y`
- **[Phase 3]** `git blame` on probe area: core probe from
  `e7fa5c80defe0` (2021), GCR1 logic from `f8cfa9bbab338b` (2021)
- **[Phase 3]** `git log stable/linux-6.18.y..origin/master --
  drivers/bus/fsl-mc/fsl-mc-bus.c`: commit `208858b1b48eb` not in stable
- **[Phase 3]** `git apply --check` on patch: **clean apply**
- **[Phase 4]** `b4 dig -c 208858b1b48eb`: found lore thread
- **[Phase 4]** `b4 dig -a`: single v1, no revisions
- **[Phase 4]** `b4 dig -w`: chleroy, linuxppc-dev, linux-kernel CC'd
- **[Phase 4]** `b4 dig -m /tmp/fsl_mc.mbox`: maintainer “Applied,
  thanks!” — no NAKs or stable discussion
- **[Phase 5]** `grep fsl_mc_bus_probe`: only platform driver probe
  callback
- **[Phase 5]** Read current `fsl_mc_bus_probe()` lines 1014–1096:
  confirms no GSR check before `mc_get_version()`
- **[Phase 5]** DT check `fsl-lx2160a.dtsi`: two `reg` entries for fsl-
  mc (portal + control registers)
- **[Phase 6]** `grep FSL_MC_GSR fsl_mc_firmware_check`: **not present**
  in local tree
- **[Phase 6]** Confirmed buggy probe path exists at lines 1069–1091
- **[Phase 6]** Patch applies cleanly to v6.18.43
- **[Phase 7]** `Kconfig`: `FSL_MC_BUS` depends on OF && (LAYERSCAPE ||
  COMPILE_TEST)
- **[Phase 8]** Failure mode: `mc_get_version()` error → `goto
  error_cleanup_mc_io` → non-defer probe failure

**YES**

 drivers/bus/fsl-mc/fsl-mc-bus.c | 46 +++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index 996379ace3764..21eb0a3c190fc 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -66,6 +66,13 @@ struct fsl_mc_addr_translation_range {
 #define GCR1_P1_STOP	BIT(31)
 #define GCR1_P2_STOP	BIT(30)
 
+#define FSL_MC_GSR		0x8
+#define FSL_MC_GSR_BOOT_DONE	BIT(0)
+#define FSL_MC_GSR_MCS_MASK	GENMASK(7, 0)
+#define FSL_MC_GSR_MCS_ERR_MASK	GENMASK(7, 1)
+#define FSL_MC_GSR_BC_MASK	GENMASK(15, 8)
+#define FSL_MC_GSR_BC_SHIFT	8
+
 #define FSL_MC_FAPR	0x28
 #define MC_FAPR_PL	BIT(18)
 #define MC_FAPR_BMT	BIT(17)
@@ -1007,6 +1014,41 @@ static int get_mc_addr_translation_ranges(struct device *dev,
 	return 0;
 }
 
+static u32 fsl_mc_read_gsr(struct fsl_mc *mc)
+{
+	return readl(mc->fsl_mc_regs + FSL_MC_GSR);
+}
+
+static int fsl_mc_firmware_check(struct platform_device *pdev)
+{
+	struct fsl_mc *mc = platform_get_drvdata(pdev);
+	u32 gsr, boot_done, boot_code, mcs;
+
+	gsr = fsl_mc_read_gsr(mc);
+	boot_code = (gsr & FSL_MC_GSR_BC_MASK) >> FSL_MC_GSR_BC_SHIFT;
+	if (boot_code == 0xDD) {
+		dev_err(&pdev->dev,
+			"fsl-mc: DPL processing was not started, DPAA2 will not work!\n");
+		return -EOPNOTSUPP;
+	}
+
+	boot_done = gsr & FSL_MC_GSR_BOOT_DONE;
+	if (!boot_done) {
+		dev_dbg(&pdev->dev,
+			"fsl-mc: DPL processing in progress, defer probe\n");
+		return -EPROBE_DEFER;
+	}
+
+	mcs = gsr & FSL_MC_GSR_MCS_MASK;
+	if (mcs & FSL_MC_GSR_MCS_ERR_MASK) {
+		dev_err(&pdev->dev,
+			"fsl-mc: MC boot completed with error 0x%x\n", mcs);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /*
  * fsl_mc_bus_probe - callback invoked when the root MC bus is being
  * added
@@ -1071,6 +1113,10 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
 		       mc->fsl_mc_regs + FSL_MC_GCR1);
 	}
 
+	error = fsl_mc_firmware_check(pdev);
+	if (error)
+		return error;
+
 	/*
 	 * Get physical address of MC portal for the root DPRC:
 	 */
-- 
2.53.0

