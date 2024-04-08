Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E2C2E62C;
	Mon,  8 Apr 2024 13:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581730; cv=none; b=ked4R8tglpYcrUupaU4MQklmkUbqQ/Jc2O7x9EyX+8jg/vbGYISfCbbm70/BB/9phANrRH6STMd639YNIoNfRr2/axHyH+9QFcBqRho5RKG2C+9T3O2xj/XGx4256UdXCpwVmQpoVVMRIs8xLFQ/DsSv4BWpga773kCAK4WUA/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581730; c=relaxed/simple;
	bh=afWCE3KGTDTj+haRJSNSi+ejPHX/PQ9Z6P1nk+F04KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKLxH05f4t7jY33zxse4U8WoLvpLF9II2Lntj1mMd5mvxNYY/NGMwZHMhfoTLCNAxigDNSLLrO0zrL9Jsoq5DbB5DybL6EA+2hOZQWHcCY9raD4fVpLACaL1ZsDzXjfToH86+hgpu+iwbrOYLFHrDiuRdqFXdULm4FgjZKn91zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8dZhR3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8dZhR3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646BDC433F1;
	Mon,  8 Apr 2024 13:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581729;
	bh=afWCE3KGTDTj+haRJSNSi+ejPHX/PQ9Z6P1nk+F04KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8dZhR3InD/x4XYmDqrRW8UkdaLj3m+FPvhAG1rKfWP1SSS/izVN4ff84/4b42WlW
	 eJV2LClcgvfj4Tge/icCWluspY5i+l3o7aoxnK+eY+dHZ88gziSedhc0Qz49E/96uC
	 i2viG6AJ/SjAwXo7K7LAfWqA5T2CKriNQXEtUXyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/252] netfilter: nf_tables: reject destroy command to remove basechain hooks
Date: Mon,  8 Apr 2024 14:55:34 +0200
Message-ID: <20240408125307.733223333@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f10419ba6e0bd..0653f1e5e8929 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2934,7 +2934,8 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, chain, nla);
 
 	if (nla[NFTA_CHAIN_HOOK]) {
-		if (chain->flags & NFT_CHAIN_HW_OFFLOAD)
+		if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYCHAIN ||
+		    chain->flags & NFT_CHAIN_HW_OFFLOAD)
 			return -EOPNOTSUPP;
 
 		if (nft_is_base_chain(chain)) {
-- 
2.43.0



