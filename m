Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210111;
	b=n2JcnME1j8D+8WOeKY3gd1SFbIOZOo7bH6hFc+faMfzwcMshffmWFlbWz99vFmP8vBlc
	 uOeelQfKsXyn3wgrf5v5dOODkd1yo1TkXEki+q0caGuqxY1839hYceiQMpoqtslPHgsr0
	 XsqbUSLofdrUKo8+kuXhHXxgeIncQiYgkWvqQPSFh2SwYnpXEB9XE5OL0KlV34YfVa2Sn
	 P4Tvr6mVpNHfrq7D1L/IMADHxsMzVpTgYn2djGUTs3z5naPRrtHyyd563xz0NK/aDnPCs
	 bwgGMeHDwqab7EU+tyvxQul91Xf3aN/nHefYM9dDcu7zQf62uGMMoMxhDMJ24D6tKCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pMqwf/ZhTM0ylAkCfAhBbtXXIWQi39OERnSBE6Md0UI=;
	b=x4az8Q0S3aFn0/uGdS+3sfFyWGAmTcnOx7KkViH1aGhuIjcW8tIotZuB4k8oTO6d1uxp
	 rS2GWbDIzlxIZiAEC8LRvj8Ce2jLRoO/9a8vvLhqUyy7Bvq38+ce3/aXNbzSTl6losY4i
	 V1erXrLEd6I6zvImB873fQkc37S2VjMcy2SUN4mBLveZNxL8aBqGmvbyzVa6pWt4BxCF+
	 GRZUpbxMm4N87/WapiRHVHnI2Ruz41UOR/rhkyf2djxRbWs4RgVbxHCDCHElURHr48sB6
	 DA/GqvzLaQzHEVEkO+fhPry2zWWEThrEvp0TLbwDXOirisE4ets3xy5pdDTJC/0R90g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sXnpcHzy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A4E606A31A;
	Wed, 28 Oct 2026 17:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sXnpcHzy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364AC1F01825;
	Wed, 28 Oct 2026 17:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210110;
	bh=pMqwf/ZhTM0ylAkCfAhBbtXXIWQi39OERnSBE6Md0UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sXnpcHzy3Qm0/JtO+/AVHHmpxX10UWFeshoVUIv/OviNrcDpig6pOJKFhwrODuZpb
	 Q4PUg3BLhy7doJt2qajMPW5nuDAn3baVXhdwY9INjkcaqr7OK+FP4oqVNGDXG3/l+S
	 ZV7nfZbjIWIbdOOSrZYRpofKnFyg7sWyFr61aqWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 079/168] ipv4: avoid divide by zero in fib_rebalance
Date: Wed, 28 Oct 2026 18:00:15 +0100
Message-ID: <20261028165944.953650039@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

commit 5046d2880fec7d49ebed2fd2866747ee1d06ad71 upstream.

fib_rebalance() computes the total eligible nexthop weight in one pass
and programs upper bounds in a second pass. A concurrent change to
ignore_routes_with_linkdown can make the first pass return zero while
the second pass sees an eligible nexthop, resulting in division by zero.

If the first pass reports a zero total, set each nexthop upper bound to
-1 and skip the division. This matches the IPv6 fix in commit
d2c26c2911dd ("ipv6: avoid divide by zero in rt6_multipath_rebalance")
and preserves the lock-free rebalance path.

Fixes: 0e884c78ee19 ("ipv4: L3 hash-based multipath")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260827182514.4667-2-zihanx@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -857,7 +857,7 @@ static void fib_rebalance(struct fib_inf
 	change_nexthops(fi) {
 		int upper_bound;
 
-		if (nexthop_nh->fib_nh_flags & RTNH_F_DEAD) {
+		if (!total || nexthop_nh->fib_nh_flags & RTNH_F_DEAD) {
 			upper_bound = -1;
 		} else if (ip_ignore_linkdown(nexthop_nh->fib_nh_dev) &&
 			   nexthop_nh->fib_nh_flags & RTNH_F_LINKDOWN) {


