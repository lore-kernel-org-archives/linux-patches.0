Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAE0125AB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D780C433C8;
	Mon, 26 Jun 2023 18:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804853;
	bh=thxrqLg38SgwLMy6aMl2GTqH54FxKYpysZGPt92k7Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTdF2qmGCqLAU3I8CcTj8PC15g8ID4paZm07NQKV+qXlwMkXAH5fyQaARz1vNUX9R
	 v6TzvWFhVUPY8vWRItKFZ+Ff8ZBDATOttk/Sr5p9mppeemfsVmcClaXzjAV3Qa6j/0
	 /pO9g0ojhRCizkCd7zKDYYQ9s2he1m5R/NHtZ/38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 63/96] netfilter: nft_set_pipapo: .walk does not deal with generations
Date: Mon, 26 Jun 2023 20:12:18 +0200
Message-ID: <20230626180749.563422222@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
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

[ Upstream commit 2b84e215f87443c74ac0aa7f76bb172d43a87033 ]

The .walk callback iterates over the current active set, but it might be
useful to iterate over the next generation set. Use the generation mask
to determine what set view (either current or next generation) is use
for the walk iteration.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 15e451dc3fc46..78e1ec8badde3 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1974,12 +1974,16 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 			    struct nft_set_iter *iter)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
+	struct net *net = read_pnet(&set->net);
 	struct nft_pipapo_match *m;
 	struct nft_pipapo_field *f;
 	int i, r;
 
 	rcu_read_lock();
-	m = rcu_dereference(priv->match);
+	if (iter->genmask == nft_genmask_cur(net))
+		m = rcu_dereference(priv->match);
+	else
+		m = priv->clone;
 
 	if (unlikely(!m))
 		goto out;
-- 
2.39.2



