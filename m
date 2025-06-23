Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F712367B0;
	Mon, 23 Jun 2025 13:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685216; cv=none; b=m5tskODnHzUGlKaIb4+hZeemouNL+z5Wqb7bAT8sao3zrJ8wKVpVmauAVaGTGir36rIlS2B64oXWc2JCCE1YzLYSA/ncYa9mt2293pG+Ijho2smN5I8yjYLOPB7+V36zGce3ASSAzM/j6Oay1TIbp0YIIWaOrUaSuglcft5L1Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685216; c=relaxed/simple;
	bh=mK/3sPbNcoz7A0prXcWJleGBt7K/8+7ea8/LMb3f02o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nASF1bmFfofhzO9s3+RHAQ3Z7M7iNnCqTbbdcy2aKZ+escsta4Gl72P8YjjSBFmCj5dIHaEE9VD75DJL0OlfDB3WDbJmQm8iKBbtPr4ZIn8Bl59q0wJ11VSaG4Ma7SJsoxZNIPjiITh1UM8Jlzc1+KSsGK5gQw/3m4H/JHyBtsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+E1ICwX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+E1ICwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AEAC4CEEA;
	Mon, 23 Jun 2025 13:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685216;
	bh=mK/3sPbNcoz7A0prXcWJleGBt7K/8+7ea8/LMb3f02o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+E1ICwX4Sb13z3V9+3VwocgiSreH/gRjbzSCJhxyr+Tx+z11onz/oK0JSE1hUM+B
	 DiE/YG34pvJw61KQxshi2nFnJkP8zlFS8ABrNHpvCfGqLBvlfg+Piewvu7D975W0oo
	 c5EUdBE3qOdROrJJjj79YDw4n+Rdsb0DvL0L8hGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/411] crypto: marvell/cesa - Avoid empty transfer descriptor
Date: Mon, 23 Jun 2025 15:02:41 +0200
Message-ID: <20250623130633.514080531@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 1bafd82d9a40cf09c6c40f1c09cc35b7050b1a9f ]

The user may set req->src even if req->nbytes == 0.  If there
is no data to hash from req->src, do not generate an empty TDMA
descriptor.

Fixes: db509a45339f ("crypto: marvell/cesa - add TDMA support")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/cesa/hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 84c1065092796..72b0f863dee07 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -663,7 +663,7 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	if (ret)
 		goto err_free_tdma;
 
-	if (iter.src.sg) {
+	if (iter.base.len > iter.src.op_offset) {
 		/*
 		 * Add all the new data, inserting an operation block and
 		 * launch command between each full SRAM block-worth of
-- 
2.39.5



