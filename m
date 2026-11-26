Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704545;
	b=vqB2CEgQqIV7IPEuuJXIq6JJGFeDtWJB7YswDg7UZ/umDtVye049J3Eih4b8FFP9ez/b
	 J9cgVRcqlju2fZis07MV6fRaTfokFaEdXZB8nORBn1dazrU3k44yn4i2GrqbxXZiZS0YX
	 Lk+towBquDYTSzeKCRtq1bvHCgyBaW2wsJOy6uImio2/gKsM0ywLG6UNcLfsjFa7B0ffi
	 haUt3Q8w+Cbtb6VnUaX1yJWSa4bVm1C6ET7vEcuOn6btC7MaJbYxb6/cEBKAO3Zk2E4xH
	 VQH7Rbt+c4xRr3v5K1WGhx6qFt5lJ8wvre2tq+KzMCDCPulTfr0YGCZ+52/36LVZ8uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n5M7NQLRxApTSh/S8RwWSEgWPiQy1/jdzCth8axngaQ=;
	b=CSlEjh/G1tlWp4yqokKAe1bis+/py03HV26/aRXa+P0xW5N2TISBy5oKqO6bdp3Z9WZQ
	 //7LjziiQKwgTU/AMKEd7Ek3D07ameFipNNmphQNMVbQbKYmR4XFY2FEVfWdFWbzre69M
	 SXEdn42qPTZCcFQIYCI6bR0SFdZdLH1KcU80ROJdqoEMtmC6tW07s2oWuZZvkZB812bcq
	 LubxvFsn5X9ETfbgwNr0gYEwogCHEAMJRcWcH7MEiuNZMyPqQPvc4UtfROuH34/7nmEnO
	 5Gz28SI19KaBfeZPnb4inPbWM0Ey2wM2f7WQV7oNkJUl0RjXTON5ljIfSoRfAA1tOtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgq4hNQE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E47606A31C;
	Thu, 26 Nov 2026 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgq4hNQE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA3B1F000CA;
	Thu, 26 Nov 2026 14:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704544;
	bh=n5M7NQLRxApTSh/S8RwWSEgWPiQy1/jdzCth8axngaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hgq4hNQE743S8/GOVLbQ89qVVuU3piyR5Rivp2hci8I4tOcoBjbwdDcd0L1TjAVlf
	 pL66yok10biLxJhma/CSa9ZexZCwZvS2rTr0XUgAKCGadgGcIsNIQwCZbP15B+RXaX
	 0DiPDFyS7L/b5MQlceEpSGN4SOQmsLrVZoFK/TVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 161/265] ipv6: fix cached route reuse for control messages
Date: Thu, 26 Nov 2026 15:38:11 +0100
Message-ID: <20261126143616.391591393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xia Yan <yanxia@cmss.chinamobile.com>

commit f778e80b3daf5033fb996f45c2b5d0ce1e82c0a7 upstream.

A connected IPv6 UDP or ping socket can reuse its cached route when an
SO_MARK cmsg requests another mark. A packet can then bypass a prohibit
rule instead of failing with EACCES.

ip6_sk_dst_lookup_flow() reads the cache even when connected is false.
UDP clears connected after parsing IP or socket control messages. Ping
always passes false.

Only read the cache when connected is true. Ordinary connected UDP
sends keep using the cache. Ping sends do a fresh lookup.

Found during code review of IPv6 UDP route caching. On UML, the same
connected-socket selftest fails four IPv6 cases before the fix and
passes all 54 with it.

Fixes: c6af0c227a22 ("ip: support SO_MARK cmsg")
Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Link: https://lore.kernel.org/netdev/willemdebruijn.kernel.1e0038bcc3ef8@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Xia Yan <yanxia@cmss.chinamobile.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261109014400.9025-1-yanxia@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1233,7 +1233,7 @@ EXPORT_SYMBOL_GPL(ip6_dst_lookup_flow);
  *	@sk: socket which provides the dst cache and route info
  *	@fl6: flow to lookup
  *	@final_dst: final destination address for ipsec lookup
- *	@connected: whether @sk is connected or not
+ *	@connected: whether the flow can use and update the socket dst cache
  *
  *	This function performs a route lookup on the given flow with the
  *	possibility of using the cached route in the socket if it is valid.
@@ -1250,11 +1250,14 @@ struct dst_entry *ip6_sk_dst_lookup_flow
 					 const struct in6_addr *final_dst,
 					 bool connected)
 {
-	struct dst_entry *dst = sk_dst_check(sk, inet6_sk(sk)->dst_cookie);
+	struct dst_entry *dst;
 
-	dst = ip6_sk_dst_check(sk, dst, fl6);
-	if (dst)
-		return dst;
+	if (connected) {
+		dst = sk_dst_check(sk, inet6_sk(sk)->dst_cookie);
+		dst = ip6_sk_dst_check(sk, dst, fl6);
+		if (dst)
+			return dst;
+	}
 
 	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_dst);
 	if (connected && !IS_ERR(dst))


