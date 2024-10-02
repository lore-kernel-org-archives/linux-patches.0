Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431691CFEBE;
	Wed,  2 Oct 2024 14:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878537; cv=none; b=tnHtadFeX41jFi5peZurDheM2UOKSpleJVLheE8jUOCbUgdM9LFhWBzKIFbmgpx2KCvAsZY1XhBVQ0aGWz4t8lXCFduT8/rK5zjOav1L3hs/LKkyEhN+YzhSgnW7Nbu9rzrmtMsbGITf382j/vuI8cw1gikSyfTMOKtPlNW6G5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878537; c=relaxed/simple;
	bh=2y03h8fS3PUuaeEf42Q+FH49A1N3xRQDcj6lfBM1zQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCx8iVhcCMc1x3bfdHPjcfM9tdyeridI5yBA2symOOsObfAesmwh9+Fz1mN+aAW2Xq9AHp3hC1vU1DmE11C1/TY2annzTxNutg5Exl4qTh9Csh5a09Z1jQT3ZfNXGRMDHDMN/JWGYj3JzA8uvhwWZPeZYwu13IDGNL0eHitMHIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahuUZ4un; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahuUZ4un"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0204C4CEC2;
	Wed,  2 Oct 2024 14:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878537;
	bh=2y03h8fS3PUuaeEf42Q+FH49A1N3xRQDcj6lfBM1zQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahuUZ4unXyIP7nb557VuQtuGIzBMZKjBQTwAj1+IlxpDjR5GGAUGIPpXy5fkTFEKR
	 8GG5SEVPT24J9yjD02tKBXdQu7UAYaB3OLER8w0UpxyN4qgpsvjJQArs9Dsq4RjGO6
	 ieYMg+byOUp1x9wGbw1/slFug4Vrsk6mPExQP2JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 448/634] netfilter: nf_tables: missing objects with no memcg accounting
Date: Wed,  2 Oct 2024 14:59:08 +0200
Message-ID: <20241002125828.783508925@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 69e687cea79fc99a17dfb0116c8644b9391b915e ]

Several ruleset objects are still not using GFP_KERNEL_ACCOUNT for
memory accounting, update them. This includes:

- catchall elements
- compat match large info area
- log prefix
- meta secctx
- numgen counters
- pipapo set backend datastructure
- tunnel private objects

Fixes: 33758c891479 ("memcg: enable accounting for nft objects")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c  |  2 +-
 net/netfilter/nft_compat.c     |  6 +++---
 net/netfilter/nft_log.c        |  2 +-
 net/netfilter/nft_meta.c       |  2 +-
 net/netfilter/nft_numgen.c     |  2 +-
 net/netfilter/nft_set_pipapo.c | 13 +++++++------
 net/netfilter/nft_tunnel.c     |  5 +++--
 7 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 71df3e5cc46d9..465cc43c75e30 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6631,7 +6631,7 @@ static int nft_setelem_catchall_insert(const struct net *net,
 		}
 	}
 
-	catchall = kmalloc(sizeof(*catchall), GFP_KERNEL);
+	catchall = kmalloc(sizeof(*catchall), GFP_KERNEL_ACCOUNT);
 	if (!catchall)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index d3d11dede5450..85450f6011426 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -536,7 +536,7 @@ nft_match_large_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	struct xt_match *m = expr->ops->data;
 	int ret;
 
-	priv->info = kmalloc(XT_ALIGN(m->matchsize), GFP_KERNEL);
+	priv->info = kmalloc(XT_ALIGN(m->matchsize), GFP_KERNEL_ACCOUNT);
 	if (!priv->info)
 		return -ENOMEM;
 
