Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F285F46A61A;
	Tue, 21 Jul 2026 15:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648546; cv=none; b=hdFxNaIpBB06rqUmgOk4pzLJ1dcX5sDjUztvLKIAWCMiqOhi9SdOin5XtwCJH3/9ZxY190v80TYJOQMCPGhAhbcyz1MHbZ9GnfzYfTRy+H/eIgcsXACBIcTjF6WP/eltV7TzQAR0XQF1wHinevN0VrBZBct+WbYRIa/P53HAJ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648546; c=relaxed/simple;
	bh=EtZz9x/xuPpz3mm9V+ZA2Z5qzomiTywA96QRGGQlNWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+FSDrfJcOCei8HxzCo27kTsUIpKL5/tc4X2fE2sg9odd833EzZQdaB2Fr3ASFMcSHOfGG9l+v7dLTfOTaCub0N/cljzwtV1u8nLBB5/HKhuV4ovh5UPrNvjtqpF0NEuqsqzipZshQWgrEKqD8s0Md0dDyvSB2e/Cxe9LSGsuJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RuYNk1O0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RuYNk1O0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F491F00ADB;
	Tue, 21 Jul 2026 15:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648544;
	bh=gg4dXkzGvUdFZG4L0cK3iIFoIxnClrx53NRr3bce+SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RuYNk1O0Lr7YnRfnpL9WyYkZsLYYieHgoi5eTG98CFa2kgEIvF+M0L3yvqucUtKPd
	 O156V0MWHF8H+6mUGQTEytmVCKxpr2ddCL0758i17ALPGuWmrr2zWtDRlxYEQFQ9vi
	 oKmA3neJw35T36bsErxLkYci+qZ1Yr73t7nJJX4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0223/2077] RDMA/mlx5: Fix UMR XLT cleanup on ODP populate failure
Date: Tue, 21 Jul 2026 16:58:16 +0200
Message-ID: <20260721152557.939763055@linuxfoundation.org>
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
index f2139474be3751..688d5246f284e8 100644
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



