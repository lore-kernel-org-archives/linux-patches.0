Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F0E269823;
	Tue,  8 Apr 2025 12:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114477; cv=none; b=bdN1jBjzTOLgphsBKIS3Yv3LxE7RUFo/pwo+0sRpMq1WMv5xbCvq7BhgCeDfU6dojUe+tQnS/1XDyPKJg4H4dvnY7qjpRquDUtTZqHttzwqM1Smjxdpy0cbNgLGZClA6+c1lHAXyGxUyWCwCT4STvUAxauuxuRQDOpnKWpkoVyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114477; c=relaxed/simple;
	bh=J/rNwqziBRuuF1mTDxmTtkU8l7QEMJ/eai4mDg5bavM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGNPzklB23pxMoGcG+YlfKEcugcXrQgOve1LA+uLoYqPugJ90siDah6p2VOH/q9Yg8Tq4KNAHgticO3qOJaOZNIaQNiTVYd4a8KpaEfr0TlQMcxq//29T+BqtF9SmwsemooiXuyCUl/ykFzmE4Pnuzj0CgVnGk/LyOaGUoGhWhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFANIPaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFANIPaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC24AC4CEEA;
	Tue,  8 Apr 2025 12:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114477;
	bh=J/rNwqziBRuuF1mTDxmTtkU8l7QEMJ/eai4mDg5bavM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFANIPaUpYY1YFaIhjw5o15HT3FGIuF/nQEPb/EmjIO7/+vFDFULMUbYan4BpWrkX
	 UBNJ4QDBzZpdKVfFQRJ8sPIuV7aqvaCpNtZWAWF1XZISxRnWdzPfxSuentGiUwnkEX
	 BMfAb0DrsBvf8T82smHpm6jt5/hsERNBIuzgEOZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 120/499] crypto: iaa - Test the correct request flag
Date: Tue,  8 Apr 2025 12:45:32 +0200
Message-ID: <20250408104854.193479978@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit fc4bd01d9ff592f620c499686245c093440db0e8 ]

Test the correct flags for the MAY_SLEEP bit.

Fixes: 2ec6761df889 ("crypto: iaa - Add support for deflate-iaa compression algorithm")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index c3776b0de51d7..990ea46955bbf 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1537,7 +1537,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	iaa_wq = idxd_wq_get_private(wq);
 
 	if (!req->dst) {
-		gfp_t flags = req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
+		gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 
 		/* incompressible data will always be < 2 * slen */
 		req->dlen = 2 * req->slen;
@@ -1619,7 +1619,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 
 static int iaa_comp_adecompress_alloc_dest(struct acomp_req *req)
 {
-	gfp_t flags = req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
 		GFP_KERNEL : GFP_ATOMIC;
 	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
-- 
2.39.5



