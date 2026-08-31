Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707F24AE10A;
	Mon, 31 Aug 2026 13:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184115; cv=none; b=qImyha8m+0B0IQeUbuy0moMtcR0NmAYoEWPG91Dpt8A+Ubm11IonToeiWx4NTRkF2sYHb5/fnu64XF6tXxPxBAlpk7OIcdmYTCiqTBpi6cnmhpEBuA9GQ0heJ1EQpoNobtuSw5U28MKnJUwHYa1psBQMG5ke16n0OYWPa2U5w2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184115; c=relaxed/simple;
	bh=wkONQlJveVnXMRF87bAcPyMdv+CkVKuQayBY1/B9MHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SUXcaCOzrTKs/h16mww8MFBnzi5aYFQqKKSZY7CISrLTMRHn441hi8N2S/se4TgHEb0Nz0QED79LTbJRADS/qLHHoNEs0cufgXynr8ckHFWh23p+dka9L6NL62DizQNt6vLoDoD25YyEc1J/hGwZxuigtqZ/m20mg/iA5QyZlso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IzCdEAe2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IzCdEAe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B67D1F00A3D;
	Mon, 31 Aug 2026 13:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184113;
	bh=gcsO/YjmrI9xPTx4rYUVj9KgkrXnYbioR7BJYXuCLYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IzCdEAe2IllO1EnAb/cyMseqsuB/A2wOiAfN0FpYyVzRyiYY+m0ukOxTw1CvEmTPw
	 EudKSPBgdwXG8ICQ2yxSLcPxrOVbRVkqPEAEKB3/Xh70zVJwJo0lqF+xvfOTbdTEqV
	 4/G1c6Bs5/nhkyIWhTQWsJD+iKmHCi/hcRDwQTx9RoGjDEjX3VPt74sdgRmVaaJJhn
	 Rqi2M3y3df11pUNzqL2TGNL7fgk/6irsyrEKh97asAxkZjrCN7u/E4WQbHMysJUaHW
	 C1bn5lkxLPGyqOnlUzClZcOUmV9i9ZxC0E3H1dXj7zZlAAuR2kT6ebNRnfjHkmVOVE
	 x5u/x03CyGbAg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wang YuWei <1973615295@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] spi: dw-dma: Wait for controller idle before completing Tx
Date: Mon, 31 Aug 2026 09:28:47 -0400
Message-ID: <20260831133314.4125787-499-sashal@kernel.org>
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

From: Wang YuWei <1973615295@qq.com>

[ Upstream commit 0bcd59706aeda8a5d48ba656bab74cb26f2b423e ]

dw_spi_dma_wait_tx_done() polls dw_spi_dma_tx_busy(), which only checks
DW_SPI_SR_TF_EMPT. An empty TX FIFO merely means the last data word has
been moved into the shift register; the transfer is not complete on the
bus until DW_SPI_SR_BUSY is also cleared. As a result the wait can
return while the controller is still shifting out the final word.

Any caller that tears down or reconfigures the controller right after
the transfer can then lose the tail of the transfer.

The memory-operation path in spi-dw-core.c already waits for both
DW_SPI_SR_BUSY == 0 and DW_SPI_SR_TF_EMPT == 1. Use the same completion
condition in the DMA path so the transfer is guaranteed to be finished
on the bus before the wait returns.

