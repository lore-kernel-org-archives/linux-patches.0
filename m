Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25F544AB60;
	Tue, 21 Jul 2026 21:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669135; cv=none; b=M3MrPLXPQk2zLC6fkzGytxbHEu9iJaPVZOPPm3EHW44m464Nk0vgsSp37lF1kWDnr5mSXa6hdWS3Farj0WXMOtOh6fzUug1o5DaiWwOf9PwI3C5o2y3pbj2kF4HrIYXnQY1padTfi/9tYi3P2oBlwuc+vQ1JN0Kz2+xLxmNLgQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669135; c=relaxed/simple;
	bh=hZrCPoj0avTh0JCGwqV6ZG8wGZtZbnrYksGvasBQALI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SB+pI//FIBekQ3X+x0vvx56faRWItF7O5/aUpyaOHkeXKHVs93m1nSnq70W0737kw1YEa2p5WYItU/qPrkrJgmxo18FgPiTx6hzRg4MthK6+lV+BH/Hv4TJ0yGp4RKdtOZzzBH+7qWnjTO0ez6UynEFDobUWcRYdCrRSQkno0oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tU8qGyoE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tU8qGyoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B3D1F000E9;
	Tue, 21 Jul 2026 21:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669134;
	bh=GExJClK/XdcvGYOyXfOoXH8A3wmxFHP2o5O1/LElQPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tU8qGyoEYfef3nSLsw4VPu8YRwVlN/E9oYrhfrEPkJsVO32QcWKZ2dUumhkPL5khn
	 sXjkEOqZyWWyH+zpKOrhw9FSpyM8OF/qawduyg+RAoPzjrxwXyZW72uzOuwGjw9k7t
	 LZB3JabNgMB11TzEchsWWrxY/nZB+6IfJZQ+yIDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0441/1067] crypto: marvell/octeontx - fix DMA cleanup using wrong loop index
Date: Tue, 21 Jul 2026 17:17:22 +0200
Message-ID: <20260721152434.480589525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



