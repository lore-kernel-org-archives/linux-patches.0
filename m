Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671AD255E26;
	Mon, 23 Jun 2025 13:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685585; cv=none; b=YVdhF6oQcfZbAAtJ8SrDVoa1fv03vnrVPSRnQRzNCxpkkfFpZ+ShS2EVwCHODHGMWVcWwC2ZBX1YVPmZamwVqiY/RnAj4QYzfKuQP1p3ZkBwZ/BVhiLWIsMP4lX0BUTda6rN06OgcVnn6E+Pj2DyZcNdrX5IvAAktYAfpGdwe/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685585; c=relaxed/simple;
	bh=vkHrIg/3Ttz4qO9C+0F6hhY3K4i3p5wccrhaOpyqKBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaaFU1X/wK0RwB2beerhEDlSogZM/B9XWBj1lsJcjokKQyC+U1BNy1UKRde0kPiGYY49QqqbrBxccZw7W2gQxVDlXM1pr5gi8IVWgPllT6te9PCTd8QSZwarDB7QZ2OkiaketseC3xCNfSuhe+pShZMALF+8h9YF+BPfhpumWDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjiD6/Vw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjiD6/Vw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E797AC4CEF0;
	Mon, 23 Jun 2025 13:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685585;
	bh=vkHrIg/3Ttz4qO9C+0F6hhY3K4i3p5wccrhaOpyqKBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjiD6/VwTkY31BJIEaccXsoWvBkK33GEfqA0O1vFyJtN2hNpsABEbi8K7Q9EcwcIx
	 38qZEuXMIRHqoUDNRT8FP+qWEXyOGDklXnSbjAV8n+Urc1RXCk99LiI7E5ZvwI5XaC
	 cdzeOX0uyfM/1IfshgwRv2JWxLOi8EDu7YnbJuik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/508] crypto: sun8i-ss - do not use sg_dma_len before calling DMA functions
Date: Mon, 23 Jun 2025 15:01:02 +0200
Message-ID: <20250623130645.678024351@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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
index e97fb203690ae..5a864a71efa11 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -136,7 +136,7 @@ static int sun8i_ss_setup_ivs(struct skcipher_request *areq)
 
 	/* we need to copy all IVs from source in case DMA is bi-directionnal */
 	while (sg && len) {
-		if (sg_dma_len(sg) == 0) {
+		if (sg->length == 0) {
 			sg = sg_next(sg);
 			continue;
 		}
-- 
2.39.5



