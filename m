Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0ED1A76A4;
	Tue, 30 Jul 2024 17:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359921; cv=none; b=shkwuohjMllGfEpNQQkdXG4CIqPNmWCs4NU4uIbfGHJGO8kssz5zXzZdcMKByRvrRfgrCVnmCPO4FFHYabhrbvkQA4FTTafZtxV2+T6wKM3EvU9CwsnaBadaMpjcDexd0d5+u7+xCcx9gKHoRNsGY2jxus2C6LXk9Cb7MaS6Rig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359921; c=relaxed/simple;
	bh=L6xaosuBU2XGKbbpMvctjMwOOrxHpWP3+ZW9z5EF9GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWTcxTWi1BFQMNZpMDPlr5cSqx1Cny6D7B2qEapgKRKFiTjs2OtQArNz6q+WPnTAtsymhZBhT2m3fd930U6K+AwlanN/qQQJStWMmaQrpO8rXKVCzgKQPYFc1HzRdDAnVglV6z6H4uyiw4PXUg4JPxmopBfEZVC+UruycCFKids=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8hgbKeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8hgbKeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2EDC4AF0C;
	Tue, 30 Jul 2024 17:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359920;
	bh=L6xaosuBU2XGKbbpMvctjMwOOrxHpWP3+ZW9z5EF9GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8hgbKeGFTs9hrMt6dcDrSXHVSjk/7BfN8VuZ6hGAlxKIeJDrr2gEKSoNWWxPYknY
	 4IyEGToc2F/+53NMh4U1WFPaWUXYOwJ7LtXEAOgeoJJcHt6MkoQQCfHO6MtqOhfm0G
	 MU6rT1R8AJ5zuUtvi7ddwovbqBy8qxIwMqanPbRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 554/809] ipv6: fix source address selection with route leak
Date: Tue, 30 Jul 2024 17:47:10 +0200
Message-ID: <20240730151746.639524422@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 252442f2ae317d109ef0b4b39ce0608c09563042 upstream.

By default, an address assigned to the output interface is selected when
the source address is not specified. This is problematic when a route,
configured in a vrf, uses an interface from another vrf (aka route leak).
The original vrf does not own the selected source address.

Let's add a check against the output interface and call the appropriate
function to select the source address.

CC: stable@vger.kernel.org
Fixes: 0d240e7811c4 ("net: vrf: Implement get_saddr for IPv6")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://patch.msgid.link/20240710081521.3809742-3-nicolas.dichtel@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip6_route.h |   20 ++++++++++++++------
 net/ipv6/ip6_output.c   |    1 +
 net/ipv6/route.c        |    2 +-
 3 files changed, 16 insertions(+), 7 deletions(-)

--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -127,18 +127,26 @@ void rt6_age_exceptions(struct fib6_info
 
 static inline int ip6_route_get_saddr(struct net *net, struct fib6_info *f6i,
 				      const struct in6_addr *daddr,
-				      unsigned int prefs,
+				      unsigned int prefs, int l3mdev_index,
 				      struct in6_addr *saddr)
 {
+	struct net_device *l3mdev;
+	struct net_device *dev;
+	bool same_vrf;
 	int err = 0;
 
-	if (f6i && f6i->fib6_prefsrc.plen) {
+	rcu_read_lock();
+
+	l3mdev = dev_get_by_index_rcu(net, l3mdev_index);
+	if (!f6i || !f6i->fib6_prefsrc.plen || l3mdev)
+		dev = f6i ? fib6_info_nh_dev(f6i) : NULL;
+	same_vrf = !l3mdev || l3mdev_master_dev_rcu(dev) == l3mdev;
+	if (f6i && f6i->fib6_prefsrc.plen && same_vrf)
 		*saddr = f6i->fib6_prefsrc.addr;
-	} else {
-		struct net_device *dev = f6i ? fib6_info_nh_dev(f6i) : NULL;
+	else
+		err = ipv6_dev_get_saddr(net, same_vrf ? dev : l3mdev, daddr, prefs, saddr);
 
-		err = ipv6_dev_get_saddr(net, dev, daddr, prefs, saddr);
-	}
+	rcu_read_unlock();
 
 	return err;
 }
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1124,6 +1124,7 @@ static int ip6_dst_lookup_tail(struct ne
 		from = rt ? rcu_dereference(rt->from) : NULL;
 		err = ip6_route_get_saddr(net, from, &fl6->daddr,
 					  sk ? READ_ONCE(inet6_sk(sk)->srcprefs) : 0,
+					  fl6->flowi6_l3mdev,
 					  &fl6->saddr);
 		rcu_read_unlock();
 
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5689,7 +5689,7 @@ static int rt6_fill_node(struct net *net
 				goto nla_put_failure;
 	} else if (dest) {
 		struct in6_addr saddr_buf;
-		if (ip6_route_get_saddr(net, rt, dest, 0, &saddr_buf) == 0 &&
+		if (ip6_route_get_saddr(net, rt, dest, 0, 0, &saddr_buf) == 0 &&
 		    nla_put_in6_addr(skb, RTA_PREFSRC, &saddr_buf))
 			goto nla_put_failure;
 	}


