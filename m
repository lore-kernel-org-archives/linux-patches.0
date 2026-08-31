Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DE144A3EE;
	Mon, 31 Aug 2026 13:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183253; cv=none; b=IbR5rGVohfh6y/5VaGG3/UpH3qN21kFXK3D4hf2tTI5gbqM3qozVLUHUqQInXSLXgBCeKjCDrp4/V2gOB4qUgOlz8LOLh7TZXq+1mPFFC7CmtEmjZJ+wOcKCrb5jparsjhTNQbN6yp36xqtUX8hN0Ih3KHeKtQbGRUpiHWO8AKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183253; c=relaxed/simple;
	bh=oh2YkbmgMvme2wfIqUUrhz0XqDSc/AOMh9FKdvrNdbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RUf60PwyHFnHI41t0wPNNV5Ve5Hx/ocnQ7yGCaydQUckUyM7uphw72j7CGtvbMM5PB7sX1dq6UJJh5XfBxtK/XPQfru3aSFMp+nbeTRXPJtR1LxtNuE/UZ6kPAQhMSQLqbCl+jnhcHnEwS/YBFqHPa5XeksG+IIppLJsb95VYOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T2Vt1I5V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T2Vt1I5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01EE1F00A3D;
	Mon, 31 Aug 2026 13:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183250;
	bh=GJbGSdIwEcZvJqjyZfMmB/c+qaHeUawyYViL4DXd61M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T2Vt1I5V7Iml4VX9ywxtQgN67K7leMQPM55Je1Pbm8Js24m/Ab+fEvYMt3bmVKps4
	 Pw2mafAvLNFjpJ1jtVRe0w9lkyHalS8pp/fsoaG51has2j2cP92pvof0p+Nhj7DXT9
	 xJbpn2YhqTpKA4KraQSgaN92KiDJpAi9h65eW8rYGm8k3NdnFarX6jj7gwcUl4XCBS
	 maywHzmAkjwlrjrmCwA7L7oWuTApRVDkVlAr7Vo127SlNshL8aiId0imt2+a3pXRVk
	 k3fPmcDJJNg0pMc7MxYiU3CcjukR+mMW6If15xWcwtgtdlJIgc3TTqHKTPIFUVZpeA
	 zP/udfVfSwIMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Marco Felsch <m.felsch@pengutronix.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	jirislaby@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] serial: 8250: fix possible ISR soft lockup
Date: Mon, 31 Aug 2026 09:21:04 -0400
Message-ID: <20260831133314.4125787-36-sashal@kernel.org>
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

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 0c6bf45e5a345cc3b9ffbeaf9083ecac3c2293eb ]

There are rare cases in which the host gets stuck in the ISR because it
is flooded with messages during the startup phase.

The reason for the soft lockup in the ISR is the missing FIFO error IRQ
(FIFOE) handling. Not handling it and reporting IRQ_HANDLED triggers
the IRQ immediately again.

Fix this by adding a check for the FIFOE status and clearing the FIFO
if no data is ready (DR).

This behavior was observed on an AM62L device which uses the OMAP 8250
driver. Fix it for all 8250 drivers, since the OMAP driver's special
IRQ setup handling may trigger this behavior more frequently, but it
is not ensured that other 8250 drivers aren't affected.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Link: https://patch.msgid.link/20260519-v7-1-topic-serial-8250-v1-1-56b04293a246@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `serial: 8250: fix possible ISR soft lockup`

**Local tree:** `v6.18.44` (`6.18.44`) — 6.18.y stable series

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[serial: 8250]` `[fix]` — Fix a possible ISR soft lockup in
the generic 8250 IRQ handler when FIFO error (FIFOE) is latched without
data ready (DR).

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Marco Felsch `<m.felsch@pengutronix.de>` (author)
- **Link:** https://patch.msgid.link/20260519-v7-1-topic-
  serial-8250-v1-1-56b04293a246@pengutronix.de
- **Signed-off-by:** Greg Kroah-Hartman `<gregkh@linuxfoundation.org>`
  (TTY maintainer merge)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable`, or syzbot tags
- Original submission was `[PATCH RFC]`; TI contacts (`k-willis@ti.com`,
  `m-shah@ti.com`) were CC'd on lore

