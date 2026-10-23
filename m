Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774938;
	b=weaC3PwFRnwX4t9XGZlgxg5JuxQ/xr+EAd7NcShdat9QGx8S9yWxLJuowRz6NZ9s1voq
	 MzTF/XJZjCLbdcSnvRyG1D09cW2MDv2HTfl72qGtEqiUF8xaA7YB9e/fJX5yM4gSI7rQk
	 Yp5+7+e+B3R9FhVPznpnpQIYTt46Yf0joBTDf/OLMRNRh+XWFoYw3ZyL67UZ4KMeSKSgi
	 GU4rHDHgPdIsU67Eot7Snxo0NFnAuLzTH2gIOytw5iW9yUKqSbU4r1xC/gFdw+6O5avbo
	 5VM83Iqz1jLUsWSSfUSrHOVAQK05mi3R8plZTzRS04A1QbCY7upbIcvtzXaVIHmnUwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1aHzcYp1jRRqmng/89pp3Adj43LUuedquo7DdJWOn1E=;
	b=0MZh2Cl9zDLN5h/mBi20xrLHH1QqIW9G8Dft1WflHLwZe0vPg2DqVuI3nJ/034v6pMHV
	 x4X8hGenepSZesmZssV+VNcTvX/2Ecnxwf4DBsn/gk9xqhX3gwIglBlbT845z7TWcwN8I
	 yNuhv9lUd6BbWbNdFT2iMX04sE1HQQdY+Y/AtDn7mgWusz0SN1dBN67dmuSsXBneK9H22
	 G0m6uGPSRMpz0U9VbmzH7KghM9A85uJjV4cvXR73SDzuTfgXxIMnEz6anjWhG/21oZ5kh
	 mVtz6YlmbbFSJ+Ih8RZadu3DML5Lnerh1wqBN0CD59SpvLz9aiaHc+s2kGGfiTLgYhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="chVB+eJ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5259B606A31A;
	Fri, 23 Oct 2026 17:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=chVB+eJ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB001F01825;
	Fri, 23 Oct 2026 17:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774938;
	bh=1aHzcYp1jRRqmng/89pp3Adj43LUuedquo7DdJWOn1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=chVB+eJ/vqlMDoRFrEdRPgLHANWwqdSYPOZ9yS/8hKZssPw/xxr5LWjUpaTf2aRe4
	 ps28K8gaYyQB8QIPVuBnwGVNhGOKDKZQ1HdYl95asK9ZfrZBpWuUbjw7trGOnH4vR+
	 83zI0An2QRBSMnfJHGmuFqiEHelk4L06DvrqxVWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 207/242] ipv4: avoid divide by zero in fib_rebalance
Date: Fri, 23 Oct 2026 18:40:49 +0200
Message-ID: <20261023163718.689479708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -877,7 +877,7 @@ static void fib_rebalance(struct fib_inf
 	change_nexthops(fi) {
 		int upper_bound;
 
-		if (nexthop_nh->fib_nh_flags & RTNH_F_DEAD) {
+		if (!total || nexthop_nh->fib_nh_flags & RTNH_F_DEAD) {
 			upper_bound = -1;
 		} else if (ip_ignore_linkdown(nexthop_nh->fib_nh_dev) &&
 			   nexthop_nh->fib_nh_flags & RTNH_F_LINKDOWN) {


