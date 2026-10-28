Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217035;
	b=rx1aCgHOYGeAwf4sTGJmCurpVpajFANxjy5Db/S4EOCF4kqwUyNT0nbGmvjZtGgTpdAh
	 adBBrsAR4D3KW6HthPcala6tNeEActogMgRrfrk2zIlIZsHhy5ZXrKEGK2X9RRaRtQ7aP
	 0/ulms1RWyjpwBwX0Qq1/tIG3e81yyLVgEJ7mH+01PcVJnM++TDmdkqungsDQwbMt6D0G
	 AVDphAJi+ePfS+YDZtpMfmGMfztQhLN1leq4IASplffGu4hKtLi0xgodzgUKxsdHH3fYw
	 zNj4pzhHt+XTVjSAvx1f36jxk0SiUpu9gHIQr/zwxD6OmSSIssBY39JiOjvoacXRlmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IsYWC5MugXybyBkcQQB6fvQyRmQxH9AFn9GHfhbRnPk=;
	b=Ws7IvrmyWSU0wddbT2124IMg1mX3Agk1oz7HEyRXLHhEe7EUfbigKVTBvGp3Wm7eAdzI
	 fDMcx3t2RdHjOmckZJIh4Fy7v/eoMXxAYcSnk3RZJl8Rk6s1JC/kPhCGbLK/X8IvUsJ9x
	 tCr70tBq5xrSKOjOLJULJZe1XWhkYetGcXxHpbsrcKmTy3U05FdwqDMJvwkZeVinl1bZU
	 WGGYEJQp3T2mqPCAepbrbYRSdStCFecilXg/mjEq3vVSeQimNM56TyqWCb25su69dISid
	 oXoAjq2NjR6cmHeGFP+nCM0FLBadiVU9KVhO3GbScirYh94UxgB0EP49KiuI1wEQgsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksMVfq3e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA89A606A336;
	Wed, 28 Oct 2026 19:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksMVfq3e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92491F01825;
	Wed, 28 Oct 2026 19:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217034;
	bh=IsYWC5MugXybyBkcQQB6fvQyRmQxH9AFn9GHfhbRnPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksMVfq3eWKdkgomvy9wjyvnspBxBrAk31VXctipgLC4UShNybhm2YJRPiJfbksZZH
	 Re4PbjwqXFz38qySEzyUkRQG1OZ5DZoAOO/ZE4JgUTMKBsNc/ndvS8X3ULX4e01lla
	 7r8W3DVXOnajX1qN/fTjN8A7kTY0N7P/+0Yd1s9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 1765/1887] ipv4: avoid divide by zero in fib_rebalance
Date: Wed, 28 Oct 2026 18:04:21 +0100
Message-ID: <20261028170539.621401205@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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


