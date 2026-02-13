Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5296535FF49;
	Fri, 13 Feb 2026 13:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770991024; cv=none; b=OetzZzUJbmYDsP9YPVrs4Ro+ZP4eu0MP4HGiH+G8Z8kUN88RuAJ02eP1eG+kQi0EOuPszhsFWVbsxb5GPt71mCsS9Mv0Y5p7jD6Of9u5tCFQUBZh/Yp6Z0ZdBd1/GV3rWXFnQREiqlFCKsR3R7FHuYYSGfFHHtMZ77mXKrSy3ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770991024; c=relaxed/simple;
	bh=5frlYhix0QPgYdPCFoggct3s548rMCzBaaSTprf513s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fd4ub7S0qZGxHpOKQxT4n5NCxDVvAEtosG/pgmpGl6izw8sygfos0DAIHmE58ofY3D95hu+POv0knZBqSJlkxEhqptl3j6zUO1n7x7d9cHhBl2cguLef607k6ZKuHSM8WoKdA+4rywiP+jxqEb6nFolMogdyQCC5t3NLDwBifpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oueogD9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oueogD9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF46EC116C6;
	Fri, 13 Feb 2026 13:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770991024;
	bh=5frlYhix0QPgYdPCFoggct3s548rMCzBaaSTprf513s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oueogD9bNOpnT7KcFIUJlqQqjhLRUbhweTQOLxuL3oQ59BrVKn+/mPu5VIhSKNJBG
	 kTtvUxUKlgkh6V/qs0Jc9+thUwHm0Sdp4mDwfpYUDhRsfKUOgFtEyC2ezvTZmjiX0J
	 Fo8veDZEJNEqUij8zggjbg+J1B4GNF1sc7SnGVgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 6.6 19/25] netfilter: nf_tables: missing objects with no memcg accounting
Date: Fri, 13 Feb 2026 14:48:45 +0100
Message-ID: <20260213134704.582003651@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134703.882698935@linuxfoundation.org>
References: <20260213134703.882698935@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 69e687cea79fc99a17dfb0116c8644b9391b915e upstream.

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
[ Adjust context ]
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c  |    2 +-
 net/netfilter/nft_compat.c     |    6 +++---
 net/netfilter/nft_log.c        |    2 +-
 net/netfilter/nft_meta.c       |    2 +-
 net/netfilter/nft_numgen.c     |    2 +-
 net/netfilter/nft_set_pipapo.c |   10 +++++-----
 net/netfilter/nft_tunnel.c     |    5 +++--
 7 files changed, 15 insertions(+), 14 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6615,7 +6615,7 @@ static int nft_setelem_catchall_insert(c
 		}
 	}
 
