Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C576FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FACAC433EF;
	Mon,  3 Apr 2023 14:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533357;
	bh=oBdmUSTIaXMJEYtjpL+7zXX5ZYXXep+XtS4WHi757UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLDmcN+sngdnMJaLJFteq1e8R4bmg2lXpLiu/YM0nUH2aLCJj24B882LwYpak/8ds
	 leSX7EiWAS3nLjK7/L6yeAObSZWi+milQ22ll0HhYgDoTipe8y40oEH3pG7bIDBjMZ
	 xrCodpIXbbrH5ZIcz4dg817t5zD446hCN5K8KhsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <simon.horman@corigine.com>,
	Felix Fietkau <nbd@nbd.name>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 122/187] net: ethernet: mtk_eth_soc: fix L2 offloading with DSA untag offload
Date: Mon,  3 Apr 2023 16:09:27 +0200
Message-Id: <20230403140419.979855334@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 5f36ca1b841fb17a20249fd9fedafc7dc7fdd940 ]

Check for skb metadata in order to detect the case where the DSA header
is not present.

Fixes: 2d7605a72906 ("net: ethernet: mtk_eth_soc: enable hardware DSA untagging")
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20230330120840.52079-2-nbd@nbd.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 6 +++---
 drivers/net/ethernet/mediatek/mtk_ppe.c     | 5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 9f9df6255baa1..bd7c18c839d42 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2006,9 +2006,6 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			skb_checksum_none_assert(skb);
 		skb->protocol = eth_type_trans(skb, netdev);
 
-		if (reason == MTK_PPE_CPU_REASON_HIT_UNBIND_RATE_REACHED)
-			mtk_ppe_check_skb(eth->ppe[0], skb, hash);
-
 		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
 			if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
 				if (trxd.rxd3 & RX_DMA_VTAG_V2) {
@@ -2036,6 +2033,9 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			__vlan_hwaccel_put_tag(skb, htons(vlan_proto), vlan_tci);
 		}
 
+		if (reason == MTK_PPE_CPU_REASON_HIT_UNBIND_RATE_REACHED)
+			mtk_ppe_check_skb(eth->ppe[0], skb, hash);
+
 		skb_record_rx_queue(skb, 0);
 		napi_gro_receive(napi, skb);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 1ff024f42444b..52db211d9596a 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -8,6 +8,7 @@
 #include <linux/platform_device.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
+#include <net/dst_metadata.h>
 #include <net/dsa.h>
 #include "mtk_eth_soc.h"
 #include "mtk_ppe.h"
@@ -699,7 +700,9 @@ void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 		    skb->dev->dsa_ptr->tag_ops->proto != DSA_TAG_PROTO_MTK)
 			goto out;
 
-		tag += 4;
+		if (!skb_metadata_dst(skb))
+			tag += 4;
+
 		if (get_unaligned_be16(tag) != ETH_P_8021Q)
 			break;
 
-- 
2.39.2



