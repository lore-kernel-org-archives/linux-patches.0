Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C223D5242;
	Thu, 15 Jan 2026 17:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499636; cv=none; b=LhFYW61p8X9edu8/4siWn5UDC2XX/k3dE5qqN3mbPpWJS3QJR7KChZaD8Wbkh1qQMpPtOLjzVV2Vby3hyy6dibvPBASJhhN8/LnEaIaN/ysRT/AJ5mQFBuDle98uO8tlu1Ycoo3+KCsgSorNXqEOLhN0ww8rmh91oaPSykiKTOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499636; c=relaxed/simple;
	bh=phcAM1dAQnG5XGGPqmvyb+ASu1lwNxX+aRZGG0iE4SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwYTZiRrfQM7NoqmTgR5G6NpOxETrl1RV7YIOoegTX6S8KHJEFhF/8bYDVT3m0lAPYqALaiqrcyH+nxoaePv8k0eV2xx9ygTZkxcjDGVDbu+qDIjVlLXTKYlDl67xJ4ATPyQ2HGgrYGD1GM8eZnXXtKZHRBXp13QodYDJyneM9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZW9RfgxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZW9RfgxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BCCC116D0;
	Thu, 15 Jan 2026 17:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499636;
	bh=phcAM1dAQnG5XGGPqmvyb+ASu1lwNxX+aRZGG0iE4SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZW9RfgxGjEIb5lZEDHTVxeLf84Dc1/MrG/onacgLliQjf/7B7MtuwHDI0seMPHWqX
	 ZXjq3fEkACfQtagSI+v2CdXIsB1fYVS7ODRzghJ5m86TxiSCe/9+OPzIE4cxQuFqjo
	 EKhTaB7cRyGMMd4SedV5oo5iiXKTO4gTOkloAork=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 296/451] RDMA/bnxt_re: fix dma_free_coherent() pointer
Date: Thu, 15 Jan 2026 17:48:17 +0100
Message-ID: <20260115164241.597523880@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit fcd431a9627f272b4c0bec445eba365fe2232a94 ]

The dma_alloc_coherent() allocates a dma-mapped buffer, pbl->pg_arr[i].
The dma_free_coherent() should pass the same buffer to
dma_free_coherent() and not page-aligned.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20251230085121.8023-2-fourier.thomas@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 64e88104165e..8547a8512541 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -70,9 +70,7 @@ static void __free_pbl(struct bnxt_qplib_res *res, struct bnxt_qplib_pbl *pbl,
 		for (i = 0; i < pbl->pg_count; i++) {
 			if (pbl->pg_arr[i])
 				dma_free_coherent(&pdev->dev, pbl->pg_size,
-						  (void *)((unsigned long)
-						   pbl->pg_arr[i] &
-						  PAGE_MASK),
+						  pbl->pg_arr[i],
 						  pbl->pg_map_arr[i]);
 			else
 				dev_warn(&pdev->dev,
-- 
2.51.0



