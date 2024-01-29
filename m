Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3201415CD51;
	Mon, 29 Jan 2024 17:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548335; cv=none; b=ne2Nj5qUHxDKLpCFlh2w8QhxoA7Y9fSjsShvoa4hvg5ooZ/EwGtB+BKckKzcR9TrQPxeVwtRH0e69onx/57dXd875LlkSXdLojKd1ELuIrdfqadZfxNX08Dj9NldodDwz6kYCdWqJMq5i1Giak3FuL25XbKj4md1C4VtwK1j2HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548335; c=relaxed/simple;
	bh=sU4auR5kxT9OYoJCxq35FEliNhTPiJtJwMYWo+QG36U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5isMqq8OMP6njEXGF3f9r3KbCXUUQ/MIBsdkdAoce3Q/2pDfhWVlQhtohkrnKFaH/ziuQJ4NQ8V5XPw0L1Pv2PXJRDDnDnHk15xpTLqrKjKiMlCXmnrnveQjTeY4VDCloLd0UR7okK7E7FIEupbl6JZTgtLlG2nGqDH2fX0Qd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXk1Bwa9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXk1Bwa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB89FC433C7;
	Mon, 29 Jan 2024 17:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548335;
	bh=sU4auR5kxT9OYoJCxq35FEliNhTPiJtJwMYWo+QG36U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXk1Bwa970OrkeiDXTxpTQZ5Ts4ur5USsPT0qaCUpnnbg8y6bH8jfWn02ipZA4OEx
	 FTZBvqoJu1lY+7BhGsMnXQXSuuJ6nKSWteCF3dkZkzjl5eCnVwkAh6A1auHLrkXeVW
	 Q4mLfyj/0JE0xYk7UtsFYomRCjBWrETvwE0FV5h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/185] netfilter: nft_limit: reject configurations that cause integer overflow
Date: Mon, 29 Jan 2024 09:05:02 -0800
Message-ID: <20240129170001.869146318@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit c9d9eb9c53d37cdebbad56b91e40baf42d5a97aa ]

Reject bogus configs where internal token counter wraps around.
This only occurs with very very large requests, such as 17gbyte/s.

Its better to reject this rather than having incorrect ratelimit.

Fixes: d2168e849ebf ("netfilter: nft_limit: add per-byte limiting")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_limit.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 75c05ef885a9..36ded7d43262 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -58,17 +58,19 @@ static inline bool nft_limit_eval(struct nft_limit_priv *priv, u64 cost)
 static int nft_limit_init(struct nft_limit_priv *priv,
 			  const struct nlattr * const tb[], bool pkts)
 {
+	u64 unit, tokens, rate_with_burst;
 	bool invert = false;
-	u64 unit, tokens;
 
 	if (tb[NFTA_LIMIT_RATE] == NULL ||
 	    tb[NFTA_LIMIT_UNIT] == NULL)
 		return -EINVAL;
 
 	priv->rate = be64_to_cpu(nla_get_be64(tb[NFTA_LIMIT_RATE]));
+	if (priv->rate == 0)
+		return -EINVAL;
+
 	unit = be64_to_cpu(nla_get_be64(tb[NFTA_LIMIT_UNIT]));
-	priv->nsecs = unit * NSEC_PER_SEC;
-	if (priv->rate == 0 || priv->nsecs < unit)
+	if (check_mul_overflow(unit, NSEC_PER_SEC, &priv->nsecs))
 		return -EOVERFLOW;
 
 	if (tb[NFTA_LIMIT_BURST])
@@ -77,18 +79,25 @@ static int nft_limit_init(struct nft_limit_priv *priv,
 	if (pkts && priv->burst == 0)
 		priv->burst = NFT_LIMIT_PKT_BURST_DEFAULT;
 
-	if (priv->rate + priv->burst < priv->rate)
+	if (check_add_overflow(priv->rate, priv->burst, &rate_with_burst))
 		return -EOVERFLOW;
 
 	if (pkts) {
-		tokens = div64_u64(priv->nsecs, priv->rate) * priv->burst;
+		u64 tmp = div64_u64(priv->nsecs, priv->rate);
+
+		if (check_mul_overflow(tmp, priv->burst, &tokens))
+			return -EOVERFLOW;
 	} else {
+		u64 tmp;
+
 		/* The token bucket size limits the number of tokens can be
 		 * accumulated. tokens_max specifies the bucket size.
 		 * tokens_max = unit * (rate + burst) / rate.
 		 */
-		tokens = div64_u64(priv->nsecs * (priv->rate + priv->burst),
-				 priv->rate);
+		if (check_mul_overflow(priv->nsecs, rate_with_burst, &tmp))
+			return -EOVERFLOW;
+
+		tokens = div64_u64(tmp, priv->rate);
 	}
 
 	if (tb[NFTA_LIMIT_FLAGS]) {
-- 
2.43.0



