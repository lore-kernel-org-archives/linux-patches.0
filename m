Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA3A3382D6
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301657; cv=none; b=fgjDjCbeBb09i7rOt2qeu703B0C6L3c/oUznmm8ZmCYvJoWSaRXdM67+MojLNDppoxRnhD9ZX88v/N/Ka6DHbp7Z9lrd5AOFOBc0Qq9lGEB5zaC/McOY+ZA0WNaegAW06eUQ36dXRTkguz2fm381FR01QbOFTnSVCbbVu3QxQB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301657; c=relaxed/simple;
	bh=CoByT++M7jXtrNZTWF0mDOceAMLwMK8z3ClqgtFUzQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRxt3p4ML7eLEbBZ3CTw34/XbJjWtzIRZfxGyK4jDKmYRqOTqIZZ2oMEdnQO0KGT/qJwX7qys4QL0c9oIp3rwRHEX9qRr5kUlCzrvdfiyYXn1v5tPzUsLSrBZbHO5yFJFtjQ7qNbBLRDlzQC8k5RMCHQ3JhQfsiNjhB3dezj7mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zc4Mr2xB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zc4Mr2xB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DAEC116D0;
	Sat, 28 Feb 2026 18:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301656;
	bh=CoByT++M7jXtrNZTWF0mDOceAMLwMK8z3ClqgtFUzQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zc4Mr2xBpvzr3JCzpPQkY/9VwyMw/LKjO+tB5q98RJLk0nTVbh4n6Tt2asvtTlyOh
	 K9uUO1cbHRMKehow028weITZtuKMkDz5r0Na8J/uzRrOlJOrayUZ9nY8/YISeRY9rR
	 Qijq1q4Wql5B1Fv+tVnCxhc11ayCW0c+Qvmt0X9FvD5hZ4UNwhSoqkAABFb2aUEavP
	 hsiR+P42uiGYhZwHjvwOCjry5zJFWo/ETJvf4WeNDpISe42yNe8ZUo0x4y2ntScHUP
	 AJsjZSKJeLjEFG4QsQavEq3kVEcadVZ7R3qI7TbTlt5T2uxmWC1dXPzUhqk68j00X9
	 y6saFNbK5airQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/385] crypto: octeontx - fix dma_free_coherent() size
Date: Sat, 28 Feb 2026 12:54:36 -0500
Message-ID: <20260228180011.1568201-54-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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

