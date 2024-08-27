Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4A91C57B7;
	Tue, 27 Aug 2024 14:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769912; cv=none; b=HoDivCkdpncemnPjWsi5xHpaNbuJxqiuJB348d6EwyiTME/p5gGQw3li8ttSQE26Z1rup/Btr4XtZNsoV/g0Kt0c4tWbb0EetTTRE4IGhxlCN27AYnEEdob4uB+y/CJlaDrFFvsu7UyxxH4C2V8LSXmh0OB5OJTogrYeXGZeYzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769912; c=relaxed/simple;
	bh=gedKM8qJqt3Uc3CrTJYVmt/rIGGDfhlgJv4mQGFRp5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDfA25ri90sfKuDCxgfkuhGz7UwHJKXZ3cHXjvEFtNocHqw+PrdWDedVUlGNdudZGHrlggZ7sUWYWoOpwCkIj/E4i+qQvont9UDzBYcYtzh/g6I5vQlHT9It+4aA1KkgFkSura8LA+fqSGJUj4cwBBPSPDpWKKQew6HBwqcXgB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANIPCjE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANIPCjE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C4BC61063;
	Tue, 27 Aug 2024 14:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769912;
	bh=gedKM8qJqt3Uc3CrTJYVmt/rIGGDfhlgJv4mQGFRp5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANIPCjE9Yraprj4RcTA2h0xKda2CRezDMU/0vAkHRRIz+hx9EtBHduqgU27vLsL/H
	 zPUkSkvIM7XI559qVUR+wxNi2xxXU/CyQRZvaLBLYjZ6xiprvG+hivcNzrO317sC0g
	 01taR3tzN952vXMxt1W9AohahlIDlEPY3E/Wsq0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/341] netfilter: nf_tables: Carry reset boolean in nft_obj_dump_ctx
Date: Tue, 27 Aug 2024 16:35:03 +0200
Message-ID: <20240827143846.150837567@linuxfoundation.org>
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
index e3e3ad532ec9f..170f6f624ac16 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7721,6 +7721,7 @@ struct nft_obj_dump_ctx {
 	unsigned int	s_idx;
 	char		*table;
 	u32		type;
+	bool		reset;
 };
 
 static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
@@ -7734,12 +7735,8 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -7766,7 +7763,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 						     NFT_MSG_NEWOBJ,
 						     NLM_F_MULTI | NLM_F_APPEND,
 						     table->family, table,
-						     obj, reset);
+						     obj, ctx->reset);
 			if (rc < 0)
 				break;
 
@@ -7775,7 +7772,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 cont:
 			idx++;
 		}
-		if (reset && entries)
+		if (ctx->reset && entries)
 			audit_log_obj_reset(table, nft_net->base_seq, entries);
 		if (rc < 0)
 			break;
@@ -7802,6 +7799,9 @@ static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 	if (nla[NFTA_OBJ_TYPE])
 		ctx->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 
+	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
+		ctx->reset = true;
+
 	return 0;
 }
 
-- 
2.43.0



