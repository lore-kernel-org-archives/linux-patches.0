Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4D2BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378FEC433EF;
	Tue,  7 Mar 2023 17:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209641;
	bh=ls1ww7wUoZdGfmdpDQ/rsvnyM2uFK2RBvTwDXaamC4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SwHO/MN5j5VxVt1zJFBlDs1GhpzcDs4nCTgiIvdkSkIBoM5p9fZUq+PCi9ew5Bya
	 4SsmIaCtqjNgYmozSYQE1g1Wdisu5Iij3x4chmhLSCLvqX6rwApjUZMw9q3xwCtZXK
	 oPUhZKd6WLswXanQvo1lxsjim48IqQxtV1aHPL4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0257/1001] irqchip/irq-mvebu-gicp: Fix refcount leak in mvebu_gicp_probe
Date: Tue,  7 Mar 2023 17:50:29 +0100
Message-Id: <20230307170032.883618024@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit 9419e700021a393f67be36abd0c4f3acc6139041 ]

of_irq_find_parent() returns a node pointer with refcount incremented,
We should use of_node_put() on it when not needed anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: a68a63cb4dfc ("irqchip/irq-mvebu-gicp: Add new driver for Marvell GICP")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230102084208.3951758-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mvebu-gicp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-mvebu-gicp.c b/drivers/irqchip/irq-mvebu-gicp.c
index fe88a782173dd..c43a345061d53 100644
--- a/drivers/irqchip/irq-mvebu-gicp.c
+++ b/drivers/irqchip/irq-mvebu-gicp.c
@@ -221,6 +221,7 @@ static int mvebu_gicp_probe(struct platform_device *pdev)
 	}
 
 	parent_domain = irq_find_host(irq_parent_dn);
+	of_node_put(irq_parent_dn);
 	if (!parent_domain) {
 		dev_err(&pdev->dev, "failed to find parent IRQ domain\n");
 		return -ENODEV;
-- 
2.39.2



