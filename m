Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5043E41735B;
	Tue, 21 Jul 2026 20:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664768; cv=none; b=s8iMfGyfcwykbgNMdt3CfyAxsV73lfJ3JdbyawSD+TmPbTPcPdW74/K/3hkh1s3DH12oxXo5ahSFlzbJ6qb6WzwO3m9ytZ6ISu1XqVgKsCnXV/f6qs/dCaRKyaWZHBSpNo0rPdqOAHm1m5ZJHteQ9T1LAFcZbWMNYC0hR1Ge2ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664768; c=relaxed/simple;
	bh=casf9cTWKNz+BPlIYmqA8BEjPI/X2XVbX/vmKGXl77k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KIi+g656SfJixh+/6sqS2ja1Xfaueeee+busYlTctgLrOw4OdbxBr5dX4EOSy3MMYlZn6Tw0h18bjksLFUlhAw5v50Udfm5TYkIWdtrWUQ1W8FgFD8AgF3n/U/r2mskmWVm8cEQ6Vhd3NOFOZIxnTS14ytj8Zb05RahWW56BNhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2KZcUq8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2KZcUq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB2F1F000E9;
	Tue, 21 Jul 2026 20:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664767;
	bh=WnUrVRo29RKIpM7VuWtEIIJE/bkPUYCHMZviECcDOPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m2KZcUq851VqondtgfU/Dv9ZaiUFmb4h70H539kPdslkHvsi7TJlTV4BUbBGdbm7l
	 1Ky1naCtCKaLCPEFx9AqYbuHYNoYwvc94cM9njDhid5FY2vvzCC70meWacQMWoLPtB
	 3GhmcBXwxSZ8x5Nsr4SctWYU3gGUaejemzPj9iKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0052/1266] bonding: prevent potential infinite loop in bond_header_parse()
Date: Tue, 21 Jul 2026 17:08:09 +0200
Message-ID: <20260721152442.965777681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[backport to 6.6, also fix function for wireless/{cisco/hostap}]
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/net.c                             | 5 +++--
 drivers/net/bonding/bond_main.c                    | 8 +++++---
 drivers/net/wireless/cisco/airo.c                  | 4 +++-
 drivers/net/wireless/intersil/hostap/hostap_main.c | 1 +
 include/linux/etherdevice.h                        | 3 ++-
 include/linux/if_ether.h                           | 3 ++-
 include/linux/netdevice.h                          | 6 ++++--
 net/ethernet/eth.c                                 | 9 +++------
 net/ipv4/ip_gre.c                                  | 3 ++-
 net/mac802154/iface.c                              | 4 +++-
 net/phonet/af_phonet.c                             | 5 ++++-
 11 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index 7a4d1a478e33e2..21f3a9dae072a9 100644
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
index af8cdc8d26c91d..6b558aa98c6d2f 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1489,9 +1489,11 @@ static int bond_header_create(struct sk_buff *skb, struct net_device *bond_dev,
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
@@ -1501,7 +1503,7 @@ static int bond_header_parse(const struct sk_buff *skb, unsigned char *haddr)
 	if (slave) {
 		slave_ops = READ_ONCE(slave->dev->header_ops);
 		if (slave_ops && slave_ops->parse)
-			ret = slave_ops->parse(skb, haddr);
+			ret = slave_ops->parse(skb, slave->dev, haddr);
 	}
 	rcu_read_unlock();
 	return ret;
diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index dbd13f7aa3e6ea..bd269fdaa1d014 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -2437,7 +2437,9 @@ void stop_airo_card(struct net_device *dev, int freeres)
 
 EXPORT_SYMBOL(stop_airo_card);
 
-static int wll_header_parse(const struct sk_buff *skb, unsigned char *haddr)
+static int wll_header_parse(const struct sk_buff *skb,
+			    const struct net_device *dev,
+			    unsigned char *haddr)
 {
 	memcpy(haddr, skb_mac_header(skb) + 10, ETH_ALEN);
 	return ETH_ALEN;
diff --git a/drivers/net/wireless/intersil/hostap/hostap_main.c b/drivers/net/wireless/intersil/hostap/hostap_main.c
index 787f685e70b492..8ba1a709fe47de 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_main.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_main.c
@@ -575,6 +575,7 @@ void hostap_dump_tx_header(const char *name, const struct hfa384x_tx_frame *tx)
 
 
 static int hostap_80211_header_parse(const struct sk_buff *skb,
+				     const struct net_device *dev,
 				     unsigned char *haddr)
 {
 	memcpy(haddr, skb_mac_header(skb) + 10, ETH_ALEN); /* addr2 */
diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 297231854ada51..6f96d1c6d10fd1 100644
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
index 8a9792a6427ad9..47a0feffc12155 100644
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
index a81dab6c2f5f24..74474139fb9ac8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -312,7 +312,9 @@ struct header_ops {
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
@@ -3174,7 +3176,7 @@ static inline int dev_parse_header(const struct sk_buff *skb,
 
 	if (!dev->header_ops || !dev->header_ops->parse)
 		return 0;
-	return dev->header_ops->parse(skb, haddr);
+	return dev->header_ops->parse(skb, dev, haddr);
 }
 
 static inline __be16 dev_parse_header_protocol(const struct sk_buff *skb)
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index b4a6e26ec2871b..a90d2470e090bb 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -195,14 +195,11 @@ __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev)
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
index e58965ce8263d2..b5ebfee9a8faf6 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -888,7 +888,8 @@ static int ipgre_header(struct sk_buff *skb, struct net_device *dev,
 	return -(t->hlen + sizeof(*iph));
 }
 
-static int ipgre_header_parse(const struct sk_buff *skb, unsigned char *haddr)
+static int ipgre_header_parse(const struct sk_buff *skb, const struct net_device *dev,
+			      unsigned char *haddr)
 {
 	const struct iphdr *iph = (const struct iphdr *) skb_mac_header(skb);
 	memcpy(haddr, &iph->saddr, 4);
diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index 9e4631fade90c9..000be60d958034 100644
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
index 2b582da1e88c05..e38fad4144e489 100644
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
2.53.0



