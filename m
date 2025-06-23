Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81B1221FDD;
	Mon, 23 Jun 2025 21:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713116; cv=none; b=mTwHquZ9e5YuQOjyZIakaH7CBwwAGEUBpy04cMVQ1apZFyqSMN/4lxcMMyTS9VfALSakgzzQlUigqTuLstb+1SjyV1XK68Ng3XcHRii4HR2SYR/ywhS/IzzP4SQm/5FWLVp8H4TPXqUcKQZDdr24DJE/ErfNz/D63Zgol7rA3is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713116; c=relaxed/simple;
	bh=PIOjpPggg0uu3Ee9Dyhh3md3AhYhNxpEOnUkSxiqrBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXJ//swShEfvlB6f73dmjut1RQYP1q4sOkhEqExKM2SQ2fk62hFmsmFhvLWrZuA5fXxWv34vH+JEsApoFeaaZs9yVJ0D6NY2ExAgRWkrLg1EeLfhEMCMPAznY8dR3Px5kLQcPy+OW4hvmPFgFaMrPZwMzToUjof5rm6F7u3fUg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/vkFm2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/vkFm2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D7EC4CEEA;
	Mon, 23 Jun 2025 21:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713115;
	bh=PIOjpPggg0uu3Ee9Dyhh3md3AhYhNxpEOnUkSxiqrBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/vkFm2bPvWiURsIBR9TNTz+FS5c90lIrRL4iYb4yRQKBRVT5w9I2BieCuptkYnE2
	 MkMBxq22H/rUa6viaFw3NjxwoLOubkK5PLUp/qtW4OsFTFOy/7gtcjnWZOgXLV2p9V
	 jwe8vgbwlBqvLOutnM5hFKcGRYhy3qL1+LhgK9gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/411] netfilter: nf_set_pipapo_avx2: fix initial map fill
Date: Mon, 23 Jun 2025 15:04:29 +0200
Message-ID: <20250623130636.707570327@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ecabe66368eab..cf5683afaf833 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1115,6 +1115,25 @@ bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 features,
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
@@ -1173,7 +1192,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	res  = scratch->map + (map_index ? m->bsize_max : 0);
 	fill = scratch->map + (map_index ? 0 : m->bsize_max);
 
-	/* Starting map doesn't need to be set for this implementation */
+	pipapo_resmap_init_avx2(m, res);
 
 	nft_pipapo_avx2_prepare();
 
-- 
2.39.5



