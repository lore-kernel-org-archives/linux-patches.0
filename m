Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA6220CCD8;
	Tue,  8 Apr 2025 11:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113433; cv=none; b=WXOz5+kTSflU4M3k9uJ0LaEpPQp8KmEdhTL/+8Jx5R+0rrX5HEMZXXnxHu8vVDiaTQgy7EtAPwrLCWZL5mE+a4gxm9peLvcW+p5w1vEQk3MHPQ7QMxCZtH7t3x/3IB2E6ZNlMzHSMvdi8sowFPJJGULn5KNtUU+BQEC0Ft6Wcug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113433; c=relaxed/simple;
	bh=OnT3XjOn4ZyJ6VzpElZrrpnUk/tVy/BOUq2u7eNKKkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHNW+bvCSRAbYV9sIlm+g+vPwU73Bb6X78IOgSzx646NAkUJ7Q/BosJRjb6lINqZN5nMs2l/RrOs3GV9ZH4AAfHdPXQVfNTAlxP1J5EfdWTlmYHHVkNd4n5RJvXC3l63CqOztC+ZYSYMdK+3oaznwKAc+2b9PbPkGt/WQQYxbZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7tvWAXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7tvWAXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1655C4CEE5;
	Tue,  8 Apr 2025 11:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113433;
	bh=OnT3XjOn4ZyJ6VzpElZrrpnUk/tVy/BOUq2u7eNKKkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7tvWAXcjPn58jHfztNGl00CVp4CIG3m9zS8055PZxV3oOITdTo/8Iilyd9k62GiM
	 cYRgVD+D4EgoOyi/8hXCW13I6om66RAFUBJAwDhTOgKEGpENiQuy6K8RAqOUbRu5C3
	 /adGIibtZgk+W6qdcRZVIdTQfjwo81YC0mn29NnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lama Kayal <lkayal@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/268] net/mlx5e: SHAMPO, Make reserved size independent of page size
Date: Tue,  8 Apr 2025 12:49:21 +0200
Message-ID: <20250408104832.582197450@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lama Kayal <lkayal@nvidia.com>

[ Upstream commit fab05835688526f9de123d1e98e4d1f838da4e22 ]

When hw-gro is enabled, the maximum number of header entries that are
needed per wqe (hd_per_wqe) is calculated based on the size of the
reservations among other parameters.

Miscalculation of the size of reservations leads to incorrect
calculation of hd_per_wqe as 0, particularly in the case of large page
size like in aarch64, this prevents the SHAMPO header from being
correctly initialized in the device, ultimately causing the following
cqe err that indicates a violation of PD.

 mlx5_core 0000:00:08.0 eth2: ERR CQE on RQ: 0x1180
 mlx5_core 0000:00:08.0 eth2: Error cqe on cqn 0x510, ci 0x0, qn 0x1180, opcode 0xe, syndrome  0x4, vendor syndrome 0x32
 00000000: 00 00 00 00 04 4a 00 00 00 00 00 00 20 00 93 32
 00000010: 55 00 00 00 fb cc 00 00 00 00 00 00 07 18 00 00
 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4a
 00000030: 00 00 00 9a 93 00 32 04 00 00 00 00 00 00 da e1

Use the correct formula for calculating the size of reservations,
precisely it shouldn't be dependent on page size, instead use the
correct multiply of MLX5E_SHAMPO_WQ_BASE_RESRV_SIZE.

Fixes: e5ca8fb08ab2 ("net/mlx5e: Add control path for SHAMPO feature")
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1742732906-166564-1-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 30507b7c2fb17..775010e94cb7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -408,7 +408,7 @@ u8 mlx5e_shampo_get_log_pkt_per_rsrv(struct mlx5_core_dev *mdev,
 				     struct mlx5e_params *params)
 {
 	u32 resrv_size = BIT(mlx5e_shampo_get_log_rsrv_size(mdev, params)) *
-			 PAGE_SIZE;
+			 MLX5E_SHAMPO_WQ_BASE_RESRV_SIZE;
 
 	return order_base_2(DIV_ROUND_UP(resrv_size, params->sw_mtu));
 }
@@ -881,7 +881,8 @@ static u32 mlx5e_shampo_get_log_cq_size(struct mlx5_core_dev *mdev,
 					struct mlx5e_params *params,
 					struct mlx5e_xsk_param *xsk)
 {
-	int rsrv_size = BIT(mlx5e_shampo_get_log_rsrv_size(mdev, params)) * PAGE_SIZE;
+	int rsrv_size = BIT(mlx5e_shampo_get_log_rsrv_size(mdev, params)) *
+		MLX5E_SHAMPO_WQ_BASE_RESRV_SIZE;
 	u16 num_strides = BIT(mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk));
 	int pkt_per_rsrv = BIT(mlx5e_shampo_get_log_pkt_per_rsrv(mdev, params));
 	u8 log_stride_sz = mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk);
@@ -1094,7 +1095,8 @@ u32 mlx5e_shampo_hd_per_wqe(struct mlx5_core_dev *mdev,
 			    struct mlx5e_params *params,
 			    struct mlx5e_rq_param *rq_param)
 {
-	int resv_size = BIT(mlx5e_shampo_get_log_rsrv_size(mdev, params)) * PAGE_SIZE;
+	int resv_size = BIT(mlx5e_shampo_get_log_rsrv_size(mdev, params)) *
+		MLX5E_SHAMPO_WQ_BASE_RESRV_SIZE;
 	u16 num_strides = BIT(mlx5e_mpwqe_get_log_num_strides(mdev, params, NULL));
 	int pkt_per_resv = BIT(mlx5e_shampo_get_log_pkt_per_rsrv(mdev, params));
 	u8 log_stride_sz = mlx5e_mpwqe_get_log_stride_size(mdev, params, NULL);
-- 
2.39.5



