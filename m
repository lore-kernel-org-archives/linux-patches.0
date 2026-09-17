Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0072A3B3BE2;
	Thu, 17 Sep 2026 16:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663920; cv=none; b=pHPllQMmYXeaT1xie/kqneRJkq939VZnVUcwXuill1QXQEF+Q1VMY85o5b5kLXjaYns6RX8ZVmrgOHK9SR07SQhhAt/Z+xzgMhMYqv2X6RVJVLpZ374FCeNRKaeFsPMKk6gNgVuHWO0b2nPH8fYjjlWiDBfRaAx0qhUpRF0zAb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663920; c=relaxed/simple;
	bh=ncKyV4R99/SsSe6BSxFhFl3U17vu4QVnzTxgRXT6ksE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcxRFkYz4ttM0q4sxhvPIP6ycsJq4T2boVoXQq1F+3wxf4NzKmda1Clqx7cGKEjFUVqvek65x0urjdVtL9KWcxE2A0BnYDlCeVZrmBo7FsSGk5wNvw2YRvy9W/lxl5yNvrdJR9B7/O0/euaA4MVHthnyEz3DTxnEM8q9EPFL1TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HiTFThPp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiTFThPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1391F1F00893;
	Thu, 17 Sep 2026 16:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663918;
	bh=K9cv/e7y5vZiOqJAr3oN24Dg9o9kZ8wis9O7vWU9utE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HiTFThPpsxRWixBkDm8xXS11ASdTWN6MQOGRIr7Q78dE6oB1Z+Rv8soZuw11s6B8F
	 wMBODJ3ZbjJiGfiZT/gWjp2DJECH6b0WNdUKK3P/5HdUqrq43I2q1if3rjANn55Ary
	 XXf4AnUkXjiOFwiiGZvMzt89qDhNYUvJuRjTsDuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0198/1250] irqchip/gic-v5: Immediately exec priority drop following activate
Date: Thu, 17 Sep 2026 15:59:53 +0100
Message-ID: <20260917151557.484664620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Bischoff <sascha.bischoff@arm.com>

[ Upstream commit abf60331ebe9a9a7937a72aac7699c2907ab9307 ]

With GICv5 an interrupt of equal or lower priority cannot be signalled
until there has been a priority drop. This is done via the GIC CDEOI
system instruction. Once this has been executed, the hardware is able
to signal the next interrupt if there is one.

As all interrupts are programmed to have the same priority, no new
interrupts can be signalled until the priority drop has happened. This
can cause issues when, for example, an interrupt remains active while
a long running process takes place, such as when injecting a physical
interrupt into a guest VM in software.

The GICv5 driver has so far done the priority drop as part of
irq_eoi(), i.e., at the same time as deactivating the interrupt. This
means that any long running process (or VM) could block incoming
interrupts, effectively causing a denial of service for all other
interrupts.

Rather than doing the EOI as part of irq_eoi() (which the name would
suggest would be a good place for it), move it to happen immediately
after acknowledging an interrupt in the main GICv5 interrupt
handler. The deactivation of interrupts (GIC CDDI) remains implemented
as part of irq_eoi(), which means that the same interrupt cannot be
signalled a second time until deactivated by software.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Link: https://lore.kernel.org/r/20260520091949.542365-18-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index ebeb26b25dac8..222ef50acf100 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -207,17 +207,13 @@ static void gicv5_hwirq_eoi(u32 hwirq_id, u8 hwirq_type)
 	       FIELD_PREP(GICV5_GIC_CDDI_TYPE_MASK, hwirq_type);
 
 	gic_insn(cddi, CDDI);
-
-	gic_insn(0, CDEOI);
 }
 
 static void gicv5_ppi_irq_eoi(struct irq_data *d)
 {
 	/* Skip deactivate for forwarded PPI interrupts */
-	if (irqd_is_forwarded_to_vcpu(d)) {
-		gic_insn(0, CDEOI);
+	if (irqd_is_forwarded_to_vcpu(d))
 		return;
-	}
 
 	gicv5_hwirq_eoi(d->hwirq, GICV5_HWIRQ_TYPE_PPI);
 }
@@ -917,6 +913,13 @@ static void __exception_irq_entry gicv5_handle_irq(struct pt_regs *regs)
 	 */
 	isb();
 
+	/*
+	 * Ensure that we can receive the next interrupts in the event that we
+	 * have a long running handler or directly enter a guest by doing the
+	 * priority drop immediately.
+	 */
+	gic_insn(0, CDEOI);
+
 	hwirq = FIELD_GET(GICV5_HWIRQ_INTID, ia);
 
 	handle_irq_per_domain(hwirq);
-- 
2.53.0



