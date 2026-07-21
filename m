Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE10437111;
	Tue, 21 Jul 2026 22:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671710; cv=none; b=MdtHE/1K5ID50PdpNV9T5hmQfQj+6aFjtlAybngs9U4Qd9Gs9Qdbg/8w4rGQFuwW3pBZsOYd2JkSs34CfZlzxf+BZomVv0qfZ/cBdXY+HS0uIqlIACjgt+Atd75kKwErbdHKEK3ir+yrlizjIAuciFPbXlMbbP4d051c/MW1RGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671710; c=relaxed/simple;
	bh=BdSawPosgXOnIxef4/LjmbCdZbSL1UcafVnc5KPb+oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWnJyuc8hbOklA9ylXQF3jCymqEJ0kOPsnXDg5gTvNMyPQd7cEm+UCSul15OzL1cuy4/jz06gV1LffGUFhRNUReNHH38CyjOBu+tyBLrZb29peQ4YN4D+xV4x0Su+E6N9PMi0+f0E39eZiVzEQ6CV1XnLUuWzyUnrSpjnaiEFpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Marq6O1E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Marq6O1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFCE1F000E9;
	Tue, 21 Jul 2026 22:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671709;
	bh=x3F9YgO4Wg8DjAn35vUe/EY59egsMc3d8GwyjeXRkdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Marq6O1E6QVzb6I2zbaFl0v+JQpXknNqvA4gwmd5ifvR5CPjdd2dXy84X53tizvT+
	 ln8mY2k7IrThd+pGTfCX7D4qSFcNxzL/vgWVmtCQAkAS9LsPzTSMsGN/coobdrS4cq
	 k2jAiWjXp47CJHXYFQTM1zr6p8yS3ng/Zp/sTvdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 348/843] crypto: marvell/octeontx - fix DMA cleanup using wrong loop index
Date: Tue, 21 Jul 2026 17:19:43 +0200
Message-ID: <20260721152413.862252896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



