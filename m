Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521461ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6606C433C8;
	Tue, 25 Jul 2023 11:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284880;
	bh=y8nRA/ienjfp/6onmPvSg1cf9o5x7Ntk0AGnruUlrLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2PWRxu7EdhFOSYkU20NC17QoVVAe8020EfoqbPSgU8AudotAz5w3MvgjTvL/Ocbda
	 hnoyUxbXLR9aawpcyvPKVMum80RZu0XSsXWXwxIPvqnjYQNqutYld87PSRcbk988pg
	 3cbt37PWjvFBOpB1L9afeZXkOEU6moVqihKDTHXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 505/509] net: phy: prevent stale pointer dereference in phy_init()
Date: Tue, 25 Jul 2023 12:47:24 +0200
Message-ID: <20230725104616.841767650@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 1c613beaf877c0c0d755853dc62687e2013e55c4 ]

mdio_bus_init() and phy_driver_register() both have error paths, and if
those are ever hit, ethtool will have a stale pointer to the
phy_ethtool_phy_ops stub structure, which references memory from a
module that failed to load (phylib).

It is probably hard to force an error in this code path even manually,
but the error teardown path of phy_init() should be the same as
phy_exit(), which is now simply not the case.

Fixes: 55d8f053ce1b ("net: phy: Register ethtool PHY operations")
Link: https://lore.kernel.org/netdev/ZLaiJ4G6TaJYGJyU@shell.armlinux.org.uk/
Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20230720000231.1939689-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index e771e0e8a9bc6..095d16ceafcf8 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3024,23 +3024,30 @@ static int __init phy_init(void)
 {
 	int rc;
 
+	ethtool_set_ethtool_phy_ops(&phy_ethtool_phy_ops);
+
 	rc = mdio_bus_init();
 	if (rc)
-		return rc;
+		goto err_ethtool_phy_ops;
 
-	ethtool_set_ethtool_phy_ops(&phy_ethtool_phy_ops);
 	features_init();
 
 	rc = phy_driver_register(&genphy_c45_driver, THIS_MODULE);
 	if (rc)
-		goto err_c45;
+		goto err_mdio_bus;
 
 	rc = phy_driver_register(&genphy_driver, THIS_MODULE);
-	if (rc) {
-		phy_driver_unregister(&genphy_c45_driver);
+	if (rc)
+		goto err_c45;
+
+	return 0;
+
 err_c45:
-		mdio_bus_exit();
-	}
+	phy_driver_unregister(&genphy_c45_driver);
+err_mdio_bus:
+	mdio_bus_exit();
+err_ethtool_phy_ops:
+	ethtool_set_ethtool_phy_ops(NULL);
 
 	return rc;
 }
-- 
2.39.2



