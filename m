Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFAD1C57A0;
	Tue, 27 Aug 2024 14:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769905; cv=none; b=Loq2mou9A18As9h5BzMo16NpGDaS/6/kQZezCvl26D/jTmPCO9CtcpvftYp+fKwx/SUTqK9uKfNptwRVqz8xBe79MZg5cJwcuQ4B066Giceu/LY86hlzT+eb9h99DaIpVJKaFxMzEd0ocQEJ4HnvTD754oB53APhaY2doFQ0lOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769905; c=relaxed/simple;
	bh=r1QBQ6MNgcBT90YOz4ev/zYq9yKSuRO9S+NYcLEPRs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iM0N1PTtlUe08I3rLJKvFWhiT7AyTIJXAjW9xoIhLcsxbJzw/ZpIT+O61woWu09UbTeKru9Vzw4BM91cYK9N9Mv94gNNYh/2h6nWhxu6DjpTIxUjg7sgLW7oYLpjSIyJ70W2/c+NllOr4MWkDhLOEIGTi9i9GU/0r5wRVYa2rEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OSn+555v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSn+555v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00F6C61063;
	Tue, 27 Aug 2024 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769905;
	bh=r1QBQ6MNgcBT90YOz4ev/zYq9yKSuRO9S+NYcLEPRs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OSn+555v0+anpLcsrnS5w4afE4U2Pk1j8Tgab57wQQZxUV0e9wvQrJfZ9C+QQJCy9
	 QnhXNUt3fyUmYpXVWWvDiLdJItFcaJEthv6B0zvzITnV74UWdQoBsH6almA+2lvOn2
	 SioWEl5R0MD/DofJBbYBTP5R5tWES0EfjpVx0BPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/341] netfilter: nf_tables: Carry s_idx in nft_obj_dump_ctx
Date: Tue, 27 Aug 2024 16:35:01 +0200
Message-ID: <20240827143846.076064392@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 2eda95cfa2fc43bcb21a801dc1d16a0b7cc73860 ]

Prep work for moving the context into struct netlink_callback scratch
area.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: bd662c4218f9 ("netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ca5fb700d15cf..7d6146923819c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7718,6 +7718,7 @@ static void audit_log_obj_reset(const struct nft_table *table,
 }
 
 struct nft_obj_dump_ctx {
+	unsigned int	s_idx;
 	char		*table;
 	u32		type;
 };
@@ -7725,14 +7726,14 @@ struct nft_obj_dump_ctx {
 static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	const struct nft_table *table;
-	unsigned int idx = 0, s_idx = cb->args[0];
 	struct nft_obj_dump_ctx *ctx = cb->data;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
+	const struct nft_table *table;
 	unsigned int entries = 0;
 	struct nft_object *obj;
+	unsigned int idx = 0;
 	bool reset = false;
 	int rc = 0;
 
@@ -7751,7 +7752,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 		list_for_each_entry_rcu(obj, &table->objects, list) {
 			if (!nft_is_active(net, obj))
 				goto cont;
-			if (idx < s_idx)
+			if (idx < ctx->s_idx)
 				goto cont;
 			if (ctx->table && strcmp(ctx->table, table->name))
 				goto cont;
@@ -7781,7 +7782,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 	rcu_read_unlock();
 
-	cb->args[0] = idx;
+	ctx->s_idx = idx;
 	return skb->len;
 }
 
-- 
2.43.0



