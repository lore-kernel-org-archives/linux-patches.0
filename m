Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B52A1DE8BF;
	Wed, 19 Feb 2025 08:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954412; cv=none; b=iAk9jrUsmeBJ4KJKusNpD1hn+wZ4Fr41UQuPudOOMvLt70CkSI6LL5dBoGKIBSJ/utahDNA2zUcTogoguPrexQ/fGmmvT4921o+fbRoaaO21IUsvxzayGKL7OEcS4tPgpKgoYaXFljEFr2aEIEMGU0BYPnr6Ao8K6ccuqTdWBDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954412; c=relaxed/simple;
	bh=mJFafRSy1FvxGRDTodSPBiEsxj7AmELcGFF75pWbvFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LF8x3DK+lekevyeF0QVXxB4hvNZ+RR0GyfC9IDWTj9iKRQihUfRIU2OIfnHo9cJaotlJ+G2A8HdEBRkhKQwE8M/O6rI+B+Y10QggkifVt82jEi6WIpIi8I/dYRsAmAjHOWjRUdzgkJRwOaNM03HRZZPTFL+MR62+c4OyPFGUZTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kny7QQ75; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kny7QQ75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804D6C4CED1;
	Wed, 19 Feb 2025 08:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954411;
	bh=mJFafRSy1FvxGRDTodSPBiEsxj7AmELcGFF75pWbvFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kny7QQ75JYNEZ1qDPj5Hkwo0ik0OyLb9gIqhSXSc9l1kHqFRa7jn7e8JPX8Tfsl0o
	 3ih5bEJlBuNVgIwa/ZowOvyLCr2WHUXByxePIwgmUtg+2fYcD0VaKwpHfVUrKdRUFk
	 vihaofUKv67r6K0HLrHnWMJZyhZuWOPqG+sMB7lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 196/274] net: ipv6: fix dst ref loops in rpl, seg6 and ioam6 lwtunnels
Date: Wed, 19 Feb 2025 09:27:30 +0100
Message-ID: <20250219082617.255620797@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 92191dd1073088753821b862b791dcc83e558e07 ]

Some lwtunnels have a dst cache for post-transformation dst.
If the packet destination did not change we may end up recording
a reference to the lwtunnel in its own cache, and the lwtunnel
state will never be freed.

Discovered by the ioam6.sh test, kmemleak was recently fixed
to catch per-cpu memory leaks. I'm not sure if rpl and seg6
can actually hit this, but in principle I don't see why not.

Fixes: 8cb3bf8bff3c ("ipv6: ioam: Add support for the ip6ip6 encapsulation")
Fixes: 6c8702c60b88 ("ipv6: sr: add support for SRH encapsulation and injection with lwtunnels")
Fixes: a7a29f9c361f ("net: ipv6: add rpl sr tunnel")
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250130031519.2716843-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ioam6_iptunnel.c | 9 ++++++---
 net/ipv6/rpl_iptunnel.c   | 9 ++++++---
 net/ipv6/seg6_iptunnel.c  | 9 ++++++---
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/ioam6_iptunnel.c b/net/ipv6/ioam6_iptunnel.c
index 28e5a89dc2557..7b6bd832930d1 100644
--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -411,9 +411,12 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 			goto drop;
 		}
 
-		local_bh_disable();
-		dst_cache_set_ip6(&ilwt->cache, cache_dst, &fl6.saddr);
-		local_bh_enable();
+		/* cache only if we don't create a dst reference loop */
+		if (dst->lwtstate != cache_dst->lwtstate) {
+			local_bh_disable();
+			dst_cache_set_ip6(&ilwt->cache, cache_dst, &fl6.saddr);
+			local_bh_enable();
+		}
 
 		err = skb_cow_head(skb, LL_RESERVED_SPACE(cache_dst->dev));
 		if (unlikely(err))
diff --git a/net/ipv6/rpl_iptunnel.c b/net/ipv6/rpl_iptunnel.c
index 7ba22d2f2bfef..be084089ec783 100644
--- a/net/ipv6/rpl_iptunnel.c
+++ b/net/ipv6/rpl_iptunnel.c
@@ -236,9 +236,12 @@ static int rpl_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 			goto drop;
 		}
 
-		local_bh_disable();
-		dst_cache_set_ip6(&rlwt->cache, dst, &fl6.saddr);
-		local_bh_enable();
+		/* cache only if we don't create a dst reference loop */
+		if (orig_dst->lwtstate != dst->lwtstate) {
+			local_bh_disable();
+			dst_cache_set_ip6(&rlwt->cache, dst, &fl6.saddr);
+			local_bh_enable();
+		}
 
 		err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
 		if (unlikely(err))
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 4bf937bfc2633..316dbc2694f2a 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -575,9 +575,12 @@ static int seg6_output_core(struct net *net, struct sock *sk,
 			goto drop;
 		}
 
-		local_bh_disable();
-		dst_cache_set_ip6(&slwt->cache, dst, &fl6.saddr);
-		local_bh_enable();
+		/* cache only if we don't create a dst reference loop */
+		if (orig_dst->lwtstate != dst->lwtstate) {
+			local_bh_disable();
+			dst_cache_set_ip6(&slwt->cache, dst, &fl6.saddr);
+			local_bh_enable();
+		}
 
 		err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
 		if (unlikely(err))
-- 
2.39.5



