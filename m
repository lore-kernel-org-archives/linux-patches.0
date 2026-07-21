Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BA233A9FC;
	Tue, 21 Jul 2026 20:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666136; cv=none; b=OYaNgfpEfV9nydSVwoaDTiF8dZ3QpJUs1XEbZ9+8c7tpB3fpBLUbYjTu/4O3cCu/umxnKZH9RrSnFzV+rXDAaCqmOp1qkKNKMIxUKj7zzhhph+LQvAFJVMtiD27oF+7F6bNtFVDqRL2pBu4s/dfAZDZPRyIeAsxSqcXdEizg7Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666136; c=relaxed/simple;
	bh=cvspG4W8F8isZG7P2p+KIi/LKF2z8sLA8E1WgBPbAbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSP4i+WfXG6InEOwhuIzjwMJKMH+Ij4kVAUCjvSYK3sfJg5UvZUp6IksVhvSiq5YCWHe4V3DPk4YZqpFz3aEU6L/K8DfNaInruHvsAsPiKCS9/bjdl8QtCnxG9KjEitwo4CicKBqDUWvcy2Q35nbrPFzU8cxudT+Vnxv0LtMQpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJH7A32m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJH7A32m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2C61F000E9;
	Tue, 21 Jul 2026 20:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666135;
	bh=ay7PqV0GofYB0NpxgZRZI06pvSjk8kj/VnodBhnBS+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJH7A32mI0yu4LHt9d+nO76yJf0xoNp7CGI0DBgpcYjYFX71MgLG+OaWIrTd5RZxs
	 z1R0MBjmYJxY6b0myoD+IMI0rkjunVbzO9LaykTae35Ks19TtRqJTRfY8qW4Z2U3g/
	 m43LEJcZ0n2Jcc5oTE9zsWzRGShM9wuf8ssZZ0t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0569/1266] crypto: cavium/cpt - fix DMA cleanup using wrong loop index
Date: Tue, 21 Jul 2026 17:16:46 +0200
Message-ID: <20260721152454.598140198@linuxfoundation.org>
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



