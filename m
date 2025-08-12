Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF77B27781E;
	Tue, 12 Aug 2025 19:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025946; cv=none; b=rd8hQWZwfECtfjhLDn4IhOU5CYky+ENNhSXwZhZE640XMJgnOxv1peBYqZhLUko90S+1CYylqYwDbBv1jv2uJMFnwckTawic3fCmDVYTR1onIAlSnscxKGT3fVbgGTsLznUoTVTqvJxEgUP/0g4Q+44zWRQ88BjJtkgeCosiOos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025946; c=relaxed/simple;
	bh=4QyvhCMXxU2bRBp7IsknWEDuwlGkUbu2DalJ1ZNr+NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prlCCdHZBwzxdifKZSZN8c2CbtSnNq3ecMtDv71kdvwpZRcunwoDgveHSbhDqy3xxQMLfSbdXfYWTXa3+XIVuzlxLMh89/SIWJd7CswIqBAYWepP0JJxver/yIC0UXCEGGt1kEGR6rEnXw//mYaD/8RKbqFd794leiTWfmvJQUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHPaPB45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHPaPB45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00CF1C4CEF0;
	Tue, 12 Aug 2025 19:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025945;
	bh=4QyvhCMXxU2bRBp7IsknWEDuwlGkUbu2DalJ1ZNr+NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHPaPB45nLF7EybXzheB/a2zlSC1cxrgYiX8YxPYdZu0qDLidVO8uxKaaBJU7xeSx
	 hrEIFVFtDdyX+gU3w1OdCt2hALFXTO52rt+IJRa6cnw8NgOGCtp7D14LEUV0Yhb7pG
	 nvwUv+vPo/G74cHa6vKsNQZ3sfcWQGr8dginB/Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 148/480] netfilter: nf_tables: Drop dead code from fill_*_info routines
Date: Tue, 12 Aug 2025 19:45:56 +0200
Message-ID: <20250812174403.614903328@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 8080357a8c6cf4905bbd8969412c19d34be3395e ]

This practically reverts commit 28339b21a365 ("netfilter: nf_tables: do
not send complete notification of deletions"): The feature was never
effective, due to prior modification of 'event' variable the conditional
early return never happened.

User space also relies upon the current behaviour, so better reintroduce
the shortened deletion notifications once it is fixed.

Fixes: 28339b21a365 ("netfilter: nf_tables: do not send complete notification of deletions")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a133e1c175ce..3eb000ae2f27 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1130,11 +1130,6 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 			 NFTA_TABLE_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELTABLE) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (nla_put_be32(skb, NFTA_TABLE_FLAGS,
 			 htonl(table->flags & NFT_TABLE_F_MASK)))
 		goto nla_put_failure;
@@ -1993,11 +1988,6 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 			 NFTA_CHAIN_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELCHAIN && !hook_list) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (nft_is_base_chain(chain)) {
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
 		struct nft_stats __percpu *stats;
@@ -4788,11 +4778,6 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			 NFTA_SET_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELSET) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (set->flags != 0)
 		if (nla_put_be32(skb, NFTA_SET_FLAGS, htonl(set->flags)))
 			goto nla_put_failure;
@@ -8276,11 +8261,6 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 			 NFTA_OBJ_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELOBJ) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
 	    nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
 	    nft_object_dump(skb, NFTA_OBJ_DATA, obj, reset))
@@ -9298,11 +9278,6 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 			 NFTA_FLOWTABLE_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELFLOWTABLE && !hook_list) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (nla_put_be32(skb, NFTA_FLOWTABLE_USE, htonl(flowtable->use)) ||
 	    nla_put_be32(skb, NFTA_FLOWTABLE_FLAGS, htonl(flowtable->data.flags)))
 		goto nla_put_failure;
-- 
2.39.5



