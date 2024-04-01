Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C83C129;
	Mon,  1 Apr 2024 16:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988855; cv=none; b=ffeeTQQAmAfweD27IdZ+Hc2/VxvtXB9hxhlQAYyiUJXWlEIFnHSRhwK7ICU3yApmBXAl6wVGTRLWOIbM8bRH4T5+VhRXNTqFj+NRUtc2d/qcOsRJc0sk7i66nJgMBxXfykor2utpripz9KzwkBiYjib722b5tn8YWiKI9UdID6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988855; c=relaxed/simple;
	bh=p0lTGP+0U63X4sHeXwOjFFGCvX5NYqBu8nrttRFxCA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ual+8fS+hjpVJBJEzI4HcodPLDkj7r828G37Klw0Lffn0gstT/dlNxuvarnosd93qQMR80mhM4FD9xN7SPbUOpHLnMcfXBg4Yo3Sp/1Lv+zZFqGZJ9UnHdViwEcEDGlPNMqiibXrnQUWBTq4k6LR7Lzl2VFDevlO6MKpcVo1Nmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvjkfK7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvjkfK7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCF6C433C7;
	Mon,  1 Apr 2024 16:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988855;
	bh=p0lTGP+0U63X4sHeXwOjFFGCvX5NYqBu8nrttRFxCA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvjkfK7qLIKzsHrLg5m+eEL4VRv2gccpaEqOkDLKCSiV0QddKlyTQglR7rehyg4n2
	 IV30uxWj3prOoimlPaE0XMxpk2DRyfnkGGHlHIdFO49r0fJzV+yaAMYrX+fmFJhGSM
	 kHekhF8nXMsyoDloVhUZcgPGWd3EQlGRhZvj6mi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 308/432] irqchip/renesas-rzg2l: Flush posted write in irq_eoi()
Date: Mon,  1 Apr 2024 17:44:55 +0200
Message-ID: <20240401152602.375896010@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 3dc2b3867f219..d6514f2d51aff 100644
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



