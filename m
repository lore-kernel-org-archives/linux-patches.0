Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BD646D08F;
	Tue, 21 Jul 2026 18:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657750; cv=none; b=VpypDCtoTGnnsyxOiW70/2xb7jke+AT3GbgT/HlDZoVwGvg9KSai+eqGYdbwhFktjbmmMcu9fWE2ctgIE4OohRMVihT+wvnZe8WKrXt2K+qG359H5Wni2IiN9/x9x/TmzmbbUY+zQST0Rcb25mo5iIf7BShfBfkWCKJQaHuFRrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657750; c=relaxed/simple;
	bh=EtNiugT1hYmTgosIPkUbuOpYRA55ixevrvO+Qkt5MZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJkwWLk9En9ADJ3gxopRG+iEV9Gss55uV4KrUyf3Czwn1RMJi0LhacmXH4AulOjb4x8MRpPBzGydWEcYA4Ig+93BMZomy7SxjWaHwU7fLFWTjuDj+QO92qD4NaePHEnO5hPpRhzWvXxuCcSGU8Bo7kB7HyIls4NqwXcKIAdBvzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PqeQH2dl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PqeQH2dl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16481F000E9;
	Tue, 21 Jul 2026 18:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657749;
	bh=qwvZ11JfpknFXLupJiKqT9xFogpyPCws1hwSri8/TyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PqeQH2dl8L1XCXDO4u2J6MyyKm7Wfe+YbemNR4Eck1Z3FNYyplJ01838pKfpQVqxH
	 f3IFHhBvH7BzVt+0KjLcuXsn491EWg5P50GMH061635q07EEaiT7HEAvnFr7V8cbj2
	 aGqO0sEjlrzI/RI8QjCeCdgVZtwZFKTXsiGM6xDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0841/1611] netfilter: nft_payload: reject offsets exceeding 65535 bytes
Date: Tue, 21 Jul 2026 17:15:57 +0200
Message-ID: <20260721152534.304080385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 213be32f46a29ca15a314df06c3424ecffd6c90a ]

Large offsets were rejected based on netlink policy, but blamed commit
removed the policy without updating nft_payload_inner_init() to use the
truncation-check helper.

Silent truncation is not a problem, but not wanted either, so add a
check.

Fixes: 077dc4a27579 ("netfilter: nft_payload: extend offset to 65535 bytes")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index b0214418f75acd..da1c6bf0dc572a 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -224,11 +224,17 @@ static int nft_payload_init(const struct nft_ctx *ctx,
 			    const struct nlattr * const tb[])
 {
 	struct nft_payload *priv = nft_expr_priv(expr);
+	u32 offset;
+	int err;
 
 	priv->base   = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
-	priv->offset = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
 	priv->len    = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
 
+	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U16_MAX, &offset);
+	if (err < 0)
+		return err;
+	priv->offset = offset;
+
 	return nft_parse_register_store(ctx, tb[NFTA_PAYLOAD_DREG],
 					&priv->dreg, NULL, NFT_DATA_VALUE,
 					priv->len);
@@ -648,7 +654,8 @@ static int nft_payload_inner_init(const struct nft_ctx *ctx,
 				  const struct nlattr * const tb[])
 {
 	struct nft_payload *priv = nft_expr_priv(expr);
-	u32 base;
+	u32 base, offset;
+	int err;
 
 	if (!tb[NFTA_PAYLOAD_BASE] || !tb[NFTA_PAYLOAD_OFFSET] ||
 	    !tb[NFTA_PAYLOAD_LEN] || !tb[NFTA_PAYLOAD_DREG])
@@ -666,8 +673,11 @@ static int nft_payload_inner_init(const struct nft_ctx *ctx,
 	}
 
 	priv->base   = base;
-	priv->offset = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
 	priv->len    = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
+	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U16_MAX, &offset);
+	if (err < 0)
+		return err;
+	priv->offset = offset;
 
 	return nft_parse_register_store(ctx, tb[NFTA_PAYLOAD_DREG],
 					&priv->dreg, NULL, NFT_DATA_VALUE,
-- 
2.53.0



