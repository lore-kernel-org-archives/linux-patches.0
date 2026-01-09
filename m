Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABC51946C8;
	Fri,  9 Jan 2026 12:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960280; cv=none; b=pp8U/xBj3f4U62CWJUxgRFZM0iPS/O7C5r9/oTNdQ+/5HEn1YRkZ3bLFRKmRUx1iJxKJeNf5tdveui5TPm4VGG+kzZbHyigQsrQkImrdQ6hedZDVkjBDf55QRqJ/EBNG1f7NJYCK7pGvU0GbyoGYNc8zYhtiejVeEUhF7V2HOKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960280; c=relaxed/simple;
	bh=2APAvV8RcCe9MkgGpbfwlJdL8SnG2PCdoYO12yU5urM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRJp4LxV/Gxa3xJZsBTEoG6gERj0E5x09M5wgYJYNWnStjkR7CW0qrXVQf8rbewT3C6W/Bv7reAGQkZ0U1jFn9J8VH2BfmAm3cU37RKcYM6kJgtTLe9JzOmseKadktWli6zWI8Xh2m25g0so/DI0Z5sWZ4LeF71p4P2zQynKono=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEONWaCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEONWaCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF3AC4CEF1;
	Fri,  9 Jan 2026 12:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960280;
	bh=2APAvV8RcCe9MkgGpbfwlJdL8SnG2PCdoYO12yU5urM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEONWaCFn3S1+aFuLlXHtgz/y5JX5MDqozVrGgbe6kn61NEetXzmshaWqO5KJFqMg
	 9M9wMbeuw+RqDVsIR60otcn4ORl6wE+MoyKk2CH1m2ssvOZBuTckmPX9nnnteAFrKg
	 mRtEsnDCdYihCs+eeFIw/fvuKUxFhom+1CRgoeAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 347/737] netfilter: nf_tables: remove redundant chain validation on register store
Date: Fri,  9 Jan 2026 12:38:06 +0100
Message-ID: <20260109112147.039919271@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8b8895e4372d9..394ee65e1d35f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10964,21 +10964,10 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
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



