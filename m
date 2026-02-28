Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4015639B949
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302523; cv=none; b=CeT5oV2uLDQwQxle+kpY6YOuxVnMq+CcwruLV0etGTS2jVGT6fIQ/IFjDq2tr4+EoM6/H/Dc85NKJ2MOKF0p4nnvJ44BkLs7hoNjIo4m/JciXSTjqEF1R3aD5xFnAENZBwgjFMvlLuL8KFr7PrZsFTEeuXbdB88pg+dEhaZUTsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302523; c=relaxed/simple;
	bh=JITbUhLN7oo4uG9dvWAGwAMYMehoKqc5WgwjKMsGTak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtzCGpjZg9muSVI+jZxRJvNq4pvk7/dAlQlf3VbO5Kjn900ty6wTuLrmtwQHTE0YkWLQbQaQRTwP4hlEIOtW0KMD/OfwcjCCK3ffT9algvAgV8pv5TBc4iQpm07OdDyRgnZQeWM//tFqF56IThy/sufCdwQ2ib901d/MbDPo+Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xboyyhkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xboyyhkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5385C19423;
	Sat, 28 Feb 2026 18:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302523;
	bh=JITbUhLN7oo4uG9dvWAGwAMYMehoKqc5WgwjKMsGTak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XboyyhkhKmTagec3jI4cBFQtIgGTvzkUV6BDcQKDVQln6CVH16/8ZBQX4NboX1rUz
	 qVNOR0562NY/ocxDrhXoLSoA+M5DPhb9Okn3ZWK913t6Vnrr0WBfIX6Zk4zrXaIhFZ
	 PMeKdW0tWoyvTmW5/UXf+tjgupTsH5lZsc8PVXpOfuTB9rY4d0253TlFa/1wvNXzo3
	 4yuUBPOsiu64NH94K2t4rQEL16aLQjqmvlIfMqDhuPMvizSCW4eQOXbA7OdJ86CdMd
	 Lkz4+HN/C8sCT6Rm+mUveJP2JFaRxPoJP65KmZQjq5IctGp1Km7xf6Ij69P4DBXs/t
	 Av7BDB4ASuFXw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/164] crypto: cavium - fix dma_free_coherent() size
Date: Sat, 28 Feb 2026 13:12:40 -0500
Message-ID: <20260228181505.1600663-21-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 941676c30ba5b40a01bed92448f457ce62fd1f07 ]

The size of the buffer in alloc_command_queues() is
curr->size + CPT_NEXT_CHUNK_PTR_SIZE, so used that length for
dma_free_coherent().

Fixes: c694b233295b ("crypto: cavium - Add the Virtual Function driver for CPT")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/cavium/cpt/cptvf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_main.c b/drivers/crypto/cavium/cpt/cptvf_main.c
index 112b12a32542b..aaf54cab19cc1 100644
--- a/drivers/crypto/cavium/cpt/cptvf_main.c
+++ b/drivers/crypto/cavium/cpt/cptvf_main.c
@@ -183,7 +183,8 @@ static void free_command_queues(struct cpt_vf *cptvf,
 
 		hlist_for_each_entry_safe(chunk, node, &cqinfo->queue[i].chead,
 					  nextchunk) {
-			dma_free_coherent(&pdev->dev, chunk->size,
+			dma_free_coherent(&pdev->dev,
+					  chunk->size + CPT_NEXT_CHUNK_PTR_SIZE,
 					  chunk->head,
 					  chunk->dma_addr);
 			chunk->head = NULL;
-- 
2.51.0

