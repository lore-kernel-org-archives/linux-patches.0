Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD4E3BF2E8;
	Thu, 15 Jan 2026 16:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496359; cv=none; b=sBoynh6mQ0IylX/e4Wi+Tr5ciaPBsv3YfAMXS4TMDQbDIKT4iNziu5M6JnlByFAR3n38ak3gM9gwIAQcbAXeux+Yx5e/9g1QX11liBBQOsHNU4Obk/KIZlI22JO397pQK5dPF9mvSp/QoMaH8WoRCikYO3jfjw6qvXcGHPuh8wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496359; c=relaxed/simple;
	bh=HAtqh0N0LSoSXbmiuNj1myF4cEx00QUyUqws823TrEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvasUKK0u2KkepmBSdY/nTMA5227RD+ahtoP+dLxY9RzSiuy0cfNQgtvd7UHTXL2LGGxvZ2PjrqPi2q87iv16Lo25BTP91d5FYJyN8KG1iYxTh50+4CJzdO0tj126X9L6il/I4OtbYDhQu2c5+uz0KMnf9hANzIIGaD9VxvjTFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRd7+qtw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRd7+qtw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C10C16AAE;
	Thu, 15 Jan 2026 16:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496358;
	bh=HAtqh0N0LSoSXbmiuNj1myF4cEx00QUyUqws823TrEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRd7+qtwKWeKy7nCfKrNKLf0Vnd8eIMl8filPLt9o/cbPjBvWaqq4M/shIOsAKhZc
	 bAO3OV4uFbeRimJP80WIT3D3U9d8g23L6bpMtA4QiR/4ruLTo92ufGxRL26LEopG0x
	 elOcrPVC4Y4p8smwRlxf/k/ZHZOdoMUM/6mz3dXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 168/181] netfilter: nf_tables: avoid chain re-validation if possible
Date: Thu, 15 Jan 2026 17:48:25 +0100
Message-ID: <20260115164208.378899953@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 8e1a1bc4f5a42747c08130b8242ebebd1210b32f ]

Hamza Mahfooz reports cpu soft lock-ups in
nft_chain_validate():

 watchdog: BUG: soft lockup - CPU#1 stuck for 27s! [iptables-nft-re:37547]
[..]
 RIP: 0010:nft_chain_validate+0xcb/0x110 [nf_tables]
[..]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_table_validate+0x6b/0xb0 [nf_tables]
  nf_tables_validate+0x8b/0xa0 [nf_tables]
  nf_tables_commit+0x1df/0x1eb0 [nf_tables]
[..]

Currently nf_tables will traverse the entire table (chain graph), starting
from the entry points (base chains), exploring all possible paths
(chain jumps).  But there are cases where we could avoid revalidation.

Consider:
1  input -> j2 -> j3
2  input -> j2 -> j3
3  input -> j1 -> j2 -> j3

Then the second rule does not need to revalidate j2, and, by extension j3,
because this was already checked during validation of the first rule.
We need to validate it only for rule 3.

This is needed because chain loop detection also ensures we do not exceed
the jump stack: Just because we know that j2 is cycle free, its last jump
might now exceed the allowed stack size.  We also need to update all
reachable chains with the new largest observed call depth.

Care has to be taken to revalidate even if the chain depth won't be an
issue: chain validation also ensures that expressions are not called from
invalid base chains.  For example, the masquerade expression can only be
called from NAT postrouting base chains.

Therefore we also need to keep record of the base chain context (type,
hooknum) and revalidate if the chain becomes reachable from a different
hook location.

Reported-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Closes: https://lore.kernel.org/netfilter-devel/20251118221735.GA5477@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net/
Tested-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h | 34 +++++++++++----
 net/netfilter/nf_tables_api.c     | 69 +++++++++++++++++++++++++++++--
 2 files changed, 91 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index fab7dc73f738c..0e266c2d0e7f0 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1091,6 +1091,29 @@ struct nft_rule_blob {
 		__attribute__((aligned(__alignof__(struct nft_rule_dp))));
 };
 
+enum nft_chain_types {
+	NFT_CHAIN_T_DEFAULT = 0,
+	NFT_CHAIN_T_ROUTE,
+	NFT_CHAIN_T_NAT,
+	NFT_CHAIN_T_MAX
+};
+
+/**
+ *	struct nft_chain_validate_state - validation state
+ *
+ *	If a chain is encountered again during table validation it is
+ *	possible to avoid revalidation provided the calling context is
+ *	compatible.  This structure stores relevant calling context of
+ *	previous validations.
+ *
+ *	@hook_mask: the hook numbers and locations the chain is linked to
+ *	@depth: the deepest call chain level the chain is linked to
+ */
+struct nft_chain_validate_state {
+	u8			hook_mask[NFT_CHAIN_T_MAX];
+	u8			depth;
+};
+
 /**
  *	struct nft_chain - nf_tables chain
  *
@@ -1109,6 +1132,7 @@ struct nft_rule_blob {
  *	@udlen: user data length
  *	@udata: user data in the chain
  *	@blob_next: rule blob pointer to the next in the chain
+ *	@vstate: validation state
  */
 struct nft_chain {
 	struct nft_rule_blob		__rcu *blob_gen_0;
@@ -1128,9 +1152,10 @@ struct nft_chain {
 
 	/* Only used during control plane commit phase: */
 	struct nft_rule_blob		*blob_next;
+	struct nft_chain_validate_state vstate;
 };
 
-int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain);
+int nft_chain_validate(const struct nft_ctx *ctx, struct nft_chain *chain);
 int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 			 const struct nft_set_iter *iter,
 			 struct nft_elem_priv *elem_priv);
