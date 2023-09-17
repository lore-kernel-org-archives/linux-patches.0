Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9167461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48B2C433C7;
	Sun, 17 Sep 2023 20:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981299;
	bh=vDZ8goxAh7GGSdSC7KAjtYxN4EPGvdQ/eMaWZxhnK/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FVBAD2S5HxHie6UU9AIFUofjDx6280/8T4HP/6oq9O9bGxD0WZNbxKd4PrX7cJsq3
	 oZ9tNSL+dVU646czs8jGj9pTWkejHhCN1bkO+FNAtqtyI0O3T6ZeEXftZfB3AUlMfB
	 eEwDbZfBaka0b5+v/sMygbYI/7h4KY5Uccl7pAMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/219] ipv6: ignore dst hint for multipath routes
Date: Sun, 17 Sep 2023 21:13:48 +0200
Message-ID: <20230917191044.651325083@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>

[ Upstream commit 8423be8926aa82cd2e28bba5cc96ccb72c7ce6be ]

Route hints when the nexthop is part of a multipath group causes packets
in the same receive batch to be sent to the same nexthop irrespective of
the multipath hash of the packet. So, do not extract route hint for
packets whose destination is part of a multipath group.

A new SKB flag IP6SKB_MULTIPATH is introduced for this purpose, set the
flag when route is looked up in fib6_select_path() and use it in
ip6_can_use_hint() to check for the existence of the flag.

Fixes: 197dbf24e360 ("ipv6: introduce and uses route look hints for list input.")
Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ipv6.h | 1 +
 net/ipv6/ip6_input.c | 3 ++-
 net/ipv6/route.c     | 3 +++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 37dfdcfcdd542..15d7529ac9534 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -146,6 +146,7 @@ struct inet6_skb_parm {
 #define IP6SKB_JUMBOGRAM      128
 #define IP6SKB_SEG6	      256
 #define IP6SKB_FAKEJUMBO      512
+#define IP6SKB_MULTIPATH      1024
 };
 
 #if defined(CONFIG_NET_L3_MASTER_DEV)
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index d94041bb42872..b8378814532ce 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -99,7 +99,8 @@ static bool ip6_can_use_hint(const struct sk_buff *skb,
 static struct sk_buff *ip6_extract_route_hint(const struct net *net,
 					      struct sk_buff *skb)
 {
-	if (fib6_routes_require_src(net) || fib6_has_custom_rules(net))
+	if (fib6_routes_require_src(net) || fib6_has_custom_rules(net) ||
+	    IP6CB(skb)->flags & IP6SKB_MULTIPATH)
 		return NULL;
 
 	return skb;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 960ab43a49c46..93957b20fccce 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -425,6 +425,9 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
 	if (match->nh && have_oif_match && res->nh)
 		return;
 
+	if (skb)
+		IP6CB(skb)->flags |= IP6SKB_MULTIPATH;
+
 	/* We might have already computed the hash for ICMPv6 errors. In such
 	 * case it will always be non-zero. Otherwise now is the time to do it.
 	 */
-- 
2.40.1



