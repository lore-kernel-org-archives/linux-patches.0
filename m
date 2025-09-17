Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5708718FDBD;
	Wed, 17 Sep 2025 12:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113536; cv=none; b=L6MUEJV/J0LrkLsFBl5t8xaLDtAnmhrcLiGXYGwIB2+UrM86onK7nJsSzYsVpo/6aMB782VI41C1+A7w+h9Rw2HIA6rL34/3gwsb2yMkrYyUM4ZtJeyCljK89KXZaiQHC1BFpvvTlF+GsWhB5ICEDHwvZ7hAiztX9ILJFOXxBY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113536; c=relaxed/simple;
	bh=/QxmnS2pJWa1DVAJz375UDoDzrbyYO4vvY09Y5ob26Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnTgP0+u+LwfwnosOU2z9S5im3WeNArCC+zcPoPmI3iEzEzjz4+EWNoOdD/fsEai/vQxuWYx6dtVp8I0lcGFGKob+VPlgkoAt+MGze23bC/bSnBgpnmrPICJ5s0h3JWLoLsYolsZxlI2Pmt6gK5bQjIDjjyQGhBEgTWR1LpPDMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nluAs7Dl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nluAs7Dl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BA8C4CEFB;
	Wed, 17 Sep 2025 12:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113536;
	bh=/QxmnS2pJWa1DVAJz375UDoDzrbyYO4vvY09Y5ob26Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nluAs7Dl71YEPVnvELKqZ0NA48YS72tZiPZisUBclzkrfAx0WpUqLM+wb+K+X8eZB
	 r49ydJU0+7h8xJGcL3s5a864wDd/Ie/8DcWTp4NYCHmTrZrk4l0QZw/uvZocg/zOla
	 oKudQeX6CQpUFni7IXLhkzKZgK7GooTZoPviEDSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/140] netfilter: nf_tables: make nft_set_do_lookup available unconditionally
Date: Wed, 17 Sep 2025 14:34:47 +0200
Message-ID: <20250917123347.115710916@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



