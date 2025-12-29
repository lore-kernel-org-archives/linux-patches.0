Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA41330324;
	Mon, 29 Dec 2025 16:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025078; cv=none; b=StzK0yg5VrgohkX0xWqf9qzQbdim2Muhc+yo7wPC4gE9eVo0JNt8a8vkY0AGXxNsMiQJxGpbkB5TQsjSnc8Y4HEa/Hes/j2imRI2hVFz8RWw0tDPOdfomQwy5d4zmaojH+QaXv5EbZDemHNaBCRCIA8z79+yn/+kIp2jXxjBmvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025078; c=relaxed/simple;
	bh=bS+YtuLKqwJBJ1apFsF43bq4rVOCLhBIVS6/ov8udj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuIErD5aAdofxQ5wrsNSJgCDGbK5N8MKxSDytJTz6ZThRtMaLHKoG3KUReM57wua1rWJZLBL55akav4SNdOnkHSjcZ7XwEMSGMzBkZ5rP2MBUkYwEzUxbNZLo4BKDWS/sRAs5RFKodAQR+QqyFi6peBAPgMqEApFLYNuyfdKdoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qecN03n2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qecN03n2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250E0C116C6;
	Mon, 29 Dec 2025 16:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025078;
	bh=bS+YtuLKqwJBJ1apFsF43bq4rVOCLhBIVS6/ov8udj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qecN03n2UJMbNTuCTKcN+gPkeJ5YwnGvik3BQ9cRvO2q2GgkZMs4Lve9SDv3aJ/ex
	 fw+BYrLBXaU1CIr11BdyKo33qqcIS0Yz67hsaCKfk5Pz3CREn0cQ0FqrLeojUuKuAt
	 Of75Z9vXS4Q9Y3rG39fjLp5V27bMPLkyHIy12Joc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 086/430] netfilter: nf_tables: remove redundant chain validation on register store
Date: Mon, 29 Dec 2025 17:08:08 +0100
Message-ID: <20251229160727.527546252@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index eed434e0a9702..1a204f6371ad1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11678,21 +11678,10 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
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



