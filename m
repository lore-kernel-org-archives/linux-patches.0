Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136041EBFE0;
	Tue, 12 Aug 2025 17:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021506; cv=none; b=Z8LlmK+3RgTn2B2nIWdnmD4GRSe/xFe6hlUUnfcKa/1cd5H+qKADIc3Sjguh31GfjJ7IOYwm4DXm5vbzsLy2xJiMCrM5ihpwNaioKN/a5inKOfxnZIaYa+X7Zdet3DfCcDaF0qgv8OKGIepUlawOYSB1w3dH+oGCoifXpnyT/JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021506; c=relaxed/simple;
	bh=yf4P41HW+mMfj/Owbte0qCgpX1netJ3xdPmjv5S7Brs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrIVN7gnZd2Kgwpn6asHD7PwZJjNyN7aFL3l1E3Um0yvOgdkB6/s3JsFEZC2eQOOheCuzIOBClavxLMvjEXXwX8/K1vT+5p/XDeb50ykLuenEzE97p0uuGXORfetQfsWSekrDEURr1JzkYnaZy13OHtT7X3LPO9S8DehbHG/HxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQbalsQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQbalsQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC11C4CEF0;
	Tue, 12 Aug 2025 17:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021505;
	bh=yf4P41HW+mMfj/Owbte0qCgpX1netJ3xdPmjv5S7Brs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQbalsQy3K10JJ1W9JvjrWOMh/wEyqSM0fT0DCRa5V8sPEnMB4vOW8jkfML2JglW5
	 xQMUhBqWfY8vde+8z75kMKwuG2X4hL3JVrvuqhrhx0kYKDxGvKRoSxIlLE9OYemN+J
	 utIPMcH6fAqTQqz/WxlJf8WIsSWVzGa4+tcN3PdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 142/262] crypto: keembay - Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:28:50 +0200
Message-ID: <20250812172959.146200283@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
index daba8ca05dbe..b73222303539 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
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



