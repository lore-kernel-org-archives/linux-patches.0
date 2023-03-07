Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3DABA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6A3C4339B;
	Tue,  7 Mar 2023 18:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212491;
	bh=HZIWujb/y2WJXh7im6m7dJaPfLpTd7Kwtf11QNvNkiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y9WHh59Yize8snoWm9Z/RiPHsSPZ/OWkCQHyMyeyidoVK61b9cM568BC6h/vKvR2d
	 5cztJNwxqUtOSmUuJZ0iuJEMP9O/QiyJuwT4Sn+otBvZj4MxjcbKYiZ8wBMIuGKQT6
	 4RQM5ZZmbp4ii+VnULYE9GZ5oCkyo8Rk7PSsqcvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 200/885] irqchip/alpine-msi: Fix refcount leak in alpine_msix_init_domains
Date: Tue,  7 Mar 2023 17:52:14 +0100
Message-Id: <20230307170010.726203135@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit 071d068b89e95d1b078aa6bbcb9d0961b77d6aa1 ]

of_irq_find_parent() returns a node pointer with refcount incremented,
We should use of_node_put() on it when not needed anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: e6b78f2c3e14 ("irqchip: Add the Alpine MSIX interrupt controller")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230102082811.3947760-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-alpine-msi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-alpine-msi.c b/drivers/irqchip/irq-alpine-msi.c
index 5ddb8e578ac6a..fc1ef7de37973 100644
--- a/drivers/irqchip/irq-alpine-msi.c
+++ b/drivers/irqchip/irq-alpine-msi.c
@@ -199,6 +199,7 @@ static int alpine_msix_init_domains(struct alpine_msix_data *priv,
 	}
 
 	gic_domain = irq_find_host(gic_node);
+	of_node_put(gic_node);
 	if (!gic_domain) {
 		pr_err("Failed to find the GIC domain\n");
 		return -ENXIO;
-- 
2.39.2



