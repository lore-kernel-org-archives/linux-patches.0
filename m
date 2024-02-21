Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED5B7C08D;
	Wed, 21 Feb 2024 13:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522041; cv=none; b=O8MLnTY4V4Qu9e8QGEcI91blP2Y/5EPKcuWkfrE8UUMX3CNs6YIPwpnfNfhWCRO6vkDJbZk0Lg6IcaguR3IqfldcB18t7rG47BoWJMOWvWg2nkN+BILOq15Q0SMxhKOKgdrycxFq2+FwyLsRQzezi76KEjeVC58g9zJtjX28K6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522041; c=relaxed/simple;
	bh=zqLzMtqq5uM+YXKHewyZTwfGOWBy32dAY0qqMliLdCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyDlHi2pXKb7w0+pcZIAz7WXA6wcuY11m/7NpD3j9xzdDE58CzcEqeMweeXp4sG3bvnC+3XLdIyRPSD7F7zVZK+owZxQCqKtjbi3R4VmKxNd3hqAQyry7LVP0nPVzrLmmhRpgaU+5phteyyP0RIJcUUOS6+GmvlxxcL9C68sPd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HDNz5JH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HDNz5JH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85426C433C7;
	Wed, 21 Feb 2024 13:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522040;
	bh=zqLzMtqq5uM+YXKHewyZTwfGOWBy32dAY0qqMliLdCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HDNz5JH2RLaMD2rPM7pRvcNDUM5+e8MGZ8qQf8IbfpafRc/kKcTwUTY8vod7kUTko
	 1PvCLD9Z3LejYcmn8Dw1A1y2olgNZZgYGQbUq4o64MEI6zvZ3HEaREYoZi81BRryXf
	 SbIN0xZcJtdn2YRsj2Wf3mnm2MSU6041aL0mDqdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/476] netfilter: nft_limit: reject configurations that cause integer overflow
Date: Wed, 21 Feb 2024 14:01:55 +0100
Message-ID: <20240221130010.313118927@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 593fa07f10d5..b23a671fa9d8 100644
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



