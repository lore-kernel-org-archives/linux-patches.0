Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402FF35FF5C;
	Tue,  6 Jan 2026 17:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721752; cv=none; b=MT5K5cts4ISGbJmbXgroOrEQi0PG/QdrEBN+wv0CTL8VQTpMiQfjS8+OsClXnSa+V8PvEgeIPGqCvke2ZQlVL58oIBr/oideYIUTJRn4XpqQFvom5LJM+wRVXH4j4TV8s+rgYvJ72HS0heq+oZs/wG943cwnfp7dQdZrcZsbTMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721752; c=relaxed/simple;
	bh=EcoQZgilFuO5y3HGlMuGFrjG/3AQbdXsmKeCbqRblfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efhi37W+wmiHMd2pYw490yRCsvI48iQDqY7r6fChh6ZpWnk/n4QMwyI2IDMsNY9/EnG+BuVlAaM1/AhB09SwRoZ1BMZR3er1pCVufxwEev85sLnvmzILs3Eg3OOs/l5ixdDxODCtKUEDBtnD0omB15G+oZBgJVWsXTy42sYqJBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkfOQXOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkfOQXOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B95C116C6;
	Tue,  6 Jan 2026 17:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721752;
	bh=EcoQZgilFuO5y3HGlMuGFrjG/3AQbdXsmKeCbqRblfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkfOQXODkI/HUaypRFPhTWQrH1C+ganwhunA859qxUi21NFThDmu/WsAOGuE+HnsQ
	 4J+rbYv1pU98GbcqdGmlP0fg9WOrXnSAdV/cvJGhNC6WWNTYsdjcQVg7svCsgQz4cG
	 xm5XlmDmx1eUV1K+utGJ2Om8/7EkBOaALNaufux8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Ido Schimmel <idosch@nvidia.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/312] net: fib: restore ECMP balance from loopback
Date: Tue,  6 Jan 2026 18:02:16 +0100
Message-ID: <20260106170550.094084471@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

[ Upstream commit 6e17474aa9fe15015c9921a5081c7ca71783aac6 ]

Preference of nexthop with source address broke ECMP for packets with
source addresses which are not in the broadcast domain, but rather added
to loopback/dummy interfaces. Original behaviour was to balance over
nexthops while now it uses the latest nexthop from the group. To fix the
issue introduce next hop scoring system where next hops with source
address equal to requested will always have higher priority.

For the case with 198.51.100.1/32 assigned to dummy0 and routed using
192.0.2.0/24 and 203.0.113.0/24 networks:

2: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether d6:54:8a:ff:78:f5 brd ff:ff:ff:ff:ff:ff
    inet 198.51.100.1/32 scope global dummy0
       valid_lft forever preferred_lft forever
7: veth1@if6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 06:ed:98:87:6d:8a brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.0.2.2/24 scope global veth1
       valid_lft forever preferred_lft forever
    inet6 fe80::4ed:98ff:fe87:6d8a/64 scope link proto kernel_ll
       valid_lft forever preferred_lft forever
9: veth3@if8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether ae:75:23:38:a0:d2 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 203.0.113.2/24 scope global veth3
       valid_lft forever preferred_lft forever
    inet6 fe80::ac75:23ff:fe38:a0d2/64 scope link proto kernel_ll
       valid_lft forever preferred_lft forever

~ ip ro list:
default
	nexthop via 192.0.2.1 dev veth1 weight 1
	nexthop via 203.0.113.1 dev veth3 weight 1
192.0.2.0/24 dev veth1 proto kernel scope link src 192.0.2.2
203.0.113.0/24 dev veth3 proto kernel scope link src 203.0.113.2

before:
   for i in {1..255} ; do ip ro get 10.0.0.$i; done | grep veth | awk ' {print $(NF-2)}' | sort | uniq -c:
    255 veth3

after:
   for i in {1..255} ; do ip ro get 10.0.0.$i; done | grep veth | awk ' {print $(NF-2)}' | sort | uniq -c:
    122 veth1
    133 veth3

Fixes: 32607a332cfe ("ipv4: prefer multipath nexthop that matches source address")
Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20251221192639.3911901-1-vadim.fedorenko@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_semantics.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index a5f3c8459758..0caf38e44c73 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -2167,8 +2167,8 @@ void fib_select_multipath(struct fib_result *res, int hash,
 {
 	struct fib_info *fi = res->fi;
 	struct net *net = fi->fib_net;
-	bool found = false;
 	bool use_neigh;
+	int score = -1;
 	__be32 saddr;
 
 	if (unlikely(res->fi->nh)) {
@@ -2180,7 +2180,7 @@ void fib_select_multipath(struct fib_result *res, int hash,
 	saddr = fl4 ? fl4->saddr : 0;
 
 	change_nexthops(fi) {
-		int nh_upper_bound;
+		int nh_upper_bound, nh_score = 0;
 
 		/* Nexthops without a carrier are assigned an upper bound of
 		 * minus one when "ignore_routes_with_linkdown" is set.
@@ -2190,24 +2190,18 @@ void fib_select_multipath(struct fib_result *res, int hash,
 		    (use_neigh && !fib_good_nh(nexthop_nh)))
 			continue;
 
-		if (!found) {
+		if (saddr && nexthop_nh->nh_saddr == saddr)
+			nh_score += 2;
+		if (hash <= nh_upper_bound)
+			nh_score++;
+		if (score < nh_score) {
 			res->nh_sel = nhsel;
 			res->nhc = &nexthop_nh->nh_common;
-			found = !saddr || nexthop_nh->nh_saddr == saddr;
+			if (nh_score == 3 || (!saddr && nh_score == 1))
+				return;
+			score = nh_score;
 		}
 
-		if (hash > nh_upper_bound)
-			continue;
-
-		if (!saddr || nexthop_nh->nh_saddr == saddr) {
-			res->nh_sel = nhsel;
-			res->nhc = &nexthop_nh->nh_common;
-			return;
-		}
-
-		if (found)
-			return;
-
 	} endfor_nexthops(fi);
 }
 #endif
-- 
2.51.0



