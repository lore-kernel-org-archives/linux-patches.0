Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5DB16B394;
	Tue,  2 Jul 2024 17:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941383; cv=none; b=fOJ5rhV4v1IumC9WUSwefYhiByR5euTEEGHbudSFHYSiuk4oksyySPpZbxyiD6mNS0m0FY0OnDfvl8NrEBB8x7qBJRps8uy8PHH+4Juoebfbr+sH1zRVhu9jzeJt6Qt24qBG0OjHX53dfDS3RLW/8App5VcNfSzCqieuwNeMvzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941383; c=relaxed/simple;
	bh=OWDXNZv3j+4JyBTwCu3/J3EoSI+hHXJqHKjKxOQK1uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxovP3dvENBAhty+9vfmtDlqsXSAnQRA0/IoGPxBzvq/2ISpO8+OyKwTvTOI5jsxXvNEWsxF2xvG1CTUYY9itOIvB9jQUi7bjhqPxuBM+gIdcoUb4gY7zVcdseaHrN/YK/mjoJIB+oiRPGMdHUqnCY84WMvCH1w6Ds68U6NzDBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwwAhbLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwwAhbLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAC9C116B1;
	Tue,  2 Jul 2024 17:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941383;
	bh=OWDXNZv3j+4JyBTwCu3/J3EoSI+hHXJqHKjKxOQK1uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwwAhbLf+EnZCD2c+XERMBmmyO7DB6NLoCQSZdNnPn3dVue4/yYpYY+vs/OxACRzW
	 ZoLzh9H6OhgxkM6AlQ/E6TsUC7NGjxwzxXqSyqXHKal+2e3Or397oOrJG6T57JVe3K
	 OWJ81aMlPpE/z9I5eZKpMOUCvDlrQoGUagBxljaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Li <dawei.li@shingroup.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/128] net/dpaa2: Avoid explicit cpumask var allocation on stack
Date: Tue,  2 Jul 2024 19:04:08 +0200
Message-ID: <20240702170228.014714952@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

From: Dawei Li <dawei.li@shingroup.cn>

[ Upstream commit d33fe1714a44ff540629b149d8fab4ac6967585c ]

For CONFIG_CPUMASK_OFFSTACK=y kernel, explicit allocation of cpumask
variable on stack is not recommended since it can cause potential stack
overflow.

Instead, kernel code should always use *cpumask_var API(s) to allocate
cpumask var in config-neutral way, leaving allocation strategy to
CONFIG_CPUMASK_OFFSTACK.

Use *cpumask_var API(s) to address it.

Signed-off-by: Dawei Li <dawei.li@shingroup.cn>
Link: https://lore.kernel.org/r/20240331053441.1276826-3-dawei.li@shingroup.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index de62eee58a00e..bbbe7c5b5d35a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2754,11 +2754,14 @@ static int dpaa2_eth_xdp_xmit(struct net_device *net_dev, int n,
 static int update_xps(struct dpaa2_eth_priv *priv)
 {
 	struct net_device *net_dev = priv->net_dev;
-	struct cpumask xps_mask;
-	struct dpaa2_eth_fq *fq;
 	int i, num_queues, netdev_queues;
+	struct dpaa2_eth_fq *fq;
+	cpumask_var_t xps_mask;
 	int err = 0;
 
+	if (!alloc_cpumask_var(&xps_mask, GFP_KERNEL))
+		return -ENOMEM;
+
 	num_queues = dpaa2_eth_queue_count(priv);
 	netdev_queues = (net_dev->num_tc ? : 1) * num_queues;
 
@@ -2768,16 +2771,17 @@ static int update_xps(struct dpaa2_eth_priv *priv)
 	for (i = 0; i < netdev_queues; i++) {
 		fq = &priv->fq[i % num_queues];
 
-		cpumask_clear(&xps_mask);
-		cpumask_set_cpu(fq->target_cpu, &xps_mask);
+		cpumask_clear(xps_mask);
+		cpumask_set_cpu(fq->target_cpu, xps_mask);
 
-		err = netif_set_xps_queue(net_dev, &xps_mask, i);
+		err = netif_set_xps_queue(net_dev, xps_mask, i);
 		if (err) {
 			netdev_warn_once(net_dev, "Error setting XPS queue\n");
 			break;
 		}
 	}
 
+	free_cpumask_var(xps_mask);
 	return err;
 }
 
-- 
2.43.0