-	catchall = kmalloc(sizeof(*catchall), GFP_KERNEL);
+	catchall = kmalloc(sizeof(*catchall), GFP_KERNEL_ACCOUNT);
 	if (!catchall)
 		return -ENOMEM;
 
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -535,7 +535,7 @@ nft_match_large_init(const struct nft_ct
 	struct xt_match *m = expr->ops->data;
 	int ret;
 
-	priv->info = kmalloc(XT_ALIGN(m->matchsize), GFP_KERNEL);
+	priv->info = kmalloc(XT_ALIGN(m->matchsize), GFP_KERNEL_ACCOUNT);
 	if (!priv->info)
 		return -ENOMEM;
 
@@ -808,7 +808,7 @@ nft_match_select_ops(const struct nft_ct
 		goto err;
 	}
 
-	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL);
+	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL_ACCOUNT);
 	if (!ops) {
 		err = -ENOMEM;
 		goto err;
@@ -898,7 +898,7 @@ nft_target_select_ops(const struct nft_c
 		goto err;
 	}
 
-	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL);
+	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL_ACCOUNT);
 	if (!ops) {
 		err = -ENOMEM;
 		goto err;
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -163,7 +163,7 @@ static int nft_log_init(const struct nft
 
 	nla = tb[NFTA_LOG_PREFIX];
 	if (nla != NULL) {
-		priv->prefix = kmalloc(nla_len(nla) + 1, GFP_KERNEL);
+		priv->prefix = kmalloc(nla_len(nla) + 1, GFP_KERNEL_ACCOUNT);
 		if (priv->prefix == NULL)
 			return -ENOMEM;
 		nla_strscpy(priv->prefix, nla, nla_len(nla) + 1);
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -952,7 +952,7 @@ static int nft_secmark_obj_init(const st
 	if (tb[NFTA_SECMARK_CTX] == NULL)
 		return -EINVAL;
 
-	priv->ctx = nla_strdup(tb[NFTA_SECMARK_CTX], GFP_KERNEL);
+	priv->ctx = nla_strdup(tb[NFTA_SECMARK_CTX], GFP_KERNEL_ACCOUNT);
 	if (!priv->ctx)
 		return -ENOMEM;
 
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -66,7 +66,7 @@ static int nft_ng_inc_init(const struct
 	if (priv->offset + priv->modulus - 1 < priv->offset)
 		return -EOVERFLOW;
 
-	priv->counter = kmalloc(sizeof(*priv->counter), GFP_KERNEL);
+	priv->counter = kmalloc(sizeof(*priv->counter), GFP_KERNEL_ACCOUNT);
 	if (!priv->counter)
 		return -ENOMEM;
 
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -874,7 +874,7 @@ static void pipapo_lt_bits_adjust(struct
 		return;
 	}
 
-	new_lt = kvzalloc(lt_size + NFT_PIPAPO_ALIGN_HEADROOM, GFP_KERNEL);
+	new_lt = kvzalloc(lt_size + NFT_PIPAPO_ALIGN_HEADROOM, GFP_KERNEL_ACCOUNT);
 	if (!new_lt)
 		return;
 
@@ -1150,7 +1150,7 @@ static int pipapo_realloc_scratch(struct
 		scratch = kzalloc_node(struct_size(scratch, map,
 						   bsize_max * 2) +
 				       NFT_PIPAPO_ALIGN_HEADROOM,
-				       GFP_KERNEL, cpu_to_node(i));
+				       GFP_KERNEL_ACCOUNT, cpu_to_node(i));
 		if (!scratch) {
 			/* On failure, there's no need to undo previous
 			 * allocations: this means that some scratch maps have
@@ -1323,7 +1323,7 @@ static struct nft_pipapo_match *pipapo_c
 	struct nft_pipapo_match *new;
 	int i;
 
-	new = kmalloc(struct_size(new, f, old->field_count), GFP_KERNEL);
+	new = kmalloc(struct_size(new, f, old->field_count), GFP_KERNEL_ACCOUNT);
 	if (!new)
 		return ERR_PTR(-ENOMEM);
 
@@ -1353,7 +1353,7 @@ static struct nft_pipapo_match *pipapo_c
 		new_lt = kvzalloc(src->groups * NFT_PIPAPO_BUCKETS(src->bb) *
 				  src->bsize * sizeof(*dst->lt) +
 				  NFT_PIPAPO_ALIGN_HEADROOM,
-				  GFP_KERNEL);
+				  GFP_KERNEL_ACCOUNT);
 		if (!new_lt)
 			goto out_lt;
 
@@ -1367,7 +1367,7 @@ static struct nft_pipapo_match *pipapo_c
 		if (src->rules > (INT_MAX / sizeof(*src->mt)))
 			goto out_mt;
 
-		dst->mt = kvmalloc(src->rules * sizeof(*src->mt), GFP_KERNEL);
+		dst->mt = kvmalloc(src->rules * sizeof(*src->mt), GFP_KERNEL_ACCOUNT);
 		if (!dst->mt)
 			goto out_mt;
 
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -503,13 +503,14 @@ static int nft_tunnel_obj_init(const str
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


