Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4F91FBCB5;
	Tue, 26 Aug 2025 13:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215488; cv=none; b=eIWpSXOqX/cllZsRkigbt4tYPqOf3Zh50FrRqHYOEyx9sjgIzS7mgHslMaOKZTkH5AwSOvnUag9pJMhh6rdFKN8eASYDTKc1VaRYDrwiErlWMXjnD/BLGTvr62edep7XF6ZuwvVkEMKIly5LsDk3qcUJFgc2f/pfyKBzSE6dlhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215488; c=relaxed/simple;
	bh=ESDXAehDKWCAF9eCknbJJQafpYj0JfFnPgk8Q3teKKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjsQeQuRMXKXA3eT82FYjZIkotxm6YgRxmM8BrszSuwAbFnnIM96k0KTNJHUSbAepyQ3Lk+MCEh8BdD7IZZJLjjxIOGYdDqZ2Ig/1Qyb5qoKeQUfVPcwtA7oAx40HhvQTou5tzfO+H1wKNv0in1Cw4RdJMZrWyrA7yO4VNALhrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qb4cJMZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qb4cJMZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C263C4CEF1;
	Tue, 26 Aug 2025 13:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215488;
	bh=ESDXAehDKWCAF9eCknbJJQafpYj0JfFnPgk8Q3teKKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qb4cJMZO4kuByoD62j1uCgkGLssHocXGzAzRRgr4+dmyrFPOhSOqRF569Hkr/1nnM
	 K3Yh+6F7E98L8lhsXgb2eoe2kXXvJAlm90IOjT6WHHbuG0ARbZYn8UvmfLMWRccOkr
	 9pYvD6GYIB2T9sUvZo61HPpThN8DsOgiN0SsF//w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Ben-Ishay <benishay@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/644] net/mlx5e: Add support to klm_umr_wqe
Date: Tue, 26 Aug 2025 13:02:23 +0200
Message-ID: <20250826110947.790731779@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Ben-Ishay <benishay@nvidia.com>

[ Upstream commit d7b896acbdcb3ef5dab1fd2f33ba5a8da6ba1dda ]

This commit adds the needed definitions for using the klm_umr_wqe.
UMR stands for user-mode memory registration, is a mechanism to alter
address translation properties of MKEY by posting WorkQueueElement
aka WQE on send queue.
MKEY stands for memory key, MKEY are used to describe a region in memory that
can be later used by HW.
KLM stands for {Key, Length, MemVa}, KLM_MKEY is indirect MKEY that enables
to map multiple memory spaces with different sizes in unified MKEY.
klm_umr_wqe is a UMR that use to update a KLM_MKEY.
SHAMPO feature uses KLM_MKEY for memory registration of his header buffer.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 531d0d32de3e ("net/mlx5: Correctly set gso_size when LRO is used")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 24 +++++++++++++++++++-
 include/linux/mlx5/device.h                  |  1 +
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index c822c3ac0544b..4f711f1af6c1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -152,6 +152,25 @@ struct page_pool;
 #define MLX5E_UMR_WQEBBS \
 	(DIV_ROUND_UP(MLX5E_UMR_WQE_INLINE_SZ, MLX5_SEND_WQE_BB))
 
+#define MLX5E_KLM_UMR_WQE_SZ(sgl_len)\
+	(sizeof(struct mlx5e_umr_wqe) +\
+	(sizeof(struct mlx5_klm) * (sgl_len)))
+
+#define MLX5E_KLM_UMR_WQEBBS(klm_entries) \
+	(DIV_ROUND_UP(MLX5E_KLM_UMR_WQE_SZ(klm_entries), MLX5_SEND_WQE_BB))
+
+#define MLX5E_KLM_UMR_DS_CNT(klm_entries)\
+	(DIV_ROUND_UP(MLX5E_KLM_UMR_WQE_SZ(klm_entries), MLX5_SEND_WQE_DS))
+
+#define MLX5E_KLM_MAX_ENTRIES_PER_WQE(wqe_size)\
+	(((wqe_size) - sizeof(struct mlx5e_umr_wqe)) / sizeof(struct mlx5_klm))
+
+#define MLX5E_KLM_ENTRIES_PER_WQE(wqe_size)\
+	ALIGN_DOWN(MLX5E_KLM_MAX_ENTRIES_PER_WQE(wqe_size), MLX5_UMR_KLM_ALIGNMENT)
+
+#define MLX5E_MAX_KLM_PER_WQE(mdev) \
+	MLX5E_KLM_ENTRIES_PER_WQE(MLX5E_TX_MPW_MAX_NUM_DS << MLX5_MKEY_BSF_OCTO_SIZE)
+
 #define MLX5E_MSG_LEVEL			NETIF_MSG_LINK
 
 #define mlx5e_dbg(mlevel, priv, format, ...)                    \
@@ -217,7 +236,10 @@ struct mlx5e_umr_wqe {
 	struct mlx5_wqe_ctrl_seg       ctrl;
 	struct mlx5_wqe_umr_ctrl_seg   uctrl;
 	struct mlx5_mkey_seg           mkc;
-	struct mlx5_mtt                inline_mtts[0];
+	union {
+		struct mlx5_mtt inline_mtts[0];
+		struct mlx5_klm inline_klms[0];
+	};
 };
 
 extern const char mlx5e_self_tests[][ETH_GSTRING_LEN];
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 476d8fd5a7e5b..afc7e2d81b6d8 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -290,6 +290,7 @@ enum {
 	MLX5_UMR_INLINE			= (1 << 7),
 };
 
+#define MLX5_UMR_KLM_ALIGNMENT 4
 #define MLX5_UMR_MTT_ALIGNMENT 0x40
 #define MLX5_UMR_MTT_MASK      (MLX5_UMR_MTT_ALIGNMENT - 1)
 #define MLX5_UMR_MTT_MIN_CHUNK_SIZE MLX5_UMR_MTT_ALIGNMENT
-- 
2.39.5



