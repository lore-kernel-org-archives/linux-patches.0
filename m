Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B933644C1;
	Wed, 30 Sep 2026 17:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790206; cv=none; b=lsRwI+yyOjYkzu90XZa8rlKvFP1w6KsgQv4qmlcAT+F4XqVlRbGINbPiq5tZLqnFoOplrJ9blpO4neCP4HkBfo48YeydR68VNgOgWH437vt8Kk6Fx6dIH/0Kq/gmbB3q10rnL0ApjM1j8U6bckacQOx36+QZD8OE24vkUAgsnOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790206; c=relaxed/simple;
	bh=rtA4qicakg4IQ5SaLnF7kRfPmd/dmN770O02fvnyiyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCrolO7O86xrvexC/TgIZRwBHLnYVLNBpNjAeMFCx5bAmp44b6S+0Lti+hUdBnKJB/h5Bb508TaTulDUV3VMgFAE5MIHPtEO38+pP4xsi/kTt5tsC1RkuLQhqh7bsokmkhupkwLsjJvbCl4dXL0lLXWEYYJgwh+JaujoGo/Zxb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJPjmxqf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJPjmxqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2091F000FF;
	Wed, 30 Sep 2026 17:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790204;
	bh=263q02C2CerbQHx+Rp/vEQ3W/0pP1eL9jp4w6qs4X9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IJPjmxqfFXiFw3P2h0bGLXuOSo5FP8IgBrAoE/5fP9ZK3CJrC//F9ac1dFJsTnlG7
	 wnug11c64sB51wDqIKwW+UKqolNbwJ1VXZCMMHUjNzhK3kjnN5ROPhkS/2lptzvXj7
	 BXHVj79jc+CIXzqi54Dt8ZAFQvFnSQEgpCyLF/Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 748/877] ipv4: remove fib_info_devhash[]
Date: Wed, 30 Sep 2026 17:27:39 +0200
Message-ID: <20260930152430.836665022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

[ Upstream commit a3f5f4c2f9b6bc2aa6f5a3e8e23b7519e4f2e3e3 ]

Upcoming per-netns RTNL conversion needs to get rid
of shared hash tables.

fib_info_devhash[] is one of them.

It is unclear why we used a hash table, because
a single hlist_head per net device was cheaper and scalable.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20241004134720.579244-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8d6cd1885085 ("ipv6: flowlabel: cap duplicate leases per socket")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/net_cachelines/net_device.rst |    1 
 include/linux/netdevice.h                              |    3 +
 net/ipv4/fib_semantics.c                               |   35 +++++++----------
 3 files changed, 19 insertions(+), 20 deletions(-)

--- a/Documentation/networking/net_cachelines/net_device.rst
+++ b/Documentation/networking/net_cachelines/net_device.rst
@@ -83,6 +83,7 @@ unsigned_int                        allm
 bool                                uc_promisc                                                      
 unsigned_char                       nested_level                                                    
 struct_in_device*                   ip_ptr                  read_mostly         read_mostly         __in_dev_get
