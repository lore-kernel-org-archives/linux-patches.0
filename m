Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E439FC8E6;
	Mon, 22 Sep 2025 19:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569487; cv=none; b=XHrYr45BsiLaJC6VXA45TCwzESlkt1iEf3mzyhaThbYL56Xh8ZBNmz3YW+kues+gGMBi9Q9aWc1dXxdh+YAPFoMERnN0IaEs4dOOC2DnlspQIx67pF195ekiO4v23knbhFesLqPczxN2zcQ0m2lJQr5niXC3l2I7bfru3Sor4Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569487; c=relaxed/simple;
	bh=F2nmrTdTf9kQXGV5YCU8Kz879PiSxTwTU7yw69jZn3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3LXLJWB3QRY1rzDFcKtYxzpKkBgWCoZ1o1R5B9RNvFUhzMHeY3LO3RKLMsIg01uVVMLvvYJH4pTljRnQTntrEurJDNCN0V13yY76JZNVXQ6mMlWVlQdyJ5u3NZcwtgspK5QXvThZTDyF66Guw+7JvuKT676NubxO8/BLatbrwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+ciZGAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+ciZGAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E716C4CEF0;
	Mon, 22 Sep 2025 19:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569486;
	bh=F2nmrTdTf9kQXGV5YCU8Kz879PiSxTwTU7yw69jZn3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+ciZGAU6KVeR8UitpTGvCvWI7z5vJ3fRUxceuQO/bUIh2Rq5O5/MFs24C6efoAKV
	 xoD1LlDpu/aLIgCf4dgob1lIAsIJX3tPvvaZyuyT6eHmnd8gfuGHsg11DDkAT9qPxF
	 w+Zt2JMkFcZZO9/BkxImAn4HD/ISvpWBSoRI8AlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeounsu Moon <yyyynoom@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 11/61] net: natsemi: fix `rx_dropped` double accounting on `netif_rx()` failure
Date: Mon, 22 Sep 2025 21:29:04 +0200
Message-ID: <20250922192403.857344855@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yeounsu Moon <yyyynoom@gmail.com>

[ Upstream commit 93ab4881a4e2b9657bdce4b8940073bfb4ed5eab ]

`netif_rx()` already increments `rx_dropped` core stat when it fails.
The driver was also updating `ndev->stats.rx_dropped` in the same path.
Since both are reported together via `ip -s -s` command, this resulted
in drops being counted twice in user-visible stats.

Keep the driver update on `if (unlikely(!skb))`, but skip it after
`netif_rx()` errors.

Fixes: caf586e5f23c ("net: add a core netdev->rx_dropped counter")
Signed-off-by: Yeounsu Moon <yyyynoom@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250913060135.35282-3-yyyynoom@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/natsemi/ns83820.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index 998586872599b..c692d2e878b2e 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -820,7 +820,7 @@ static void rx_irq(struct net_device *ndev)
 	struct ns83820 *dev = PRIV(ndev);
 	struct rx_info *info = &dev->rx_info;
 	unsigned next_rx;
-	int rx_rc, len;
+	int len;
 	u32 cmdsts;
 	__le32 *desc;
 	unsigned long flags;
@@ -881,8 +881,10 @@ static void rx_irq(struct net_device *ndev)
 		if (likely(CMDSTS_OK & cmdsts)) {
 #endif
 			skb_put(skb, len);
-			if (unlikely(!skb))
+			if (unlikely(!skb)) {
+				ndev->stats.rx_dropped++;
 				goto netdev_mangle_me_harder_failed;
+			}
 			if (cmdsts & CMDSTS_DEST_MULTI)
 				ndev->stats.multicast++;
 			ndev->stats.rx_packets++;
@@ -901,15 +903,12 @@ static void rx_irq(struct net_device *ndev)
 				__vlan_hwaccel_put_tag(skb, htons(ETH_P_IPV6), tag);
 			}
 #endif
-			rx_rc = netif_rx(skb);
-			if (NET_RX_DROP == rx_rc) {
-netdev_mangle_me_harder_failed:
-				ndev->stats.rx_dropped++;
-			}
+			netif_rx(skb);
 		} else {
 			dev_kfree_skb_irq(skb);
 		}
 
+netdev_mangle_me_harder_failed:
 		nr++;
 		next_rx = info->next_rx;
 		desc = info->descs + (DESC_SIZE * next_rx);
-- 
2.51.0



