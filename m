Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B611CA8F;
	Mon,  1 Apr 2024 16:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987445; cv=none; b=NMeApVaR7DBIkiPFC5A2KCcQzA8SyiNDox37bOD27D7AuJJJG/74cIYVhbxZMM6rnRYYJGsyvCg4fPuu4wOIaDTxrbN6Hj3+J+Mh/XSDPwQCHzP/34PzzJH4UhKWKSFUVuxUB0xZFiSO4PNhTvsVp/B/i75Vbmu4y4zqd+CkZc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987445; c=relaxed/simple;
	bh=46FsSdNxy+EA5uQtUr1rZaRORPCJehdmb4l2KgQRrkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6c1ihF3kRJ2LrUlEbPWbc6d/ApUkjyAe3J0Ky3ypFuZnp7Ag/DcfVrNTqq3Qs5C3HwBhR7SkoD+u4tM7k6Do3OqFfIZSxohHjzqpYycOpaFFu2cK0rh36FsOoTNLCpdHTMgT4oZrLnm52tbZQwX+naYOJFRD8PJMHpMdgez2ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INwmYtfk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INwmYtfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EDAC433C7;
	Mon,  1 Apr 2024 16:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987445;
	bh=46FsSdNxy+EA5uQtUr1rZaRORPCJehdmb4l2KgQRrkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INwmYtfkPxR+Rp12sMSNBpnBoaB4/EvCLL3aXmea/6PaZSZn7bYv+N9dh77d6Rgkt
	 /ExVuReOrDG+K4P+lGQEOlnUy1SI3lek0JAjc/8+XQAAdOEkcVm5pidX4eCMT/o/q4
	 mamWBs32wypAuDIizz3fLvNtr5Y0G/5x0l5weaNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 262/399] irqchip/renesas-rzg2l: Flush posted write in irq_eoi()
Date: Mon,  1 Apr 2024 17:43:48 +0200
Message-ID: <20240401152557.008986781@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 9494fc26259c3..5285bc817dd0c 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -99,8 +99,14 @@ static void rzg2l_irq_eoi(struct irq_data *d)
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
@@ -111,8 +117,14 @@ static void rzg2l_tint_eoi(struct irq_data *d)
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



