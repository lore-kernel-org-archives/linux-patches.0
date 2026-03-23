Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6DC36F414;
	Mon, 23 Mar 2026 14:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274866; cv=none; b=Rn0tiSbLLsGzT77TMrKyWuqthx7JhHJ9rFbVznNpXpDsXgbvNnnZc74GzoHcSDU0HuFt/svgbY0kW8HDKr1aBSZcT/vAFA/xp7rXZ0fPIVxTPzOanMkKvdCcwuBqj43LXTIa0ZnxqQ6cJKWmlMrWilJs1KsmqH3hspfcCWXO32I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274866; c=relaxed/simple;
	bh=PgUQlbcaj1LwktG9sniKIvuDMQOXLvmW5rCyy77MSVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tn1N9NWSMyJwSNdxMYw6hQ2ipjIfU0BkSaklUMsPnMn6xcqj77inGCeF9zcadX31rLrhABdRpwOEFlDuRfEq8T7lamrGOO1eRJQ+bDMh1rRKEeY7kasQU9XuyUWqYSEGgkA/abMso3b3NCCpV7U6OHTAFMdd6dKiG2OHLsuYU2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySqOjmOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySqOjmOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0EDC4CEF7;
	Mon, 23 Mar 2026 14:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274865;
	bh=PgUQlbcaj1LwktG9sniKIvuDMQOXLvmW5rCyy77MSVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySqOjmOQAigtDt6FD+56fZ7G9zAjILsh4543hMwcMNobDKAIh4M7rP5mNBu/1tvNr
	 LIS837QUSs42SBwSmi1Qg4xeHIGqSa5fQCT9gx2g8ctFO4jYAcgjQSsRH0TBGcrWgG
	 loe1HVUWzaT/VK8yTRXW05ktVXwyT9aWaD1Vl//4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gurpreet Shergill <giki.shergill@proton.me>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 137/212] nf_tables: nft_dynset: fix possible stateful expression memleak in error path
Date: Mon, 23 Mar 2026 14:45:58 +0100
Message-ID: <20260323134508.099907247@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 0548a13b5a145b16e4da0628b5936baf35f51b43 ]

If cloning the second stateful expression in the element via GFP_ATOMIC
fails, then the first stateful expression remains in place without being
released.

   unreferenced object (percpu) 0x607b97e9cab8 (size 16):
     comm "softirq", pid 0, jiffies 4294931867
     hex dump (first 16 bytes on cpu 3):
       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
     backtrace (crc 0):
       pcpu_alloc_noprof+0x453/0xd80
       nft_counter_clone+0x9c/0x190 [nf_tables]
       nft_expr_clone+0x8f/0x1b0 [nf_tables]
       nft_dynset_new+0x2cb/0x5f0 [nf_tables]
       nft_rhash_update+0x236/0x11c0 [nf_tables]
       nft_dynset_eval+0x11f/0x670 [nf_tables]
       nft_do_chain+0x253/0x1700 [nf_tables]
       nft_do_chain_ipv4+0x18d/0x270 [nf_tables]
       nf_hook_slow+0xaa/0x1e0
       ip_local_deliver+0x209/0x330

Fixes: 563125a73ac3 ("netfilter: nftables: generalize set extension to support for several expressions")
Reported-by: Gurpreet Shergill <giki.shergill@proton.me>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     |  4 ++--
 net/netfilter/nft_dynset.c        | 10 +++++++++-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c18cffafc9696..4dc080f7f27c6 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -875,6 +875,8 @@ struct nft_elem_priv *nft_set_elem_init(const struct nft_set *set,
 					u64 timeout, u64 expiration, gfp_t gfp);
 int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 			    struct nft_expr *expr_array[]);
+void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
+			       struct nft_set_elem_expr *elem_expr);
 void nft_set_elem_destroy(const struct nft_set *set,
 			  const struct nft_elem_priv *elem_priv,
 			  bool destroy_expr);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b6a575ec33159..0992869b33b35 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6863,8 +6863,8 @@ static void __nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
 	}
 }
 
-static void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
-				      struct nft_set_elem_expr *elem_expr)
+void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
+			       struct nft_set_elem_expr *elem_expr)
 {
 	struct nft_expr *expr;
 	u32 size;
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 7807d81296646..9123277be03ce 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -30,18 +30,26 @@ static int nft_dynset_expr_setup(const struct nft_dynset *priv,
 				 const struct nft_set_ext *ext)
 {
 	struct nft_set_elem_expr *elem_expr = nft_set_ext_expr(ext);
+	struct nft_ctx ctx = {
+		.net	= read_pnet(&priv->set->net),
+		.family	= priv->set->table->family,
+	};
 	struct nft_expr *expr;
 	int i;
 
 	for (i = 0; i < priv->num_exprs; i++) {
 		expr = nft_setelem_expr_at(elem_expr, elem_expr->size);
 		if (nft_expr_clone(expr, priv->expr_array[i], GFP_ATOMIC) < 0)
-			return -1;
+			goto err_out;
 
 		elem_expr->size += priv->expr_array[i]->ops->size;
 	}
 
 	return 0;
+err_out:
+	nft_set_elem_expr_destroy(&ctx, elem_expr);
+
+	return -1;
 }
 
 struct nft_elem_priv *nft_dynset_new(struct nft_set *set,
-- 
2.51.0



