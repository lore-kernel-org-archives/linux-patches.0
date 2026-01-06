Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CEB346E50;
	Tue,  6 Jan 2026 17:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719862; cv=none; b=eoKFqutDbQeaZh4l7PqH/3+75iUAi1kAFWF8Obv2u2HQxSIvhRpoyAVSBx3p16OoXRgszFJZY5euc2DypfRz6W7rCEN7+QKBt106Xn20vE08JwPyhf1v+nZM9ZOfxLTG0PiMrLO1rkygdp+W0BaQT8wPu/Gem9WEVTPrl0A84NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719862; c=relaxed/simple;
	bh=2v1qreq0gE6YhXglghurFlM44na9zy4XafVKI8Y/W9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLoDRSFFh8l7wclhwGDJ0yxSY8vDPPg2hL8S8XLNWf+ylvQ0CiGYvODYLmpnvnX+CP0oia5KeFv8jZKSTHsV0Pi7clC1Bfq2pheqR38bvenwLm+zABqZOB+waueH9mREptFP92akXhY1nbuZ5is2e4ZdIpSuoepj4MUTVaRTgdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpCNEavw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpCNEavw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C649C116C6;
	Tue,  6 Jan 2026 17:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719862;
	bh=2v1qreq0gE6YhXglghurFlM44na9zy4XafVKI8Y/W9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpCNEavwyuqq1unaHAZef836yW7fAgFJlX66m9jfkyRQD+ffM+7E4y+WBV0yEvk1e
	 63tEBYiks0o3InjF/ZFtlC7slthV9DqZAvXE3DRF/XhTs28aVdhsQDPPqJ3AMHETba
	 etOIUMovYOV41oPJI6bmzszIxiMQ8yPZgsX5ExzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/567] netfilter: nf_tables: remove redundant chain validation on register store
Date: Tue,  6 Jan 2026 17:57:23 +0100
Message-ID: <20260106170453.593459318@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit a67fd55f6a09f4119b7232c19e0f348fe31ab0db ]

This validation predates the introduction of the state machine that
determines when to enter slow path validation for error reporting.

Currently, table validation is perform when:

- new rule contains expressions that need validation.
- new set element with jump/goto verdict.

Validation on register store skips most checks with no basechains, still
this walks the graph searching for loops and ensuring expressions are
called from the right hook. Remove this.

Fixes: a654de8fdc18 ("netfilter: nf_tables: fix chain dependency validation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e1c617b488889..b4741fb337988 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11211,21 +11211,10 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 				       enum nft_data_types type,
 				       unsigned int len)
 {
-	int err;
-
 	switch (reg) {
 	case NFT_REG_VERDICT:
 		if (type != NFT_DATA_VERDICT)
 			return -EINVAL;
-
-		if (data != NULL &&
-		    (data->verdict.code == NFT_GOTO ||
-		     data->verdict.code == NFT_JUMP)) {
-			err = nft_chain_validate(ctx, data->verdict.chain);
-			if (err < 0)
-				return err;
-		}
-
 		break;
 	default:
 		if (type != NFT_DATA_VALUE)
-- 
2.51.0



