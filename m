Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042280;
	b=jLoTae3sdsjBLb/RmLeYwVUdOnl3waK9gTQlHGES9226ATlLLShkF4UlqH6xKcTYkWJh
	 BmcDX5JJgWIKwfd8WLV28B3ZdAIcbDASBHzeiev7CZ5GY3yfwTOtzI69sCv4S5l0yZCQM
	 NdeSLYWh7eLHwgS/5v8eGsuV1sQdNRBWuH93YvPuPb86YKyuaRekyt8YcvN8rChi/RSC0
	 fnFc+WAflOE1TLWEUiv020cXeV6YIZFn/Yan+AptLXO0UaCLLnsY0KrAWe1EWepXN9k+d
	 XvbrV988WYzdQ59tI1P97+Jzi2ykl6r/chrJSwf4hTu97xuAZPDcpr9iwoZ19FoZZVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xgc70aXN5FnQvJo+f4FBG9giVLKxJ1R1vm6VQ+YtPe4=;
	b=dgAvuW+h0cCUe1RbaWzIj1M69f68d71Qts+27gdhTjMmi/lm6sZvNhalcn6XsXrpFCwb
	 C7gppVb3XNV80YGPx5zIUjZsj7YagZ5099HUaHHe8ZiYV2KMAf1zyAHEqxq8pWM13NxeX
	 tENLnLYPFmWSvl8Ho0pTYVsrCD806rzI6RSEQsRutKKsRYddSaRwqJ4k9D2rvtCi8mNcM
	 T7LCtxt3Q8k9jtlWCyOuh8VqGhAQ0yw6CrkF+g5xffSbhqMnbSOUWln7l+Bs682AcRaV3
	 4/J0tKrXOFlLiGj7EkUBI3N23lfAlTLHbtwdjZmfvoBvWsVsw3G9fyJ5KArbzstba8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2YcjXlcQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DB3606A31C;
	Wed, 18 Nov 2026 22:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2YcjXlcQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3751C1F000C4;
	Wed, 18 Nov 2026 22:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042279;
	bh=Xgc70aXN5FnQvJo+f4FBG9giVLKxJ1R1vm6VQ+YtPe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2YcjXlcQQbs4o2flj6406KI4wIu8octx2PkrDiq8MJi0x3Mq/purn9s8V1yUIWgAx
	 5HVCdA5PSKKYZVO63K2y08bGkJaqTWzY6x4R+l3VJjmOJPJvkeVBoENx30eIO83hj1
	 TE7ikulDktIU+Ptp0D8xmrmaZUi3+HqahAf6sVfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3073/3318] net: hix5hd2: serialize timeout recovery with interface teardown
Date: Wed, 18 Nov 2026 16:01:35 +0100
Message-ID: <20261118150452.286853079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e8cedc2608654..5ecf428984e4a 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -11,6 +11,7 @@
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
 #include <linux/reset.h>
+#include <linux/rtnetlink.h>
 #include <linux/clk.h>
 #include <linux/circ_buf.h>
 
@@ -889,8 +890,13 @@ static void hix5hd2_tx_timeout_task(struct work_struct *work)
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
@@ -1288,6 +1294,7 @@ static int hix5hd2_dev_remove(struct platform_device *pdev)
 	struct hix5hd2_priv *priv = netdev_priv(ndev);
 
 	unregister_netdev(ndev);
+	cancel_work_sync(&priv->tx_timeout_task);
 	mdiobus_unregister(priv->bus);
 	mdiobus_free(priv->bus);
 
@@ -1295,7 +1302,6 @@ static int hix5hd2_dev_remove(struct platform_device *pdev)
 		hix5hd2_destroy_sg_desc_queue(priv);
 	hix5hd2_destroy_hw_desc_queue(priv);
 	of_node_put(priv->phy_node);
-	cancel_work_sync(&priv->tx_timeout_task);
 	free_netdev(ndev);
 
 	return 0;
-- 
2.53.0



