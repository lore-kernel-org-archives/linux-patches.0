Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783194FC8E6;
	Wed, 30 Sep 2026 15:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783213; cv=none; b=ErdLiWzXrICn+zPX8FhmUfVBCuLtzxJ7+Npv66ze9oEfn9ghM5dtJ74NWksRfL057ErGIxagFc+1gODUCy8FxHgC3QFIlyz4Q/1SmKnVWId2YH/ab+cVhS59Tu5C0WUhMq/5EUEI0Ky/zyt3M+SX2l2uszmkDVAFZfV8rwtC5GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783213; c=relaxed/simple;
	bh=rlEyaGTH0TGfAzTxd0UwJaKiTvWp06nvUuZ2O7G1WsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnN1td1bA2UwHaMb9FMxwFVdb/euXLupiwMlzxNTAsJ9ovKr2cVOGxrJmxLotnAjlOKGbYeKJcYK2eN3ClA9+xq8fpnRnqfFh3dhMSRvcmUXtbtuQ5VPkf4EgjmXJ40G8Ir9fVLTogrY0/3J6VYEaQ9V85iBDMBBqxnUprzXZYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nnu2Hd/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nnu2Hd/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3E31F000FF;
	Wed, 30 Sep 2026 15:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783211;
	bh=giwyrOY2CkwlvMLJ28/tUDi+9FTKzCeN9s3+INRWJzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nnu2Hd/xn77qMap93Jtnbs+wNwBuReyo7oneit/8Wl7AoqCt40Qu3LDI7pzbVTOBM
	 JU2GaH6OEG1XvueMtNzkBcKL9fwwPU43DWYwVHEXJNzhxINBQ/GvfjpDbi12/f1s/Y
	 1eQyJqgPy+calS0o1vUdW08dqDK4poan/o6e2/us=
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
Subject: [PATCH 5.10 320/595] ipv6: mcast: extend RCU protection in igmp6_send()
Date: Wed, 30 Sep 2026 17:23:33 +0200
Message-ID: <20260930152354.569496635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c4a9866ea45b6..7b141c227eefd 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2146,21 +2146,21 @@ static void mld_send_cr(struct inet6_dev *idev)
 
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
@@ -2171,20 +2171,21 @@ static void igmp6_send(struct in6_addr *addr, struct net_device *dev, int type)
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
 
@@ -2209,9 +2210,6 @@ static void igmp6_send(struct in6_addr *addr, struct net_device *dev, int type)
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



