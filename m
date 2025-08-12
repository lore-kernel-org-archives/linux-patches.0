Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123BB2FE562;
	Tue, 12 Aug 2025 17:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020782; cv=none; b=ZHcb6mUd0LB9kE6krme5bfcAEMVe1Wm49ryEdkUPzsI4+Uf9Fm2GYWYRnEoDkJbFLSmk9P/VQAqyuY7sPElpTAdcXCIQT8mPSTHV7UYEo1x8eBWBGKlBPC1ycrUioq+Zb8v3HswstoqRHwTHuF21XE+AuPc9y/GIdvXkofqDFmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020782; c=relaxed/simple;
	bh=us+h6W/xpgqNM6oJGJaWGvl19GQ96PqyXScq37Tnr0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPscscTU54XEPJ2NQUgblShiRynqUzByKqJOeVNyuDSXzXZSP9ly8jhiidaoetdNaXBTPVqO4wXSiH69On3VeC9ziReAvL6qDKDnwEXXOuhg3MlX8P34aaCbShqi+zNW9HZ3EybJCiDQg4svEahcvO8gKDqPZboMzf9CpM1usrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrpOJuJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrpOJuJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17505C4CEF0;
	Tue, 12 Aug 2025 17:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020781;
	bh=us+h6W/xpgqNM6oJGJaWGvl19GQ96PqyXScq37Tnr0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrpOJuJgynfVIyi9sCGKfgFKcdO1IKGJccRPehMa6cC+lFKESmHRlSoDWFp3J0ldG
	 dSNtH/eNjNoNAINOR/umTBdNnoU/lIkO+dNWv6a1yc+QbS0QsPSwAKXQGcUmLyPtYU
	 m9G6WaVYx+4WkuZuIswvepLf8u3XFMCCzcRZ1QXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/253] crypto: keembay - Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:29:15 +0200
Message-ID: <20250812172955.828540910@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 01951a7dc5ac1a37e5fb7d86ea7eb2dfbf96e8b6 ]

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: 472b04444cd3 ("crypto: keembay - Add Keem Bay OCS HCU driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/keembay/keembay-ocs-hcu-core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/keembay/keembay-ocs-hcu-core.c
index 0379dbf32a4c..6b46c37f00ae 100644
--- a/drivers/crypto/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/keembay/keembay-ocs-hcu-core.c
@@ -68,6 +68,7 @@ struct ocs_hcu_ctx {
  * @sg_data_total:  Total data in the SG list at any time.
  * @sg_data_offset: Offset into the data of the current individual SG node.
  * @sg_dma_nents:   Number of sg entries mapped in dma_list.
+ * @nents:          Number of entries in the scatterlist.
  */
 struct ocs_hcu_rctx {
 	struct ocs_hcu_dev	*hcu_dev;
@@ -91,6 +92,7 @@ struct ocs_hcu_rctx {
 	unsigned int		sg_data_total;
 	unsigned int		sg_data_offset;
 	unsigned int		sg_dma_nents;
+	unsigned int		nents;
 };
 
 /**
@@ -199,7 +201,7 @@ static void kmb_ocs_hcu_dma_cleanup(struct ahash_request *req,
 
 	/* Unmap req->src (if mapped). */
 	if (rctx->sg_dma_nents) {
-		dma_unmap_sg(dev, req->src, rctx->sg_dma_nents, DMA_TO_DEVICE);
+		dma_unmap_sg(dev, req->src, rctx->nents, DMA_TO_DEVICE);
 		rctx->sg_dma_nents = 0;
 	}
 
@@ -260,6 +262,10 @@ static int kmb_ocs_dma_prepare(struct ahash_request *req)
 			rc = -ENOMEM;
 			goto cleanup;
 		}
+
+		/* Save the value of nents to pass to dma_unmap_sg. */
+		rctx->nents = nents;
+
 		/*
 		 * The value returned by dma_map_sg() can be < nents; so update
 		 * nents accordingly.
-- 
2.39.5



