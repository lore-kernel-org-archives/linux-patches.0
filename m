Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E0625F97B;
	Tue,  8 Apr 2025 12:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116426; cv=none; b=hQMQVE7A31KVJgVMA1Lu5cC82AJ62RaSC1M1CYB0he+oTvEPAutq3XfTA0bnXPGbHEpm0rsWC8kov3gFTFlaXGQsqXWFNOF4G5JFyf4gg9O1TvTtB30HbeqQ4gmEYmw2xuQUlJUpSw4iHMYmn6UcjEzSjVim88/Qe0k3n2mcnpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116426; c=relaxed/simple;
	bh=tZRhRgV4/hjCzJYZrZ4zGuM5qrUm890rkos8Il7Ol3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVa6tWbXqLe6CE0J9vdu2UswnK6cAWpC0M0JU0FUBlOw7cmR9/Buhss8D0oXhakTiRBHCSoRmNO8eMZ7JZ9W2yKM7bZRjWf9g7d3X8mDeSwa1WaGjfabVZ6vRMnb+L/qD/dZhQA6P/4YFdLqSFOHIZy7vQ8XF84/jk0KWF6wdys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFRcZE3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFRcZE3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241C6C4CEE5;
	Tue,  8 Apr 2025 12:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116426;
	bh=tZRhRgV4/hjCzJYZrZ4zGuM5qrUm890rkos8Il7Ol3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFRcZE3i/OdHL38bgZZEy8GgoKDRO6FhDiOnMK8cQufsLRScdwWTIg59W4Gf3ArUV
	 m8TTfqWiZDtU2rcvjOk9i1uh5yvnV3LD/Nz37efGVl1+j6gr5Hro1uvkjFhuX8QhFN
	 54fVK856fhWHuzQZOvMYfL3RQ09vj4QogmM9faxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/423] crypto: iaa - Test the correct request flag
Date: Tue,  8 Apr 2025 12:47:03 +0200
Message-ID: <20250408104847.998055246@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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
index d2f07e34f3142..e1f60f0f507c9 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1527,7 +1527,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	iaa_wq = idxd_wq_get_private(wq);
 
 	if (!req->dst) {
-		gfp_t flags = req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
+		gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 
 		/* incompressible data will always be < 2 * slen */
 		req->dlen = 2 * req->slen;
@@ -1609,7 +1609,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 
 static int iaa_comp_adecompress_alloc_dest(struct acomp_req *req)
 {
-	gfp_t flags = req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
 		GFP_KERNEL : GFP_ATOMIC;
 	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
-- 
2.39.5



