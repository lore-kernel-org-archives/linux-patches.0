Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1FD36C9D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302315; cv=none; b=WN0Uf2b+/MQGwd5Eg5EH9huvpG/JUoDfDdJup5w04sZE6jbHPDdDofBO7SDZtiTgb8jMAPuz86KHD4PYT0YbjKymTohU3FDtsWkjW/b5OlI+89sx21JS93CHbEwZ15qDsMx7SYk+GMGKVa/GGDxFJjWUytf/QwTuupU6huyxO2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302315; c=relaxed/simple;
	bh=2QrBIXSMCnntHiTeaL+fWzXsS1ata4VH2uYK+QctfWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kp3MuVqiS2bgeAP7AlVQ2p6Ll16zUBnlS+JENKI/AzuyCQv5ps8Y2gnvgH08HDAP5Kvj8UzfyWWHP1+HmljPDy2TjA0UbPMMEwWTh1b6fghEvDfOiHkD8aynd/GSFYqaArLYfgFZ82CRB2CNqH7t8qLeLRxdp3TQEElPDnXtfGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WTR20oYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WTR20oYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB60C116D0;
	Sat, 28 Feb 2026 18:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302315;
	bh=2QrBIXSMCnntHiTeaL+fWzXsS1ata4VH2uYK+QctfWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTR20oYvsZx9SjcHRjruNC0dOTnrQHya3XPsH0eUhvwvRiOMql+0NN0buoXkl0hS6
	 9THKLYRXhV4p+7nF+/ikaAKtK+7XEu439ixbLwpHqf2FrUr1FOPk0eWPbYPmjDgL5t
	 d1xTlBQuxIWRUf3YVyg2Ksy0zCvgkWVTWQFrrz6uiATJMz4K0KulyzosurXA621jtG
	 VeBs06ErOTEMjIPT7i4b5oVVKSza3Hoftfl5HXdK54Nwqv4Cypqt3Enxzl5UJ2t3mp
	 Es/Bbh5ezMU39e+ixy7T/hY6QiX6XIByarIF5g7NhoQi/LwDIUwE8C0bUPJO74fwJH
	 ZlIgIP+ultL+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/232] crypto: cavium - fix dma_free_coherent() size
Date: Sat, 28 Feb 2026 13:08:05 -0500
Message-ID: <20260228181127.1592657-32-sashal@kernel.org>
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

