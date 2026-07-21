Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCD93CAE7F;
	Tue, 21 Jul 2026 22:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673704; cv=none; b=hcVvmdaZ2uQRsZO62uOWSGjTscHfapRjVduT85cn3P+EbRsXC35WW9o07qpsyRcJVOn9IrjICJSoHSUck6biWwN7d+RPkjOC1YLL/iCpZfTW2CfmFC27Jk20PTC9qR+OHCm8SoZLuPfnECUsRhSYibe62cbcdX9Q7mAsb7EWytQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673704; c=relaxed/simple;
	bh=H1QXFh6urq//15RvzSe3+jxTWpyiy5NR6cNKzQELcgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HopibaXFY7m1hAU/yTHeI90mjNNaulztaK/9lDZ7KFd3o8hpTzv5CL93qnubvZ9AB1LbTpxnizbQbzDNhJqK6u7Y1mgCt3kVJ7LlHVUZoGWzu0iU7FFOxJEyZMpaZPRcvklEkAyHhGOtKfoFAUhX5AA3K6dLHSnBfw6GSR1O0Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e79ONLe6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e79ONLe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6301F000E9;
	Tue, 21 Jul 2026 22:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673703;
	bh=rlqfwfpxvmG3h8nsIcMLysY8cis81wFQ6axsX3EJIuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e79ONLe6r3HyvP0KqxtgxRKaNAHrTO6duTbvUwyFY3GXd/oy3eawKDy2bddTOO8QE
	 i70ibJl2kjjj0aiIUnnMPrhlrPKrgqCnBq0XFd9xwZRifiFSv3xeQ0ngCtZN/ogQDd
	 Ux50zFAtBN1StpO1UO6U/lMdiHDkSqgwpiFYC99E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 261/699] crypto: marvell/octeontx - fix DMA cleanup using wrong loop index
Date: Tue, 21 Jul 2026 17:20:20 +0200
Message-ID: <20260721152401.587318638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 7891c64c0520519782470ba29bac8a5761e295d8 ]

The sg_cleanup path used list[i] instead of list[j] when unmapping DMA
buffers, leaking successfully mapped entries and repeatedly unmapping
the failed one.

Fixes: 10b4f09491bf ("crypto: marvell - add the Virtual Function driver for CPT")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c b/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c
index c80baf1ad90b2f..89030e2711ce41 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c
@@ -157,8 +157,8 @@ static inline int setup_sgio_components(struct pci_dev *pdev,
 sg_cleanup:
 	for (j = 0; j < i; j++) {
 		if (list[j].dma_addr) {
-			dma_unmap_single(&pdev->dev, list[i].dma_addr,
-					 list[i].size, DMA_BIDIRECTIONAL);
+			dma_unmap_single(&pdev->dev, list[j].dma_addr,
+					 list[j].size, DMA_BIDIRECTIONAL);
 		}
 
 		list[j].dma_addr = 0;
-- 
2.53.0



