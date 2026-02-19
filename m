Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03BB2FF646;
	Thu, 19 Feb 2026 02:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466691; cv=none; b=RTwh+Wcxuhcbfzk3wZGh2tW5KqoayUA9GiLJtgUsPvkEtDoKJfhwiJVvMXQ/s1/mbjgX9BXQUrW0DCgFEwjGa1NlaZKV0UzZMgkeC623UKkXqxGurWcuyX4cvpKFAnlCfEeJU6YoC7wIVxM6sl8uqyP/zXdd0w/Dz8YP8GGZZVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466691; c=relaxed/simple;
	bh=JPYaRy7iWzboVkB9Lh83sxLQndZwhGP0uXEVpC7Jo84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kB8hMAxHS0wH4h9bALDEhEivYNxkI3Lx/4CnVSzUnwdwqNE+UlfoyqnYopgmjrhFv9f+QYCcIgMmooqp4+3EbrzbiO42XEyWUUzg7kXRb3nCOawY5aqNi+OlQ35u0c7J9hMnR+ybgIdqDpZoVRTUC2apODXlm1Nf3PttpXfhjn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ptDL+SIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ptDL+SIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C596DC19422;
	Thu, 19 Feb 2026 02:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466690;
	bh=JPYaRy7iWzboVkB9Lh83sxLQndZwhGP0uXEVpC7Jo84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptDL+SIyXPj21+H9G9H9rpuhlcMSN6KIRyLF6jmjQSjlbJXbZAZma/x2ukAw1+FMM
	 9b+nHl2852wSRNuARGbetDwvLMT/3//mnxm5H2psjkcIIiJ8+q9bWzXCPGqcdiYHfY
	 x/MMkp26o1gImnTgX2iDfjBZ07O8MNrzVTSIZS9nbKm0pp0/SgMCRr8tLDWi+4a2kI
	 hR7VhjNyC5GYHPGoByHn9meMWlvKxo5Asm9R0ZNXxVBJN5TjbdbLfYtjS3DVODqVWQ
	 QMv5mCztF//JaneW6FKWPtGmSel2q/aHBPNs4uqcufi5s8V4UhazBz0YcYBxHhsPgC
	 WIY85TKoriWWA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Moteen Shah <m-shah@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	jirislaby@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] serial: 8250: 8250_omap.c: Add support for handling UART error conditions
Date: Wed, 18 Feb 2026 21:03:57 -0500
Message-ID: <20260219020422.1539798-21-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Moteen Shah <m-shah@ti.com>

[ Upstream commit 623b07b370e9963122d167e04fdc1dc713ebfbaf ]

The DMA IRQ handler does not accounts for the overrun(OE) or any other
errors being reported by the IP before triggering a DMA transaction which
leads to the interrupts not being handled resulting into an IRQ storm.

The way to handle OE is to:
1. Reset the RX FIFO.
2. Read the UART_RESUME register, which clears the internal flag

Earlier, the driver issued DMA transations even in case of OE which shouldn't
be done according to the OE handling mechanism mentioned above, as we are
resetting the FIFO's, refer section: "12.1.6.4.8.1.3.6 Overrun During
Receive" [0].

[0] https://www.ti.com/lit/pdf/spruiu1

Signed-off-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260112081829.63049-2-m-shah@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Detailed Analysis

### 1. What the commit fixes

The commit fixes an **IRQ storm** on TI K3/AM654 SoCs when a UART
overrun error (OE) occurs during DMA-based UART communication. The
existing `am654_8250_handle_rx_dma()` function did not handle UART error
conditions at all:

- When an overrun occurs, the UART sets `UART_LSR_OE` in the line status
  register
- The existing code would try to start a DMA transaction despite the
  overrun condition
- Without reading the UART_OMAP_RESUME register and resetting the FIFO,
  the error interrupt flag stays set
- This causes an **interrupt storm** — the interrupt fires repeatedly
  because it was never properly acknowledged/cleared

This is a known hardware behavior documented in the TI reference manual
section "12.1.6.4.8.1.3.6 Overrun During Receive."

### 2. Does it meet stable kernel rules?

**Obviously correct**: Yes. The fix follows the TI reference manual's
prescribed overrun handling: reset RX FIFO, then read the RESUME
register. The additional error handling for FE/PE/BI follows standard
UART error clearing practices.

**Fixes a real bug**: Yes. An IRQ storm is a serious hardware-triggered
bug that can lock up the system or make it unresponsive. This has been a
known class of problems on K3 SoCs (see prior commits `b67e830d38fa9`
and `c128a1b0523b6` that fixed similar IRQ storms from different
causes).

**Important issue**: Yes. IRQ storms can cause:
- 100% CPU consumption in interrupt context
- System hangs or unresponsiveness
- Potential soft lockups / hard lockups

**Small and contained**: The change adds ~15 lines of new error handling
code, modifies 2-3 lines in the existing function, and adds one register
define. All changes are confined to a single file and a single driver.

**No new features**: Despite the subject saying "Add support", this is
really fixing missing error handling in an existing IRQ handler. It
doesn't add new functionality; it properly handles error conditions that
were being ignored.

### 3. Risk vs Benefit

**Risk**: LOW
- Changes are confined to the AM654/K3 DMA RX path only (guarded by
  `UART_HAS_EFR2` habit flag)
- The fix follows documented hardware procedures from TI's reference
  manual
- The new `am654_8250_handle_uart_errors()` function is straightforward:
  it clears error conditions by reading appropriate registers
- The condition `!(status & UART_LSR_OE)` prevents DMA on overrun, which
  is the correct behavior per the hardware documentation

**Benefit**: HIGH
- Prevents IRQ storms on K3/AM654 SoCs when UART overrun or other error
  conditions occur during DMA
