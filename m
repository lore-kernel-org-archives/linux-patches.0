Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B72BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0365C433D2;
	Tue,  7 Mar 2023 17:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209266;
	bh=FLaoKP3mvUlsIyfzu8KuoroxST0CDW8UaBwZn1x7mjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ybcePFANIGzQ+r8xgqp+vOTFo0mAc53PxE2b9D8sQNuPLl3+B8KIQigbZx2ecfrdm
	 d59azFb6jiu8ht5H1zNeJTiQ89gCZJtEA40iMqKl8Ebnfmi1SNaZz7NrMazZVZcUu6
	 /DhSoygCPVY9unIALb4ldQ5SxaFRrgRpZrWjdQBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0164/1001] wifi: wilc1000: fix potential memory leak in wilc_mac_xmit()
Date: Tue,  7 Mar 2023 17:48:56 +0100
Message-Id: <20230307170029.138936430@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
index 9b319a455b96d..6f3ae0dff77ce 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -730,6 +730,7 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	if (skb->dev != ndev) {
 		netdev_err(ndev, "Packet not destined to this device\n");
+		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
 
-- 
2.39.2



