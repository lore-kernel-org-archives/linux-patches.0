Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DEB47010C;
	Tue, 21 Jul 2026 17:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656725; cv=none; b=mPaTNODXvqfNw1Q2baG1ZOxjh6fdIq1bXZoUkgYU0FKGLMpYoiJUgvTrPcUQiaprRxzrMy7WqO9To8tOa1Wv8opcbde9TTHGhhyoNFAvWy5NRNsQk5HsMo06iMa7bwPVKdPvzeAE6/k0JdxuV0BMq+O5QEGKfIqIbXFxNziGph8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656725; c=relaxed/simple;
	bh=H2+vJ5OKIV+JkoUqsmsk1iDpDMLAtM0JtsyZuvhIwVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEWblUgiHfljl2B0PfHirOjHPrU5P1mdnw1jsxil7bJH8PrSJpn7SUNSAz7QuylVp+2s8UCBXbvQYg2SWJ2VRqS9j52O+xU/CxX0hmrgXfSNayGsxe0QpAfBzOknb74P8Sv8MI62//K7HjZIZMCrX2wRV/ayGdG9qNEKLgk2Lgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bitC/0+s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bitC/0+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508D41F000E9;
	Tue, 21 Jul 2026 17:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656723;
	bh=TV6a1l1mBhXlskf79UcBNAnvLcNfBrRnBI5Fj8JwgY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bitC/0+sSLIZhR3eZt24n3EC6AcPJx+9DgPObfxrLiO3zeQn76SAvScZPX3IfkZre
	 y9Y05PDBO7Z3G06kOPgss2z73yiUMnqyMw8zsGzlfmJddWsnWt0yj4x10OoUZU5dJU
	 c12uhfjfcg1Uoi2RKP2vYL6I8mX9lkUBP1TmE+jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0494/1611] crypto: cavium/cpt - fix DMA cleanup using wrong loop index
Date: Tue, 21 Jul 2026 17:10:10 +0200
Message-ID: <20260721152526.453693084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index fb59bb28245575..f35286bcbd664d 100644
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



