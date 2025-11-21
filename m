Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75C434EF00;
	Fri, 21 Nov 2025 13:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733424; cv=none; b=l72+vHCpP88iPmvRj0VfC5P/xo35xhOSa9xF82q2huc/FZ4JvAiqYChnT7P/GpDoSbriD06iDw3xSmfz9jc9cRaD4uuE2hUjgA6rBaAU4G5IbiNKYOymjtozeSonCMaIo8cSYn177fH3H/5tCGbKuwEtvnLBIrmjKI6yl4TLKJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733424; c=relaxed/simple;
	bh=cP+EtvAqhxgKt/cVfJoqdUmay9BA8b7epDabSZIbk8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gshE5D0TuGcZrpjcsgf0OoVLv3ZKKvbyuLRWKC3yU+AUBB5TQFnQAdElQxZClwg+KWwH2u6pvEg6cEzk/LEwy1Tt82c5mveCVfx+f/pi8v3/P3Ua0Vl4UaUJnSXbCpS+axcYf++V0AD9jNuEloaU3hpOXjp924vmIEnQk6P+0+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaIk9+Cy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaIk9+Cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2AAC116D0;
	Fri, 21 Nov 2025 13:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733424;
	bh=cP+EtvAqhxgKt/cVfJoqdUmay9BA8b7epDabSZIbk8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaIk9+CyAa3XbWZjgB9FpzfSaj6ClKjtFtxwLUSUq22+3PCXPMtB2SrW/JI2onA43
	 bDrQtgV0+aGOMEOkhyM1WIpwAkyRWLmGfxGWpXkzXvj6/GqlohYZmS4CVMF69OLEiB
	 zHzkyJMyXamU6xNuOUlnXJ3yTp1pB4eF6q0yLQdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 456/529] netfilter: nf_tables: reject duplicate device on updates
Date: Fri, 21 Nov 2025 14:12:35 +0100
Message-ID: <20251121130247.235309028@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit cf5fb87fcdaaaafec55dcc0dc5a9e15ead343973 upstream.

A chain/flowtable update with duplicated devices in the same batch is
possible. Unfortunately, netdev event path only removes the first
device that is found, leaving unregistered the hook of the duplicated
device.

Check if a duplicated device exists in the transaction batch, bail out
with EEXIST in such case.

WARNING is hit when unregistering the hook:

 [49042.221275] WARNING: CPU: 4 PID: 8425 at net/netfilter/core.c:340 nf_hook_entry_head+0xaa/0x150
 [49042.221375] CPU: 4 UID: 0 PID: 8425 Comm: nft Tainted: G S                  6.16.0+ #170 PREEMPT(full)
 [...]
 [49042.221382] RIP: 0010:nf_hook_entry_head+0xaa/0x150

Fixes: 78d9f48f7f44 ("netfilter: nf_tables: add devices to existing flowtable")
Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5ca1d775e976d..80443b4eaeff0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2576,6 +2576,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	struct nft_chain *chain = ctx->chain;
 	struct nft_chain_hook hook = {};
 	struct nft_stats *stats = NULL;
+	struct nftables_pernet *nft_net;
 	struct nft_hook *h, *next;
 	struct nf_hook_ops *ops;
 	struct nft_trans *trans;
@@ -2616,6 +2617,20 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 				if (nft_hook_list_find(&basechain->hook_list, h)) {
 					list_del(&h->list);
 					kfree(h);
+					continue;
+				}
+
+				nft_net = nft_pernet(ctx->net);
+				list_for_each_entry(trans, &nft_net->commit_list, list) {
+					if (trans->msg_type != NFT_MSG_NEWCHAIN ||
+					    trans->ctx.table != ctx->table ||
+					    !nft_trans_chain_update(trans))
+						continue;
+
+					if (nft_hook_list_find(&nft_trans_chain_hooks(trans), h)) {
+						nft_chain_release_hook(&hook);
+						return -EEXIST;
+					}
 				}
 			}
 		} else {
@@ -8493,6 +8508,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
+	struct nftables_pernet *nft_net;
 	struct nft_hook *hook, *next;
 	struct nft_trans *trans;
 	bool unregister = false;
@@ -8508,6 +8524,20 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		if (nft_hook_list_find(&flowtable->hook_list, hook)) {
 			list_del(&hook->list);
 			kfree(hook);
+			continue;
+		}
+
+		nft_net = nft_pernet(ctx->net);
+		list_for_each_entry(trans, &nft_net->commit_list, list) {
+			if (trans->msg_type != NFT_MSG_NEWFLOWTABLE ||
+			    trans->ctx.table != ctx->table ||
+			    !nft_trans_flowtable_update(trans))
+				continue;
+
+			if (nft_hook_list_find(&nft_trans_flowtable_hooks(trans), hook)) {
+				err = -EEXIST;
+				goto err_flowtable_update_hook;
+			}
 		}
 	}
 
-- 
2.51.0



