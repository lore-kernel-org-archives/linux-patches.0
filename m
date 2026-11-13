Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590429;
	b=t4mVNU3BgAlgwmykW9A/6hlyd2TQY15Fv1YM+u/KP5mlkyLIN2Ae+KCkqfStC8FxvnZ1
	 vWzxWklHPIslENc6qNMNLxkktJt1YfqeAuz3SNy7AFxIEC9RscLLYNL7kUqdNgpeSChhC
	 7Av9QXMOZLq0EtUXTmlDFlxWTy4gH87905jLaXFQOBM0zE/o51VyJfT9GgVOgxAVmtl6D
	 laSdi4sktd0IMNtnQiVmgWXSHZ/T4EysLsVdh9pH9SnD5yXmdWPQNWLuSFVxsdJExbfan
	 BCtoZ/uRWTwXnO3JOGDb3ZVKG/Z25TlBbPiOwTMLnHi8ivDC12KfwtEWw2ouoZ49tvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eCvneVdH/OsEblOhFJglHGypfF8CwGey++B1YfhCbbk=;
	b=HOg9qT0+g3KXM+6LpYGFQEg32nEqb2tLghf0dHNVBC/Bpjw7gTYm1TGsVt/TOLgmg6a0
	 8u4HO0jscb0cdk0DBGNJzx89teje3UID0EsekqM9613vkzdWt2LkvzLfrBItt9TgaRqBi
	 WMJAoUUcz9K5Ucirv8QwfrUVxn/zc7ax0YNdRMk2ZtcL1ni9P7puRTpYzv93mu6PRupja
	 vRXkBgr1lr+IV3M2xA7Z3r2HKsMpvAoIohRc3CSnON0gML4Hy/UC/2QJ4NwcqnmAPffik
	 f+O8TNSOfIs86FBdTA3kNGGcO3jnSE1CiAnz6u1+k2bDBgGtS3T9FhV8VM74HQeFk4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YlZ7YmE8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31180606A884;
	Fri, 13 Nov 2026 17:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YlZ7YmE8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D168B1F000C6;
	Fri, 13 Nov 2026 17:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590429;
	bh=eCvneVdH/OsEblOhFJglHGypfF8CwGey++B1YfhCbbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YlZ7YmE8IJmzgSicBocx1UjKwwLdV0IU0h1UYcuinjhhUk5FhezVujzXJ5O5f3471
	 ljx3iuiJNnBKQB+b/r8eY0och2fPgNRbGNXJSNU2sRRv0k5l6LKkCUppinjHl8VR0G
	 QkenF9VzamW4xUxtwy3zAXytNMPwJnBi//S2DeBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 391/686] ipv6: fix device binding after failed datagram connect
Date: Fri, 13 Nov 2026 10:48:44 -0500
Message-ID: <20261113153834.254129420@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 97c655c260568..7edf30d8098de 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -148,6 +148,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 	__be32			fl6_flowlabel = 0;
 	__be32			old_fl6_flowlabel;
 	__be16			old_dport;
+	int			old_bound_dev_if;
 	int			addr_type;
 	int			err;
 
@@ -218,6 +219,8 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 		goto out;
 	}
 
+	old_bound_dev_if = sk->sk_bound_dev_if;
+
 	if (__ipv6_addr_needs_scope_id(addr_type)) {
 		if (addr_len >= sizeof(struct sockaddr_in6) &&
 		    usin->sin6_scope_id) {
@@ -260,6 +263,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 		sk->sk_v6_daddr = old_daddr;
 		np->flow_label = old_fl6_flowlabel;
 		inet->inet_dport = old_dport;
+		WRITE_ONCE(sk->sk_bound_dev_if, old_bound_dev_if);
 		goto out;
 	}
 
-- 
2.53.0



