Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B9136C9E3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302316; cv=none; b=LhInnfjUUc8MbTyvIJ7SnkMOfvkkrYP6enU2aYPC7PnXIe4sFNw82dzGfWVipBLeMddE60pve+i0DLHf1/TEVXIawPpiuYcGKinvLVjGpjgyGGvK14Z4VbeHJxkJzlVGwSPXlOSWgPNx07hbSWY7I9OxLus7IzTDRFl+31slX3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302316; c=relaxed/simple;
	bh=CoByT++M7jXtrNZTWF0mDOceAMLwMK8z3ClqgtFUzQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrTRfUT+ucvH48FIkjvlvVK9WOiLOA/Sh0CB5ejE9Acnb8Gs3A5MqKhG9cI2/9QBCewGXmbcOHFw8DKQK5MNnB9IpvPcV9LnBabzRUmAA/8HXDVqsocmHYnsxtSSayAJ5Hf9ex5Skr8u9qE4jxRzeO9fSh11tJdhksWDBny5+6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ORjlNuQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ORjlNuQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67914C116D0;
	Sat, 28 Feb 2026 18:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302315;
	bh=CoByT++M7jXtrNZTWF0mDOceAMLwMK8z3ClqgtFUzQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORjlNuQ5DgsngGW8JqcMeDzmWuQkqrlrxu2VxQvBklHx+cX5/a4KjHIXrXduuh3b4
	 bCfhM6CVmns+KuD/L3X7tc+deRP1GStz+8YGsyVTgrVHvoYhfBCFtoTJShbpFqTTnZ
	 DtVnuGh/ww1A/HPDIoj62De4nzyhzOr0Akp6YFb+SnVjiq9Ai1bZhBW70ctBwvoL9l
	 2CKmgCHdgaYqbfKvljnjzI/Pg5fpY+TAUQrNAyNgp35H1UoCCGhM1zD5is35ZMNy8/
	 p+nJSX5n5c5qphuEbmN+DNzlSBS723V1Gw9hx982txMoxXK6oSdPBoxCnfZ0D2o2da
	 1ejV9qhfPvvmA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/232] crypto: octeontx - fix dma_free_coherent() size
Date: Sat, 28 Feb 2026 13:08:06 -0500
Message-ID: <20260228181127.1592657-33-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

