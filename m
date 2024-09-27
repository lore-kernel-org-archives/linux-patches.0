Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3678D17B515;
	Fri, 27 Sep 2024 12:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440148; cv=none; b=vF52zMB/9InpsvWJE9zyASDa48r3ZOQTW4NdKn5lCl2witIE+MOE0XIgmslDrKYDx3d0HYOZ0n4XwPQ+x7I2754hK1el9sY1H0evXc6NmYeRHhBWt0lA7Ed1pOJsSZuJ4S941u8IcfZAqyv4jp2f/U/4gE/aflYite5L5mAqBFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440148; c=relaxed/simple;
	bh=8VHwLrbK9y5j60dx+h4oeWvNqvyRq7NpMvBMJxhtKAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R37aBJBC5eCjchNpRZ1OaHccQn8BRnRLkoJ8H6WLDEoPpiLfshqfCRhBXJpneOG8WWiVi0Ejuudq/p9hkR61V76MbgQNgQdjwjypDH6fqufYYI/KeaLkUF6wdRAafPcHmcBp/SNVJYtQPTeU7GCjXT0EnhMpw3PExzu9Qb93v0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofq8ir1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofq8ir1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B52DC4CEC4;
	Fri, 27 Sep 2024 12:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440147;
	bh=8VHwLrbK9y5j60dx+h4oeWvNqvyRq7NpMvBMJxhtKAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ofq8ir1pn8+9Wwqulx/qb1YpH0zFsxu8rSKQvg+pBVlyGmDxIghU0APVRB0+G4qTE
	 CtYzX0opYn3H8Wh9yIK/kpMUyvlwB9Ds4HlrU8NktyUfiL0OeFgWnuBDp0GzFBeR8W
	 8a7tZv/tQGbMSzLry6olD+Yb2D2ybD6QQLPu94PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 23/58] can: m_can: Limit coalescing to peripheral instances
Date: Fri, 27 Sep 2024 14:23:25 +0200
Message-ID: <20240927121719.737748965@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Schneider-Pargmann <msp@baylibre.com>

[ Upstream commit e443d15b949952ee039b731d5c35bcbafa300024 ]

The use of coalescing for non-peripheral chips in the current
implementation is limited to non-existing. Disable the possibility to
set coalescing through ethtool.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://lore.kernel.org/all/20240805183047.305630-8-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index e4f0a382c2165..ddde067f593fc 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -2141,7 +2141,7 @@ static int m_can_set_coalesce(struct net_device *dev,
 	return 0;
 }
 
-static const struct ethtool_ops m_can_ethtool_ops = {
+static const struct ethtool_ops m_can_ethtool_ops_coalescing = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS_IRQ |
 		ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ |
 		ETHTOOL_COALESCE_TX_USECS_IRQ |
@@ -2152,18 +2152,20 @@ static const struct ethtool_ops m_can_ethtool_ops = {
 	.set_coalesce = m_can_set_coalesce,
 };
 
-static const struct ethtool_ops m_can_ethtool_ops_polling = {
+static const struct ethtool_ops m_can_ethtool_ops = {
 	.get_ts_info = ethtool_op_get_ts_info,
 };
 
-static int register_m_can_dev(struct net_device *dev)
+static int register_m_can_dev(struct m_can_classdev *cdev)
 {
+	struct net_device *dev = cdev->net;
+
 	dev->flags |= IFF_ECHO;	/* we support local echo */
 	dev->netdev_ops = &m_can_netdev_ops;
-	if (dev->irq)
-		dev->ethtool_ops = &m_can_ethtool_ops;
+	if (dev->irq && cdev->is_peripheral)
+		dev->ethtool_ops = &m_can_ethtool_ops_coalescing;
 	else
-		dev->ethtool_ops = &m_can_ethtool_ops_polling;
+		dev->ethtool_ops = &m_can_ethtool_ops;
 
 	return register_candev(dev);
 }
@@ -2349,7 +2351,7 @@ int m_can_class_register(struct m_can_classdev *cdev)
 	if (ret)
 		goto rx_offload_del;
 
-	ret = register_m_can_dev(cdev->net);
+	ret = register_m_can_dev(cdev);
 	if (ret) {
 		dev_err(cdev->dev, "registering %s failed (err=%d)\n",
 			cdev->net->name, ret);
-- 
2.43.0



