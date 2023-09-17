Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8E06FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D203C433C8;
	Sun, 17 Sep 2023 19:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979554;
	bh=UXXKxW93z6LQ0/LMhS1lxjcM/Wb6aUI3BC1ow/fa6Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n16TZrG58Ms2t05zcwr0YDtHd8v8P7Xgf29UiLvsyqQyhTQwuZ33R0kYrVuWoVlPK
	 mOn+1bThGNQqvBb3W4wKchqqwlf6+yT776nnQEjbVNL+RNcAiGcushJK86GfKsxkjC
	 otRrYru3nxTLsHMlWgUATINkpOI4o83If1uzO7Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 347/406] ipv4: ignore dst hint for multipath routes
Date: Sun, 17 Sep 2023 21:13:21 +0200
Message-ID: <20230917191110.437557588@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>

[ Upstream commit 6ac66cb03ae306c2e288a9be18226310529f5b25 ]

Route hints when the nexthop is part of a multipath group causes packets
in the same receive batch to be sent to the same nexthop irrespective of
the multipath hash of the packet. So, do not extract route hint for
packets whose destination is part of a multipath group.

A new SKB flag IPSKB_MULTIPATH is introduced for this purpose, set the
flag when route is looked up in ip_mkroute_input() and use it in
ip_extract_route_hint() to check for the existence of the flag.

Fixes: 02b24941619f ("ipv4: use dst hint for ipv4 list receive")
Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h    | 1 +
 net/ipv4/ip_input.c | 3 ++-
 net/ipv4/route.c    | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 8d1173577fb5c..9be2efe00f2c0 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -56,6 +56,7 @@ struct inet_skb_parm {
 #define IPSKB_FRAG_PMTU		BIT(6)
 #define IPSKB_L3SLAVE		BIT(7)
 #define IPSKB_NOPOLICY		BIT(8)
+#define IPSKB_MULTIPATH		BIT(9)
 
 	u16			frag_max_size;
 };
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index eccd7897e7aa6..372579686162b 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -566,7 +566,8 @@ static void ip_sublist_rcv_finish(struct list_head *head)
 static struct sk_buff *ip_extract_route_hint(const struct net *net,
 					     struct sk_buff *skb, int rt_type)
 {
-	if (fib4_has_custom_rules(net) || rt_type == RTN_BROADCAST)
+	if (fib4_has_custom_rules(net) || rt_type == RTN_BROADCAST ||
+	    IPCB(skb)->flags & IPSKB_MULTIPATH)
 		return NULL;
 
 	return skb;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 374647693d7ac..3ddeb4fc0d08a 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2066,6 +2066,7 @@ static int ip_mkroute_input(struct sk_buff *skb,
 		int h = fib_multipath_hash(res->fi->fib_net, NULL, skb, hkeys);
 
 		fib_select_multipath(res, h);
+		IPCB(skb)->flags |= IPSKB_MULTIPATH;
 	}
 #endif
 
-- 
2.40.1



