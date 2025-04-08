Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309AF219301;
	Tue,  8 Apr 2025 11:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112294; cv=none; b=USJpWSH5unAvPfewge75BwZrm2PZwMXI08oDyzPpS4ghSWZ+MzHXxgJ//UEKXgAfiIrNALa2OhlMVgEtGLto47LITB/P6s9Gt/y6Bw0AeNctB5grSpYG1Zpb0iY+btE63sq93OPZULOlTvQFmzcblMaE7M1CbUbZMp5RQkvN7W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112294; c=relaxed/simple;
	bh=VxTiyk6YH1aUhQDxWlG4tSC1kDH9IaPdpklZf3b/MyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fy07LLWDoMSDUTo1S7CcRVTJYAZ0jXws5HLoErgm1L5vvF0FMibgEGl7lpT0XamSfqiQCLZn1wyYAx/rVlZfHecpAMKPzhR3jdLFjrvXdNa3cHf8J0NXQ7NytRPgUQ5t1njrcaVILYUY5Tpvdd8IbSojPrd50oDfcmXcVT0qyoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlbOP1PP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlbOP1PP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A68C4CEE5;
	Tue,  8 Apr 2025 11:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112294;
	bh=VxTiyk6YH1aUhQDxWlG4tSC1kDH9IaPdpklZf3b/MyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlbOP1PPmR0IPUO4dyMD4R0DE2X4T3aEl3Qo59omMZD8fgXZOyCiytr94ureAYZRD
	 AcIqjWpHYj9R40kkEHdnK+EB0O+HyoynJK1QVSWnnAWoS7smtqs/gj3YFQSVtZQeSa
	 QreTCF56HHZEUP+mhuiWuz7ADQNcVGlWADm4BPfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kashavkin <akashavkin@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/279] netfilter: nft_exthdr: fix offset with ipv4_find_option()
Date: Tue,  8 Apr 2025 12:46:39 +0200
Message-ID: <20250408104826.819515614@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d1dcf5b2e92e1..7c2931e024bb0 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -85,7 +85,6 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 	unsigned char optbuf[sizeof(struct ip_options) + 40];
 	struct ip_options *opt = (struct ip_options *)optbuf;
 	struct iphdr *iph, _iph;
-	unsigned int start;
 	bool found = false;
 	__be32 info;
 	int optlen;
@@ -93,7 +92,6 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 	iph = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
 	if (!iph)
 		return -EBADMSG;
-	start = sizeof(struct iphdr);
 
 	optlen = iph->ihl * 4 - (int)sizeof(struct iphdr);
 	if (optlen <= 0)
@@ -103,7 +101,7 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 	/* Copy the options since __ip_options_compile() modifies
 	 * the options.
 	 */
-	if (skb_copy_bits(skb, start, opt->__data, optlen))
+	if (skb_copy_bits(skb, sizeof(struct iphdr), opt->__data, optlen))
 		return -EBADMSG;
 	opt->optlen = optlen;
 
@@ -118,18 +116,18 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
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



