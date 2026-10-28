Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207719;
	b=SSW6rCOR9eEUNZvZm6AAe6rIB+IZTnRNKJByYDsX4QQ8RTznKNavW06dpFmKc51RtVAS
	 I++hCYZPuyFGaMyRmsl22JXdsWJrPAwj66bEKKSJxCqc7VpA8W4Qn4XKIcmmqIkq24Z/2
	 v5ApHDUCYYE4Q6Bgnb0u5yRWzLDK7YBrsUF+qtSgUqlRltevPQakfYGteeeWCWOvLV6LP
	 J5koFPc/+Jx4HzqKIsb5iYfWAZZ0bfqUOmRPxjWGhaUuCGhrEJh8S73aNBfxwcjGW7wLh
	 tCfh7fYk4/joe2NixYIGm5T9HaS7Qv0mnpvHeyxd8DTtlsBe/rcDBxZOGTuRn9IH1uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bsrFVUKAAfpf5A+IdRpct5FQ+eVVJal1ffQ8m4ZHuXc=;
	b=Mrg67QUU0sj+/cOqqBo7RhS6bFWDi14kTr/JGKa+fa4FQ6Q0y5xJwVp7H9xQco/hGSg0
	 ajoDolSO2iTzpy/xkdNzdeWmXykDbt/VldBGN84lMgO9yhoxnbLcSRQb0iF81/gghUcml
	 HJZPib6cg0/UEPtNFzcoxOMojtRaA5rSBPI4Ro7mZq7MTXncJXnVbXejWMBpc5DZQKZUx
	 an1S26pcQbGPY8hFsGhyJ/CysLuzg89HFnnY+/8oMn9/xBTmK2gW9SnC+ckP5YYi7WUI1
	 3UNSCQRviAHAimiE17ixNmoLYG98tkNnGl7uedeO6dCB/L3jrC6YzzVWcMpuSDVI8Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zIHTaFK8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFEC606A31A;
	Wed, 28 Oct 2026 17:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zIHTaFK8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6767D1F01828;
	Wed, 28 Oct 2026 17:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207719;
	bh=bsrFVUKAAfpf5A+IdRpct5FQ+eVVJal1ffQ8m4ZHuXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zIHTaFK822PwIcHuGqLM0A9l8a0u+/eSneitMPBAE9L1nWjrRH/AAU63bO7ZMiSIs
	 fIvsEWDjviaii3kmqFdlRTYPwERLbZlJ2gOJY/nhqeTSaUVMLGmYpCC2l808UvKNLC
	 z11TyLc/Bsxy965WQAJs0Sxo96VANkNT9b9ZgoO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 114/247] ipv4: avoid divide by zero in fib_rebalance
Date: Wed, 28 Oct 2026 17:58:37 +0100
Message-ID: <20261028165950.098236400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -856,7 +856,7 @@ static void fib_rebalance(struct fib_inf
 	change_nexthops(fi) {
 		int upper_bound;
 
-		if (nexthop_nh->fib_nh_flags & RTNH_F_DEAD) {
+		if (!total || nexthop_nh->fib_nh_flags & RTNH_F_DEAD) {
 			upper_bound = -1;
 		} else if (ip_ignore_linkdown(nexthop_nh->fib_nh_dev) &&
 			   nexthop_nh->fib_nh_flags & RTNH_F_LINKDOWN) {


