Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705427;
	b=mIRYm5KkpCa8qKRXEeESvh37tr/QbL3VJx+ZUx4jGBcQl1W5CldNpNQ1+jl3BayzvhHD
	 P6OfOQZM273ZzxGVlo1fyVW2Emudb5wzWlfjintJNpsTu3oYYYQzfIUh2s3oowY+G7zBV
	 2TM5AVtHXdZtiB4OBL97Sju2+EPccK02O3jRnYZ3azygitsIpLWNpMfvBOLkOMHlRvT0o
	 MgOQFmMtL1OoqHyiTT7TetyHe4GoBCRuH4ci1UcFUYoZi6hpeFF77k35ULiu67nLTmY5A
	 ae/F3mgbSY4umcHT/paWpPbEoPwtvbQaKA0IJ5W8IKm7KrIPIFmkYGnKe8fctPRLf2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fw+XaxP3e33Hi5LVf7gD9shKVkoOyX19rKkfN+K0nYs=;
	b=VpedxYyzwy+EpHYoID98rP1EzAPSgUpvPls3p50xmQg90TzYVGTPpuRZWhFgPGAQc1k0
	 9AHMIyMl1YhxQ7bLiOiGN+TSDROCoXrNN3BZclEZKmLU37VKYLLk57ReVxt4mPaBB2Kjt
	 z43tU8bSMX2ofom6T1zEuVkSka1P1qUhDgva5MKwgIEkZCBGDjiZdLaK7q/8wXOusSnkA
	 JlIvDxIDbzbYRDGnEnNwPH5Et01g9x3tCvD5QyqnTwiCrfYGfGdorJh43GQq5N5GYXbzj
	 jtjSxOgop4J6Pp+C4CwVwzX8TC2JEBj6pD+1XzsEGITUpPiniMoucNdgsz4iJvjQdZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PTkuviZX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7842A606A31E;
	Thu, 26 Nov 2026 15:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PTkuviZX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45DA1F000CA;
	Thu, 26 Nov 2026 15:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705427;
	bh=fw+XaxP3e33Hi5LVf7gD9shKVkoOyX19rKkfN+K0nYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTkuviZXJolCOIGiO9839TGA5xSOTPJRNQQ3T8nk5xKhW/v6dJyjc0Y/YKV4bhSCk
	 M8/uWp5BwB85RVWAekTYFd2oTcpO1bSQOT8uivmhE4gHtfZk1K9/sw/wxn73xcaNsx
	 qSw4iyxsOqTEne3hYbywlzPJx4yaz8DcPKHrgFqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 195/319] ipv6: fix cached route reuse for control messages
Date: Thu, 26 Nov 2026 15:39:23 +0100
Message-ID: <20261126144011.146343020@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1257,7 +1257,7 @@ EXPORT_SYMBOL_GPL(ip6_dst_lookup_flow);
  *	@sk: socket which provides the dst cache and route info
  *	@fl6: flow to lookup
  *	@final_dst: final destination address for ipsec lookup
- *	@connected: whether @sk is connected or not
+ *	@connected: whether the flow can use and update the socket dst cache
  *
  *	This function performs a route lookup on the given flow with the
  *	possibility of using the cached route in the socket if it is valid.
@@ -1274,11 +1274,14 @@ struct dst_entry *ip6_sk_dst_lookup_flow
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


