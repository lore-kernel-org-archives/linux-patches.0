Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074BB307AD6;
	Mon, 13 Oct 2025 15:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368358; cv=none; b=ev0rxeEGjaJBtErjghFxGlsMyWveeAjgU0g3DnLRsHHb0Z3W5+3Ss7cdPERXNU/Gb/6Wj7tFLx31bfyLrz2i6uNTP7Fj9Y55szQTCebsKx+73yMBGSEF7RlSiwDg5T1bGQ9DyxIp0QH7ZdayUpyK4yFSgRipiEUxY3r900NO31w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368358; c=relaxed/simple;
	bh=/N/B7eQcwoprnayHjDG1E5EuaykzoftIRLy0jFc/zWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c9yEmS2WemauuMbeHG9vDUXQq1gZxKrex2dwyQ+uRMVI4XewEGFPpfyZolWiPTpjd8Qps7fgHcNcpYXQvvuOPw1iqDAsgg0vXaweRD3FegkJ5TOOhlnPY/ePNC7TRYI27g5aWwR8Dd90r3afYeJpgO+J96Xts+29z7K0l6HdRjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lxLydBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lxLydBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E90C4CEE7;
	Mon, 13 Oct 2025 15:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368357;
	bh=/N/B7eQcwoprnayHjDG1E5EuaykzoftIRLy0jFc/zWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2lxLydBNwpkHtz2DtcpnWbrqUnuj1OUuO9kvuETWWfLbnCVzybihhMIkBAoZ0MpE1
	 Uypqn0N7Sdpt/Flya+hVP4hkmAMq94YEoNMVhSQXk5rh/zTxCjWTSMRXThxJC54T9z
	 PaR044AwXlgWw3rtauNvNpfviYx8JvWBrHPRYja0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Or Har-Toov <ohartoov@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/262] RDMA/mlx5: Better estimate max_qp_wr to reflect WQE count
Date: Mon, 13 Oct 2025 16:44:08 +0200
Message-ID: <20251013144329.944922847@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 1a7c18c485bf17ef408d5ebb7f83e1f8ef329585 ]

The mlx5 driver currently derives max_qp_wr directly from the
log_max_qp_sz HCA capability:

    props->max_qp_wr = 1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);

However, this value represents the number of WQEs in units of Basic
Blocks (see MLX5_SEND_WQE_BB), not actual number of WQEs.  Since the size
of a WQE can vary depending on transport type and features (e.g., atomic
operations, UMR, LSO), the actual number of WQEs can be significantly
smaller than the WQEBB count suggests.

This patch introduces a conservative estimation of the worst-case WQE size
— considering largest segments possible with 1 SGE and no inline data or
special features. It uses this to derive a more accurate max_qp_wr value.

Fixes: 938fe83c8dcb ("net/mlx5_core: New device capabilities handling")
Link: https://patch.msgid.link/r/7d992c9831c997ed5c33d30973406dc2dcaf5e89.1755088725.git.leon@kernel.org
Reported-by: Chuck Lever <cel@kernel.org>
Closes: https://lore.kernel.org/all/20250506142202.GJ2260621@ziepe.ca/
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 48 ++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 435c456a4fd5b..29d0bc583169b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -13,6 +13,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/bitmap.h>
+#include <linux/log2.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/task.h>
@@ -865,6 +866,51 @@ static void fill_esw_mgr_reg_c0(struct mlx5_core_dev *mdev,
 	resp->reg_c0.mask = mlx5_eswitch_get_vport_metadata_mask();
 }
 
+/*
+ * Calculate maximum SQ overhead across all QP types.
+ * Other QP types (REG_UMR, UC, RC, UD/SMI/GSI, XRC_TGT)
+ * have smaller overhead than the types calculated below,
+ * so they are implicitly included.
+ */
+static u32 mlx5_ib_calc_max_sq_overhead(void)
+{
+	u32 max_overhead_xrc, overhead_ud_lso, a, b;
+
+	/* XRC_INI */
+	max_overhead_xrc = sizeof(struct mlx5_wqe_xrc_seg);
+	max_overhead_xrc += sizeof(struct mlx5_wqe_ctrl_seg);
+	a = sizeof(struct mlx5_wqe_atomic_seg) +
+	    sizeof(struct mlx5_wqe_raddr_seg);
+	b = sizeof(struct mlx5_wqe_umr_ctrl_seg) +
+	    sizeof(struct mlx5_mkey_seg) +
+	    MLX5_IB_SQ_UMR_INLINE_THRESHOLD / MLX5_IB_UMR_OCTOWORD;
+	max_overhead_xrc += max(a, b);
+
+	/* UD with LSO */
+	overhead_ud_lso = sizeof(struct mlx5_wqe_ctrl_seg);
+	overhead_ud_lso += sizeof(struct mlx5_wqe_eth_pad);
+	overhead_ud_lso += sizeof(struct mlx5_wqe_eth_seg);
+	overhead_ud_lso += sizeof(struct mlx5_wqe_datagram_seg);
+
+	return max(max_overhead_xrc, overhead_ud_lso);
+}
+
+static u32 mlx5_ib_calc_max_qp_wr(struct mlx5_ib_dev *dev)
+{
+	struct mlx5_core_dev *mdev = dev->mdev;
+	u32 max_wqe_bb_units = 1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
+	u32 max_wqe_size;
+	/* max QP overhead + 1 SGE, no inline, no special features */
+	max_wqe_size = mlx5_ib_calc_max_sq_overhead() +
+		       sizeof(struct mlx5_wqe_data_seg);
+
+	max_wqe_size = roundup_pow_of_two(max_wqe_size);
+
+	max_wqe_size = ALIGN(max_wqe_size, MLX5_SEND_WQE_BB);
+
+	return (max_wqe_bb_units * MLX5_SEND_WQE_BB) / max_wqe_size;
+}
+
 static int mlx5_ib_query_device(struct ib_device *ibdev,
 				struct ib_device_attr *props,
 				struct ib_udata *uhw)
@@ -1023,7 +1069,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->max_mr_size	   = ~0ull;
 	props->page_size_cap	   = ~(min_page_size - 1);
 	props->max_qp		   = 1 << MLX5_CAP_GEN(mdev, log_max_qp);
-	props->max_qp_wr	   = 1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
+	props->max_qp_wr = mlx5_ib_calc_max_qp_wr(dev);
 	max_rq_sg =  MLX5_CAP_GEN(mdev, max_wqe_sz_rq) /
 		     sizeof(struct mlx5_wqe_data_seg);
 	max_sq_desc = min_t(int, MLX5_CAP_GEN(mdev, max_wqe_sz_sq), 512);
-- 
2.51.0



