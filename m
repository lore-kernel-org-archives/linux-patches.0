Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C26D257AC7;
	Tue, 25 Mar 2025 12:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905534; cv=none; b=NlCMQVtf5w3oILSd+NPYbsn9tAHCTEGNJTvGnGyqJiTuT7/WHSU+sbXwldPXE18tvgNkBISWn52fZ8ObDcasrF9d0n1UQlo6+muEpjaLF4WXPYHTuTaTP6Fj9yO4SDpRrMUa3XU3sTqJH4Sn8ZSTyZFnje9mXTKZPrWw16GCfSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905534; c=relaxed/simple;
	bh=zUPigEdejwLhzN73JHQNntlRUecSI1KZvPk48N55m3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1rZxGmWHxaBqyoX6M5SiFc9xgiY1rSr0lYjkaOgr+9i/xmAgXmbjPHapBJDye1eIJjuRtpgZ71BCdGMGtX2BKCOxJTRtmJakdiq7R3SVwyh9LTxOQSGadwICIWZna5neC2yg9xvz+7Aa6WI35L4ULRDKnKkFGZXIDfy0gi1MdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwum0LDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwum0LDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27DCC4CEE9;
	Tue, 25 Mar 2025 12:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905533;
	bh=zUPigEdejwLhzN73JHQNntlRUecSI1KZvPk48N55m3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwum0LDZk2tkmW4PRYvdjD8mg7Y6fPRqBromplyaiTZc0EyVP0E/itiq7Vf0tXMJ3
	 ddZ0VvrDST3bEaDLclaSANcedQEhtjfxis0A2EZdzSNAB/NKsLGbN6aXmxN4vjrmbx
	 83c2KBChJx4WdYTveg1ACunWqh/lp1P94l2vF+Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kashavkin <akashavkin@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/198] netfilter: nft_exthdr: fix offset with ipv4_find_option()
Date: Tue, 25 Mar 2025 08:19:48 -0400
Message-ID: <20250325122157.326614735@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Kashavkin <akashavkin@gmail.com>

[ Upstream commit 6edd78af9506bb182518da7f6feebd75655d9a0e ]

There is an incorrect calculation in the offset variable which causes
the nft_skb_copy_to_reg() function to always return -EFAULT. Adding the
start variable is redundant. In the __ip_options_compile() function the
correct offset is specified when finding the function. There is no need
to add the size of the iphdr structure to the offset.

Fixes: dbb5281a1f84 ("netfilter: nf_tables: add support for matching IPv4 options")
Signed-off-by: Alexey Kashavkin <akashavkin@gmail.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_exthdr.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index de588f7b69c45..60d18bd60d821 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -86,7 +86,6 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 	unsigned char optbuf[sizeof(struct ip_options) + 40];
 	struct ip_options *opt = (struct ip_options *)optbuf;
 	struct iphdr *iph, _iph;
-	unsigned int start;
 	bool found = false;
 	__be32 info;
 	int optlen;
@@ -94,7 +93,6 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 	iph = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
 	if (!iph)
 		return -EBADMSG;
-	start = sizeof(struct iphdr);
 
 	optlen = iph->ihl * 4 - (int)sizeof(struct iphdr);
 	if (optlen <= 0)
@@ -104,7 +102,7 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 	/* Copy the options since __ip_options_compile() modifies
 	 * the options.
 	 */
-	if (skb_copy_bits(skb, start, opt->__data, optlen))
+	if (skb_copy_bits(skb, sizeof(struct iphdr), opt->__data, optlen))
 		return -EBADMSG;
 	opt->optlen = optlen;
 
@@ -119,18 +117,18 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 		found = target == IPOPT_SSRR ? opt->is_strictroute :
 					       !opt->is_strictroute;
 		if (found)
-			*offset = opt->srr + start;
+			*offset = opt->srr;
 		break;
 	case IPOPT_RR:
 		if (!opt->rr)
 			break;
-		*offset = opt->rr + start;
+		*offset = opt->rr;
 		found = true;
 		break;
 	case IPOPT_RA:
 		if (!opt->router_alert)
 			break;
-		*offset = opt->router_alert + start;
+		*offset = opt->router_alert;
 		found = true;
 		break;
 	default:
-- 
2.39.5



