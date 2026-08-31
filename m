Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027B74B5CBB;
	Mon, 31 Aug 2026 13:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184385; cv=none; b=cQtv+6VvQLrpkvzSow0y0/0xF6Mq1d6ZAxK/acsSgw4ydb8+WDhkqIo0gM3PHv5T1y31j1LSzCRTLqUtQrcOqgEqJvh+9oBHa/PV7YJMJNKcG8uvcJkVzLbPm3ky/nRpjmJBXW0xooD+3WO38mbzr/h6p0UXEie1Z9vThzEpgho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184385; c=relaxed/simple;
	bh=pxJqVe2JeqZ0DeqrNVtYgSl9R1Ly+XRBSM9st5GdjTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rDZTc6+HoxXoSAOwQKvxLv2dHOwgt5Kv1ZMGgpPXIRLsY+Vl1F0M7LvGaK8RHUSVSIKRV6U1myRHuDt6mr58IxwFOV4zNwyj6aqqGCdeTTSFF/ZwT8iFu2Dl3fk/nThnOglEskk6FpPLat3IqZzUyVo0AMv7qbtDoswhHeegvdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZq0u3Gf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZq0u3Gf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BA51F000E9;
	Mon, 31 Aug 2026 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184383;
	bh=wQtAP4WPaZgC8vzljHhmC9u3m5h5hgTOsfh3R0/nUTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZq0u3GfghDV8VSVJaXo7oY51TIuvN1N4fmtkyh/a+ezkKIqtEYYGkCYWSnAh5TGu
	 L8yvvxe0qfa0OYJG8akhyhSTW5djssoanL72UiOPQLcpFjfN4P/KLLefOg93tZhTO/
	 pzGColXRhsy6PQvJVWa3kJzw8BBV9O5bVfK59Wowna5GO5QDQP56P0k/dXqXl7r/o0
	 wPE1BVvU7/0Lyo4c4zNmk3mw0x4DE8+3s5/v0GgmcoU9oceT4vBnCQhgrxx9hIcBNR
	 PRMFUY2ZevdPdbKuLTZGAUDxHevtP1mtcClAnJFy57FZG9/Fqjx+riV/8vv09R4wYq
	 lsp9VBq3OyyRA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	han.xu@nxp.com,
	linux-spi@vger.kernel.org,
	imx@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] spi: spi-nxp-fspi: propagate clock reconfig failures in nxp_fspi_select_mem()
Date: Mon, 31 Aug 2026 09:31:29 -0400
Message-ID: <20260831133314.4125787-661-sashal@kernel.org>
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

[ Upstream commit b5902b9779796d515b7d65eb9205994b7a8d00cb ]

nxp_fspi_select_mem() disables the FlexSPI clocks before calling
clk_set_rate() and re-enabling them. If clk_set_rate() or the clock
re-enable fails, the function returned early (as void) leaving both the
serial root clock and the register interface clock disabled.

As the function returned void, nxp_fspi_exec_op() had no way to know
about the failure and continued to access FlexSPI registers (LUT setup,
data transfer, AHB buffer invalidation). Accessing the controller
registers while its clock is gated off results in a synchronous external
abort.

