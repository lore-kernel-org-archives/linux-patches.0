Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B483B841B;
	Tue, 13 Oct 2026 12:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892861; cv=none; b=V3MgSr8LJKNJTxYSxvTCgD2+FzWhfVtuF0X8csAOgbHOzRuGqtg7fsj/N4ZYhNaAeE6I9xC+gPHHEMGrLzXSTGQcrp1BsGXgrd1qTBQ0+kid+xFwVoPTpcmfGbIy4BDx1dr7fo1vrIhssZ1YlfdTNlSCVmeCrdU1PGZWu2QBDG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892861; c=relaxed/simple;
	bh=iFbIlJca+HSSLJeh5V7PV/KXADGb5wqjVcASK3GriAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDoBfTT8spqVUVQ2+2WPdyldSHQ3wxizSIVLt2snsW/lwsQBL5nlegpPg7hnpoqNr10172FrVx91XGAXTPTVi42pgD16svXpk/MbMHQDtgUcampdkL6siLrU944ID84OutCmQQsfEG6SXu0S/HzRhjJVxE0ICd0hiWfNkKwnByQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHR7TDb5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHR7TDb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348531F000FF;
	Tue, 13 Oct 2026 12:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892859;
	bh=Si04Hwc/Y5ZW1TR0a0W/9w+HxdR+GhXPPI9wZPi3OMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHR7TDb5Y/wQUpqLmE/NNqCox4gb1J+K06R9uxW8fQBUy54Bu3wSNoXjoeRcqTEnf
	 7eEmfdjxNFglIWkzxNCSznGeBCCZ4GdzNu1m7pXj5nMvxPNHXJdYBsgW1CC3VIQUmp
	 KotqU1QhkB0uGjPfZd1RWXJc2wOi9Tw5lGKH1J8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 015/621] ipv6: Fix redirect exception creation for UDP/RAW sockets
Date: Tue, 13 Oct 2026 13:30:10 +0200
Message-ID: <20261013112921.225903781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit cd51b74bdd0b75aedf255dc67306a16dd057f7ee ]

When an ICMP Redirect Message is matched to a socket, both IPv4 and IPv6
verify that the source IP of the ICMP packet is the current gateway for
the quoted packet. Both also pass the socket's bound device as the
expected nexthop device.

The difference is that IPv4 treats "oif=0" as "any", whereas IPv6 always
requires an exact match (see ip6_redirect_nh_match()), since the gateway
address is usually a link-local address.

Therefore, when an IPv6 UDP/RAW socket is not bound to a device, the
above verification fails and an exception is not created. This also
happens when the socket is bound to a VRF, as l3mdev_update_flow()
resets the oif to 0.

Fix this by passing the ifindex of the ingress device as the expected
nexthop device. This is consistent with the existing callers of
ip6_redirect(). Note that for ICMPv6 Redirect Message packets the VRF
driver does not reset skb->dev to the VRF device, so skb->dev is
correct, even when it is a VRF port.

Fixes: b55b76b22144 ("ipv6:introduce function to find route for redirect")
Cc: stable@vger.kernel.org
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260828192344.2596928-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e99b4901091a2..a02819f4689ff 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3257,7 +3257,7 @@ void ip6_redirect_no_header(struct sk_buff *skb, struct net *net, int oif)
 
 void ip6_sk_redirect(struct sk_buff *skb, struct sock *sk)
 {
-	ip6_redirect(skb, sock_net(sk), sk->sk_bound_dev_if,
+	ip6_redirect(skb, sock_net(sk), skb->dev->ifindex,
 		     READ_ONCE(sk->sk_mark), sk_uid(sk));
 }
 EXPORT_SYMBOL_GPL(ip6_sk_redirect);
-- 
2.53.0



