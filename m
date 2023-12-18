Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4F13786D;
	Mon, 18 Dec 2023 14:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZJfTqgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350D9C433C8;
	Mon, 18 Dec 2023 14:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908549;
	bh=Fqm3pFWIdBkcN8YcDHfCefWVJGnhSccRqzn6OLvw2/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZJfTqghZ5KYSpO9Zm6/9HCWyywYAq+WxSeG/qvEc56Z5Gd6IpFcmyTAoKrh65X7S
	 Snm+BWEMnNUCpIMB/kp6bJ1XVhD3UhX16lk7HzVeC1QuFsmfsSVZA07v2qi2pvbN8i
	 JNnu9JKTWhGO7c1WCg9XzocI0lVKs1lEy7mWY7Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radu Bulie <radu-andrei.bulie@nxp.com>,
	Wei Fang <wei.fang@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/62] net: fec: correct queue selection
Date: Mon, 18 Dec 2023 14:51:35 +0100
Message-ID: <20231218135046.716575313@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135046.178317233@linuxfoundation.org>
References: <20231218135046.178317233@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radu Bulie <radu-andrei.bulie@nxp.com>

[ Upstream commit 9fc95fe95c3e2a63ced8eeca4b256518ab204b63 ]

The old implementation extracted VLAN TCI info from the payload
before the VLAN tag has been pushed in the payload.

Another problem was that the VLAN TCI was extracted even if the
packet did not have VLAN protocol header.

This resulted in invalid VLAN TCI and as a consequence a random
queue was computed.

This patch fixes the above issues and use the VLAN TCI from the
skb if it is present or VLAN TCI from payload if present. If no
VLAN header is present queue 0 is selected.

Fixes: 52c4a1a85f4b ("net: fec: add ndo_select_queue to fix TX bandwidth fluctuations")
Signed-off-by: Radu Bulie <radu-andrei.bulie@nxp.com>
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 27 +++++++++--------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index e18b3b72fc0df..4ce913559c91d 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3266,31 +3266,26 @@ static int fec_set_features(struct net_device *netdev,
 	return 0;
 }
 
-static u16 fec_enet_get_raw_vlan_tci(struct sk_buff *skb)
-{
-	struct vlan_ethhdr *vhdr;
-	unsigned short vlan_TCI = 0;
-
-	if (skb->protocol == htons(ETH_P_ALL)) {
-		vhdr = (struct vlan_ethhdr *)(skb->data);
-		vlan_TCI = ntohs(vhdr->h_vlan_TCI);
-	}
-
-	return vlan_TCI;
-}
-
 static u16 fec_enet_select_queue(struct net_device *ndev, struct sk_buff *skb,
 				 struct net_device *sb_dev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	u16 vlan_tag;
+	u16 vlan_tag = 0;
 
 	if (!(fep->quirks & FEC_QUIRK_HAS_AVB))
 		return netdev_pick_tx(ndev, skb, NULL);
 
-	vlan_tag = fec_enet_get_raw_vlan_tci(skb);
-	if (!vlan_tag)
+	/* VLAN is present in the payload.*/
+	if (eth_type_vlan(skb->protocol)) {
+		struct vlan_ethhdr *vhdr = skb_vlan_eth_hdr(skb);
+
+		vlan_tag = ntohs(vhdr->h_vlan_TCI);
+	/*  VLAN is present in the skb but not yet pushed in the payload.*/
+	} else if (skb_vlan_tag_present(skb)) {
+		vlan_tag = skb->vlan_tci;
+	} else {
 		return vlan_tag;
+	}
 
 	return fec_enet_vlan_pri_to_queue[vlan_tag >> 13];
 }
-- 
2.43.0



