Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7985C4D7D4D;
	Tue, 13 Oct 2026 11:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892013; cv=none; b=rs5xEYPjmzLUK5vXe7q/AB9I88HVJAW3W4Z77pEPkpgKjPLYqch3b8u2ZEe0Jt+4o1F9rcdekQ+AL9NftEv7TO+SiynFXQSQMchvXAZkLhwBD4fVX+sS4Wgp6O39/m+fZh1DGAGzuVJKWDFeqiqkdJDowJsEv6pFw444GLXbD2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892013; c=relaxed/simple;
	bh=8CJghREZFae02SPf3NM20fEPZFHSIL5hgcCEi3HnyGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvzVHvFC4F6bq1s72hLTn2uucliuMP9qptAzcVgRs+7g11ejg+f2vcQaGDMcFnh3Drbbxd7WbY7iLGfcJ9QzVqnolS7jqa2w4qrnN5zC7EZB59clG5mlTVpCB2noS90yN4x/fDB2ECOzCuq4p8NWPbA3kGFdcWTqoWDNqF7Lt/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ar4kBTCH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ar4kBTCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967821F00893;
	Tue, 13 Oct 2026 11:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892012;
	bh=LZYiP994fq7AU61VSAbz1FAi2eHtyCd74hqzkrMI7WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ar4kBTCH09Ei2vm0PJfcPQX0I+xE+Za1D35rV8t2Ay/pVli1RmxtOS6DruIDj8BQT
	 tmqAisLPcCpUGX8TJxlMALbaPhe13YDBhshZLFX0i1VT8adsl9Ux70/ZvuTCCHuaVf
	 dmQ1jiKdoECs65ABPv8kFHR4mBggt3H8S8bIy9XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Klein <aksecurity@gmail.com>,
	Noam Caspi <noam.caspi@mail.huji.ac.il>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 007/281] ipv6: udp: Create exceptions before socket matching
Date: Tue, 13 Oct 2026 13:35:23 +0200
Message-ID: <20261013112855.230277391@linuxfoundation.org>
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

[ Upstream commit ac76cab50e899a7346408b8d3c3a4192c2eefb9f ]

Currently, when ICMPv6 Packet Too Big and Redirect Message packets are
locally delivered and quote a UDP packet, an exception is only created
in the IPv6 exception cache if the kernel can match the UDP packet to an
existing socket.

This behavior allows off-path attackers to conduct a side-channel attack
on the exception cache in order to discover the ephemeral port used by a
connected UDP socket.

Commit 4785305c05b2 ("ipv6: use siphash in rt6_exception_hash()") and
commit a00df2caffed ("ipv6: make exception cache less predictible") tried
to mitigate such attacks by making it harder for attackers to discover
hash collisions in the exception cache and by randomizing the number of
exceptions a hash bucket can hold, respectively. Unfortunately, both of
the mitigations can be bypassed.

Instead, mitigate such attacks by always creating an exception, even
before trying to find a matching socket. Do that by calling
ip6_update_pmtu() and ip6_redirect(), the helpers used when the quoted
packet did not originate from a socket.

This means that guesses (right or wrong) from an off-path attacker will
always result in an exception being created or updated in the cache that
the attacker can observe.

Pass the ifindex of the ingress device and the default uid, in a similar
fashion to icmpv6_err(). Unlike IPv4, an oif of 0 would not match any
nexthop in ip6_redirect_nh_match() and no exception would be created in
response to a Redirect Message.

Note that this does not allow attackers to create exceptions that they
could not create before, as both helpers can already be reached with
little to no validation. For example, by sending an ICMPv6 error that
quotes an ICMPv6 Echo Reply or one that quotes a UDP source port that
matches a wildcard socket.

Also note that in the good case (matched socket) the above scheme comes
at the cost of an extra route lookup, as the no socket helpers perform
their own lookup before the one performed by ip6_sk_update_pmtu() /
ip6_sk_redirect(). When the two resolve to different nexthops, it also
results in two exceptions being created for the same destination IP. One
in the exception cache of the nexthop resolved by the no socket helpers
and another in the exception cache of the nexthop used by the socket.

Fixes: 2b760fcf5cfb ("ipv6: hook up exception table to store dst cache")
Cc: stable@vger.kernel.org
Reported-by: Amit Klein <aksecurity@gmail.com>
Reported-by: Noam Caspi <noam.caspi@mail.huji.ac.il>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260828192344.2596928-4-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/udp.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 15e032194eccc..b73cf02ac1b6e 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -690,6 +690,17 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
 	return sk;
 }
 
+static void udpv6_err_update_exception(struct net *net, struct sk_buff *skb,
+				       u8 type, __be32 info)
+{
+	if (type == ICMPV6_PKT_TOOBIG)
+		ip6_update_pmtu(skb, net, info, skb->dev->ifindex, 0,
+				sock_net_uid(net, NULL));
+	else if (type == NDISC_REDIRECT)
+		ip6_redirect(skb, net, skb->dev->ifindex, 0,
+			     sock_net_uid(net, NULL));
+}
+
 static int udpv6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		     u8 type, u8 code, int offset, __be32 info)
 {
@@ -703,6 +714,8 @@ static int udpv6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	int harderr;
 	int err;
 
+	udpv6_err_update_exception(net, skb, type, info);
+
 	daddr = seg6_get_daddr(skb, opt) ? : &hdr->daddr;
 	saddr = &hdr->saddr;
 	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
-- 
2.53.0



