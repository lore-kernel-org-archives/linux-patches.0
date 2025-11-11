Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BD42FF672;
	Tue, 11 Nov 2025 01:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824389; cv=none; b=YsdRzBX2hlLsgz6fkoTr1qaBJC7O87TmEOWcjIU1twybgWYvoLfHQJ+qaaXq+1HsEmimoFS7NJ5XO+nulGfwyenlCAwaL6btboN9bropSN1Noa0X3inq4rTlu14qh941E1DGmTN2lKnW/Mzh0znEdj9ed6ZEcoP5P8ypnjddpG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824389; c=relaxed/simple;
	bh=GhXE/lPKjaA9WH4xtwBs0iV+/dsKGsczVQWHtovlGxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPU+mO1RxyU/rzqh4iwODfHj5KzfgdjCYLIPCykNZGL76QZD3l9u06A8w7APwtdY6XkNDBUcsiio1dskLzNyWeOClz3K9vbNo3DMQ5FriFvGmes3OUYuoKqeAb2BMawQ14zvpylnMiy0+BQtE0qhmdGork3S2k+RZa12jvecTPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPEnBo/H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPEnBo/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B89C113D0;
	Tue, 11 Nov 2025 01:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824389;
	bh=GhXE/lPKjaA9WH4xtwBs0iV+/dsKGsczVQWHtovlGxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPEnBo/HDpsDK1pOwZ0VvU0tBA/oScSirlLW+M3W3OWMvYiqrbw2AZ2yo/IhodMxL
	 VfU3jqv8QyrHJzNi0PE8PS5SC8pYghfBaHuGFLpGv1jVuiw2BV4KzCybgIzv7xfjaR
	 /hsitcd+LIGQ7nYIPnqlXzxtBGZk8SYNu886x+hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Yael Chemla <ychemla@nvidia.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 434/565] net/mlx5e: Dont query FEC statistics when FEC is disabled
Date: Tue, 11 Nov 2025 09:44:50 +0900
Message-ID: <20251111004536.642009470@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 6b81b8a0b1978284e007566d7a1607b47f92209f ]

Update mlx5e_stats_fec_get() to check the active FEC mode and skip
statistics collection when FEC is disabled.

Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Link: https://patch.msgid.link/20250924124037.1508846-3-vadim.fedorenko@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 611ec4b6f3709..2f077ad1e810b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1413,16 +1413,13 @@ static void fec_set_rs_stats(struct ethtool_fec_stats *fec_stats, u32 *ppcnt)
 }
 
 static void fec_set_block_stats(struct mlx5e_priv *priv,
+				int mode,
 				struct ethtool_fec_stats *fec_stats)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u32 out[MLX5_ST_SZ_DW(ppcnt_reg)] = {};
 	u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] = {};
 	int sz = MLX5_ST_SZ_BYTES(ppcnt_reg);
-	int mode = fec_active_mode(mdev);
-
-	if (mode == MLX5E_FEC_NOFEC)
-		return;
 
 	MLX5_SET(ppcnt_reg, in, local_port, 1);
 	MLX5_SET(ppcnt_reg, in, grp, MLX5_PHYSICAL_LAYER_COUNTERS_GROUP);
@@ -1463,11 +1460,14 @@ static void fec_set_corrected_bits_total(struct mlx5e_priv *priv,
 void mlx5e_stats_fec_get(struct mlx5e_priv *priv,
 			 struct ethtool_fec_stats *fec_stats)
 {
-	if (!MLX5_CAP_PCAM_FEATURE(priv->mdev, ppcnt_statistical_group))
+	int mode = fec_active_mode(priv->mdev);
+
+	if (mode == MLX5E_FEC_NOFEC ||
+	    !MLX5_CAP_PCAM_FEATURE(priv->mdev, ppcnt_statistical_group))
 		return;
 
 	fec_set_corrected_bits_total(priv, fec_stats);
-	fec_set_block_stats(priv, fec_stats);
+	fec_set_block_stats(priv, mode, fec_stats);
 }
 
 #define PPORT_ETH_EXT_OFF(c) \
-- 
2.51.0



