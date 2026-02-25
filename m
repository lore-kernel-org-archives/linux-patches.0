Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165F721D596;
	Wed, 25 Feb 2026 01:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982897; cv=none; b=g0O/EhF0cYSkxvAzuLKf6ka6gXOSNdHFGfUFhcSJyUxnHsNXG6kZ+0xpcSOszfrK2i0QhQhoRRxqrRf5Fms2s8YdSCwCG6BGT9Cefm7vlrQ73Q/8NgAtprudKo6oOf6K0v/02zbMDzobtjz3HJGFRt2i61jqcJR2eBDiyoiJ2ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982897; c=relaxed/simple;
	bh=FV2ATPhot1Pu0hJ1ltvSOngvGkqYepZD1EARKo+Uf5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7C1dffqb2jdaBzd6hVtJaFXg9/avUAGLO25inpKsesTWcCRGFl3iZXVY0DHAQMRctW14A2cz29pFvOOiy8eNcf8WcfSfOAtDLD+94I52wnFNTBmwQXOkbFtt5yUt6/LRRKfTxeldw3A/qiKEHRHjfmSYURAgIKUAbG95upwZpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvI1xGSo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvI1xGSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81FCC116D0;
	Wed, 25 Feb 2026 01:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982896;
	bh=FV2ATPhot1Pu0hJ1ltvSOngvGkqYepZD1EARKo+Uf5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvI1xGSoqOEswkX4zyokAkrEDtLymwOnL2ve/TluIMt4nMGkDp0ztXQkzoIga1HWe
	 5QF6+HonsgkBBjATZHU9nDR7laWBkO59VITlGO+oPieKEj3sN2jvJ1fCnWVZhlpevy
	 1w9KaBTXSPn+KdHX0KXl4pluHPmVYQXYo0dQaNt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 081/781] crypto: octeontx - fix dma_free_coherent() size
Date: Tue, 24 Feb 2026 17:13:10 -0800
Message-ID: <20260225012401.687995304@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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