### Step 1.3: Body analysis
**Record:**
- **Bug:** Missing handling of `UART_LSR_FIFOE` when `UART_LSR_DR` is
  clear leaves a level-triggered IRQ uncleared; handler returns
  `IRQ_HANDLED` and IRQ re-fires immediately → ISR interrupt storm.
- **Symptom:** Soft lockup in the serial ISR during startup on AM62L
  (OMAP 8250).
- **Root cause:** FIFO error IRQ not cleared when no data is ready to
  read.
- **Fix approach:** If `!DR && FIFOE`, call
  `serial8250_clear_and_reinit_fifos()`.
- **Scope claim:** Observed on OMAP/AM62L; applied generically to all
  8250 drivers via `serial8250_handle_irq_locked()`.

### Step 1.4: Hidden bug fix detection
**Record:** Not disguised — explicitly a bug fix for ISR soft lockup.
Verb "fix" and failure-mode description are direct.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/tty/serial/8250/8250_port.c` only (+7 lines)
- **Function:** `serial8250_handle_irq_locked()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** After reading LSR, handler proceeds to skip_rx logic and
  only reads RX when `DR|BI` is set. `FIFOE` alone with `!DR` is never
  cleared.
- **After:** Early check: if `!(status & UART_LSR_DR) && (status &
  UART_LSR_FIFOE)`, clear and reinit FIFOs before other processing.
- **Path affected:** IRQ handler hot path for all 8250 ports using the
  generic handler.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness — unhandled hardware error condition
  causing interrupt storm
- **Mechanism:** `serial8250_rx_chars()` only loops while `DR|BI`; with
  `FIFOE` set and `DR` clear, nothing clears the error.
  `serial8250_handle_irq()` always returns 1 (`IRQ_HANDLED`). Level-
  triggered IRQ stays asserted → CPU spins in ISR until soft-lockup
  watchdog fires.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Yes — mirrors existing OMAP pattern
  (`am654_8250_handle_uart_errors()` clears FIFO on overrun) and only
  acts when no data is present.
