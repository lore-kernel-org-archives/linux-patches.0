Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BA024FBFF;
	Mon, 23 Jun 2025 13:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685739; cv=none; b=G+rthca5zv+Cc9EJ9UwvcwP8wGOXsd/SP+z279suxsBww+r1J3suWlWyJjCgNFBhxhEdrAqkKN9fcb65vSzbX28GpKI4iDNS7BNs2lwJB1dVG1Qp8yOaWBnNR1BVq4JlUKDh/geACIJSOjrER4YJ83ML7LPGQJnAFgcCy9HkFl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685739; c=relaxed/simple;
	bh=5JPIv6tSroJhsU0ovUNj6wpG1cWS6F0wL5KAGVyinXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poJWuZ3KY/aCwHsAD3oZWKV8NO+PpRnlqtJphcORzm7WUBfch9YctCCiUAMu9eet/098zek7i5NEqNiDXLGKY1+zdfymieOIe2dn9fq2efaByJ7rxVT0iYWtZk9N4+e4HfeCLg0EXWfuc8y6VXLR9xtq6clGmR2HNKI0a2TYQ9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEPdPSKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEPdPSKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F4FC4CEEA;
	Mon, 23 Jun 2025 13:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685739;
	bh=5JPIv6tSroJhsU0ovUNj6wpG1cWS6F0wL5KAGVyinXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEPdPSKi4ySKrq1PsYBCh60ftQOMo05k+edq2T/HT0lLKtLD/kpWfwVVAiw1Pew1O
	 53/vnVRv9jVSdP8xm+fnYlSzL7KQ+rblZ6+Ns8iRfmK50jX+D+8A/2xdd0zApFgzN3
	 xLv81wdBxIsMlMe0Y8W0IVgCBTpQMAStn4w/1ADA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/411] netfilter: nft_tunnel: fix geneve_opt dump
Date: Mon, 23 Jun 2025 15:03:30 +0200
Message-ID: <20250623130634.982094167@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 22a9613de4c29d7d0770bfb8a5a9d73eb8df7dad ]

When dumping a nft_tunnel with more than one geneve_opt configured the
netlink attribute hierarchy should be as follow:

 NFTA_TUNNEL_KEY_OPTS
 |
 |--NFTA_TUNNEL_KEY_OPTS_GENEVE
 |  |
 |  |--NFTA_TUNNEL_KEY_GENEVE_CLASS
 |  |--NFTA_TUNNEL_KEY_GENEVE_TYPE
 |  |--NFTA_TUNNEL_KEY_GENEVE_DATA
 |
 |--NFTA_TUNNEL_KEY_OPTS_GENEVE
 |  |
 |  |--NFTA_TUNNEL_KEY_GENEVE_CLASS
 |  |--NFTA_TUNNEL_KEY_GENEVE_TYPE
 |  |--NFTA_TUNNEL_KEY_GENEVE_DATA
 |
 |--NFTA_TUNNEL_KEY_OPTS_GENEVE
 ...

Otherwise, userspace tools won't be able to fetch the geneve options
configured correctly.

Fixes: 925d844696d9 ("netfilter: nft_tunnel: add support for geneve opts")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_tunnel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index cfe6cf1be4217..95f8230322289 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -588,10 +588,10 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 		struct geneve_opt *opt;
 		int offset = 0;
 
-		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_GENEVE);
-		if (!inner)
-			goto failure;
 		while (opts->len > offset) {
+			inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_GENEVE);
+			if (!inner)
+				goto failure;
 			opt = (struct geneve_opt *)(opts->u.data + offset);
 			if (nla_put_be16(skb, NFTA_TUNNEL_KEY_GENEVE_CLASS,
 					 opt->opt_class) ||
@@ -601,8 +601,8 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 				    opt->length * 4, opt->opt_data))
 				goto inner_failure;
 			offset += sizeof(*opt) + opt->length * 4;
+			nla_nest_end(skb, inner);
 		}
-		nla_nest_end(skb, inner);
 	}
 	nla_nest_end(skb, nest);
 	return 0;
-- 
2.39.5



