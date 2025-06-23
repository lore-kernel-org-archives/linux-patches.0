Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC056136;
	Mon, 23 Jun 2025 21:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714605; cv=none; b=MqqeH1ZJ2jeIlf6hQtbFRGU7Zv0NvIVMxMDcnI7+Sqr/c/dOdZ0yCQHicWlZP+sLhiG1SRUewR9hqQUlz+r5FA4sb91HCLxLL3xbqkIkXm7XoOwfjEUqUbQnY6pfV5OjpWj/j1KHhu3Yw5NNMYEJiZzdlBildfx8VY9YWXKNqfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714605; c=relaxed/simple;
	bh=LOoHTUiK932LYqWpEKB26G2j1oRbfOavPruhoBIqlAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcdyrGyCBCHbtg34TWpsAyPYnO2ohbXJe1KrZ8oDeNh0lcsPw6u4jWaxr+nTwMWrF6ykuTfhuToshgcj7PDJHVCeP2iuhT6sjr6wRMnyzunKoheFUxJG0qgeOeIPgc/4tO1PWC21q1zYleOxaA3Bfn9eVsVSFcTGJ270SsBKXeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNLPT2wq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNLPT2wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260C6C4CEEA;
	Mon, 23 Jun 2025 21:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714605;
	bh=LOoHTUiK932LYqWpEKB26G2j1oRbfOavPruhoBIqlAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNLPT2wq5oAaS3KRMcPVHL4211q/aI+AJiiyRexrxSN/p/iquXqsgbs5EPO6oGP2S
	 FXVQ/yb0sf0p6omjHna3+h2ts6czzgZQvJbYCKJOq+ae4/AUKyBd+21R/yACAH8zVe
	 wRdm8bBH/fvI2dkxkNMZ3wLfGUzMha13LEzTQ1Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 184/508] netfilter: nf_set_pipapo_avx2: fix initial map fill
Date: Mon, 23 Jun 2025 15:03:49 +0200
Message-ID: <20250623130649.801337058@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit ea77c397bff8b6d59f6d83dae1425b08f465e8b5 ]

If the first field doesn't cover the entire start map, then we must zero
out the remainder, else we leak those bits into the next match round map.

The early fix was incomplete and did only fix up the generic C
implementation.

A followup patch adds a test case to nft_concat_range.sh.

Fixes: 791a615b7ad2 ("netfilter: nf_set_pipapo: fix initial map fill")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo_avx2.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index c15db28c5ebc4..be7c16c79f711 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1113,6 +1113,25 @@ bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 features,
 	return true;
 }
 
+/**
+ * pipapo_resmap_init_avx2() - Initialise result map before first use
+ * @m:		Matching data, including mapping table
+ * @res_map:	Result map
+ *
+ * Like pipapo_resmap_init() but do not set start map bits covered by the first field.
+ */
+static inline void pipapo_resmap_init_avx2(const struct nft_pipapo_match *m, unsigned long *res_map)
+{
+	const struct nft_pipapo_field *f = m->f;
+	int i;
+
+	/* Starting map doesn't need to be set to all-ones for this implementation,
+	 * but we do need to zero the remaining bits, if any.
+	 */
+	for (i = f->bsize; i < m->bsize_max; i++)
+		res_map[i] = 0ul;
+}
+
 /**
  * nft_pipapo_avx2_lookup() - Lookup function for AVX2 implementation
  * @net:	Network namespace
@@ -1171,7 +1190,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	res  = scratch->map + (map_index ? m->bsize_max : 0);
 	fill = scratch->map + (map_index ? 0 : m->bsize_max);
 
-	/* Starting map doesn't need to be set for this implementation */
+	pipapo_resmap_init_avx2(m, res);
 
 	nft_pipapo_avx2_prepare();
 
-- 
2.39.5



