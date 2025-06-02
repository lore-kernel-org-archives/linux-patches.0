Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF5022D9E7;
	Mon,  2 Jun 2025 14:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873794; cv=none; b=Ze8LgCx3B74Kgi+tKNGWXvLQDr7KhiqoV4TEvAdVsM+FhSQ9zp3SGDQFuHlE0pb2jZNJCwWFr2n7c9OOhl42WsHiafc1VaJ+R7AIwGzQlAcCXVJvs7Li6f+Y6qLFgnnHgvcRITUVsWvZ+fH7Hvd0sJIa6kILQz3dUqQOUcppU/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873794; c=relaxed/simple;
	bh=VHzKz9N2WMK51JieCXLd6b7DCngHpEmtD5PB6RdWPcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFOm9EHywQPXPsXVDNumPQSpMs5WqNIz/bRgF5KSlOC0fXnNpmQOWTKlZlkESeGvLgO5YdKb36CI3Hz1WqztVe1vAaCsz3zFtSUHIlnhalKacH2RW3bvvf2jZl4rz2LWMnBWngSIfjTjf6ahnIavHVfkrYTozYxlw3ohlD223PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y41zyaJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y41zyaJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9DCC4CEEB;
	Mon,  2 Jun 2025 14:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873794;
	bh=VHzKz9N2WMK51JieCXLd6b7DCngHpEmtD5PB6RdWPcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y41zyaJPhUA0bsSJrmW93yxjItHrm+Qsq372o2XgllVs3I0zcG7JSQLN+VIuZwpUE
	 dNryRl4nhVz/xN7BcgpO0oMNAfPddjePl9zmHT3y7OvcfiR7t7WUVJmLRtnL/RhDgn
	 3zyrXO2rbhtm6Elm7jt1BhMN9DyRGg+QMmfF5r1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Tu <witu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 255/444] net/mlx5e: reduce the max log mpwrq sz for ECPF and reps
Date: Mon,  2 Jun 2025 15:45:19 +0200
Message-ID: <20250602134351.280144602@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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
index 20a6bc1a234f4..9cf33ae48c216 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -93,8 +93,6 @@ struct page_pool;
 #define MLX5_MPWRQ_DEF_LOG_STRIDE_SZ(mdev) \
 	MLX5_MPWRQ_LOG_STRIDE_SZ(mdev, order_base_2(MLX5E_RX_MAX_HEAD))
 
-#define MLX5_MPWRQ_MAX_LOG_WQE_SZ 18
-
 /* Keep in sync with mlx5e_mpwrq_log_wqe_sz.
  * These are theoretical maximums, which can be further restricted by
  * capabilities. These values are used for static resource allocations and
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 775010e94cb7c..dcd5db907f102 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -9,6 +9,9 @@
 #include <net/page_pool/types.h>
 #include <net/xdp_sock_drv.h>
 
+#define MLX5_MPWRQ_MAX_LOG_WQE_SZ 18
+#define MLX5_REP_MPWRQ_MAX_LOG_WQE_SZ 17
+
 static u8 mlx5e_mpwrq_min_page_shift(struct mlx5_core_dev *mdev)
 {
 	u8 min_page_shift = MLX5_CAP_GEN_2(mdev, log_min_mkey_entity_size);
@@ -102,18 +105,22 @@ u8 mlx5e_mpwrq_log_wqe_sz(struct mlx5_core_dev *mdev, u8 page_shift,
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



