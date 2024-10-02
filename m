Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA2A16F84F;
	Wed,  2 Oct 2024 13:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875330; cv=none; b=nAZjgV6ekfKPnbUpPqzw4XNtYRlN7sKv5odjjaWLrT1IQB0cOIFElnTg217jnKveV3noCG5UK9M4P30cYfUk5MNaPrmJ0Jt8OG4/Ll7DJEhlwZvKaUur+VR63FYypOIlNFwf1SFsloVYgPQ3dvIvZyEABhPjrULZFvVUfIc534w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875330; c=relaxed/simple;
	bh=dgvzWCcmFwpVMxOJoet1HpPDR67lhfMWvblc9XmUYOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsmVZ+o0zxRZXfBtOuZhQs468Y9/t43WcP7LuxQfcHNp17JNtAsxbiGTDes/aRlPWZ6tfVgP4Cvx3C/wTz28yyXU+uZNStNIQrZBBe/PvBFrzbFTNNdCt30Z3GTJo1UfcSpck4QwrwHcIJ3tie0KHmdhBWz6eCy9/5KQClmXgow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ujy85uv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ujy85uv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E73C4CEC5;
	Wed,  2 Oct 2024 13:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875329;
	bh=dgvzWCcmFwpVMxOJoet1HpPDR67lhfMWvblc9XmUYOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ujy85uv9EKcF2kwTOD3xE2RcWtB4x4BdWjJ1D/TiGPo0wIL6bbisoAKCNgs/am3kj
	 2dExhihtT4A+pHv0CSd8CUUj9BCSKOrv8CXWsOQdndqMaXjGXWqlp374npV47M3wIV
	 LEOjLnXoKHvVY/hTZaIwFgIwR9K1cKRo5g2yVpcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 066/695] netfilter: nf_tables: remove annotation to access set timeout while holding lock
Date: Wed,  2 Oct 2024 14:51:04 +0200
Message-ID: <20241002125825.119865072@linuxfoundation.org>
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

[ Upstream commit 15d8605c0cf4fc9cf4386cae658c68a0fd4bdb92 ]

Mutex is held when adding an element, no need for READ_ONCE, remove it.

Fixes: 123b99619cca ("netfilter: nf_tables: honor set timeout and garbage collection updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b13a899698a8a..9e57c68f0803f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6915,7 +6915,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return err;
 	} else if (set->flags & NFT_SET_TIMEOUT &&
 		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
-		timeout = READ_ONCE(set->timeout);
+		timeout = set->timeout;
 	}
 
 	expiration = 0;
@@ -7022,7 +7022,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto err_parse_key_end;
 
-		if (timeout != READ_ONCE(set->timeout)) {
+		if (timeout != set->timeout) {
 			err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 			if (err < 0)
 				goto err_parse_key_end;
-- 
2.43.0



