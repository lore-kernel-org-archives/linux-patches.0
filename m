Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8CF33A702
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302064; cv=none; b=Wo4Mp8q5zZd7irnU4n9cPBhJUmYlb/HUc6WqrsRWPCNduP5wnXrHtvW7+dti+THjKMtTEsbd9v/wm0qme2NvrmyFyKEy2pfGVAc7Sdm5NnoTrXEIGGuzDan9S5rT9CROQWkUm9MSgGmLjSkhLcfCJvEiNXUT1kwk2XInJsMDEZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302064; c=relaxed/simple;
	bh=CoByT++M7jXtrNZTWF0mDOceAMLwMK8z3ClqgtFUzQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6470KzpL80PyEMg/qupByksKC6gtEKqoDKo3400Zex8CR5OzYRwG0aEqTCmI5uZxbkaTrdF10g5vOw+bhbHPDXFU06Nr9GBBBes7poqY3fYjcUlx0Vyj/cPT8rhMPRP7T7EVqgjK12Md/ivPd6skiKYORcH7VBPqEFqIlSSjqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rFdjJ2xN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rFdjJ2xN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106C6C19424;
	Sat, 28 Feb 2026 18:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302064;
	bh=CoByT++M7jXtrNZTWF0mDOceAMLwMK8z3ClqgtFUzQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFdjJ2xN9hnyEuBYfaq+BEMqdQ6ZXb3gNck88y+wSpJvWxoIiEt2Hn6UYE8evjgkE
	 lJ3OHzaIdbciBZWN8Z+/ckhseeHzNd/Bs24Wc5AB5mBoAbb/EQFA6HAeCrfdmC83SK
	 7kKbiq7d0qP5TKgXOy9AOKsxzG/4aWpvLuvg41qXJpNMNTRcy1czEdBZ9Gdf3zQSuz
	 VStUFr/gkwYnMYk0obuaFrDZTTLCo1Fu6fx2h/qDWSeCWjmSglnm2S/N+pvyvmSwEe
	 7JHfwR5loF+Y1avr41dkeFAaYDva4xN6Dm3deASD19CLaL67nIycABkyIZkuv0QKq7
	 pphHxgGaxuvUA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/283] crypto: octeontx - fix dma_free_coherent() size
Date: Sat, 28 Feb 2026 13:03:04 -0500
Message-ID: <20260228180709.1583486-42-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 88a41d1ca5f64..6c0bfb3ea1c9f 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
@@ -168,7 +168,8 @@ static void free_command_queues(struct otx_cptvf *cptvf,
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

