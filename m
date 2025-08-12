Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4A96BB5B;
	Tue, 12 Aug 2025 18:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024006; cv=none; b=QBoPdPgKt/7ZRSk0SdlDWrc230UbghL/3u7/nNrB6RfA0dOfmTUqOJNXpInX+GztrBwZymIf8xQ9vlurDiUgb1dwAbfVKLr00JuKYGdjz9LDWc52WFS41VRAeI3W6DoxDl8IaISdDbu7Vluls7nRbeAkFn/p+UmnAE9QvkdGpjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024006; c=relaxed/simple;
	bh=BJieD4zoncUbKWDtEb9r3GgDmeqhTdW7CuGsykP9Mew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+S7+eZZGQxCHBIGu9VanTHwUlfQDXtmFU9etWO2YVT2nNYfGR3GIY95zlujosgVe1m53aBkwbnUtyFnzQW3V8YrXLB51p9s5XjG9xCE2R4koCNbXs8/KMsJfzFPlVNF/FVIbNUyOhe9aeuRYM/iC5S+BXddYpVFNVxkt/X4Sqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ej5vvmWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ej5vvmWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958E2C4CEF0;
	Tue, 12 Aug 2025 18:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024006;
	bh=BJieD4zoncUbKWDtEb9r3GgDmeqhTdW7CuGsykP9Mew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ej5vvmWHQasnCJJ+oyxvc7qK+KTBSUMONG+SVqW4prfu65jHjGzax44XUihxqLi5k
	 U0Kcm/kHYrsxaiTz/zDmrIh5/e72un8UdRr0s5CDo+WhFv51oWV/fUSJBrToIGHvNv
	 ltrcyyvPmezj1q1p2ZpJetvu19ammyWZz22kIE7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 202/627] netfilter: nf_tables: adjust lockdep assertions handling
Date: Tue, 12 Aug 2025 19:28:17 +0200
Message-ID: <20250812173426.963431390@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 8df1b40de76979bb8e975201d07b71103d5de820 ]

It's needed to check the return value of lockdep_commit_lock_is_held(),
otherwise there's no point in this assertion as it doesn't print any
debug information on itself.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

Fixes: b04df3da1b5c ("netfilter: nf_tables: do not defer rule destruction via call_rcu")
Reported-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9ebda0248d20..064f18792d98 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4029,7 +4029,7 @@ void nf_tables_rule_destroy(const struct nft_ctx *ctx, struct nft_rule *rule)
 /* can only be used if rule is no longer visible to dumps */
 static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *rule)
 {
-	lockdep_commit_lock_is_held(ctx->net);
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(ctx->net));
 
 	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_RELEASE);
 	nf_tables_rule_destroy(ctx, rule);
@@ -5844,7 +5844,7 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      struct nft_set_binding *binding,
 			      enum nft_trans_phase phase)
 {
-	lockdep_commit_lock_is_held(ctx->net);
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(ctx->net));
 
 	switch (phase) {
 	case NFT_TRANS_PREPARE_ERROR:
-- 
2.39.5



