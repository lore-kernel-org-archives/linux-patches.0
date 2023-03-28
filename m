Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C218BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F07FC433D2;
	Tue, 28 Mar 2023 14:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014815;
	bh=QZPAApuX+LVsCm0tyNzXqx5blc3z/ObEqubVn4tB2Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjyRHmpxTgIUyXEM7h6Pq5T996ISa+7zDYNmQ97GXNCRcHRhlx2Bu+zPCQq7nZrCt
	 /uK4QN6B2QaCdbLrGmmI62JRgm78IeuKIB2LmEzSLBXt9nRoqYicmi5rT9+jSJNKto
	 2eBa08NbsbcQ0gbzTqX/pFm6ZLymWoHf+LKQ2UOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 061/240] net: qcom/emac: Fix use after free bug in emac_remove due to race condition
Date: Tue, 28 Mar 2023 16:40:24 +0200
Message-Id: <20230328142622.263780357@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit 6b6bc5b8bd2d4ca9e1efa9ae0f98a0b0687ace75 ]

In emac_probe, &adpt->work_thread is bound with
emac_work_thread. Then it will be started by timeout
handler emac_tx_timeout or a IRQ handler emac_isr.

If we remove the driver which will call emac_remove
  to make cleanup, there may be a unfinished work.

The possible sequence is as follows:

Fix it by finishing the work before cleanup in the emac_remove
and disable timeout response.

CPU0                  CPU1

                    |emac_work_thread
emac_remove         |
free_netdev         |
kfree(netdev);      |
                    |emac_reinit_locked
                    |emac_mac_down
                    |//use netdev
Fixes: b9b17debc69d ("net: emac: emac gigabit ethernet controller driver")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/emac/emac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 3115b2c128980..eaa50050aa0b7 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -724,9 +724,15 @@ static int emac_remove(struct platform_device *pdev)
 	struct net_device *netdev = dev_get_drvdata(&pdev->dev);
 	struct emac_adapter *adpt = netdev_priv(netdev);
 
+	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
+
 	unregister_netdev(netdev);
 	netif_napi_del(&adpt->rx_q.napi);
 
+	free_irq(adpt->irq.irq, &adpt->irq);
+	cancel_work_sync(&adpt->work_thread);
+
 	emac_clks_teardown(adpt);
 
 	put_device(&adpt->phydev->mdio.dev);
-- 
2.39.2



