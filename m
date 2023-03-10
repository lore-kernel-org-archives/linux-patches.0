Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A919848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A68C4339C;
	Fri, 10 Mar 2023 14:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458486;
	bh=TKvm4l4LIxuq+q3VPpW9uNQOBvDZFKDpjOtU/DD+8Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTxTm1c9WfWGpNgSQpPIHjy4rROWuPusDbbz/3YZqQojpCeJ3DN4zT+glc56lT+Jd
	 YRMyiUogvmkdwa6GmIboXBsjjk/AOnk77ja1yUfIwUiz8RZGthrkmkA0pOIcjaMi7q
	 NggJC6wHGNl+cYZi2Bhk9q/JcRx0BF2mXBYOuduo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/357] wilc1000: let wilc_mac_xmit() return NETDEV_TX_OK
Date: Fri, 10 Mar 2023 14:35:31 +0100
Message-Id: <20230310133735.849211687@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>

[ Upstream commit cce0e08301fe43dc3fe983d5f098393d15f803f0 ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type defining 'NETDEV_TX_OK' but this
driver returns '0' instead of 'NETDEV_TX_OK'.

Fix this by returning 'NETDEV_TX_OK' instead of '0'.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200629104009.84077-1-luc.vanoostenryck@gmail.com
Stable-dep-of: deb962ec9e1c ("wifi: wilc1000: fix potential memory leak in wilc_mac_xmit()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wilc1000/wilc_netdev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_netdev.c b/drivers/staging/wilc1000/wilc_netdev.c
index 508acb8bb089f..c8cf88258d06d 100644
--- a/drivers/staging/wilc1000/wilc_netdev.c
+++ b/drivers/staging/wilc1000/wilc_netdev.c
@@ -717,14 +717,14 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	if (skb->dev != ndev) {
 		netdev_err(ndev, "Packet not destined to this device\n");
-		return 0;
+		return NETDEV_TX_OK;
 	}
 
 	tx_data = kmalloc(sizeof(*tx_data), GFP_ATOMIC);
 	if (!tx_data) {
 		dev_kfree_skb(skb);
 		netif_wake_queue(ndev);
-		return 0;
+		return NETDEV_TX_OK;
 	}
 
 	tx_data->buff = skb->data;
@@ -748,7 +748,7 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 		mutex_unlock(&wilc->vif_mutex);
 	}
 
-	return 0;
+	return NETDEV_TX_OK;
 }
 
 static int wilc_mac_close(struct net_device *ndev)
-- 
2.39.2



