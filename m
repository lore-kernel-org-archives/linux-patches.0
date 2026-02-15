Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E2A2F5311;
	Sun, 15 Feb 2026 17:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771177289; cv=none; b=OdZ6C1QwkU4nv4Vx6J2FbkJ0o0JQnYzmfZVRDdvGvtSdVFYWJ9KYGPIUBKj9WNom32NpfYx7V6VULWitJMLT1Kz0poiYpteHfjX07nm844WHfGGn7KTVequPvdHj1vqHCfxDlGeGWT/k3rDYFz8iT9YSMLahrbMI1cFg/2CueOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771177289; c=relaxed/simple;
	bh=Puh4sgT37KZtRy3LP1iDs5Wc0tui0i2RCskJqWuY0uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OooayM32MJQXIPCOYm+5VYBsLo+M3rOxEhR2r89uKC/wijk6qrNVgDu8qj7iENjTPJyrQ5CNqpIDW+EoD3fwT9QM/SCnTwfeesaPeQTZ18MEetwRR9aNqO06U9nYGKgFJc1aNecQKl+262E/qaIF1cN/196O0IWDEe6tsOEvYrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/MunuDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/MunuDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509B3C4AF09;
	Sun, 15 Feb 2026 17:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771177289;
	bh=Puh4sgT37KZtRy3LP1iDs5Wc0tui0i2RCskJqWuY0uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/MunuDyJXkvmToAMxs0vNSjvoLfHGf/W77PI0VSpUNdtpvzVGQXxGNx9trxWWXPr
	 aw+Z+tial1Ymoc3UmqnJSWTnaPfsExqdofGvL2XHtzHng/iJYyFwmfIWe2JDOIdfzY
	 KpP6fkfmrNFX5aG+/27jEa8KRlSS22dzZh845XV48RIGDM8o3B8MPvUM+dR7hDGbSx
	 7ry107bN4PbychCVb9Rl8VwK38OPfPKM51WCAr8KMlo/xtJ/BQrpYFuQ1XTp2YscIn
	 tfvECyxPT42gEzxdUJSPmSQIdJeIFdokE+E8wGSZdzNlTVLuZQ1virzAZz6l0PIV4+
	 Qsod28svsCC5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Otto=20Pfl=C3=BCger?= <otto.pflueger@abscue.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	orsonzhai@gmail.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] mailbox: sprd: mask interrupts that are not handled
Date: Sun, 15 Feb 2026 12:41:14 -0500
Message-ID: <20260215174120.2390402-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260215174120.2390402-1-sashal@kernel.org>
References: <20260215174120.2390402-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Otto Pflüger <otto.pflueger@abscue.de>

[ Upstream commit 75df94d05fc03fd9d861eaf79ce10fbb7a548bd8 ]

To reduce the amount of spurious interrupts, disable the interrupts that
are not handled in this driver.

Signed-off-by: Otto Pflüger <otto.pflueger@abscue.de>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Comprehensive Analysis

### 1. What the Commit Does

This commit changes the interrupt mask initialization in
`sprd_mbox_startup()` for the Spreadtrum mailbox driver. The two key
changes are:

**a) Deterministic initialization instead of read-modify-write:**
- **Before:** Read the hardware's current IRQ mask register state, then
  clear specific bits to unmask desired interrupts. This left other bits
  in whatever state the hardware/bootloader had them.
- **After:** Start from the full mask constant (all interrupts masked),
  then unmask only the ones the driver actually handles. This is fully
  deterministic.

**b) Stop enabling the inbox overflow interrupt:**
- **Before:** Both `SPRD_INBOX_FIFO_OVERFLOW_IRQ` (BIT(1)) and
  `SPRD_INBOX_FIFO_DELIVER_IRQ` (BIT(2)) were unmasked. The driver only
  handles delivery interrupts.
- **After:** Only `SPRD_INBOX_FIFO_DELIVER_IRQ` is unmasked.

### 2. Bug Being Fixed

The `sprd_mbox_inbox_isr()` only checks the delivery status bits
(`SPRD_INBOX_FIFO_DELIVER_MASK`). If no delivery is pending, it returns
`IRQ_NONE` with a "spurious inbox interrupt" warning. This means:

- If the inbox overflow interrupt fires without a concurrent delivery
  event, the ISR returns `IRQ_NONE`
- Repeated `IRQ_NONE` returns trigger the kernel's spurious interrupt
  detection in `note_interrupt()` (`kernel/irq/spurious.c`), which can
  eventually **disable the entire IRQ line** with a "nobody cared"
  message
- If the inbox delivery interrupt shares the same IRQ line, disabling
  the IRQ would **break all mailbox communication**

Similarly, the old code left outbox bits 1-4 and inbox bit 0 in an
indeterminate state dependent on hardware power-on defaults, potentially
enabling additional interrupts the driver doesn't handle.

### 3. Stable Kernel Criteria Assessment

- **Obviously correct:** Yes. The change is straightforward - mask
  everything, then unmask only what the driver handles. This matches the
  `sprd_mbox_shutdown()` function which already uses
  `SPRD_INBOX_FIFO_IRQ_MASK` and `SPRD_OUTBOX_FIFO_IRQ_MASK` to mask all
  interrupts.
- **Fixes a real bug:** Yes. Spurious interrupts can lead to the kernel
  disabling the IRQ line ("nobody cared"), which would break mailbox
  functionality entirely.
- **Small and contained:** Yes. 4 insertions, 6 deletions in a single
  file, affecting one function.
