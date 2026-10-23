Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774274;
	b=vPkh0Ma0FW6+QokwgjRvBZZgcM3uOBZtRMAEe8skaQvuLH9eZfqps05lsIApPc8MnRvO
	 S+/KRPsqM8Ro7TUQowfMerUGbIA+0gsM5ZveGzxyHs49BhaUWqEBKF+GXbbad31nAfva3
	 gWPTEpZ6+cWHDEUP65k/365+wTnnAI4g1Bb7+ezc71BKHvvJx6vtiG1oOaq0kkyc9X5WV
	 ZqFFbuCmuq4cp1oMh4WBumm8TNkdjWQnhsAvcJJGNKozExfHhhadU8PE+gMnlJh4F6s1D
	 cxmGMYgxj1FNcUTocpTsWwIKU6L3Rk8xjzQ/3RBwsDBfQttS/KVl9ddLKTVPEzWti5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h6Kj73X5+o7AYjOsr5NiUZPF/hM5I/W6W4D0TR7QUcE=;
	b=1uGlNcqLYYOEe/66OLNsfx9exDWIevZpLBXpnZPDIfrsUT0PD6c1gYdPR33maReEeinG
	 b3X8nBW3FHsCdU8afex63mB4sJD5Fe1+tgQjStHQTyXmG3opeKt9X4MK096tThmxtyD2l
	 ddAvUnHYk1Dr8eW0vqxoPo5hIY3y2VlvqvzUExXQRLLaJh60O9S3AbrNbNAF+th+cBMpR
	 PBtBaHnVZAAImBG+TXDdw+sP1/IUaCRVVJ6c32Qv2IclnZjBdRP8Ew0JkkSIkPL0BBht7
	 otDTfgdNQjgu6qMfyXZiYsUQwOuVVTJDpcsLeBNZuwe0N73U1WSp8xJSUoczoILPlyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Cq/wo0WV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE67D606A31B;
	Fri, 23 Oct 2026 16:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cq/wo0WV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D9C1F01825;
	Fri, 23 Oct 2026 16:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774273;
	bh=h6Kj73X5+o7AYjOsr5NiUZPF/hM5I/W6W4D0TR7QUcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cq/wo0WVUXouqqjfReESMEE61R+QnVsShk8V1bh4wFpsSb5x63+7+X5bCRdxPhTvL
	 ROW22gF1naSVm+ga2xDj1ZgZ6Vl760fhfFEmjzh5KNNx6Aq2B3IP71PpgGZ6jXt+xR
	 0uGbDK/smL82ns7om0i8ef4gPLCanZCQWqGi4O1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 141/193] ipv4: avoid divide by zero in fib_rebalance
Date: Fri, 23 Oct 2026 18:36:58 +0200
Message-ID: <20261023163717.541854402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
@@ -881,7 +881,7 @@ static void fib_rebalance(struct fib_inf
 	change_nexthops(fi) {
 		int upper_bound;
 
-		if (nexthop_nh->fib_nh_flags & RTNH_F_DEAD) {
+		if (!total || nexthop_nh->fib_nh_flags & RTNH_F_DEAD) {
 			upper_bound = -1;
 		} else if (ip_ignore_linkdown(nexthop_nh->fib_nh_dev) &&
 			   nexthop_nh->fib_nh_flags & RTNH_F_LINKDOWN) {


