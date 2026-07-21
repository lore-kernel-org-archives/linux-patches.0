Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06064326D44;
	Tue, 21 Jul 2026 17:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655825; cv=none; b=k26Aty5z8quD+7qBEfge36PFOhIV88zx8IoSloV4bW7u1n6CqrkmH7EC2JGKP+QGlHLCKGGDxieE8ja6bpVTfBDMyfEQ9/aaxaEN3sswruRSOu9P4i4OqMEFqaEjeS4gZqACM9XKZTBekx3ZK0/NRThKryFU9AGe2TW6t1rHcbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655825; c=relaxed/simple;
	bh=rXCpBuAkb/HGqMXFrOwqlSoaUIyqev9eqxlcywzdU48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+Hv6IKP63EY/eaVG1odIkJrqS96NWFG4sY5LWYNgbhT+EHncNnD72vIB1C7nKQPcbvI9QTwJWrMQ9NGld6Kt4JMewj+3vgSEImt9zy8pOB+eXDAmu7u5UCfYuTP0C2RSKjSCDLIDPWaVtmYDMcVdTOTTsHsHKKQIK3i9cTKGpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWFk/D63; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWFk/D63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AADF1F00A3A;
	Tue, 21 Jul 2026 17:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655823;
	bh=cmv68s9Xiy0pZWVdTxltdYmIedqVNZ1InM3VLAf8LrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWFk/D63zJVImJtZtFurfp3S6IKdiIuxB2Ya0iYdbEepYfdITbA9STHTDOXKJB/WQ
	 YMQ6CYO/4mcR5qQI7SFhG9sKoooL4uvYlq9/hviSvWs2LMv6ODIUS7Goun8OSt+v3X
	 qIflAKYRJeOF8cZX4hCN+iHTWhXhuRwiRS2V9sr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0156/1611] RDMA/mlx5: Fix UMR XLT cleanup on ODP populate failure
Date: Tue, 21 Jul 2026 17:04:32 +0200
Message-ID: <20260721152518.389132819@linuxfoundation.org>
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

From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

[ Upstream commit 1eae35b37923cb71b0cb5136d00671440d488b9f ]

mlx5r_umr_update_xlt() allocates and DMA maps an XLT buffer with
mlx5r_umr_create_xlt(). The buffer is released by the common cleanup path
through mlx5r_umr_unmap_free_xlt().

After mlx5_odp_populate_xlt() became fallible, its error path returned
directly and skipped that cleanup. This leaks the XLT DMA mapping and
buffer. If the emergency XLT page was used, it also leaves
xlt_emergency_page_mutex locked.

Break out of the loop so execution falls through the existing cleanup path.

Fixes: 1efe8c0670d6 ("RDMA/core: Convert UMEM ODP DMA mapping to caching IOVA and page linkage")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Link: https://patch.msgid.link/20260426132356.22264-1-prathameshdeshpande7@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/umr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 29488fba21a034..71f331ce6d8940 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -915,7 +915,7 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 		 */
 		err = mlx5_odp_populate_xlt(xlt, idx, npages, mr, flags);
 		if (err)
-			return err;
+			break;
 		dma_sync_single_for_device(ddev, sg.addr, sg.length,
 					   DMA_TO_DEVICE);
 		sg.length = ALIGN(size_to_map, MLX5_UMR_FLEX_ALIGNMENT);
-- 
2.53.0



