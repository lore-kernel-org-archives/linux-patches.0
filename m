Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB35579813;
	Thu, 17 Sep 2026 15:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659613; cv=none; b=RMLtf9aYnJV41PnRkPPObvLBuljOqISunfTBCdlJD1hfi6YhThxvFl28PbYjvwz4b+RS9rQ3j5WXnP68M92ZWCNe9/+8MDm1F6Vv9U8YXb2GsD0idL6PCMuioCZYqoXbLPqLnAzLk+PNxD0+hac5JrAljno0B5IuhAnqjLiGcvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659613; c=relaxed/simple;
	bh=fE0ctDbzLxPjOryX/+46cgbQ9IcNV4daPIIgWyVDpM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hd7en70yIUoJyhm+97KU7TthB46jqEEJT5FT5Nu+TSKdDLlXKuLpv/DHkYIZG5XC8oNLno9x+M2tA7hQH0+nDkf7eqdcOAgk3aPgtTcrR9lawu2xCxZ2SyXYqCGHKDjEWoLmO7doqNrKv6i936rn9ErnfT7t/8AcDYT8BSbqvOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MugNzmpB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MugNzmpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BC81F0089A;
	Thu, 17 Sep 2026 15:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659604;
	bh=007DDRUg8E583gQOsPh4dXqtBoJbR5qfE/miFgdQ4vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MugNzmpBUv6QvUDCP0/dcVt8NNr/iowhcX4RkM5OyKvmO7lbaSoC5+wnLgcEAfLzi
	 hHm4iPlWeKqSXHRpe3gnRwT4Li1UHg3KMOnSgrWdaM0QKp5R7I/ARgLpD8XzMeg/gz
	 9cfF3TirP9hcyft8nFlfdZxO4xRANEgorTS+LaKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Karumanchi <vineeth.karumanchi@amd.com>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 312/733] net: macb: fix NULL pointer dereference on unbind with fixed-link
Date: Thu, 17 Sep 2026 16:10:20 +0100
Message-ID: <20260917151359.246019547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineeth Karumanchi <vineeth.karumanchi@amd.com>

[ Upstream commit 38b6be101006d3e7af972999f45d4f1e8250587a ]

When the device tree describes a fixed-link and has no "mdio" child
node, macb_mii_init() returns early without allocating the MDIO bus,
leaving bp->mii_bus as NULL.

Two cleanup paths then dereference this NULL bus:

1. On driver unbind, macb_remove() unconditionally calls
   mdiobus_unregister(bp->mii_bus), which oopses:

  Unable to handle kernel NULL pointer dereference at virtual address 00000000000004a8
  pc : mdiobus_unregister+0x14/0xa4
  lr : macb_remove+0x38/0xa4
  Call trace:
   mdiobus_unregister+0x14/0xa4 (P)
   macb_remove+0x38/0xa4
   platform_remove+0x20/0x30
   device_release_driver_internal+0x1c8/0x224
   unbind_store+0xb4/0xbc

2. On the probe error path in macb_probe(), reached when
   macb_mii_init() has succeeded but a subsequent step fails, the
   err_out_unregister_mdio label runs the same unconditional cleanup.

mdiobus_unregister() and mdiobus_free() do not guard against a NULL
bus, so guard the calls in both macb_remove() and the probe error
path.

Fixes: d0c3601f2c4e ("net: macb: Avoid 20s boot delay by skipping MDIO bus registration for fixed-link PHY")
Signed-off-by: Vineeth Karumanchi <vineeth.karumanchi@amd.com>
Reviewed-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260902102836.2019355-1-vineeth.karumanchi@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 05eda2545597b..cd140f98cbc83 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5964,8 +5964,10 @@ static int macb_probe(struct platform_device *pdev)
 	return 0;
 
 err_out_unregister_mdio:
-	mdiobus_unregister(bp->mii_bus);
-	mdiobus_free(bp->mii_bus);
+	if (bp->mii_bus) {
+		mdiobus_unregister(bp->mii_bus);
+		mdiobus_free(bp->mii_bus);
+	}
 
 err_out_phy_exit:
 	phy_exit(bp->phy);
@@ -5993,8 +5995,10 @@ static void macb_remove(struct platform_device *pdev)
 		bp = netdev_priv(netdev);
 		unregister_netdev(netdev);
 		phy_exit(bp->phy);
-		mdiobus_unregister(bp->mii_bus);
-		mdiobus_free(bp->mii_bus);
+		if (bp->mii_bus) {
+			mdiobus_unregister(bp->mii_bus);
+			mdiobus_free(bp->mii_bus);
+		}
 
 		device_set_wakeup_enable(&bp->pdev->dev, 0);
 		cancel_delayed_work_sync(&bp->tx_lpi_work);
-- 
2.53.0



