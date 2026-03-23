Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC13241695;
	Mon, 23 Mar 2026 14:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277347; cv=none; b=pnQ9smt24XCs6uHRnPaUZ6ygMEvEdxMKELqnJZLEfk2TG9V+5+yt4xmF34qvBT/Xx0irndTumnFxx3vF5kPsNr5GPnlFLzPFEu0AtD6O1n/hG9/zSlX4sBkvosEGnUf3ZaA1G1W/R3QKTLm2BH93sdwpLKAPyhrnp/OrSBNiqcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277347; c=relaxed/simple;
	bh=TLlRPt+4Jl3y+/QFJcll2PosRr50yT8WZMzVTN8s1BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASRMcJW4ornZcPIbmj4d6fTj6hc8o/bGSbNcsC78EB86GO8XcBPhT24yKPgFS8mUGm1+/XWxUrp+5ECVivoK7vUcfyf8wSN/ItuHeg3shSFDnq96NhJu1wC+pfwv/lF4Gil3l3OflBXGqoZvL/2icYI9kGTKrc0DTt9GecBRzsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0qt27MU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0qt27MU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB38C4CEF7;
	Mon, 23 Mar 2026 14:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277346;
	bh=TLlRPt+4Jl3y+/QFJcll2PosRr50yT8WZMzVTN8s1BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0qt27MU0UCOhwF7iX6FSKYKbjdhnCAXeU5ofO53zQ0LZ5JDnjQsI/b184wOx61xfp
	 BlMzHjYrdGqjaQPsLvWS4jz3/H5VsXxTfD0Spa844qkKV+8JWth28JutuX4Cum7e19
	 yCzJND+ZIm4+cOiu17bwG4ytXLsEZL6Vy4G0VqWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 405/460] bonding: prevent potential infinite loop in bond_header_parse()
Date: Mon, 23 Mar 2026 14:46:41 +0100
Message-ID: <20260323134536.510884245@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b7405dcf7385445e10821777143f18c3ce20fa04 ]

bond_header_parse() can loop if a stack of two bonding devices is setup,
because skb->dev always points to the hierarchy top.

Add new "const struct net_device *dev" parameter to
(struct header_ops)->parse() method to make sure the recursion
is bounded, and that the final leaf parse method is called.

