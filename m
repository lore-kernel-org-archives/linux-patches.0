Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0425A79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0F9C433F0;
	Thu, 12 Jan 2023 14:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534240;
	bh=5cFMZE45Bz8BmbazTYNe+iubCbJy3RRjk2aUQUDzbdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEFj+9rfHEniRoVZFJ8E+v2eT5QeuNy92+jQkp2GZhUVBmvfPEzJEz+8Uze7SPCRv
	 KxnmVe0A5hlE0u67z1Q984DRHwkuvrRX7YoxZ7TTcveNrWk8c3604uUFh6vkdO3htq
	 IoZ5AV39oDiWFVHWX1HyxyEvRYXD9DowYQjYTtCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 743/783] RDMA/mlx5: Fix validation of max_rd_atomic caps for DC
Date: Thu, 12 Jan 2023 14:57:39 +0100
Message-Id: <20230112135558.810180153@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit 8de8482fe5732fbef4f5af82bc0c0362c804cd1f ]

Currently, when modifying DC, we validate max_rd_atomic user attribute
against the RC cap, validate against DC. RC and DC QP types have different
device limitations.

This can cause userspace created DC QPs to malfunction.

Fixes: c32a4f296e1d ("IB/mlx5: Add support for DC Initiator QP")
Link: https://lore.kernel.org/r/0c5aee72cea188c3bb770f4207cce7abc9b6fc74.1672231736.git.leonro@nvidia.com
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 49 +++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 7a2bec0ac005..0caff276f2c1 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4258,6 +4258,40 @@ static bool mlx5_ib_modify_qp_allowed(struct mlx5_ib_dev *dev,
 	return false;
 }
 
+static int validate_rd_atomic(struct mlx5_ib_dev *dev, struct ib_qp_attr *attr,
+			      int attr_mask, enum ib_qp_type qp_type)
+{
+	int log_max_ra_res;
+	int log_max_ra_req;
+
+	if (qp_type == MLX5_IB_QPT_DCI) {
+		log_max_ra_res = 1 << MLX5_CAP_GEN(dev->mdev,
+						   log_max_ra_res_dc);
+		log_max_ra_req = 1 << MLX5_CAP_GEN(dev->mdev,
+						   log_max_ra_req_dc);
+	} else {
+		log_max_ra_res = 1 << MLX5_CAP_GEN(dev->mdev,
+						   log_max_ra_res_qp);
+		log_max_ra_req = 1 << MLX5_CAP_GEN(dev->mdev,
+						   log_max_ra_req_qp);
+	}
+
+	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC &&
+	    attr->max_rd_atomic > log_max_ra_res) {
+		mlx5_ib_dbg(dev, "invalid max_rd_atomic value %d\n",
+			    attr->max_rd_atomic);
+		return false;
+	}
+
+	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC &&
+	    attr->max_dest_rd_atomic > log_max_ra_req) {
+		mlx5_ib_dbg(dev, "invalid max_dest_rd_atomic value %d\n",
+			    attr->max_dest_rd_atomic);
+		return false;
+	}
+	return true;
+}
+
 int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		      int attr_mask, struct ib_udata *udata)
 {
@@ -4352,21 +4386,8 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		}
 	}
 
-	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC &&
-	    attr->max_rd_atomic >
-	    (1 << MLX5_CAP_GEN(dev->mdev, log_max_ra_res_qp))) {
-		mlx5_ib_dbg(dev, "invalid max_rd_atomic value %d\n",
-			    attr->max_rd_atomic);
-		goto out;
-	}
-
-	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC &&
-	    attr->max_dest_rd_atomic >
-	    (1 << MLX5_CAP_GEN(dev->mdev, log_max_ra_req_qp))) {
-		mlx5_ib_dbg(dev, "invalid max_dest_rd_atomic value %d\n",
-			    attr->max_dest_rd_atomic);
+	if (!validate_rd_atomic(dev, attr, attr_mask, qp_type))
 		goto out;
-	}
 
 	if (cur_state == new_state && cur_state == IB_QPS_RESET) {
 		err = 0;
-- 
2.35.1



