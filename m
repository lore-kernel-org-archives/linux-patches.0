Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CFE35AC08
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302676; cv=none; b=uJEukYf5dPP55nMeyUvidnt+x4FFUSzcqMsBgXA/znvHjx+7oJPIJtuXAd5xobxbrXGOy7mkXim53//KfdKukZzxLK+ronql8soDzr2/dE4IH6eqPhbhdpqRPxEZwQBRVL/u+8LgGoXyHM9Ieg9NTuLNKWzTFAzPdpqZpoD8EN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302676; c=relaxed/simple;
	bh=we3qotM6uHP37deCPphHD7HWeNlKNMep4yR6FIAb+uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuwiB2LziqljttitT1sUOtqe+cWi/88EbexbSFWapAJavMwbZIX2RNUsl+sjFYWDPC59UBtsWsVwmSBOeZV8PYCrY9C3iKTTNQTix6zPvT5DSVUNCepsjcsqyAjaMVz3LfaanaQYStliokDQY6DvsSWGS34IGk0PlpJJjskM5uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PlY+sI/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PlY+sI/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C23C19423;
	Sat, 28 Feb 2026 18:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302675;
	bh=we3qotM6uHP37deCPphHD7HWeNlKNMep4yR6FIAb+uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlY+sI/++/Kn/MdstRRDMDGIBtjpvK29IhWE43c5WH2N+SrDEUiw5h/J8P2HxtlMh
	 RSn38ufEY3GI78PtbzXuq9cYoabzkDcIv2kE4NtgzoKeW+/hYer3TUVWqGW7lxnrOs
	 IHyKtAlzh+VejrhSteYSOns93ZYFFlvUiugBcZSgdLktYxb86LSEUUUKToBAb+l4rj
	 kaQlR87zywTCT+7y+ngqNt8ggQA2R6P6gKJ1FEqqzsltVRoBqcnS5Qv05jCJHYOsx6
	 12lvnPDc7JE5HQVK6DfPFhDYRBsuTH/93mqE7/uAfMxpzczg4gSONSC8ZtmrLiqQJQ
	 iVa+pr8tzsTWw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/147] crypto: octeontx - fix dma_free_coherent() size
Date: Sat, 28 Feb 2026 13:15:33 -0500
Message-ID: <20260228181736.1605592-25-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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

[ Upstream commit 624a6760bf8464965c17c8df10b40b557eaa3002 ]

The size of the buffer in alloc_command_queues() is
curr->size + OTX_CPT_NEXT_CHUNK_PTR_SIZE, so used that length for
dma_free_coherent().

Fixes: 10b4f09491bf ("crypto: marvell - add the Virtual Function driver for CPT")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/octeontx/otx_cptvf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
index 228fe8e47e0ed..ba9fa4defdba3 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
@@ -170,7 +170,8 @@ static void free_command_queues(struct otx_cptvf *cptvf,
 			chunk = list_first_entry(&cqinfo->queue[i].chead,
 					struct otx_cpt_cmd_chunk, nextchunk);
 
-			dma_free_coherent(&pdev->dev, chunk->size,
+			dma_free_coherent(&pdev->dev,
+					  chunk->size + OTX_CPT_NEXT_CHUNK_PTR_SIZE,
 					  chunk->head,
 					  chunk->dma_addr);
 			chunk->head = NULL;
-- 
2.51.0

