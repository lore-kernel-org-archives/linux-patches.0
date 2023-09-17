Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3FA7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A45AC433C8;
	Sun, 17 Sep 2023 19:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980787;
	bh=F2kLMIdedlDAEGkCZrRidVTHlHXfAtDL6uyYy2yYRQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gC5xSeXmIaiQ9h5hTXSYhcI3ebXcQN2XeCcFTtQIlAxuidk0lvMh6JqNTv9AW39kN
	 LuaUb9Y2hK0ullQhMRqiU54zTe+R49OQJhKDSpDagGYrc95uuRmN2YWx3UjTbum8Yh
	 NfO+AkvyaCvqDscG+Rb7Rrt6MNuPy8kW38kqGOrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 258/285] net: ethernet: adi: adin1110: use eth_broadcast_addr() to assign broadcast address
Date: Sun, 17 Sep 2023 21:14:18 +0200
Message-ID: <20230917191100.193836225@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 54024dbec95585243391caeb9f04a2620e630765 ]

Use eth_broadcast_addr() to assign broadcast address instead
of memset().

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 32530dba1bd4 ("net:ethernet:adi:adin1110: Fix forwarding offload")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/adi/adin1110.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index f5c2d7a9abc10..1c009b485188d 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -739,7 +739,7 @@ static int adin1110_broadcasts_filter(struct adin1110_port_priv *port_priv,
 	u32 port_rules = 0;
 	u8 mask[ETH_ALEN];
 
-	memset(mask, 0xFF, ETH_ALEN);
+	eth_broadcast_addr(mask);
 
 	if (accept_broadcast && port_priv->state == BR_STATE_FORWARDING)
 		port_rules = adin1110_port_rules(port_priv, true, true);
@@ -760,7 +760,7 @@ static int adin1110_set_mac_address(struct net_device *netdev,
 		return -EADDRNOTAVAIL;
 
 	eth_hw_addr_set(netdev, dev_addr);
-	memset(mask, 0xFF, ETH_ALEN);
+	eth_broadcast_addr(mask);
 
 	mac_slot = (!port_priv->nr) ?  ADIN_MAC_P1_ADDR_SLOT : ADIN_MAC_P2_ADDR_SLOT;
 	port_rules = adin1110_port_rules(port_priv, true, false);
@@ -1271,7 +1271,7 @@ static int adin1110_port_set_blocking_state(struct adin1110_port_priv *port_priv
 		goto out;
 
 	/* Allow only BPDUs to be passed to the CPU */
-	memset(mask, 0xFF, ETH_ALEN);
+	eth_broadcast_addr(mask);
 	port_rules = adin1110_port_rules(port_priv, true, false);
 	ret = adin1110_write_mac_address(port_priv, mac_slot, mac,
 					 mask, port_rules);
@@ -1386,7 +1386,7 @@ static int adin1110_fdb_add(struct adin1110_port_priv *port_priv,
 
 	other_port = priv->ports[!port_priv->nr];
 	port_rules = adin1110_port_rules(port_priv, false, true);
-	memset(mask, 0xFF, ETH_ALEN);
+	eth_broadcast_addr(mask);
 
 	return adin1110_write_mac_address(other_port, mac_nr, (u8 *)fdb->addr,
 					  mask, port_rules);
-- 
2.40.1



