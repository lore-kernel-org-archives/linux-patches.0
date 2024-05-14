Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C3E18026;
	Tue, 14 May 2024 11:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686505; cv=none; b=MpZA8IBPlSOeeOSTPWftSIK1xr32pgj6b2lR0zg47i/oqO2ggDWZlJTiCVlgrczqXV/dGrhvvWRlcVc8hPaDJgOzAa8J28ADNdPWFGYKLFZQ6bOwxtN3PMQxEmiB1x6iin/clOd3C8nuI2+Pbq7HMthvfjtfSJ6FYlaJlYtb3Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686505; c=relaxed/simple;
	bh=LgwuEqL4srKO/GTsa9k3xmzlIuPHOhV9+sF5A8dC/Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mT6QvrRO1SEbSzITQH4QMUCzHHcWuhK+dz8GEHjzd6CGAURmOBuhg2Wd1CfOS2we0cLZw4SNVQoi+olCL07VScjnyMOJixpzWND0s5MrMxQ/VUdqoVh6Bu5OcDrYXTzF1UIdI3jo7hxhcRVYTJK6kc2F0gDsJpOgOWkrIPkXpt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/G6foXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/G6foXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17F3C2BD10;
	Tue, 14 May 2024 11:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686505;
	bh=LgwuEqL4srKO/GTsa9k3xmzlIuPHOhV9+sF5A8dC/Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/G6foXYh1kgGY+QFGWuzFo06jb3d/yBhu77bms55Y2Q3aPTVFFlclifRU++Ir6QH
	 4GvP2CjgnpbukAwuNnYrKKH2u/MfAVtQFO/SCM/kFYnSxNFoAevbl8gi5HKZj8kHSC
	 Mp22CkQZ94P0WR+m4bYQl+brNaVZAyNal0jMCE1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/236] net-sysfs: convert dev->operstate reads to lockless ones
Date: Tue, 14 May 2024 12:18:44 +0200
Message-ID: <20240514101026.510398919@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d38eff27767dc..e9e5c77ef0f4a 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -439,7 +439,8 @@ static int br_fill_ifinfo(struct sk_buff *skb,
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
index aa6cb1f90966f..13513efcfbfe8 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -53,7 +53,7 @@ static void rfc2863_policy(struct net_device *dev)
 {
 	unsigned char operstate = default_operstate(dev);
 
-	if (operstate == dev->operstate)
+	if (operstate == READ_ONCE(dev->operstate))
 		return;
 
 	write_lock(&dev_base_lock);
@@ -73,7 +73,7 @@ static void rfc2863_policy(struct net_device *dev)
 		break;
 	}
 
-	dev->operstate = operstate;
+	WRITE_ONCE(dev->operstate, operstate);
 
 	write_unlock(&dev_base_lock);
 }
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 8409d41405dfe..fdf3308b03350 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -306,11 +306,9 @@ static ssize_t operstate_show(struct device *dev,
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
index 80169afb888d2..1163226c025c1 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -876,9 +876,9 @@ static void set_operstate(struct net_device *dev, unsigned char transition)
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
index 83906d093f0ae..89e694f1c3bd3 100644
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
index 3866deaadbb66..16a9a21f6af19 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5979,7 +5979,7 @@ static int inet6_fill_ifinfo(struct sk_buff *skb, struct inet6_dev *idev,
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



