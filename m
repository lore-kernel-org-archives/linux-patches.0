Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66382E7379;
	Sat, 30 May 2026 17:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162832; cv=none; b=fz5r02ABn/FeK4mot44TJLgzIHPrkUs5+ABuGXs+P4TvK2YSRNBzmvG8+E14USnL2p6rWmXpJWkHn7GhEKoejsahY5yWPwVY7QuOvC8R9ueM5JPUPBgYyXLwBzb2Xm6CK6PS4Y+4Nz0xvaJb6GdkrtN7CB7TX1hb4kDBW5fEKm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162832; c=relaxed/simple;
	bh=alpNI7+XD2GUpYRQDzGrhkoW2gHPIrS+OMXiLpQ4fJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OVTRXsgKvbNSmD7IBGM4cEAjhBlAFYpYb/ufKby73TjUjb5mi9FNu5FdrtzzwqTjrIo436eECg0QhNdb1AfEEF50dTEoTXXeZvS4qpYP+GSwnrQGfC1ExyyGE2cv9f1q2P+Cc6c/SATQfpDi5VVuKVnUTJQS2W0qQv45TRHHGEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugZhCUzx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugZhCUzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340051F00893;
	Sat, 30 May 2026 17:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162831;
	bh=d7y2+Z7s3fUzBxFQ5Eo289jifX2hzBnDkdAm59NTvgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ugZhCUzx0RpH2u7RDQY8VxdPdcxAHGbSU3fk2flZ06CPbZ3G03oIq1bbFrxDlMEMM
	 9xWNaBGejiCzu5s61LRcPzD+rt/HNgi37XDDy45Tue7LJgJY9l7+ilBgTjIGuBldYU
	 WDrEQFsr1F7aK0HASzetlGoSY1W/3a0JsDecCu8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gurpreet Shergill <giki.shergill@proton.me>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Li hongliang <1468888505@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/776] nf_tables: nft_dynset: fix possible stateful expression memleak in error path
Date: Sat, 30 May 2026 17:56:31 +0200
Message-ID: <20260530160242.315965059@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Minor conflict resolved. ]
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     |  4 ++--
 net/netfilter/nft_dynset.c        | 10 +++++++++-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9f68155e054cf..2b977d5d6f30f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -821,6 +821,8 @@ void *nft_set_elem_init(const struct nft_set *set,
 			u64 timeout, u64 expiration, gfp_t gfp);
 int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 			    struct nft_expr *expr_array[]);
+void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
+			       struct nft_set_elem_expr *elem_expr);
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 			  bool destroy_expr);
 void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 53d7dd39a95bc..623b776bf7926 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5919,8 +5919,8 @@ static void __nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
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
index ecdd4a60db9c5..673c5e6a3e8d6 100644
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
 
 static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
-- 
2.53.0



