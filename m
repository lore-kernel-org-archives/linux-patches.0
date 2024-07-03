Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DD5142649;
	Wed,  3 Jul 2024 10:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004190; cv=none; b=Cg4pvceQMYx8QlDrz+IhMFj7ijXIrd5PVrIzu5VEfWUT89Y2Uvaw2Tww+7pjXL+0mqyYUnWzHeQd7qfAqtFi1dbTbBpOPNVvf9HC0LVyLAV4yoVscOYuLZPs9967bWYUjuYpWWdcWl93rLO9CdMMWo/ucygK9cmlVkSd2iAZqnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004190; c=relaxed/simple;
	bh=f9MiLpODZ52QAXVn4ygXGrzkoNwvRLWPRtZu3gAE/tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5HVeFbQ2xp3fXqHi+HKaOb66F7GJmxQCr5DNLMS3zo0Um0QePHsT73BJyjowbOd2bfVdkdxXIx3unxowUhnrwX3C6tFUpO0qtZ1mOAQKLFIvQBlvEci3cZ5owSNvP2o54omYBtzZm79aUMY1zbYZ3tYyRWvHTZo9cNW312d820=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbBDl6qO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbBDl6qO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAFAC2BD10;
	Wed,  3 Jul 2024 10:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004190;
	bh=f9MiLpODZ52QAXVn4ygXGrzkoNwvRLWPRtZu3gAE/tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbBDl6qOkUp0NdwvPfxmzIoA2LJ2cJnrd+lzpuFBFTgKPjS2WRbiEb7dcUw2RbyxE
	 vTAvh+gMOPZ0cK+5jrUpqLeVLijcI4tx+x1PhjLAyqKE3Ofp6M2q50jjbYfgWWzmTV
	 AnE0MP72OzbWsT+tHUi8sEqpuFy+Ac6QYCK4Nq3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Li <dawei.li@shingroup.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 150/189] net/dpaa2: Avoid explicit cpumask var allocation on stack
Date: Wed,  3 Jul 2024 12:40:11 +0200
Message-ID: <20240703102847.135468098@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ad0d070f7f172..5f5766b1f3b70 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1945,11 +1945,14 @@ static int dpaa2_eth_xdp_xmit(struct net_device *net_dev, int n,
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
 
@@ -1959,16 +1962,17 @@ static int update_xps(struct dpaa2_eth_priv *priv)
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



