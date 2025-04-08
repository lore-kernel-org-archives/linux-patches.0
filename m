Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A33267B7F;
	Tue,  8 Apr 2025 11:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111213; cv=none; b=rkv3jbbaAyqbHa/C9e3jdB73EgB4xn2mHMN1RIGo/ekf4A+S1YiQHHlfk9+wH81Nhx14UjZP53NKyQCC07+LfGmJpe8RUXtqNlep8CPiVWnLfBUvJM7TD1FrM97NEu+cxYHn8UbjEvaedsrub3ngL+rK9ABm5/VRmwczmAxIGz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111213; c=relaxed/simple;
	bh=u3u0RnY81vD4bSAf/vvR31hwfphF827gVGoxI6n1C4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEDdFGL8YkP9Hn13Wb4gVeO7FedJrN8iuzpO2XZXa4zccbhHeiHEfqIUY5ca0aEAqD7VjuF99Zl2vBhuD+zUVV41gwVJPgAVdq6YgStHIpCKtX+T/83qqc1bm78pXRYa8lgj5Uw8TXpMIIzcZyqCZYu9cjomDiNTe6dibjjMT5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9smnlDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9smnlDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECEBC4CEE5;
	Tue,  8 Apr 2025 11:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111213;
	bh=u3u0RnY81vD4bSAf/vvR31hwfphF827gVGoxI6n1C4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9smnlDp55SMOd+ypOS6u2+K5aNM10swsdIip4q8ZZ63USLIy1dkHdV7jT6cWVfLC
	 WAB6CP05474LEv2TmABke0D46LWtd7MomEVNUgdalC2W5FTJH+oJyI8omj0TO4QdWE
	 eOCzdcpDO+UTa/aRu0u+EQqd99cYTRmanD7K92gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 351/731] crypto: iaa - Test the correct request flag
Date: Tue,  8 Apr 2025 12:44:08 +0200
Message-ID: <20250408104922.438629947@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



