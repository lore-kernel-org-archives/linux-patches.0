Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08047375256
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302524; cv=none; b=A7+a0LdHYNfh2UNhvQ1hw0TL1ro5P+cDinW4Z79Vv2O/xRoXxZxUOs1JI4BTqyofIDa4Vf9/L+dAuuHKZv/vv24tFPUPgnOo2fjKST9AsknSy30ACBzyVkk1OVXoXYPDv8qcTMnbfjmgpyWO/otVOlolgeABjoHYYU3a3NL0reg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302524; c=relaxed/simple;
	bh=fgeC/Oo11rslpcR5xqKnlzQphsTQTpO01IvnqfFlgSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcniJMlE4GIiBHQ10M30zj6Hw6VeBNs1qxQQ5pw+hONfRCmTOGqfSwr8cMP2uoux5J2o2WO+zV8BrhaVzzj5lnBg/O8/YtsDuk3RpdIrk0Kt82DRe6tz+ZmqDl4cYVS6XQ0y0vFOfV2+Y75qbspSz1zhxT12Iv6FkzlTdaXtOqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fm9//NCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fm9//NCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE7BC116D0;
	Sat, 28 Feb 2026 18:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302523;
	bh=fgeC/Oo11rslpcR5xqKnlzQphsTQTpO01IvnqfFlgSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fm9//NChDT5qf4RwDPYSsJ2vIEHyfEFt6DBKJKjnvI8HP7J/SiUL2of5tnFvZvyyz
	 1nj5nBgxojYpx+Yt6ATFdSKr1oO0x2bM0hoES5ruR06/C6TZT/WWVi0wev0yCeocaT
	 l2hUhav2d5YLI+HTy2DCSXFOTGlm5IuOyFY3N7jQ4Lb82UdCrrm2RSDptGauTZkRPt
	 kRKRyLfn/MEnCOrYub3Jn3Vk+lP0IFggUZyJEeCnZo1HjEK9LtFQXm+o+rXpDU19OZ
	 ohmmOJ0nyH1U1iDPjXghCDqpZP0bMIG0bVuGrAiqSt2KjlUOtrhNEOLfrjVX5VCFMo
	 zWOmJsOWy0tAw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/164] crypto: octeontx - fix dma_free_coherent() size
Date: Sat, 28 Feb 2026 13:12:41 -0500
Message-ID: <20260228181505.1600663-22-sashal@kernel.org>
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
index c076d0b3ad5f1..bbac7778201d2 100644
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

