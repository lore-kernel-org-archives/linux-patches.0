Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DB046EC75;
	Tue, 21 Jul 2026 18:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659761; cv=none; b=tbMODT7S+pZ1B7ed4Tg4i00ezZSlXhIyZ2JbmdR8yAurvGul3L5znyLhsux2N59Kfro9ncg+89hI6DcBdTTxzkytck7lAupJe/DfM8nfhH54puur1XaDz9smQ/sbu2x1dKarvG2dCT5YuHvCxXsEEK682wFE5bGrNQsHQljTWrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659761; c=relaxed/simple;
	bh=OgJ2Fnbs/t9+NJok3lezLVtzIBZuGgoKNeQqsgB1hag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHM5emD8/HckSb50DiF66K5unz1pi2ynTMYiGHmfO5OzAkIcRVMJi0QmLkJzT5LX7FR3oU7ut57OC7BLD/eeX8dnEmIsfBiLqPGLYudkS8XFFWqf3QezQzsKE8D1XiUNUv98+wHVhFsMpzfmpDjeiQZ7QAGsCj7OFQhGJvbrjbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVvVahyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVvVahyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B37A1F000E9;
	Tue, 21 Jul 2026 18:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659759;
	bh=itAfapOscFGGRUiwjLvj20B7TaL87odhQUmcfJs4u0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IVvVahybJqMAcpTgRaSeluobG1nGVfdaeBYHFZTdaIO3vMCWKjam+TckGU7JOV0kT
	 X4gMkr5Sec9XWfb+uVg+46xvPlG41tllpFt1Ck79IUWopxrY8FZCMrN+iS/Q5gv0BY
	 5f+jqHZZO6pQr8kfS5z2O9hgA83Tw3rrAnDiT6Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0722/2077] crypto: marvell/octeontx - fix DMA cleanup using wrong loop index
Date: Tue, 21 Jul 2026 17:06:35 +0200
Message-ID: <20260721152609.829583353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



