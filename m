Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621643;
	b=30VvgsfVEQ3KiirH6nOtr2rH5kg9gJt0d0KR7DojqLMBU63xyCkFPDMOGfvKk3peuLMT
	 WFXMnJ803B4Uhh7UpNsnJk63vlT7xU0sq3w2UJTZH+x0yUVyqtFKgt9bEAzreMxQJzK1k
	 pDMaA/NBYWDdBbx4N6IpDLXocRtkYh5dso21TRylBuv19/YKXbRodAwNZWCBktax0c+CN
	 lR3i8ceob+NzAHe+9pXUUjFJ69ZisRJ9hDPPbGx6id/eaiZqjl8JpeZ7mzh9dJtNCPHb0
	 Tt+asEFYiOycIn1DYMiAC3OQQk6U0sfSh7egGd7oDd/mim6PU4sIm3TMaODQABOIkTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UXxL7QbCEu7y4jH5gMS59ZUdATGssMjMVnZWOx9e/ug=;
	b=v01AxytQMI4KUOt/SrLJUvnoTsq8pvjh7d1dOQwrE7Yf3fKejBLSCUQON9T+vT4RLXYV
	 oGOkEw0ZLrObzr/nkZAREQxJb0eQV5Np9dXOYhWfCljFiAD390zy3qtgvBA9UlAY8kKFV
	 mzJ13yldTGrB8SXWrmMej4y5rsz49cUuazT3segF1mZrH1DYENLOQvR72dtjpXRYfLb1r
	 0JYrE4Ubj+PpxRpURf0yOxXLdzwv5DlT1WiCiDz9D+ZIk6pmMLPpmkN8Lo1pTV342WHbd
	 zCg1etiE9MWucU1RwmQvTEpRr2BcXm0QTlbksCnOmoq7E2Zg6uG9uE/bywYmQThLayA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMtwyl3E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDFA606A330;
	Wed, 25 Nov 2026 15:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMtwyl3E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13451F000E0;
	Wed, 25 Nov 2026 15:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621642;
	bh=UXxL7QbCEu7y4jH5gMS59ZUdATGssMjMVnZWOx9e/ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMtwyl3EUOZmob5A1M7qbDkzx3Xb/FwAvzWWPe8VkMOtTmqa7x/YOSqL3TdRrz0vQ
	 6ptypvJfUPxjb+cv/HOQgKP0rCvYqpaPXJlefrQFHrJWw5vPQnCnHn7zAXg1ThlFTs
	 0YNJdNsAohliuIOCURquypB4x/xcpkuqgul49FsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 289/990] netfilter: nf_tables: fix memleak when rule deletion fails with hardware offload
Date: Wed, 25 Nov 2026 15:27:36 +0100
Message-ID: <20261125143828.858052143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit e95b3be75ae0652d40a48a210f0cf5197b3b3783 ]

Allocate flow rule object after transaction has been allocation and rule
deactivation has been performed, otherwise memleak is possible.  Let the
transaction unwind the existing rule deactivation from the abort path,
this needs to update nft_flow_rule_destroy() to skip release if
flow_rule is null.

While at this, remove check for non-null flow_rule in newrule error path
now that nft_flow_rule_destroy() is skipped if flow_rule is null.

Fixes: 63b48c73ff56 ("netfilter: nf_tables_offload: undo updates if transaction fails")
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Link: https://patch.msgid.link/20261028062204.1079089-1-hdthky0@gmail.com/
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c     | 21 +++++++++------------
 net/netfilter/nf_tables_offload.c |  3 +++
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 76876761698eb..a248dc75c5a0a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -754,16 +754,6 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
 	if (trans == NULL)
 		return -ENOMEM;
 
-	if (ctx->chain->flags & NFT_CHAIN_HW_OFFLOAD) {
-		flow = nft_flow_rule_create(ctx->net, rule);
-		if (IS_ERR(flow)) {
-			nft_trans_destroy(trans);
-			return PTR_ERR(flow);
-		}
-
-		nft_trans_flow_rule(trans) = flow;
-	}
-
 	err = nf_tables_delrule_deactivate(ctx, rule);
 	if (err < 0) {
 		nft_trans_destroy(trans);
@@ -771,6 +761,14 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
 	}
 	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_PREPARE);
 
+	if (ctx->chain->flags & NFT_CHAIN_HW_OFFLOAD) {
+		flow = nft_flow_rule_create(ctx->net, rule);
+		if (IS_ERR(flow))
+			return PTR_ERR(flow);
+
+		nft_trans_flow_rule(trans) = flow;
+	}
+
 	return 0;
 }
 
@@ -4527,8 +4525,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 err_destroy_flow_rule:
 	nft_use_dec_restore(&chain->use);
 err_destroy_flow:
-	if (flow)
-		nft_flow_rule_destroy(flow);
+	nft_flow_rule_destroy(flow);
 err_release_rule:
 	nft_rule_expr_deactivate(&ctx, rule, NFT_TRANS_PREPARE_ERROR);
 	nf_tables_rule_destroy(&ctx, rule);
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 933a17d0f2513..853094a300c24 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -148,6 +148,9 @@ void nft_flow_rule_destroy(struct nft_flow_rule *flow)
 	struct flow_action_entry *entry;
 	int i;
 
+	if (!flow)
+		return;
+
 	flow_action_for_each(i, entry, &flow->rule->action) {
 		switch (entry->id) {
 		case FLOW_ACTION_REDIRECT:
-- 
2.53.0