- **No new features:** Correct. This only changes interrupt masking
  behavior.
- **Self-contained:** Yes. No dependency on the revision 2 commit or the
  delivery flag commit. The startup function code is unchanged between
  v6.19 and the state before this patch.

### 4. Risk Assessment

- **Risk:** Very low. The change makes the interrupt state deterministic
  and only enables interrupts the driver actually handles. The shutdown
  function already uses the same mask constants.
- **Regression potential:** Minimal. The only functional change is that
  the inbox overflow interrupt is no longer enabled - but since the ISR
  never handled it, enabling it was always a bug.
- **Scope:** Single driver (sprd-mailbox), single function, 10 lines
  changed.

### 5. Backport Applicability

The driver exists since v5.8. The buggy code in `sprd_mbox_startup()`
has been present since the driver was added (`ca27fc26cd221`). The patch
should apply cleanly to all stable trees that include this driver
(5.10.y, 5.15.y, 6.1.y, 6.6.y, etc.) as the startup function has never
been modified between the initial driver addition and this fix.

### Verification

- **Verified** that `sprd_mbox_inbox_isr()` does NOT handle overflow
  interrupts - it only checks `SPRD_INBOX_FIFO_DELIVER_MASK` and returns
  `IRQ_NONE` if no delivery is pending (lines 153-193 of the v6.19
  source).
- **Verified** that `sprd_mbox_shutdown()` already uses
  `SPRD_INBOX_FIFO_IRQ_MASK` and `SPRD_OUTBOX_FIFO_IRQ_MASK` to disable
  all interrupts (lines 269-284), confirming the mask constants are the
  correct "all masked" values.
- **Verified** the startup function is unchanged between v6.19 (HEAD)
  and the state just before this patch on master (identical code at
  lines 236-268).
- **Verified** the revision 2 commit (`c6ff944003cf1`) does NOT modify
  `sprd_mbox_startup()`, confirming this patch has no dependency on it.
- **Verified** the delivery flag commit (`c77661d60d422`) modifies
  `sprd_mbox_inbox_isr()` only, not `sprd_mbox_startup()`, confirming
  independence.
- **Verified** the driver was added in v5.8-rc1 (`ca27fc26cd221`), so it
  exists in all currently maintained stable trees (5.10+).
- **Verified** via lore.kernel.org that no reviewer concerns or NAKs
  were raised about this patch.
- **Verified** that `SPRD_INBOX_FIFO_IRQ_MASK = GENMASK(2,0) = 0x7` and
  `SPRD_OUTBOX_FIFO_IRQ_MASK = GENMASK(4,0) = 0x1F` from the source
  definitions (lines 44-52).
- **Could NOT verify** specific user reports of the "nobody cared" IRQ
  being triggered in practice (no Reported-by tag, no bug report link).
  However, the code analysis clearly shows this is possible if the
  overflow interrupt fires without a concurrent delivery.

### Summary

This is a small, self-contained bug fix that prevents spurious
interrupts from potentially disabling the entire IRQ line for the
Spreadtrum mailbox driver. The fix is obviously correct (mask what you
don't handle), has minimal risk, applies cleanly to all stable trees,
and prevents a real failure mode (kernel disabling the shared IRQ). It
meets all stable kernel criteria.

**YES**

 drivers/mailbox/sprd-mailbox.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/mailbox/sprd-mailbox.c b/drivers/mailbox/sprd-mailbox.c
index ee8539dfcef54..c1a5fe6cc8771 100644
--- a/drivers/mailbox/sprd-mailbox.c
+++ b/drivers/mailbox/sprd-mailbox.c
@@ -243,21 +243,19 @@ static int sprd_mbox_startup(struct mbox_chan *chan)
 		/* Select outbox FIFO mode and reset the outbox FIFO status */
 		writel(0x0, priv->outbox_base + SPRD_MBOX_FIFO_RST);
 
-		/* Enable inbox FIFO overflow and delivery interrupt */
-		val = readl(priv->inbox_base + SPRD_MBOX_IRQ_MSK);
-		val &= ~(SPRD_INBOX_FIFO_OVERFLOW_IRQ | SPRD_INBOX_FIFO_DELIVER_IRQ);
+		/* Enable inbox FIFO delivery interrupt */
+		val = SPRD_INBOX_FIFO_IRQ_MASK;
+		val &= ~SPRD_INBOX_FIFO_DELIVER_IRQ;
 		writel(val, priv->inbox_base + SPRD_MBOX_IRQ_MSK);
 
 		/* Enable outbox FIFO not empty interrupt */
-		val = readl(priv->outbox_base + SPRD_MBOX_IRQ_MSK);
+		val = SPRD_OUTBOX_FIFO_IRQ_MASK;
 		val &= ~SPRD_OUTBOX_FIFO_NOT_EMPTY_IRQ;
 		writel(val, priv->outbox_base + SPRD_MBOX_IRQ_MSK);
 
 		/* Enable supplementary outbox as the fundamental one */
 		if (priv->supp_base) {
 			writel(0x0, priv->supp_base + SPRD_MBOX_FIFO_RST);
-			val = readl(priv->supp_base + SPRD_MBOX_IRQ_MSK);
-			val &= ~SPRD_OUTBOX_FIFO_NOT_EMPTY_IRQ;
 			writel(val, priv->supp_base + SPRD_MBOX_IRQ_MSK);
 		}
 	}
-- 
2.51.0

