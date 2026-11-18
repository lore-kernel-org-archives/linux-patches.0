Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046603;
	b=hIwC60THgTvCbtpSJWE9CqO75dTd5KOSHSnsLzbSFEhgYY5xb3ndEWkov631CQVagfJ+
	 yb1FB7NqzxaDG4YNdsXZb6r/cZg6UguGQVAb+JANJtGonYL4V8PX1mLlbRhs2dLo3zd8n
	 wyviAZ7UrD2pd5fjVdw87K/lbjnNCiagaN0egCFB5Y9gOpNIlTu17jnrp5pyNM+DRq81w
	 Wy4vjAuwmqXMhushPAvWl5R9wnGb3SsxR0f8HnAEfSN5hKSYNwOC5cCssEaiEMTsWrUob
	 UVP+Lpn89JQbkJz7SvGwph2KfGDnQoQHec/j1m54TGVdulQWV1JGXhRza8vn+nGWdnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YfS4AHz7BAX2QeAGDzWUjmIe6ar0MiKhfxqR42+JXIc=;
	b=qb9f05yS+YTTeCLMcj+2FzEiD2kluGdWeACtMZv/mYVyvn2vODdNO6IcmhqH4a+ZPgM2
	 RJTKMbqZPb+uIQo/qnhQnTtml+EDTeV3j1UcjHgSE6tDrZCQkRe9TSjtJisnk0F8WG6RR
	 0MzNI3BD4m94tbUnTVRq+UL79oITZ42p+WwQuUVPCoiERzGlbZuedkfp3gAkcCw7p530a
	 v2zUnWTOiExhro3Z5TBs0/jkATkoyzsjkEcgip38Lz9OhMAvzVuc39YC4hIAvSDhs6U8G
	 IfYDO0fenJSS24IRLJ2+aEkQU1TG8GC0XjYL+hW7Ob18RFY8hN1zsp72+rFZywnp1Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lHR2WBdg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EF9606A337;
	Thu, 19 Nov 2026 00:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lHR2WBdg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52F21F000C4;
	Thu, 19 Nov 2026 00:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046603;
	bh=YfS4AHz7BAX2QeAGDzWUjmIe6ar0MiKhfxqR42+JXIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lHR2WBdgwE3B367Rpa1AQNHvUkXZWpLrPTF2nm6d+RkyYx1l6oHGwkRBdbmpdKVky
	 wpVHZesUu8nDr14GBVJ/C6ccfckexLkngLklJZeJIW5ZQDDJHOQHvr5gQUlXiqRCoP
	 0Uxt4sU37XbrRuEmGdgTv+ycRYZ6lmTk0VDovMNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1289/2857] ipv6: fix device binding after failed datagram connect
Date: Wed, 18 Nov 2026 15:38:43 +0100
Message-ID: <20261118150247.904920937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e758afe146d3d..756c0e802a3b5 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -146,6 +146,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 	__be32			fl6_flowlabel = 0;
 	__be32			old_fl6_flowlabel;
 	__be16			old_dport;
+	int			old_bound_dev_if;
 	int			addr_type;
 	int			err;
 
@@ -216,6 +217,8 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 		goto out;
 	}
 
+	old_bound_dev_if = sk->sk_bound_dev_if;
+
 	if (__ipv6_addr_needs_scope_id(addr_type)) {
 		if (addr_len >= sizeof(struct sockaddr_in6) &&
 		    usin->sin6_scope_id) {
@@ -258,6 +261,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 		sk->sk_v6_daddr = old_daddr;
 		np->flow_label = old_fl6_flowlabel;
 		inet->inet_dport = old_dport;
+		WRITE_ONCE(sk->sk_bound_dev_if, old_bound_dev_if);
 		goto out;
 	}
 
-- 
2.53.0



