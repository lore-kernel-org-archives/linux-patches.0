Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C905A2517A0;
	Mon, 23 Jun 2025 13:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684929; cv=none; b=KUKx4k9Xl7qO0aEdc8yhUaXN8tsLCPBZbHdFXZp9kq+TCaZujzFTKjR1zs8XAl6O56HzakTByaKOqXgrdDS4JYNXm9PY4nG3065hjzptTJihrJe9fyZcKDOGPkGRL3w9Xoba+UPfIoFQ/xG+UbfvArIdkgFSKCyW0zourdzQ0cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684929; c=relaxed/simple;
	bh=F8fH2rhX7Xg5DhtZ9T2hpgEshiTlZtiZlUsL//rh6Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgd4YkogmH24AdqRE6QaMPDKrTICrY61NnGHBm5ZQIn88SrdHXJ4BCE3Occb6VA/qNL6pwLGu/fNJ75K2IJ7Oc/tknJ+ceXLG15CAUFGlNg8cWFET+l6ddKNhxb8X7HzR42bRBgkBaF8eM0RtV45V1esXvzhY1YTuPIbHCegyXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2uQ77JJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2uQ77JJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D243C4CEEA;
	Mon, 23 Jun 2025 13:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684929;
	bh=F8fH2rhX7Xg5DhtZ9T2hpgEshiTlZtiZlUsL//rh6Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2uQ77JJwjGO10TViByG7Uf+O5y18EnftgFfesW6jPLiPKFNev3Klg1bXZAaNUKe5
	 +kA9eQOrYp8KZ8jGyqhJQphXwaNP6k9U/B+X6gSgE77GvN2FVEyemEs93xw+6hRJTH
	 DlGCShiJc1+DljUZDrME5QagR0KqBUjXT65Fn68Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/355] crypto: sun8i-ss - do not use sg_dma_len before calling DMA functions
Date: Mon, 23 Jun 2025 15:03:33 +0200
Message-ID: <20250623130627.128440081@linuxfoundation.org>
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

From: Corentin Labbe <clabbe.montjoie@gmail.com>

[ Upstream commit 2dfc7cd74a5e062a5405560447517e7aab1c7341 ]

When testing sun8i-ss with multi_v7_defconfig, all CBC algorithm fail crypto
selftests.
This is strange since on sunxi_defconfig, everything was ok.
The problem was in the IV setup loop which never run because sg_dma_len
was 0.

Fixes: 359e893e8af4 ("crypto: sun8i-ss - rework handling of IV")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index 8a94f812e6d29..f8603b931b9bb 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -117,7 +117,7 @@ static int sun8i_ss_setup_ivs(struct skcipher_request *areq)
 
 	/* we need to copy all IVs from source in case DMA is bi-directionnal */
 	while (sg && len) {
-		if (sg_dma_len(sg) == 0) {
+		if (sg->length == 0) {
 			sg = sg_next(sg);
 			continue;
 		}
-- 
2.39.5



