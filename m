Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C2F8F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60126C433C8;
	Sun, 16 Jul 2023 19:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537297;
	bh=+SoqVG6RoguNPN15+w6YkeW507traoDvh9eGkjN/N3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rBdqioqy36k9W9MUeqbS1Jfbq87CQ772/Zw1SG43rdDwe6TjD8++0ANr0d58NsnI
	 a4bwFy9LhMxwg5VpJwzgM/2T/a2tgE0tWKHeC/zvwNRdPti1hG2n7zvMmAtujnEXuO
	 f6amqn7tD/CI6+lESKwpJ+cFCxbg9cv0h2hTBSDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Rob Landley <rob@landley.net>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 045/800] irqchip/jcore-aic: Fix missing allocation of IRQ descriptors
Date: Sun, 16 Jul 2023 21:38:18 +0200
Message-ID: <20230716194950.139029811@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>

[ Upstream commit 4848229494a323eeaab62eee5574ef9f7de80374 ]

The initialization function for the J-Core AIC aic_irq_of_init() is
currently missing the call to irq_alloc_descs() which allocates and
initializes all the IRQ descriptors. Add missing function call and
return the error code from irq_alloc_descs() in case the allocation
fails.

Fixes: 981b58f66cfc ("irqchip/jcore-aic: Add J-Core AIC driver")
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Tested-by: Rob Landley <rob@landley.net>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230510163343.43090-1-glaubitz@physik.fu-berlin.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-jcore-aic.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/irqchip/irq-jcore-aic.c b/drivers/irqchip/irq-jcore-aic.c
index 5f47d8ee4ae39..b9dcc8e78c750 100644
--- a/drivers/irqchip/irq-jcore-aic.c
+++ b/drivers/irqchip/irq-jcore-aic.c
@@ -68,6 +68,7 @@ static int __init aic_irq_of_init(struct device_node *node,
 	unsigned min_irq = JCORE_AIC2_MIN_HWIRQ;
 	unsigned dom_sz = JCORE_AIC_MAX_HWIRQ+1;
 	struct irq_domain *domain;
+	int ret;
 
 	pr_info("Initializing J-Core AIC\n");
 
@@ -100,6 +101,12 @@ static int __init aic_irq_of_init(struct device_node *node,
 	jcore_aic.irq_unmask = noop;
 	jcore_aic.name = "AIC";
 
+	ret = irq_alloc_descs(-1, min_irq, dom_sz - min_irq,
+			      of_node_to_nid(node));
+
+	if (ret < 0)
+		return ret;
+
 	domain = irq_domain_add_legacy(node, dom_sz - min_irq, min_irq, min_irq,
 				       &jcore_aic_irqdomain_ops,
 				       &jcore_aic);
-- 
2.39.2



