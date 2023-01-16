Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A576FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E602C433EF;
	Mon, 16 Jan 2023 16:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887918;
	bh=BpN3Sva0JSp+Zaq2oTXSZYfT49B4CmHw5QEZv342z4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4eUsY3z8lUb1RI8HR/F1VM51iWD3e5ml2tM2CIOHuKMJ+/LBdybB8ArJVqFrTYxS
	 PnYWaHdlL6m+Cdzw/fc/0QOLggLEDlggaK8n3JnaHt/kQnMc4Qt4e9iorC552bRr1Y
	 eRgL4UioYq6mSl4AM1cAyPMJwqbsKA0FszZQR60Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 302/521] r6040: Fix kmemleak in probe and remove
Date: Mon, 16 Jan 2023 16:49:24 +0100
Message-Id: <20230116154900.618499792@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit 7e43039a49c2da45edc1d9d7c9ede4003ab45a5f ]

There is a memory leaks reported by kmemleak:

  unreferenced object 0xffff888116111000 (size 2048):
    comm "modprobe", pid 817, jiffies 4294759745 (age 76.502s)
    hex dump (first 32 bytes):
      00 c4 0a 04 81 88 ff ff 08 10 11 16 81 88 ff ff  ................
      08 10 11 16 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<ffffffff815bcd82>] kmalloc_trace+0x22/0x60
      [<ffffffff827e20ee>] phy_device_create+0x4e/0x90
      [<ffffffff827e6072>] get_phy_device+0xd2/0x220
      [<ffffffff827e7844>] mdiobus_scan+0xa4/0x2e0
      [<ffffffff827e8be2>] __mdiobus_register+0x482/0x8b0
      [<ffffffffa01f5d24>] r6040_init_one+0x714/0xd2c [r6040]
      ...

The problem occurs in probe process as follows:
  r6040_init_one:
    mdiobus_register
      mdiobus_scan    <- alloc and register phy_device,
                         the reference count of phy_device is 3
    r6040_mii_probe
      phy_connect     <- connect to the first phy_device,
                         so the reference count of the first
                         phy_device is 4, others are 3
    register_netdev   <- fault inject succeeded, goto error handling path

    // error handling path
    err_out_mdio_unregister:
      mdiobus_unregister(lp->mii_bus);
    err_out_mdio:
      mdiobus_free(lp->mii_bus);    <- the reference count of the first
                                       phy_device is 1, it is not released
                                       and other phy_devices are released
  // similarly, the remove process also has the same problem

The root cause is traced to the phy_device is not disconnected when
removes one r6040 device in r6040_remove_one() or on error handling path
after r6040_mii probed successfully. In r6040_mii_probe(), a net ethernet
device is connected to the first PHY device of mii_bus, in order to
notify the connected driver when the link status changes, which is the
default behavior of the PHY infrastructure to handle everything.
Therefore the phy_device should be disconnected when removes one r6040
device or on error handling path.

Fix it by adding phy_disconnect() when removes one r6040 device or on
error handling path after r6040_mii probed successfully.

Fixes: 3831861b4ad8 ("r6040: implement phylib")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20221213125614.927754-1-lizetao1@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/rdc/r6040.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index 2199bd08f4d6..e377c1f68777 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -1184,10 +1184,12 @@ static int r6040_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = register_netdev(dev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to register net device\n");
-		goto err_out_mdio_unregister;
+		goto err_out_phy_disconnect;
 	}
 	return 0;
 
+err_out_phy_disconnect:
+	phy_disconnect(dev->phydev);
 err_out_mdio_unregister:
 	mdiobus_unregister(lp->mii_bus);
 err_out_mdio:
@@ -1211,6 +1213,7 @@ static void r6040_remove_one(struct pci_dev *pdev)
 	struct r6040_private *lp = netdev_priv(dev);
 
 	unregister_netdev(dev);
+	phy_disconnect(dev->phydev);
 	mdiobus_unregister(lp->mii_bus);
 	mdiobus_free(lp->mii_bus);
 	netif_napi_del(&lp->napi);
-- 
2.35.1



