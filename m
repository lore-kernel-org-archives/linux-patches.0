Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5557263E;
	Mon,  1 Apr 2024 16:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990253; cv=none; b=EoGII9p0BvRl26cOTUd6/3QhGTkaYNgWyTk8WK3RWruN61JNXivtR1fJG79aNvQnYbgRU/1dpYTTi33OjLaqRKbEDT+x+XjMFZpfmM27wHWWPQ9i1wf+NyK0T0vT/OxnhOdb0JXYFalYUYc5w+NTH4jrOpZ9ohbx9uT6EY5p01A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990253; c=relaxed/simple;
	bh=GSXeu6m9dIiKdjj9DkDEP0ZdM2h+XkmJJbAdeT9+HQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHqxAEr1E7+Y0vsH5UvhsCEcsimvDyYh1VlMSe+mlpXQTcV7cvNtwHPuZX23+81Nhf9IS9ioD+Tvqg10tnYbNUvamcWZYQwUZCLASouye/V6rlndlf8GwsfqcH9eag8o+vrMqaBGpyxg6iKf3cQjo6PBQ44+zonNK8dMh3cBKCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFQCclWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFQCclWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE43BC433F1;
	Mon,  1 Apr 2024 16:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990253;
	bh=GSXeu6m9dIiKdjj9DkDEP0ZdM2h+XkmJJbAdeT9+HQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFQCclWwz4uEkgFLTlGfWRQhWA0I9eDC6kuTNyhp5CQU93jzgGvT+pHLOySm3gR7m
	 iXbX8J+10/SSClQKjB0PnN3YMxISRYo1V/nbmy2IYm2Xx9rHF+IK8F3kCCcf8apqWH
	 9fNr1+240Dop8pvsx3hT6rAccBp3s6WUHD6qvqf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 293/396] irqchip/renesas-rzg2l: Implement restriction when writing ISCR register
Date: Mon,  1 Apr 2024 17:45:42 +0200
Message-ID: <20240401152556.639402630@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit ef88eefb1a81a8701eabb7d5ced761a66a465a49 ]

The RZ/G2L manual (chapter "IRQ Status Control Register (ISCR)") describes
the operation to clear interrupts through the ISCR register as follows:

[Write operation]

  When "Falling-edge detection", "Rising-edge detection" or
  "Falling/Rising-edge detection" is set in IITSR:

    - In case ISTAT is 1
	0: IRQn interrupt detection status is cleared.
	1: Invalid to write.
    - In case ISTAT is 0
	Invalid to write.

  When "Low-level detection" is set in IITSR.:
        Invalid to write.

Take the interrupt type into account when clearing interrupts through the
ISCR register to avoid writing the ISCR when the interrupt type is level.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20231120111820.87398-6-claudiu.beznea.uj@bp.renesas.com
Stable-dep-of: 9eec61df55c5 ("irqchip/renesas-rzg2l: Flush posted write in irq_eoi()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzg2l.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-rzg2l.c b/drivers/irqchip/irq-renesas-rzg2l.c
index 96f4e322ed6b7..8e0b15c7fe7f1 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -72,11 +72,17 @@ static void rzg2l_irq_eoi(struct irq_data *d)
 	unsigned int hw_irq = irqd_to_hwirq(d) - IRQC_IRQ_START;
 	struct rzg2l_irqc_priv *priv = irq_data_to_priv(d);
 	u32 bit = BIT(hw_irq);
-	u32 reg;
+	u32 iitsr, iscr;
 
-	reg = readl_relaxed(priv->base + ISCR);
-	if (reg & bit)
-		writel_relaxed(reg & ~bit, priv->base + ISCR);
+	iscr = readl_relaxed(priv->base + ISCR);
+	iitsr = readl_relaxed(priv->base + IITSR);
+
+	/*
+	 * ISCR can only be cleared if the type is falling-edge, rising-edge or
+	 * falling/rising-edge.
+	 */
+	if ((iscr & bit) && (iitsr & IITSR_IITSEL_MASK(hw_irq)))
+		writel_relaxed(iscr & ~bit, priv->base + ISCR);
 }
 
 static void rzg2l_tint_eoi(struct irq_data *d)
-- 
2.43.0