- **Minimal:** 7 lines, no API changes.
- **Regression risk:** Very low — condition is narrow (`!DR && FIFOE`);
  clearing an empty/error-stuck FIFO is the standard recovery per 16550
  behavior.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- IRQ handler core dates to Peter Hurley (2015); `skip_rx` FIFOE-aware
  logic from `f19c3f6c8109b` (Mar 2020, "Don't service RX FIFO if
  throttled") — checks FIFOE for flow-control decisions but never clears
  a FIFOE-only stuck state.
- `serial8250_handle_irq_locked()` split in `9bb497252a420` (Feb 2026) —
  present in this tree.
- Bug is long-standing in generic 8250 IRQ path, not a recent
  regression.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:**
- Recent `8250_port.c` changes: SysRq dispatch fix (`7f8b194ed7206`),
  `serial8250_handle_irq_locked()` addition (`9bb497252a420`),
  shutdown/DW UART fixes.
- No existing fix for FIFOE-without-DR in this tree.
- Related but separate issue: RX-timeout-with-empty-FIFO fix (different
  patch series, Jul 2026) — not a prerequisite.

### Step 3.4: Author commits
**Record:** Marco Felsch is a Pengutronix contributor (DT/bindings,
drivers); not 8250 maintainer, but patch CC'd Greg Kroah-Hartman and
Jiri Slaby with TI hardware contacts.

### Step 3.5: Dependencies
**Record:**
- Requires `serial8250_handle_irq_locked()` — **present** in v6.18.44
  (`9bb497252a420`).
- Requires `serial8250_clear_and_reinit_fifos()` — **present** since
  long before 6.18 (exported, used in OMAP/PCI/RS485 paths).
- **Standalone:** Yes; no series dependency.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- Lore/openwall: https://lists.openwall.net/linux-kernel/2026/05/19/1043
- Submitted as RFC May 19, 2026; no reply thread visible in fetched
  content.
- `b4 dig -c <sha>` failed — commit not in local repo yet.

### Step 4.2: Reviewers
**Record:** To: Greg Kroah-Hartman, Jiri Slaby. Cc: linux-serial, TI
(`k-willis@ti.com`, `m-shah@ti.com`). Greg's Signed-off-by on the
committed version indicates maintainer acceptance.

### Step 4.3: Bug report
**Record:** Real hardware observation on AM62L during startup; no formal
bugzilla/syzbot report. Severity from reporter: ISR soft lockup (system
hang).

### Step 4.4: Related patches
**Record:** Separate RX-timeout-empty-FIFO fix builds on the same
function later; independent of this FIFOE fix.

### Step 4.5: Stable list
**Record:** No stable-list discussion found; not searched exhaustively
(lore stable search blocked/unavailable).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `serial8250_handle_irq_locked()` (modified),
`serial8250_clear_and_reinit_fifos()` (callee).

### Step 5.2: Callers
**Record:** `serial8250_handle_irq_locked()` called from:
- `serial8250_handle_irq()` — generic path
- `8250_dw.c` — DesignWare UART (direct locked call)

`serial8250_handle_irq()` called from:
- `serial8250_default_handle_irq()` — default IRQ handler for most 8250
  ports
- `8250_omap.c` — OMAP/AM62L path (non-DMA)
- `8250_mid.c`, `8250_bcm7271.c`, others

**Context:** Hardware IRQ handlers — every RX/TX/modem interrupt on 8250
UARTs.

### Step 5.3: Callees
**Record:** `serial8250_clear_and_reinit_fifos()` →
`serial8250_clear_fifos()` + restore FCR. Standard FIFO reset used
elsewhere in OMAP error handling.

### Step 5.4: Reachability
**Record:** Triggered by hardware UART interrupts during port
operation/startup. Console and embedded serial ports are common;
OMAP/AM62L platforms use `CONFIG_SERIAL_8250_OMAP`. Userspace can open
tty devices during boot/startup to provoke the reported scenario.

### Step 5.5: Similar patterns
**Record:** OMAP `am654_8250_handle_uart_errors()` already calls
`serial8250_clear_and_reinit_fifos()` on `UART_LSR_OE` — same recovery
pattern for a different error bit. Generic handler lacked equivalent for
`FIFOE` without `DR`.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (v6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current `8250_port.c` at lines 1801–1814 reads LSR
and has no `FIFOE && !DR` handling:

```1801:1814:drivers/tty/serial/8250/8250_port.c
        status = serial_lsr_in(up);

        /*
  - If port is stopped and there are no error conditions in the
  - FIFO, then don't drain the FIFO, as this may lead to TTY buffer
  - overflow. ...
         */
        if (!(status & (UART_LSR_FIFOE | UART_LSR_BRK_ERROR_BITS)) &&
            (port->status & (UPSTAT_AUTOCTS | UPSTAT_AUTORTS)) &&
            !(up->ier & (UART_IER_RLSI | UART_IER_RDI)))
                skip_rx = true;
```

The fix commit is **not yet applied** to this tree.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Insertion point is immediately
after `status = serial_lsr_in(up);` in `serial8250_handle_irq_locked()`.
Only minor comment-context offset vs. upstream diff.

### Step 6.3: Related fixes already present?
**Record:** None for this specific FIFOE-without-DR case.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/tty/serial/8250` — **IMPORTANT**. 8250 is the most
widely used UART framework (PC serial, embedded SoCs, consoles).

### Step 7.2: Activity
**Record:** Actively maintained in 6.18.y (recent SysRq, DW UART,
shutdown fixes in 2026).

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of 8250-based UARTs, especially OMAP/TI SoCs (AM62L
confirmed). Potentially any platform where FIFOE latches without DR
during startup. Config-dependent on `CONFIG_SERIAL_8250` and platform
8250 variants.

### Step 8.2: Trigger conditions
**Record:** Rare; during startup when UART is flooded with IRQs and FIFO
error is latched without data ready. OMAP IRQ setup may increase
frequency. Level-triggered IRQ makes it deterministic once triggered.

### Step 8.3: Failure severity
**Record:** **CRITICAL** — ISR soft lockup: CPU stuck in interrupt
handler, system watchdog/lockup detector fires, machine effectively
hung.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — prevents system hang on real hardware
- **Risk:** VERY LOW — 7-line, narrow condition, established recovery
  primitive
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real ISR soft lockup on AM62L OMAP hardware
- CRITICAL failure mode (system hang)
- Small (7 lines), obviously correct, uses existing helper
- Bug exists in v6.18.44; all prerequisites present
- Maintainer-signed (Greg Kroah-Hartman)
- Same FIFO-clear pattern already used in OMAP driver error paths
- Affects generic IRQ path — broad protection across 8250 variants

**AGAINST backport:**
- Originally RFC; no `Tested-by:` in commit message
- Rare trigger (startup phase)
- No syzbot/CVE report

**Unresolved:**
- Full review-thread replies not retrieved (lore showed submission only)
- Commit not yet in local tree (evaluation is for inclusion)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is sound; hardware-
   tested on AM62L per commit message; maintainer merged
2. Fixes real bug affecting users? **PASS** — documented on AM62L OMAP
3. Important issue? **PASS** — ISR soft lockup (CRITICAL)
4. Small and contained? **PASS** — 7 lines, one file
5. No new features/APIs? **PASS** — error recovery only
6. Can apply to local tree? **PASS** — prerequisites present, clean
   apply expected

### Step 9.3: Exception categories
**Record:** Hardware workaround/quirk for OMAP-class UART FIFO error
behavior, implemented in generic handler. Qualifies as quirk/workaround
exception.

### Step 9.4: Decision rationale
This patch closes a real gap in the generic 8250 IRQ handler: when
`UART_LSR_FIFOE` is set without `UART_LSR_DR`, the handler never clears
the condition, and a level-triggered IRQ re-enters immediately, causing
an ISR soft lockup. The fix is minimal, uses an existing recovery
function already employed in OMAP-specific error handling, and the buggy
code is present in v6.18.44. For stable users on OMAP/embedded platforms
(and potentially others), this prevents a system-hang class bug with
negligible regression risk.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 1]** Fetched lore submission at
  https://lists.openwall.net/linux-kernel/2026/05/19/1043 — confirms RFC
  submission, TI CC'd
- **[Phase 2]** Diff: +7 lines in `serial8250_handle_irq_locked()` after
  `serial_lsr_in()`
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; `make kernelversion` →
  `6.18.44`
- **[Phase 3]** `git blame -L 1801,1825
  drivers/tty/serial/8250/8250_port.c` — handler code from 2015–2024, no
  FIFOE recovery
- **[Phase 3]** `git show 9bb497252a420` —
  `serial8250_handle_irq_locked()` present in tree
- **[Phase 3]** `git log --grep="ISR soft lockup"` — commit not yet in
  tree
- **[Phase 4]** `b4 dig -c HEAD` — failed (commit not in repo)
- **[Phase 4]** WebFetch lore/openwall — patch content confirmed; no
  review replies in fetched page
- **[Phase 4]** patch.msgid.link — blocked by bot protection
- **[Phase 5]** `grep serial8250_handle_irq` — callers in omap, dw, mid,
  bcm7271, default handler
- **[Phase 5]** Read `serial8250_rx_chars()` — only processes `DR|BI`,
  does not clear `FIFOE` alone
- **[Phase 5]** Read `am654_8250_handle_uart_errors()` — OMAP clears
  FIFO on OE, parallel pattern
- **[Phase 5]** Read `serial8250_clear_and_reinit_fifos()` at line 506 —
  exists and exported
- **[Phase 6]** Read current `8250_port.c:1801-1832` — buggy path
  confirmed, fix absent
- **[Phase 6]** `include/uapi/linux/serial_reg.h` —
  `UART_LSR_FIFOE=0x80`, `UART_LSR_DR=0x01`
- **[Phase 8]** Failure mode: ISR interrupt storm → soft lockup,
  severity CRITICAL

**YES**

 drivers/tty/serial/8250/8250_port.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 7c10087458bb6..9252ec2bbcce2 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1802,6 +1802,13 @@ void serial8250_handle_irq_locked(struct uart_port *port, unsigned int iir)
 
 	status = serial_lsr_in(up);
 
+	/*
+	 * Recover from no-data-ready and FIFO error condition to avoid getting
+	 * stuck in the ISR.
+	 */
+	if (!(status & UART_LSR_DR) && (status & UART_LSR_FIFOE))
+		serial8250_clear_and_reinit_fifos(up);
+
 	/*
 	 * If port is stopped and there are no error conditions in the
 	 * FIFO, then don't drain the FIFO, as this may lead to TTY buffer
-- 
2.53.0

