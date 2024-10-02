Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099161D0BBB;
	Wed,  2 Oct 2024 13:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877359; cv=none; b=tERWFBMSoGzA0rnhl5+J6bVFx512oUYxbQBr92+dXYSX/64xDAv3+Kfl4oNKRHlemRgZJ8t+TncCg3CzOdbUtlmOtbDl0tDFLJ8JqYeEyDzoqj5On721PHa/ct+JvzviVoGzeR3R9nudvfVcZsgkjujOYBzkTA2l2U12UCevD0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877359; c=relaxed/simple;
	bh=Oqlwms8lp+JaEMaOIeGEsfyd6ZfQq2uQi1m8snY8XWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W559kXHez6gi4UhCQPBBxoEhBiWP3HUBnUX2y39ZwrTB8NU9MFETe/C3U9QF9fS5Cg0ptXN0gB2asbweCldSCs3PZJO9aGChpVNIYbTwWmWOd/LLowOi26dnqUxoswVb9MXEGeuviIsSPPADi5bgwz67BEuwPGwWc3EZ+2t1wJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTGll0B8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTGll0B8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860D9C4CECD;
	Wed,  2 Oct 2024 13:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877358;
	bh=Oqlwms8lp+JaEMaOIeGEsfyd6ZfQq2uQi1m8snY8XWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTGll0B8V2f74Dh2Q3NNCDL0tI1+W2JSlgu7qjt+rkS7fsWpe7tH9C/a+1qb9LVsa
	 brihjrqJebo10WA/j01/PAshaw7rjZPGgVfXqggFCClBz0kzhxVpe0mfZUj0OH7vOU
	 DOMAuraHwKWCoHlh7skBp4d1SNyM7Sn2B1+0Y6RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 054/634] netfilter: nf_tables: reject element expiration with no timeout
Date: Wed,  2 Oct 2024 14:52:34 +0200
Message-ID: <20241002125813.237213132@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index ebf8d4cbbdc35..e3ac29f75f32e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6874,6 +6874,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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



