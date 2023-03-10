Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531F8881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD90C433A0;
	Fri, 10 Mar 2023 14:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459608;
	bh=UmbTJXG3/FVwqNHygXRLI7rsw2TQgCXFA97ylurlsl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrX2AlQ9iGIXj6KDhVxluvnf/HCo13spdwoS7ZexmbA8dq2wbmvqJyoP/xtKCwAGY
	 u6DBSDYA+WLpnhHbkZuBN3wlXSQgWPU8xqA9FaKSXv6dzA/yFXzCnOMMhFotJBAD0e
	 6NsrTNFgrN6ey/pveDI+DM4wOFrch4qGIFXVts20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/529] wifi: wilc1000: fix potential memory leak in wilc_mac_xmit()
Date: Fri, 10 Mar 2023 14:33:24 +0100
Message-Id: <20230310133807.817695188@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit deb962ec9e1c9a81babd3d37542ad4bd6ac3396e ]

The wilc_mac_xmit() returns NETDEV_TX_OK without freeing skb, add
dev_kfree_skb() to fix it. Compile tested only.

Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/1668684964-48622-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 20615c7ec1683..c508f429984ab 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -684,6 +684,7 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	if (skb->dev != ndev) {
 		netdev_err(ndev, "Packet not destined to this device\n");
+		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
 
-- 
2.39.2



