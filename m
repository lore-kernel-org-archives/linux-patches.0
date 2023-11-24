Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66453418E;
	Fri, 24 Nov 2023 19:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hS65YbQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F00CC433C7;
	Fri, 24 Nov 2023 19:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853271;
	bh=AFXyNFWjTpy3ismWgGxlm9WXhV720KKUp178GlqEeGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hS65YbQ6iNoxDLUA+wLqDfh/55SLys3icJJe+iKCH6sghOxPvQjJ5y+yyTPDlhnOP
	 zbwt7xX4C3XHQkCWiTVXWH4yGgQLuPPKWFkT5zfZ2NIhekTXzJpTES0enGsykAvCW4
	 cW5Na7XSL5RplrDd9/+yd2N4qWRvQkMysqeuqnj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/297] netfilter: nf_tables: use the correct get/put helpers
Date: Fri, 24 Nov 2023 17:52:44 +0000
Message-ID: <20231124172004.565898785@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit d86473bf2ff39c05d4a6701c8aec66a16af0d410 ]

Switch to be16/32 and u16/32 respectively.  No code changes here,
the functions do the same thing, this is just for sparse checkers' sake.

objdiff shows no changes.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: c301f0981fdd ("netfilter: nf_tables: fix pointer math issue in nft_byteorder_eval()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_byteorder.c | 3 ++-
 net/netfilter/nft_osf.c       | 2 +-
 net/netfilter/nft_socket.c    | 8 ++++----
 net/netfilter/nft_xfrm.c      | 8 ++++----
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index 7b0b8fecb2205..d3e1467e576fb 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -44,7 +44,8 @@ void nft_byteorder_eval(const struct nft_expr *expr,
 		case NFT_BYTEORDER_NTOH:
 			for (i = 0; i < priv->len / 8; i++) {
 				src64 = nft_reg_load64(&src[i]);
-				nft_reg_store64(&dst[i], be64_to_cpu(src64));
+				nft_reg_store64(&dst[i],
+						be64_to_cpu((__force __be64)src64));
 			}
 			break;
 		case NFT_BYTEORDER_HTON:
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 720dc9fba6d4f..c9c124200a4db 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -99,7 +99,7 @@ static int nft_osf_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	if (nla_put_u8(skb, NFTA_OSF_TTL, priv->ttl))
 		goto nla_put_failure;
 
-	if (nla_put_be32(skb, NFTA_OSF_FLAGS, ntohl(priv->flags)))
+	if (nla_put_u32(skb, NFTA_OSF_FLAGS, ntohl((__force __be32)priv->flags)))
 		goto nla_put_failure;
 
 	if (nft_dump_register(skb, NFTA_OSF_DREG, priv->dreg))
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 9ad9cc0d1d27c..1725e7349f3d9 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -162,7 +162,7 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	priv->key = ntohl(nla_get_u32(tb[NFTA_SOCKET_KEY]));
+	priv->key = ntohl(nla_get_be32(tb[NFTA_SOCKET_KEY]));
 	switch(priv->key) {
 	case NFT_SOCKET_TRANSPARENT:
 	case NFT_SOCKET_WILDCARD:
@@ -178,7 +178,7 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 		if (!tb[NFTA_SOCKET_LEVEL])
 			return -EINVAL;
 
-		level = ntohl(nla_get_u32(tb[NFTA_SOCKET_LEVEL]));
+		level = ntohl(nla_get_be32(tb[NFTA_SOCKET_LEVEL]));
 		if (level > 255)
 			return -EOPNOTSUPP;
 
@@ -200,12 +200,12 @@ static int nft_socket_dump(struct sk_buff *skb,
 {
 	const struct nft_socket *priv = nft_expr_priv(expr);
 
-	if (nla_put_u32(skb, NFTA_SOCKET_KEY, htonl(priv->key)))
+	if (nla_put_be32(skb, NFTA_SOCKET_KEY, htonl(priv->key)))
 		return -1;
 	if (nft_dump_register(skb, NFTA_SOCKET_DREG, priv->dreg))
 		return -1;
 	if (priv->key == NFT_SOCKET_CGROUPV2 &&
-	    nla_put_u32(skb, NFTA_SOCKET_LEVEL, htonl(priv->level)))
+	    nla_put_be32(skb, NFTA_SOCKET_LEVEL, htonl(priv->level)))
 		return -1;
 	return 0;
 }
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index cbbbc4ecad3ae..3553f89fd057f 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -50,7 +50,7 @@ static int nft_xfrm_get_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	priv->key = ntohl(nla_get_u32(tb[NFTA_XFRM_KEY]));
+	priv->key = ntohl(nla_get_be32(tb[NFTA_XFRM_KEY]));
 	switch (priv->key) {
 	case NFT_XFRM_KEY_REQID:
 	case NFT_XFRM_KEY_SPI:
@@ -132,13 +132,13 @@ static void nft_xfrm_state_get_key(const struct nft_xfrm *priv,
 		WARN_ON_ONCE(1);
 		break;
 	case NFT_XFRM_KEY_DADDR_IP4:
-		*dest = state->id.daddr.a4;
+		*dest = (__force __u32)state->id.daddr.a4;
 		return;
 	case NFT_XFRM_KEY_DADDR_IP6:
 		memcpy(dest, &state->id.daddr.in6, sizeof(struct in6_addr));
 		return;
 	case NFT_XFRM_KEY_SADDR_IP4:
-		*dest = state->props.saddr.a4;
+		*dest = (__force __u32)state->props.saddr.a4;
 		return;
 	case NFT_XFRM_KEY_SADDR_IP6:
 		memcpy(dest, &state->props.saddr.in6, sizeof(struct in6_addr));
@@ -147,7 +147,7 @@ static void nft_xfrm_state_get_key(const struct nft_xfrm *priv,
 		*dest = state->props.reqid;
 		return;
 	case NFT_XFRM_KEY_SPI:
-		*dest = state->id.spi;
+		*dest = (__force __u32)state->id.spi;
 		return;
 	}
 
-- 
2.42.0



