Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B318489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6043C433EF;
	Fri, 10 Mar 2023 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457801;
	bh=LiPyWCuCLGw5Wxbj1aEfulOXij31ZYe5O3yWivWYw80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBk+J54u0MqOMIrIc+bDr1CrgpantMFqUxSYmV/4LpGY8ZpV9lHbWi5cDEiPa0TTV
	 U8ryaGMwqktB5LOyWHt0wWriYT6c7oy7jd9IyA/OoC6BtqxskhzTqtDzcvFHzA5xU4
	 /WB6rwlFGzcnb6PWmnLz8BT0S8WAb8iCzV9XO/1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/252] irqchip/irq-brcmstb-l2: Set IRQ_LEVEL for level triggered interrupts
Date: Fri, 10 Mar 2023 14:37:13 +0100
Message-Id: <20230310133720.746106516@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 94debe03e8afa1267f95a9001786a6aa506b9ff3 ]

When support for the level triggered interrupt controller flavor was
added with c0ca7262088e, we forgot to update the flags to be set to
contain IRQ_LEVEL. While the flow handler is correct, the output from
/proc/interrupts does not show such interrupts as being level triggered
when they are, correct that.

Fixes: c0ca7262088e ("irqchip/brcmstb-l2: Add support for the BCM7271 L2 controller")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221216230934.2478345-2-f.fainelli@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-brcmstb-l2.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb-l2.c
index 83364fedbf0ab..3f1ae63233cb4 100644
--- a/drivers/irqchip/irq-brcmstb-l2.c
+++ b/drivers/irqchip/irq-brcmstb-l2.c
@@ -169,6 +169,7 @@ static int __init brcmstb_l2_intc_of_init(struct device_node *np,
 					  *init_params)
 {
 	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	unsigned int set = 0;
 	struct brcmstb_l2_intc_data *data;
 	struct irq_chip_type *ct;
 	int ret;
@@ -216,9 +217,12 @@ static int __init brcmstb_l2_intc_of_init(struct device_node *np,
 	if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
 		flags |= IRQ_GC_BE_IO;
 
+	if (init_params->handler == handle_level_irq)
+		set |= IRQ_LEVEL;
+
 	/* Allocate a single Generic IRQ chip for this node */
 	ret = irq_alloc_domain_generic_chips(data->domain, 32, 1,
-			np->full_name, init_params->handler, clr, 0, flags);
+			np->full_name, init_params->handler, clr, set, flags);
 	if (ret) {
 		pr_err("failed to allocate generic irq chip\n");
 		goto out_free_domain;
-- 
2.39.2



