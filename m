Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A712A3B9D9D;
	Tue, 21 Jul 2026 22:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671715; cv=none; b=u+MRjmRQ113JXMEYfYS8fhnjU0Y4LiRU4pRiR/HtZJCFQnIB1S2YBDq5CJ+s5X0sn50HMDIAY3PmD8KI53nqeHwMQPh9/iLs1DqM3VCH6VzNkM9qsDE9uMNM+oEvoNZFLe8D/giQgCj7huRo3ocrfljA00XRRqgSXqE4ppBqkPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671715; c=relaxed/simple;
	bh=IqjuhclT93qADlMZWHR9v/+cXlldm1P6XzPyRoeYHC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1/jBMONKUFZScJI/m2y6nvHKt/KwDODuOOmCoOcUDNSgQw2FBXIZ3tdx+bLUCTqt2tidZhM6lHzGYyiyUCy8D6W0wZrHQrWT6D/7yJltNEiY78ThYZOaCv519ky/+Wx+GbjRjM+py0JEmf1rLpIeeu2zVA3fSZLzNxagT2az9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qwvev/gR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qwvev/gR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196881F000E9;
	Tue, 21 Jul 2026 22:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671714;
	bh=NMB25ABU5kgSn11Ih0f0oDqEV+JkplievgsWs+yhJvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qwvev/gRhO3/8+mZetr7ogEoGCtDs9BGAlOvojinRU2o4c5mh9BSb3EmVOyPn+LMt
	 EJa2tVNRfP0g5x5eYURPOg9fIvgiEcTXgdf4F3RPDIHD6vTlrdO3OdqiARAb3prmke
	 da0KcbK/Mx6nNoRpWD/zK6KHQGziestCL0WpVYrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 349/843] crypto: cavium/cpt - fix DMA cleanup using wrong loop index
Date: Tue, 21 Jul 2026 17:19:44 +0200
Message-ID: <20260721152413.884918735@linuxfoundation.org>
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

[ Upstream commit 9dbf173bd32d5f81b005008b682bfb50aa093455 ]

The sg_cleanup error path used list[i] instead of list[j] when unmapping
DMA buffers, leaking successfully mapped entries and repeatedly unmapping
the failed one.

Fixes: c694b233295b ("crypto: cavium - Add the Virtual Function driver for CPT")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
index 153004bdfb5cde..753bdb2ae33f8d 100644
--- a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
+++ b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -108,8 +108,8 @@ static int setup_sgio_components(struct cpt_vf *cptvf, struct buf_ptr *list,
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



