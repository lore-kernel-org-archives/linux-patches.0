Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7F117727;
	Mon, 27 May 2024 19:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838255; cv=none; b=gYFPmbK238/TEt3xMApu/wZKpH1QspL22iSxfdDQwiLRSG3oTUSdH4hOKGjaoh+GEH166e07S76dN1x8j/v9U6LMnX1cOyQcWSVViPMJahAyEo93RCAVl0kU9nPN9qpo0AoWndUsE+uLtlE6lQB44HXAEO+KOtwn5nAQn7X9+ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838255; c=relaxed/simple;
	bh=zh0TQE8uVSafsVciF8PXypBHmXTxvVmRLVV3nIzjWxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V47JJ9597l5cYRAC8h6DE8lrFhdkxDbQPL1xXepXNofpg/EqkCIvbKfLZFjOxw+DNjvwZP+OGBWkRC43bhGMSnd2OLkJqIpaR/hhvZNGrRNTN9KWDhPfcEA95Q5IEYS3JkTPCsImytfP1bVtFSBWoSWs+eSio2S6ijWX2OaNo0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLVU8yv1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLVU8yv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64059C2BBFC;
	Mon, 27 May 2024 19:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838255;
	bh=zh0TQE8uVSafsVciF8PXypBHmXTxvVmRLVV3nIzjWxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLVU8yv1y7aKFacxK45pjonXRYzyMZGleb3NKKP4N8iX2ZLo63xjUB+tqHNDFhlAJ
	 OKBt/iiFKLboHTMYVVURkhnxyOdFb0vASypg+8lqCcjd79pYaeBetldoIzptMw1iB+
	 nBaGNb62eedhVAwDi45bpLxwmHcygFVir3CmHsKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 325/493] net: fec: remove .ndo_poll_controller to avoid deadlocks
Date: Mon, 27 May 2024 20:55:27 +0200
Message-ID: <20240527185640.897230375@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit c2e0c58b25a0a0c37ec643255558c5af4450c9f5 ]

There is a deadlock issue found in sungem driver, please refer to the
commit ac0a230f719b ("eth: sungem: remove .ndo_poll_controller to avoid
deadlocks"). The root cause of the issue is that netpoll is in atomic
context and disable_irq() is called by .ndo_poll_controller interface
of sungem driver, however, disable_irq() might sleep. After analyzing
the implementation of fec_poll_controller(), the fec driver should have
the same issue. Due to the fec driver uses NAPI for TX completions, the
.ndo_poll_controller is unnecessary to be implemented in the fec driver,
so fec_poll_controller() can be safely removed.

Fixes: 7f5c6addcdc0 ("net/fec: add poll controller function for fec nic")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Link: https://lore.kernel.org/r/20240511062009.652918-1-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 26 -----------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 8decb1b072c5e..e92a830330590 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3678,29 +3678,6 @@ fec_set_mac_address(struct net_device *ndev, void *p)
 	return 0;
 }
 
-#ifdef CONFIG_NET_POLL_CONTROLLER
-/**
- * fec_poll_controller - FEC Poll controller function
- * @dev: The FEC network adapter
- *
- * Polled functionality used by netconsole and others in non interrupt mode
- *
- */
-static void fec_poll_controller(struct net_device *dev)
-{
-	int i;
-	struct fec_enet_private *fep = netdev_priv(dev);
-
-	for (i = 0; i < FEC_IRQ_NUM; i++) {
-		if (fep->irq[i] > 0) {
-			disable_irq(fep->irq[i]);
-			fec_enet_interrupt(fep->irq[i], dev);
-			enable_irq(fep->irq[i]);
-		}
-	}
-}
-#endif
-
 static inline void fec_enet_set_netdev_features(struct net_device *netdev,
 	netdev_features_t features)
 {
@@ -4007,9 +3984,6 @@ static const struct net_device_ops fec_netdev_ops = {
 	.ndo_tx_timeout		= fec_timeout,
 	.ndo_set_mac_address	= fec_set_mac_address,
 	.ndo_eth_ioctl		= phy_do_ioctl_running,
-#ifdef CONFIG_NET_POLL_CONTROLLER
-	.ndo_poll_controller	= fec_poll_controller,
-#endif
 	.ndo_set_features	= fec_set_features,
 	.ndo_bpf		= fec_enet_bpf,
 	.ndo_xdp_xmit		= fec_enet_xdp_xmit,
-- 
2.43.0



