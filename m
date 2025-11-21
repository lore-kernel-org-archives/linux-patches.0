Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9086B26560A;
	Fri, 21 Nov 2025 13:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731832; cv=none; b=Qv5olX6kl7K+puwog31r+ds72+FLGK4wB+gVEIbJR3oe2atePQsR0w4mEB9oCjPVSAv7VS/FcVYhX7qtjh1ptV6wV6w5zhBbMKowFqpy/vFN+j1c1qkEBffskHiiuRRhpsT5YhS/qFqe8PmDxiHSAKkt4UgBV3D3j8zTJPv6qvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731832; c=relaxed/simple;
	bh=qd07o7yjCDKL2QP7SHGEyXSiSQdGnPBZVc9Q5IYtCp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTJNyD4YPzx0ROAhJREjS1HSQrOJ9rQMWyqjtk2NFzy91Vz5vJSE5O0ghKWRBJne+ZYLfs+Zd2eM1oXQVqLsBhBdhPbpRuHAfIuPUUkzPWZICKmU7qNwGuTO9zf0UB55vlwycGGiqHXZxSlgI1K024YarBLe5+Nq/FcOE6q8KYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNq58utD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNq58utD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA2EC4CEF1;
	Fri, 21 Nov 2025 13:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731832;
	bh=qd07o7yjCDKL2QP7SHGEyXSiSQdGnPBZVc9Q5IYtCp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNq58utD1nFKsLToi6chxqxn+avEt+W4ZI+xpzThfinTcM2l67f4NYE+vS5tqSMYH
	 nkZkLoBJo2v3FkBCGnFT5QtW7Zfpo5OJw2cB8n+IaLlfwGJsUXPCAPWSe6sffHTMbs
	 mVl/pploFnyir97h97Qv0ij6X3WGMCFH0qNHS1Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/185] Revert "netfilter: nf_tables: Reintroduce shortened deletion notifications"
Date: Fri, 21 Nov 2025 14:12:04 +0100
Message-ID: <20251121130147.367182283@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

This is a partial revert of commit dbe85d3115c7e6b5124c8b028f4f602856ea51dd.

This update breaks old nftables userspace because monitor parser cannot
handle this shortened deletion, this patch was added as a Stable-dep:,
let's revert it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 36 ++---------------------------------
 1 file changed, 2 insertions(+), 34 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3028d388b2933..2f3684dcbef8c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1032,12 +1032,6 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 			 NFTA_TABLE_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELTABLE ||
-	    event == NFT_MSG_DESTROYTABLE) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (nla_put_be32(skb, NFTA_TABLE_FLAGS,
 			 htonl(table->flags & NFT_TABLE_F_MASK)))
 		goto nla_put_failure;
@@ -1893,13 +1887,6 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 			 NFTA_CHAIN_PAD))
 		goto nla_put_failure;
 
-	if (!hook_list &&
-	    (event == NFT_MSG_DELCHAIN ||
-	     event == NFT_MSG_DESTROYCHAIN)) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (nft_is_base_chain(chain)) {
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
 		struct nft_stats __percpu *stats;
@@ -4685,12 +4672,6 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			 NFTA_SET_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELSET ||
-	    event == NFT_MSG_DESTROYSET) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (set->flags != 0)
 		if (nla_put_be32(skb, NFTA_SET_FLAGS, htonl(set->flags)))
 			goto nla_put_failure;
@@ -8021,18 +8002,12 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 
 	if (nla_put_string(skb, NFTA_OBJ_TABLE, table->name) ||
 	    nla_put_string(skb, NFTA_OBJ_NAME, obj->key.name) ||
-	    nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
 	    nla_put_be64(skb, NFTA_OBJ_HANDLE, cpu_to_be64(obj->handle),
 			 NFTA_OBJ_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELOBJ ||
-	    event == NFT_MSG_DESTROYOBJ) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
-	if (nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
+	if (nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
+	    nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
 	    nft_object_dump(skb, NFTA_OBJ_DATA, obj, reset))
 		goto nla_put_failure;
 
@@ -9048,13 +9023,6 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 			 NFTA_FLOWTABLE_PAD))
 		goto nla_put_failure;
 
-	if (!hook_list &&
-	    (event == NFT_MSG_DELFLOWTABLE ||
-	     event == NFT_MSG_DESTROYFLOWTABLE)) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (nla_put_be32(skb, NFTA_FLOWTABLE_USE, htonl(flowtable->use)) ||
 	    nla_put_be32(skb, NFTA_FLOWTABLE_FLAGS, htonl(flowtable->data.flags)))
 		goto nla_put_failure;
-- 
2.51.0



