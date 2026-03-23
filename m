Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76CF3AC0E3;
	Mon, 23 Mar 2026 13:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274338; cv=none; b=j4YDDNGqFj3esCMCV02XfQOBVDQ7tp9H05f29d61cI4NULoPUr5IMEMSJfWcG95Oc7HS5ALMiBSya/PuUE4RPw5Q7/eGgRw6k+BHAyYivSUBNVrBlJlGhnIq+URys/X7VybeMJPWArY9epY47Q+nkasml1FUwil8pelWfT4sThM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274338; c=relaxed/simple;
	bh=d0hR0zUBV/uH/cg9R0IJL6WlE2hs5vPkYgbmr6PeAv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8St+9N7ex/3FxQbNurt/tooE6sIjeSvWSpKyZRyDvC2e3nSDbbJ2k/IORAcWXMg18jPfCALjTGWzq3FccC5BFQcFrhQVqxQyle/7TCbD3vqI8GOOQFA4h5SIt67Gb4MtJFfvdQICgvVfR0CxliK645BNY3XwoAcezAAfnk15d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7Bwp3rz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7Bwp3rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550F7C4CEF7;
	Mon, 23 Mar 2026 13:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274338;
	bh=d0hR0zUBV/uH/cg9R0IJL6WlE2hs5vPkYgbmr6PeAv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7Bwp3rzgu6es86gEoPcutp1VUaoyE1ebCOH/MqRq2YIk37FNlNQb9HQw5ETZkxxY
	 4AeCtaFDt12Kj3nw8JiBNDi5CAqDY4UfTNQapGe4aeR3sYU7oL7+4BhDRtGiBwjCKJ
	 mjZeWUdWgILCrXH0yt01imu+IZ0oN9+q+zFg5Vlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 169/220] net/mlx5e: Prevent concurrent access to IPSec ASO context
Date: Mon, 23 Mar 2026 14:45:46 +0100
Message-ID: <20260323134509.886300249@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 99b36850d881e2d65912b2520a1c80d0fcc9429a ]

The query or updating IPSec offload object is through Access ASO WQE.
The driver uses a single mlx5e_ipsec_aso struct for each PF, which
contains a shared DMA-mapped context for all ASO operations.

A race condition exists because the ASO spinlock is released before
the hardware has finished processing WQE. If a second operation is
initiated immediately after, it overwrites the shared context in the
DMA area.

When the first operation's completion is processed later, it reads
this corrupted context, leading to unexpected behavior and incorrect
results.

This commit fixes the race by introducing a private context within
each IPSec offload object. The shared ASO context is now copied to
this private context while the ASO spinlock is held. Subsequent
processing uses this saved, per-object context, ensuring its integrity
is maintained.

Fixes: 1ed78fc03307 ("net/mlx5e: Update IPsec soft and hard limits")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260316094603.6999-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec.h         |  1 +
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c | 17 ++++++++---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index f8eaaf37963b1..abcbd38db9dbb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -287,6 +287,7 @@ struct mlx5e_ipsec_sa_entry {
 	struct mlx5e_ipsec_dwork *dwork;
 	struct mlx5e_ipsec_limits limits;
 	u32 rx_mapped_id;
+	u8 ctx[MLX5_ST_SZ_BYTES(ipsec_aso)];
 };
 
 struct mlx5_accel_pol_xfrm_attrs {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index ef7322d381af6..2739ff490239d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -370,20 +370,18 @@ static void mlx5e_ipsec_aso_update_soft(struct mlx5e_ipsec_sa_entry *sa_entry,
 static void mlx5e_ipsec_handle_limits(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
-	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
-	struct mlx5e_ipsec_aso *aso = ipsec->aso;
 	bool soft_arm, hard_arm;
 	u64 hard_cnt;
 
 	lockdep_assert_held(&sa_entry->x->lock);
 
-	soft_arm = !MLX5_GET(ipsec_aso, aso->ctx, soft_lft_arm);
-	hard_arm = !MLX5_GET(ipsec_aso, aso->ctx, hard_lft_arm);
+	soft_arm = !MLX5_GET(ipsec_aso, sa_entry->ctx, soft_lft_arm);
+	hard_arm = !MLX5_GET(ipsec_aso, sa_entry->ctx, hard_lft_arm);
 	if (!soft_arm && !hard_arm)
 		/* It is not lifetime event */
 		return;
 
-	hard_cnt = MLX5_GET(ipsec_aso, aso->ctx, remove_flow_pkt_cnt);
+	hard_cnt = MLX5_GET(ipsec_aso, sa_entry->ctx, remove_flow_pkt_cnt);
 	if (!hard_cnt || hard_arm) {
 		/* It is possible to see packet counter equal to zero without
 		 * hard limit event armed. Such situation can be if packet
@@ -454,10 +452,8 @@ static void mlx5e_ipsec_handle_event(struct work_struct *_work)
 		container_of(_work, struct mlx5e_ipsec_work, work);
 	struct mlx5e_ipsec_sa_entry *sa_entry = work->data;
 	struct mlx5_accel_esp_xfrm_attrs *attrs;
-	struct mlx5e_ipsec_aso *aso;
 	int ret;
 
-	aso = sa_entry->ipsec->aso;
 	attrs = &sa_entry->attrs;
 
 	spin_lock_bh(&sa_entry->x->lock);
@@ -466,8 +462,9 @@ static void mlx5e_ipsec_handle_event(struct work_struct *_work)
 		goto unlock;
 
 	if (attrs->replay_esn.trigger &&
-	    !MLX5_GET(ipsec_aso, aso->ctx, esn_event_arm)) {
-		u32 mode_param = MLX5_GET(ipsec_aso, aso->ctx, mode_parameter);
+	    !MLX5_GET(ipsec_aso, sa_entry->ctx, esn_event_arm)) {
+		u32 mode_param = MLX5_GET(ipsec_aso, sa_entry->ctx,
+					  mode_parameter);
 
 		mlx5e_ipsec_update_esn_state(sa_entry, mode_param);
 	}
@@ -629,6 +626,8 @@ int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry,
 			/* We are in atomic context */
 			udelay(10);
 	} while (ret && time_is_after_jiffies(expires));
+	if (!ret)
+		memcpy(sa_entry->ctx, aso->ctx, MLX5_ST_SZ_BYTES(ipsec_aso));
 	spin_unlock_bh(&aso->lock);
 	return ret;
 }
-- 
2.51.0



