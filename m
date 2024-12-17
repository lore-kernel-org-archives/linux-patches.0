Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBC0142E77;
	Tue, 17 Dec 2024 17:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456230; cv=none; b=drnKrRXuXZ9Rot95T/B4krNCNR8o7TB5LL9GqV5A3Y9p1YHyff87xNrRPcyELfaeDqyQnJqx1j77yyfcFG2KcNVJeC5xuC7cZR7AxmGAt2RXHPjnrk/e3fL+bFxIjz+pid5UM3fFiukgDBUZxVHxEJyBSZBVxLBY6m6OvfyPhKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456230; c=relaxed/simple;
	bh=Tpd6495KxIpULnOnjwweYplU2YP0XQHdD00YtKwp3AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWB820py4ETLJNejx8PMpA7fWB3ZOVnCwia/urE6vIJzi6VnLOBE3LudV+lCJQnMqB99OTbTi0YlH9O9Fve8VI74hIFgt0IlAgetvstsu/B6oE1ozS1P2X7JY97SSHYh42Z1S2W5+MBZ/WFjhTyEdsJdqUvK7DhAG6mJy4xsAVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3bm9z5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3bm9z5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0805C4CED3;
	Tue, 17 Dec 2024 17:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456230;
	bh=Tpd6495KxIpULnOnjwweYplU2YP0XQHdD00YtKwp3AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3bm9z5xrLDMfpm7xLzzd+APJrFoajQLPq97tnRx/96GlvppIT1ZRi/KMzZ1rC1NM
	 a3QGIp30sK/4g+mvYKEA6poi5kZFoHx0EamDwjp1vyCbcbqgqQalA57xSmK7akvVXI
	 5MYnNkOfScJFbwRYHFdrSwrW056mCgpSSEcmjb/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/109] net: rswitch: Add a setting ext descriptor function
Date: Tue, 17 Dec 2024 18:07:56 +0100
Message-ID: <20241217170536.393425999@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit fcff581ee43078cf23216aa7079012e935a6a078 ]

If the driver would like to transmit a jumbo frame like 2KiB or more,
it should be split into multiple queues. In the near future, to support
this, add a setting ext descriptor function to improve code readability.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0c9547e6ccf4 ("net: renesas: rswitch: fix race window between tx start and complete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 73 +++++++++++++++++---------
 1 file changed, 47 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index b008a44ea6ac..c01b4bd3f812 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1516,6 +1516,51 @@ static int rswitch_stop(struct net_device *ndev)
 	return 0;
 };
 
+static bool rswitch_ext_desc_set_info1(struct rswitch_device *rdev,
+				       struct sk_buff *skb,
+				       struct rswitch_ext_desc *desc)
+{
+	desc->info1 = cpu_to_le64(INFO1_DV(BIT(rdev->etha->index)) |
+				  INFO1_IPV(GWCA_IPV_NUM) | INFO1_FMT);
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
+		struct rswitch_gwca_ts_info *ts_info;
+
+		ts_info = kzalloc(sizeof(*ts_info), GFP_ATOMIC);
+		if (!ts_info)
+			return false;
+
+		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+		rdev->ts_tag++;
+		desc->info1 |= cpu_to_le64(INFO1_TSUN(rdev->ts_tag) | INFO1_TXC);
+
+		ts_info->skb = skb_get(skb);
+		ts_info->port = rdev->port;
+		ts_info->tag = rdev->ts_tag;
+		list_add_tail(&ts_info->list, &rdev->priv->gwca.ts_info_list);
+
+		skb_tx_timestamp(skb);
+	}
+
+	return true;
+}
+
+static bool rswitch_ext_desc_set(struct rswitch_device *rdev,
+				 struct sk_buff *skb,
+				 struct rswitch_ext_desc *desc,
+				 dma_addr_t dma_addr, u16 len, u8 die_dt)
+{
+	rswitch_desc_set_dptr(&desc->desc, dma_addr);
+	desc->desc.info_ds = cpu_to_le16(len);
+	if (!rswitch_ext_desc_set_info1(rdev, skb, desc))
+		return false;
+
+	dma_wmb();
+
+	desc->desc.die_dt = die_dt;
+
+	return true;
+}
+
 static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct rswitch_device *rdev = netdev_priv(ndev);
@@ -1539,33 +1584,9 @@ static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *nd
 	gq->skbs[gq->cur] = skb;
 	gq->unmap_addrs[gq->cur] = dma_addr;
 	desc = &gq->tx_ring[gq->cur];
-	rswitch_desc_set_dptr(&desc->desc, dma_addr);
-	desc->desc.info_ds = cpu_to_le16(skb->len);
-
-	desc->info1 = cpu_to_le64(INFO1_DV(BIT(rdev->etha->index)) |
-				  INFO1_IPV(GWCA_IPV_NUM) | INFO1_FMT);
-	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
-		struct rswitch_gwca_ts_info *ts_info;
-
-		ts_info = kzalloc(sizeof(*ts_info), GFP_ATOMIC);
-		if (!ts_info)
-			goto err_unmap;
-
-		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
-		rdev->ts_tag++;
-		desc->info1 |= cpu_to_le64(INFO1_TSUN(rdev->ts_tag) | INFO1_TXC);
-
-		ts_info->skb = skb_get(skb);
-		ts_info->port = rdev->port;
-		ts_info->tag = rdev->ts_tag;
-		list_add_tail(&ts_info->list, &rdev->priv->gwca.ts_info_list);
-
-		skb_tx_timestamp(skb);
-	}
-
-	dma_wmb();
+	if (!rswitch_ext_desc_set(rdev, skb, desc, dma_addr, skb->len, DT_FSINGLE | DIE))
+		goto err_unmap;
 
-	desc->desc.die_dt = DT_FSINGLE | DIE;
 	wmb();	/* gq->cur must be incremented after die_dt was set */
 
 	gq->cur = rswitch_next_queue_index(gq, true, 1);
-- 
2.39.5



