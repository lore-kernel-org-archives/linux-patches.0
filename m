Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0E24653C;
	Mon,  1 Apr 2024 16:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990256; cv=none; b=dWcEI41eBCzQNVSVIn3XTadq96LgT2Wm4ugn4yMaz32Twn7575ta4FPi1uJ5PkDB8q5gVOgCHbmTXoR8BRQI7g/FSaSv8UOWvWDpMX/zfNaYzuR/SSwD3zCpSD6JDO38NFyBl8upp2rME9M7xg9o3NeU/Uyn8ExCZsKEOS/QG2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990256; c=relaxed/simple;
	bh=WNBUleOudV8vW3UcbnsIqO/EkD960GtTjnl9H3etaT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f59wpCne5QvCH1CudOhLjAAG3aR4v284AY7rzbV3++GCiu7U22wvWteay0EiBji6DmroqKbJrZELckvLzS1u4aS7Qr397ZCFjZSO9KS9NBZhVSXwBx+JHC/X6R6q43wA1e7gcy7PB9dq+m64i6KsZ7AKZB7rXdtUsGUivRIAksA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bY+HTj23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bY+HTj23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8015C433C7;
	Mon,  1 Apr 2024 16:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990256;
	bh=WNBUleOudV8vW3UcbnsIqO/EkD960GtTjnl9H3etaT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bY+HTj23pu8PEHnmC+uFl0VZML8I8UeIMGikaGcw+G0c9O1WXpia8HML7rpOLkzVd
	 qzdTP+j1w7ZQ4P0OLZE2MUxHn+yvhnosbI1J3qmoyMhOTyB/WJxgNzuwjA9c40YKDk
	 nNbUuw3ftgqrrAFevEHdv2eB02+FMVTBk8xtNyeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 294/396] irqchip/renesas-rzg2l: Flush posted write in irq_eoi()
Date: Mon,  1 Apr 2024 17:45:43 +0200
Message-ID: <20240401152556.670752799@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 9eec61df55c51415409c7cc47e9a1c8de94a0522 ]

The irq_eoi() callback of the RZ/G2L interrupt chip clears the relevant
interrupt cause bit in the TSCR register by writing to it.

This write is not sufficient because the write is posted and therefore not
guaranteed to immediately clear the bit. Due to that delay the CPU can
raise the just handled interrupt again.

Prevent this by reading the register back which causes the posted write to
be flushed to the hardware before the read completes.

Fixes: 3fed09559cd8 ("irqchip: Add RZ/G2L IA55 Interrupt Controller driver")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzg2l.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-rzg2l.c b/drivers/irqchip/irq-renesas-rzg2l.c
index 8e0b15c7fe7f1..7ea646e3e287f 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -81,8 +81,14 @@ static void rzg2l_irq_eoi(struct irq_data *d)
 	 * ISCR can only be cleared if the type is falling-edge, rising-edge or
 	 * falling/rising-edge.
 	 */
-	if ((iscr & bit) && (iitsr & IITSR_IITSEL_MASK(hw_irq)))
+	if ((iscr & bit) && (iitsr & IITSR_IITSEL_MASK(hw_irq))) {
 		writel_relaxed(iscr & ~bit, priv->base + ISCR);
+		/*
+		 * Enforce that the posted write is flushed to prevent that the
+		 * just handled interrupt is raised again.
+		 */
+		readl_relaxed(priv->base + ISCR);
+	}
 }
 
 static void rzg2l_tint_eoi(struct irq_data *d)
@@ -93,8 +99,14 @@ static void rzg2l_tint_eoi(struct irq_data *d)
 	u32 reg;
 
 	reg = readl_relaxed(priv->base + TSCR);
-	if (reg & bit)
+	if (reg & bit) {
 		writel_relaxed(reg & ~bit, priv->base + TSCR);
+		/*
+		 * Enforce that the posted write is flushed to prevent that the
+		 * just handled interrupt is raised again.
+		 */
+		readl_relaxed(priv->base + TSCR);
+	}
 }
 
 static void rzg2l_irqc_eoi(struct irq_data *d)
-- 
2.43.0



