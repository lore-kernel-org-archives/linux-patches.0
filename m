Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F034A1BF7F9;
	Wed, 20 Nov 2024 13:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107710; cv=none; b=pUgJR3OV2msOQMf2IP4WhctzAxUq4oWHS5ZAIGTAVE8HEKAAc9Q2VubW75o7WeJCiOHggG0NU5JskpS4hF4zMgGz4ojvmS8J/5w+1y+69guMDlaZu7IKZVMIDanNSsgz5dZg8ooSt9IFOch1DJvhOS/UIUG9a7NFi/qcN3Fr1fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107710; c=relaxed/simple;
	bh=GwfFr5xbFpIl2xt/z6tftNiOWtaGjwxP2Y2qGgBd1w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRHGSWstOn7vfjSLT1YYMxTNQgH5pDm5dkdVzZeE7v+s6eWek1XFcY1zs5XuVQy00zg0/xdKbViuJNq9IEAdrV6n/sjz7Grv5atVl+fMj1hLaPnrBChqKkcmxui1Z1SuQ/LaWjRMfP7s58jS5JhonmELyqGRYGwnounQTRlgni4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=At7iecgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="At7iecgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD480C4CED1;
	Wed, 20 Nov 2024 13:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107709;
	bh=GwfFr5xbFpIl2xt/z6tftNiOWtaGjwxP2Y2qGgBd1w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=At7iecgMMHMcxfZ/FmU0UpoYpIFY8HeTmkEiS9wJu/qA0nhK2pnasTnddP6PEXlBo
	 IRNHUYsCdgGczGPe5AQLbD67hYds26+9CKtbpsNDh1fOBV3L6cpF/lNQlZYsaC0Msq
	 m7UEJRbQ7qLKNDNG4oGS1nBct1NiBmhGJqRqkJCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 60/73] net: fec: remove .ndo_poll_controller to avoid deadlocks
Date: Wed, 20 Nov 2024 13:58:46 +0100
Message-ID: <20241120125811.049647321@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_main.c |   26 --------------------------
 1 file changed, 26 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3508,29 +3508,6 @@ fec_set_mac_address(struct net_device *n
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
@@ -3604,9 +3581,6 @@ static const struct net_device_ops fec_n
 	.ndo_tx_timeout		= fec_timeout,
 	.ndo_set_mac_address	= fec_set_mac_address,
 	.ndo_eth_ioctl		= fec_enet_ioctl,
-#ifdef CONFIG_NET_POLL_CONTROLLER
-	.ndo_poll_controller	= fec_poll_controller,
-#endif
 	.ndo_set_features	= fec_set_features,
 };
 


