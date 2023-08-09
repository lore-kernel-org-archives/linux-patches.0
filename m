Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F319717AAB
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768C4C433C7;
	Wed,  9 Aug 2023 11:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580580;
	bh=fsQLgh5fBbSXM4GjCiryUIBMx4SSAbka1yZ9henrX1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCwrxMV2uRL6CtaCQxVp/5Z5/kywjMuKWqWHlxORuTRosJzbk94HpZKwAmi6CHGz/
	 0exBE8EM7nQS8A4vtHbcKlHWq+/oxCWDGxPzZYWiZ4E5Xpta8BZPppKwG1PrnT62op
	 x+2yvYDcHuvmQw4H3Lqit7XLp5sTnhQHcLPC7hi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/154] irq-bcm6345-l1: Do not assume a fixed block to cpu mapping
Date: Wed,  9 Aug 2023 12:41:46 +0200
Message-ID: <20230809103639.468914813@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 55ad24857341c36616ecc1d9580af5626c226cf1 ]

The irq to block mapping is fixed, and interrupts from the first block
will always be routed to the first parent IRQ. But the parent interrupts
themselves can be routed to any available CPU.

This is used by the bootloader to map the first parent interrupt to the
boot CPU, regardless wether the boot CPU is the first one or the second
one.

When booting from the second CPU, the assumption that the first block's
IRQ is mapped to the first CPU breaks, and the system hangs because
interrupts do not get routed correctly.

Fix this by passing the appropriate bcm6434_l1_cpu to the interrupt
handler instead of the chip itself, so the handler always has the right
block.

Fixes: c7c42ec2baa1 ("irqchips/bmips: Add bcm6345-l1 interrupt controller")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230629072620.62527-1-jonas.gorski@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-bcm6345-l1.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/irqchip/irq-bcm6345-l1.c b/drivers/irqchip/irq-bcm6345-l1.c
index 1bd0621c4ce2a..4827a11832478 100644
--- a/drivers/irqchip/irq-bcm6345-l1.c
+++ b/drivers/irqchip/irq-bcm6345-l1.c
@@ -82,6 +82,7 @@ struct bcm6345_l1_chip {
 };
 
 struct bcm6345_l1_cpu {
+	struct bcm6345_l1_chip	*intc;
 	void __iomem		*map_base;
 	unsigned int		parent_irq;
 	u32			enable_cache[];
@@ -115,17 +116,11 @@ static inline unsigned int cpu_for_irq(struct bcm6345_l1_chip *intc,
 
 static void bcm6345_l1_irq_handle(struct irq_desc *desc)
 {
-	struct bcm6345_l1_chip *intc = irq_desc_get_handler_data(desc);
-	struct bcm6345_l1_cpu *cpu;
+	struct bcm6345_l1_cpu *cpu = irq_desc_get_handler_data(desc);
+	struct bcm6345_l1_chip *intc = cpu->intc;
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	unsigned int idx;
 
-#ifdef CONFIG_SMP
-	cpu = intc->cpus[cpu_logical_map(smp_processor_id())];
-#else
-	cpu = intc->cpus[0];
-#endif
-
 	chained_irq_enter(chip, desc);
 
 	for (idx = 0; idx < intc->n_words; idx++) {
@@ -257,6 +252,7 @@ static int __init bcm6345_l1_init_one(struct device_node *dn,
 	if (!cpu)
 		return -ENOMEM;
 
+	cpu->intc = intc;
 	cpu->map_base = ioremap(res.start, sz);
 	if (!cpu->map_base)
 		return -ENOMEM;
@@ -272,7 +268,7 @@ static int __init bcm6345_l1_init_one(struct device_node *dn,
 		return -EINVAL;
 	}
 	irq_set_chained_handler_and_data(cpu->parent_irq,
-						bcm6345_l1_irq_handle, intc);
+						bcm6345_l1_irq_handle, cpu);
 
 	return 0;
 }
-- 
2.40.1