Fixes: 950803f72547 ("bonding: fix type confusion in bond_setup_by_slave()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Tested-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Cc: Jay Vosburgh <jv@jvosburgh.net>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Link: https://patch.msgid.link/20260315104152.1436867-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/net.c          | 5 +++--
 drivers/net/bonding/bond_main.c | 8 +++++---
 include/linux/etherdevice.h     | 3 ++-
 include/linux/if_ether.h        | 3 ++-
 include/linux/netdevice.h       | 6 ++++--
 net/ethernet/eth.c              | 9 +++------
 net/ipv4/ip_gre.c               | 3 ++-
 net/mac802154/iface.c           | 4 +++-
 net/phonet/af_phonet.c          | 5 ++++-
 9 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index 1bf0e15c15408..423ead5fa9c13 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -257,9 +257,10 @@ static void fwnet_header_cache_update(struct hh_cache *hh,
 	memcpy((u8 *)hh->hh_data + HH_DATA_OFF(FWNET_HLEN), haddr, net->addr_len);
 }
 
-static int fwnet_header_parse(const struct sk_buff *skb, unsigned char *haddr)
+static int fwnet_header_parse(const struct sk_buff *skb, const struct net_device *dev,
+			      unsigned char *haddr)
 {
-	memcpy(haddr, skb->dev->dev_addr, FWNET_ALEN);
+	memcpy(haddr, dev->dev_addr, FWNET_ALEN);
 
 	return FWNET_ALEN;
 }
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index d11ca46a5b1f7..5035cfa74f1ac 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1563,9 +1563,11 @@ static int bond_header_create(struct sk_buff *skb, struct net_device *bond_dev,
 	return ret;
 }
 
-static int bond_header_parse(const struct sk_buff *skb, unsigned char *haddr)
+static int bond_header_parse(const struct sk_buff *skb,
+			     const struct net_device *dev,
+			     unsigned char *haddr)
 {
-	struct bonding *bond = netdev_priv(skb->dev);
+	struct bonding *bond = netdev_priv(dev);
 	const struct header_ops *slave_ops;
 	struct slave *slave;
 	int ret = 0;
@@ -1575,7 +1577,7 @@ static int bond_header_parse(const struct sk_buff *skb, unsigned char *haddr)
 	if (slave) {
 		slave_ops = READ_ONCE(slave->dev->header_ops);
 		if (slave_ops && slave_ops->parse)
-			ret = slave_ops->parse(skb, haddr);
+			ret = slave_ops->parse(skb, slave->dev, haddr);
 	}
 	rcu_read_unlock();
 	return ret;
diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index ecf203f010343..a3ae683affa58 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -42,7 +42,8 @@ extern const struct header_ops eth_header_ops;
 
 int eth_header(struct sk_buff *skb, struct net_device *dev, unsigned short type,
 	       const void *daddr, const void *saddr, unsigned len);
-int eth_header_parse(const struct sk_buff *skb, unsigned char *haddr);
+int eth_header_parse(const struct sk_buff *skb, const struct net_device *dev,
+		     unsigned char *haddr);
 int eth_header_cache(const struct neighbour *neigh, struct hh_cache *hh,
 		     __be16 type);
 void eth_header_cache_update(struct hh_cache *hh, const struct net_device *dev,
diff --git a/include/linux/if_ether.h b/include/linux/if_ether.h
index 8a9792a6427ad..47a0feffc1215 100644
--- a/include/linux/if_ether.h
+++ b/include/linux/if_ether.h
@@ -37,7 +37,8 @@ static inline struct ethhdr *inner_eth_hdr(const struct sk_buff *skb)
 	return (struct ethhdr *)skb_inner_mac_header(skb);
 }
 
-int eth_header_parse(const struct sk_buff *skb, unsigned char *haddr);
+int eth_header_parse(const struct sk_buff *skb, const struct net_device *dev,
+		     unsigned char *haddr);
 
 extern ssize_t sysfs_format_mac(char *buf, const unsigned char *addr, int len);
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 12edeeb172c4e..fcc1509ca7cb8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -308,7 +308,9 @@ struct header_ops {
 	int	(*create) (struct sk_buff *skb, struct net_device *dev,
 			   unsigned short type, const void *daddr,
 			   const void *saddr, unsigned int len);
-	int	(*parse)(const struct sk_buff *skb, unsigned char *haddr);
+	int	(*parse)(const struct sk_buff *skb,
+			 const struct net_device *dev,
+			 unsigned char *haddr);
 	int	(*cache)(const struct neighbour *neigh, struct hh_cache *hh, __be16 type);
 	void	(*cache_update)(struct hh_cache *hh,
 				const struct net_device *dev,
@@ -3163,7 +3165,7 @@ static inline int dev_parse_header(const struct sk_buff *skb,
 
 	if (!dev->header_ops || !dev->header_ops->parse)
 		return 0;
-	return dev->header_ops->parse(skb, haddr);
+	return dev->header_ops->parse(skb, dev, haddr);
 }
 
 static inline __be16 dev_parse_header_protocol(const struct sk_buff *skb)
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 43e211e611b16..ca4e3a01237d0 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -193,14 +193,11 @@ __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev)
 }
 EXPORT_SYMBOL(eth_type_trans);
 
-/**
- * eth_header_parse - extract hardware address from packet
- * @skb: packet to extract header from
- * @haddr: destination buffer
- */
-int eth_header_parse(const struct sk_buff *skb, unsigned char *haddr)
+int eth_header_parse(const struct sk_buff *skb, const struct net_device *dev,
+		     unsigned char *haddr)
 {
 	const struct ethhdr *eth = eth_hdr(skb);
+
 	memcpy(haddr, eth->h_source, ETH_ALEN);
 	return ETH_ALEN;
 }
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index be85dbe74ac8c..084556b03a2e2 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -917,7 +917,8 @@ static int ipgre_header(struct sk_buff *skb, struct net_device *dev,
 	return -(t->hlen + sizeof(*iph));
 }
 
-static int ipgre_header_parse(const struct sk_buff *skb, unsigned char *haddr)
+static int ipgre_header_parse(const struct sk_buff *skb, const struct net_device *dev,
+			      unsigned char *haddr)
 {
 	const struct iphdr *iph = (const struct iphdr *) skb_mac_header(skb);
 	memcpy(haddr, &iph->saddr, 4);
diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index 9e4631fade90c..000be60d95803 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -469,7 +469,9 @@ static int mac802154_header_create(struct sk_buff *skb,
 }
 
 static int
-mac802154_header_parse(const struct sk_buff *skb, unsigned char *haddr)
+mac802154_header_parse(const struct sk_buff *skb,
+		       const struct net_device *dev,
+		       unsigned char *haddr)
 {
 	struct ieee802154_hdr hdr;
 
diff --git a/net/phonet/af_phonet.c b/net/phonet/af_phonet.c
index a27efa4faa4ef..532ee4e10ba94 100644
--- a/net/phonet/af_phonet.c
+++ b/net/phonet/af_phonet.c
@@ -129,9 +129,12 @@ static int pn_header_create(struct sk_buff *skb, struct net_device *dev,
 	return 1;
 }
 
-static int pn_header_parse(const struct sk_buff *skb, unsigned char *haddr)
+static int pn_header_parse(const struct sk_buff *skb,
+			   const struct net_device *dev,
+			   unsigned char *haddr)
 {
 	const u8 *media = skb_mac_header(skb);
+
 	*haddr = *media;
 	return 1;
 }
-- 
2.51.0



