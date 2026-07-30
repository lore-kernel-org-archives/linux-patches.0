Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736B14446E9;
	Thu, 30 Jul 2026 16:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428113; cv=none; b=l+6PjJZMeM8U9OZ1TbMw/HB6bwgpZgQ5RQXAkmEJ6t6v3BDJyoKAOpQqwiXn7duYgrTkj85qp0y7Xnc+BdAFa547x7pwtq0IjmyZWpwteSykXkcUTflNPNNuEAyBbV1zVGM/m0sf6IukXEhUW2mxTD3cHQB85x6ODP+HcSrIiWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428113; c=relaxed/simple;
	bh=7T1auTQXTTDAOPwMqbqvjPUbD+59NCcjApyTE7+UgF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1g2oKNb76Ze85pt6Arlue9e/OVMtxhduGwiNZ4d62iKjphx4hgcv7/foo3l2uXam3noeARyZgdcMvrFephxCbrHppQzJk8QfumzlYna0RYcPG61sB96FuIG1RD4AkqGkLn7kP6Y7xMCTNHj82PGonYu792/SiPHoOcaDHyreYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xwUloexW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xwUloexW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2DA1F00A3A;
	Thu, 30 Jul 2026 16:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428110;
	bh=jYlKBb7t98n/GsnmsgAfqlJTCo3PQ0nqW0gGl7Bvf2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xwUloexWBchiyHCSxrI1R15FLBO3uN+Lt8nklhwj7TJbO4V17bvtRHGTu5RNrea0L
	 cYQmm2/RSCiB14M9UAt+xApdSkWMGSsLWN6yYlOiDQHmuxO9EgBqYclnMpoBiONNEE
	 I8ZXxSzl3WBBHlQ6T8CkWh4G85iVjmTLHuvKePkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 406/484] netfilter: nft_set_pipapo: move prove_locking helper around
Date: Thu, 30 Jul 2026 16:15:03 +0200
Message-ID: <20260730141432.293271652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit a590f4760922acaa2d2b55a88004a38eecdd6412 ]

Preparation patch, the helper will soon get called from insert
function too.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 47e65eff5069 ("netfilter: nft_set_pipapo: don't leak bad clone into future transaction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1217,6 +1217,17 @@ static int pipapo_realloc_scratch(struct
 	return 0;
 }
 
+static bool nft_pipapo_transaction_mutex_held(const struct nft_set *set)
+{
+#ifdef CONFIG_PROVE_LOCKING
+	const struct net *net = read_pnet(&set->net);
+
+	return lockdep_is_held(&nft_pernet(net)->commit_mutex);
+#else
+	return true;
+#endif
+}
+
 /**
  * nft_pipapo_insert() - Validate and insert ranged elements
  * @net:	Network namespace
@@ -1802,17 +1813,6 @@ static void nft_pipapo_commit(struct nft
 	pipapo_gc_queue(set);
 }
 
-static bool nft_pipapo_transaction_mutex_held(const struct nft_set *set)
-{
-#ifdef CONFIG_PROVE_LOCKING
-	const struct net *net = read_pnet(&set->net);
-
-	return lockdep_is_held(&nft_pernet(net)->commit_mutex);
-#else
-	return true;
-#endif
-}
-
 static void nft_pipapo_abort(const struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);


