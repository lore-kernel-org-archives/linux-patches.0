Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30A3405C3F;
	Wed, 30 Sep 2026 19:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797076; cv=none; b=f5fxnPhCrAKfEr4zMXL1RQxvSz8lY9Baekpkh52iCJFcPFWhiWvHSy6N70XZWgIBBeMYcD+XAD5/CuH0eYy1I4nJqkkVlAY0cutZUGXnkVHHWuUzxdqj/K/XArTud0ziKjTKXM867h4tR4CNJODVByW3Q2yyef6kXgJ6Op5a8Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797076; c=relaxed/simple;
	bh=1CckU+HC525OyFUP+/3vn1Ri8XEeH4gZ17odct/MS2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgK7YpfNh5SS+enyD5GbNuV4oGLi9dd7LfzRChfRjcs+9JOyhphEoDx6aYshvNEF3eLi8jiF5y0lt9W0H1JviJtv96kUxvVWfUV96/YLm5T/SjIG+YUU1bjlvYEowApEM9Ic+Py77Pcx51cpiLIqG8d9+A9LlflR/oZ+7eMdylE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=miHauP8u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="miHauP8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C844A1F000FF;
	Wed, 30 Sep 2026 19:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797074;
	bh=k+aYWGzu3VlojexkoM9IdE+elT1lgPz+QG3d4bAxeeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=miHauP8utRhcUQThPCHxz1t/lZfqC/DWXmSbgbf0tHraBMzq2LYSZ2Ka9bnxKI1OS
	 ukpbGjwRjH54r5rqZzzOgahgpwfZUsReXaBMX3INpcjV/HZoNvvwmxCBCNdlZtOlGZ
	 LzDF5fDqLppZUfSm7x4jrAoRRYZEl5ewa4t3wuso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Florian Westphal <fw@strlen.de>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 1136/1193] netfilter: ip6t_rt: fix zero-address non-strict match out-of-bounds read
Date: Wed, 30 Sep 2026 17:30:20 +0200
Message-ID: <20260930152459.477371681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


