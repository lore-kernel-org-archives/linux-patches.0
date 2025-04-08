Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF94826F471;
	Tue,  8 Apr 2025 12:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115868; cv=none; b=ly2MTIA95Zx0k9GsBWhiaTAnAst09xXGw6wHx6BE6mC53+w55qxGaO//v5qZBmP/yUqgt/NHKJ1KbA1MdxfJDi+Z2LgSPy7idXXqLHpDSUx4vm9sRq8u3hRtq+eagj/fbXxFOChiZqwQX1z56a7h3OznYN2069KHeTuhNQaBFec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115868; c=relaxed/simple;
	bh=8L2jviRZbOJgV7QB/p7V2ONdh/meuJldiZBZMnF3dPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qd0ij7/yO/PkcUaLS7u3wqXIvFw3tDwNvRDcs/hXe8Nd1QYA7WtwkhRhwLu5GBZioVdF/62l1dCWKJiVIlC16xO7eQgI9Qt/rYaij2Ut0ITW61/0HrnNMIxvwHez3vFDe6sJuKd1RB5pf1bU8rqkyyG+Lsm57PSRNpj0pf8zt98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/+TL0Tw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/+TL0Tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D611C4CEE7;
	Tue,  8 Apr 2025 12:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115868;
	bh=8L2jviRZbOJgV7QB/p7V2ONdh/meuJldiZBZMnF3dPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/+TL0TwGe4ucsBN94sGKbkFDJSCpHRr2+S9RgUJsK87DSxuy3t6gVJ18xjZqsY86
	 f7C90paaZPYkf2Vd+6enRMQ9kMRAe2wxe5zqtYQpXFa3EU3TxycP4r8OZK4+zKY9+b
	 a7cd9inMnf2mRaNsYZLvSHrpgf/h3GtjuzrdEUnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lama Kayal <lkayal@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/204] net/mlx5e: SHAMPO, Make reserved size independent of page size
Date: Tue,  8 Apr 2025 12:50:47 +0200
Message-ID: <20250408104823.751151026@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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
index be7302aa6f864..33cc53f221e0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -390,7 +390,7 @@ u8 mlx5e_shampo_get_log_pkt_per_rsrv(struct mlx5_core_dev *mdev,
 				     struct mlx5e_params *params)
 {
 	u32 resrv_size = BIT(mlx5e_shampo_get_log_rsrv_size(mdev, params)) *
-			 PAGE_SIZE;
+			 MLX5E_SHAMPO_WQ_BASE_RESRV_SIZE;
 
 	return order_base_2(DIV_ROUND_UP(resrv_size, params->sw_mtu));
 }
@@ -818,7 +818,8 @@ static u32 mlx5e_shampo_get_log_cq_size(struct mlx5_core_dev *mdev,
 					struct mlx5e_params *params,
 					struct mlx5e_xsk_param *xsk)
 {
-	int rsrv_size = BIT(mlx5e_shampo_get_log_rsrv_size(mdev, params)) * PAGE_SIZE;
+	int rsrv_size = BIT(mlx5e_shampo_get_log_rsrv_size(mdev, params)) *
+		MLX5E_SHAMPO_WQ_BASE_RESRV_SIZE;
 	u16 num_strides = BIT(mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk));
 	int pkt_per_rsrv = BIT(mlx5e_shampo_get_log_pkt_per_rsrv(mdev, params));
 	u8 log_stride_sz = mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk);
@@ -1027,7 +1028,8 @@ u32 mlx5e_shampo_hd_per_wqe(struct mlx5_core_dev *mdev,
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



