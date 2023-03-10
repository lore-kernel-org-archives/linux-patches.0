Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16661848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0B4C433D2;
	Fri, 10 Mar 2023 14:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458571;
	bh=dOyGtgEoquZpppBRGeLcbyPe5UMgmj9mzV4Iu9UiE9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T21qiG86arADAM6rTKrSHskR+ldGSLXdIUakGn7WeHQgQb3n3BN7dT2UcsovnDQH9
	 Wg/xljqy7HXy/l4KgQZhcnesNYNXlN3iDXiNfOhlc/Y06MhB7kxvuQOab3Q9gGYwwH
	 zKo1Nm9uOE7ZcnUfyPTrXlPNnSD0myw7EOi5qLB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/357] irqchip/ti-sci: Fix refcount leak in ti_sci_intr_irq_domain_probe
Date: Fri, 10 Mar 2023 14:36:00 +0100
Message-Id: <20230310133737.113161706@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 02298b7bae12936ca313975b02e7f98b06670d37 ]

of_irq_find_parent() returns a node pointer with refcount incremented,
We should use of_node_put() on it when not needed anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: cd844b0715ce ("irqchip/ti-sci-intr: Add support for Interrupt Router driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230102085611.3955984-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-ti-sci-intr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-ti-sci-intr.c b/drivers/irqchip/irq-ti-sci-intr.c
index 59d51a20bbd86..7d0163d85fb9b 100644
--- a/drivers/irqchip/irq-ti-sci-intr.c
+++ b/drivers/irqchip/irq-ti-sci-intr.c
@@ -205,6 +205,7 @@ static int ti_sci_intr_irq_domain_probe(struct platform_device *pdev)
 	}
 
 	parent_domain = irq_find_host(parent_node);
+	of_node_put(parent_node);
 	if (!parent_domain) {
 		dev_err(dev, "Failed to find IRQ parent domain\n");
 		return -ENODEV;
-- 
2.39.2



