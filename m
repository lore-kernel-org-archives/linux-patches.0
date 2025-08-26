Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ECA2192F2;
	Tue, 26 Aug 2025 14:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218442; cv=none; b=nuI4tOzxASmLhNLuPSCMJxYJ5WeY3ewLsI2fSypRDxreyUjTKj8ZlAuRjF2Saywh13MB9RmD2KYHbRPc+z/G290KdqBQmTg4tHxdhTjOulV7gEpDsZaiJn08RuQ/i+MMcycagcDMuJd+zIEvdegrQfYEcbp5ZQTELYZ2CyfdL64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218442; c=relaxed/simple;
	bh=nCRFBH3vu1h2sIn+8ofInNmtnhrItilCaMiJ9lIE92I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgVx2tBb1g3VZyy8NEsbNeGyoNThUw1VLeKrPXIlcbo/FuU8dNuHcCoCCDV3AdowvDmcoZCOc4Q4HoKvrSluSLcVO5B6QFYIrscn8M12sY36KkERl6UIysFhkHko/zTWyZCe+uMlGsQKNCQzzU7wAZPE8ZGJ2e9CSAyh7a1G6Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0YSskjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0YSskjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F1DC4CEF1;
	Tue, 26 Aug 2025 14:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218442;
	bh=nCRFBH3vu1h2sIn+8ofInNmtnhrItilCaMiJ9lIE92I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0YSskjnTYziRMBV/hdcGyoa2HQrVwplv0ImksQ4zlJVHUZ8p0oiMwb+ny1nSAx7k
	 XFoykGm6Hf7w/0VnnRWVry71n8mLloqOIGa9rZHyRAOQ9KTq6cJW8v88zWRXLd//1V
	 A/GI6R52Bqk7zPihd0Ytq9jR1nGr0stoKh8IrFeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 523/523] netfilter: nf_reject: dont leak dst refcount for loopback packets
Date: Tue, 26 Aug 2025 13:12:13 +0200
Message-ID: <20250826110937.339124694@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 91a79b792204313153e1bdbbe5acbfc28903b3a5 ]

recent patches to add a WARN() when replacing skb dst entry found an
old bug:

WARNING: include/linux/skbuff.h:1165 skb_dst_check_unset include/linux/skbuff.h:1164 [inline]
WARNING: include/linux/skbuff.h:1165 skb_dst_set include/linux/skbuff.h:1210 [inline]
WARNING: include/linux/skbuff.h:1165 nf_reject_fill_skb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject_ipv4.c:234
[..]
Call Trace:
 nf_send_unreach+0x17b/0x6e0 net/ipv4/netfilter/nf_reject_ipv4.c:325
 nft_reject_inet_eval+0x4bc/0x690 net/netfilter/nft_reject_inet.c:27
 expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
 ..

This is because blamed commit forgot about loopback packets.
Such packets already have a dst_entry attached, even at PRE_ROUTING stage.

Instead of checking hook just check if the skb already has a route
attached to it.

Fixes: f53b9b0bdc59 ("netfilter: introduce support for reject at prerouting stage")
Signed-off-by: Florian Westphal <fw@strlen.de>
Link: https://patch.msgid.link/20250820123707.10671-1-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 6 ++----
 net/ipv6/netfilter/nf_reject_ipv6.c | 5 ++---
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index d232e0251142..e89a4cbd9f5d 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -125,8 +125,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	if (!oth)
 		return;
 
-	if ((hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) &&
-	    nf_reject_fill_skb_dst(oldskb) < 0)
+	if (!skb_dst(oldskb) && nf_reject_fill_skb_dst(oldskb) < 0)
 		return;
 
 	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
@@ -194,8 +193,7 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (iph->frag_off & htons(IP_OFFSET))
 		return;
 
-	if ((hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) &&
-	    nf_reject_fill_skb_dst(skb_in) < 0)
+	if (!skb_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
 		return;
 
 	if (skb_csum_unnecessary(skb_in) || !nf_reject_verify_csum(proto)) {
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index b396559f68b4..5384b73e318e 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -161,7 +161,7 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	fl6.fl6_sport = otcph->dest;
 	fl6.fl6_dport = otcph->source;
 
-	if (hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) {
+	if (!skb_dst(oldskb)) {
 		nf_ip6_route(net, &dst, flowi6_to_flowi(&fl6), false);
 		if (!dst)
 			return;
@@ -259,8 +259,7 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
-	if ((hooknum == NF_INET_PRE_ROUTING || hooknum == NF_INET_INGRESS) &&
-	    nf_reject6_fill_skb_dst(skb_in) < 0)
+	if (!skb_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
 		return;
 
 	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0);
-- 
2.50.1



