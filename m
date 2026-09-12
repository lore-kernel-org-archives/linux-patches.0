Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB844BEE43;
	Sat, 12 Sep 2026 18:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238838; cv=none; b=Fvhx528JJuKCmyaFZ09yLF+mPt4XVGMx2ta5N2hsxYpg2eANdYCZDO6B0Rbxv7KnHlYm7XxkQaidWxPgFA7mzK56Y8DQ9l83lgxElljpawuw2PCt/oEwkCe4AMZGmWPdIMAjWS+F7vgeoBvNIEZvQ3DB7hWN6zkfE4bgmxk+h70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238838; c=relaxed/simple;
	bh=o6MAYU+Ze4ZjvB0UOyiVSblpBxCsulpO6lf0A7NRjO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXc5EALiTUm4mQrB8akEle9qJfFrFH1szAmDBe5/TJAeZjs3Plxcljgx7Z2n6AXgVTRKIe/m9xzAoU+AmZrVMqdHhQM/2c6Kxd8Z462r9giTGnKpL1454Ns4/BNNW2HINuWN+6Qe7u0pnBIUFRp0NSqS6MZXmd4gvN+Qk39jetc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvHIwMFw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvHIwMFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F33E1F000FF;
	Sat, 12 Sep 2026 18:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238837;
	bh=unmLv4iiYyU9oV1LuHbROj8WJcI0Riv9q9D7EJWQx3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZvHIwMFwYk1p+3EO1x/juyJge6ElYZ2SAezpLPiC1a75+v+rGj9EbM2sayUBUYfMs
	 yMdvqv3XV57IcLUVkvvfVR06Q+y0NaRNRktqTNd4D4S4jRVgBN9pw+DLO5H5kIFZdw
	 FG8UMDIG0Ipxn18hI6dIQhUHixl5YImIv2Cn1hUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Linus Walleij <linusw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 536/935] crypto: sl3516 - drop invalid sg_dma_len checks before DMA mapping
Date: Sat, 12 Sep 2026 08:59:26 +0200
Message-ID: <20260912065539.115808349@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 3ae59a2eba64b3648f069aa52eeaaeefdfe4bb2f ]

sg_dma_len() is only valid after mapping the scatterlist with
dma_map_sg(). However, sl3516_ce_need_fallback() checks it before the
source and destination scatterlists are mapped. Thus, a stale DMA length
that is not a multiple of 16 could incorrectly force a software fallback
when CONFIG_NEED_SG_DMA_LENGTH=y.

Remove the invalid checks; the existing scatterlist length checks are
sufficient.

Fixes: 46c5338db7bd ("crypto: sl3516 - Add sl3516 crypto engine")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/gemini/sl3516-ce-cipher.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/crypto/gemini/sl3516-ce-cipher.c b/drivers/crypto/gemini/sl3516-ce-cipher.c
index f2be0a7d7f7ac..52f5f1a49c911 100644
--- a/drivers/crypto/gemini/sl3516-ce-cipher.c
+++ b/drivers/crypto/gemini/sl3516-ce-cipher.c
@@ -52,10 +52,6 @@ static bool sl3516_ce_need_fallback(struct skcipher_request *areq)
 			ce->fallback_mod16++;
 			return true;
 		}
-		if ((sg_dma_len(sg) % 16) != 0) {
-			ce->fallback_mod16++;
-			return true;
-		}
 		if (!IS_ALIGNED(sg->offset, 16)) {
 			ce->fallback_align16++;
 			return true;
@@ -68,10 +64,6 @@ static bool sl3516_ce_need_fallback(struct skcipher_request *areq)
 			ce->fallback_mod16++;
 			return true;
 		}
-		if ((sg_dma_len(sg) % 16) != 0) {
-			ce->fallback_mod16++;
-			return true;
-		}
 		if (!IS_ALIGNED(sg->offset, 16)) {
 			ce->fallback_align16++;
 			return true;
-- 
2.53.0



