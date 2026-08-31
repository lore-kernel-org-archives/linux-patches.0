Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5808C55EAF7;
	Mon, 31 Aug 2026 13:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184055; cv=none; b=gmN47l0jlajLrCbNm38ctk3/Ry7WcXP/bBiX2t9LWuiRUFzW/crUpNBNVD76ChXrDMB6ta2th6+fo5JQxekaxKO6agkufxhGlq1dYOQTKBmdbJ1Lq5qRREiXWxhvYcV4AImpFmRv4EB2WY+PVbeApzXVOsRj1S4JM0dFHvGjwzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184055; c=relaxed/simple;
	bh=7yjxVhNAX9o3HTxeQpJ0/t/F3IDXyVkBk3Rljnq0Pk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rpc0DEGUsms7uF4+fl1xdHF3apmyyVM/sTpHUxma6988oMBcXbrZT5fJpygdvoDik2Jx4LDVc5gpGJm9MBTfUH91lO86GBAB6WFTzU2VKcaKTjzVC6SRHAlCbxr6YAAUJRejhUZZR5Y1C0Pnshd7O4gJdEU6IAS9B8HkWeL5i68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ILcvsDTN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ILcvsDTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7C01F00ACF;
	Mon, 31 Aug 2026 13:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184053;
	bh=Jgg4sdSKbomE329Nl7tVODUKAEXno6ZeeSXNFVTs4r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILcvsDTNC3/+2JCCTIQDPLXOdlMAd4m1Mk634fbNR0XRKWvKfXvduykTTdx/vVdEr
	 +u1BOELQ8lWlY0Huc910AC3U13rdXPMNZYPd10EzchhXD2X8bYcMOk/ZEreEdHX1+2
	 2Gaqnc30x+tdHuKqkrgye18UiTmsFxQwalorHzhE/pABQaUl8AeCkekxli+wO7kpQW
	 l8WkfT8i4Q5P1w6REmppC6VOIexnsiCOMzEy+21KIjUNixBYss4hsYioRbowDd/web
	 EzQ4WDaijA4Ymz0xgnCBpwZwoijyoRaLAj2vHjRoKJB6nUjNX2VUrgntO5GAbakY1k
	 s+9B+0nuCOX+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	han.xu@nxp.com,
	linux-spi@vger.kernel.org,
	imx@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] spi: spi-nxp-fspi: enter stop mode before reconfiguring MCR0 and DLL
Date: Mon, 31 Aug 2026 09:28:11 -0400
Message-ID: <20260831133314.4125787-463-sashal@kernel.org>
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

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit b4bde5cfff8e43e948219f0a598e4bf057ecfba4 ]

In nxp_fspi_select_mem() the RX sample clock source (MCR0[RXCLKSRC])
and the DLL control registers (DLLxCR) are reconfigured while the
FlexSPI module is still enabled. According to the FlexSPI reference
manual initialization sequence, MCR0 and the DLL control registers
should be programmed while the module is in stop mode, i.e. with
MCR0[MDIS] set to 1, and the module re-enabled (MCR0[MDIS] = 0)
afterwards.

Wrap the RX sample clock source selection and the DLL calibration/
override reconfiguration in a stop-mode window to align with the RM
and avoid reconfiguring timing-critical registers while the module is
active.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260728-fspi-clock-v2-2-dbe786a4a6eb@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `spi: spi-nxp-fspi: enter stop mode before
reconfiguring MCR0 and DLL`

