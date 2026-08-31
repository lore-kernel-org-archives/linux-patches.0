Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DCB523784;
	Mon, 31 Aug 2026 13:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183946; cv=none; b=m76ZTGrf5s1hn4k3Ic7iBWV15FVHLXUUrOAEI/KyiKMpaKAFILr1cjQfVjnXZZ1ZO5erTlzVzWOD82HKL+fDl46Yo3ZTmtNnX2+PsWioKCSmafElgthRdA1KxTPRa1ZmjmAOWifyOxFb4cXbmzyLQ/JrIydKou7bMJty/mc/Bbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183946; c=relaxed/simple;
	bh=hI+v3RdLOqP7+hhi7jivf5MIUn3GZx4JDmDXjG51kYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u3O13NmYDtbGkvblMeJRJuN7F3mLLOMY7HdMhn6KfK3RjaoU3kGfqRixOniiauSbdA4SylE+MFTtMpRfXI2hKthhk96BO/RrE87fQ5ABF5k4zn4pBgNv/3b3H2XbCwhtxxBrNqRyEotMi809OFz254KJUZcamdQbN4g8BQn2Yx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AJQLpJ6L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AJQLpJ6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9775D1F00ACF;
	Mon, 31 Aug 2026 13:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183943;
	bh=sIc59oaUWX+y+J9S60XYbLue/pJllJgUM6bZUiJhWnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJQLpJ6LntCYdAdaee84zzyFCHLw0tA1VKgrTYliDlUWia4om3s/qpOlLY3muagEO
	 nZ68KRV4Wc6FZT6Tc0ATHzJU90TnrHN/obqSvf8zO40TQ6Dwg04x0RO5Yk5V6Rev83
	 4XYwpeku9kfDZHIuAYWfvDXd1Wi3moavibe0MULol7GhMMkkwfQO8ytMyybsUxr6/5
	 XoWdHXka2eNPTTXyhIsOLy+wZJKYlMphsuPnWWGh6NlAL4vLxNGTpk+bU4TWsaqT3K
	 tpOVsLxNJQIriRH++ZkgxnkmBpbs03g8ytWagwRcBmpZb7R87UG1Qn3OtgHa1H3wXr
	 Sz3AqAjoW0eBw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-spi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] spi: xilinx: let transfers timeout in case of no IRQ
Date: Mon, 31 Aug 2026 09:27:03 -0400
Message-ID: <20260831133314.4125787-395-sashal@kernel.org>
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

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

[ Upstream commit 0f95264f49ace739d411fd9149e2b3545d741d06 ]

In case of failed HW the driver may not see an interrupt and will stuck
in waiting forever. We can avoid such situation by timing out of
transfers if the interrupt is not seen in a reasonable time.

This problem can be found on unload of ptp_ocp driver for TimeCard which
uses Xilinx SPI AXI and SPI-NOR flash memory. During tear-down process
spi-nor drivers send soft reset command which is not triggering an
interrupt stalling the unload process completely.

Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/20260610222843.782337-1-vadim.fedorenko@linux.dev
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `spi: xilinx: let transfers timeout in case
of no IRQ`

**Local tree:** `v6.18.44-1-g2736c32da98b9` (linux-6.18.y stable)
**Commit under review:** `0f95264f49ace` (mainline; **not** in this tree
yet)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[spi: xilinx]` `[let]` — Add transfer timeout when IRQ-
based completion never arrives.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Vadim Fedorenko `<vadim.fedorenko@linux.dev>`
  (author)
- **Acked-by:** Michal Simek `<michal.simek@amd.com>` (Xilinx/AMD
  maintainer)
- **Link:** https://patch.msgid.link/20260610222843.782337-1-
  vadim.fedorenko@linux.dev
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (subsystem
  maintainer, committer)
- No Fixes:, Reported-by:, Tested-by:, Cc: stable, or syzbot tags
- Notable: maintainer Ack from Xilinx/AMD; no user/fuzzer report, but
  concrete hardware scenario described

### Step 1.3: Body Analysis
**Record:**
- **Bug:** In IRQ transfer mode, if the TX-empty interrupt never fires,
  `wait_for_completion()` blocks forever.
- **Symptom:** Complete hang during `ptp_ocp` driver unload on TimeCard
  hardware (Xilinx SPI AXI + SPI-NOR). During teardown, spi-nor sends a
  soft reset that does not trigger an interrupt, stalling unload
  indefinitely.
- **Root cause:** IRQ path has no timeout; polling path already has
  stall detection (added in 2017).
- **Version info:** None explicit; bug predates `force_irq` (2023) but
  is exposed by it.

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit bug fix for an infinite-wait hang,
not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/spi/spi-xilinx.c` (+5 / -1)
- **Function:** `xilinx_spi_txrx_bufs()`
- **Scope:** Single-file surgical fix in IRQ transfer path

