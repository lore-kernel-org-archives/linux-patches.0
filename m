Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F542FD1C5;
	Wed,  3 Dec 2025 16:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779812; cv=none; b=eSi7fWa77JCtxbPWlRRSvlJt9nEGFgeQBXjdUUTg4ifFYN34qUzcdXrkvlrSHUSDeSmzMg3TtYxu9C8j/Tk1bNsxQgjtEPvsPDPVVfZWl/pmbQpGcuJnzh5FOwpKXSEh0n1GomYeYLbGeifhgfyqA+JVmI8/i4WLxs/nDNTGxQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779812; c=relaxed/simple;
	bh=wt12OHvqNjwSsibexWBOSt+2B8FYYVBWEwG6F24VVp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Apmz2wAHGrvBTvqhsVOMKihHV+DJUpsjoEF1aNdQ6ONEDUrG2eCKU44xbFskhUpFDuskfquUUx6q69/iO9kTL3z1AHOq7UCtm8s3rnm0avualoIWgVCJKo/OZrWI1ExsyW11ZXUfPgi/dRZlyX+tE8Lz3yFdobRJocuBHvuWl+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8nIlaNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8nIlaNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4F7C4CEF5;
	Wed,  3 Dec 2025 16:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779812;
	bh=wt12OHvqNjwSsibexWBOSt+2B8FYYVBWEwG6F24VVp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8nIlaNF7f1rdPouSJ5Ak9dZMiL7r+9TQ+nNynXTXX6xEYUfDQvdlrBMTkcgePlbH
	 5/C/U2ORAzxJXqgeggdNfvKfiOSyXJHU5IR2e12nVJUBGi50Pgjn8v3uYGFCLRksFk
	 RaTOxjV520cO0pgm1Eyicz3wH1dIKeo6rZsoCrq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 369/568] net/mlx5e: Add API to query/modify SBPR and SBCM registers
Date: Wed,  3 Dec 2025 16:26:11 +0100
Message-ID: <20251203152454.213249732@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit 11f0996d5c6023f4889882c8d088ec76a050d704 ]

To allow users to configure shared receive buffer parameters through
dcbnl callbacks, expose an API to query and modify SBPR and SBCM registers,
which will be used in the upcoming patch.

Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 9fcc2b6c1052 ("net/mlx5e: Fix potentially misleading debug message")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 72 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/port.h |  6 ++
 2 files changed, 78 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 89510cac46c22..505ba41195b93 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -287,6 +287,78 @@ int mlx5e_port_set_pbmc(struct mlx5_core_dev *mdev, void *in)
 	return err;
 }
 
