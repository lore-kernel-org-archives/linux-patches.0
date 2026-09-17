Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2D451B193;
	Thu, 17 Sep 2026 17:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666264; cv=none; b=JTo+MSu2PggRdG6nhUHKEkJqjhkWpOSXmJntrskRO2stiPgA8QxGQA8CX9bGrVbE5eN4QkRNJyMh0MCoyz0sLi/hmBpQl4TSTDpcRAUsV4WueOZNNNilwF+DzCZSGd8XYgEhqRIt5a+v10spTw49o27yyEXXk6v+aYff7B5bX6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666264; c=relaxed/simple;
	bh=NXEEHqBhICtL4jLBSZHQ0/0cbdAO3ZkAiFbQyOTQCk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Du5k+z+AMaW8VeFxQHkBA6S4hPSF9DEobULLUmiHnEdsD3SzHmtJ9k3CG7PgteLIrJ10406J6OtFNeQsODLT6ok9gRImV3g2zhlwGj53W4a1+9JYBqBYRinFvx3ny2dGXAt51+qkpjLWr+OT1WyrwH297DX/4anYzNBievvFnvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2MU4/jH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2MU4/jH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3501F000FF;
	Thu, 17 Sep 2026 17:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666263;
	bh=9ds6aLtMCM+SNOlAf9miXudBfrOU5+TAwxWW+6gjyYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l2MU4/jHlIpKE+sjQjgvvc2Ga6o2BTF9GnamUb146vLyXQqJuenfkO5UxL64vFwvB
	 4gwrNSObpwzTqxgTe+YAZgnAw7eAi/57ol9LRwdkQVqC5yKCeIqi8AOFy1CWXWeRL6
	 n96x1KJM/4hf++gl9ni/gMWMQw9HwGKdTUcQtq5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0942/1250] net: stmmac: add TSO check for header length
Date: Thu, 17 Sep 2026 16:12:17 +0100
Message-ID: <20260917151617.555014672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 6732e474f880468435a79d05811c8c814c5d71f8 ]

According to the STM32MP151 documentation which covers dwmac v4.2, the
hardware TSO feature can handle header lengths up to a maximum of 1023
bytes.

Add a .ndo_features_check() method implementation to check the header
length meets these requirements, otherwise fall back to software GSO.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/E1w7ptO-0000000EatC-39il@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5e38d732ec67 ("net: stmmac: fix TX descriptor availability check for TSO traffic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c   | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 609f056d4a70f..49651dc792278 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4176,6 +4176,20 @@ static size_t stmmac_tso_header_size(struct sk_buff *skb)
 	return size;
 }
 
+/* STM32MP151 (dwmac v4.2) and STM32MP25xx (dwmac v5.3) states for TDES2 normal
+ * (read format) descriptor that the maximum header length supported for the
+ * TSO feature is 1023 bytes.
+ *
+ * While IPv4 is limited to MAC+VLAN+IPv4+ext+TCP+ext = 138 bytes, the IPv6
+ * extension headers aren't similarly limited.
+ */
+static bool stmmac_tso_valid_packet(struct sk_buff *skb)
+{
+	size_t header_len = stmmac_tso_header_size(skb);
+
+	return header_len <= 1023;
+}
+
 /**
  *  stmmac_tso_xmit - Tx entry point of the driver for oversized frames (TSO)
  *  @skb : the socket buffer
@@ -4754,7 +4768,8 @@ static netdev_features_t stmmac_features_check(struct sk_buff *skb,
 
 	if (skb_is_gso(skb)) {
 		queue = skb_get_queue_mapping(skb);
-		if (!stmmac_tso_channel_permitted(netdev_priv(dev), queue))
+		if (!stmmac_tso_channel_permitted(netdev_priv(dev), queue) ||
+		    !stmmac_tso_valid_packet(skb))
 			features &= ~NETIF_F_GSO_MASK;
 	}
 
-- 
2.53.0



