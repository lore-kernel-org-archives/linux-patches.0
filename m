Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537761EBA1E;
	Tue, 15 Oct 2024 11:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992519; cv=none; b=n+hANuU4Q4OUaSGXONfuC4IAnKaxekRRcyZsduX3mbDsP5paUbvxu7E3Fx5HLQNTFUs3VsLpMBVnUrG3bdfwmzbz5O5O94rf/JdE0nUYY5mYnPwSDehEYC03Eu7p8H3OQlBzCWog8kRDihf2OW4ar03O8UpYNVeVgmNWS8KAe58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992519; c=relaxed/simple;
	bh=FTNHZ8BdEhK4D3A/D4WijrElH9MQPtY5yYqXwlhIjEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LykR+2odf16fF9s5rfzhD1ORCQvE/erFNFQrarRNLAkLSmrv/Djahk7/XXIu9IViIX/hXA6g3/RsOLxgknqiDYs6Af9LnE5oU37+sq3u7Mjs6nbfdy3nJTp607zfCZqnd91WbunHnF1ELdZJQPm/yGm85MHOf7rbMiG+UGxKXkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMgCuzeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMgCuzeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C136C4CEC6;
	Tue, 15 Oct 2024 11:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992519;
	bh=FTNHZ8BdEhK4D3A/D4WijrElH9MQPtY5yYqXwlhIjEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMgCuzeGBp7YhOS2dAHDRAAuXRvt5YfFCn9DyHMDvuMhQ5KN3Bq0lzlpNmnaGA4xZ
	 tL2kuVRxxVZtiEFl0yUSrlvwP/db+rX5ud3yjtSlvACdUxu+A5qjMD6Db0oiR9cSbj
	 BKsIK0g4nDEtwG/w59mxT0BQSr4DtBkulqbDJK5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/691] netfilter: nf_tables: reject element expiration with no timeout
Date: Tue, 15 Oct 2024 13:21:00 +0200
Message-ID: <20241015112444.807094592@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index c00a9495f3453..300926b56572d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6295,6 +6295,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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



