Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1727C1D040E;
	Wed,  2 Oct 2024 13:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875324; cv=none; b=FzI3RiGmomItMSSXc1SoofdIuSr21r45Ds0PLJAXZpNsbUTLNPwfiBihQQ2JZnPHuTlaRUhu3LkhvwIJOuhmnOzjekd2Mpxt2rbyX58Wnq5JKOGPw27+sDh5n1GQDZmovxeZKfEFU5Rjzo2SaLhchHuse1QWECVYF669CT3BIOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875324; c=relaxed/simple;
	bh=J081QfWoeEfosb+tN5Pmz+O2Nulu10g5tbBj/MsSXAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+WHkksi7t743lLA3DY2sX2roRMzDO1OMymMdrCU6ZQAw/K3122kCmpvkDP4ADBL6bS0sThIBOc3iNXTK3pLj0jANk+q7IuC2s2xdfgO+HhMGEV3WwBJ8phe33ryyCIfWPWNU8PjXHrlTaMrhRNBC4R/XfpMZvDqgyBSVAvg9dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0Av5q1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0Av5q1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93545C4CEC5;
	Wed,  2 Oct 2024 13:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875324;
	bh=J081QfWoeEfosb+tN5Pmz+O2Nulu10g5tbBj/MsSXAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0Av5q1FdwEMkInyGaZ+ULY8/P2sisQOMPI2R50IzehPfOZ59DEUn4Anu5c/gaLI8
	 4T5F0DvWRITpezsQW+SqyKjIrPIFu0JJ9JnVCe39LvsGgrOv6PrP8J8jj9MOHLgN9Q
	 93zFdFQ4MP0IK0grt8BkKwqiTTbWh9EVvcz+jes8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 064/695] netfilter: nf_tables: reject element expiration with no timeout
Date: Wed,  2 Oct 2024 14:51:02 +0200
Message-ID: <20241002125825.040302893@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d2dc429ecb4e79ad164028d965c00f689e6f6d06 ]

If element timeout is unset and set provides no default timeout, the
element expiration is silently ignored, reject this instead to let user
know this is unsupported.

Also prepare for supporting timeout that never expire, where zero
timeout and expiration must be also rejected.

Fixes: 8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23 days")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 95ef930d4fe9f..70992c6baf52e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6922,6 +6922,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (nla[NFTA_SET_ELEM_EXPIRATION] != NULL) {
 		if (!(set->flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
+		if (timeout == 0)
+			return -EOPNOTSUPP;
+
 		err = nf_msecs_to_jiffies64(nla[NFTA_SET_ELEM_EXPIRATION],
 					    &expiration);
 		if (err)
-- 
2.43.0



