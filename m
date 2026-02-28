Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9724383C69
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302064; cv=none; b=KGEUuzAo7jAaJ6XVVOr0XwsYceXBZDOLZ9owgr4tbo4vflfV70SfDQ8ZKCEbjFVmMSoG0r9jvIdM+vlMqmIQipxa4hySnh+221MKHdb7NTLMKSJCtHZrdTGFFivxll46P+kyZjdsgkFmal1+jvM6VBE0ZARPiZxXitoR0hSNMwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302064; c=relaxed/simple;
	bh=2QrBIXSMCnntHiTeaL+fWzXsS1ata4VH2uYK+QctfWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnZYhqKKljiOP2A+8F4FIB1sovM2el71QctRX/ul8WFIAtdurElVk/M8J7ygKWCYTWyuR0p94Gj549iHWyVxbs3o5BTFuLn3JKUKcHc5U3L2p/zTO3R88cZhcIIFzMQ01dcS5Kwc+MOjyYs3b0MJxSdITQb1Pqlw4hN62aN36zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q77Qmk+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q77Qmk+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515B9C116D0;
	Sat, 28 Feb 2026 18:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302063;
	bh=2QrBIXSMCnntHiTeaL+fWzXsS1ata4VH2uYK+QctfWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q77Qmk+JYdnhJQ3L0vRW/XNG882DGAoWIOtQGWig7uBKHzCTmajuqG+wmS+FMBCx1
	 lK90xJZyv7PK8Mn0jYTK/wT0JJ6loq0yIKNYDs5RQQ9dWQ7FV7Ca+snvuESs3EoWfT
	 ko0CK+mLyS5P5Y5mG9lIRiS9souIXuPlHnRuwUlF70LXjR2kBu3QUvgu5cp9/qi0dQ
	 oXtpvKsXkeUVWmwEAVYP3Tr7qQTPHmig4UANo/IwLEhtmhjc7Sd0MTe0YNZ0gnjM9r
	 UBuMd7vQHbEnTpa+aY9dTDSFYhnNC5Bc3eQ2+tjoExJesekZdMlEKJ64Fow/E1PPZi
	 FNd1fv42zjA5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/283] crypto: cavium - fix dma_free_coherent() size
Date: Sat, 28 Feb 2026 13:03:03 -0500
Message-ID: <20260228180709.1583486-41-sashal@kernel.org>
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
index c246920e6f540..bccd680c7f7ee 100644
--- a/drivers/crypto/cavium/cpt/cptvf_main.c
+++ b/drivers/crypto/cavium/cpt/cptvf_main.c
@@ -180,7 +180,8 @@ static void free_command_queues(struct cpt_vf *cptvf,
 
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

