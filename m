Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93551E871;
	Fri,  6 Dec 2024 15:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497225; cv=none; b=syLHIcr3APVm0gjglSg78lUC8i9heGPeb8Qye98yrhM09EE3oq4zKPpY3xQ4uiDylhZJ/WW9OP1lhPq95gAPdjPgKEM2n6uxvPYAeDljhTH0PWlm3WVceLjfTNDtJw4ceHgAXdHXeRlq3D+tJiNBM3UNNnkczh400axhRZYOs7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497225; c=relaxed/simple;
	bh=qdrhLGeDVEYeL+X6sVoIjM6/7cWPLn96gLYwz+UVvWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfceJw9CBexpZNusqvTg9WBXXMbGJAiyrB7h/OAKxJyZL5RMcyaROR4rIX8lTWph83AUYw224X5xxzAnjhgmnMJZ3+8GyiU2GHaR7dgQ7Ua9xLdem1uZY2mlt/1fx1CGRfUn7tOPEFK+77dmPfvSisbGnoLHRHknjjmLzhcCMNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIjUPnn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIjUPnn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460B7C4CED1;
	Fri,  6 Dec 2024 15:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497225;
	bh=qdrhLGeDVEYeL+X6sVoIjM6/7cWPLn96gLYwz+UVvWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIjUPnn+jgG2xh7KAb/NuHpTsvPYfKeFTLIPjmhlWtam2myBEspm621LRtfICRFp3
	 HbwU8rSgwhwZ2wEg4kO4wuyYeJZ2o4rgL7XOvvtg3MDNryQGqn8wvVQuZnzA6kBMTC
	 cAqnTORIHQRtnLJ5za9xQUdDKPIAvh87C7lQzStU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 230/676] netfilter: nf_tables: skip transaction if update object is not implemented
Date: Fri,  6 Dec 2024 15:30:49 +0100
Message-ID: <20241206143702.318666283@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 84b1a0c0140a9a92ea108576c0002210f224ce59 ]

Turn update into noop as a follow up for:

  9fedd894b4e1 ("netfilter: nf_tables: fix unexpected EOPNOTSUPP error")

instead of adding a transaction object which is simply discarded at a
later stage of the commit protocol.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: cddc04275f95 ("netfilter: nf_tables: must hold rcu read lock while iterating object type list")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5c4cd9646e71c..abab78148c6c8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7689,6 +7689,9 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 		if (WARN_ON_ONCE(!type))
 			return -ENOENT;
 
+		if (!obj->ops->update)
+			return 0;
+
 		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 		return nf_tables_updobj(&ctx, type, nla[NFTA_OBJ_DATA], obj);
@@ -9432,9 +9435,10 @@ static void nft_obj_commit_update(struct nft_trans *trans)
 	obj = nft_trans_obj(trans);
 	newobj = nft_trans_obj_newobj(trans);
 
-	if (obj->ops->update)
-		obj->ops->update(obj, newobj);
+	if (WARN_ON_ONCE(!obj->ops->update))
+		return;
 
+	obj->ops->update(obj, newobj);
 	nft_obj_destroy(&trans->ctx, newobj);
 }
 
-- 
2.43.0



