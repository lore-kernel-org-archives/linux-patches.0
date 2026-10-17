Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5723914ED;
	Sat, 17 Oct 2026 16:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254889; cv=none; b=u3/Sg3Y4Y3/eqB43bygTUzDrOv1quVsIVi6D0sQDKOdUsWzRkoZVwbK+VusngGYdHTf66zpFQ0tIw3mKQBV3cAXDCV1s8vW6iGzgIzVKQrRmrq3jfzTnUVNkCmtHVUpuhmsXlnpt9/RXGPBKPFhINxey9zv/F82yBOJ/XiZQJoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254889; c=relaxed/simple;
	bh=4cg2Kogug31fPJrkNlZgp5P3vvfMngIM5GTHim5dwXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsUZ5rCSq3XFv7+nre5YY+KQJGd4jUofGrtHVCpL3TTY14SHYa1loQH+mP2JRBIfSSKpcdHTBddSDiZEELifDW8E2EnWfFZM23sl4gUQXZG5SAJWoMsClGisElX5pfGIzafFaDn+Gb2sl+nTlP0TMYPsnaDWBZs3V/is/e1+adU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMgcroUs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMgcroUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DF71F000C4;
	Sat, 17 Oct 2026 16:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254888;
	bh=lhHDz4NsNimLO1sbx5xYxDkFHXekb/hLgnQf2HqFJxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMgcroUsMZflk5SfvUkhk2KqWZ5lCNDpjruubRamJaKmJenfQwvuBodG8GvFjs85f
	 XcsUIQWcR2VaJX2co94VzsWG2MGdiEIOBI9ulBbXU1RWgmXYq9pMBAeW038jfnNVz9
	 At34eMicb7C3HRO3nctixgcwfkgSrJ89NyD9t9fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 594/869] netfilter: nf_tables: prefer nft_trans_elem_alloc helper
Date: Sat, 17 Oct 2026 17:57:15 +0200
Message-ID: <20261017160052.280622610@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 08e52cccae11a4148a5810f0bd5614796994d221 ]

Reduce references to sizeof(struct nft_trans_elem).
Preparation patch to move this to a flexiable array to store
elem references.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 43559058d21e ("netfilter: nf_tables: skip double clone set expressions on element insert")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d6745e9b63370..b5e5eae856fe7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6357,7 +6357,7 @@ static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 	nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 
-static struct nft_trans *nft_trans_elem_alloc(struct nft_ctx *ctx,
+static struct nft_trans *nft_trans_elem_alloc(const struct nft_ctx *ctx,
 					      int msg_type,
 					      struct nft_set *set)
 {
@@ -7453,13 +7453,11 @@ static int __nft_set_catchall_flush(const struct nft_ctx *ctx,
 {
 	struct nft_trans *trans;
 
-	trans = nft_trans_alloc_gfp(ctx, NFT_MSG_DELSETELEM,
-				    sizeof(struct nft_trans_elem), GFP_KERNEL);
+	trans = nft_trans_elem_alloc(ctx, NFT_MSG_DELSETELEM, set);
 	if (!trans)
 		return -ENOMEM;
 
 	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
-	nft_trans_elem_set(trans) = set;
 	nft_trans_elem_priv(trans) = elem_priv;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
-- 
2.53.0



