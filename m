Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10643F9D2;
	Tue, 12 Aug 2025 18:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022249; cv=none; b=qet/BRUN0MrGoM57Gm+V+YFGSdE9/rWmrp9DLpPJY9jpbbDieD7+OhxMcodiWdEwvtHmSOl8Ecq+5wB7ImIuDVWV/yhPztoxdyfmD1oFQoty5ImgO8c6YwJ2bPr3qkIpCzy5IgkvKpoM6umIUBp1hhxLzN+TLmGK4QXJDQyrHUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022249; c=relaxed/simple;
	bh=oG1DlPEPdAPwgWnJF55DdF68D2suQyEZ7slJG/yQsuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afZ7hNLh0PuHK148W/s8TeC0kPAjYG0qC4Y2Z7L06vPpbmriGL7BxlveJKXBMNZmMDcn/lTOvLM2fxfHAmTEqkXhYpLpxqdFofpFedgJ/k6YSSuBqF/lM9TR5BoHqg2jikkcPMJhg5TBD7yk0l9nA0C5cvN6z5ObB/pm6lGSRjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6kIEmTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6kIEmTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF06CC4CEF0;
	Tue, 12 Aug 2025 18:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022249;
	bh=oG1DlPEPdAPwgWnJF55DdF68D2suQyEZ7slJG/yQsuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6kIEmTpyNSz2D3/VWdddXurO3d/4DKV9b6+dIagVlNisjIOkTsH+XieJyFV1DjVo
	 /1zvv9L+QJM+uHxBObtU6T+w0kd4Av8ttaE4+6HinT2uMH0s1eJwszZcry5PsdmXsq
	 K4tP349zlMRHUIpcSORlQjWRj92sxqAKNbouEV+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/369] netfilter: nf_tables: Drop dead code from fill_*_info routines
Date: Tue, 12 Aug 2025 19:26:35 +0200
Message-ID: <20250812173018.467787569@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bdee187bc5dd..8077bf0378bb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1029,11 +1029,6 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
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
@@ -1889,11 +1884,6 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
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
@@ -4678,11 +4668,6 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
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
@@ -8017,11 +8002,6 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
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
@@ -9040,11 +9020,6 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
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



