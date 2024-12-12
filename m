Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04E921B91D;
	Thu, 12 Dec 2024 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015790; cv=none; b=hRY8xnT8pjvmGUG8gOGpbObeaV80H7bqWTgHGJCR5ihmcXMxzoPIdJ3KwNXfdOoR8verjlI6fw76ujeYRECD57MByKTN8QjC9dbFPWRwyRUKYwC1414Vm8v9YOSRDW9TKsHHROuW3ZgXObvETOdSej16oFs+1Lnr3SqMB7cVWNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015790; c=relaxed/simple;
	bh=mCWAr/B2JCgzUCeQ1WQYX4CnXSbwXR/9Awe1bWAr1rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbIzdxBky/lX1/X+u8gj+oqwk1n11APIZsx/rYwhg78pFB0O1Hoe8silQGHPHWVOrH4jyZgKerJw9yr+b2jP8xyLme/USmP3vwj6mmZzsdzzHS8IO8AkVomT2vRyrS5uk3U9Rr0H5kjDocS4a5P2Js+SydJ5xb4DP+P1dyfdn/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOkh/yLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOkh/yLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8262C4CEE1;
	Thu, 12 Dec 2024 15:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015790;
	bh=mCWAr/B2JCgzUCeQ1WQYX4CnXSbwXR/9Awe1bWAr1rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MOkh/yLbQn8kfZMYBOpOkJeQTg8X1SNik0cjkf2EECt3GJ55PQt0R0Mwjv5em64S3
	 C/ia7FqX5123npEohlpyQAAJpxcTvS7T1amA5GwC65Ma9KWoaWoA4zzFKzhSGnU8CF
	 zNc/FVSQ7kKRJIqXQboUDdZY3mILLy91Tb3C46L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+84d0441b9860f0d63285@syzkaller.appspotmail.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/466] netfilter: nft_inner: incorrect percpu area handling under softirq
Date: Thu, 12 Dec 2024 15:53:34 +0100
Message-ID: <20241212144308.468051126@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 7b1d83da254be3bf054965c8f3b1ad976f460ae5 ]

Softirq can interrupt ongoing packet from process context that is
walking over the percpu area that contains inner header offsets.

Disable bh and perform three checks before restoring the percpu inner
header offsets to validate that the percpu area is valid for this
skbuff:

1) If the NFT_PKTINFO_INNER_FULL flag is set on, then this skbuff
   has already been parsed before for inner header fetching to
   register.

2) Validate that the percpu area refers to this skbuff using the
   skbuff pointer as a cookie. If there is a cookie mismatch, then
   this skbuff needs to be parsed again.

3) Finally, validate if the percpu area refers to this tunnel type.

Only after these three checks the percpu area is restored to a on-stack
copy and bh is enabled again.

After inner header fetching, the on-stack copy is stored back to the
percpu area.

Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
Reported-by: syzbot+84d0441b9860f0d63285@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables_core.h |  1 +
 net/netfilter/nft_inner.c              | 57 ++++++++++++++++++++------
 2 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index ff27cb2e16620..03b6165756fc5 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -161,6 +161,7 @@ enum {
 };
 
 struct nft_inner_tun_ctx {
+	unsigned long cookie;
 	u16	type;
 	u16	inner_tunoff;
 	u16	inner_lloff;
diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index 928312d01eb1d..817ab978d24a1 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -210,35 +210,66 @@ static int nft_inner_parse(const struct nft_inner *priv,
 			   struct nft_pktinfo *pkt,
 			   struct nft_inner_tun_ctx *tun_ctx)
 {
-	struct nft_inner_tun_ctx ctx = {};
 	u32 off = pkt->inneroff;
 
 	if (priv->flags & NFT_INNER_HDRSIZE &&
-	    nft_inner_parse_tunhdr(priv, pkt, &ctx, &off) < 0)
+	    nft_inner_parse_tunhdr(priv, pkt, tun_ctx, &off) < 0)
 		return -1;
 
 	if (priv->flags & (NFT_INNER_LL | NFT_INNER_NH)) {
-		if (nft_inner_parse_l2l3(priv, pkt, &ctx, off) < 0)
+		if (nft_inner_parse_l2l3(priv, pkt, tun_ctx, off) < 0)
 			return -1;
 	} else if (priv->flags & NFT_INNER_TH) {
-		ctx.inner_thoff = off;
-		ctx.flags |= NFT_PAYLOAD_CTX_INNER_TH;
+		tun_ctx->inner_thoff = off;
+		tun_ctx->flags |= NFT_PAYLOAD_CTX_INNER_TH;
 	}
 
-	*tun_ctx = ctx;
 	tun_ctx->type = priv->type;
+	tun_ctx->cookie = (unsigned long)pkt->skb;
 	pkt->flags |= NFT_PKTINFO_INNER_FULL;
 
 	return 0;
 }
 
