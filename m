Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFE916F8F5;
	Wed,  3 Jul 2024 11:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005016; cv=none; b=Dwfqmeyn5EzkQCfxw8k/eHoQpb3imoUlcB9lOvB+qPuUG5+hCZL1Az6hre58ifwbPCdKVFOs7YCE7m8TaprF4g1XsydfurC87FiWTswOGjfXWnLoXwS1lg/+ihWtu8faz94mhsT0PvyjNMtsAJLn890c2c+04BN+kwKar0T6Ork=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005016; c=relaxed/simple;
	bh=6nMEmELLFMzylBR2wTEyxLP6wj9GCTM4T5YvoTgOd+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKuALn6b+ET91u9hazI9KyCVXCICe5bnM/FzA88vtQBd/S5qDySbuFdzI31GUjT7e6QlQ0xU6RkrZUISjhZQDMhawnI4Q+Wpg0fWp6/BjEWxshvQfWF1/x8+gpUOaNvlhlGAZq/cOafMpJjVeJJH6/zUfvkip6wzmqYWkqMX6kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTNeyq1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTNeyq1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4E0C2BD10;
	Wed,  3 Jul 2024 11:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005016;
	bh=6nMEmELLFMzylBR2wTEyxLP6wj9GCTM4T5YvoTgOd+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTNeyq1YdlwgNIYMbgzyiVNTK9bYjOKZXt3A7eYf0ILfqro3/x+/5x5RHuCM8WofD
	 gg79N3Qg7XiwVseW3bS53WNDXC0k6SzKbFmePVD8vR7JioArBJq38ZzyxJPYY8yjxi
	 Bj/M0rIZTOMNIh1J0BdV+d2y08/VORlsZ7nkisVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Li <dawei.li@shingroup.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 233/290] net/dpaa2: Avoid explicit cpumask var allocation on stack
Date: Wed,  3 Jul 2024 12:40:14 +0200
Message-ID: <20240703102912.954233363@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 07ba0438f9655..fa202fea537f8 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2383,11 +2383,14 @@ static int dpaa2_eth_xdp_xmit(struct net_device *net_dev, int n,
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
 
@@ -2397,16 +2400,17 @@ static int update_xps(struct dpaa2_eth_priv *priv)
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



