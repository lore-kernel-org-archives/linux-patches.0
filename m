Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6886627E3;
	Tue, 23 Jan 2024 00:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971172; cv=none; b=a8qah7dI237WA2sXxH6IaqRPiEUkGN5hupG7AfNrKnXWQ6qml0owbc7OjBAzKuLtXKgqLtNBnYMM47Hm5X3X4J4RWhFDaA7uQ71jzz2DE93r+5w9oo/+qUpGJe6+iiwP1BhqUow8gGmrCn+2eVWwfxtk37gMsbR6YR0U6BwFPak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971172; c=relaxed/simple;
	bh=/ccpDvnn+JtLaybS4VrO6v1PTEJfUC1qw9NlRRgAtzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0KYQ+vJG9Lb0v3bTqOyBuURvQQPTeEt+t2jEQgiFrddYoO/kmP1PRyzJCVfQqTFeNckcObCpmGIrYRzoQYYx0sy+wOss3h16gDugr2rb+oWJV+ilzFCevqENq4fK13o2FwO+QuED7SMFKWyfalDVTy4edayQAiK+1ua57Fl5Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXEhbH47; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXEhbH47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C336C43390;
	Tue, 23 Jan 2024 00:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971172;
	bh=/ccpDvnn+JtLaybS4VrO6v1PTEJfUC1qw9NlRRgAtzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hXEhbH47/udNgvAvVv+rnRt0Yn9JkROVNLuLwhTK9yyTp8MJRp+MC+ukFV/hxsEXS
	 hVyYchxoWkbmIPJiX1+RtCtZuZCzM81p9ObzP9SXP7HZkhV3yxM0SvLIiqK1uA2vV0
	 a4aReG45JigXIwe5MPuKsPgQZnn4wdFPgCt/9vUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/286] crypto: sahara - do not resize req->src when doing hash operations
Date: Mon, 22 Jan 2024 15:56:50 -0800
Message-ID: <20240122235736.091460392@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit a3c6f4f4d249cecaf2f34471aadbfb4f4ef57298 ]

When testing sahara sha256 speed performance with tcrypt (mode=404) on
imx53-qsrb board, multiple "Invalid numbers of src SG." errors are
reported. This was traced to sahara_walk_and_recalc() resizing req->src
and causing the subsequent dma_map_sg() call to fail.

Now that the previous commit fixed sahara_sha_hw_links_create() to take
into account the actual request size, rather than relying on sg->length
values, the resize operation is no longer necessary.

Therefore, remove sahara_walk_and_recalc() and simplify associated logic.

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 38 ++------------------------------------
 1 file changed, 2 insertions(+), 36 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index cdf16e2a81d1..c2a3a10c3484 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -886,24 +886,6 @@ static int sahara_sha_hw_context_descriptor_create(struct sahara_dev *dev,
 	return 0;
 }
 
-static int sahara_walk_and_recalc(struct scatterlist *sg, unsigned int nbytes)
-{
-	if (!sg || !sg->length)
-		return nbytes;
-
-	while (nbytes && sg) {
-		if (nbytes <= sg->length) {
-			sg->length = nbytes;
-			sg_mark_end(sg);
-			break;
-		}
-		nbytes -= sg->length;
-		sg = sg_next(sg);
-	}
-
-	return nbytes;
-}
-
 static int sahara_sha_prepare_request(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -940,36 +922,20 @@ static int sahara_sha_prepare_request(struct ahash_request *req)
 					hash_later, 0);
 	}
 
-	/* nbytes should now be multiple of blocksize */
-	req->nbytes = req->nbytes - hash_later;
-
-	sahara_walk_and_recalc(req->src, req->nbytes);
-
+	rctx->total = len - hash_later;
 	/* have data from previous operation and current */
 	if (rctx->buf_cnt && req->nbytes) {
 		sg_init_table(rctx->in_sg_chain, 2);
 		sg_set_buf(rctx->in_sg_chain, rctx->rembuf, rctx->buf_cnt);
-
 		sg_chain(rctx->in_sg_chain, 2, req->src);
-
-		rctx->total = req->nbytes + rctx->buf_cnt;
 		rctx->in_sg = rctx->in_sg_chain;
-
-		req->src = rctx->in_sg_chain;
 	/* only data from previous operation */
 	} else if (rctx->buf_cnt) {
-		if (req->src)
-			rctx->in_sg = req->src;
-		else
-			rctx->in_sg = rctx->in_sg_chain;
-		/* buf was copied into rembuf above */
+		rctx->in_sg = rctx->in_sg_chain;
 		sg_init_one(rctx->in_sg, rctx->rembuf, rctx->buf_cnt);
-		rctx->total = rctx->buf_cnt;
 	/* no data from previous operation */
 	} else {
 		rctx->in_sg = req->src;
-		rctx->total = req->nbytes;
-		req->src = rctx->in_sg;
 	}
 
 	/* on next call, we only have the remaining data in the buffer */
-- 
2.43.0



