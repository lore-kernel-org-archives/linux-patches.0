Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF7C4EDCBB;
	Tue, 13 Oct 2026 11:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892008; cv=none; b=qyvmIb5XGGf1i8Lde2iH5rqgSxWLEsK30/ljC7c33R8uwby0fgz8ICc0Ms/QfVfgVlOm43BIAgnKjxAmX5/j1rEJc190mNa5mmP75wuwgMSGMRU8xnLXLUY8keGFEuKBA3E8Mjila1iKNZd0EJiGtibCYt4CN/ouMXA7fBSU7yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892008; c=relaxed/simple;
	bh=NHY8BXKCqd/1/so+q7v4UZPKhM4myCtEqVmnjJAs+zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBJE9n0x5iHpAi9rar7Rh7Sdm5tRWbpK4vwNAUnte+bvMo1m02QxKPnjVY8QuCjg1h8pro4YRrLC4W4O+FfvnjrGKkrQeRt8bxhN70UPZ/zwYAnhnDuaTaG6I25T6g9a4V67IgfIti0zauIBOcf64Ju4+GHRcjYOxLAJQj0fCew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDT+bCG5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDT+bCG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D921F000FF;
	Tue, 13 Oct 2026 11:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892006;
	bh=lbk4P3nxCxSYsg6Gv+QzkFW4Rn6WUDqfSYGggDUWSPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDT+bCG5Z2QO8qCfUB4ElM+2pl/d3wrQnKZUZ36Y8N2jzSw6CBrDrOIe+Td5ssU+M
	 /aV6SiXmKLEiPoU7dh28pY5TJuKecDGu5hlF/ZFu/MkG1eDHfsaaMsYz+0AQlYt35/
	 oU/cev5bgsW8kgMVjsuGVPUXB5LSxuJWF7t9E/No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 005/281] ipv6: Fix redirect exception creation for UDP/RAW sockets
Date: Tue, 13 Oct 2026 13:35:21 +0200
Message-ID: <20261013112855.181266024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 8fddcc631fcb6..f58c670588def 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3261,7 +3261,7 @@ void ip6_redirect_no_header(struct sk_buff *skb, struct net *net, int oif)
 
 void ip6_sk_redirect(struct sk_buff *skb, struct sock *sk)
 {
-	ip6_redirect(skb, sock_net(sk), sk->sk_bound_dev_if,
+	ip6_redirect(skb, sock_net(sk), skb->dev->ifindex,
 		     READ_ONCE(sk->sk_mark), sk_uid(sk));
 }
 
-- 
2.53.0



