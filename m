Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D5533993;
	Thu, 15 Jan 2026 17:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496876; cv=none; b=LoMqbQlhtha7/RroMCmY4ppWI+Y1DLTgSSjgtXxZSzTvMFWv2FDaNdfxgQpYJwjY76YjsawI/BLVTXhp5vHa4zqfp5NSE/M4mPfzK92A2qG1pC+Mp/aHyXAio6ulqPvj5I1VlhXkATnycALktJ5npifGz97uO5KY8GPjdyvOuBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496876; c=relaxed/simple;
	bh=NZTIBIQbOT3evKUB+HvE0/auFrc8SJSDmk1snGMsiHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q1KttiIVPV3GX4mm5UObhDkPYVr/3qZUW1IdrcsAemTAxB+u4e8GnOBF1LsLW75xh07p+0s6CrKjGqsAod7Hr45Dx1M4KCjZi1ZBzIQXRNPWMkfUJTLF61KNz4oC7L5W/ykOVmd29zko/IDhFgaj+fI1XalE37HThK2mjtRdiNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqqnCjgQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqqnCjgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383E5C116D0;
	Thu, 15 Jan 2026 17:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496875;
	bh=NZTIBIQbOT3evKUB+HvE0/auFrc8SJSDmk1snGMsiHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqqnCjgQ6XZsclNvxVS5epryxGj0yEFNYGxVufaFeBPGQvCXc/d9lAd0Kp2rpayaW
	 4eWpD+wLCZg/3s4Y5yN6SoBbwMGvw+3tXW5pTmBBQIjWv+kqqrjNYd8qmHazBVQKLD
	 B3tq1/hjVu1oowCIkeq7X+eM/NRGI2himVravgIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ernest Van Hoecke <ernest.vanhoecke@toradex.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 47/88] gpio: pca953x: handle short interrupt pulses on PCAL devices
Date: Thu, 15 Jan 2026 17:48:30 +0100
Message-ID: <20260115164148.012666868@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ernest Van Hoecke <ernest.vanhoecke@toradex.com>

[ Upstream commit 014a17deb41201449f76df2b20c857a9c3294a7c ]

GPIO drivers with latch input support may miss short pulses on input
pins even when input latching is enabled. The generic interrupt logic in
the pca953x driver reports interrupts by comparing the current input
value against the previously sampled one and only signals an event when
a level change is observed between two reads.

For short pulses, the first edge is captured when the input register is
read, but if the signal returns to its previous level before the read,
the second edge is not observed. As a result, successive pulses can
produce identical input values at read time and no level change is
detected, causing interrupts to be missed. Below timing diagram shows
this situation where the top signal is the input pin level and the
bottom signal indicates the latched value.

─────┐     ┌──*───────────────┐     ┌──*─────────────────┐     ┌──*───
     │     │  .               │     │  .                 │     │  .
     │     │  │               │     │  │                 │     │  │
     └──*──┘  │               └──*──┘  │                 └──*──┘  │
Input   │     │                  │     │                    │     │
        ▼     │                  ▼     │                    ▼     │
       IRQ    │                 IRQ    │                   IRQ    │
              .                        .                          .
─────┐        .┌──────────────┐        .┌────────────────┐        .┌──
     │         │              │         │                │         │
     │         │              │         │                │         │
     └────────*┘              └────────*┘                └────────*┘
Latched       │                        │                          │
              ▼                        ▼                          ▼
            READ 0                   READ 0                     READ 0
                                   NO CHANGE                  NO CHANGE

PCAL variants provide an interrupt status register that records which
pins triggered an interrupt, but the status and input registers cannot
be read atomically. The interrupt status is only cleared when the input
port is read, and the input value must also be read to determine the
triggering edge. If another interrupt occurs on a different line after
the status register has been read but before the input register is
sampled, that event will not be reflected in the earlier status
snapshot, so relying solely on the interrupt status register is also
insufficient.

