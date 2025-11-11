Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694D634028B;
	Tue, 11 Nov 2025 01:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823447; cv=none; b=ULhDCi8xwBhWE/K6Mjk123r6U1OFBAA1iWGRQ5Sow8dzOGkOH+L5mJqMMVmfdHbGOG1Nyt8UdPdYvooLSGEtFaj1sW5TtWqsgjZ/QZCjvVZJjR5lyZVtKppZSNQ+Vci+wkJ6WNHl1S5/+GcYeq3SALqVQUteTSBnyqBTfoHnbF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823447; c=relaxed/simple;
	bh=Kl616C37ioixlh5x3q+ofkfXt+AAZUiSEUH9Kp4NiLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQEhRwcjTN/Ip8nKXH/uikjUJVXG5ro+K1mwoh105LJ5DJvaBSNc4FzETvEqBY4AKmtOyMNRg6LFhe0B+Tf7aqiLuKXCaji94mOSTppqRx3oNyi5e8EzULHrJdpx22dqkUjpikmytUTaB7x3w47TccrMp0H56ulsH9l2dneeWD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhcC6J4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhcC6J4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DD3C2BC9E;
	Tue, 11 Nov 2025 01:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823447;
	bh=Kl616C37ioixlh5x3q+ofkfXt+AAZUiSEUH9Kp4NiLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhcC6J4GMp8zsxYkduj5472NHAwnmZ8JLols2EnAYi5sr1eaax3f2GpNYceD3SKKt
	 6sns/ilSWHsDQpmsIcd4minHeIfh5hof1Ki5XZO0N/FDLf6ASkKm9uiCp2U9CmLk04
	 eNdORi/pOQjTI2Q1ft0Snv7WIGbr1GMg8c3OvsVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Maes <oscmaes92@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 248/565] net: ipv4: allow directed broadcast routes to use dst hint
Date: Tue, 11 Nov 2025 09:41:44 +0900
Message-ID: <20251111004532.488383835@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oscar Maes <oscmaes92@gmail.com>

[ Upstream commit 1b8c5fa0cb35efd08f07f700e6d78a541ebabe26 ]

Currently, ip_extract_route_hint uses RTN_BROADCAST to decide
whether to use the route dst hint mechanism.

This check is too strict, as it prevents directed broadcast
routes from using the hint, resulting in poor performance
during bursts of directed broadcast traffic.

Fix this in ip_extract_route_hint and modify ip_route_use_hint
to preserve the intended behaviour.

Signed-off-by: Oscar Maes <oscmaes92@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250819174642.5148-2-oscmaes92@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_input.c | 11 +++++++----
 net/ipv4/route.c    |  2 +-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index b6e7d49213097..7b092ba6f5779 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -582,9 +582,13 @@ static void ip_sublist_rcv_finish(struct list_head *head)
 }
 
 static struct sk_buff *ip_extract_route_hint(const struct net *net,
-					     struct sk_buff *skb, int rt_type)
+					     struct sk_buff *skb)
 {
-	if (fib4_has_custom_rules(net) || rt_type == RTN_BROADCAST ||
+	const struct iphdr *iph = ip_hdr(skb);
+
+	if (fib4_has_custom_rules(net) ||
+	    ipv4_is_lbcast(iph->daddr) ||
+	    ipv4_is_zeronet(iph->daddr) ||
 	    IPCB(skb)->flags & IPSKB_MULTIPATH)
 		return NULL;
 
@@ -614,8 +618,7 @@ static void ip_list_rcv_finish(struct net *net, struct sock *sk,
 
 		dst = skb_dst(skb);
 		if (curr_dst != dst) {
-			hint = ip_extract_route_hint(net, skb,
-						     dst_rtable(dst)->rt_type);
+			hint = ip_extract_route_hint(net, skb);
 
 			/* dispatch old sublist */
 			if (!list_empty(&sublist))
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 7d04df4fc6608..96a01eb33653f 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2187,7 +2187,7 @@ int ip_route_use_hint(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	if (ipv4_is_loopback(saddr) && !IN_DEV_NET_ROUTE_LOCALNET(in_dev, net))
 		goto martian_source;
 
-	if (rt->rt_type != RTN_LOCAL)
+	if (!(rt->rt_flags & RTCF_LOCAL))
 		goto skip_validate_source;
 
 	tos &= INET_DSCP_MASK;
-- 
2.51.0



