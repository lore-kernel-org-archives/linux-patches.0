Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1366A1419AD;
	Tue, 23 Jan 2024 01:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972058; cv=none; b=jI+5z8otpRSK0IEGywLnI/zvYxUqjSBWSQAqJl+PCI2X88VDaOFC57qhrRVMJz0dWenN2IM+uI93cG3ASXQApX5is3HDfV1aB4FQgSNu28+GIV6/MtRbsFu9gSfMHtD4hHlUhL/z7IEWUzmQh/ZxMm9GZXRQFEajkgfhtZRkOx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972058; c=relaxed/simple;
	bh=bMcRjTehjk873Z69lCUrQOvrxRYepr67bl/3ChVgltA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lm3Ds9KjHuDKioPO61dVjUQon2/9FH2qlfLBJENbcSpvm29iObrXn/ySFq8A8G0MoSIfs+QKzXyLtmXImTaPCMhWj5z/pRT3G6/C6RX/QzqwxdyILdLgwS/RyC8a+zFx+IhIHzize7MHlx9fOMXPdSGNHmjkwM99PxFTm6C7r9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiTSSufC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiTSSufC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1428C433C7;
	Tue, 23 Jan 2024 01:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972057;
	bh=bMcRjTehjk873Z69lCUrQOvrxRYepr67bl/3ChVgltA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SiTSSufCCq9tnlAyjrqAR9b0d1mkL9KLTduyWZQg4aJTKO+ZI1nQjZaPtRstm2LB1
	 Q1u29qiNds1OdjkXRZ1zuSZBv2eDCo7NUV0qh4DbUgAAPvboy7fmZLTp45H0MAEXu0
	 YgL4zu3joX1dpoCPcT73i2n2CTN8DbKQg8XUrIgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 399/417] netfilter: nft_limit: do not ignore unsupported flags
Date: Mon, 22 Jan 2024 15:59:27 -0800
Message-ID: <20240122235805.558142063@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 91a139cee1202a4599a380810d93c69b5bac6197 ]

Bail out if userspace provides unsupported flags, otherwise future
extensions to the limit expression will be silently ignored by the
kernel.

Fixes: c7862a5f0de5 ("netfilter: nft_limit: allow to invert matching criteria")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_limit.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 981addb2d051..75c05ef885a9 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -58,6 +58,7 @@ static inline bool nft_limit_eval(struct nft_limit_priv *priv, u64 cost)
 static int nft_limit_init(struct nft_limit_priv *priv,
 			  const struct nlattr * const tb[], bool pkts)
 {
+	bool invert = false;
 	u64 unit, tokens;
 
 	if (tb[NFTA_LIMIT_RATE] == NULL ||
@@ -90,19 +91,23 @@ static int nft_limit_init(struct nft_limit_priv *priv,
 				 priv->rate);
 	}
 
+	if (tb[NFTA_LIMIT_FLAGS]) {
+		u32 flags = ntohl(nla_get_be32(tb[NFTA_LIMIT_FLAGS]));
+
+		if (flags & ~NFT_LIMIT_F_INV)
+			return -EOPNOTSUPP;
+
+		if (flags & NFT_LIMIT_F_INV)
+			invert = true;
+	}
+
 	priv->limit = kmalloc(sizeof(*priv->limit), GFP_KERNEL_ACCOUNT);
 	if (!priv->limit)
 		return -ENOMEM;
 
 	priv->limit->tokens = tokens;
 	priv->tokens_max = priv->limit->tokens;
-
-	if (tb[NFTA_LIMIT_FLAGS]) {
-		u32 flags = ntohl(nla_get_be32(tb[NFTA_LIMIT_FLAGS]));
-
-		if (flags & NFT_LIMIT_F_INV)
-			priv->invert = true;
-	}
+	priv->invert = invert;
 	priv->limit->last = ktime_get_ns();
 	spin_lock_init(&priv->limit->lock);
 
-- 
2.43.0