- IRQ storms can make systems unusable
- This is particularly important for embedded/industrial use cases of
  AM654 SoCs

### 4. Dependencies

- Patch 2/2 in a series, but patch 1 ("Clear DMA RX running status only
  after DMA termination is done") appears independent
- The code depends on `serial8250_clear_and_reinit_fifos()` which has
  existed since early 8250 driver code
- The `am654_8250_handle_rx_dma()` function exists since commit
  `c26389f998a865` (v5.7 era), so it's present in all current stable
  trees
- The `UART_OMAP_RESUME` register define is new but it's just a constant
  (0x0B) — trivial

### 5. Concerns

The patch needs `UART_OMAP_RESUME` define which is added by this same
commit. This should apply cleanly as long as the define section hasn't
changed significantly. There may also be minor context conflicts due to
intermediate patches, but nothing fundamental.

The commit title "Add support for handling..." sounds like a feature
addition, but analysis shows it's a bug fix for missing error handling
that causes IRQ storms.

## Verification

- **git blame** confirmed `am654_8250_handle_rx_dma()` was introduced in
  commit `c26389f998a865` (2020, v5.7 era) — present in all current
  stable trees
- **git show `b67e830d38fa9`** confirmed prior IRQ storm fix on same K3
  SoCs (2021), demonstrating this is a known class of bugs
- **git show `c128a1b0523b6`** confirmed another IRQ storm fix related
  to Errata i2310 (2024), showing ongoing attention to this problem area
- **lore.kernel.org** confirmed this is patch 2/2, independent of patch
  1 (cover letter describes separate issues)
- **Grep** confirmed `serial8250_clear_and_reinit_fifos` is declared in
  `drivers/tty/serial/8250/8250.h` (available to the driver)
- **Grep** confirmed `UART_OMAP_RESUME` is not in the current codebase —
  it's introduced by this patch as a new define (0x0B register offset)
- **Read** of current `am654_8250_handle_rx_dma()` confirmed there is no
  error handling for OE/FE/PE/BI conditions — the bug exists
- **Unverified**: Whether stable trees 6.6.y or 6.1.y have any context
  conflicts that would prevent clean backport (likely minor if any)
- Greg Kroah-Hartman signed off on the commit, confirming it went
  through normal review

## Conclusion

This commit fixes a real, documented hardware bug (IRQ storm from
unhandled UART error conditions) on TI K3/AM654 SoCs. The fix is small,
contained, follows the hardware vendor's documented error handling
procedure, and addresses a serious issue (IRQ storms can make systems
unusable). The affected code (`am654_8250_handle_rx_dma`) has been in
stable trees since v5.7. This is consistent with the pattern of previous
IRQ storm fixes for this same hardware family (`b67e830d38fa9`,
`c128a1b0523b6`) that were both marked for stable backport.

**YES**

 drivers/tty/serial/8250/8250_omap.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 9e49ef48b851b..e26bae0a6488f 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -100,6 +100,9 @@
 #define OMAP_UART_REV_52 0x0502
 #define OMAP_UART_REV_63 0x0603
 
+/* Resume register */
+#define UART_OMAP_RESUME		0x0B
+
 /* Interrupt Enable Register 2 */
 #define UART_OMAP_IER2			0x1B
 #define UART_OMAP_IER2_RHR_IT_DIS	BIT(2)
@@ -119,7 +122,6 @@
 /* Timeout low and High */
 #define UART_OMAP_TO_L                 0x26
 #define UART_OMAP_TO_H                 0x27
-
 struct omap8250_priv {
 	void __iomem *membase;
 	int line;
@@ -1256,6 +1258,20 @@ static u16 omap_8250_handle_rx_dma(struct uart_8250_port *up, u8 iir, u16 status
 	return status;
 }
 
+static void am654_8250_handle_uart_errors(struct uart_8250_port *up, u8 iir, u16 status)
+{
+	if (status & UART_LSR_OE) {
+		serial8250_clear_and_reinit_fifos(up);
+		serial_in(up, UART_LSR);
+		serial_in(up, UART_OMAP_RESUME);
+	} else {
+		if (status & (UART_LSR_FE | UART_LSR_PE | UART_LSR_BI))
+			serial_in(up, UART_RX);
+		if (iir & UART_IIR_XOFF)
+			serial_in(up, UART_IIR);
+	}
+}
+
 static void am654_8250_handle_rx_dma(struct uart_8250_port *up, u8 iir,
 				     u16 status)
 {
@@ -1266,7 +1282,8 @@ static void am654_8250_handle_rx_dma(struct uart_8250_port *up, u8 iir,
 	 * Queue a new transfer if FIFO has data.
 	 */
 	if ((status & (UART_LSR_DR | UART_LSR_BI)) &&
-	    (up->ier & UART_IER_RDI)) {
+	    (up->ier & UART_IER_RDI) && !(status & UART_LSR_OE)) {
+		am654_8250_handle_uart_errors(up, iir, status);
 		omap_8250_rx_dma(up);
 		serial_out(up, UART_OMAP_EFR2, UART_OMAP_EFR2_TIMEOUT_BEHAVE);
 	} else if ((iir & 0x3f) == UART_IIR_RX_TIMEOUT) {
@@ -1282,6 +1299,8 @@ static void am654_8250_handle_rx_dma(struct uart_8250_port *up, u8 iir,
 		serial_out(up, UART_OMAP_EFR2, 0x0);
 		up->ier |= UART_IER_RLSI | UART_IER_RDI;
 		serial_out(up, UART_IER, up->ier);
+	} else {
+		am654_8250_handle_uart_errors(up, iir, status);
 	}
 }
 
-- 
2.51.0

