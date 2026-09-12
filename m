Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B24B3C583B;
	Sat, 12 Sep 2026 09:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204695; cv=none; b=e9MKEPEy3UxLrD4IrR3EdIkPEAvnYt7fEJni5CPg0q2uJH51VrwA+Yy5IdeLEgOeCChqUuwIpEo9hKs/zhoB80Q03xQopDwUNuJw/WmNWc1WnCiBNTpCqjz0Uy37xeok97FyARtNkOpirdcz7AHmjcm5OD4jcR/bMUAh9oD0H80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204695; c=relaxed/simple;
	bh=WgfrRzUJwb0zf9lSs01kGLxFpCDeHIOg//z7DmOh+9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUUIwGWI0CAEX8HcMXB0VqtRQQBSalbA15LiXVEI3dHgYi/9JO0rDk/4oCtLAGTZRiz5xN7o4chZqXPkQyWtU8P6v5xzPSo48V+vZyF+IHOdnwRJqfMEpsD7fv5hTB8zLlGheN5H7AWz+7gp9O5Jtq1IxukpdhY+UCj3mzjKg0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWZHHYR9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWZHHYR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C2E1F000FF;
	Sat, 12 Sep 2026 09:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204693;
	bh=4LjDdsPIEY/FJMzIhpTZPbWqF8pdTBaeaROywbNHJIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HWZHHYR9yzzTgOi0PgNYhFpsNaLpMnrSXmjAADbJjO2lKD/CAgcbAPT7ju9USLr3g
	 BUogb9DBU6eCYKCGk76fOXZbDlQ3fPmJNZ1asfe6+J/mSy3Qw217oBnX0ExRw9R10s
	 LGKan4Xy+GGTU9wFHY5L9JMM+UsjNJj7WI0WKXYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Stockhausen <markus.stockhausen@gmx.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1665/1815] irqchip/irq-realtek-rtl: Add mask for interrupt handling
Date: Sat, 12 Sep 2026 08:56:55 +0200
Message-ID: <20260912065728.076926126@linuxfoundation.org>
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

From: Markus Stockhausen <markus.stockhausen@gmx.de>

[ Upstream commit 2a3fa7f31f43580edcba5ee9f97473801aa3deec ]

When using multiple domains for the Interrupt controller, each one
must know which hardware interrupts it serves. Add a mask that is
filled during setup and apply it during interrupt handling.

Signed-off-by: Markus Stockhausen <markus.stockhausen@gmx.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260605211646.2101652-5-markus.stockhausen@gmx.de
Stable-dep-of: 58b34b72b64b ("irqchip/irq-realtek-rtl: Use readl_be()/writel_be() instead of readl()/writel()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-realtek-rtl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-realtek-rtl.c b/drivers/irqchip/irq-realtek-rtl.c
index 547f21da3edc2..9f792d4cb503b 100644
--- a/drivers/irqchip/irq-realtek-rtl.c
+++ b/drivers/irqchip/irq-realtek-rtl.c
@@ -27,6 +27,7 @@
 
 struct realtek_ictl_output {
 	struct irq_domain	*domain;
+	u32			mask;
 };
 
 static DEFINE_RAW_SPINLOCK(irq_lock);
@@ -109,15 +110,17 @@ static struct irq_chip realtek_ictl_irq = {
 	.irq_set_affinity	= realtek_ictl_irq_affinity,
 };
 
-static int intc_map(struct irq_domain *d, unsigned int irq, irq_hw_number_t hw)
+static int intc_map(struct irq_domain *d, unsigned int irq, irq_hw_number_t hw_irq)
 {
+	struct realtek_ictl_output *output = d->host_data;
 	unsigned int cpu;
 
 	irq_set_chip_and_handler(irq, &realtek_ictl_irq, handle_level_irq);
 
 	guard(raw_spinlock_irqsave)(&irq_lock);
+	output->mask |= BIT(hw_irq);
 	for_each_present_cpu(cpu)
-		write_irr(cpu, hw, 1);
+		write_irr(cpu, hw_irq, 1);
 
 	return 0;
 }
@@ -136,7 +139,7 @@ static void realtek_irq_dispatch(struct irq_desc *desc)
 	unsigned int hw_irq;
 
 	chained_irq_enter(chip, desc);
-	pending = readl(REG(cpu, RTL_ICTL_GIMR)) & readl(REG(cpu, RTL_ICTL_GISR));
+	pending = readl(REG(cpu, RTL_ICTL_GIMR)) & readl(REG(cpu, RTL_ICTL_GISR)) & output->mask;
 
 	if (unlikely(!pending)) {
 		spurious_interrupt();
-- 
2.53.0