+static bool nft_inner_restore_tun_ctx(const struct nft_pktinfo *pkt,
+				      struct nft_inner_tun_ctx *tun_ctx)
+{
+	struct nft_inner_tun_ctx *this_cpu_tun_ctx;
+
+	local_bh_disable();
+	this_cpu_tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx);
+	if (this_cpu_tun_ctx->cookie != (unsigned long)pkt->skb) {
+		local_bh_enable();
+		return false;
+	}
+	*tun_ctx = *this_cpu_tun_ctx;
+	local_bh_enable();
+
+	return true;
+}
+
+static void nft_inner_save_tun_ctx(const struct nft_pktinfo *pkt,
+				   const struct nft_inner_tun_ctx *tun_ctx)
+{
+	struct nft_inner_tun_ctx *this_cpu_tun_ctx;
+
+	local_bh_disable();
+	this_cpu_tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx);
+	if (this_cpu_tun_ctx->cookie != tun_ctx->cookie)
+		*this_cpu_tun_ctx = *tun_ctx;
+	local_bh_enable();
+}
+
 static bool nft_inner_parse_needed(const struct nft_inner *priv,
 				   const struct nft_pktinfo *pkt,
-				   const struct nft_inner_tun_ctx *tun_ctx)
+				   struct nft_inner_tun_ctx *tun_ctx)
 {
 	if (!(pkt->flags & NFT_PKTINFO_INNER_FULL))
 		return true;
 
+	if (!nft_inner_restore_tun_ctx(pkt, tun_ctx))
+		return true;
+
 	if (priv->type != tun_ctx->type)
 		return true;
 
@@ -248,27 +279,29 @@ static bool nft_inner_parse_needed(const struct nft_inner *priv,
 static void nft_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
 			   const struct nft_pktinfo *pkt)
 {
-	struct nft_inner_tun_ctx *tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx);
 	const struct nft_inner *priv = nft_expr_priv(expr);
+	struct nft_inner_tun_ctx tun_ctx = {};
 
 	if (nft_payload_inner_offset(pkt) < 0)
 		goto err;
 
-	if (nft_inner_parse_needed(priv, pkt, tun_ctx) &&
-	    nft_inner_parse(priv, (struct nft_pktinfo *)pkt, tun_ctx) < 0)
+	if (nft_inner_parse_needed(priv, pkt, &tun_ctx) &&
+	    nft_inner_parse(priv, (struct nft_pktinfo *)pkt, &tun_ctx) < 0)
 		goto err;
 
 	switch (priv->expr_type) {
 	case NFT_INNER_EXPR_PAYLOAD:
-		nft_payload_inner_eval((struct nft_expr *)&priv->expr, regs, pkt, tun_ctx);
+		nft_payload_inner_eval((struct nft_expr *)&priv->expr, regs, pkt, &tun_ctx);
 		break;
 	case NFT_INNER_EXPR_META:
-		nft_meta_inner_eval((struct nft_expr *)&priv->expr, regs, pkt, tun_ctx);
+		nft_meta_inner_eval((struct nft_expr *)&priv->expr, regs, pkt, &tun_ctx);
 		break;
 	default:
 		WARN_ON_ONCE(1);
 		goto err;
 	}
+	nft_inner_save_tun_ctx(pkt, &tun_ctx);
+
 	return;
 err:
 	regs->verdict.code = NFT_BREAK;
-- 
2.43.0



