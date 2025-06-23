Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52994254B1F;
	Mon, 23 Jun 2025 13:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684955; cv=none; b=EJ92e6CmV/8trtSxDbQQahhlc4Ijc5ZK1BW+e5qFAF2GSLmkS8T2+84tq2d6LuM2Vj9MqO7FaSz77hyyzhQ9ysVOfKHnFwkXQHvjBs2qWvKqGNYqKt0Ic5EuJhiCkv7XD/Mc5Zndbd6Sz5QZ4Ue7u3OzqQFnXF5Zsb4pDoj4+48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684955; c=relaxed/simple;
	bh=7Je3O1RkMwdrHk2r6nzXA0YvRZWzFardXVjoBE9GpdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyIn7dXIlNNRmUswQW8UZFxzyRbNb4jOcgG0Y6+jF8pK7ldCARqKOkbykBLiMlLvoHn1VBwpzkRdNdaU1tpkth9JHNe07cZLhU+zKx1/8eZ6LVPsx3zV+LoFprcvep0Dr2yAqb68YeQbVnm2iFThN6wuQFiMUny/CW9mK92Q7nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xe1QF2vp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xe1QF2vp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8C7C4CEEA;
	Mon, 23 Jun 2025 13:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684955;
	bh=7Je3O1RkMwdrHk2r6nzXA0YvRZWzFardXVjoBE9GpdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xe1QF2vptNIyEnLH4Mfbryt22EE41/FO7B7aQZMAavxfIGRgE3eKWoVCeeFXhzgbJ
	 dy9R0qOxYq4D5l+qe/yoxUp/F+7QvaWXwVFAK7KZ2hn9RfkyzSy0vrBHTZkumOrIcB
	 gTe/fsC/SqCDBsRiRvEKjLIxBsQAu2ljRapAebrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/355] crypto: marvell/cesa - Avoid empty transfer descriptor
Date: Mon, 23 Jun 2025 15:03:36 +0200
Message-ID: <20250623130627.235218709@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8441c3198d460..823a8fb114bbb 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -639,7 +639,7 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	if (ret)
 		goto err_free_tdma;
 
-	if (iter.src.sg) {
+	if (iter.base.len > iter.src.op_offset) {
 		/*
 		 * Add all the new data, inserting an operation block and
 		 * launch command between each full SRAM block-worth of
-- 
2.39.5



