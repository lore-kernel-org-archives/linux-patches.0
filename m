Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2578634752E;
	Sat, 12 Sep 2026 11:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211800; cv=none; b=l3wuSV+eqlxWhKeNNUmJ+APajUnjHnmJ3V8uFs68waqM+JiFloBAddwfX8C8Q1lI4f1S26/TiCJkRWznnW1zgA4gxcXW6jDC5T/99uhzHrR5VRDTmyUqDeb9bo/7/Tw0T5ommf6GslDaXSSzy086elzhqafeKJ1QWWMwtR/Mm58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211800; c=relaxed/simple;
	bh=861OJttSxw2QVkLTwZ04ZXlltCM51gVpzie/OFx2fpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVS9DJdqFUZdKuV9Fmie7l52cVtZRWm0AjfoY5iCP+CqRpncWN6Sd4StkJeRzei+/JjOk9t3p1j51Jf8yR1A/Wkdqyk5ZeLRYyDmSBrQIyhE0L5Aye4JM8bIYknHYi7cr2WW+ekASAEg1gxSod70vWpoIA9WozUkzKCS8Q0rPtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mvrAdr6r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mvrAdr6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC91D1F000FF;
	Sat, 12 Sep 2026 11:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211799;
	bh=GRh6zp1RznhPYRowk4UKhYbqieuOGGuNkU0Bv/pUeHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mvrAdr6rIuNIkTf808ylSkxKwj5oKRJvAFUPZlJ86J9KyYmbtcRnMQ1mhfuABPnRe
	 Cs713IdPe2UrylgvodgsNIjaKlvUjQwP0i8R8yXEjZVbmbqyhbTJmdw+7g1PeatcLe
	 laWU59+/XVNV1ukamaXQHxcr/D3cSJqkWBLz41s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1305/1518] irqchip/renesas-rzg2l: Fix loss of interrupt
Date: Sat, 12 Sep 2026 08:57:54 +0200
Message-ID: <20260912065653.044550461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 50b10bd0c2d721ad38abd1abe3acdefb6caa0944 ]

rzg2l_clear_irq_int() and rzg2l_clear_tint_int() perform a
read-modify-write on the ISCR/TSCR status registers to clear the bit
for the interrupt just handled. Since these registers are
write-0-to-clear per bit, this is racy:

If another interrupt's status bit gets set between the read and the write,
that bit is written back as 0 by the software-constructed value, clearing
an interrupt that hasn't been serviced yet and losing it.

This can be reproduced by triggering multiple interrupts at once, e.g.:

  gpioset -c gpiochip0 355=0 353=0 328=0 352=0

Fix this by writing back only the bit being cleared, with all other bits
set to 1, instead of read-modify-writing the whole register.  Since 1-bits
are left unchanged by hardware, concurrently-set status bits for other
interrupts are preserved.

Fixes: 3fed09559cd8 ("irqchip: Add RZ/G2L IA55 Interrupt Controller driver")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260818110937.5816-1-biju.das.jz@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzg2l.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-rzg2l.c b/drivers/irqchip/irq-renesas-rzg2l.c
index c938ab1592895..41ab8916187ec 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -103,7 +103,7 @@ static void rzg2l_clear_irq_int(struct rzg2l_irqc_priv *priv, unsigned int hwirq
 	 * falling/rising-edge.
 	 */
 	if ((iscr & bit) && (iitsr & IITSR_IITSEL_MASK(hw_irq))) {
-		writel_relaxed(iscr & ~bit, priv->base + ISCR);
+		writel_relaxed(~bit, priv->base + ISCR);
 		/*
 		 * Enforce that the posted write is flushed to prevent that the
 		 * just handled interrupt is raised again.
@@ -119,7 +119,7 @@ static void rzg2l_clear_tint_int(struct rzg2l_irqc_priv *priv, unsigned int hwir
 
 	reg = readl_relaxed(priv->base + TSCR);
 	if (reg & bit) {
-		writel_relaxed(reg & ~bit, priv->base + TSCR);
+		writel_relaxed(~bit, priv->base + TSCR);
 		/*
 		 * Enforce that the posted write is flushed to prevent that the
 		 * just handled interrupt is raised again.
-- 
2.53.0



