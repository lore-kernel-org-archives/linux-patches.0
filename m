Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A23CD52B
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D4DC433EF;
	Mon, 15 May 2023 16:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168682;
	bh=JB23uzCAbfknN9simTygnA/gYysIzqI5SA8eGz3fLVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0qXww6WkugjvpntHFHLKRKDrq3IlpqmUkOSwOZFI3+ZLIw+SWA/u13NCbtOFRbYI
	 oBx99AxnXkeYcZR7VJIFrmZ7j2Hnd11yD5d/QdB2QQot9nNGzRq+nANupjZyj2FgJN
	 eYHIzrtUf2yvq5Gp0WDDDdW5MemZk8WwdffhC9NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 088/116] netfilter: nf_tables: deactivate anonymous set from preparation phase
Date: Mon, 15 May 2023 18:26:25 +0200
Message-Id: <20230515161701.199225306@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ backport for 4.14 of c1592a89942e9678f7d9c8030efa777c0d57edab ]

Toggle deleted anonymous sets as inactive in the next generation, so
users cannot perform any update on it. Clear the generation bitmask
in case the transaction is aborted.

The following KASAN splat shows a set element deletion for a bound
anonymous set that has been already removed in the same transaction.

[   64.921510] ==================================================================
[   64.923123] BUG: KASAN: wild-memory-access in nf_tables_commit+0xa24/0x1490 [nf_tables]
[   64.924745] Write of size 8 at addr dead000000000122 by task test/890
[   64.927903] CPU: 3 PID: 890 Comm: test Not tainted 6.3.0+ #253
[   64.931120] Call Trace:
[   64.932699]  <TASK>
[   64.934292]  dump_stack_lvl+0x33/0x50
[   64.935908]  ? nf_tables_commit+0xa24/0x1490 [nf_tables]
[   64.937551]  kasan_report+0xda/0x120
[   64.939186]  ? nf_tables_commit+0xa24/0x1490 [nf_tables]
[   64.940814]  nf_tables_commit+0xa24/0x1490 [nf_tables]
[   64.942452]  ? __kasan_slab_alloc+0x2d/0x60
[   64.944070]  ? nf_tables_setelem_notify+0x190/0x190 [nf_tables]
[   64.945710]  ? kasan_set_track+0x21/0x30
[   64.947323]  nfnetlink_rcv_batch+0x709/0xd90 [nfnetlink]
[   64.948898]  ? nfnetlink_rcv_msg+0x480/0x480 [nfnetlink]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 12 ++++++++++++
 net/netfilter/nft_dynset.c        |  2 +-
 net/netfilter/nft_lookup.c        |  2 +-
 net/netfilter/nft_objref.c        |  2 +-
 5 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index fe56b2f825b4e..2db486e9724c6 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -462,6 +462,7 @@ struct nft_set_binding {
 };
 
 enum nft_trans_phase;
+void nf_tables_activate_set(const struct nft_ctx *ctx, struct nft_set *set);
 void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      struct nft_set_binding *binding,
 			      enum nft_trans_phase phase);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2f5b5d563e4d1..c683a45b8ae53 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3420,12 +3420,24 @@ void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 }
 EXPORT_SYMBOL_GPL(nf_tables_unbind_set);
 
+void nf_tables_activate_set(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	if (set->flags & NFT_SET_ANONYMOUS)
+		nft_clear(ctx->net, set);
+
+	set->use++;
+}
+EXPORT_SYMBOL_GPL(nf_tables_activate_set);
+
 void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      struct nft_set_binding *binding,
 			      enum nft_trans_phase phase)
 {
 	switch (phase) {
 	case NFT_TRANS_PREPARE:
+		if (set->flags & NFT_SET_ANONYMOUS)
+			nft_deactivate_next(ctx->net, set);
+
 		set->use--;
 		return;
 	case NFT_TRANS_ABORT:
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index a20f1668328dc..74e8fdaa34321 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -237,7 +237,7 @@ static void nft_dynset_activate(const struct nft_ctx *ctx,
 {
 	struct nft_dynset *priv = nft_expr_priv(expr);
 
-	priv->set->use++;
+	nf_tables_activate_set(ctx, priv->set);
 }
 
 static void nft_dynset_destroy(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 453f84c571662..4fcbe51e88c76 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -132,7 +132,7 @@ static void nft_lookup_activate(const struct nft_ctx *ctx,
 {
 	struct nft_lookup *priv = nft_expr_priv(expr);
 
-	priv->set->use++;
+	nf_tables_activate_set(ctx, priv->set);
 }
 
 static void nft_lookup_destroy(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 7e628f4f02b93..49a067a67e723 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -168,7 +168,7 @@ static void nft_objref_map_activate(const struct nft_ctx *ctx,
 {
 	struct nft_objref_map *priv = nft_expr_priv(expr);
 
-	priv->set->use++;
+	nf_tables_activate_set(ctx, priv->set);
 }
 
 static void nft_objref_map_destroy(const struct nft_ctx *ctx,
-- 
2.39.2