@@ -810,7 +810,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL);
+	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL_ACCOUNT);
 	if (!ops) {
 		err = -ENOMEM;
 		goto err;
@@ -900,7 +900,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL);
+	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL_ACCOUNT);
 	if (!ops) {
 		err = -ENOMEM;
 		goto err;
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 5defe6e4fd982..e355881379957 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -163,7 +163,7 @@ static int nft_log_init(const struct nft_ctx *ctx,
 
 	nla = tb[NFTA_LOG_PREFIX];
 	if (nla != NULL) {
-		priv->prefix = kmalloc(nla_len(nla) + 1, GFP_KERNEL);
+		priv->prefix = kmalloc(nla_len(nla) + 1, GFP_KERNEL_ACCOUNT);
 		if (priv->prefix == NULL)
 			return -ENOMEM;
 		nla_strscpy(priv->prefix, nla, nla_len(nla) + 1);
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 9139ce38ea7b9..f23faf565b687 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -954,7 +954,7 @@ static int nft_secmark_obj_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_SECMARK_CTX] == NULL)
 		return -EINVAL;
 
-	priv->ctx = nla_strdup(tb[NFTA_SECMARK_CTX], GFP_KERNEL);
+	priv->ctx = nla_strdup(tb[NFTA_SECMARK_CTX], GFP_KERNEL_ACCOUNT);
 	if (!priv->ctx)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 7d29db7c2ac0f..bd058babfc820 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -66,7 +66,7 @@ static int nft_ng_inc_init(const struct nft_ctx *ctx,
 	if (priv->offset + priv->modulus - 1 < priv->offset)
 		return -EOVERFLOW;
 
-	priv->counter = kmalloc(sizeof(*priv->counter), GFP_KERNEL);
+	priv->counter = kmalloc(sizeof(*priv->counter), GFP_KERNEL_ACCOUNT);
 	if (!priv->counter)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index eb4c4a4ac7ace..7be342b495f5f 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -663,7 +663,7 @@ static int pipapo_realloc_mt(struct nft_pipapo_field *f,
 	    check_add_overflow(rules, extra, &rules_alloc))
 		return -EOVERFLOW;
 
-	new_mt = kvmalloc_array(rules_alloc, sizeof(*new_mt), GFP_KERNEL);
+	new_mt = kvmalloc_array(rules_alloc, sizeof(*new_mt), GFP_KERNEL_ACCOUNT);
 	if (!new_mt)
 		return -ENOMEM;
 
@@ -936,7 +936,7 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
 		return;
 	}
 
-	new_lt = kvzalloc(lt_size + NFT_PIPAPO_ALIGN_HEADROOM, GFP_KERNEL);
+	new_lt = kvzalloc(lt_size + NFT_PIPAPO_ALIGN_HEADROOM, GFP_KERNEL_ACCOUNT);
 	if (!new_lt)
 		return;
 
@@ -1212,7 +1212,7 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 		scratch = kzalloc_node(struct_size(scratch, map,
 						   bsize_max * 2) +
 				       NFT_PIPAPO_ALIGN_HEADROOM,
-				       GFP_KERNEL, cpu_to_node(i));
+				       GFP_KERNEL_ACCOUNT, cpu_to_node(i));
 		if (!scratch) {
 			/* On failure, there's no need to undo previous
 			 * allocations: this means that some scratch maps have
@@ -1427,7 +1427,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 	struct nft_pipapo_match *new;
 	int i;
 
-	new = kmalloc(struct_size(new, f, old->field_count), GFP_KERNEL);
+	new = kmalloc(struct_size(new, f, old->field_count), GFP_KERNEL_ACCOUNT);
 	if (!new)
 		return NULL;
 
@@ -1457,7 +1457,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		new_lt = kvzalloc(src->groups * NFT_PIPAPO_BUCKETS(src->bb) *
 				  src->bsize * sizeof(*dst->lt) +
 				  NFT_PIPAPO_ALIGN_HEADROOM,
-				  GFP_KERNEL);
+				  GFP_KERNEL_ACCOUNT);
 		if (!new_lt)
 			goto out_lt;
 
@@ -1470,7 +1470,8 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 
 		if (src->rules > 0) {
 			dst->mt = kvmalloc_array(src->rules_alloc,
-						 sizeof(*src->mt), GFP_KERNEL);
+						 sizeof(*src->mt),
+						 GFP_KERNEL_ACCOUNT);
 			if (!dst->mt)
 				goto out_mt;
 
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 60a76e6e348e7..5c6ed68cc6e05 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -509,13 +509,14 @@ static int nft_tunnel_obj_init(const struct nft_ctx *ctx,
 			return err;
 	}
 
-	md = metadata_dst_alloc(priv->opts.len, METADATA_IP_TUNNEL, GFP_KERNEL);
+	md = metadata_dst_alloc(priv->opts.len, METADATA_IP_TUNNEL,
+				GFP_KERNEL_ACCOUNT);
 	if (!md)
 		return -ENOMEM;
 
 	memcpy(&md->u.tun_info, &info, sizeof(info));
 #ifdef CONFIG_DST_CACHE
-	err = dst_cache_init(&md->u.tun_info.dst_cache, GFP_KERNEL);
+	err = dst_cache_init(&md->u.tun_info.dst_cache, GFP_KERNEL_ACCOUNT);
 	if (err < 0) {
 		metadata_dst_free(md);
 		return err;
-- 
2.43.0