@@ -1138,13 +1163,6 @@ int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
 int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 
-enum nft_chain_types {
-	NFT_CHAIN_T_DEFAULT = 0,
-	NFT_CHAIN_T_ROUTE,
-	NFT_CHAIN_T_NAT,
-	NFT_CHAIN_T_MAX
-};
-
 /**
  * 	struct nft_chain_type - nf_tables chain type info
  *
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a3669acd68a32..3cbf2573b9e90 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -123,6 +123,29 @@ static void nft_validate_state_update(struct nft_table *table, u8 new_validate_s
 
 	table->validate_state = new_validate_state;
 }
+
+static bool nft_chain_vstate_valid(const struct nft_ctx *ctx,
+				   const struct nft_chain *chain)
+{
+	const struct nft_base_chain *base_chain;
+	enum nft_chain_types type;
+	u8 hooknum;
+
+	if (WARN_ON_ONCE(!nft_is_base_chain(ctx->chain)))
+		return false;
+
+	base_chain = nft_base_chain(ctx->chain);
+	hooknum = base_chain->ops.hooknum;
+	type = base_chain->type->type;
+
+	/* chain is already validated for this call depth */
+	if (chain->vstate.depth >= ctx->level &&
+	    chain->vstate.hook_mask[type] & BIT(hooknum))
+		return true;
+
+	return false;
+}
+
 static void nf_tables_trans_destroy_work(struct work_struct *w);
 
 static void nft_trans_gc_work(struct work_struct *work);
@@ -4079,6 +4102,29 @@ static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *r
 	nf_tables_rule_destroy(ctx, rule);
 }
 
+static void nft_chain_vstate_update(const struct nft_ctx *ctx, struct nft_chain *chain)
+{
+	const struct nft_base_chain *base_chain;
+	enum nft_chain_types type;
+	u8 hooknum;
+
+	/* ctx->chain must hold the calling base chain. */
+	if (WARN_ON_ONCE(!nft_is_base_chain(ctx->chain))) {
+		memset(&chain->vstate, 0, sizeof(chain->vstate));
+		return;
+	}
+
+	base_chain = nft_base_chain(ctx->chain);
+	hooknum = base_chain->ops.hooknum;
+	type = base_chain->type->type;
+
+	BUILD_BUG_ON(BIT(NF_INET_NUMHOOKS) > U8_MAX);
+
+	chain->vstate.hook_mask[type] |= BIT(hooknum);
+	if (chain->vstate.depth < ctx->level)
+		chain->vstate.depth = ctx->level;
+}
+
 /** nft_chain_validate - loop detection and hook validation
  *
  * @ctx: context containing call depth and base chain
@@ -4088,15 +4134,25 @@ static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *r
  * and set lookups until either the jump limit is hit or all reachable
  * chains have been validated.
  */
-int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
+int nft_chain_validate(const struct nft_ctx *ctx, struct nft_chain *chain)
 {
 	struct nft_expr *expr, *last;
 	struct nft_rule *rule;
 	int err;
 
+	BUILD_BUG_ON(NFT_JUMP_STACK_SIZE > 255);
 	if (ctx->level == NFT_JUMP_STACK_SIZE)
 		return -EMLINK;
 
+	if (ctx->level > 0) {
+		/* jumps to base chains are not allowed. */
+		if (nft_is_base_chain(chain))
+			return -ELOOP;
+
+		if (nft_chain_vstate_valid(ctx, chain))
+			return 0;
+	}
+
 	list_for_each_entry(rule, &chain->rules, list) {
 		if (fatal_signal_pending(current))
 			return -EINTR;
@@ -4117,6 +4173,7 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 		}
 	}
 
+	nft_chain_vstate_update(ctx, chain);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nft_chain_validate);
@@ -4128,7 +4185,7 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 		.net	= net,
 		.family	= table->family,
 	};
-	int err;
+	int err = 0;
 
 	list_for_each_entry(chain, &table->chains, list) {
 		if (!nft_is_base_chain(chain))
@@ -4137,12 +4194,16 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 		ctx.chain = chain;
 		err = nft_chain_validate(&ctx, chain);
 		if (err < 0)
-			return err;
+			goto err;
 
 		cond_resched();
 	}
 
-	return 0;
+err:
+	list_for_each_entry(chain, &table->chains, list)
+		memset(&chain->vstate, 0, sizeof(chain->vstate));
+
+	return err;
 }
 
 int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
-- 
2.51.0



