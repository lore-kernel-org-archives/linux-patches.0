Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D98E6A352;
	Tue, 14 May 2024 10:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683461; cv=none; b=VIC8nlT1cjOlBRvAYlWaP6n09DJBdTQZWnAeJK6yYEl1hSD6gW8RLMl1IhPHrSW/Yr40Phsp4ywPSXmrm13lyT6LlC6dHZhesgEKOAroA5SdkGjgi7dnq/pjuRm9cOBW3p7LqqRWWxFuloKy0g6WYjBFUqfrghEsaZBwILXy2wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683461; c=relaxed/simple;
	bh=DnPKGkTaxBzpVP0dqcYwxdNwqt5JqAYEdW14RYs2pFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQG9/L2W6YNRMOb2nnVGEpLDvq4aT9aC38+jp1Veq+C9mV0nyKAcw1+OFomGTvNbZ38LApzyhcgj064NYbY/nyfQNKNb6CFpQS/ORfpQd9iNOrX4+Il7VY+iRzVTGDtxuxi3nTSnh8ZdgWNqL0zSaNwDyCu8psz5bR5FFfud5Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDOYY7+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDOYY7+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2384BC2BD10;
	Tue, 14 May 2024 10:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683461;
	bh=DnPKGkTaxBzpVP0dqcYwxdNwqt5JqAYEdW14RYs2pFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDOYY7+m4961pbKivs847VsIBhKa7EdD02zr3zPh8sq354a9fe+c3R50od0o9BbIb
	 PQgFQrMNepWBP5q5M4Tfm6NBNTocqqwtlYMGQT7cJ68ORTUwClsFLYQIipoT6sWe+o
	 w46JgWTU5iUK0mZyMD40o0XJrxSY2CBN14yNeNO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 221/336] net-sysfs: convert dev->operstate reads to lockless ones
Date: Tue, 14 May 2024 12:17:05 +0200
Message-ID: <20240514101046.959080444@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 004d138364fd10dd5ff8ceb54cfdc2d792a7b338 ]

operstate_show() can omit dev_base_lock acquisition only
to read dev->operstate.

Annotate accesses to dev->operstate.

Writers still acquire dev_base_lock for mutual exclusion.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 4893b8b3ef8d ("hsr: Simplify code for announcing HSR nodes timer setup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netlink.c |  3 ++-
 net/core/link_watch.c   |  4 ++--
 net/core/net-sysfs.c    |  4 +---
 net/core/rtnetlink.c    |  4 ++--
 net/hsr/hsr_device.c    | 10 +++++-----
 net/ipv6/addrconf.c     |  2 +-
 6 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index d415833fce91f..f17dbac7d8284 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -455,7 +455,8 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 			  u32 filter_mask, const struct net_device *dev,
 			  bool getlink)
 {
-	u8 operstate = netif_running(dev) ? dev->operstate : IF_OPER_DOWN;
+	u8 operstate = netif_running(dev) ? READ_ONCE(dev->operstate) :
+					    IF_OPER_DOWN;
 	struct nlattr *af = NULL;
 	struct net_bridge *br;
 	struct ifinfomsg *hdr;
diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 429571c258da7..1b93e054c9a3c 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -67,7 +67,7 @@ static void rfc2863_policy(struct net_device *dev)
 {
 	unsigned char operstate = default_operstate(dev);
 
-	if (operstate == dev->operstate)
+	if (operstate == READ_ONCE(dev->operstate))
 		return;
 
 	write_lock(&dev_base_lock);
@@ -87,7 +87,7 @@ static void rfc2863_policy(struct net_device *dev)
 		break;
 	}
 
-	dev->operstate = operstate;
+	WRITE_ONCE(dev->operstate, operstate);
 
 	write_unlock(&dev_base_lock);
 }
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index a09d507c5b03d..676048ae11831 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -318,11 +318,9 @@ static ssize_t operstate_show(struct device *dev,
 	const struct net_device *netdev = to_net_dev(dev);
 	unsigned char operstate;
 
-	read_lock(&dev_base_lock);
-	operstate = netdev->operstate;
+	operstate = READ_ONCE(netdev->operstate);
 	if (!netif_running(netdev))
 		operstate = IF_OPER_DOWN;
-	read_unlock(&dev_base_lock);
 
 	if (operstate >= ARRAY_SIZE(operstates))
 		return -EINVAL; /* should not happen */
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 4e4e6c7399109..95e62235b5410 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -875,9 +875,9 @@ static void set_operstate(struct net_device *dev, unsigned char transition)
 		break;
 	}
 
-	if (dev->operstate != operstate) {
+	if (READ_ONCE(dev->operstate) != operstate) {
 		write_lock(&dev_base_lock);
-		dev->operstate = operstate;
+		WRITE_ONCE(dev->operstate, operstate);
 		write_unlock(&dev_base_lock);
 		netdev_state_change(dev);
 	}
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 9d71b66183daf..be0e43f46556e 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -31,8 +31,8 @@ static bool is_slave_up(struct net_device *dev)
 static void __hsr_set_operstate(struct net_device *dev, int transition)
 {
 	write_lock(&dev_base_lock);
-	if (dev->operstate != transition) {
-		dev->operstate = transition;
+	if (READ_ONCE(dev->operstate) != transition) {
+		WRITE_ONCE(dev->operstate, transition);
 		write_unlock(&dev_base_lock);
 		netdev_state_change(dev);
 	} else {
@@ -78,14 +78,14 @@ static void hsr_check_announce(struct net_device *hsr_dev,
 
 	hsr = netdev_priv(hsr_dev);
 
-	if (hsr_dev->operstate == IF_OPER_UP && old_operstate != IF_OPER_UP) {
+	if (READ_ONCE(hsr_dev->operstate) == IF_OPER_UP && old_operstate != IF_OPER_UP) {
 		/* Went up */
 		hsr->announce_count = 0;
 		mod_timer(&hsr->announce_timer,
 			  jiffies + msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL));
 	}
 
-	if (hsr_dev->operstate != IF_OPER_UP && old_operstate == IF_OPER_UP)
+	if (READ_ONCE(hsr_dev->operstate) != IF_OPER_UP && old_operstate == IF_OPER_UP)
 		/* Went down */
 		del_timer(&hsr->announce_timer);
 }
@@ -100,7 +100,7 @@ void hsr_check_carrier_and_operstate(struct hsr_priv *hsr)
 	/* netif_stacked_transfer_operstate() cannot be used here since
 	 * it doesn't set IF_OPER_LOWERLAYERDOWN (?)
 	 */
-	old_operstate = master->dev->operstate;
+	old_operstate = READ_ONCE(master->dev->operstate);
 	has_carrier = hsr_check_carrier(master);
 	hsr_set_operstate(master, has_carrier);
 	hsr_check_announce(master->dev, old_operstate);
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 37d48aa073c3c..775f51cbc539b 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6015,7 +6015,7 @@ static int inet6_fill_ifinfo(struct sk_buff *skb, struct inet6_dev *idev,
 	    (dev->ifindex != dev_get_iflink(dev) &&
 	     nla_put_u32(skb, IFLA_LINK, dev_get_iflink(dev))) ||
 	    nla_put_u8(skb, IFLA_OPERSTATE,
-		       netif_running(dev) ? dev->operstate : IF_OPER_DOWN))
+		       netif_running(dev) ? READ_ONCE(dev->operstate) : IF_OPER_DOWN))
 		goto nla_put_failure;
 	protoinfo = nla_nest_start_noflag(skb, IFLA_PROTINFO);
 	if (!protoinfo)
-- 
2.43.0



