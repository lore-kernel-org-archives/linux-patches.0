Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492A72DF3CB;
	Tue, 17 Jun 2025 15:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174378; cv=none; b=TmpyOyqgtF0VGE6D3+48iLLDwYGNNsrQXsIq7c6Stf3J1RO/pQrqbxgyD7lgWFxbiut+ag6AOJyNT1FNrsH2vAGXb5LSm/HvcAfniYj6KqkoBFH6xCBPO09JIoqydH1UHz6fyRuTggpHdM2ugXFBy5zXe/Mv7iCA1k8B3YFyLQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174378; c=relaxed/simple;
	bh=5FQ1EpA6JeDwRIX/QUW3S4KICZEpk/1QGzAfgugd0tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YosV1od6ib/tr8FCjDzqlXxMUYAff8RdZMzTR7RcAnASLz8UjUtGJL903WEFHOWem0pS3wQNnjRkqRMEUV01uozbty29cG8Rmuc7lVMrgIcvZH9PrE+ZuKVI2pNaKBG2zqjd8bBJakMM4VLk8iSwc6orV7lUFIjRHwbPBZcZw2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGJ9w8X8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGJ9w8X8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2E9C4CEE3;
	Tue, 17 Jun 2025 15:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174378;
	bh=5FQ1EpA6JeDwRIX/QUW3S4KICZEpk/1QGzAfgugd0tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qGJ9w8X8Meq9323Ri1wHCosK6TjOWffJIYTgQSM/PYKbonY2vnvz8NosRQ3EGRKoF
	 bI3bazZ9pTJBJUHLwwZkX1dkYURieDRMrM0MUMEfUrSJvgDEDxDNrPkFhhU1D/ZL8p
	 qnZ0j1v6P4+WoBKjrYcEMAO/6e6ZWU4LbBhF0W3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/356] crypto: sun8i-ss - do not use sg_dma_len before calling DMA functions
Date: Tue, 17 Jun 2025 17:22:19 +0200
Message-ID: <20250617152339.209767947@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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
index 7fa359725ec75..9b18fb46a2c89 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -141,7 +141,7 @@ static int sun8i_ss_setup_ivs(struct skcipher_request *areq)
 
 	/* we need to copy all IVs from source in case DMA is bi-directionnal */
 	while (sg && len) {
-		if (sg_dma_len(sg) == 0) {
+		if (sg->length == 0) {
 			sg = sg_next(sg);
 			continue;
 		}
-- 
2.39.5



