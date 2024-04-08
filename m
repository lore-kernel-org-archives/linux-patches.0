Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7A97B3EB;
	Mon,  8 Apr 2024 13:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582084; cv=none; b=gPFtfzCKMhucefi6eqiiQCH7H1y/vOZCdJewEdj0QEH1BsAIWZpjF8KCanCWSegowWEsDiY74BhUj3qcClyegqdKyHCxIZptRqQFgkJmdMnQWooR9m3rddAI8bYzbuBOjpJ2tEtiT2LMX5Uu9Om/D6QfVJe47VICxlBiPwbyL/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582084; c=relaxed/simple;
	bh=hASHIezoWOzbpVDVkh9hc80xnCkCQNhEYRjtxGhHaJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1Hj0wF15QUUoh4v4u2O9qVJf9Gf0C9XXiBxtYd7xVIaZIZva9G2FuRib8CGs+MUzcrMm8hFNjYJmnx3wsqpgyA5z+umwMqI+/hsECOcy1lX0SUpg9myWT2XXIzslZ1Ak8SPaOMnnBxOMULXj08vdNTeS5LpVQE4wmo/wvpT1aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVo1zSIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVo1zSIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9F0C43390;
	Mon,  8 Apr 2024 13:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582083;
	bh=hASHIezoWOzbpVDVkh9hc80xnCkCQNhEYRjtxGhHaJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVo1zSIQoSpKbGVeb4AGfKFkZCAjTgTRa+5iUrX4yxsC7dAr3n+CPIQw8c6RRf2r3
	 FJK5WziyJ18x4gZoopiB0y19f9fS4ZAApm0CWW8D390Yo36TSg+56P4oXnUM9PUjFt
	 1aQqgBfQLuNK4WcbYDasEFCm/idUNj3v9MnqIm9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 045/273] netfilter: nf_tables: reject destroy command to remove basechain hooks
Date: Mon,  8 Apr 2024 14:55:20 +0200
Message-ID: <20240408125310.697427057@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b32ca27fa238ff83427d23bef2a5b741e2a88a1e ]

Report EOPNOTSUPP if NFT_MSG_DESTROYCHAIN is used to delete hooks in an
existing netdev basechain, thus, only NFT_MSG_DELCHAIN is allowed.

Fixes: 7d937b107108f ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ec6266c1972c0..00288b31f734c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2932,7 +2932,8 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, chain, nla);
 
 	if (nla[NFTA_CHAIN_HOOK]) {
-		if (chain->flags & NFT_CHAIN_HW_OFFLOAD)
+		if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYCHAIN ||
+		    chain->flags & NFT_CHAIN_HW_OFFLOAD)
 			return -EOPNOTSUPP;
 
 		if (nft_is_base_chain(chain)) {
-- 
2.43.0



