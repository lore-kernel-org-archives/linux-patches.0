Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F9A1FB3;
	Tue, 27 May 2025 17:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367942; cv=none; b=peeGTskxcWxR0VL/xaY5xmbbhhmvPQwnW3J2pfqUdz+gb4aT0aop1dOguUdOaCnQiDIbz58IYCtu3L/Hf0JZ/kyhhog7N7T0xQ1WgAbQAhyeYe8Qa/9/CpN41DXZv7x8dilPISSXH6BYNuoll5sloETLzRZOQQS770dKZJkzKGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367942; c=relaxed/simple;
	bh=tyMFPDeKLS7aBsjws22/un5c3qVTRi85Sy4Aams/T7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sk5ApAoQezsPqplGY1VTYSLIyFxGSbI6eOOxMGVnvaUncJrmcqcw1OtN1OuYZ0O3V8VzNdyCDMW6DrpIe/qxbQgs3bTEHZ7LHs7+O/Cexvmm1xBNPAhKKXtSOTdjulJ2dp1gGdRE4eJ1x+SpsljxPg2j0S7AkLeJYNH3i1YpUVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Km7HdbnW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Km7HdbnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F25C4CEE9;
	Tue, 27 May 2025 17:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367942;
	bh=tyMFPDeKLS7aBsjws22/un5c3qVTRi85Sy4Aams/T7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Km7HdbnWUryPVTSWn7h/FU3xUtk8QF8lxLsXlx5Bv2lHToqWviYKw4KfTLZiU40Ko
	 91YdxceBc1/bIR5Lvrx7tawKWosTLQG8VBhSeITowXj30l9RvJPtI6L3uRqG2KIQdB
	 HJLlpKySq2zVNLIM87bLu8kwdRl75v+B7cK9R1fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Tu <witu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 509/783] net/mlx5e: reduce the max log mpwrq sz for ECPF and reps
Date: Tue, 27 May 2025 18:25:06 +0200
Message-ID: <20250527162533.866821907@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Tu <witu@nvidia.com>

[ Upstream commit e1d68ea58c7e9ebacd9ad7a99b25a3578fa62182 ]

For the ECPF and representors, reduce the max MPWRQ size from 256KB (18)
to 128KB (17). This prepares the later patch for saving representor
memory.

With Striding RQ, there is a minimum of 4 MPWQEs. So with 128KB of max
MPWRQ size, the minimal memory is 4 * 128KB = 512KB. When creating page
pool, consider 1500 mtu, the minimal page pool size will be 512KB/4KB =
128 pages = 256 rx ring entries (2 entries per page).

Before this patch, setting RX ringsize (ethtool -G rx) to 256 causes
driver to allocate page pool size more than it needs due to max MPWRQ
is 256KB (18). Ex: 4 * 256KB = 1MB, 1MB/4KB = 256 pages, but actually
128 pages is good enough. Reducing the max MPWRQ to 128KB fixes the
limitation.

Signed-off-by: William Tu <witu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250209101716.112774-7-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  2 --
 .../net/ethernet/mellanox/mlx5/core/en/params.c   | 15 +++++++++++----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 8f9ec48ecc06d..769e683f24883 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -95,8 +95,6 @@ struct page_pool;
 #define MLX5_MPWRQ_DEF_LOG_STRIDE_SZ(mdev) \
 	MLX5_MPWRQ_LOG_STRIDE_SZ(mdev, order_base_2(MLX5E_RX_MAX_HEAD))
 
-#define MLX5_MPWRQ_MAX_LOG_WQE_SZ 18
-
 /* Keep in sync with mlx5e_mpwrq_log_wqe_sz.
  * These are theoretical maximums, which can be further restricted by
  * capabilities. These values are used for static resource allocations and
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 8c4d710e85675..58ec5e44aa7ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -10,6 +10,9 @@
 #include <net/page_pool/types.h>
 #include <net/xdp_sock_drv.h>
 
+#define MLX5_MPWRQ_MAX_LOG_WQE_SZ 18
+#define MLX5_REP_MPWRQ_MAX_LOG_WQE_SZ 17
+
 static u8 mlx5e_mpwrq_min_page_shift(struct mlx5_core_dev *mdev)
 {
 	u8 min_page_shift = MLX5_CAP_GEN_2(mdev, log_min_mkey_entity_size);
@@ -103,18 +106,22 @@ u8 mlx5e_mpwrq_log_wqe_sz(struct mlx5_core_dev *mdev, u8 page_shift,
 			  enum mlx5e_mpwrq_umr_mode umr_mode)
 {
 	u8 umr_entry_size = mlx5e_mpwrq_umr_entry_size(umr_mode);
-	u8 max_pages_per_wqe, max_log_mpwqe_size;
+	u8 max_pages_per_wqe, max_log_wqe_size_calc;
+	u8 max_log_wqe_size_cap;
 	u16 max_wqe_size;
 
 	/* Keep in sync with MLX5_MPWRQ_MAX_PAGES_PER_WQE. */
 	max_wqe_size = mlx5e_get_max_sq_aligned_wqebbs(mdev) * MLX5_SEND_WQE_BB;
 	max_pages_per_wqe = ALIGN_DOWN(max_wqe_size - sizeof(struct mlx5e_umr_wqe),
 				       MLX5_UMR_FLEX_ALIGNMENT) / umr_entry_size;
-	max_log_mpwqe_size = ilog2(max_pages_per_wqe) + page_shift;
+	max_log_wqe_size_calc = ilog2(max_pages_per_wqe) + page_shift;
+
+	WARN_ON_ONCE(max_log_wqe_size_calc < MLX5E_ORDER2_MAX_PACKET_MTU);
 
-	WARN_ON_ONCE(max_log_mpwqe_size < MLX5E_ORDER2_MAX_PACKET_MTU);
+	max_log_wqe_size_cap = mlx5_core_is_ecpf(mdev) ?
+			   MLX5_REP_MPWRQ_MAX_LOG_WQE_SZ : MLX5_MPWRQ_MAX_LOG_WQE_SZ;
 
-	return min_t(u8, max_log_mpwqe_size, MLX5_MPWRQ_MAX_LOG_WQE_SZ);
+	return min_t(u8, max_log_wqe_size_calc, max_log_wqe_size_cap);
 }
 
 u8 mlx5e_mpwrq_pages_per_wqe(struct mlx5_core_dev *mdev, u8 page_shift,
-- 
2.39.5



