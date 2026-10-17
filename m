Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A7437BE64;
	Sat, 17 Oct 2026 16:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254892; cv=none; b=AeRtJqKOYhJFSWGZX6ZlEN38OxJd21Bv93P2ov5G2s34ROlxszM3fREJfEUuRYRyBqqguulzmay56EHXE9pOqbn97UqV0wyq0/+YFgYKMbvgX6O1A1wVptL37Ip4Nj0FxfgT8NKzZhP5l9Fm6K0Z9Go3uv4FXq7SuN0ENp/7fJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254892; c=relaxed/simple;
	bh=hU9cdCf9YFUfENVNmgMxPtYtEZ2dhRwYZpmF6xpFQ34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSuLwelx5Qgwc1AwAaq1u+oKYaZISZ7NlykZADQjnqDgcezAbsTu5Pgd/QMO32Q7twXq8DbZaVTEdE2YJBQjzexDXs/VeD0f+QKWpZerMqa9oFzJDoij/zeHeK+/Vz2q5HK+mBUiD6DFB+BXaCjUJx9vpqL0IYzUJt0i6TgSkEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JIvlh1G1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JIvlh1G1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9AA1F000C4;
	Sat, 17 Oct 2026 16:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254891;
	bh=biAk9YHxn55a8499zjykq2nBAEDwU5lwAR/pHMKWKKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIvlh1G1qKef45RgLkytQsikAvcdq1mn9d8y4O886X0Ry/cfwOOD9C9atd+HW9WAU
	 8xDGfFhtu949LeJrEawzM4nKqssSauZWFcsHepAOMvAw++DYnT9xduPnYpOyybMD3Z
	 D+xBfm0kHSgDGQZwPDVpWahkemdxWZMC8Bq45oTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 595/869] netfilter: nf_tables: add nft_trans_commit_list_add_elem helper
Date: Sat, 17 Oct 2026 17:57:16 +0200
Message-ID: <20261017160052.304581886@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 4ee29181216d2acb7be210126324ec3bc0e3bd01 ]

Add and use a wrapper to append trans_elem structures to the
transaction log.

Unlike the existing helper, pass a gfp_t to indicate if sleeping
is allowed.

This will be used by a followup patch to realloc nft_trans_elem
structures after they gain a flexible array member to reduce
number of such container structures on the transaction list.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 43559058d21e ("netfilter: nf_tables: skip double clone set expressions on element insert")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b5e5eae856fe7..0e2c5052977cd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -440,6 +440,17 @@ static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *tr
 	}
 }
 
+static void nft_trans_commit_list_add_elem(struct net *net, struct nft_trans *trans,
+					   gfp_t gfp)
+{
+	WARN_ON_ONCE(trans->msg_type != NFT_MSG_NEWSETELEM &&
+		     trans->msg_type != NFT_MSG_DELSETELEM);
+
+	might_alloc(gfp);
+
+	nft_trans_commit_list_add_tail(net, trans);
+}
+
 static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
 {
 	struct nft_trans *trans;
@@ -7167,7 +7178,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 					if (update_flags) {
 						nft_trans_elem_priv(trans) = elem_priv;
 						nft_trans_elem_update_flags(trans) = update_flags;
-						nft_trans_commit_list_add_tail(ctx->net, trans);
+						nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 						goto err_set_size;
 					}
 				}
@@ -7187,7 +7198,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	nft_trans_elem_priv(trans) = elem.priv;
-	nft_trans_commit_list_add_tail(ctx->net, trans);
+	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 
 	return set_full ? -ENFILE : 0;
 
@@ -7406,7 +7417,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	nft_setelem_data_deactivate(ctx->net, set, elem.priv);
 
 	nft_trans_elem_priv(trans) = elem.priv;
-	nft_trans_commit_list_add_tail(ctx->net, trans);
+	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 	return 0;
 
 fail_ops:
@@ -7442,7 +7453,7 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 	nft_trans_elem_set(trans) = set;
 	nft_trans_elem_priv(trans) = elem_priv;
-	nft_trans_commit_list_add_tail(ctx->net, trans);
+	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_ATOMIC);
 
 	return 0;
 }
@@ -7459,7 +7470,7 @@ static int __nft_set_catchall_flush(const struct nft_ctx *ctx,
 
 	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 	nft_trans_elem_priv(trans) = elem_priv;
-	nft_trans_commit_list_add_tail(ctx->net, trans);
+	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 
 	return 0;
 }
-- 
2.53.0



