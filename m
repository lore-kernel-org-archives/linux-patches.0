Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED01D2BEFEF;
	Wed, 30 Sep 2026 19:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795463; cv=none; b=QHDOkz42R5kZQqmytDMo7ZJ5j5qwqOw+J7hfEBylOJr26oOAYxM1C7tBm8bWY53YtABJcDIiCk4Wu4gkx3izoUYXW3RYRVyi4JqPDnS1SS0Q7PdkGPj9ECnT1LB3LyM6qAotH+CElVhjdVLCTr8UK5fTSqrmoVq1W7V5gGxLouI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795463; c=relaxed/simple;
	bh=CUReDxXof+uCfyYBBzOgdVL/8+V2v4Q6crdN4wiLs7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVL20EgeCtuIpwOd4LoamcjFT0oHXksUlTlJwHUcVbxAfbJ8mbVBJw2WtLcKuQZRjyo/X9DPpbjmMeUuakG91JgcO8PsStqjoPo1IhYVKXVPmsVdFEVY+MyHeMZrpx+qSwimtzA4nISWJYnEWstPtXR1qb5OyEZQgj8Dua2HZOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hv5FoTSv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hv5FoTSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5515E1F000FF;
	Wed, 30 Sep 2026 19:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795461;
	bh=guKfI+YGFR0c8X983+imY3vL0jMGNybkUjAhBQm8AKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hv5FoTSvvVkBtUEi0oNgOrjkewo1UT5ZOgoizR1IyOHjySe/Gx1Tc2g+5vQVFpwQb
	 W7pXQ6zK5JCkgoAn9wAC3+bk4jWkH4NP0AawMIik1IYR7pjem2bwegkMlKVbHQ9Beo
	 vUlpWCvgqWAslREH5PbvxfRKgQw8w9SotDDzP9z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Karumanchi <vineeth.karumanchi@amd.com>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0515/1193] net: macb: fix NULL pointer dereference on unbind with fixed-link
Date: Wed, 30 Sep 2026 17:19:59 +0200
Message-ID: <20260930152445.613713859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 07fb05e016b55..7642829240151 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5305,8 +5305,10 @@ static int macb_probe(struct platform_device *pdev)
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
@@ -5334,8 +5336,10 @@ static int macb_remove(struct platform_device *pdev)
 		bp = netdev_priv(dev);
 		unregister_netdev(dev);
 		phy_exit(bp->phy);
-		mdiobus_unregister(bp->mii_bus);
-		mdiobus_free(bp->mii_bus);
+		if (bp->mii_bus) {
+			mdiobus_unregister(bp->mii_bus);
+			mdiobus_free(bp->mii_bus);
+		}
 
 		tasklet_kill(&bp->hresp_err_tasklet);
 		pm_runtime_disable(&pdev->dev);
-- 
2.53.0



