Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027512;
	b=25zYPpFvMoD/+ZyX3Bw3xC+C5lYSEJD/LF5r/omQ0lVV8wjFKXyqpm50UbA0CQ6RXRuR
	 wUwZis+3RHlD6ag6xPMDVE0Bhh830Krkvy+4DsGXNbclqYJ91+wkvuUQiieu1k3jsX3R1
	 0fdfX2eknJIHUBmCW1GL0ySoQzv1Y9eiGaJh26bDxdfVBxh7vRtfgsGYnVymRO/YTol/x
	 GUTzAarGOoT1BWy3LIgOR7l8IpJgi3XnSWkvj5k6YMUWaACSjlzbOKL9hJRcAdqyqvqEw
	 vN6mBTbL32hQ8H3ybFvCf2f7z3MiiiXj80CXN6DhHNwAFrVwO7wWmpgoeEsaNfXdhzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lM8mgHxYKVUAupz/PV5454mx+bsMpnx6SdMew54hkyY=;
	b=Ew5+0m9sxrEOyQPyu4EQRqEta96g8QlXIpActgaOPEimJnUt0JTrm9Lec481hrp0nbli
	 pKHw1/rZQY6L35ehgfSywUsuT4KdeHQ8g0coZgfyvaybx7grpt7gekeD+/1pCzS2hYBlJ
	 W4V9QprkbR3situKI7aEvCDP2CNGUja+WLvDE5uTbHYDR6Yf5x4UhNIwhtLDgDJprgESR
	 G+0Op9rErALO5ELHRPsC0k/j9FULL3AV0bsluTCxGdKGZp9kr2IH6puqvvHPYBKH/J7bK
	 8BVz8R60sAtRJ2drvxVX3J6aPyMNZwH6SUasA6npE65DfdDbFEUzUe8UJs0dI0kWJDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fAaysxh8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B305160A2603;
	Wed, 18 Nov 2026 18:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fAaysxh8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1662E1F000C4;
	Wed, 18 Nov 2026 18:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027512;
	bh=lM8mgHxYKVUAupz/PV5454mx+bsMpnx6SdMew54hkyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fAaysxh8RYaZEREeOcaCLxosRKoctyYpVZ2+EjnhWAIjxeWpYQmpK9I5rODPBSGRy
	 ob0hadtknPHiel7zWKOyChdvsOHjGvHeB/b7uLFfOlXkYio3Hr6CNakXNFDl8i3o7J
	 Frl66cLg7fpG4Ge5v3HvwZLMY4t7xLt1AlOwwmRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1815/2151] net: hix5hd2: serialize timeout recovery with interface teardown
Date: Wed, 18 Nov 2026 15:59:10 +0100
Message-ID: <20261118150227.923772859@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 87cce46329a811ea3fe108ac721e0a2400d0a3bb ]

The timeout worker calls the driver's close and open methods without
RTNL or a running-state check. A timeout queued before an interface is
closed can call close again after ndo_stop has disabled NAPI. The second
napi_disable() can then wait indefinitely. The worker can also race with
an ongoing close.

Take RTNL and skip recovery when the interface is no longer running.
Use the netdev core close and open helpers so a failed reopen leaves the
interface down, rather than leaving it marked running with NAPI disabled.

After unregister_netdev() has stopped the watchdog, drain the worker
before releasing its MDIO and descriptor resources. This wait is outside
RTNL, allowing an already queued worker to take RTNL, observe the down
state, and finish.

This issue was identified as part of our ongoing research while
reviewing kernel code.

Fixes: 57c5bc9ad7d7 ("net: hisilicon: add hix5hd2 mac driver")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/179203116093.2621539.3718842986255459438.G202@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index 02282dc86faf4..12a5657653f85 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -12,6 +12,7 @@
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
 #include <linux/reset.h>
+#include <linux/rtnetlink.h>
 #include <linux/clk.h>
 #include <linux/circ_buf.h>
 
@@ -890,8 +891,13 @@ static void hix5hd2_tx_timeout_task(struct work_struct *work)
 	struct hix5hd2_priv *priv;
 
 	priv = container_of(work, struct hix5hd2_priv, tx_timeout_task);
-	hix5hd2_net_close(priv->netdev);
-	hix5hd2_net_open(priv->netdev);
+
+	rtnl_lock();
+	if (netif_running(priv->netdev)) {
+		dev_close(priv->netdev);
+		dev_open(priv->netdev, NULL);
+	}
+	rtnl_unlock();
 }
 
 static void hix5hd2_net_timeout(struct net_device *dev, unsigned int txqueue)
@@ -1283,6 +1289,7 @@ static void hix5hd2_dev_remove(struct platform_device *pdev)
 	struct hix5hd2_priv *priv = netdev_priv(ndev);
 
 	unregister_netdev(ndev);
+	cancel_work_sync(&priv->tx_timeout_task);
 	mdiobus_unregister(priv->bus);
 	mdiobus_free(priv->bus);
 
@@ -1290,7 +1297,6 @@ static void hix5hd2_dev_remove(struct platform_device *pdev)
 		hix5hd2_destroy_sg_desc_queue(priv);
 	hix5hd2_destroy_hw_desc_queue(priv);
 	of_node_put(priv->phy_node);
-	cancel_work_sync(&priv->tx_timeout_task);
 	free_netdev(ndev);
 }
 
-- 
2.53.0



