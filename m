Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849CC34B1A6;
	Tue, 21 Jul 2026 22:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673707; cv=none; b=GNoCPDsSWD3zbCkBOrkMVu+rnjnHV8b4azg/VRVEZ+7KwULm/e5OF5k+ysOP4YE4T82w2OAlJINawsGrN3s9o3wZgSJo1ZgRx+LTVjXcHKrSnJ7AzOhlmcqz9gOBmv/EQQUL+gQKdyeIVfusKus8IOmhQWw6aBKtdfdf2OL2FYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673707; c=relaxed/simple;
	bh=vh1Fhx/LoNCdBQS4wJ4SaK/bX6i7FxxXM+j428N0UlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5nkNOcaeLzrpqilkz/RsrWVTQZ1C1sOhXftqqjppmctQayz1MduCQaqiUlyGIASz+Uknf/gzQz45BTq3FfbLJMF79e40S2LCpkRqNwbMWKeSS33nrthWue/uDh6quQbCcJZCCj59fXp2sJSiZ80V6BDclSWmUd38UnwvrL8Jcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iffJQo0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iffJQo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97DB1F000E9;
	Tue, 21 Jul 2026 22:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673706;
	bh=ROYEJaU+chYe8bz95Wa2JiJCA9tCV0UiLg/qJHxojGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1iffJQo055qKJh9+JVHNjXLK3NL08JeBYVxb3zVv/lku0liypccxeT89PDebYDaeJ
	 MsjKLmumkYv5Qn3U22Uknaomv7iaEjN9hZoOchV+3ySSrauXRFmfRCeFymyLSy+3TW
	 CWOSLGHgaUIL12Oj++JHuxHA3NglH9hGqZRWEJXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 262/699] crypto: cavium/cpt - fix DMA cleanup using wrong loop index
Date: Tue, 21 Jul 2026 17:20:21 +0200
Message-ID: <20260721152401.610333280@linuxfoundation.org>
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
index 4fe7898c85615a..fb55c5b1ddedbd 100644
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



