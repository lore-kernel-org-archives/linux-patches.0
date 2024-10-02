Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5061D1F59;
	Wed,  2 Oct 2024 14:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879189; cv=none; b=U0oMRHPSlLTbFdE0wv2bzE2UhWRZUSsp4Ky3tYpqY2HNu/cO/g+Jeb276WvRA6UnnN+3l5jphzkhWM4jNVIw/MhBD5esNrkbrLp5nwYQQoUBV2N6WRuxGbbK3DPIrzIneHafH7KCrhxnxYAxY4uIFIjIkYXcco+SCd+CaCViDus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879189; c=relaxed/simple;
	bh=CR0Fi3hE2AFmxGGJjKk+sEj2+xDWAlakkd3vfmEcDwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBy033PJvheHSgowVHZgkN2BBkDNuzFMzNBBFOXDPPBp5t4kutswP+5FcmMw0NLEk/e0QM3WTssP/bc+EaKIKWBGpW2utuq15XqmyINfGab+Uvcy9SqUvASKnWF1jX+hpg2KruSWkiNOSAtObFOOwfIBx7bXN3dIh8v8GgQa5lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KluzcDAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KluzcDAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FDCC4CEC2;
	Wed,  2 Oct 2024 14:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879189;
	bh=CR0Fi3hE2AFmxGGJjKk+sEj2+xDWAlakkd3vfmEcDwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KluzcDAYXAbO85cc3JfJ0PkXEEgkHb0z35g56jgIF06LkfWXYLDbNC0+Izvp2J2Tk
	 PmPJvmmfbqC1rQ8IzHGCjlQn1hcJXthtGnILHgukfQVPCGjasklaL/ssGmCHNZc8Oi
	 JRgCK11uP40e3uzXnq4eVAq5YZNUbTNJPtpcXiPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/538] netfilter: nf_tables: reject element expiration with no timeout
Date: Wed,  2 Oct 2024 14:54:33 +0200
Message-ID: <20241002125753.372819658@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index b28acdaaf9709..8bb61fb62a2b6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6698,6 +6698,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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



