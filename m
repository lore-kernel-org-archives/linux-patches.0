Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618556;
	b=ZpqAl0hhtpOESlEJRQV95Ed5r2k4nueDB28/FHhk6TQQFaWKkuEhO4ncCU2rQZQKhzAX
	 LyM9dRoAX81cK6083ZIDaIIRaCWdPPUWte3/7J/pP5xW9c5wkQKSpdQkZHeZZE+yfW/pd
	 pu3U2Lm+pkqccxrvWLag2k8MNFJXKgdH5OzL82yFxIwgtEnVQmLjOKNW7CZWosEjTgmtR
	 4eUk9x321IvIgqdeSawQSdVxnaB9r030xCORPCNEQFliiA3MScxF7B89dq4DIeSL5f6DC
	 SSxchB8E8NGWkpkvAtEXXMKJifyVJIvakCRzy2UpvLe2aYJ23HEgUTDKoyULit3HpwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NBQZaCToXoqHHKFwZf2EpPaM92ZAT7xZHLffoaoS/Uo=;
	b=AxULKOJmczxmA6IDN1PlBxBF5CfQKLLlP9ONzOJ37wRdDYuRJ9P1lLbeWIfQR7PERs/R
	 TmTKT7Xm/dllNuHV+qXTzGEOhPc3cemDvRe5Z3KtTuoYamrTaozHDITlddxoCYzU41gB+
	 0Tjvw1GpoLBIJS1RJ3ka+hypne6I2rWc3Ww5NMYJZEh+F05CVD9h+Ws3UfX6ioTLm7NgX
	 rW+dLFkNIcPNGKKvh06Mp4zS7z1e6GCRov6IeipBVqu7KaO3V/OjoT3Ei8q7FP8547c3c
	 IuyP0HrBqSaVAqrhIbD2lhrZhdZZwlWXLJxQjWmWUo3wwHfcSKYQvfAHNIVA5arnIog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M4dSteV9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC60606A31E;
	Wed, 25 Nov 2026 14:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M4dSteV9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFB31F000C6;
	Wed, 25 Nov 2026 14:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618556;
	bh=NBQZaCToXoqHHKFwZf2EpPaM92ZAT7xZHLffoaoS/Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M4dSteV96nBZZDfpTW2NRCV3e9tVjDX6VBvgmX4c8kR25MdK5JWC0H5moeTgDu7Bm
	 zkBMDQXAVQRri40nKPqumuH7iQ5//kE5iPIXY5djBL8RiYjzQIxMMihTonenkUJZPa
	 NP+chng2h7uTNs6Taik27lPfE2gWdGKiQhEi2ZYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0318/1005] netfilter: nf_tables: fix memleak when rule deletion fails with hardware offload
Date: Wed, 25 Nov 2026 15:27:36 +0100
Message-ID: <20261125143829.186304924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b59628e6240c1..1322f37b96359 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -760,16 +760,6 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
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
@@ -777,6 +767,14 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
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
 
@@ -4536,8 +4534,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
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
index 0ac3c26dfb3d1..48b9e58e0c44f 100644
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



