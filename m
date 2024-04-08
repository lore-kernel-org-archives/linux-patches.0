Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E044A7B3E5;
	Mon,  8 Apr 2024 13:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582096; cv=none; b=hXvYci1wZ/35ehdrLnBliTDLe+Jg/oY+eDkphNDfhG3anYIqQd2ZEms17An1IHP8eHqq6HJBgv+SJ4gRGu+APQgsMz0zFrcqjmzXNcxcuRzVjqOPkKBt0RyZYJERVIaHPAQmjuO/AgZsEYK+9TF+L0uSyQCiApUaz1dlyrxChYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582096; c=relaxed/simple;
	bh=C8OWFhUMtlDCxrThbC7F+k99c2CUPPjt4GwqFCGdZs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyN3XXnkrMnXT8Sgalpap5nzqHRl4iy+32rtTsYbFVhCjd8yJgOf+Z0QJ0Hx6mdf9GVTrGSUHHelLqVUGI4j3E0XdfjZQlDHqmve/t9XWr+3NxLS+tjNlqlF/UquRLHQq3lrI/MUc/4SoGnf0A/yeiuz73jShsQ0C4KRn722rmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rryCR7zk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rryCR7zk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0E2C433F1;
	Mon,  8 Apr 2024 13:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582095;
	bh=C8OWFhUMtlDCxrThbC7F+k99c2CUPPjt4GwqFCGdZs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rryCR7zkfvU0AGhrYPj+fiE5OjSzWtGUektrBJkhCw0tg7cO3yG8m0j5H5o7AZ8sB
	 Tu0U+PWSG3V8gtB7Exy+tMFffixYnHUKmR1vLkjzLbA320EtvzLJLXejDbe9irolA9
	 vLEiqak87MdFH6bHwpTo82ZYBlX4kPtkSZxOxPYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 046/273] netfilter: nf_tables: reject table flag and netdev basechain updates
Date: Mon,  8 Apr 2024 14:55:21 +0200
Message-ID: <20240408125310.727931386@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 1e1fb6f00f52812277963365d9bd835b9b0ea4e0 ]

netdev basechain updates are stored in the transaction object hook list.
When setting on the table dormant flag, it iterates over the existing
hooks in the basechain. Thus, skipping the hooks that are being
added/deleted in this transaction, which leaves hook registration in
inconsistent state.

Reject table flag updates in combination with netdev basechain updates
in the same batch:

- Update table flags and add/delete basechain: Check from basechain update
  path if there are pending flag updates for this table.
- add/delete basechain and update table flags: Iterate over the transaction
  list to search for basechain updates from the table update path.

In both cases, the batch is rejected. Based on suggestion from Florian Westphal.

Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Fixes: 7d937b107108f ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 00288b31f734c..db233965631bb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1198,6 +1198,25 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
 #define __NFT_TABLE_F_UPDATE		(__NFT_TABLE_F_WAS_DORMANT | \
 					 __NFT_TABLE_F_WAS_AWAKEN)
 
+static bool nft_table_pending_update(const struct nft_ctx *ctx)
+{
+	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
+	struct nft_trans *trans;
+
+	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
+		return true;
+
+	list_for_each_entry(trans, &nft_net->commit_list, list) {
+		if ((trans->msg_type == NFT_MSG_NEWCHAIN ||
+		     trans->msg_type == NFT_MSG_DELCHAIN) &&
+		    trans->ctx.table == ctx->table &&
+		    nft_trans_chain_update(trans))
+			return true;
+	}
+
+	return false;
+}
+
 static int nf_tables_updtable(struct nft_ctx *ctx)
 {
 	struct nft_trans *trans;
@@ -1221,7 +1240,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 		return -EOPNOTSUPP;
 
 	/* No dormant off/on/off/on games in single transaction */
-	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
+	if (nft_table_pending_update(ctx))
 		return -EINVAL;
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWTABLE,
@@ -2619,6 +2638,13 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 		}
 	}
 
+	if (table->flags & __NFT_TABLE_F_UPDATE &&
+	    !list_empty(&hook.list)) {
+		NL_SET_BAD_ATTR(extack, attr);
+		err = -EOPNOTSUPP;
+		goto err_hooks;
+	}
+
 	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
 	    nft_is_base_chain(chain) &&
 	    !list_empty(&hook.list)) {
@@ -2848,6 +2874,9 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 	struct nft_trans *trans;
 	int err;
 
+	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
+		return -EOPNOTSUPP;
+
 	err = nft_chain_parse_hook(ctx->net, basechain, nla, &chain_hook,
 				   ctx->family, chain->flags, extack);
 	if (err < 0)
-- 
2.43.0



