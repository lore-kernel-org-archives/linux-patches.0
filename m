Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CF41A2FCF;
	Thu,  6 Jun 2024 14:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683222; cv=none; b=m3Sesu6PiJ5/AgeGqRmoOGhA3R7Z+4rNggqR/mAbwjhwGy+YQWJm79MrUiYs1X/Wcketgp+JP8V4LomLkXtGsCS1tKPGJC4nZZSpPRMiMn1KR4RUUVuQSsHOHse1OKslT2Z0qEPTG2CeuIk0YvCfME8G1QjcRE88JvWgAvIkTic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683222; c=relaxed/simple;
	bh=RXJ2N2+h5rID4jMJkq9hMrK+vguUza1dlm108jJa2Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kqk8aKlwXFr4bFXk83peRRtOjBMaXOdJOgMvniejPGV98BOsMwJ4rutqzUpCatGqLhbrMnar8rBx2iRY8TTJTyq1onx7gUZH3951j2o+1hLDgAvJJrwqCdpA0/dPMPfmUB+Yp9h+Sak4Tgc0Et/I7urfoWxkoNvJ9mOoQTduWk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T56GraBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T56GraBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1499C2BD10;
	Thu,  6 Jun 2024 14:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683222;
	bh=RXJ2N2+h5rID4jMJkq9hMrK+vguUza1dlm108jJa2Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T56GraBKM8BRaqJ+Ipzy4BgxljVEpML/pxNM3+89Vxf+6BLkzy9l5G8ZRKl2LrubQ
	 55HPVSiHNo+16bjeZWjPoQNdTwyU7oG5T1XjNlKDVIkxRD8AanIuqgDghkj6Cg31he
	 q6PfhuFF7dEdWhlbpWC+xPSjCVWItjHgF3hXAYvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adham Faris <afaris@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/473] net/mlx5e: Fail with messages when params are not valid for XSK
Date: Thu,  6 Jun 2024 16:00:27 +0200
Message-ID: <20240606131703.134652301@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Adham Faris <afaris@nvidia.com>

[ Upstream commit 130b12079f3732babe2772314ab129bca0d8492f ]

Current XSK prerequisites validation implementation
(setup.c/mlx5e_validate_xsk_param()) fails silently when xsk
prerequisites are not fulfilled.
Add error messages to the kernel log to help the user understand what
went wrong when params are not valid for XSK.

Signed-off-by: Adham Faris <afaris@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: a5535e533694 ("mlx5: stop warning for 64KB pages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   |  9 +++++++--
 .../mellanox/mlx5/core/en/xsk/setup.c         | 19 +++++++++++++++++--
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index d3de1b7a80bf5..be7302aa6f864 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -581,11 +581,16 @@ int mlx5e_mpwrq_validate_xsk(struct mlx5_core_dev *mdev, struct mlx5e_params *pa
 	bool unaligned = xsk ? xsk->unaligned : false;
 	u16 max_mtu_pkts;
 
-	if (!mlx5e_check_fragmented_striding_rq_cap(mdev, page_shift, umr_mode))
+	if (!mlx5e_check_fragmented_striding_rq_cap(mdev, page_shift, umr_mode)) {
+		mlx5_core_err(mdev, "Striding RQ for XSK can't be activated with page_shift %u and umr_mode %d\n",
+			      page_shift, umr_mode);
 		return -EOPNOTSUPP;
+	}
 
-	if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params, xsk))
+	if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params, xsk)) {
+		mlx5_core_err(mdev, "Striding RQ linear mode for XSK can't be activated with current params\n");
 		return -EINVAL;
+	}
 
 	/* Current RQ length is too big for the given frame size, the
 	 * needed number of WQEs exceeds the maximum.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index ff03c43833bbf..81a567e172646 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -7,6 +7,18 @@
 #include "en/health.h"
 #include <net/xdp_sock_drv.h>
 
+static int mlx5e_legacy_rq_validate_xsk(struct mlx5_core_dev *mdev,
+					struct mlx5e_params *params,
+					struct mlx5e_xsk_param *xsk)
+{
+	if (!mlx5e_rx_is_linear_skb(mdev, params, xsk)) {
+		mlx5_core_err(mdev, "Legacy RQ linear mode for XSK can't be activated with current params\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* The limitation of 2048 can be altered, but shouldn't go beyond the minimal
  * stride size of striding RQ.
  */
@@ -17,8 +29,11 @@ bool mlx5e_validate_xsk_param(struct mlx5e_params *params,
 			      struct mlx5_core_dev *mdev)
 {
 	/* AF_XDP doesn't support frames larger than PAGE_SIZE. */
-	if (xsk->chunk_size > PAGE_SIZE || xsk->chunk_size < MLX5E_MIN_XSK_CHUNK_SIZE)
+	if (xsk->chunk_size > PAGE_SIZE || xsk->chunk_size < MLX5E_MIN_XSK_CHUNK_SIZE) {
+		mlx5_core_err(mdev, "XSK chunk size %u out of bounds [%u, %lu]\n", xsk->chunk_size,
+			      MLX5E_MIN_XSK_CHUNK_SIZE, PAGE_SIZE);
 		return false;
+	}
 
 	/* frag_sz is different for regular and XSK RQs, so ensure that linear
 	 * SKB mode is possible.
@@ -27,7 +42,7 @@ bool mlx5e_validate_xsk_param(struct mlx5e_params *params,
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		return !mlx5e_mpwrq_validate_xsk(mdev, params, xsk);
 	default: /* MLX5_WQ_TYPE_CYCLIC */
-		return mlx5e_rx_is_linear_skb(mdev, params, xsk);
+		return !mlx5e_legacy_rq_validate_xsk(mdev, params, xsk);
 	}
 }
 
-- 
2.43.0



