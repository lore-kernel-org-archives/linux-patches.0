Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C2135AC03
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302675; cv=none; b=NTnKQk79vXcA0/EtnaOE3muXjeglaxnvpXbnhC1UX+DpXMjUz7tUcmb/O9avKOdri8O2F9cF5h6882E9nkgW/NjY9rnNzi+VuWuRQZomK78rCV0t6MyLlnJDEDRtZN3VVsmjite5vc9CCgol37xbgovV7RJ255K7V2OKfzSBR2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302675; c=relaxed/simple;
	bh=vKbRkOmX4wfWqG4R+ubSHxN8qwz3TB/R7jb4MhXW6EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bP/PKDR0Qbozm8rawLC1r6H0D+bs/DCzg6ALfczg+trddIWFMUKWHlnAoF973ahkNEvEdbj3I+063xMln2cszVrGr9YYZiffm1j8Mx/yqX3LGe3YEfgIuq6bRyw9Nik6C7dhtFjKIT4VcAv7StpvkZns5qxCAIRWw+ekJZ+ZXOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tIfYn6+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tIfYn6+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98467C116D0;
	Sat, 28 Feb 2026 18:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302675;
	bh=vKbRkOmX4wfWqG4R+ubSHxN8qwz3TB/R7jb4MhXW6EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIfYn6+F1F5WmO0ai2LusE67VPzVE1cW2hU7wAwPHPxVcWDc6sszHHkPA8UVDSB9D
	 zTVGht4zJSPImImvIMtK5GAha/+hdu9c5n8AMIfptFtgTEEhoxM3TWRrqtZszPbPAh
	 1KfOjJZSwmRT0NDIUSsimhDM7WrUbI7mdJvPa97GtOfjZpdkYFutcLLvh8pm60k8r9
	 047DessGXsiyU9aVixQjl4JmTKGy7G1IHHEUbOYCiBrx2aj2ZF1D6CuMyIwGPaE0/n
	 aCbev+PW+hg7orfubIjYtbTvUsF1KmVRgBXk8t3erzAJhVu4bUqXRrFb+PAPQxRxxa
	 /17F9fxHnnZvQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/147] crypto: cavium - fix dma_free_coherent() size
Date: Sat, 28 Feb 2026 13:15:32 -0500
Message-ID: <20260228181736.1605592-24-sashal@kernel.org>
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
index a15245992cf99..cbd0c111057fd 100644
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

