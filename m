Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F5D3B1ECC;
	Tue, 21 Jul 2026 20:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666133; cv=none; b=U5JuiZKONyv547jbFsjzAnaKc8Gj8Pa5D7nJ1CbTb02fuY9K1s3IeYLGCw2tFmTBxW+5kaQK/JCSn+aDX9K0MNzpneoJkGczG6j4MVw86ivukLIOZac6B3hdmWAoJM4pO29A90qc1d8+bQFEcgsabD801ZpFHgmp+Y87/ZSXfEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666133; c=relaxed/simple;
	bh=KJqFOqWxwQ/iVxC7K6KSKnJaBtG7T7vDr2Ynbh3+dCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITSNOLrV3mIhkbHVFHeJ/pgCv+qX0UskFTGTwgpW1TH4PQdOII2d751xWLgya7dD4bt/kOgmAU3SulvvdWInR3AtaBDdMqSVdAXTdeRHT1hoCieWd6suyOdL3KRRzQ6rAY33+CbMv0HdnCmbVx5+Tu4SAov7luksUhlxG1DTlF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qG2zgDyM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qG2zgDyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE821F000E9;
	Tue, 21 Jul 2026 20:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666132;
	bh=wOAStoNCaEGbyeEjcV6psdjEXT3e8BnlQv2/tktbgg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qG2zgDyMy1ICsNIB8sJKIG5ZKqb5RdA6xARj3u+/7CfX/pwSzd29Zx2ZQyUbEvoyN
	 G86jTs34khTOgxCMzOACHbAM/8GE0NanWAxzRgjmJmji4LTZBoLCNJWKq1Hfu0b+zs
	 6Y8xCbJUxLi0GwM7xok0DMx3xFqeE1/O6vLL+YEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0568/1266] crypto: marvell/octeontx - fix DMA cleanup using wrong loop index
Date: Tue, 21 Jul 2026 17:16:45 +0200
Message-ID: <20260721152454.575878175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



