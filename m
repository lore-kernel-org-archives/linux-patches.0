Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB2618A6A5;
	Tue, 27 May 2025 17:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365233; cv=none; b=kYwBEfy2JLHPNKEXK3enXORCb5v3sP4yAu0MLag/R6yEfJL70XE2FGF79jrhUCSn0E0I1Yv4TpkkwsrOkDqfTb7eRpBrqTF5fHDusY4j/wwwAfZhoqT/ZHUrBXSHFl2veItFUjWvwXinx9z+gf0lXLMKxnW21Uwld0DiJlR0kDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365233; c=relaxed/simple;
	bh=WY+Hbk75UlvBOmiRGb1A3gdODYgtiB5VqXSTkxk4FCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+5+2u2zd83pr/fteJZ3v++cNbu/pJVPVW3d2dzw4qHSQ5xDmNEX9FfXQux/fVHRFaYLltRqTBq8GAZ2vYYF7hjCXxLj2F/3scTRczUX3+SKUCYl/6gvVHn/QQ13Iek4snIziYlfzhfjixsl5Cb3rS2rznaOEnSWkvpspjVbEeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2NlSuXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2NlSuXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECCAC4CEE9;
	Tue, 27 May 2025 17:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365233;
	bh=WY+Hbk75UlvBOmiRGb1A3gdODYgtiB5VqXSTkxk4FCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2NlSuXZhlQ7oAahD8uOCe6NVxaBkDwvvIxNtFFkxZZLjY47cXd31LporrlYoAIlt
	 p2ogqy4sH57cxU+CLDuScwQhq85zMWQEDTs18H6iA5BuqJi6tBBNTSmTVWUPPKTwzj
	 ondAStEh1uwAS1pwa6FnunyM3fpQCns8IxclhWvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 308/626] net: ipv6: Init tunnel link-netns before registering dev
Date: Tue, 27 May 2025 18:23:21 +0200
Message-ID: <20250527162457.547753399@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Xiao Liang <shaw.leon@gmail.com>

[ Upstream commit db014522f35606031d8ac58b4aed6b1ed84f03d1 ]

Currently some IPv6 tunnel drivers set tnl->net to dev_net(dev) in
ndo_init(), which is called in register_netdevice(). However, it lacks
the context of link-netns when we enable cross-net tunnels at device
registration time.

Let's move the init of tunnel link-netns before register_netdevice().

ip6_gre has already initialized netns, so just remove the redundant
assignment.

Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250219125039.18024-8-shaw.leon@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_gre.c    | 2 --
 net/ipv6/ip6_tunnel.c | 3 ++-
 net/ipv6/ip6_vti.c    | 3 ++-
 net/ipv6/sit.c        | 8 +++++---
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 235808cfec705..68e9a41eed491 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1498,7 +1498,6 @@ static int ip6gre_tunnel_init_common(struct net_device *dev)
 	tunnel = netdev_priv(dev);
 
 	tunnel->dev = dev;
-	tunnel->net = dev_net(dev);
 	strcpy(tunnel->parms.name, dev->name);
 
 	ret = dst_cache_init(&tunnel->dst_cache, GFP_KERNEL);
@@ -1882,7 +1881,6 @@ static int ip6erspan_tap_init(struct net_device *dev)
 	tunnel = netdev_priv(dev);
 
 	tunnel->dev = dev;
-	tunnel->net = dev_net(dev);
 	strcpy(tunnel->parms.name, dev->name);
 
 	ret = dst_cache_init(&tunnel->dst_cache, GFP_KERNEL);
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 48fd53b989726..5350c9bb2319b 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1878,7 +1878,6 @@ ip6_tnl_dev_init_gen(struct net_device *dev)
 	int t_hlen;
 
 	t->dev = dev;
-	t->net = dev_net(dev);
 
 	ret = dst_cache_init(&t->dst_cache, GFP_KERNEL);
 	if (ret)
@@ -1940,6 +1939,7 @@ static int __net_init ip6_fb_tnl_dev_init(struct net_device *dev)
 	struct net *net = dev_net(dev);
 	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
 
+	t->net = net;
 	t->parms.proto = IPPROTO_IPV6;
 
 	rcu_assign_pointer(ip6n->tnls_wc[0], t);
@@ -2013,6 +2013,7 @@ static int ip6_tnl_newlink(struct net *src_net, struct net_device *dev,
 	int err;
 
 	nt = netdev_priv(dev);
+	nt->net = net;
 
 	if (ip_tunnel_netlink_encap_parms(data, &ipencap)) {
 		err = ip6_tnl_encap_setup(nt, &ipencap);
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 590737c275379..0123504691443 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -925,7 +925,6 @@ static inline int vti6_dev_init_gen(struct net_device *dev)
 	struct ip6_tnl *t = netdev_priv(dev);
 
 	t->dev = dev;
-	t->net = dev_net(dev);
 	netdev_hold(dev, &t->dev_tracker, GFP_KERNEL);
 	netdev_lockdep_set_classes(dev);
 	return 0;
@@ -958,6 +957,7 @@ static int __net_init vti6_fb_tnl_dev_init(struct net_device *dev)
 	struct net *net = dev_net(dev);
 	struct vti6_net *ip6n = net_generic(net, vti6_net_id);
 
+	t->net = net;
 	t->parms.proto = IPPROTO_IPV6;
 
 	rcu_assign_pointer(ip6n->tnls_wc[0], t);
@@ -1008,6 +1008,7 @@ static int vti6_newlink(struct net *src_net, struct net_device *dev,
 	vti6_netlink_parms(data, &nt->parms);
 
 	nt->parms.proto = IPPROTO_IPV6;
+	nt->net = net;
 
 	if (vti6_locate(net, &nt->parms, 0))
 		return -EEXIST;
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 39bd8951bfca1..3c15a0ae228e2 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -269,6 +269,7 @@ static struct ip_tunnel *ipip6_tunnel_locate(struct net *net,
 
 	nt = netdev_priv(dev);
 
+	nt->net = net;
 	nt->parms = *parms;
 	if (ipip6_tunnel_create(dev) < 0)
 		goto failed_free;
@@ -1449,7 +1450,6 @@ static int ipip6_tunnel_init(struct net_device *dev)
 	int err;
 
 	tunnel->dev = dev;
-	tunnel->net = dev_net(dev);
 	strcpy(tunnel->parms.name, dev->name);
 
 	ipip6_tunnel_bind_dev(dev);
@@ -1563,6 +1563,7 @@ static int ipip6_newlink(struct net *src_net, struct net_device *dev,
 	int err;
 
 	nt = netdev_priv(dev);
+	nt->net = net;
 
 	if (ip_tunnel_netlink_encap_parms(data, &ipencap)) {
 		err = ip_tunnel_encap_setup(nt, &ipencap);
@@ -1858,6 +1859,9 @@ static int __net_init sit_init_net(struct net *net)
 	 */
 	sitn->fb_tunnel_dev->netns_local = true;
 
+	t = netdev_priv(sitn->fb_tunnel_dev);
+	t->net = net;
+
 	err = register_netdev(sitn->fb_tunnel_dev);
 	if (err)
 		goto err_reg_dev;
@@ -1865,8 +1869,6 @@ static int __net_init sit_init_net(struct net *net)
 	ipip6_tunnel_clone_6rd(sitn->fb_tunnel_dev, sitn);
 	ipip6_fb_tunnel_init(sitn->fb_tunnel_dev);
 
-	t = netdev_priv(sitn->fb_tunnel_dev);
-
 	strcpy(t->parms.name, sitn->fb_tunnel_dev->name);
 	return 0;
 
-- 
2.39.5



