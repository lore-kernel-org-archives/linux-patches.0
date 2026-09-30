Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91ED6518137;
	Wed, 30 Sep 2026 17:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787911; cv=none; b=byrtDH0JXVpKg4qKpY4K4wUiyTQ/LhczaselAP4idZY76aQ9WK6CrSkCT4U+FmRCOQj+CJElyrTiwprBTxRO7b51qSgqS1d//CO6BnvbPs1xV2ZdCGU8FP4wg4iCnXTangyH2G6Bkx6QmoV9gQdDhwRaHojsiZv4aetYlVj+zTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787911; c=relaxed/simple;
	bh=+YtQNSWXvjocaoGwc6r7Jn9TiFiiZWufJc16XZikGGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ie/u8LKvjWB+mjDfqoUPZVgimSb7608m3npvzBQSRP8HyYTKgG200tIHt/3uFKdYibpw5DNF9Xs1PMeXhxeLjJoG+u1XWuJxxXOKyOFb09GHUZ7cXomY4Q+KS5uPbSGwaKb3jNs5jd0T0ROemyBkaHVn1bEMqUSWqBgGgpFV0Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBJ2YWJM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBJ2YWJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6631F000FF;
	Wed, 30 Sep 2026 17:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787910;
	bh=EHHMV3YHiSxGe+eNLcX+Y3qUp8p6cTfopUekisTLa/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aBJ2YWJMOwAq7L/cAsH2MDnMqCcMLYIbXt6UrMTp8CxNabfLm6cYdubXwlDQgretv
	 /cdl450c4Cf2tDigbDISsaZ2vFzyiLRlJl81ZZE00Fw02zQDt1TQ+/+zMKZ/btBJeD
	 4e3nXPUOnCJEbju/j+83Q5vcD2OxUkyhS3hwOOLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Florian Westphal <fw@strlen.de>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.2 351/457] netfilter: ip6t_rt: fix zero-address non-strict match out-of-bounds read
Date: Wed, 30 Sep 2026 17:27:36 +0200
Message-ID: <20260930152353.587203360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luxiao Xu <rakukuip@gmail.com>

commit 82313c169eddc02b1bf5ba6b427803e272d3ec42 upstream.

rt_mt6_check() permits rules to be configured with rtinfo->addrnr == 0
even when address matching (IP6T_RT_FST_MASK) is requested.

In the IP6T_RT_FST_NSTRICT path, rt_mt6() evaluates packet routing
addresses against rtinfo->addrs[i] and terminates backwards at the bottom
of the loop:

    if (ipv6_addr_equal(ap, &rtinfo->addrs[i])) {
        i++;
    }
    if (i == rtinfo->addrnr)
        break;

When addrnr is 0, if the first packet address matches rtinfo->addrs[0],
i is incremented to 1. Because i is now strictly greater than addrnr (0),
the loop termination condition (i == rtinfo->addrnr) is bypassed and will
never be satisfied.

If a crafted IPv6 packet contains matching routing addresses, i will
advance past IP6T_RT_HOPS (16). The subsequent call to ipv6_addr_equal()
reads beyond struct ip6t_rt, triggering UBSAN/KASAN out-of-bounds warnings
or kernel panics.

Fix this by:
1. Rejecting rules in rt_mt6_check() where IP6T_RT_FST_MASK is set but
   rtinfo->addrnr is zero.
2. In rt_mt6(), moving the termination condition (i < rtinfo->addrnr)
   into the for-loop header condition and removing the backwards break
   at the end of the loop body.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: Florian Westphal <fw@strlen.de>
Assisted-by: LLM
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/netfilter/ip6t_rt.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -96,7 +96,8 @@ static bool rt_mt6(const struct sk_buff
 			unsigned int i = 0;
 
 			for (temp = 0;
-			     temp < (unsigned int)((hdrlen - 8) / 16);
+			     temp < (unsigned int)((hdrlen - 8) / 16) &&
+			     i < rtinfo->addrnr;
 			     temp++) {
 				ap = skb_header_pointer(skb,
 							ptr
@@ -112,8 +113,6 @@ static bool rt_mt6(const struct sk_buff
 
 				if (ipv6_addr_equal(ap, &rtinfo->addrs[i]))
 					i++;
-				if (i == rtinfo->addrnr)
-					break;
 			}
 			if (i == rtinfo->addrnr)
 				return ret;
@@ -162,6 +161,12 @@ static int rt_mt6_check(const struct xt_
 		pr_debug("too many addresses specified\n");
 		return -EINVAL;
 	}
+
+	if ((rtinfo->flags & IP6T_RT_FST_MASK) && !rtinfo->addrnr) {
+		pr_info_ratelimited("address list match requested but addrnr is 0\n");
+		return -EINVAL;
+	}
+
 	if ((rtinfo->flags & (IP6T_RT_RES | IP6T_RT_FST_MASK)) &&
 	    (!(rtinfo->flags & IP6T_RT_TYP) ||
 	     (rtinfo->rt_type != 0) ||


