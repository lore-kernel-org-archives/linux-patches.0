Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC87127FB37;
	Sat, 12 Sep 2026 16:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229655; cv=none; b=CmS0I13PPipBOLDBLzVPHzjZYksEOmG3zt7t7OTi/Qe3PYUmF3MuhoOp3904B/lyP5ZQrh9/6g4tVrNlRYOBEdpQofDheLTqSvy4LyxCohAJgouv6xzYirIDS0/fkBk/HVTquZ8HbDImfR6ibiFz5VJiNXEF5a6E1racvBHYUuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229655; c=relaxed/simple;
	bh=UQ9mPh20E8Es4R3JYXai8LPJs40U/3AkK6DuKnaWiN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fc08HhzfyBJIccqMabcY9LfOjOWVBbdu1UY0X3aFYpES+YEZb5D4SVMvnMnrpqrD5GTHZ6GLE/wsS2agWFdhbpVN/WodyvHuhMof/5q/N+mrYR3bteU6HPrFQpNAzT7S+jMueFq03F1bxpeCXn02nSsJ8ngBgT7F0oyta7Q09OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTooD3Oq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTooD3Oq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C991F000FF;
	Sat, 12 Sep 2026 16:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229654;
	bh=O/tkkr6+PmE/uByoo/jAdjLW0mC6X6DyRrZrkgw1nOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTooD3OqTrUE/2wZGCfgI8hEiYARacuzNnVPguosgN5ua08ePqAo+q0F2hbFDcZgL
	 i8OyKAIG/gzzQKEHWfo5TwhR/MIL/drQgkQO/wGilyPcTmLNgKL2wB86rVF/QpFbYB
	 dKhU4cH8j3yiyWkyBkjbhrtpMgt6yyNhouV0pR14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Linus Walleij <linusw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0633/1191] crypto: sl3516 - drop invalid sg_dma_len checks before DMA mapping
Date: Sat, 12 Sep 2026 08:56:01 +0200
Message-ID: <20260912065602.473013285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 14d0d83d388d8..fa96ce25ed599 100644
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



