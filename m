Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705169;
	b=WA0jOIRiBdmajgIZRlGhfOgKTa9l5mzCSisnnKTapK7do05OCpbYTzsdw8lIcpLBYyVs
	 EnflsIbjpPmLoSBOBottkEiT/lOs3mk+HGswOkROxiv8H+OF8Nkqii5QtPXK98sKta8Pm
	 w34tDGX9MNmbyjihTrrYgcyVOrMi1VtJqOij0J/mpkiRgpgEIqcXmT0rdZDmnMVcGgEMm
	 LgMhHBdwV7+6HVCAMYZdar314hmdOS5t4pFtth5l7q5ZzxgVfMlB+DANzt0c9KQ4aSYdg
	 fhnE3YDIvdf1aC0MXwPTCQcDnZIqMC/j+Wyh5Oqf4OjH4jPBh/15LJZ+2YeEOpuiKVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8lLhlg/v7hTPcMThP3E0Zk8Xag5ndcoGThWRcnNJQM4=;
	b=vDhkMivEXJqWoTQrSTZYqUUXt4txqhfXSox5JwUVlJBbWceAMK8Bd9Ds7FrC3NnWQuiz
	 2kNSzdoIGkH6ljE1YKX9ioWDBJ+rqm18z1ppPYgRboxozFlWHs578JBftmy7xkhAP1xm4
	 iRNnWBe7cg1zYNxGaRneRJPywU4+wJfTdGGGWDO9q0vZoEUGTPYmDqMhdZFGb58ExWNU5
	 vKmK+qD0L6fRcuCAcF8QZRPyqceRDgHbkJkHOtgUYT2cSSsKUYu9k6Vg9928L5z5bz25f
	 ib1MXeS/ang9nLAf04mDxVoJJU57sx4E4nNX0IPwRc3MiqQ7Jsu+xZPUpdVrq3eBgOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qMJ/rbVh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C7E606A32D;
	Thu, 26 Nov 2026 14:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qMJ/rbVh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8527C1F000C4;
	Thu, 26 Nov 2026 14:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705168;
	bh=8lLhlg/v7hTPcMThP3E0Zk8Xag5ndcoGThWRcnNJQM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qMJ/rbVhSuqdkUyI8vNznoJ0Ry0CSviJfWRLeUWM6Kd59GUUQHNF/xoDaiAoZCGZr
	 cyto4TZPukbhLShX8B/NASkyUIcPWoFEPHN245pG8Y1jQzF/2TQnEyhkdDQYCX5EEz
	 YKgb9uKLEJoWoehzzBP/WXboMW+/7B0k94yJpbO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/319] netfilter: nf_tables: fix memleak when rule deletion fails with hardware offload
Date: Thu, 26 Nov 2026 15:37:54 +0100
Message-ID: <20261126144009.136186226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c12b2ded65193..fa258466b52c2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -521,16 +521,6 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
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
@@ -538,6 +528,14 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
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
 
@@ -3805,8 +3803,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
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
index 27907fa6f1571..6c91cba23d13e 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -147,6 +147,9 @@ void nft_flow_rule_destroy(struct nft_flow_rule *flow)
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



