Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46252481B8;
	Mon,  1 Apr 2024 17:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991270; cv=none; b=X0866TRF4R1ciHpdbzthWIQI33yRIoQcUDXjNf3k+GkvTeAioWUiS0K9X+zaJgLgf5W0h0jXRAl3aLcLasjza7TuymEMeQf3vg4npooxzza7zwk/wsxtApfHl4gOZ77cKJzBVxbuTJ4XSsi7tQRVXe5pT8yYBF5M+I+5W4yV7Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991270; c=relaxed/simple;
	bh=HGZHeJnL/LBnhmeMHC6FfFRZLH0x3kGQRJB3McSQ8tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmFo0Lgg75saKB79dhicq61HjcDinWl6RYlTpfNvH2sAVrgG6DvpJB3h6+xl9CKq73LbbaqL6wj3Bqa3NUP8DB7+DK/rbQhBOqlKDQgkd71oz4sCAojGcwvxktGaHEf6XHjBHjmj88XZ4Fx4oORHoCLUxo2ZQK7KPbC5IVB/jz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mgj2JFDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgj2JFDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EACC433C7;
	Mon,  1 Apr 2024 17:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991270;
	bh=HGZHeJnL/LBnhmeMHC6FfFRZLH0x3kGQRJB3McSQ8tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mgj2JFDWshHY86YwisdTsZfNt6TRrMhBYJ8RNj3KG31MAslt8D9gXCnWm7xnzgTJr
	 whTjiHoixd9h77aaZy9RKotLR5k3CLDIcKiMgisNoXx7kaC2zO/LKKhJ9Hcg1oyM1S
	 pE9AK4K99Vww4Dw4WB95ieL/YfB1KFrLbuhnYtfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 185/272] irqchip/renesas-rzg2l: Implement restriction when writing ISCR register
Date: Mon,  1 Apr 2024 17:46:15 +0200
Message-ID: <20240401152536.600557536@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 10c3e85c90c23..fbd1766f6aaa5 100644
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