Make nxp_fspi_select_mem() return an error code and have
nxp_fspi_exec_op() bail out on failure before any further register
access, including nxp_fspi_invalid().

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://patch.msgid.link/20260728-fspi-clock-v2-3-dbe786a4a6eb@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `spi: spi-nxp-fspi: propagate clock reconfig
failures in nxp_fspi_select_mem()`

**Local tree:** Linux **6.18.44** (`git describe HEAD` →
`v6.18.44-2-g1b9e1abadee04`, Makefile `6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[spi: spi-nxp-fspi]` `[propagate]` — propagate clock
reconfiguration failures from `nxp_fspi_select_mem()` to its caller.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** `https://patch.msgid.link/20260728-fspi-
  clock-v2-3-dbe786a4a6eb@nxp.com` (PATCH v2 3/3)
- **Cc: stable:** — none (expected for manual review)
- **Signed-off-by:** Haibo Chen `<haibo.chen@nxp.com>`, Mark Brown
  `<broonie@kernel.org>` (SPI maintainer)

Notable: part of a 3-patch series; no syzbot/fuzzer report, but
maintainer merge is a quality signal.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `nxp_fspi_select_mem()` disables FlexSPI clocks, calls
  `clk_set_rate()`, then re-enables. On `clk_set_rate()` or re-enable
  failure, it returns early as `void`, leaving clocks disabled.
- **Symptom:** `nxp_fspi_exec_op()` continues with LUT setup, data
  transfer, and `nxp_fspi_invalid()` — register accesses with clocks
  gated → **synchronous external abort** (SoC bus fault / kernel crash).
- **Root cause:** Missing error propagation from a `void` helper.
- **Fix:** Return `int` from `nxp_fspi_select_mem()`, re-enable clocks
  on `clk_set_rate()` failure (for runtime PM balance), bail out of
  `nxp_fspi_exec_op()` before any further register access.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — this is an explicit crash-prevention fix on
an error path, not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **File:** `drivers/spi/spi-nxp-fspi.c` (~25 insertions, ~7 deletions)
- **Functions:** `nxp_fspi_select_mem()`, `nxp_fspi_exec_op()`
- **Scope:** Single-file, surgical fix

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE

**Hunk 1 — `nxp_fspi_select_mem()`:**
- **Before:** `static void`; early-exit paths return nothing;
  `clk_set_rate()` / `nxp_fspi_clk_prep_enable()` failures silently
  return with clocks disabled.
- **After:** `static int`; success returns `0`; `clk_set_rate()` failure
  re-enables clocks then returns error; `clk_prep_enable()` failure
  returns error; success returns `0`.

**Hunk 2 — `nxp_fspi_exec_op()`:**
- **Before:** Ignores `nxp_fspi_select_mem()` result; always runs
  `nxp_fspi_prepare_lut()`, transfer path, and `nxp_fspi_invalid()`.
- **After:** Checks return value; on failure calls
  `pm_runtime_put_autosuspend()` and returns immediately — no register
  access.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:** **Error-path / memory-mapped I/O safety fix.** Category:
NULL/gated-clock register access leading to synchronous external abort
(ARM-class failure). Mechanism: clocks disabled at lines 912–920 in the
current tree, failure swallowed, MMIO continues.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- Fix is obviously correct and minimal.
- Re-enabling clocks on `clk_set_rate()` failure preserves runtime PM
  reference counting — thoughtful detail.
- Low regression risk: only affects already-failing paths.
- On `nxp_fspi_clk_prep_enable()` failure, clocks may still be left
  disabled, but caller correctly avoids MMIO (better than crashing).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** In this 6.18.44 tree, the buggy `clk_set_rate()` early-
return pattern at lines 914–920 is present. `git blame` attributes
surrounding code to `10eaa4c4a2579` (bulk import in this checkout; not a
meaningful per-line history). The void-return + silent-failure pattern
is in the current file.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag. N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:**
- `51c52e493346f` — **already in this tree**: patch 1/3 of the same
  series (per-SoC SDR/DTR rate limits), committed by Greg K-H as stable
  backport.
- Patch 2/3 (“enter stop mode before reconfiguring MCR0 and DLL”) is
  **not** in this tree.
- This fix (patch 3/3) is **not** in this tree.
- Standalone for the error-propagation bug: patch 3 does not require
  patch 2; patch 2 is an init-sequence improvement.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Haibo Chen (NXP) authored `51c52e493346f` already backported
here; SPI maintainer Mark Brown committed both.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:**
- Series context: v2 0/3 cover letter lists patches 1–3; patch 1 is
  already present.
- Patch 3 applies cleanly to **this tree's** simpler
  `nxp_fspi_select_mem()` (no MCR0 stop-mode hunks from patch 2).
- **Can apply standalone:** YES (minor context adaptation only).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:**
- `b4 dig -c <commit>`: commit not in this tree; could not run against
  commitish.
- **lkml.iu.edu:** [PATCH v2 3/3] — confirms diff and crash description.
- **lists.openwall.net:** [PATCH v2 0/3] series cover letter — patches
  1–3 described; v2 adds patches 2–3 per review feedback.
- lore.kernel.org blocked by bot protection; used lkml/openwall mirrors
  instead.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** Cover letter To: Han Xu, Yogesh Gaur, **Mark Brown** (SPI
maintainer). Cc: linux-spi, imx, linux-kernel. Mark Brown committed the
patch upstream.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No external bug report or syzbot link. Bug identified by
code-path analysis in the patch series (v2 added per review). Severity
described authoritatively: synchronous external abort.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** 3-patch series; patch 1 backported here; patch 2 optional;
patch 3 is the subject commit.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Not searched separately; patch 1 already landed in this
6.18.y tree via Greg K-H, indicating the series is stable-appropriate.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `nxp_fspi_select_mem()`, `nxp_fspi_exec_op()`, plus callees
`nxp_fspi_clk_disable_unprep()`, `clk_set_rate()`,
`nxp_fspi_clk_prep_enable()`, `nxp_fspi_prepare_lut()`,
`nxp_fspi_invalid()`.

### Step 5.2: TRACE CALLERS
**Record:** `nxp_fspi_exec_op` is registered in
`nxp_fspi_mem_ops.exec_op` (line 1329). Called from `spi_mem_exec_op()`
in `drivers/spi/spi-mem.c`, which is the standard path for SPI NOR flash
operations (read/program/erase). Common on NXP i.MX and Layerscape
boards using FlexSPI for boot flash.

### Step 5.3: TRACE CALLEES
**Record:** Clock disable/enable (`nxp_fspi_clk_*`), `clk_set_rate()`,
MMIO via `fspi_readl`/`fspi_writel` in LUT prep and `nxp_fspi_invalid()`
(MCR0 SWRESET).

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** MTD/spi-nor → `spi_mem_exec_op()` → `nxp_fspi_exec_op()` →
`nxp_fspi_select_mem()`. Reachable during normal flash I/O when chip-
select, DTR/STR mode, or `max_freq` changes between operations
(`per_op_freq = true` in mem caps). **Userspace-reachable** via flash
access (root typically, but critical for system stability).

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** ACPI path skips manual clock disable/enable
(`is_acpi_node()` early return in `nxp_fspi_clk_disable_unprep` /
`nxp_fspi_clk_prep_enable`). Bug is most severe on **Device Tree**
platforms (primary NXP embedded use case) where
`nxp_fspi_clk_disable_unprep()` actually gates clocks.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** Current 6.18.44 code:

```862:920:drivers/spi/spi-nxp-fspi.c
static void nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device
*spi,
                                const struct spi_mem_op *op)
{
        // ...
        nxp_fspi_clk_disable_unprep(f);

        ret = clk_set_rate(f->clk, rate);
        if (ret)
                return;

        ret = nxp_fspi_clk_prep_enable(f);
        if (ret)
                return;
```

```1121:1142:drivers/spi/spi-nxp-fspi.c
        nxp_fspi_select_mem(f, mem->spi, op);

        nxp_fspi_prepare_lut(f, op);
        // ... transfer ...
        nxp_fspi_invalid(f);
```

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** **Clean apply expected.** This tree lacks patch 2's MCR0
stop-mode code in `nxp_fspi_select_mem()`, so the backport is actually
simpler than upstream context. No conflicting changes found.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** Patch 1 (`51c52e493346f`) present. This error-propagation
fix is **not** present. No duplicate fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **drivers/spi** — NXP FlexSPI (`CONFIG_SPI_NXP_FLEXSPI`,
depends on `ARCH_MXC || ARCH_LAYERSCAPE`). **IMPORTANT** for embedded
NXP platforms (boot flash, MTD); not universal core code, but critical
where enabled.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Active in 6.18.y — recent backports include `51c52e493346f`,
`c1c2871f33360`, `40ad64ac25bb7`.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** Users of `CONFIG_SPI_NXP_FLEXSPI` on i.MX
(8MM/MP/QXP/DXL/ULP/95) and Layerscape (LX2160A) platforms with DT-based
clock control.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** Any SPI-mem operation requiring chip-select or clock/mode
reconfiguration when `clk_set_rate()` or `nxp_fspi_clk_prep_enable()`
fails (unsupported rate, CCM/clock driver error, resource pressure).
Uncommon but realistic; more likely after dynamic per-op frequency
changes. Privileged flash access path.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** **Synchronous external abort** on MMIO with gated clocks →
kernel oops/panic. **Severity: CRITICAL.**

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** HIGH — prevents hard kernel crash on error path.
- **Risk:** LOW — ~30 lines, error-path only, SPI maintainer committed.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Real bug with documented CRITICAL failure mode (sync external abort)
- Small, surgical, maintainer-merged fix
- Buggy code confirmed present in Linux 6.18.44
- Patch 1 of same series already backported to this tree
- Standalone application without patch 2
- Prevents crash on flash I/O error paths

**AGAINST backport:**
- No syzbot/user bug report (theoretical until clock reconfig fails)
- Affects driver-specific embedded platforms only
- Patch 2 of series not in tree (minor context difference, not a
  blocker)

**UNRESOLVED:**
- Exact upstream commit SHA not in this checkout (fix not merged here
  yet)
- No explicit `Cc: stable` in review thread found

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — logic is clear; merged by
   SPI maintainer.
2. Fixes a real bug affecting users? **PASS** — crash on FlexSPI flash
   operations.
3. Important issue? **PASS** — CRITICAL (kernel crash / external abort).
4. Small and contained? **PASS** — one file, ~32 lines.
5. No new features or APIs? **PASS** — error propagation only.
6. Can apply to the local tree? **PASS** — bug present; clean/minor-
   context apply.

### Step 9.3: EXCEPTION CATEGORIES
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug-fix backport.

### Step 9.4: DECISION RATIONALE

For **this 6.18.44 tree**, the buggy void-return pattern is live in
`spi-nxp-fspi.c`. When clock reconfiguration fails during a flash
operation, the driver continues accessing gated FlexSPI registers and
can trigger a synchronous external abort — a production-killing failure
on affected NXP hardware. The fix is minimal, obviously correct, already
vetted by the SPI maintainer, and independently applicable (patch 1 is
already here; patch 2 is not required). Risk is low; benefit is
preventing kernel crashes.

---

## Verification

- **[Phase 1]** `git describe HEAD` → v6.18.44; parsed subject, tags
  (Link, SOBs), body
- **[Phase 1]** No Fixes:/Reported-by:/Cc: stable tags
- **[Phase 2]** Read current `spi-nxp-fspi.c` lines 862–934, 1103–1147;
  confirmed void return + silent failure
- **[Phase 2]** Confirmed `nxp_fspi_invalid()` does MMIO (lines 611–622)
- **[Phase 2]** Confirmed ACPI skips manual clk disable/enable (lines
  704–705, 722–723)
- **[Phase 3]** `git log -20 -- drivers/spi/spi-nxp-fspi.c` — recent
  fspi commits
- **[Phase 3]** `git show 51c52e493346f` — patch 1/3 already backported
  to this tree
- **[Phase 3]** `git blame -L 900,950` — buggy clk path present
- **[Phase 3]** `git log --grep="propagate clock"` — fix not in tree
- **[Phase 4]** `b4 dig` — commit not in tree; usage confirmed
- **[Phase 4]** WebFetch lkml.iu.edu/2607.3/07703.html — patch 3/3
  content confirmed
- **[Phase 4]** WebFetch lists.openwall.net — series cover letter
  (patches 1–3) confirmed
- **[Phase 4]** lore.kernel.org — blocked (bot protection); used mirrors
- **[Phase 5]** `grep nxp_fspi_exec_op` — mem_ops registration at line
  1329
- **[Phase 5]** Read `spi-mem.c` `spi_mem_exec_op()` — standard flash
  path
- **[Phase 5]** Kconfig `SPI_NXP_FLEXSPI` — ARCH_MXC || ARCH_LAYERSCAPE
- **[Phase 5]** `of_device_id` — imx8*, lx2160a, imx95 compatibles
- **[Phase 6]** Buggy code verified present in 6.18.44 checkout
- **[Phase 6]** No duplicate fix in tree
- **[Phase 6]** Patch 2 (MCR0 stop mode) absent — backport simpler
- **[Phase 8]** Failure mode: synchronous external abort — CRITICAL

**YES**

 drivers/spi/spi-nxp-fspi.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index b504a5c86692a..69ab72fff19d2 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -859,8 +859,8 @@ static void nxp_fspi_dll_override(struct nxp_fspi *f)
  * Value for rest of the CS FLSHxxCR0 register would be zero.
  *
  */
-static void nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi,
-				const struct spi_mem_op *op)
+static int nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi,
+			       const struct spi_mem_op *op)
 {
 	/* flexspi only support one DTR mode: 8D-8D-8D */
 	bool op_is_dtr = op->cmd.dtr && op->addr.dtr && op->dummy.dtr && op->data.dtr;
@@ -880,7 +880,7 @@ static void nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi,
 	if ((f->selected == spi_get_chipselect(spi, 0)) &&
 	    (!!(f->flags & FSPI_DTR_MODE) == op_is_dtr) &&
 	    (f->pre_op_rate == op->max_freq))
-		return;
+		return 0;
 
 	/* Reset FLSHxxCR0 registers */
 	fspi_writel(f, 0, f->iobase + FSPI_FLSHA1CR0);
@@ -912,12 +912,19 @@ static void nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi,
 	nxp_fspi_clk_disable_unprep(f);
 
 	ret = clk_set_rate(f->clk, rate);
-	if (ret)
-		return;
+	if (ret) {
+		/*
+		 * clk_set_rate() failed with the clocks already disabled.
+		 * Re-enable them so the enable count matches what the caller's
+		 * pm_runtime_put() (runtime_suspend) will drop.
+		 */
+		nxp_fspi_clk_prep_enable(f);
+		return ret;
+	}
 
 	ret = nxp_fspi_clk_prep_enable(f);
 	if (ret)
-		return;
+		return ret;
 
 	/*
 	 * If clock rate > 100MHz, then switch from DLL override mode to
@@ -931,6 +938,8 @@ static void nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi,
 	f->pre_op_rate = op->max_freq;
 
 	f->selected = spi_get_chipselect(spi, 0);
+
+	return 0;
 }
 
 static int nxp_fspi_read_ahb(struct nxp_fspi *f, const struct spi_mem_op *op)
@@ -1118,7 +1127,16 @@ static int nxp_fspi_exec_op(struct spi_mem *mem, const struct spi_mem_op *op)
 				   FSPI_STS0_ARB_IDLE, 1, POLL_TOUT, true);
 	WARN_ON(err);
 
-	nxp_fspi_select_mem(f, mem->spi, op);
+	err = nxp_fspi_select_mem(f, mem->spi, op);
+	if (err) {
+		/*
+		 * On failure the FlexSPI clock may be left disabled, so avoid
+		 * any further register access (which would trigger a synchronous
+		 * external abort) and bail out.
+		 */
+		pm_runtime_put_autosuspend(f->dev);
+		return err;
+	}
 
 	nxp_fspi_prepare_lut(f, op);
 	/*
-- 
2.53.0

