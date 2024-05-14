Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB5012F5BD;
	Tue, 14 May 2024 11:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686777; cv=none; b=BsWQNwmNzIluRmwuWOdhoMPky9W5DyjZwHxkGlgSVARcEP01Y6gdGw43pJHxhUqgPcY8ROb5kWzfVgpGOP+BC3WIf92dszTq8+SED4/FkxhEUiDJd9RKPt6vY/SwqbxtMnZg2uxbNgC/2jF4CizLXJB88ayBNY9yGqR8XVxqA2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686777; c=relaxed/simple;
	bh=mTrznR+V+gdH+lDiDjx3PKrBSXtW/+k6mXSrMQb5Yhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuP4MODZfNivG/5r1p8BSP+k1UVTccFuK7+57PBhFnmUEJ9HXGhdXtoynZys3X4l1HQMdwayyVel7FChSel0xKe383QKr+kesNSojlfH4uPV6PpOqM/xTZfW17bIgrxLsNowCRpVjTSduoLX3K2ynkPNUzWbsBLbxByzBw14ifM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A0F0EHP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A0F0EHP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30815C2BD10;
	Tue, 14 May 2024 11:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686777;
	bh=mTrznR+V+gdH+lDiDjx3PKrBSXtW/+k6mXSrMQb5Yhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0F0EHP5cQtEp55B8AFQyF2e5g2lfM/pktrAM/3uHTC7mhuPku6v3EfcWnHd9JU/A
	 bWwZBHHfqxfhWg6uVVK5Cp60812AvMBv4UCpXaa1eh+GEeBh2guVjuW5gNNE2Dbbb6
	 4SCDCY2biXZ9mxCy+Cqr+/7clCo4PsBKtk9Hx/yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yu <zhangyu31@baidu.com>,
	Li RongQing <lirongqing@baidu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/63] net: slightly optimize eth_type_trans
Date: Tue, 14 May 2024 12:19:27 +0200
Message-ID: <20240514100948.253815114@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 45cf7959c30402d7c4ea43568a6f1bab0ba6ca63 ]

netperf udp stream shows that eth_type_trans takes certain cpu,
so adjust the mac address check order, and firstly check if it
is device address, and only check if it is multicast address
only if not the device address.

After this change:
To unicast, and skb dst mac is device mac, this is most of time
reduce a comparision
To unicast, and skb dst mac is not device mac, nothing change
To multicast, increase a comparision

Before:
1.03%  [kernel]          [k] eth_type_trans

After:
0.78%  [kernel]          [k] eth_type_trans

Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6e159fd653d7 ("ethernet: Add helper for assigning packet type when dest address does not match device address")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethernet/eth.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index ca06e9a53d15c..88a074dd983e6 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -165,15 +165,17 @@ __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev)
 	eth = (struct ethhdr *)skb->data;
 	skb_pull_inline(skb, ETH_HLEN);
 
-	if (unlikely(is_multicast_ether_addr_64bits(eth->h_dest))) {
-		if (ether_addr_equal_64bits(eth->h_dest, dev->broadcast))
-			skb->pkt_type = PACKET_BROADCAST;
-		else
-			skb->pkt_type = PACKET_MULTICAST;
+	if (unlikely(!ether_addr_equal_64bits(eth->h_dest,
+					      dev->dev_addr))) {
+		if (unlikely(is_multicast_ether_addr_64bits(eth->h_dest))) {
+			if (ether_addr_equal_64bits(eth->h_dest, dev->broadcast))
+				skb->pkt_type = PACKET_BROADCAST;
+			else
+				skb->pkt_type = PACKET_MULTICAST;
+		} else {
+			skb->pkt_type = PACKET_OTHERHOST;
+		}
 	}
-	else if (unlikely(!ether_addr_equal_64bits(eth->h_dest,
-						   dev->dev_addr)))
-		skb->pkt_type = PACKET_OTHERHOST;
 
 	/*
 	 * Some variants of DSA tagging don't have an ethertype field
-- 
2.43.0



