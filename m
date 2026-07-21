Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1FF46EC6F;
	Tue, 21 Jul 2026 18:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659763; cv=none; b=h/nwUNGHq3G5o5UlM/y0GPKZ82LHYwFWXug0jCcMytUJd1GavpynqGWfZD7o/u1kBTXuOeo8UXfU9UQmV7QkZz1jKIkgEwOIjs+wCWeNJdiFs426a0HMCGIhy1YlYGVhXsWWoo607M5JKHcJh52XWgzrOFR7I+Lr+CQ0WA1H+4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659763; c=relaxed/simple;
	bh=0WfqjAS5Ufq1kGrHGVXFVY2F4l+FVn/taDi4k2pyHfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXVdD3+eQoTfIB1gjYRE6hKg2XcVPzHNIYchuhP5qcwieovlig8YvqGdzXIs64MYqoWrirp28pudPFcJ8/a6F0VX6RlS4+mbjnStefQv7g5yuOx1+mWmPRb/SptW7Szm7fs/JwNVd6NtmV22DOY/JY4IMeto/sQE0KBj/IlFx7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXlw3Tm7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXlw3Tm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D352F1F000E9;
	Tue, 21 Jul 2026 18:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659762;
	bh=4fJkFSBZm3JYojbds9DGaf0vMx8U1h2aq0LgL5o9kwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iXlw3Tm7JHn87HWKTRdjJyO9+MQLa3Z69VNUKTzd4tB1RUfMBjrOo+nIryNbMWnuk
	 +ven1JSpHJYOWEe5xe+Mn0My7lGuG8G2y55R9beDVUjFGjpZZ4tFa8ty4IRstRYnkr
	 gkfNN6wQD7E3NIx9y3DpD1Nx7WruXks6IpJmtiCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0723/2077] crypto: cavium/cpt - fix DMA cleanup using wrong loop index
Date: Tue, 21 Jul 2026 17:06:36 +0200
Message-ID: <20260721152609.853498475@linuxfoundation.org>
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
index e183b60277ff1e..de305cbeccbe0e 100644
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