Signed-off-by: Wang YuWei <1973615295@qq.com>
Link: https://patch.msgid.link/tencent_4EA7B5C94669ED4C38A5F6C1C9126E5D9106@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `spi: dw-dma: Wait for controller idle
before completing Tx`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, `VERSION = 6`,
`PATCHLEVEL = 18`, `SUBLEVEL = 44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[spi: dw-dma]` `[Wait]` — Ensure the DesignWare SPI DMA TX
completion wait does not return until the controller is fully idle on
the bus.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** `https://patch.msgid.link/tencent_4EA7B5C94669ED4C38A5F6C1C9
  126E5D9106@qq.com`
- **Cc: stable:** — not present (not a negative signal)
- **Signed-off-by:** Wang YuWei `<1973615295@qq.com>` (author)
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (SPI subsystem
  maintainer)

Notable: maintainer ack via Mark Brown's Signed-off-by; no syzbot/user
bug report.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `dw_spi_dma_tx_busy()` only checks `DW_SPI_SR_TF_EMPT`. TX
  FIFO empty means the last word entered the shift register, but the bus
  transfer is not finished until `DW_SPI_SR_BUSY` is also clear.
- **Symptom:** `dw_spi_dma_wait_tx_done()` can return early; callers
  that tear down or reconfigure the controller immediately afterward can
  truncate the final word(s) of a transfer.
- **Root cause:** Incomplete hardware status polling in the DMA TX wait
  path.
- **Fix approach:** Match the DMA path to the intended completion
  condition: idle only when `TF_EMPT=1` **and** `BUSY=0`.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — this is an explicit correctness bug fix for
premature TX completion, not cleanup or optimization.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `drivers/spi/spi-dw-dma.c` (+2 / -1)
- **Functions modified:** `dw_spi_dma_tx_busy()` only
- **Scope:** Single-file, surgical (3-line hunk)

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Hunk (dw_spi_dma_tx_busy):**
  - **Before:** `busy = !(SR & TF_EMPT)` — not busy as soon as TX FIFO
    is empty.
  - **After:** `busy = ((SR & (BUSY|TF_EMPT)) != TF_EMPT)` — busy unless
    FIFO is empty **and** controller is not shifting.
  - **Path affected:** `dw_spi_dma_wait_tx_done()` polling loop, called
    from `dw_spi_dma_transfer()` after DMA submission completes.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Category:** Logic / hardware-timing correctness fix
- **Mechanism:** On DW APB SSI, `TF_EMPT` can be set while `BUSY` is
  still set (shift register active). Old code treated that state as
  "done"; new code correctly keeps waiting.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- **Quality:** Obviously correct from DW SPI status-register semantics.
- **Minimal:** One condition change in one inline helper.
- **Regression risk:** Very low. Worst case is slightly longer wait on
  the final word; that is the intended behavior and matches hardware
  reality.
- **Note:** Commit body says mem-op path waits for both `BUSY==0` and
  `TF_EMPT==1`, but `dw_spi_ctlr_busy()` in `spi-dw-core.c` only tests
  `DW_SPI_SR_BUSY`. The DMA fix itself is still correct; the mem-op
  comparison is slightly imprecise wording.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:**
- Blame on current tree (`HEAD`): lines 282–285 introduced in
  `5d324e5159d9e` (Nov 2025 merge bringing in `spi-dw-dma.c`).
- Buggy `TF_EMPT`-only check present at `v6.15`, `v6.16`, `v6.17`,
  `v6.18`, and current `HEAD`.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag. N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:**
- Upstream fix: `0bcd59706aeda` (`spi: dw-dma: Wait for controller idle
  before completing Tx`)
- Related nearby fix on this tree: `aae4a47073b12` (NULL deref in
  timeout error logging — separate issue)
- Standalone one-patch series (v1 only); no series dependency.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Wang YuWei has no other commits in this tree's
`drivers/spi/` history. Mark Brown is SPI maintainer and applied the
patch.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No prerequisites. `git apply --check` of upstream diff
against current `spi-dw-dma.c` succeeds cleanly. Only touches
`dw_spi_dma_tx_busy()`; no dependency on newer refactors.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:**
- **b4 dig -c 0bcd59706aeda:** https://patch.msgid.link/tencent_4EA7B5C9
  4669ED4C38A5F6C1C9126E5D9106@qq.com
- **Revisions (b4 dig -a):** v1 only
- **Review feedback:** Mark Brown reply: "Applied to broonie/spi
  for-7.2. Thanks!" No NAKs, no objections, no explicit stable
  nomination in thread.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record (b4 dig -w):** To Mark Brown; Cc Jisheng Zhang, `linux-
