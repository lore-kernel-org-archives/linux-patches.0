Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C793F23EAB2;
	Mon, 23 Mar 2026 14:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277318; cv=none; b=Rv4vJXfmCj9XfJ1C7oq3qnUy0Ch6OP+/HIZdG05U3BW47kfaGDfja+uBn9anSlNlyzfgXiAwfPm6ZOgBiAuNigm8hjb7PZuaC8xJDZ0sbkRS0RR1cPuHVg2q2/G7w7ye5AIFthlOXIeqtEURnMwOmbMFcQiBZsvaUq0nfzOAx0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277318; c=relaxed/simple;
	bh=uOstY6/NXepb3Wi+We2dwtEYGu0UI2xxRuha0LiGDLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FBNwbBcOrbm5ZfyjVOWFprIR/bXTq8Rli1cgIsIyeXCRtinT3REHJXXud7B8tekdMNQuQIlbMa5mdj1R7ICpyCu2jWEyc4dZQV+mPDsmx40LUD+55+Po80MGReySkX58SMe9w22NNm83/OxNhL5rK9f5WRlbOW3nBWodLuoZO4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ReekarNB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ReekarNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5688DC4CEF7;
	Mon, 23 Mar 2026 14:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277318;
	bh=uOstY6/NXepb3Wi+We2dwtEYGu0UI2xxRuha0LiGDLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ReekarNBwDO4VbpCyjxw2asIH22xE74PsAV/5XhfkL5XQkhFsQ+fxLry2vzgmVcn8
	 /JFzsqEmG4iI8pBn5oybBd1MVUca6veADbMcwaZVD4stviKpgV+iUkWd4tVOTMZ2MQ
	 HqQy+0ZWFabiiJtp4qsikBVt6jeHcjK5EVlwEHOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gurpreet Shergill <giki.shergill@proton.me>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 396/460] nf_tables: nft_dynset: fix possible stateful expression memleak in error path
Date: Mon, 23 Mar 2026 14:46:32 +0100
Message-ID: <20260323134536.298471193@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 79296ed87b9b3..36964b86d336d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -873,6 +873,8 @@ struct nft_elem_priv *nft_set_elem_init(const struct nft_set *set,
 					u64 timeout, u64 expiration, gfp_t gfp);
 int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 			    struct nft_expr *expr_array[]);
+void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
+			       struct nft_set_elem_expr *elem_expr);
 void nft_set_elem_destroy(const struct nft_set *set,
 			  const struct nft_elem_priv *elem_priv,
 			  bool destroy_expr);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 268d00ffee0cb..0c12560e94f3b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6637,8 +6637,8 @@ static void __nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
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
index e24493d9e7761..0b3c4f6a8decd 100644
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
 
 static struct nft_elem_priv *nft_dynset_new(struct nft_set *set,
-- 
2.51.0



