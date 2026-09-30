Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E572D9484;
	Wed, 30 Sep 2026 16:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785572; cv=none; b=qFeXT4zNUR5i9qerMnIUlrdtNYqwpa/5WKGYdkfxCVRkv0JJmI6rLCqXlqwCNTmQofIb67jhRluskuEFHTrWO2+xGp/CupXh5n1sZhlDR0I109UJI3wcDW0iLILrE+1V6Y1v7biFUTihyx2pCGJXQZxXkMQLYrP8QKtsZhDhWrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785572; c=relaxed/simple;
	bh=TN/CqTwVm3q61+uLXnxeuWnZBHeBQxp5mWnvMXkkU0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXggCvbcCyao1o2LTRGXVM9WPrkmiu/LHUESzSE34lhBbQWt9EDT5bViTEZ/WRNHHTVktX7C0hfcSHFgIzNVzM3McAed9bxlgHl36p6lBQ9xOniCSYrKTRS4fa0o+sZBFzLwU6fBM8yHnh9crUWNRGe17E9oKB2MmXCFQLsi5Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVvTDSuQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVvTDSuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A51D1F000FF;
	Wed, 30 Sep 2026 16:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785565;
	bh=eMUHk9bUfm3VHQ4aX6YIeIDwJnpZiK0vCMn+gqKn+PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVvTDSuQYTmgEvpaOKNJ6gLKyax/paGXjioRU6YdIq8AbzaxXk2RP/arasF7IJDt6
	 Ya/IQ4yUz8DxsIZkJnCmOWfCpjEqpZqXZU3zoQl5g7k6g8Ngo/fajU+PHgmIMu5r9a
	 kiB4Ie1tAvfL2NW9HkHMKHYELXOh37IAcR8zUtlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Shun Ota <shun.ota@miraclelinux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 555/982] ipv6: mcast: extend RCU protection in igmp6_send()
Date: Wed, 30 Sep 2026 17:21:31 +0200
Message-ID: <20260930152428.695725426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 087c1faa594fa07a66933d750c0b2610aa1a2946 ]

igmp6_send() can be called without RTNL or RCU being held.

Extend RCU protection so that we can safely fetch the net pointer
and avoid a potential UAF.

Note that we no longer can use sock_alloc_send_skb() because
ipv6.igmp_sk uses GFP_KERNEL allocations which can sleep.

Instead use alloc_skb() and charge the net->ipv6.igmp_sk
socket under RCU protection.

Fixes: b8ad0cbc58f7 ("[NETNS][IPV6] mcast - handle several network namespace")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-9-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ use IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUT, full_len)
  instead of upstream's IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTPKTS).
  Older LTS kernels do not have commit b4a11b2033b7 ("net: fix
  IPSTATS_MIB_OUTPKGS increment in OutForwDatagrams"), so the legacy
  byte-based counter logic must be preserved. ]
Signed-off-by: Shun Ota <shun.ota@miraclelinux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/mcast.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 35fb4f624d59e..4ef73d68f6d11 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2154,21 +2154,21 @@ static void mld_send_cr(struct inet6_dev *idev)
 
 static void igmp6_send(struct in6_addr *addr, struct net_device *dev, int type)
 {
-	struct net *net = dev_net(dev);
-	struct sock *sk = net->ipv6.igmp_sk;
+	const struct in6_addr *snd_addr, *saddr;
+	int err, len, payload_len, full_len;
+	struct in6_addr addr_buf;
 	struct inet6_dev *idev;
 	struct sk_buff *skb;
 	struct mld_msg *hdr;
-	const struct in6_addr *snd_addr, *saddr;
-	struct in6_addr addr_buf;
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
-	int err, len, payload_len, full_len;
 	u8 ra[8] = { IPPROTO_ICMPV6, 0,
 		     IPV6_TLV_ROUTERALERT, 2, 0, 0,
 		     IPV6_TLV_PADN, 0 };
-	struct flowi6 fl6;
 	struct dst_entry *dst;
+	struct flowi6 fl6;
+	struct net *net;
+	struct sock *sk;
 
 	if (type == ICMPV6_MGM_REDUCTION)
 		snd_addr = &in6addr_linklocal_allrouters;
@@ -2179,20 +2179,21 @@ static void igmp6_send(struct in6_addr *addr, struct net_device *dev, int type)
 	payload_len = len + sizeof(ra);
 	full_len = sizeof(struct ipv6hdr) + payload_len;
 
-	rcu_read_lock();
-	IP6_UPD_PO_STATS(net, __in6_dev_get(dev),
-		      IPSTATS_MIB_OUT, full_len);
-	rcu_read_unlock();
+	skb = alloc_skb(hlen + tlen + full_len, GFP_KERNEL);
 
-	skb = sock_alloc_send_skb(sk, hlen + tlen + full_len, 1, &err);
+	rcu_read_lock();
 
+	net = dev_net_rcu(dev);
+	idev = __in6_dev_get(dev);
+	IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUT, full_len);
 	if (!skb) {
-		rcu_read_lock();
-		IP6_INC_STATS(net, __in6_dev_get(dev),
-			      IPSTATS_MIB_OUTDISCARDS);
+		IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
 		rcu_read_unlock();
 		return;
 	}
+	sk = net->ipv6.igmp_sk;
+	skb_set_owner_w(skb, sk);
+
 	skb->priority = TC_PRIO_CONTROL;
 	skb_reserve(skb, hlen);
 
@@ -2217,9 +2218,6 @@ static void igmp6_send(struct in6_addr *addr, struct net_device *dev, int type)
 					 IPPROTO_ICMPV6,
 					 csum_partial(hdr, len, 0));
 
-	rcu_read_lock();
-	idev = __in6_dev_get(skb->dev);
-
 	icmpv6_flow_init(sk, &fl6, type,
 			 &ipv6_hdr(skb)->saddr, &ipv6_hdr(skb)->daddr,
 			 skb->dev->ifindex);
-- 
2.53.0



