Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADE4320A02;
	Mon, 27 Oct 2025 19:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593180; cv=none; b=PxlmkuL1GBMBGAkFxtqLvb0z2sG0TqyHA5bkNzaSAuKQKPhP42smYK2lYbBo6qtjoMXM4/B1HgMLgJkhDWUTAS8BMs2Fv1cVLkeHx7JpUHC/ku7oFwFgvS7ecjvTLAY0M6A8XMwACHA5Ffvo+UbkIfMb7sMZOSOKQViQr+lFa2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593180; c=relaxed/simple;
	bh=74cSK6xoRSXGlcgByt+/2Mx3cdrms7iMHgl31KzWjiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFP2IcW4v87rF+q8Gno8WLGQCUDHW8Jb9yxICS4DbHE5QCFKFAhw8aAkS4+OKSjgsMuPEZsi3hjYs7J+Kf/VN92RPEILpVtL/31QZk8eHnweFzLP1jsDQZKz9lcc1ZkCRu/2G0hT00Ho0/RkIi9DCe55dQwsVSN/FgpBU5cEyTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AusB6sXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AusB6sXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F467C4CEF1;
	Mon, 27 Oct 2025 19:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593179;
	bh=74cSK6xoRSXGlcgByt+/2Mx3cdrms7iMHgl31KzWjiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AusB6sXemmt47REh2Qwd11Omb4duKpz1vwKiEu0BsFt/M4FgQ/j84xVTFOGhlErWD
	 rnXWrM4d0Eou1IFZyb394Hjxk7s4llezAJyf5+yZVQo+BT5Mai50GfO0gxCjAYdkKU
	 /LKsLFChLVFCvYg1Ib2lkUUZIHOMPFnZTbt+Zayw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 044/184] can: rockchip-canfd: rkcanfd_start_xmit(): use can_dev_dropped_skb() instead of can_dropped_invalid_skb()
Date: Mon, 27 Oct 2025 19:35:26 +0100
Message-ID: <20251027183516.092879918@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 3a3bc9bbb3a0287164a595787df0c70d91e77cfd ]

In addition to can_dropped_invalid_skb(), the helper function
can_dev_dropped_skb() checks whether the device is in listen-only mode and
discards the skb accordingly.

Replace can_dropped_invalid_skb() by can_dev_dropped_skb() to also drop
skbs in for listen-only mode.

Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Closes: https://lore.kernel.org/all/20251017-bizarre-enchanted-quokka-f3c704-mkl@pengutronix.de/
Fixes: ff60bfbaf67f ("can: rockchip_canfd: add driver for Rockchip CAN-FD controller")
Link: https://patch.msgid.link/20251017-fix-skb-drop-check-v1-3-556665793fa4@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rockchip/rockchip_canfd-tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/rockchip/rockchip_canfd-tx.c b/drivers/net/can/rockchip/rockchip_canfd-tx.c
index 865a15e033a9e..12200dcfd3389 100644
--- a/drivers/net/can/rockchip/rockchip_canfd-tx.c
+++ b/drivers/net/can/rockchip/rockchip_canfd-tx.c
@@ -72,7 +72,7 @@ netdev_tx_t rkcanfd_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	int err;
 	u8 i;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	if (!netif_subqueue_maybe_stop(priv->ndev, 0,
-- 
2.51.0



