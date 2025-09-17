Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066951F583D;
	Wed, 17 Sep 2025 12:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113063; cv=none; b=i29dbNIuQuSNLKmTydjWc5pE2dJyqx4P3VTdkisf+OFqI65+aRG0cqmDqOmctcEQJHkLe15wGy9ABpX/6JAJdfP6magQk+1SBFLtqJuA0Sk0fxQUSP+tBl+r1CRKtx/Xp3/4MKoV3flZ5UFrxEGtInMueCwJj62U7Gvccb4l8uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113063; c=relaxed/simple;
	bh=P/CudsXeO5/cjLB13WLQ3w26AET60UKXMcEJyjeuksA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=im2Su7g25hAw26IZBkWee/mxUqUtD0rdaOAEqDhSX5PXUC/Qi6em9KjEgBNurYJf8AFAWLNnK71jPJLA19d+99P4fQ4Z3HAVeSiSW2BChoWj59LsKCqhkY2CZ70RtPiabe6wCosj0C4fi/KiX0BLN143GsM+vBfoyjSGKvqAw1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSEhLqUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSEhLqUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40184C4CEF0;
	Wed, 17 Sep 2025 12:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113062;
	bh=P/CudsXeO5/cjLB13WLQ3w26AET60UKXMcEJyjeuksA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSEhLqUBEHowyorZ+1KKfB/e3PsphTOZSSByDSjkJLuQspoPVQitUJdzFchPreJr2
	 Ty2Zx8OdXiSaxYvPwVMU6eEYvjegXmfe/udeG2CsbNQ663CpysfWCwU5ZvvbILfLDC
	 uvHQ0fXdskqL4hJFtjl/R6/qxJ2w65Q4Slis34Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 161/189] netfilter: nf_tables: make nft_set_do_lookup available unconditionally
Date: Wed, 17 Sep 2025 14:34:31 +0200
Message-ID: <20250917123355.808813076@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 11fe5a82e53ac3581a80c88e0e35fb8a80e15f48 ]

This function was added for retpoline mitigation and is replaced by a
static inline helper if mitigations are not enabled.

Enable this helper function unconditionally so next patch can add a lookup
restart mechanism to fix possible false negatives while transactions are
in progress.

Adding lookup restarts in nft_lookup_eval doesn't work as nft_objref would
then need the same copypaste loop.

This patch is separate to ease review of the actual bug fix.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: b2f742c846ca ("netfilter: nf_tables: restart set lookup on base_seq change")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables_core.h | 10 ++--------
 net/netfilter/nft_lookup.c             | 17 ++++++++++++-----
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 6a52fb97b8443..04699eac5b524 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -109,17 +109,11 @@ nft_hash_lookup_fast(const struct net *net, const struct nft_set *set,
 const struct nft_set_ext *
 nft_hash_lookup(const struct net *net, const struct nft_set *set,
 		const u32 *key);
+#endif
+
 const struct nft_set_ext *
 nft_set_do_lookup(const struct net *net, const struct nft_set *set,
 		  const u32 *key);
-#else
-static inline const struct nft_set_ext *
-nft_set_do_lookup(const struct net *net, const struct nft_set *set,
-		  const u32 *key)
-{
-	return set->ops->lookup(net, set, key);
-}
-#endif
 
 /* called from nft_pipapo_avx2.c */
 const struct nft_set_ext *
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 40c602ffbcba7..2c6909bf1b407 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -24,11 +24,11 @@ struct nft_lookup {
 	struct nft_set_binding		binding;
 };
 
-#ifdef CONFIG_MITIGATION_RETPOLINE
-const struct nft_set_ext *
-nft_set_do_lookup(const struct net *net, const struct nft_set *set,
-		  const u32 *key)
+static const struct nft_set_ext *
+__nft_set_do_lookup(const struct net *net, const struct nft_set *set,
+		    const u32 *key)
 {
+#ifdef CONFIG_MITIGATION_RETPOLINE
 	if (set->ops == &nft_set_hash_fast_type.ops)
 		return nft_hash_lookup_fast(net, set, key);
 	if (set->ops == &nft_set_hash_type.ops)
@@ -51,10 +51,17 @@ nft_set_do_lookup(const struct net *net, const struct nft_set *set,
 		return nft_rbtree_lookup(net, set, key);
 
 	WARN_ON_ONCE(1);
+#endif
 	return set->ops->lookup(net, set, key);
 }
+
+const struct nft_set_ext *
+nft_set_do_lookup(const struct net *net, const struct nft_set *set,
+		  const u32 *key)
+{
+	return __nft_set_do_lookup(net, set, key);
+}
 EXPORT_SYMBOL_GPL(nft_set_do_lookup);
-#endif
 
 void nft_lookup_eval(const struct nft_expr *expr,
 		     struct nft_regs *regs,
-- 
2.51.0



