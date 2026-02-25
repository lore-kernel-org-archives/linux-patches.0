Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D1426ED3D;
	Wed, 25 Feb 2026 01:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983784; cv=none; b=M0lFdRXDXsVECIDNWArzWRtgZDy9ofFh9y5GDAxhOhxpU28f9aCEmCXS1MY2jL4jZRZZeROaopzFbJ6VBKwLnJ9XcarbE3XSyK7RScZy6Q6VJ16UPq7jp2nhEeoF53/VIsNR1LDtNbPssbZF+Cp38xFeU2yMDUJ9sfGaZntC/l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983784; c=relaxed/simple;
	bh=Bs4nlMR06mLwHkgmqfuyjSL7W9H4ZyIFVACPRqsnG+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trpkuaZx6Fg2Ba1gylhBqXT2oYbHvZnYalSXWXihiJf98npz93SmGizTOLTcTQ41oElvR3zGZsVtdmtse3ZqzVj5g+6yYNcA8VN4FE2c/ibdr7rZ91F1CCWZ87WsxJrhzr+ot0n/eaL2QYxEUhqnwcQI8fUF9p7WTaOgCoZf4fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHznHSUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHznHSUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBBCC116D0;
	Wed, 25 Feb 2026 01:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983784;
	bh=Bs4nlMR06mLwHkgmqfuyjSL7W9H4ZyIFVACPRqsnG+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHznHSUC1sqdZEHymLNItt2guwSTEqNuds2NPZm2xbFJedJomU/K1d1P/pd1e3N86
	 Dtqb0dpOxDOLB2pH0PpByX/GLi7McL5RJZ7TLhQdC+ZHQ5dfSxE8etn79l4xV+Pdg4
	 E0PvprR6XqVxfWJXgPqY61faDgxST1NivBcGFiUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 072/641] crypto: cavium - fix dma_free_coherent() size
Date: Tue, 24 Feb 2026 17:16:38 -0800
Message-ID: <20260225012350.810416677@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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



