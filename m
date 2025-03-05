Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE311C5F2C;
	Wed,  5 Mar 2025 17:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197303; cv=none; b=ROnd37NBv9S6frxt3QTjW1mOaEVImnnFG7YZznc0GrP3kwAkbyqpnPUk1NOIyKKUHcHeWcWv9qx+KDyRSON5QxGc5AggDRamrjjng3yMla/JgNd/IiCE4KrWBS9hKDNLnT1iaV4WHTq0jbnleoMGvTDNxKJsOVSzRyHNf0/Wzpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197303; c=relaxed/simple;
	bh=TEz0YrwdAE2xbC1nm2NRhDyC91N/zT5o58y46PCIhzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbjkhcjls2ze4eR5LyQ4oGSrh+KZlOZl0dDDG5Mxb6IH3paCSPsjQFkRimP7KYG+NOPZNPuLGijF0NypTIYGkG29Av0p/2rVrcDdT86Cf8Bx/M9xL3eRjtNMk7x1buOOz46/T9Fcvhr4mzvpNeDYs8WzOZ+73exvT2qnEb+p1g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvAUfGpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvAUfGpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B81C4CEE9;
	Wed,  5 Mar 2025 17:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197303;
	bh=TEz0YrwdAE2xbC1nm2NRhDyC91N/zT5o58y46PCIhzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zvAUfGpjkPDd6SvcEcCRGkTOowkUw62TnO0ifhdSWPr48lkoCkDt5hEu9fedQCrdG
	 8Kup9p+KLtCYzeLfbbUh2qcC1PhufdE+a5w8sPuoq1f+Mu8LchIgwswA5RdOd4V9Q4
	 uGQWeWu+xOHoqNFxG8UVi43LGeyFRnetjrD2V9DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/176] RDMA/mlx5: Reduce QP table exposure
Date: Wed,  5 Mar 2025 18:47:59 +0100
Message-ID: <20250305174509.882571811@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 2ecfd946169e7f56534db2a5f6935858be3005ba ]

driver.h is common header to whole mlx5 code base, but struct
mlx5_qp_table is used in mlx5_ib driver only. So move that struct
to be under sole responsibility of mlx5_ib.

Link: https://lore.kernel.org/r/bec0dc1158e795813b135d1143147977f26bf668.1685953497.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Stable-dep-of: c534ffda781f ("RDMA/mlx5: Fix AH static rate parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/qp.h      | 11 ++++++++++-
 include/linux/mlx5/driver.h          |  9 ---------
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 024d2071c6a5d..5c533023a51a4 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -25,6 +25,7 @@
 #include <rdma/mlx5_user_ioctl_verbs.h>
 
 #include "srq.h"
+#include "qp.h"
 
 #define mlx5_ib_dbg(_dev, format, arg...)                                      \
 	dev_dbg(&(_dev)->ib_dev.dev, "%s:%d:(pid %d): " format, __func__,      \
diff --git a/drivers/infiniband/hw/mlx5/qp.h b/drivers/infiniband/hw/mlx5/qp.h
index fb2f4e030bb8f..e677fa0ca4226 100644
--- a/drivers/infiniband/hw/mlx5/qp.h
+++ b/drivers/infiniband/hw/mlx5/qp.h
@@ -6,7 +6,16 @@
 #ifndef _MLX5_IB_QP_H
 #define _MLX5_IB_QP_H
 
-#include "mlx5_ib.h"
+struct mlx5_ib_dev;
+
+struct mlx5_qp_table {
+	struct notifier_block nb;
+
+	/* protect radix tree
+	 */
+	spinlock_t lock;
+	struct radix_tree_root tree;
+};
 
 int mlx5_init_qp_table(struct mlx5_ib_dev *dev);
 void mlx5_cleanup_qp_table(struct mlx5_ib_dev *dev);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 6cea62ca76d6b..060610183fdf9 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -440,15 +440,6 @@ struct mlx5_core_health {
 	struct delayed_work		update_fw_log_ts_work;
 };
 
-struct mlx5_qp_table {
-	struct notifier_block   nb;
-
-	/* protect radix tree
-	 */
-	spinlock_t		lock;
-	struct radix_tree_root	tree;
-};
-
 enum {
 	MLX5_PF_NOTIFY_DISABLE_VF,
 	MLX5_PF_NOTIFY_ENABLE_VF,
-- 
2.39.5



