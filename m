Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106171C5792;
	Tue, 27 Aug 2024 15:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772170; cv=none; b=j0N0AQY/C5b6Wm7BrrCnQHDkrYOC8PjNrJEd7zgiY0RDWSs9rq+iNvU07bRiOoPFBts3dSYwW1m186RdwrEVSbAFsjjd8yrAsyyfIvE/W6xCNnpTHTL4+uSoc9jKROUj+uhg3A+u8a7AYoV3xeB5cyGH6TKk4dq2dAfIqDezMGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772170; c=relaxed/simple;
	bh=trDQgYf9u7KQCrMRNQpWwAXz843lsdkTitRd1KdXWGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmI4eaPhdITLweSIaH4mQWdcXo8Eiu3IHtw8otgnML/oCaFKchv0/ehLO0KU763mS7RAFaWjvi2dTCY7ffwo2dHp0UbMLQs6/K3TgTPqXFDOXqbQG3UDo98swFUAgEX6z1IbA+gBtf8cqg25hCxL6P3xTLmPdn/pu7zHMgm+3ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7hBq1L5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7hBq1L5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B0CC61042;
	Tue, 27 Aug 2024 15:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772169;
	bh=trDQgYf9u7KQCrMRNQpWwAXz843lsdkTitRd1KdXWGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7hBq1L5os/NLqjeahnLXLaVJWkRWY3zPHxoKoX0yUx92Wvz2x5zOe95PgslnNr57
	 GvZHO0ftciNINtfyBWT2jc/kty8z8D7jfzS5w1RNA+xKswn7w2Ow/rRJj0xZr96zuR
	 yh/0k2qgnVO+PU/ixJ3/MNUJ752d4jH57Y7eiB/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/321] netfilter: nf_tables: Carry reset boolean in nft_obj_dump_ctx
Date: Tue, 27 Aug 2024 16:36:52 +0200
Message-ID: <20240827143842.207956118@linuxfoundation.org>
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

[ Upstream commit a552339063d37b3b1133d9dfc31f851edafb27bb ]

Relieve the dump callback from having to inspect nlmsg_type upon each
call, just do it once at start of the dump.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: bd662c4218f9 ("netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 05c93af417120..38a5e5c5530c7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7420,6 +7420,7 @@ struct nft_obj_dump_ctx {
 	unsigned int	s_idx;
 	char		*table;
 	u32		type;
+	bool		reset;
 };
 
 static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
@@ -7433,12 +7434,8 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	unsigned int entries = 0;
 	struct nft_object *obj;
 	unsigned int idx = 0;
-	bool reset = false;
 	int rc = 0;
 
-	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
-		reset = true;
-
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
 	cb->seq = READ_ONCE(nft_net->base_seq);
@@ -7465,7 +7462,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 						     NFT_MSG_NEWOBJ,
 						     NLM_F_MULTI | NLM_F_APPEND,
 						     table->family, table,
-						     obj, reset);
+						     obj, ctx->reset);
 			if (rc < 0)
 				break;
 
@@ -7474,7 +7471,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 cont:
 			idx++;
 		}
-		if (reset && entries)
+		if (ctx->reset && entries)
 			audit_log_obj_reset(table, nft_net->base_seq, entries);
 		if (rc < 0)
 			break;
@@ -7501,6 +7498,9 @@ static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 	if (nla[NFTA_OBJ_TYPE])
 		ctx->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 
+	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
+		ctx->reset = true;
+
 	return 0;
 }
 
-- 
2.43.0