Support for input latching and interrupt status handling was previously
added by [1], but the interrupt status-based logic was reverted by [2]
due to these issues. This patch addresses the original problem by
combining both sources of information. Events indicated by the interrupt
status register are merged with events detected through the existing
level-change logic. As a result:

* short pulses, whose second edges are invisible, are detected via the
  interrupt status register, and
* interrupts that occur between the status and input reads are still
  caught by the generic level-change logic.

This significantly improves robustness on devices that signal interrupts
as short pulses, while avoiding the issues that led to the earlier
reversion. In practice, even if only the first edge of a pulse is
observable, the interrupt is reliably detected.

This fixes missed interrupts from an Ilitek touch controller with its
interrupt line connected to a PCAL6416A, where active-low pulses are
approximately 200 us long.

[1] commit 44896beae605 ("gpio: pca953x: add PCAL9535 interrupt support for Galileo Gen2")
[2] commit d6179f6c6204 ("gpio: pca953x: Improve interrupt support")

Fixes: d6179f6c6204 ("gpio: pca953x: Improve interrupt support")
Signed-off-by: Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20251217153050.142057-1-ernestvanhoecke@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 6b9bfdebadb5a..120d6695a4b55 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -840,14 +840,35 @@ static bool pca953x_irq_pending(struct pca953x_chip *chip, unsigned long *pendin
 	DECLARE_BITMAP(old_stat, MAX_LINE);
 	DECLARE_BITMAP(cur_stat, MAX_LINE);
 	DECLARE_BITMAP(new_stat, MAX_LINE);
+	DECLARE_BITMAP(int_stat, MAX_LINE);
 	DECLARE_BITMAP(trigger, MAX_LINE);
 	DECLARE_BITMAP(edges, MAX_LINE);
 	int ret;
 
+	if (chip->driver_data & PCA_PCAL) {
+		/* Read INT_STAT before it is cleared by the input-port read. */
+		ret = pca953x_read_regs(chip, PCAL953X_INT_STAT, int_stat);
+		if (ret)
+			return false;
+	}
+
 	ret = pca953x_read_regs(chip, chip->regs->input, cur_stat);
 	if (ret)
 		return false;
 
+	if (chip->driver_data & PCA_PCAL) {
+		/* Detect short pulses via INT_STAT. */
+		bitmap_and(trigger, int_stat, chip->irq_mask, gc->ngpio);
+
+		/* Apply filter for rising/falling edge selection. */
+		bitmap_replace(new_stat, chip->irq_trig_fall, chip->irq_trig_raise,
+			       cur_stat, gc->ngpio);
+
+		bitmap_and(int_stat, new_stat, trigger, gc->ngpio);
+	} else {
+		bitmap_zero(int_stat, gc->ngpio);
+	}
+
 	/* Remove output pins from the equation */
 	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
 
@@ -861,7 +882,8 @@ static bool pca953x_irq_pending(struct pca953x_chip *chip, unsigned long *pendin
 
 	if (bitmap_empty(chip->irq_trig_level_high, gc->ngpio) &&
 	    bitmap_empty(chip->irq_trig_level_low, gc->ngpio)) {
-		if (bitmap_empty(trigger, gc->ngpio))
+		if (bitmap_empty(trigger, gc->ngpio) &&
+		    bitmap_empty(int_stat, gc->ngpio))
 			return false;
 	}
 
@@ -869,6 +891,7 @@ static bool pca953x_irq_pending(struct pca953x_chip *chip, unsigned long *pendin
 	bitmap_and(old_stat, chip->irq_trig_raise, new_stat, gc->ngpio);
 	bitmap_or(edges, old_stat, cur_stat, gc->ngpio);
 	bitmap_and(pending, edges, trigger, gc->ngpio);
+	bitmap_or(pending, pending, int_stat, gc->ngpio);
 
 	bitmap_and(cur_stat, new_stat, chip->irq_trig_level_high, gc->ngpio);
 	bitmap_and(cur_stat, cur_stat, chip->irq_mask, gc->ngpio);
-- 
2.51.0



