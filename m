Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F47D28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9708EC4339B;
	Mon, 30 Jan 2023 13:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087117;
	bh=mJ/RL0qJmJLL0dPQ/Z/L34KkcnDdhTzNokLYOPsLSDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsOiMcbSFWnd4zsZnmdMx6ZgMYcshEov8fhTerYikk4HwNXk15vy4TPUu2sKoxvkN
	 B2QV1niOz4AHfuOUTGV99Cs0eTk9Sp2DvmpkgYCNiN7Y/MVRXK6jwPq2DsnG7eU2ge
	 uthmak9ITN9y9HIotPiptwqvpDxQcPgpUh4yS/BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/313] net: lan966x: add missing fwnode_handle_put() for ports node
Date: Mon, 30 Jan 2023 14:48:27 +0100
Message-Id: <20230130134340.016220112@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Clément Léger <clement.leger@bootlin.com>

[ Upstream commit 925f3deb45df73173a33e1e81db77575f4ffde39 ]

Since the "ethernet-ports" node is retrieved using
device_get_named_child_node(), it should be release after using it. Add
missing fwnode_handle_put() and move the code that retrieved the node
from device-tree to avoid complicated handling in case of error.

Fixes: db8bcaad5393 ("net: lan966x: add the basic lan966x driver")
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://lore.kernel.org/r/20230112161311.495124-1-clement.leger@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microchip/lan966x/lan966x_main.c   | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 20ee5b28f70a..569108c49cbc 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -1022,11 +1022,6 @@ static int lan966x_probe(struct platform_device *pdev)
 		lan966x->base_mac[5] &= 0xf0;
 	}
 
-	ports = device_get_named_child_node(&pdev->dev, "ethernet-ports");
-	if (!ports)
-		return dev_err_probe(&pdev->dev, -ENODEV,
-				     "no ethernet-ports child found\n");
-
 	err = lan966x_create_targets(pdev, lan966x);
 	if (err)
 		return dev_err_probe(&pdev->dev, err,
@@ -1104,6 +1099,11 @@ static int lan966x_probe(struct platform_device *pdev)
 		}
 	}
 
+	ports = device_get_named_child_node(&pdev->dev, "ethernet-ports");
+	if (!ports)
+		return dev_err_probe(&pdev->dev, -ENODEV,
+				     "no ethernet-ports child found\n");
+
 	/* init switch */
 	lan966x_init(lan966x);
 	lan966x_stats_init(lan966x);
@@ -1138,6 +1138,8 @@ static int lan966x_probe(struct platform_device *pdev)
 		lan966x_port_init(lan966x->ports[p]);
 	}
 
+	fwnode_handle_put(ports);
+
 	lan966x_mdb_init(lan966x);
 	err = lan966x_fdb_init(lan966x);
 	if (err)
@@ -1160,6 +1162,7 @@ static int lan966x_probe(struct platform_device *pdev)
 	lan966x_fdb_deinit(lan966x);
 
 cleanup_ports:
+	fwnode_handle_put(ports);
 	fwnode_handle_put(portnp);
 
 	lan966x_cleanup_ports(lan966x);
-- 
2.39.0



