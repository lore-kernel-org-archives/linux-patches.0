Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585736;
	b=kBld14n6lZjwGkJ4iL7mlYwzoQ5Y4as1UGiUnVPfC+N/1ZMqdpvpJk2JuXt3OiLZSFOD
	 1cSRRBZzETqgrgrNM9yjDXtRLahiWg+0XSvEHgjFYewSK0YuB3pnUTTBZeg9f1rkdf6v0
	 j2Gm8SoJEPM2itjgEa2hhe3sjSmb4C5nrjLKbShU4mxo8xVkl7i/1TO12gczOCMgZealO
	 3R+whFBQTWug4tlVnDZ66GJuasUtDrSqSclTLgGkyGK1EYKAPpwVa1eRrNzVEiX6qr2TJ
	 8K3Vgdd1mYqURXTU1OTD7BCTzOJ9sFiGMWbu7TY/5SvvzchZ0mXInBGn4/d4IUfQDxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a0I4lfDdmWNR4Yac8kbFLHjiiDaMTYPRzAbkYtLsltQ=;
	b=HGuvzVBLwgtpQoSYApVWfC21u/JRJjoTYKKV2xe2GeU2d1Nlb2BijYgy1Gqst8H3Exlu
	 TUU3hO4vH0xZyze+ZypptFl2SSmXSARj2CUoNPugb+R5pKwBoIRnbxQLtWn9nizjfy5LJ
	 9VjsxOVWHnwkRCOHPQPjeHmjPEDuVzh83sXisupTa1HyR1L6dm0LMnKmsHRUYEn5CC1cu
	 IQqkSAR45Ct+MO1kurXMSHqm1usl+0LmSHAEh10eM13pe2sCJWJsF9JBgUoSKlIndyYDV
	 wogGOgou24xPzinaTfHNUxkVL/NmzgdJtbmuLgKLyuvd9dwuOSIT0MNOmHbuLHtzv8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s1dSwmsp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B303D606A336;
	Fri, 13 Nov 2026 16:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s1dSwmsp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C401F000C4;
	Fri, 13 Nov 2026 16:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585736;
	bh=a0I4lfDdmWNR4Yac8kbFLHjiiDaMTYPRzAbkYtLsltQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s1dSwmspxG26gxrMaya4tRkTwQNU7EpwT/F5ah0Y/FNwMv2O6s38972+m+HBlB//U
	 YgvXVfdItq/W73NmTMMhUgbvrOsQck0qP424ai+FUh+0LiYb3F8DBz4bnd0+YUXo5/
	 JU8pDl0JWjmJmNzRPjA09XqkakNbNJ0Jl5/8U+bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 336/507] ipv6: fix device binding after failed datagram connect
Date: Fri, 13 Nov 2026 10:50:40 -0500
Message-ID: <20261113153806.804970078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xia Yan <yanxia@cmss.chinamobile.com>

[ Upstream commit bc53aab4881adc134f495092034e9e7c0791d84c ]

__ip6_datagram_connect() can change sk_bound_dev_if when connecting to
an address that needs a scope ID. If ip6_datagram_dst_update() fails,
the old peer address and port are restored, but the new device binding
is left behind.

A UDP socket can then keep reporting its original peer while sends and
attempts to reconnect to that peer fail with ENETUNREACH. Replies to the
socket are also dropped by the device match. The same problem occurs
when a scoped multicast destination picks up np->mcast_oif.

Save the original binding before processing the scope and restore it
along with the peer information on failure. This completes the rollback
in commit 2f987a76a977 ("net: ipv6: keep sk status consistent after
datagram connect failure") and preserves the new binding on success.

Found while reviewing scope-ID handling in __ip6_datagram_connect().

Confirmed by exchanging UDP traffic over ::1, then attempting a link-local
connect with a nonexistent scope ifindex or a down interface. After that
connect fails, the original peer is still reported but communication and
reconnecting to it fail.

Tested before and after the fix in UML for three rounds, covering explicit
scopes, multicast interface fallback, initially unconnected sockets and
existing bindings. With the fix, the old binding and peer are retained,
and traffic and reconnection to the original peer work. Also built on
x86_64 with W=1 using adjusted allmodconfig and allyesconfig
configurations, with no new warnings.

Fixes: 2f987a76a977 ("net: ipv6: keep sk status consistent after datagram connect failure")
Cc: stable@vger.kernel.org
Signed-off-by: Xia Yan <yanxia@cmss.chinamobile.com>
Link: https://patch.msgid.link/20261029135822.448299-1-yanxia@cmss.chinamobile.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/datagram.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 38d7b48452817..9672ac979f476 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -149,6 +149,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr_unsized *uaddr,
 	__be32			fl6_flowlabel = 0;
 	__be32			old_fl6_flowlabel;
 	__be16			old_dport;
+	int			old_bound_dev_if;
 	int			addr_type;
 	int			err;
 
@@ -219,6 +220,8 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr_unsized *uaddr,
 		goto out;
 	}
 
+	old_bound_dev_if = sk->sk_bound_dev_if;
+
 	if (__ipv6_addr_needs_scope_id(addr_type)) {
 		if (addr_len >= sizeof(struct sockaddr_in6) &&
 		    usin->sin6_scope_id) {
@@ -261,6 +264,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr_unsized *uaddr,
 		sk->sk_v6_daddr = old_daddr;
 		np->flow_label = old_fl6_flowlabel;
 		inet->inet_dport = old_dport;
+		WRITE_ONCE(sk->sk_bound_dev_if, old_bound_dev_if);
 		goto out;
 	}
 
-- 
2.53.0



