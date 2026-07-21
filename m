Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D2647A870;
	Tue, 21 Jul 2026 17:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656422; cv=none; b=IO3O5tNEmsVyaF5/yLh7L12rnEUQbTtYKH2GKPelMiVcXvDl0oenb7InpLVcYaFfaX5/av3dBEklCFyS6B/DpqGOtbV6hSIp7dwzn07gT+v7RaSUIgEQ6Imj8eSbwlyMobmJj3NApEJ0xeHLEp6R4qSzrVTbUK02ImIfsh2tmS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656422; c=relaxed/simple;
	bh=YRtm+9iC8DJiLSmvafxSGnYiYli/WP0Xigefd4nEBic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDhfiVUkT/ofbuIet/Inj18iQaGM8VrLqzrMjyWiY+FgM/UlkksAMigKY64bczeoHKuV5mVb+6zpYdy8xFkliyvRwE9zg9MsqabPCMMzVUSfRbmFWvRndhr12rQ6NtruKHWvAcW1v7/gyHQpYRezOkD1PNPdpq6WOz5888UhjEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmBFLdcf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmBFLdcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96581F000E9;
	Tue, 21 Jul 2026 17:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656421;
	bh=dKaRBarDEsC5uUOqRz12GlqYGEODdn184ZJvV+deYMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WmBFLdcfPVxxo2jsnApuiCuJCsU1/ZTTym6c8oIe86nd1WMNgm6EJE8Cyq74Ol8sp
	 jmTxv7Q3rv/4sVxGzmNai3F7a8hQDbM8f3HrQqHK+pXgui/csWTiffA/Hb//U960bD
	 H+XDVXme9cpwsgVnAgrEWt6oepJdf+gIfb0AVRLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0382/1611] IB/mlx5: Remove unused mkc bits in mlx5r_umr_update_mr_page_shift()
Date: Tue, 21 Jul 2026 17:08:18 +0200
Message-ID: <20260721152523.795557859@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 4910483bd7ee2b40d0cc8ebd537fa33c95562029 ]

The HW only processes mkc fields selected by mkey_mask.
pd, qpn and mkey_7_0 are never selected so they can be left as zero.

This removes a racy read of mr->pd.

Fixes: e73242aa14d2 ("RDMA/mlx5: Optimize DMABUF mkey page size")
Link: https://patch.msgid.link/r/5-v1-29ebd2c229b5+fd5-ib_mr_pd_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/umr.c | 16 +++-------------
 drivers/infiniband/hw/mlx5/umr.h |  3 +--
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 71f331ce6d8940..3e2624cfd17f7d 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -937,8 +937,7 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
  * pinned and the HW can switch from 4K to huge-page alignment).
  */
 int mlx5r_umr_update_mr_page_shift(struct mlx5_ib_mr *mr,
-				   unsigned int page_shift,
-				   bool dd)
+				   unsigned int page_shift)
 {
 	struct mlx5_ib_dev *dev = mr_to_mdev(mr);
 	struct mlx5r_umr_wqe wqe = {};
@@ -953,16 +952,8 @@ int mlx5r_umr_update_mr_page_shift(struct mlx5_ib_mr *mr,
 	/* Fill mkey segment with the new page size, keep the rest unchanged */
 	MLX5_SET(mkc, &wqe.mkey_seg, log_page_size, page_shift);
 
-	if (dd)
-		MLX5_SET(mkc, &wqe.mkey_seg, pd, dev->ddr.pdn);
-	else
-		MLX5_SET(mkc, &wqe.mkey_seg, pd, to_mpd(mr->ibmr.pd)->pdn);
-
 	MLX5_SET64(mkc, &wqe.mkey_seg, start_addr, mr->ibmr.iova);
 	MLX5_SET64(mkc, &wqe.mkey_seg, len, mr->ibmr.length);
-	MLX5_SET(mkc, &wqe.mkey_seg, qpn, 0xffffff);
-	MLX5_SET(mkc, &wqe.mkey_seg, mkey_7_0,
-		 mlx5_mkey_variant(mr->mmkey.key));
 
 	err = mlx5r_umr_post_send_wait(dev, mr->mmkey.key, &wqe, false);
 	if (!err)
@@ -1049,7 +1040,7 @@ static int _mlx5r_umr_zap_mkey(struct mlx5_ib_mr *mr,
 	 * non-present.
 	 */
 	if (*nblocks) {
-		err = mlx5r_umr_update_mr_page_shift(mr, max_page_shift, dd);
+		err = mlx5r_umr_update_mr_page_shift(mr, max_page_shift);
 		if (err) {
 			mr->page_shift = old_page_shift;
 			return err;
@@ -1114,8 +1105,7 @@ int mlx5r_umr_dmabuf_update_pgsz(struct mlx5_ib_mr *mr, u32 xlt_flags,
 			goto err;
 	}
 
-	err = mlx5r_umr_update_mr_page_shift(mr, mr->page_shift,
-					     mr->data_direct);
+	err = mlx5r_umr_update_mr_page_shift(mr, mr->page_shift);
 	if (err)
 		goto err;
 	err = _mlx5r_dmabuf_umr_update_pas(mr, xlt_flags, 0, zapped_blocks,
diff --git a/drivers/infiniband/hw/mlx5/umr.h b/drivers/infiniband/hw/mlx5/umr.h
index e9361f0140e7b4..2797dda2b2bef0 100644
--- a/drivers/infiniband/hw/mlx5/umr.h
+++ b/drivers/infiniband/hw/mlx5/umr.h
@@ -105,8 +105,7 @@ int mlx5r_umr_update_mr_pas(struct mlx5_ib_mr *mr, unsigned int flags);
 int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 			 int page_shift, int flags);
 int mlx5r_umr_update_mr_page_shift(struct mlx5_ib_mr *mr,
-				   unsigned int page_shift,
-				   bool dd);
+				   unsigned int page_shift);
 int mlx5r_umr_dmabuf_update_pgsz(struct mlx5_ib_mr *mr, u32 xlt_flags,
 				 unsigned int page_shift);
 
-- 
2.53.0



