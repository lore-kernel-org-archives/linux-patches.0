Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E76A267B9C;
	Tue,  8 Apr 2025 12:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113783; cv=none; b=aM046QAencP3vuC+wH3lkkA8RR3BTSSn0/kJqRoKbV/oBFjBe1BLXp9C3w+fUYCnkB/ZULDq+JIZXykfwcjmYKfqrAQzlGyNXVpkRTg1BsjvxZa4u++HPfs+MTwJ35Uva20nbG5g+OhlIBfRpJ1sEE+tXUQqiklvxrdBv6ckhqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113783; c=relaxed/simple;
	bh=BOLTJjWAjdZAc9KOsMu/u/r3LR5MoeO1bi8R021/ABk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0VkFDpIHr7znxOpjOI6UI+341Epzu74wQGrgFlDOHUGp12frBL8DC434RSAcXn/4swRpfjjh0QJGfXcdObrgTG/fLguN0TBTRjorukvammuFRT+zKy1aIaBMGikwPmAFwPGWey3548SsL+lO/SZEvXgKFvsGquGM93Xa33KsQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPiE/jXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPiE/jXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA45BC4CEE5;
	Tue,  8 Apr 2025 12:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113783;
	bh=BOLTJjWAjdZAc9KOsMu/u/r3LR5MoeO1bi8R021/ABk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPiE/jXFsL2K+LtFx8VamiGz4gQljNgFO0ejHBgBa1xs2MZlPL86YRoAJDi7FsJ3v
	 9ZfM8oQMeTTNXBKC+P8Ync1wI0qDtTLOvtjVP+jp0by0TQoGJO28b7Eu4uYCufeBLI
	 A1Ngz1FXF7Xzj2iqcLUL79StgcSj0d5UkNXGr8hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kashavkin <akashavkin@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/154] netfilter: nft_exthdr: fix offset with ipv4_find_option()
Date: Tue,  8 Apr 2025 12:49:20 +0200
Message-ID: <20250408104815.896841353@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ca268293cfa12..de43abf6d1191 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -83,7 +83,6 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 	unsigned char optbuf[sizeof(struct ip_options) + 40];
 	struct ip_options *opt = (struct ip_options *)optbuf;
 	struct iphdr *iph, _iph;
-	unsigned int start;
 	bool found = false;
 	__be32 info;
 	int optlen;
@@ -91,7 +90,6 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 	iph = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
 	if (!iph)
 		return -EBADMSG;
-	start = sizeof(struct iphdr);
 
 	optlen = iph->ihl * 4 - (int)sizeof(struct iphdr);
 	if (optlen <= 0)
@@ -101,7 +99,7 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 	/* Copy the options since __ip_options_compile() modifies
 	 * the options.
 	 */
-	if (skb_copy_bits(skb, start, opt->__data, optlen))
+	if (skb_copy_bits(skb, sizeof(struct iphdr), opt->__data, optlen))
 		return -EBADMSG;
 	opt->optlen = optlen;
 
@@ -116,18 +114,18 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
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



