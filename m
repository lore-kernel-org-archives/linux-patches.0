Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87BB2F5E;
	Tue, 12 Aug 2025 18:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022622; cv=none; b=nShjKgBkaC7NuLrV5Llq2Nuwyj5gYXM+HM/O+bBJmYm3BrFWFwxud2evLV7yiJRgQx8ZPysPe4eNhWmToApQesnUvwr8uqc9csVlBMLhShZ7tRQLFBgsM2ULYE7zRCu2VglGjg8Yvjn5vO9hOu+zyqowoe6H5z1uYt+4RkvuBnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022622; c=relaxed/simple;
	bh=ttZmpxW7LtnJwe1cjkPtnLA6wFwb0wSMpValMHPl7sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIe9Lx1BWslInAh7J5QVGG5r66W3ltzsJdSrXd3hwWK8R0QxWMWWhaV1Ifmh6W1FFfpRr21GCMOWfRQCMQRe1nqizvp2VdIP98AZqHgK/TXahhPsejvo56RQeKqr3MNktJmVWflwg1Gj1wJc/uFEhRTxxcbjCrbDvjryDYBXOLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrDvhGLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrDvhGLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5576CC4CEF0;
	Tue, 12 Aug 2025 18:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022621;
	bh=ttZmpxW7LtnJwe1cjkPtnLA6wFwb0wSMpValMHPl7sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vrDvhGLbzqb1wuBQrKhsf2NEE16kt57na1TdOPT80DUj0z5NlihrONqYRf0Zweb01
	 ea+bczonRarQq6Edm8wa/JaZF2kucnN4Po0AmmznOPvZR1sDxpexszKUlqg1DvALTi
	 Lttlubwgsmq3lzz9MaCVuAZ9pD5XmaQ90eoqqojY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 208/369] crypto: keembay - Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:28:25 +0200
Message-ID: <20250812173022.585640330@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e54c79890d44..fdeca861933c 100644
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



