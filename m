Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8CC1E7C3C;
	Wed,  6 Nov 2024 12:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897850; cv=none; b=QT++zPM3q0TO1ZuqwKYTsIyBgrX8Pzv+1plwaE8q+vaibadT8Trg52jHCvVs4NqB7VjlPhqN9W3Y7Whv6I0kX7a7XWQe7Uw8MNa+kFyyny1RbSslqjbu7HVoU0WeScoJC7TJ2Fm0Of+bHm5WUIGRWxMOAuQO6GPEstQQjATPyzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897850; c=relaxed/simple;
	bh=cfQaVyC2T9xock9xpUYoQvbUO2YOJLg3pxmETxZ6ovo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip7bRdAwCModc/e/pyddA4K1xPaCf/giP7T4jy9ZzssTAv77+5salcMsn1Zzn2+WQg8Z9tLzYXPy/1zHNgFUvzFKR3bewXg9znVJbGyFykAlf1jAwxOaTzoqbUCn9OL6hhAKpYXthQrVvb31aNFCkp2+WnjcWqSz9aHx7RtrP6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lB0uZ/1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lB0uZ/1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AF3C4CECD;
	Wed,  6 Nov 2024 12:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897850;
	bh=cfQaVyC2T9xock9xpUYoQvbUO2YOJLg3pxmETxZ6ovo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lB0uZ/1Zl2zoRCSzNGsMPpD9ftj2KEI6kCRMLg26D0/wmAp+vN2rwfYeVO+lm47VY
	 OXcY0GW2eiJNkq/IFL0WIDfQ7v/OX+XVTYOcmQbR4w1MYSSgBC/3nfQ5bwLYoDjNJb
	 d1Xcg24hZ45IS6pasZzvZbMHZexzhcQTkvOm9qXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/462] netfilter: nf_tables: reject element expiration with no timeout
Date: Wed,  6 Nov 2024 12:58:54 +0100
Message-ID: <20241106120332.535084907@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f125d505c4519..3c4cc2e58bf83 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4887,6 +4887,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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