spi@vger.kernel.org`, `linux-kernel@vger.kernel.org`. Appropriate
maintainer coverage.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No external bug report, syzbot link, or hardware-specific
reproduction email. Bug rationale is hardware-spec-based code analysis.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Single-patch series; no companion patches required.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Lore stable search not performed (lore bot protection on
WebFetch). No stable discussion found in downloaded mbox thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `dw_spi_dma_tx_busy()` (modified); caller
`dw_spi_dma_wait_tx_done()` (unchanged).

### Step 5.2: TRACE CALLERS
**Record:**
- `dw_spi_dma_wait_tx_done()` ← `dw_spi_dma_transfer()` (line 660)
- `dw_spi_dma_transfer()` ← `dws->dma_ops->dma_transfer` in `spi-dw-
  core.c:456`
- `dw_spi_transfer_one()` ← standard SPI controller transfer path during
  DMA-mapped transfers

Called during normal SPI DMA message processing, not obscure init-only
code.

### Step 5.3: TRACE CALLEES
**Record:** `dw_readl(dws, DW_SPI_SR)` — hardware status register read
only. No locks, allocations, or API changes.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:**
`userspace ioctl/write → spidev or kernel SPI client →
spi_sync/spi_async → dw_spi_transfer_one → dw_spi_dma_transfer →
dw_spi_dma_wait_tx_done → dw_spi_dma_tx_busy`

Reachable from userspace via SPI device nodes and from in-kernel SPI
clients (flash, sensors, etc.) on `CONFIG_SPI_DW_DMA` platforms.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** Mem-op wait in `spi-dw-core.c` uses `dw_spi_ctlr_busy()`
(`BUSY` only). DMA path was inconsistent and too eager. No other
instances of the same broken `TF_EMPT`-only pattern found in this file.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **Yes.** Current `HEAD` at `drivers/spi/spi-dw-
dma.c:282-285`:

```282:285:drivers/spi/spi-dw-dma.c
static inline bool dw_spi_dma_tx_busy(struct dw_spi *dws)
{
        return !(dw_readl(dws, DW_SPI_SR) & DW_SPI_SR_TF_EMPT);
}
```

Present since at least v6.15 in this repository's tags; definitely
present in v6.18.y.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** **Clean apply expected.** `git apply --check` of upstream
patch against current file succeeded. No conflicts with `aae4a47073b12`
(different lines). `ctlr` vs `host` rename in other parts of file does
not affect this hunk.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** Fix **not** present. `git merge-base --is-ancestor
0bcd59706aeda HEAD` → not an ancestor. Buggy code still at `HEAD`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** `drivers/spi/` — DesignWare SPI DMA driver. **IMPORTANT**:
widely used on embedded SoCs; SPI often backs boot flash, storage, and
sensors.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Active in 6.18.y (recent `aae4a47073b12` fix in same file).
`spi-dw-dma.c` is established infrastructure, not brand-new experimental
code in this tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** Users of DesignWare SPI with DMA enabled
(`CONFIG_SPI_DW_DMA`). Driver-specific but common on ARM/embedded
platforms using DW APB SSI.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:**
- **Trigger:** Any DMA SPI TX transfer where the wait returns after FIFO
  empty but before shift register completes.
- **Likelihood:** Real on real hardware — this is documented DW SPI
  behavior, not theoretical.
- **Userspace trigger:** Yes, via SPI userspace access or kernel drivers
  using DMA-mapped transfers.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:**
- **Failure mode:** Truncated/lost tail of SPI transfer; possible data
  corruption on SPI flash/devices, protocol errors, silent bad data.
- **Severity:** **HIGH** (data integrity / silent corruption), not
  merely cosmetic.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** HIGH — prevents real transfer truncation on common
  embedded hardware.
- **Risk:** VERY LOW — 2-line status-check correction, maintainer-
  reviewed.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Real hardware-timing bug with plausible data-corruption impact
- Buggy code confirmed in v6.18.44
- Fix is minimal, obviously correct, applies cleanly
- SPI maintainer (Mark Brown) Signed-off-by
- Affects normal DMA SPI transfer completion path
- No prerequisite commits

**AGAINST backport:**
- No user bug report or syzbot reproduction (weak negative only)
- Commit message slightly overstates mem-op path behavior (does not
  affect fix correctness)

**Unresolved:** No hardware-specific reproduction logs; impact inferred
from DW SPI register semantics and code path (sufficient for this class
of driver fix).

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — logic matches hardware;
   maintainer applied; no Tested-by but change is trivial and
   verifiable.
2. Fixes a real bug affecting users? **PASS** — premature TX completion
   can truncate transfers.
3. Important issue? **PASS** — data corruption / transfer integrity
   (HIGH).
4. Small and contained? **PASS** — 1 file, 2 lines changed.
5. No new features or APIs? **PASS** — behavior correction only.
6. Can apply to local tree? **PASS** — verified clean apply.

### Step 9.3: EXCEPTION CATEGORIES
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
driver correctness fix.

### Step 9.4: DECISION RATIONALE

For **linux-6.18.y**, the buggy `TF_EMPT`-only wait exists, the fix is
absent, the patch applies cleanly, and the failure mode (truncated SPI
DMA transfers) is materially important for stable users on DW SPI + DMA
platforms. This is exactly the kind of small, hardware-correctness fix
stable trees should carry.

---

## Verification

- [Phase 1] Parsed subject, tags, body; no Fixes/Reported-by/syzbot
- [Phase 2] Diff: 1 file, `dw_spi_dma_tx_busy()` only; logic change
  verified
- [Phase 3] `git describe HEAD` → `v6.18.44`; blame → buggy lines at
  282–285
- [Phase 3] `git cat-file` / `git grep` → buggy code at v6.15, v6.16,
  v6.17, v6.18, HEAD
- [Phase 3] Upstream commit `0bcd59706aeda` confirmed; not ancestor of
  HEAD
- [Phase 3] `git apply --check` → patch applies cleanly to current tree
- [Phase 4] `b4 dig -c 0bcd59706aeda` → lore URL found
- [Phase 4] `b4 dig -a` → v1 only
- [Phase 4] `b4 dig -w` → Mark Brown, Jisheng Zhang, linux-spi CC'd
- [Phase 4] mbox thread → Mark Brown applied; no NAKs
- [Phase 5] Call chain traced: `dw_spi_transfer_one` →
  `dw_spi_dma_transfer` → `dw_spi_dma_wait_tx_done`
- [Phase 5] `dw_spi_dma_wait_tx_done` called at `spi-dw-dma.c:660` when
  `cur_msg->status == -EINPROGRESS`
- [Phase 6] Buggy code read at `spi-dw-dma.c:282-285` on HEAD
- [Phase 6] Related fix `aae4a47073b12` present; this fix not present
- [Phase 8] Failure mode: truncated SPI TX → data corruption risk,
  severity HIGH

**YES**

 drivers/spi/spi-dw-dma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-dw-dma.c b/drivers/spi/spi-dw-dma.c
index 31063f9270924..72b85e0f683dc 100644
--- a/drivers/spi/spi-dw-dma.c
+++ b/drivers/spi/spi-dw-dma.c
@@ -281,7 +281,8 @@ static int dw_spi_dma_wait(struct dw_spi *dws, unsigned int len, u32 speed)
 
 static inline bool dw_spi_dma_tx_busy(struct dw_spi *dws)
 {
-	return !(dw_readl(dws, DW_SPI_SR) & DW_SPI_SR_TF_EMPT);
+	return (dw_readl(dws, DW_SPI_SR) &
+		(DW_SPI_SR_BUSY | DW_SPI_SR_TF_EMPT)) != DW_SPI_SR_TF_EMPT;
 }
 
 static int dw_spi_dma_wait_tx_done(struct dw_spi *dws,
-- 
2.53.0

