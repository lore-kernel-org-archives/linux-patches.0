Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357F02BD033;
	Mon, 27 Oct 2025 19:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592935; cv=none; b=DekRG41UGExRy+J+kjXTANZQ4YdOkyfEZS/4OJunbpdBULSX8z1gd87xuDqdw/vTJKELSN2n0SYLqlzTo/FW7qs0eYb2Kdirx7zIi5Woox/OdAH9EkzN0X3Cdbfd9BDUJgMmrW17yBRc4uPwdhgcsJ2MPphy8UIJL3QL2Mqyl2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592935; c=relaxed/simple;
	bh=maKULD8YfwwbLq4VAhd4m+ROS8mGrLCtI1nNuwvQyF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNjJKZHV5IWEWHt2P9aLPZhN8CPDV73PeuOZ2l0KPx9dH95b9Y1O6JI+VXIJNtBR0hd4c/SjhbdGvx3ETDK42VtwCGhH48Irc749zYc0Ts4lvA+QFeIoxodU/F7nP6h4gkQk2m/DryxcvjJmXTeY8vzSDh4UJDFjDtVzSGn0y8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQjAMkYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQjAMkYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2F0C4CEF1;
	Mon, 27 Oct 2025 19:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592935;
	bh=maKULD8YfwwbLq4VAhd4m+ROS8mGrLCtI1nNuwvQyF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQjAMkYZ2NOQJYRpfuabZCo1AXosKm7TaQNosmwXEhFhgQeVnP6QwbmB9zueRDCvE
	 0X3Jtqy2pb7YeZQrp1OYuRQ0V5AqK6XEwio6+FXngI0MUf8JR0e3hSe4pn6qluIRWp
	 KKCJQ30eZ+xt8O7a7jXJtELB9A87k4rVe8qrb6m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/117] can: rockchip-canfd: rkcanfd_start_xmit(): use can_dev_dropped_skb() instead of can_dropped_invalid_skb()
Date: Mon, 27 Oct 2025 19:35:58 +0100
Message-ID: <20251027183454.838229891@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



