Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7868863400;
	Tue, 23 Jan 2024 01:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975068; cv=none; b=CcayBEzzNcOi6V/o0WURDnApbMyS/OUnJjnVQBPvDbMmMJNhWL8RQr+76s5tRyZZexwTs9PI7aX0XYT+JQNZLMqAr3PIi2Su0F3Gvrir8JAHIX/Kdl7MIktvMCIK4TpuRsuZMkrscC+fvbSatAgp5jSGPrHuj4BCA1PqVj/MA48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975068; c=relaxed/simple;
	bh=fW0xomiM8nSIsWAAS8rkZUZF/D0kXGzDXWGyYMr/YFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9ToctY2E+2bdWfBqHhOAXuLOb4MBiapkx+EP5qMh4/GHOTQihLeE1WWq0MxY51KKulnxV/LMAEig96RHZooJ2FdXzGJ+hIXQrSULIuz63JoBJJlldEbAXY6mVGCveaq3CBQCmhs5QQqEwrOyLztt54Z5vTiWLxdjvfBpPlKnr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ui3mzmCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ui3mzmCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7F9C43399;
	Tue, 23 Jan 2024 01:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975068;
	bh=fW0xomiM8nSIsWAAS8rkZUZF/D0kXGzDXWGyYMr/YFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ui3mzmCK5JOesUQdqWKEMUqQ3xhdbly1HRTHz/s1g2Ax5g4I6MJ6S9axMYdzrJp7g
	 pNbOhlL4oHB4enowG0BdAs43sfDFfRMxv5SGeCU/MMs+19/eiFEm2SSbbqWbGvqeq+
	 C+wSbbpWwBVu597PeiAINIzHyXTxKmHi4zHoDcsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 351/374] netfilter: nft_limit: do not ignore unsupported flags
Date: Mon, 22 Jan 2024 16:00:07 -0800
Message-ID: <20240122235757.149536131@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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
index ac0979febdac..a355fbabe99f 100644
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