+struct hlist_head                   fib_nh_head
 struct_inet6_dev*                   ip6_ptr                 read_mostly         read_mostly         __in6_dev_get
 struct_vlan_info*                   vlan_info                                                       
 struct_dsa_port*                    dsa_ptr                                                         
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2217,6 +2217,9 @@ struct net_device {
 
 	/* Protocol-specific pointers */
 	struct in_device __rcu	*ip_ptr;
+	/** @fib_nh_head: nexthops associated with this netdev */
+	struct hlist_head	fib_nh_head;
+
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
 	struct vlan_info __rcu	*vlan_info;
 #endif
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -57,10 +57,6 @@ static unsigned int fib_info_hash_size;
 static unsigned int fib_info_hash_bits;
 static unsigned int fib_info_cnt;
 
-#define DEVINDEX_HASHBITS 8
-#define DEVINDEX_HASHSIZE (1U << DEVINDEX_HASHBITS)
-static struct hlist_head fib_info_devhash[DEVINDEX_HASHSIZE];
-
 /* for_nexthops and change_nexthops only used when nexthop object
  * is not set in a fib_info. The logic within can reference fib_nh.
  */
@@ -322,12 +318,9 @@ static inline int nh_comp(struct fib_inf
 	return 0;
 }
 
-static struct hlist_head *
-fib_info_devhash_bucket(const struct net_device *dev)
+static struct hlist_head *fib_nh_head(struct net_device *dev)
 {
-	u32 val = net_hash_mix(dev_net(dev)) ^ dev->ifindex;
-
-	return &fib_info_devhash[hash_32(val, DEVINDEX_HASHBITS)];
+	return &dev->fib_nh_head;
 }
 
 static unsigned int fib_info_hashfn_1(int init_val, u8 protocol, u8 scope,
@@ -439,11 +432,11 @@ int ip_fib_check_default(__be32 gw, stru
 	struct hlist_head *head;
 	struct fib_nh *nh;
 
-	head = fib_info_devhash_bucket(dev);
+	head = fib_nh_head(dev);
 
 	hlist_for_each_entry_rcu(nh, head, nh_hash) {
-		if (nh->fib_nh_dev == dev &&
-		    nh->fib_nh_gw4 == gw &&
+		DEBUG_NET_WARN_ON_ONCE(nh->fib_nh_dev != dev);
+		if (nh->fib_nh_gw4 == gw &&
 		    !(nh->fib_nh_flags & RTNH_F_DEAD)) {
 			return 0;
 		}
@@ -1632,7 +1625,7 @@ link_it:
 
 			if (!nexthop_nh->fib_nh_dev)
 				continue;
-			head = fib_info_devhash_bucket(nexthop_nh->fib_nh_dev);
+			head = fib_nh_head(nexthop_nh->fib_nh_dev);
 			hlist_add_head_rcu(&nexthop_nh->nh_hash, head);
 		} endfor_nexthops(fi)
 	}
@@ -1974,12 +1967,12 @@ out:
 
 void fib_sync_mtu(struct net_device *dev, u32 orig_mtu)
 {
-	struct hlist_head *head = fib_info_devhash_bucket(dev);
+	struct hlist_head *head = fib_nh_head(dev);
 	struct fib_nh *nh;
 
 	hlist_for_each_entry(nh, head, nh_hash) {
-		if (nh->fib_nh_dev == dev)
-			fib_nhc_update_mtu(&nh->nh_common, dev->mtu, orig_mtu);
+		DEBUG_NET_WARN_ON_ONCE(nh->fib_nh_dev != dev);
+		fib_nhc_update_mtu(&nh->nh_common, dev->mtu, orig_mtu);
 	}
 }
 
@@ -1993,7 +1986,7 @@ void fib_sync_mtu(struct net_device *dev
  */
 int fib_sync_down_dev(struct net_device *dev, unsigned long event, bool force)
 {
-	struct hlist_head *head = fib_info_devhash_bucket(dev);
+	struct hlist_head *head = fib_nh_head(dev);
 	struct fib_info *prev_fi = NULL;
 	int scope = RT_SCOPE_NOWHERE;
 	struct fib_nh *nh;
@@ -2007,7 +2000,8 @@ int fib_sync_down_dev(struct net_device
 		int dead;
 
 		BUG_ON(!fi->fib_nhs);
-		if (nh->fib_nh_dev != dev || fi == prev_fi)
+		DEBUG_NET_WARN_ON_ONCE(nh->fib_nh_dev != dev);
+		if (fi == prev_fi)
 			continue;
 		prev_fi = fi;
 		dead = 0;
@@ -2157,7 +2151,7 @@ int fib_sync_up(struct net_device *dev,
 	}
 
 	prev_fi = NULL;
-	head = fib_info_devhash_bucket(dev);
+	head = fib_nh_head(dev);
 	ret = 0;
 
 	hlist_for_each_entry(nh, head, nh_hash) {
@@ -2165,7 +2159,8 @@ int fib_sync_up(struct net_device *dev,
 		int alive;
 
 		BUG_ON(!fi->fib_nhs);
-		if (nh->fib_nh_dev != dev || fi == prev_fi)
+		DEBUG_NET_WARN_ON_ONCE(nh->fib_nh_dev != dev);
+		if (fi == prev_fi)
 			continue;
 
 		prev_fi = fi;


