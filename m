Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50A31C6F62;
	Tue, 27 Aug 2024 14:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769908; cv=none; b=Q3CIITOuTN49qVcV0n3+1c8CP9+c8dnZGH999cPAvyeXlQe+dGMCS1sqEnXV9QtreKsmjRPZfrBWf+CB4KRGOAJVRSW54bVLyvxAZ3LDNcvUrkzBkA0Pn6fwIt7eEr3O4Ubgz99eOFwbOzvfpgWR86yufxcAzReZY68gQk9s70k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769908; c=relaxed/simple;
	bh=3jwDaqZjQPpZRwqWu2Jl9x7xc33LKVGgURzFLYI21bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMEeihNhYGeHbo6C1PdmrG06hPDE5ZAZNluscdbefWjm16pzG5M+/ndW8sU2FW6768cvMlCpa9N21/aPecdcO0IgV0nNadHmwV2FlQO6UEihiBuAClnKi4baSn0AppBp0ieyoLHCOIMbcmdosNTEV97AdEX8t4syZRCXRd5eKts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnS4i/NL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnS4i/NL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23443C61063;
	Tue, 27 Aug 2024 14:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769908;
	bh=3jwDaqZjQPpZRwqWu2Jl9x7xc33LKVGgURzFLYI21bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnS4i/NLB5ftVbgFagwwezb9eoijZRP3FmzI58ucgcxbgKA+D7hQ1trOcpHVmLjfy
	 tnS2Ehh5Z7LMqpCPK1Y5px9h/6JTeIcdBayYtfC/bNIFk6BBI9YsHC5rshKgQwA6v1
	 UrAHJFnjfUzLIKLRfyrO0Dxc32cvCtpeUqqXDaRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/341] netfilter: nf_tables: nft_obj_filter fits into cb->ctx
Date: Tue, 27 Aug 2024 16:35:02 +0200
Message-ID: <20240827143846.113109627@linuxfoundation.org>
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

[ Upstream commit 5a893b9cdf6fa5758f43d323a1d7fa6d1bf489ff ]

No need to allocate it if one may just use struct netlink_callback's
scratch area for it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: bd662c4218f9 ("netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7d6146923819c..e3e3ad532ec9f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7726,7 +7726,7 @@ struct nft_obj_dump_ctx {
 static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	struct nft_obj_dump_ctx *ctx = cb->data;
+	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
@@ -7788,34 +7788,28 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 
 static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 {
+	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
 	const struct nlattr * const *nla = cb->data;
-	struct nft_obj_dump_ctx *ctx = NULL;
 
-	ctx = kzalloc(sizeof(*ctx), GFP_ATOMIC);
-	if (!ctx)
-		return -ENOMEM;
+	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
 
 	if (nla[NFTA_OBJ_TABLE]) {
 		ctx->table = nla_strdup(nla[NFTA_OBJ_TABLE], GFP_ATOMIC);
-		if (!ctx->table) {
-			kfree(ctx);
+		if (!ctx->table)
 			return -ENOMEM;
-		}
 	}
 
 	if (nla[NFTA_OBJ_TYPE])
 		ctx->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 
-	cb->data = ctx;
 	return 0;
 }
 
 static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 {
-	struct nft_obj_dump_ctx *ctx = cb->data;
+	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
 
 	kfree(ctx->table);
-	kfree(ctx);
 
 	return 0;
 }
-- 
2.43.0



