Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D598280A3B;
	Wed,  4 Feb 2026 14:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216234; cv=none; b=M0mT/rhfs7UwhkLqQI1EVtyrTtC2QY+f5w+LbiUyQaB8eBFvAZrqONFafISs+apYlybueNwJfdfAO4Fj3PUUWkKF+XBIKKofX4VyWKO1yv3c23zsOaUa/lDXs53ALKtGiNU565kNXkJSYAdkss9+zaP3A2frJGQFvvxZUia7C00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216234; c=relaxed/simple;
	bh=6UJp3PJhuu5LsX2SZQCAcmlvVyNWuXhMU9PhzL6Ro4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tj5MZFDykAFBT0edIjXzSX1LJWirDKW8WZJ0P2BdXRGXqLu3/jwT9wcehgZyXunjpYd0zNNpc3IjY3Qv7WnBywSTSoPlWk49i+F2Emq04FtWZlo484pXV6/wiqxKNf7XPEMpMdZ2l4cc2bZ5umtkZVMzzPdD9aLdnUzw4U37NJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bm/QEqgn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bm/QEqgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4D9C4CEF7;
	Wed,  4 Feb 2026 14:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216234;
	bh=6UJp3PJhuu5LsX2SZQCAcmlvVyNWuXhMU9PhzL6Ro4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bm/QEqgnYkocqIUMPJp1eIr1sl/TNgGVgIyIZ2/bQXGFWNzvldhggOhjj9/yO7a7D
	 zDkBrqv2TnnaL3C+qKSaRDSWsFeFksiVCOVomU4roqwJDP6yLm6XXpXh3rWt3plNo+
	 B4oR+Rd0CFbVCv+Gp06NaxDPwsBnJgNBnI+9A5o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jethro Beekman <kernel@jbeekman.nl>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/161] macvlan: Add nodst option to macvlan type source
Date: Wed,  4 Feb 2026 15:37:49 +0100
Message-ID: <20260204143851.991798543@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jethro Beekman <kernel@jbeekman.nl>

[ Upstream commit 427f0c8c194b22edcafef1b0a42995ddc5c2227d ]

The default behavior for source MACVLAN is to duplicate packets to
appropriate type source devices, and then do the normal destination MACVLAN
flow. This patch adds an option to skip destination MACVLAN processing if
any matching source MACVLAN device has the option set.

This allows setting up a "catch all" device for source MACVLAN: create one
or more devices with type source nodst, and one device with e.g. type vepa,
and incoming traffic will be received on exactly one device.

v2: netdev wants non-standard line length

Signed-off-by: Jethro Beekman <kernel@jbeekman.nl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7470a7a63dc1 ("macvlan: fix possible UAF in macvlan_forward_source()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c        | 19 ++++++++++++++-----
 include/uapi/linux/if_link.h |  1 +
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 9c77e6ab2b307..9a6d31cdc4ce6 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -421,18 +421,24 @@ static void macvlan_forward_source_one(struct sk_buff *skb,
 	macvlan_count_rx(vlan, len, ret == NET_RX_SUCCESS, false);
 }
 
-static void macvlan_forward_source(struct sk_buff *skb,
+static bool macvlan_forward_source(struct sk_buff *skb,
 				   struct macvlan_port *port,
 				   const unsigned char *addr)
 {
 	struct macvlan_source_entry *entry;
 	u32 idx = macvlan_eth_hash(addr);
 	struct hlist_head *h = &port->vlan_source_hash[idx];
+	bool consume = false;
 
 	hlist_for_each_entry_rcu(entry, h, hlist) {
-		if (ether_addr_equal_64bits(entry->addr, addr))
+		if (ether_addr_equal_64bits(entry->addr, addr)) {
+			if (entry->vlan->flags & MACVLAN_FLAG_NODST)
+				consume = true;
 			macvlan_forward_source_one(skb, entry->vlan);
+		}
 	}
+
+	return consume;
 }
 
 /* called under rcu_read_lock() from netif_receive_skb */
@@ -461,7 +467,8 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
 			return RX_HANDLER_CONSUMED;
 		*pskb = skb;
 		eth = eth_hdr(skb);
-		macvlan_forward_source(skb, port, eth->h_source);
+		if (macvlan_forward_source(skb, port, eth->h_source))
+			return RX_HANDLER_CONSUMED;
 		src = macvlan_hash_lookup(port, eth->h_source);
 		if (src && src->mode != MACVLAN_MODE_VEPA &&
 		    src->mode != MACVLAN_MODE_BRIDGE) {
@@ -480,7 +487,8 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
 		return RX_HANDLER_PASS;
 	}
 
-	macvlan_forward_source(skb, port, eth->h_source);
+	if (macvlan_forward_source(skb, port, eth->h_source))
+		return RX_HANDLER_CONSUMED;
 	if (macvlan_passthru(port))
 		vlan = list_first_or_null_rcu(&port->vlans,
 					      struct macvlan_dev, list);
@@ -1283,7 +1291,8 @@ static int macvlan_validate(struct nlattr *tb[], struct nlattr *data[],
 		return 0;
 
 	if (data[IFLA_MACVLAN_FLAGS] &&
-	    nla_get_u16(data[IFLA_MACVLAN_FLAGS]) & ~MACVLAN_FLAG_NOPROMISC)
+	    nla_get_u16(data[IFLA_MACVLAN_FLAGS]) & ~(MACVLAN_FLAG_NOPROMISC |
+						      MACVLAN_FLAG_NODST))
 		return -EINVAL;
 
 	if (data[IFLA_MACVLAN_MODE]) {
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 9334f2128bb2e..33c3b684f6de4 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -609,6 +609,7 @@ enum macvlan_macaddr_mode {
 };
 
 #define MACVLAN_FLAG_NOPROMISC	1
+#define MACVLAN_FLAG_NODST	2 /* skip dst macvlan if matching src macvlan */
 
 /* VRF section */
 enum {
-- 
2.51.0



