Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0D51C93B7;
	Tue, 27 Aug 2024 15:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772167; cv=none; b=Es9p6XEIZm4+7k5Ma/XI/+Pxt40ANaEmjN77Wbz4+5Cw/KFsaq0dirni28LRxUdxtYg+aqJNcj3XMIYIxPQ+njA43zpTYoZsf3or/Guug4Oh842zgaISTA+zCPvoDO8ZY8VHoUx54zXTBpoAWwP8g08rNX4Tv4IwLRcXKqZkvAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772167; c=relaxed/simple;
	bh=AvobskIawxx9u2rP5iPaUzptvalnejub0BYfQL0YI20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnStHMmykf/EjTldk8ErXVSif6ktK6nVmGDtXt5NOf40jTOeJzaTlUW/TAfMxR/xjS8E/R85yAtg7cf1dwHmMJfGbiMXzFrY+1tHIh2vDD3qrdRQauydyogDUfJ7jirHOk3C5vi9Bh1KmbuLBpsEuMO2ZolLcMXHikeKZ19mswE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lni2Ik7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lni2Ik7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A04C61048;
	Tue, 27 Aug 2024 15:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772166;
	bh=AvobskIawxx9u2rP5iPaUzptvalnejub0BYfQL0YI20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lni2Ik7O/xeXMsJvegPumRXpsU7LlUQ3u8C9UZbakDteOj0d5YwveM6xq1eZyFSRj
	 N7PrkZaEXYuNAOkyZgOiK9m9O6LIby83Q8cbguVJZ2Nc1DEUvgtbiJSeTyC5LOOdKg
	 fSuU2aIupMtK1blaCwJ8jMUTkODMQOQMdoS800Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/321] netfilter: nf_tables: nft_obj_filter fits into cb->ctx
Date: Tue, 27 Aug 2024 16:36:51 +0200
Message-ID: <20240827143842.169860690@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
index 48cd3e2dde69c..05c93af417120 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7425,7 +7425,7 @@ struct nft_obj_dump_ctx {
 static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	struct nft_obj_dump_ctx *ctx = cb->data;
+	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
@@ -7487,34 +7487,28 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 
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