+int mlx5e_port_query_sbpr(struct mlx5_core_dev *mdev, u32 desc, u8 dir,
+			  u8 pool_idx, void *out, int size_out)
+{
+	u32 in[MLX5_ST_SZ_DW(sbpr_reg)] = {};
+
+	MLX5_SET(sbpr_reg, in, desc, desc);
+	MLX5_SET(sbpr_reg, in, dir, dir);
+	MLX5_SET(sbpr_reg, in, pool, pool_idx);
+
+	return mlx5_core_access_reg(mdev, in, sizeof(in), out, size_out, MLX5_REG_SBPR, 0, 0);
+}
+
+int mlx5e_port_set_sbpr(struct mlx5_core_dev *mdev, u32 desc, u8 dir,
+			u8 pool_idx, u32 infi_size, u32 size)
+{
+	u32 out[MLX5_ST_SZ_DW(sbpr_reg)] = {};
+	u32 in[MLX5_ST_SZ_DW(sbpr_reg)] = {};
+
+	MLX5_SET(sbpr_reg, in, desc, desc);
+	MLX5_SET(sbpr_reg, in, dir, dir);
+	MLX5_SET(sbpr_reg, in, pool, pool_idx);
+	MLX5_SET(sbpr_reg, in, infi_size, infi_size);
+	MLX5_SET(sbpr_reg, in, size, size);
+	MLX5_SET(sbpr_reg, in, mode, 1);
+
+	return mlx5_core_access_reg(mdev, in, sizeof(in), out, sizeof(out), MLX5_REG_SBPR, 0, 1);
+}
+
+static int mlx5e_port_query_sbcm(struct mlx5_core_dev *mdev, u32 desc,
+				 u8 pg_buff_idx, u8 dir, void *out,
+				 int size_out)
+{
+	u32 in[MLX5_ST_SZ_DW(sbcm_reg)] = {};
+
+	MLX5_SET(sbcm_reg, in, desc, desc);
+	MLX5_SET(sbcm_reg, in, local_port, 1);
+	MLX5_SET(sbcm_reg, in, pg_buff, pg_buff_idx);
+	MLX5_SET(sbcm_reg, in, dir, dir);
+
+	return mlx5_core_access_reg(mdev, in, sizeof(in), out, size_out, MLX5_REG_SBCM, 0, 0);
+}
+
+int mlx5e_port_set_sbcm(struct mlx5_core_dev *mdev, u32 desc, u8 pg_buff_idx,
+			u8 dir, u8 infi_size, u32 max_buff, u8 pool_idx)
+{
+	u32 out[MLX5_ST_SZ_DW(sbcm_reg)] = {};
+	u32 in[MLX5_ST_SZ_DW(sbcm_reg)] = {};
+	u32 min_buff;
+	int err;
+	u8 exc;
+
+	err = mlx5e_port_query_sbcm(mdev, desc, pg_buff_idx, dir, out,
+				    sizeof(out));
+	if (err)
+		return err;
+
+	exc = MLX5_GET(sbcm_reg, out, exc);
+	min_buff = MLX5_GET(sbcm_reg, out, min_buff);
+
+	MLX5_SET(sbcm_reg, in, desc, desc);
+	MLX5_SET(sbcm_reg, in, local_port, 1);
+	MLX5_SET(sbcm_reg, in, pg_buff, pg_buff_idx);
+	MLX5_SET(sbcm_reg, in, dir, dir);
+	MLX5_SET(sbcm_reg, in, exc, exc);
+	MLX5_SET(sbcm_reg, in, min_buff, min_buff);
+	MLX5_SET(sbcm_reg, in, infi_max, infi_size);
+	MLX5_SET(sbcm_reg, in, max_buff, max_buff);
+	MLX5_SET(sbcm_reg, in, pool, pool_idx);
+
+	return mlx5_core_access_reg(mdev, in, sizeof(in), out, sizeof(out), MLX5_REG_SBCM, 0, 1);
+}
+
 /* buffer[i]: buffer that priority i mapped to */
 int mlx5e_port_query_priority2buffer(struct mlx5_core_dev *mdev, u8 *buffer)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
index 7a7defe607926..3f474e370828d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
@@ -57,6 +57,12 @@ u32 mlx5e_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed,
 bool mlx5e_ptys_ext_supported(struct mlx5_core_dev *mdev);
 int mlx5e_port_query_pbmc(struct mlx5_core_dev *mdev, void *out);
 int mlx5e_port_set_pbmc(struct mlx5_core_dev *mdev, void *in);
+int mlx5e_port_query_sbpr(struct mlx5_core_dev *mdev, u32 desc, u8 dir,
+			  u8 pool_idx, void *out, int size_out);
+int mlx5e_port_set_sbpr(struct mlx5_core_dev *mdev, u32 desc, u8 dir,
+			u8 pool_idx, u32 infi_size, u32 size);
+int mlx5e_port_set_sbcm(struct mlx5_core_dev *mdev, u32 desc, u8 pg_buff_idx,
+			u8 dir, u8 infi_size, u32 max_buff, u8 pool_idx);
 int mlx5e_port_query_priority2buffer(struct mlx5_core_dev *mdev, u8 *buffer);
 int mlx5e_port_set_priority2buffer(struct mlx5_core_dev *mdev, u8 *buffer);
 
-- 
2.51.0



