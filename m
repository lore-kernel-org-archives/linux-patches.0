Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F128D36B924;
	Sat, 12 Sep 2026 09:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204840; cv=none; b=XuI2KiCqQlTg4L0RaLtm7wXO19ggNACxD6awTNX+xz/uDB7BLe7uXYX71LeyC10tN6VGzemJpdStnvWYlqjZoF7ueLIDGggPilBFq6KNRSj6ooyhggD4qHgt9fgrywM9nIsLDT28RdyXwkkTTdI6F/JKOIVv1Ypfa6qtUD66O5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204840; c=relaxed/simple;
	bh=S0NiL2soAgeXofgcA9/nyK/C7cu55ajy7hMeVS38S1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnzHkBS76xMEHl49yoBzuki4pURb5d+FH7O7VyOd7z0EIWtyF+yoBQEt4hia0jufwv4UJTyH7N1MPzQMbbfm4HGI0WzWRl7oEb0y5H5Z0/OWEP7S2wEujU+ApvvTpF47gaS51T2QcB5J2Naq5gQI6ZR03ENGkiPPXrxEv6V+/EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOVGL/UD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOVGL/UD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA271F000FF;
	Sat, 12 Sep 2026 09:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204838;
	bh=GtJ4O5n07Plth81U1Q7g8Aa1QtCWw+0UItwjIsr+Enw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QOVGL/UD1shHG8zzwfl//uovdRLHTrKGj/ZK7LXPjTc3OKCAdkmhSdF5uvkXhPjl9
	 ot1n1QfxgRQ0auEyik6CnOShSmFuwhvU3k9/PYPFy4fgY4fNy6ER+d8NYJF1kRYyO5
	 GgArJPZzFful7SKi0QXxa3orV1lcTtDfUL0LC9oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1652/1815] irqchip/gic-v5: Defer default SPI and LPI IAFFID programming
Date: Sat, 12 Sep 2026 08:56:42 +0200
Message-ID: <20260912065727.777655547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit a1ee1a1ca75b674f503c74eb8b3ca77612ba3c0c ]

SPI and LPI interrupts do not have an architected default value for their
IAFFID (interrupt affinity ID) - the property that determines an IRQ
affinity.

Current code awkwardly tries to set a default IAFFID value corresponding
to the logical cpu executing the gicv5_hwirq_init() function at SPI/LPI
allocation time.

There are two issues with this approach:

- gicv5_hwirq_init() is called in preemptible context and current code
  uses smp_processor_id() to check the logical cpu executing the function.
  Whilst that's harmless, it can spit a splat on DEBUG_PREEMPT kernels
- Setting the default SPI/LPI IAFFID to the one belonging to the cpu
  executing the IRQ allocation is a completely arbitrary choice

It is saner to remove the SPI/LPI IAFFID set-up in the SPI/LPI domain IRQ
allocation code and flag SPI/LPI irqchips as IRQCHIP_AFFINITY_PRE_STARTUP
so that the SPI/LPI affinity is initialized by IRQ core to a sane value
before an IRQ is started up using the respective irq_chip
irq_set_affinity() callback.

Fixes: 5cb1b6dab2de ("irqchip/gic-v5: Add GICv5 IRS/SPI support")
Fixes: 0f0101325876 ("irqchip/gic-v5: Add GICv5 LPI/IPI support")
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260812-gicv5-7-2-fixes-v1-7-3743e82c69a4@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 4f5d1eebb4fa1..d6f1c0c8b7473 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -87,25 +87,13 @@ static void gicv5_ppi_priority_init(void)
 
 static void gicv5_hwirq_init(irq_hw_number_t hwirq, u8 priority, u8 hwirq_type)
 {
-	u64 cdpri, cdaff;
-	u16 iaffid;
-	int ret;
+	u64 cdpri;
 
 	if (hwirq_type == GICV5_HWIRQ_TYPE_LPI || hwirq_type == GICV5_HWIRQ_TYPE_SPI) {
 		cdpri = FIELD_PREP(GICV5_GIC_CDPRI_PRIORITY_MASK, priority)	|
 			FIELD_PREP(GICV5_GIC_CDPRI_TYPE_MASK, hwirq_type)	|
 			FIELD_PREP(GICV5_GIC_CDPRI_ID_MASK, hwirq);
 		gic_insn(cdpri, CDPRI);
-
-		ret = gicv5_irs_cpu_to_iaffid(smp_processor_id(), &iaffid);
-
-		if (WARN_ON_ONCE(ret))
-			return;
-
-		cdaff = FIELD_PREP(GICV5_GIC_CDAFF_IAFFID_MASK, iaffid)		|
-			FIELD_PREP(GICV5_GIC_CDAFF_TYPE_MASK, hwirq_type)	|
-			FIELD_PREP(GICV5_GIC_CDAFF_ID_MASK, hwirq);
-		gic_insn(cdaff, CDAFF);
 	}
 }
 
@@ -548,6 +536,7 @@ static const struct irq_chip gicv5_spi_irq_chip = {
 	.irq_get_irqchip_state	= gicv5_spi_irq_get_irqchip_state,
 	.irq_set_irqchip_state	= gicv5_spi_irq_set_irqchip_state,
 	.flags			= IRQCHIP_SET_TYPE_MASKED |
+				  IRQCHIP_AFFINITY_PRE_STARTUP |
 				  IRQCHIP_SKIP_SET_WAKE	  |
 				  IRQCHIP_MASK_ON_SUSPEND,
 };
@@ -561,7 +550,8 @@ static const struct irq_chip gicv5_lpi_irq_chip = {
 	.irq_retrigger		= gicv5_lpi_irq_retrigger,
 	.irq_get_irqchip_state	= gicv5_lpi_irq_get_irqchip_state,
 	.irq_set_irqchip_state	= gicv5_lpi_irq_set_irqchip_state,
-	.flags			= IRQCHIP_SKIP_SET_WAKE	  |
+	.flags			= IRQCHIP_AFFINITY_PRE_STARTUP |
+				  IRQCHIP_SKIP_SET_WAKE	  |
 				  IRQCHIP_MASK_ON_SUSPEND,
 };
 
-- 
2.53.0



