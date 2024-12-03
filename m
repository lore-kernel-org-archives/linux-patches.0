Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DA51F76AB;
	Tue,  3 Dec 2024 15:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238557; cv=none; b=F7WMPHSyIz5HXa5jr+LJulalRHSildR6vY5cz90ng3pMK6zvVJ5ZiuIThw3RXNll+OKla9m1TWyVaUpfXZB30QH7hJdziwFN6qL4n/R5IlocpG6vZt14iUZtP7vIQHrhB8nUoO9ac/4AfV9TPl8YqLmRUWUVORhSrzOnsuXrwZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238557; c=relaxed/simple;
	bh=0ncdcL1/oqTvEu/7QRAI3Joh70WnjBeqZ4XAoLvc5Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgM4csci6+vsPmvW9F3T5aGiKV8NWd15/uaFWEBlV3StNvPrJKPhzMhyvBvP3wLOoJ9Spv59HUEiH3pusfF218dmtXcrhQC1z674dGumOTaLZaew5Zeog0c+zKjBC5IBMOJ8lCE+YgwkInX6myvK8SI3hyPDRez45qbblr3b0d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxkILEmI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxkILEmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DCBC4CED6;
	Tue,  3 Dec 2024 15:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238557;
	bh=0ncdcL1/oqTvEu/7QRAI3Joh70WnjBeqZ4XAoLvc5Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxkILEmIjVG997IgdCd5XxB2s+bE6i/LzCs+mWuuONsmgG40ihJz4v1gh8s/qtv9A
	 2AZJ/310EHfao4hh65IZnDiWNjaV5HKEmY3eaDUGtK31TYMEnc4zkvKQROwpnSIrJM
	 LqxTmud/ixttYVF50rrJa8hpVQaZutMM/j7ybsBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 319/817] netfilter: nf_tables: must hold rcu read lock while iterating object type list
Date: Tue,  3 Dec 2024 15:38:11 +0100
Message-ID: <20241203144008.270700294@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit cddc04275f95ca3b18da5c0fb111705ac173af89 ]

Update of stateful object triggers:
WARNING: suspicious RCU usage
net/netfilter/nf_tables_api.c:7759 RCU-list traversed in non-reader section!!

other info that might help us debug this:
rcu_scheduler_active = 2, debug_locks = 1
1 lock held by nft/3060:
 #0: ffff88810f0578c8 (&nft_net->commit_mutex){+.+.}-{4:4}, [..]

... but this list is not protected by the transaction mutex but the
nfnl nftables subsystem mutex.

Switch to nft_obj_type_get which will acquire rcu read lock,
bump refcount, and returns the result.

v3: Dan Carpenter points out nft_obj_type_get returns error pointer, not
NULL, on error.

Fixes: dad3bdeef45f ("netfilter: nf_tables: fix memory leak during stateful obj update").
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a7a1913aa2917..f69e29917087a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7783,9 +7783,7 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 	struct nft_trans *trans;
 	int err = -ENOMEM;
 
-	if (!try_module_get(type->owner))
-		return -ENOENT;
-
+	/* caller must have obtained type->owner reference. */
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWOBJ,
 				sizeof(struct nft_trans_obj));
 	if (!trans)
@@ -7853,15 +7851,16 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 		if (info->nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
-		type = __nft_obj_type_get(objtype, family);
-		if (WARN_ON_ONCE(!type))
-			return -ENOENT;
-
 		if (!obj->ops->update)
 			return 0;
 
+		type = nft_obj_type_get(net, objtype, family);
+		if (WARN_ON_ONCE(IS_ERR(type)))
+			return PTR_ERR(type);
+
 		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
+		/* type->owner reference is put when transaction object is released. */
 		return nf_tables_updobj(&ctx, type, nla[NFTA_OBJ_DATA], obj);
 	}
 
-- 
2.43.0



