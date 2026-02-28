Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C6F3382D6
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301656; cv=none; b=VakQ3va2HPUan0rn5sdabXDTVIxxk5C++z9IEMxtoW+enxl6OOn27vvm2aDZCpzQxesMO0RE0O/5M/NQUWomyyIXk7810D+EWZpK9yOUwiohwFRZc4xppGwP5E6ItIMPo6y7gtnG4h6D1IcABo5/jPQ30fn8Uj8ar4PnLHnLZeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301656; c=relaxed/simple;
	bh=2QrBIXSMCnntHiTeaL+fWzXsS1ata4VH2uYK+QctfWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFxU33zL5r4Ffru0qSLmzfoXNDb2tXIms2My8LThGVQ+RSH/JNjoalZrSs2cY/CObPWLShgv64U+g3r71VmE9DB7hg9GAHKb9V1LvLSGN6aX/Q2Jix/4SF0RsgQWf7ieMkgzpmeh0LqS2Q2lTq5oXzFdbKkDsNJ04Krau/E0HgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tUDGSVaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tUDGSVaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9412DC116D0;
	Sat, 28 Feb 2026 18:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301656;
	bh=2QrBIXSMCnntHiTeaL+fWzXsS1ata4VH2uYK+QctfWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUDGSVaGj2ylXqh8OuCBP54VOhRMWemjroC105ehSDYOVTIhmarloJ8egr1ULjgvu
	 zgkEfBvMRvZXrtNC27QHc8BiTCkyjLbyyhSaAUq0nDlXSm/79IFaVrFkAH5DUmqXqw
	 NRUum9Tzilj6FmPiLn/CI4J4CGY/AHY1PMEKZuIw/VQywG0acR6ipAR2WOme2x7TUj
	 XavnRjHFgwF3yYMXR6d0PSdZtqbe2UznIf8i8HEfsYvefSicw1X3Q/FDWlcvHyQV9K
	 ppKFbf9TQ1hpr9dl/eccMTq6iUbYtBMfN7uzD2eEaG1DGYmVxsgt15pMr2JiSbA5et
	 a9KomH/+zEPEg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/385] crypto: cavium - fix dma_free_coherent() size
Date: Sat, 28 Feb 2026 12:54:35 -0500
Message-ID: <20260228180011.1568201-53-sashal@kernel.org>
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