**Local tree:** Linux 6.18.44 (`v6.18.44-2-g1b9e1abadee04`, Makefile
`VERSION=6 PATCHLEVEL=18 SUBLEVEL=44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 – Subject line**

Record: `[spi: spi-nxp-fspi]` `[enter/align]` — Enter FlexSPI stop mode
(MCR0[MDIS]=1) before reprogramming MCR0 RX clock source and DLL control
registers during runtime memory selection.

**Step 1.2 – Tags**

| Tag | Value |
|-----|-------|
| Signed-off-by | Haibo Chen \<haibo.chen@nxp.com\> |
| Reviewed-by | Frank Li \<Frank.Li@nxp.com\> (NXP) |
| Link | https://patch.msgid.link/20260728-fspi-
clock-v2-2-dbe786a4a6eb@nxp.com |
| Signed-off-by | Mark Brown \<broonie@kernel.org\> (SPI maintainer) |

Notable: No Reported-by, Fixes:, Cc: stable, or syzbot tags. Reviewed by
NXP engineer. Link indicates patch **2/2** of `fspi-clock-v2` series
(patch 1 is already in this tree as `51c52e493346f`).

Record: Reviewed-by from NXP; part of v2 series; no user/fuzzer bug
report in message.

**Step 1.3 – Body analysis**

Record:
- **Bug:** `nxp_fspi_select_mem()` reprograms MCR0[RXCLKSRC] and DLLxCR
  while FlexSPI is still enabled (MCR0[MDIS]=0), violating the FlexSPI
  reference manual initialization sequence.
- **Symptom:** Timing-critical registers changed while the module is
  active; can cause unreliable flash reads when switching chip-select,
  DTR/STR mode, or clock rate.
- **Root cause:** Runtime reconfiguration path omits the stop-mode
  window that probe initialization already uses correctly.
- **Version info:** None in message.

**Step 1.4 – Hidden bug fix?**

Record: **Yes.** Although framed as RM compliance, this is a hardware
correctness bug fix. The driver’s own probe path already disables the
module (MDIS) before DLL programming; `select_mem()` was inconsistent,
creating a real stability risk on flash access paths.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 – Inventory**

Record:
- **File:** `drivers/spi/spi-nxp-fspi.c` (+14 lines net in
  `nxp_fspi_select_mem()`)
- **Function modified:** `nxp_fspi_select_mem()`
- **Scope:** Single-file, surgical fix

**Step 2.2 – Code flow change**

Record:
- **Hunk 1 (before RX/DLL reconfig):** Reads MCR0, sets MDIS (stop
  mode), then proceeds with `nxp_fspi_select_rx_sample_clk_source()`,
  clock rate change, and DLL calibration/override.
- **Hunk 2 (after DLL reconfig):** Clears MDIS to re-enable the module.
- **Before:** MCR0 and DLL registers written while module active.
- **After:** Same operations wrapped in stop-mode window, matching probe
  init at lines 1244–1252.

**Step 2.3 – Bug mechanism**

Record: **Category (g) logic/correctness + hardware workaround.**
Reprogramming timing-critical MCR0/DLL registers on a live FlexSPI
controller violates documented hardware sequencing. The probe path
already does this correctly; runtime `select_mem()` did not.

**Step 2.4 – Fix quality**

Record:
- **Obviously correct:** Yes — mirrors existing probe/cleanup MDIS usage
  in the same file.
- **Minimal:** Yes — ~14 lines, no refactoring.
- **Regression risk:** Low overall. **Minor concern:** pre-existing
  early `return` on `clk_set_rate()` / `clk_prep_enable()` failure would
  now leave MDIS=1 (module disabled). These paths existed before; stop
  mode makes failure state slightly worse, but `clk_set_rate()` failure
  is rare and the function already had unsafe early returns.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 – Blame**

Record: Lines 899–929 in current tree blame to `10eaa4c4a2579` (tree
import artifact; entire `spi-nxp-fspi.c` arrived with stable tree). The
runtime reconfiguration path without stop mode has been present since
the driver exists in this tree.

**Step 3.2 – Fixes: tag**

Record: N/A — no Fixes: tag in commit message.

**Step 3.3 – Related file history**

Record:
- `51c52e493346f` — v2-1 per-SoC rate limits (already in tree; does
  **not** include stop mode)
- `40ad64ac25bb7` — ACPI fwnode propagation
- No stop-mode fix already present

**Step 3.4 – Author context**

Record: Haibo Chen (NXP) authored both `51c52e493346f` (v2-1) and this
v2-2 patch. Frank Li (NXP) reviewed. Mark Brown (SPI maintainer)
committed.

**Step 3.5 – Dependencies**

Record: Part of `fspi-clock-v2` 2-patch series. **v2-1 is already in
this tree.** This patch is standalone — it only wraps existing
reconfiguration in stop mode and does not depend on v2-1’s data
structures. Can apply cleanly to current `nxp_fspi_select_mem()`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 – Original discussion**

Record: **UNVERIFIED** — `b4 dig -c` could not run (commit not in tree);
lore.kernel.org and patch.msgid.link returned 403/bot protection. Link
confirms patch `fspi-clock-v2-2` from NXP.

**Step 4.2 – Reviewers**

Record: **UNVERIFIED** via b4 dig -w. Commit message shows Reviewed-by:
Frank Li (NXP), Signed-off-by: Mark Brown (SPI maintainer).

**Step 4.3 – Bug report**

Record: No Reported-by or syzbot link. Bug inferred from RM requirement
and inconsistency with probe init.

**Step 4.4 – Series context**

Record: `fspi-clock-v2` series:
- v2-1 (`51c52e493346f`) — per-SoC SDR/DTR limits — **in tree**
- v2-2 (this commit) — stop mode before MCR0/DLL reconfig — **not in
  tree**

**Step 4.5 – Stable list**

Record: **UNVERIFIED** — could not search lore stable archive (403).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 – Key functions**

Record: `nxp_fspi_select_mem()` modified; calls
`nxp_fspi_select_rx_sample_clk_source()`, `nxp_fspi_dll_calibration()`,
`nxp_fspi_dll_override()`.

**Step 5.2 – Callers**

Record: `nxp_fspi_select_mem()` called from `nxp_fspi_exec_op()` (line
1121), which is the `spi_mem` exec_op handler — invoked on every SPI
flash memory operation when CS, DTR/STR mode, or frequency changes.

**Step 5.3 – Callees**

Record: `fspi_readl`/`fspi_writel` on MCR0,
`nxp_fspi_select_rx_sample_clk_source()` (writes MCR0 RXCLKSRC),
`clk_set_rate`, `nxp_fspi_dll_calibration()`/`nxp_fspi_dll_override()`
(write DLLACR/DLLBCR).

**Step 5.4 – Reachability**

Record: **Userspace-reachable** via MTD/SPI-NOR flash access on NXP
platforms. Triggered when:
- Switching between chip-selects (multi-flash boards)
- Switching DTR ↔ STR mode (e.g., after `spi_nor_suspend` per driver
  comment at line 754)
- Changing operation frequency

**Step 5.5 – Similar patterns**

Record: Probe init (lines 1244–1252) and cleanup (line 1352) already use
`FSPI_MCR0_MDIS`. `select_mem()` was the inconsistent outlier. Driver
comment at lines 749–751 notes DTR mode without proper RXCLKSRC “read
operation may meet issue.”

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

**Step 6.1 – Buggy code present?**

Record: **Yes.** Current `nxp_fspi_select_mem()` at lines 899–929
reprograms MCR0/DLL without entering stop mode. Commit is **not** yet
applied.

**Step 6.2 – Backport complications**

Record: **Clean apply expected.** Only adds `u32 reg` and MDIS set/clear
around existing code. No structural conflicts with recent changes.

**Step 6.3 – Related fixes already present?**

Record: **No.** `git log --grep='stop mode'` returns nothing. v2-1 rate
limits are present but stop-mode fix is absent.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1 – Subsystem and criticality**

Record: **drivers/spi** — NXP FlexSPI controller
(`CONFIG_SPI_NXP_FLEXSPI`, depends on `ARCH_LAYERSCAPE || ARCH_MXC`).
**IMPORTANT** for NXP embedded (i.MX8, i.MX95, LX2160A) — boot/storage
flash lives on this controller.

**Step 7.2 – Activity**

Record: Active — recent commits `51c52e493346f`, `40ad64ac25bb7` in this
tree.

---

## PHASE 8: IMPACT AND RISK

**Step 8.1 – Who is affected**

Record: **Platform-specific** — NXP i.MX and Layerscape boards using
FlexSPI for SPI-NOR flash (common boot media).

**Step 8.2 – Trigger conditions**

Record: Chip-select switch, DTR/STR mode change, or frequency change
during flash I/O. Moderately common on multi-CS or DTR-capable setups.
Unprivileged users can trigger via normal flash/MTD access.

**Step 8.3 – Failure mode severity**

Record: **Flash read corruption or failures** when timing registers are
reprogrammed on an active controller. Severity: **HIGH** for affected
platforms (silent data corruption risk on NOR flash reads).

**Step 8.4 – Risk/benefit**

Record:
- **Benefit:** HIGH for NXP embedded users — prevents unreliable flash
  reads during runtime reconfiguration.
- **Risk:** LOW — small change, matches existing probe pattern, NXP-
  reviewed.
- **Ratio:** Strong benefit, low risk.

---

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backport:**
- Fixes real hardware programming sequence violation
- Probe init already uses stop mode; runtime path was wrong by
  comparison
- Can cause flash read instability/corruption on CS/mode/freq switches
- Small (~14 lines), surgical, NXP-reviewed
- Buggy code confirmed present in Linux 6.18.44 tree
- v2-1 prerequisite already in tree; patch applies standalone
- Hardware workaround / correctness fix category

**Evidence AGAINST:**
- No explicit user bug report or syzbot finding
- Platform-specific driver (not universal)
- Early-return error paths could leave MDIS=1 (pre-existing pattern,
  rare trigger)
- Mailing list discussion unverified

**Stable rules checklist:**

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — matches probe pattern;
NXP-reviewed |
| 2. Fixes real bug affecting users? | **PASS** — RM violation on live
controller during flash ops |
| 3. Important issue? | **PASS** — flash read corruption risk, HIGH for
NXP platforms |
| 4. Small and contained? | **PASS** — single function, ~14 lines |
| 5. No new features/APIs? | **PASS** — sequencing fix only |
| 6. Can apply to local tree? | **PASS** — buggy code present, clean
apply expected |

**Exception category:** Hardware workaround / correctness fix for
timing-critical register programming.

---

## Verification

- [Phase 1] Parsed subject, tags (Reviewed-by Frank Li, Link to v2-2),
  body — no Reported-by/syzbot
- [Phase 2] Diff analysis: adds MDIS stop-mode window in
  `nxp_fspi_select_mem()`, +14 lines
- [Phase 3] `git blame -L 899,929`: buggy path in current tree; `git log
  --oneline -- drivers/spi/spi-nxp-fspi.c`: v2-1 present, stop-mode fix
  absent
- [Phase 3] `51c52e493346f` confirmed as v2-1 already in tree; stop mode
  not included
- [Phase 3] `git merge-base --is-ancestor f43579ef3500 HEAD`: f43579 NOT
  ancestor (stable import), but runtime reconfig code exists
- [Phase 4] b4 dig: commit not in tree, could not run `-c`
- [Phase 4] lore.kernel.org / patch.msgid.link: 403 Forbidden —
  **UNVERIFIED** discussion content
- [Phase 5] `nxp_fspi_select_mem()` called from `nxp_fspi_exec_op()`
  line 1121 — flash hot path
- [Phase 5] Probe lines 1244–1252 use MDIS before DLL config; cleanup
  line 1352 uses MDIS
- [Phase 6] `git describe HEAD`: v6.18.44; buggy code at lines 899–929
  confirmed by read
- [Phase 6] `git log --grep='stop mode'`: no matches — fix not yet
  applied
- [Phase 7] `CONFIG_SPI_NXP_FLEXSPI` in drivers/spi/Kconfig,
  ARCH_MXC/ARCH_LAYERSCAPE
- [Phase 8] Supported SoCs: imx8mm/mp/qxp/dxl/ulp/95, lx2160a (device
  table lines 1522–1529)

This is a small, hardware-correctness fix that prevents reprogramming
timing-critical FlexSPI registers while the controller is active — a
documented violation that can cause flash read failures on NXP embedded
platforms. The fix mirrors the probe init sequence already in the
driver, applies cleanly to 6.18.44, and its series prerequisite is
already present.

**YES**The background `git log -S 'select_rx_sample_clk_source'` search
timed out and was killed; it wasn’t needed for the verdict — the
relevant history was already covered via blame, file log, and reading
the current `nxp_fspi_select_mem()` code.

**Conclusion for Linux 6.18.44:** backport **YES**. The driver
reprograms MCR0/DLL timing registers at runtime without entering stop
mode, while probe init already does — a small hardware-correctness fix
that can affect flash read reliability on NXP i.MX/Layerscape platforms
when switching chip-select, DTR/STR mode, or frequency.

 drivers/spi/spi-nxp-fspi.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index 69ab72fff19d2..5cdd14d72c34c 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -867,6 +867,7 @@ static int nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi,
 	unsigned long rate = op->max_freq;
 	int ret;
 	uint64_t size_kb;
+	u32 reg;
 
 	/*
 	 * Return when following condition all meet,
@@ -896,6 +897,15 @@ static int nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi,
 
 	dev_dbg(f->dev, "Target device [CS:%x] selected\n", spi_get_chipselect(spi, 0));
 
+	/*
+	 * Per the FlexSPI reference manual (initialization sequence), MCR0 and
+	 * the DLL control registers should be configured while the module is in
+	 * stop mode (MCR0[MDIS] = 1). Enter stop mode before reconfiguring the
+	 * RX sample clock source and the DLL, then exit stop mode afterwards.
+	 */
+	reg = fspi_readl(f, f->iobase + FSPI_MCR0);
+	fspi_writel(f, reg | FSPI_MCR0_MDIS, f->iobase + FSPI_MCR0);
+
 	nxp_fspi_select_rx_sample_clk_source(f, op_is_dtr);
 	rate = min(f->max_rate, op->max_freq);
 
@@ -935,6 +945,10 @@ static int nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi,
 	else
 		nxp_fspi_dll_override(f);
 
+	/* Exit stop mode now that MCR0 and the DLL have been reconfigured. */
+	reg = fspi_readl(f, f->iobase + FSPI_MCR0);
+	fspi_writel(f, reg & ~FSPI_MCR0_MDIS, f->iobase + FSPI_MCR0);
+
 	f->pre_op_rate = op->max_freq;
 
 	f->selected = spi_get_chipselect(spi, 0);
-- 
2.53.0