### Step 2.2: Code Flow Change
**Record:**
- **Hunk (IRQ path, ~line 288):**
  - **Before:** `wait_for_completion(&xspi->done)` — blocks forever if
    IRQ never arrives
  - **After:** `wait_for_completion_timeout(&xspi->done,
    secs_to_jiffies(1))` — on timeout: log error, call
    `xspi_init_hw(xspi)`, return `-ETIMEDOUT`
- **Path affected:** IRQ-based SPI transfers (`use_irq == true`),
  entered when `xspi->irq >= 0` and (`force_irq` or `remaining_words >
  buffer_size`)

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic/correctness — missing timeout on blocking wait
  (hang/deadlock class)
- **Mechanism:** `xilinx_spi_irq()` calls `complete(&xspi->done)` only
  on `XSPI_INTR_TX_EMPTY`. If that IRQ never fires (soft reset during
  teardown, failed HW), the caller blocks indefinitely. The polling path
  already detects stalls via status-register polling; the IRQ path had
  no equivalent safety net.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** High — minimal, follows established SPI subsystem pattern
- **Regression risk:** Very low — 1-second timeout is generous for SPI;
  matches `spi.c` core and many other SPI drivers; `xspi_init_hw()` is
  already used on stall detection in the same function
- **No red flags:** No API changes, no locking changes, no refactoring

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `wait_for_completion(&xspi->done)` introduced in
`5fe11cc09ce81b` (Ricardo Ribalda, 2015-01-28, "spi/xilinx: Support
cores with no interrupt"). Bug present since IRQ mode was added — long-
standing in this tree.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag. Bug is inherent to IRQ-path design, not
introduced by a single recent commit.

### Step 3.3: Related File History
**Record:**
- `5a1314fa697fc` (2017): stall detection for polling path — **in
  tree**, Cc: stable
- `939edfaa10f1d` (2025): increased stall retry count — **in tree**
- `1dd46599f83ac` (2023): `force_irq` for QSPI — **in tree**, same
  author (Fedorenko); forces IRQ path on ptp_ocp TimeCard
- `1c9246a199e19` (2026): FIFO buffer size fix — **in tree** (separate
  hang in IRQ mode, already backported)
- Standalone fix, not part of a multi-patch series

### Step 3.4: Author Context
**Record:** Vadim Fedorenko authored `force_irq` for xilinx SPI (2023)
and works on ptp_ocp/TimeCard. Michal Simek (AMD/Xilinx) Acked. Mark
Brown (SPI maintainer) committed.

### Step 3.5: Dependencies
**Record:** No dependencies. `force_irq`, `xspi_init_hw()`,
`wait_for_completion_timeout()`, and `secs_to_jiffies()` all exist in
this tree. Cherry-pick to HEAD auto-merges cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- **URL:** https://patch.msgid.link/20260610222843.782337-1-
  vadim.fedorenko@linux.dev
- **Series:** v1 only (single patch, no revisions)
- **Feedback:** Mark Brown applied to broonie/spi `for-7.2`; Michal
  Simek Acked-by in thread
- **No NAKs or objections** found in mbox
- **No explicit Cc: stable** nomination in thread

### Step 4.2: Reviewers
**Record:** CC'd: Mark Brown, Michal Simek, linux-spi@vger.kernel.org.
Subsystem maintainer and Xilinx maintainer both involved.

### Step 4.3: Bug Report
**Record:** No external bug tracker or syzbot report. Bug described from
real hardware (TimeCard/ptp_ocp unload). Severity from reporter:
complete unload hang.

### Step 4.4: Related Patches
**Record:** Related but independent from `1c9246a199e19` (FIFO size IRQ
hang). Both are IRQ-path hang fixes; neither depends on the other.

### Step 4.5: Stable List History
**Record:** No stable-list discussion found for this specific patch.
(WebFetch to lore blocked by bot protection; used b4 mbox download
instead.)

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `xilinx_spi_txrx_bufs()` (modified), `xilinx_spi_irq()`
(completes wait), `xspi_init_hw()` (recovery on timeout)

### Step 5.2: Callers
**Record:** `xilinx_spi_txrx_bufs` assigned to `xspi->bitbang.txrx_bufs`
at probe; invoked via `spi_bitbang` → `spi_sync()` for all SPI transfers
on this controller. Called from probe, normal I/O, and module-remove
teardown paths.

### Step 5.3: Callees
**Record:** `wait_for_completion_timeout()`, `xspi_init_hw()`,
`dev_err()`, `xspi->write_fn()`/`read_fn()` for register access

### Step 5.4: Call Chain / Reachability
**Record:**
```
rmmod ptp_ocp → spi-nor remove → spi_nor_soft_reset() →
spi_mem_exec_op()
  → spi_sync() → spi_bitbang → xilinx_spi_txrx_bufs() [IRQ path with
force_irq]
  → wait_for_completion() [hangs forever without fix]
```
Reachable from module unload on TimeCard hardware. Also reachable on any
IRQ-mode transfer where HW fails to assert TX-empty interrupt.

### Step 5.5: Similar Patterns
**Record:** Many SPI drivers use `wait_for_completion_timeout(...,
msecs_to_jiffies(1000))` or `secs_to_jiffies(1)`. Core `spi.c` uses
adaptive timeout with `-ETIMEDOUT` return. xilinx was an outlier using
unbounded `wait_for_completion()`.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy Code Exists?
**Record:** **Yes.** `drivers/spi/spi-xilinx.c:288` still has
`wait_for_completion(&xspi->done)`. `ptp_ocp.c:702` sets `.force_irq =
true` for TimeCard Xilinx SPI. Bug introduced 2015; exposed on TimeCard
since `force_irq` (2023).

### Step 6.2: Backport Complications
**Record:** Cherry-pick of `0f95264f49ace` onto HEAD succeeds with auto-
merge (tested). Expected: **clean apply**.

### Step 6.3: Related Fixes Already Present?
**Record:** Polling-path stall detection (`5a1314fa697fc`,
`939edfaa10f1d`) and FIFO size fix (`1c9246a199e19`) are in tree. **This
IRQ-timeout fix is not** — grep for "SPI transfer timed out" in spi-
xilinx.c returns nothing.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/spi/` — **IMPORTANT** (peripheral driver, but SPI
core path used by many devices; ptp_ocp is production timing hardware)

### Step 7.2: Subsystem Activity
**Record:** Active — 3 commits to spi-xilinx.c in 2025–2026 in this tree
(stall retries, FIFO fix, cleanups)

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of Xilinx SPI in IRQ mode — especially `ptp_ocp`
TimeCard (`force_irq = true`). Also any platform with failed/misbehaving
HW that fails to generate TX-empty IRQ. Config: driver built-in or
module; no special Kconfig beyond SPI + device.

### Step 8.2: Trigger Conditions
**Record:**
- **Primary:** `rmmod ptp_ocp` on TimeCard (soft reset during teardown)
- **Secondary:** Any IRQ-mode transfer where interrupt never fires (HW
  failure)
- **Likelihood:** Deterministic on affected hardware during unload; rare
  but catastrophic when it hits
- **Unprivileged trigger:** Module unload typically requires
  root/CAP_SYS_MODULE

### Step 8.3: Failure Mode Severity
**Record:** **CRITICAL** — unbounded hang (hung task), module cannot be
unloaded, may block reboot/shutdown. Not data corruption, but system
becomes unresponsive for that operation.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents permanent hang on module unload and HW-
  failure scenarios
- **Risk:** VERY LOW — 5-line change, established pattern, hardware
  reset on timeout matches existing stall recovery
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes real, reproducible infinite hang on ptp_ocp unload (TimeCard)
- CRITICAL severity (hung task, blocked unload)
- Minimal 5-line fix, obviously correct
- Matches SPI core and peer driver conventions
- Acked by Xilinx maintainer, committed by SPI maintainer
- Buggy code confirmed present in 6.18.44 tree
- Cherry-picks cleanly
- No dependencies, standalone patch
- Complements existing polling-path stall detection (fills IRQ-path gap)

**AGAINST backporting:**
- Affects relatively niche hardware (TimeCard/ptp_ocp with force_irq)
- No syzbot/fuzzer report
- No explicit Cc: stable nomination
- Theoretical false-timeout risk on extremely slow transfers (mitigated
  by 1-second timeout, same as rest of SPI subsystem)

**Unresolved:** None that affect the decision.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — standard timeout pattern;
   Acked-by Xilinx maintainer
2. Fixes a real bug affecting users? **PASS** — ptp_ocp unload hang on
   TimeCard
3. Important issue? **PASS** — CRITICAL hang on module unload
4. Small and contained? **PASS** — 5 lines, 1 file
5. No new features or APIs? **PASS** — error-path safety only
6. Can apply to local tree? **PASS** — cherry-pick auto-merges

### Step 9.3: Exception Categories
**Record:** N/A — standard bug fix, not device ID/quirk/DT/build/docs
exception.

### Step 9.4: Decision Rationale

For **linux-6.18.y**, the IRQ-path infinite wait is a real bug with a
concrete trigger on hardware this tree supports (`ptp_ocp` +
`force_irq`). Without the fix, `rmmod` hangs forever. The fix is
minimal, follows established SPI patterns, resets hardware on timeout
(same as existing stall path), and applies cleanly. This meets all
stable kernel criteria.

---

## Verification

- [Phase 1] `git show 0f95264f49ace`: parsed full commit message and
  tags
- [Phase 1] Acked-by Michal Simek confirmed in commit and mbox
- [Phase 2] `git show 0f95264f49ace -p`: verified +5/-1 diff in
  `xilinx_spi_txrx_bufs()`
- [Phase 2] Read `drivers/spi/spi-xilinx.c:238-336`: confirmed IRQ vs
  polling paths and existing stall handling
- [Phase 3] `git blame -L 286,292 drivers/spi/spi-xilinx.c`:
  `wait_for_completion` from 2015 (`5fe11cc09ce81b`)
- [Phase 3] `git log --oneline -20 -- drivers/spi/spi-xilinx.c`: related
  stall/FIFO/force_irq commits identified
- [Phase 3] `git merge-base --is-ancestor`: `5a1314fa697fc`,
  `1dd46599f83ac`, `939edfaa10f1d` confirmed in HEAD; `0f95264f49ace`
  NOT in HEAD
- [Phase 4] `b4 dig -c 0f95264f49ace -w`: recipients Mark Brown, Michal
  Simek, linux-spi
- [Phase 4] `b4 dig -c 0f95264f49ace -a`: single v1 patch, no revisions
- [Phase 4] `b4 dig -c 0f95264f49ace -m /tmp/spi-xilinx-timeout.mbx`:
  downloaded thread; Mark Brown applied, Michal Simek Acked, no NAKs
- [Phase 5] Read `drivers/ptp/ptp_ocp.c:693-707`: confirmed `.force_irq
  = true` for TimeCard Xilinx SPI
- [Phase 5] Read `drivers/mtd/spi-nor/core.c:3282-3304`: confirmed
  `spi_nor_soft_reset()` during remove path
- [Phase 5] Grep `wait_for_completion_timeout` in `drivers/spi/`: many
  drivers use 1-second timeout pattern
- [Phase 5] Read `drivers/spi/spi.c:1463-1471`: core SPI layer uses
  timeout + `-ETIMEDOUT`
- [Phase 6] `git describe HEAD`: v6.18.44 (linux-6.18.y)
- [Phase 6] Grep `wait_for_completion` in spi-xilinx.c: buggy line at
  :288 confirmed
- [Phase 6] Grep "SPI transfer timed out" in tree: only in spi.c, not
  spi-xilinx.c (fix not present)
- [Phase 6] `git cherry-pick --no-commit 0f95264f49ace`: auto-merge
  succeeded; reset afterward
- [Phase 8] Failure mode: infinite hang on IRQ-path transfer without
  interrupt — severity CRITICAL

**YES**

 drivers/spi/spi-xilinx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 8085571913c8b..dac6c695f0727 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -285,7 +285,11 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 
 		if (use_irq) {
 			xspi->write_fn(cr, xspi->regs + XSPI_CR_OFFSET);
-			wait_for_completion(&xspi->done);
+			if (!wait_for_completion_timeout(&xspi->done, secs_to_jiffies(1))) {
+				dev_err(&spi->dev, "SPI transfer timed out\n");
+				xspi_init_hw(xspi);
+				return -ETIMEDOUT;
+			}
 			/* A transmit has just completed. Process received data
 			 * and check for more data to transmit. Always inhibit
 			 * the transmitter while the Isr refills the transmit
-- 
2.53.0

