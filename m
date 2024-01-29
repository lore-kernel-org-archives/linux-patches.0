Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7D016089C;
	Mon, 29 Jan 2024 17:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548344; cv=none; b=ZVSeLNpN6GgY9H4VrrlQ/GJAigpxM8UmA+cy/QUwF5kSEtM4qkTvQS9xv0M+IwW9M8Si1huaR95oCOOTIV6R+qW5HfgPIhb3zdmfMd4ElsbKu/vZtVHpyqVNHcgB8ZJ/FWM1w9w024/nwW+rlox7aQwF8JuEmS6Y0PwYK29uRd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548344; c=relaxed/simple;
	bh=4oCgjzZy9sEn+1Tkb8uAQfA2mYuesOQHlDtrwa17wYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WW/hWKH/dQAL5q3IJ/WPb7ohu6rlM2+KgOUXGK1xiuXiEHcHqWWpiJh+X3A+J7/kfH1cPpjQZGOOBjh+EOWHDCRdI20t85K5FZhctGLaaXZkJZnZD8YkQrmNcCoc16+Gtc8C5LBnuDZyXbcY73ATPuSE53KpUv2pCQef1zs7600=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9xzmPle; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9xzmPle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657FCC433C7;
	Mon, 29 Jan 2024 17:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548344;
	bh=4oCgjzZy9sEn+1Tkb8uAQfA2mYuesOQHlDtrwa17wYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9xzmPleiFS2xjGkQC66j88vFZyR3/Hg2L/2XM6FaBz8mJ0/Pr7vfAWhm9/l6ibN3
	 zrwXS/6MMlEiLc9jeju2M/Rq7DewGzuM/btYnKcHHJ5eO9fA+x+14qSHzEMAkiCPis
	 1tvQxX14GDRcfDPi2snbQPTvG49z8CFJZFuJKI1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/185] netfilter: nf_tables: validate NFPROTO_* family
Date: Mon, 29 Jan 2024 09:05:08 -0800
Message-ID: <20240129170002.062122251@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d0009effa8862c20a13af4cb7475d9771b905693 ]

Several expressions explicitly refer to NF_INET_* hook definitions
from expr->ops->validate, however, family is not validated.

Bail out with EOPNOTSUPP in case they are used from unsupported
families.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Fixes: 2fa841938c64 ("netfilter: nf_tables: introduce routing expression")
Fixes: 554ced0a6e29 ("netfilter: nf_tables: add support for native socket matching")
Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Fixes: 6c47260250fc ("netfilter: nf_tables: add xfrm expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c       | 12 ++++++++++++
 net/netfilter/nft_flow_offload.c |  5 +++++
 net/netfilter/nft_nat.c          |  5 +++++
 net/netfilter/nft_rt.c           |  5 +++++
 net/netfilter/nft_socket.c       |  5 +++++
 net/netfilter/nft_synproxy.c     |  7 +++++--
 net/netfilter/nft_tproxy.c       |  5 +++++
 net/netfilter/nft_xfrm.c         |  5 +++++
 8 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index c16172427622..6952da7dfc02 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -349,6 +349,12 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 	unsigned int hook_mask = 0;
 	int ret;
 
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_BRIDGE &&
+	    ctx->family != NFPROTO_ARP)
+		return -EOPNOTSUPP;
+
 	if (nft_is_base_chain(ctx->chain)) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
@@ -592,6 +598,12 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 	unsigned int hook_mask = 0;
 	int ret;
 
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_BRIDGE &&
+	    ctx->family != NFPROTO_ARP)
+		return -EOPNOTSUPP;
+
 	if (nft_is_base_chain(ctx->chain)) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 8a43f6f9c90b..3d9f6dda5aeb 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -380,6 +380,11 @@ static int nft_flow_offload_validate(const struct nft_ctx *ctx,
 {
 	unsigned int hook_mask = (1 << NF_INET_FORWARD);
 
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET)
+		return -EOPNOTSUPP;
+
 	return nft_chain_validate_hooks(ctx->chain, hook_mask);
 }
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 353c090f8891..ba7bcce724ef 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -142,6 +142,11 @@ static int nft_nat_validate(const struct nft_ctx *ctx,
 	struct nft_nat *priv = nft_expr_priv(expr);
 	int err;
 
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET)
+		return -EOPNOTSUPP;
+
 	err = nft_chain_validate_dependency(ctx->chain, NFT_CHAIN_T_NAT);
 	if (err < 0)
 		return err;
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index 71931ec91721..7d21e16499bf 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -166,6 +166,11 @@ static int nft_rt_validate(const struct nft_ctx *ctx, const struct nft_expr *exp
 	const struct nft_rt *priv = nft_expr_priv(expr);
 	unsigned int hooks;
 
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET)
+		return -EOPNOTSUPP;
+
 	switch (priv->key) {
 	case NFT_RT_NEXTHOP4:
 	case NFT_RT_NEXTHOP6:
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 777561b71fcb..f28324fd8d71 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -242,6 +242,11 @@ static int nft_socket_validate(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr,
 			       const struct nft_data **data)
 {
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET)
+		return -EOPNOTSUPP;
+
 	return nft_chain_validate_hooks(ctx->chain,
 					(1 << NF_INET_PRE_ROUTING) |
 					(1 << NF_INET_LOCAL_IN) |
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 6cf9a04fbfe2..a450f28a5ef6 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -186,7 +186,6 @@ static int nft_synproxy_do_init(const struct nft_ctx *ctx,
 		break;
 #endif
 	case NFPROTO_INET:
-	case NFPROTO_BRIDGE:
 		err = nf_synproxy_ipv4_init(snet, ctx->net);
 		if (err)
 			goto nf_ct_failure;
@@ -219,7 +218,6 @@ static void nft_synproxy_do_destroy(const struct nft_ctx *ctx)
 		break;
 #endif
 	case NFPROTO_INET:
-	case NFPROTO_BRIDGE:
 		nf_synproxy_ipv4_fini(snet, ctx->net);
 		nf_synproxy_ipv6_fini(snet, ctx->net);
 		break;
@@ -253,6 +251,11 @@ static int nft_synproxy_validate(const struct nft_ctx *ctx,
 				 const struct nft_expr *expr,
 				 const struct nft_data **data)
 {
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET)
+		return -EOPNOTSUPP;
+
 	return nft_chain_validate_hooks(ctx->chain, (1 << NF_INET_LOCAL_IN) |
 						    (1 << NF_INET_FORWARD));
 }
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index 62da25ad264b..adb50c39572e 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -316,6 +316,11 @@ static int nft_tproxy_validate(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr,
 			       const struct nft_data **data)
 {
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET)
+		return -EOPNOTSUPP;
+
 	return nft_chain_validate_hooks(ctx->chain, 1 << NF_INET_PRE_ROUTING);
 }
 
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 1c5343c936a8..30259846c352 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -235,6 +235,11 @@ static int nft_xfrm_validate(const struct nft_ctx *ctx, const struct nft_expr *e
 	const struct nft_xfrm *priv = nft_expr_priv(expr);
 	unsigned int hooks;
 
+	if (ctx->family != NFPROTO_IPV4 &&
+	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET)
+		return -EOPNOTSUPP;
+
 	switch (priv->dir) {
 	case XFRM_POLICY_IN:
 		hooks = (1 << NF_INET_FORWARD) |
-- 
2.43.0



