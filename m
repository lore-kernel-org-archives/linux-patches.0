Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F361C6F4C;
	Tue, 27 Aug 2024 15:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771113; cv=none; b=cNWLdwpgRP6iUQKha7K8z7FASuKBgzkTdefh+C17u9Qan0lC5Ae7CfpPwEe5UTyl7K4FqbqSJLo4kmolmc+1tr/paZ2axg5xKSgIhxTA7pwaGBx6pl3LYhi4VHfxnBxzntEI/D0MTt0SuQwZsK74SM+Wg+WR5o9QJAz+4fRf5k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771113; c=relaxed/simple;
	bh=IdL+Kw/FtQxUVweO0UE7OwxMoH4esEO70CbykhWhOi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpnZFhd0DuGm6lVlepcrOejHE/TSHOGA+fEEJ9djAe1p0AlJypeHY6yQiWWNSv7w2zpb+9YneVd55gZpcsGVdgA9kGlYr0PvkxwOS++5/ZkBLVIeErX1dh0+jTp9F/OrR1Hzd7hadHVp5I5nV04BeU2GGNZqb6KCVNtX5onWbz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3EDU1uz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3EDU1uz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45974C6105B;
	Tue, 27 Aug 2024 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771112;
	bh=IdL+Kw/FtQxUVweO0UE7OwxMoH4esEO70CbykhWhOi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3EDU1uzUPQX0cH2tIIjFuYlgkEPJpwxJqVIl5EW2R5v39PrunSGWEM6iERgHA5d2
	 gHjgccyq3I+egrsPNkoTHptPy8FRBGXwjebnL1xkc2nG3Q413Qp5sBoMdBRICl/m2+
	 KFptUADIPcPTA12pCyHWEtVuw5awY59XFZzy60y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 090/273] net/mlx5: SD, Do not query MPIR register if no sd_group
Date: Tue, 27 Aug 2024 16:36:54 +0200
Message-ID: <20240827143836.838238727@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit c31fe2b5095d8c84562ce90db07600f7e9f318df ]

Unconditionally calling the MPIR query on BF separate mode yields the FW
syndrome below [1]. Do not call it unless admin clearly specified the SD
group, i.e. expressing the intention of using the multi-PF netdev
feature.

This fix covers cases not covered in
commit fca3b4791850 ("net/mlx5: Do not query MPIR on embedded CPU function").

[1]
mlx5_cmd_out_err:808:(pid 8267): ACCESS_REG(0x805) op_mod(0x1) failed,
status bad system state(0x4), syndrome (0x685f19), err(-5)

Fixes: 678eb448055a ("net/mlx5: SD, Implement basic query and instantiation")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Link: https://patch.msgid.link/20240808144107.2095424-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/lib/sd.c   | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
index f6deb5a3f8202..eeb0b7ea05f12 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
@@ -126,7 +126,7 @@ static bool mlx5_sd_is_supported(struct mlx5_core_dev *dev, u8 host_buses)
 }
 
 static int mlx5_query_sd(struct mlx5_core_dev *dev, bool *sdm,
-			 u8 *host_buses, u8 *sd_group)
+			 u8 *host_buses)
 {
 	u32 out[MLX5_ST_SZ_DW(mpir_reg)];
 	int err;
@@ -135,10 +135,6 @@ static int mlx5_query_sd(struct mlx5_core_dev *dev, bool *sdm,
 	if (err)
 		return err;
 
-	err = mlx5_query_nic_vport_sd_group(dev, sd_group);
-	if (err)
-		return err;
-
 	*sdm = MLX5_GET(mpir_reg, out, sdm);
 	*host_buses = MLX5_GET(mpir_reg, out, host_buses);
 
@@ -166,19 +162,23 @@ static int sd_init(struct mlx5_core_dev *dev)
 	if (mlx5_core_is_ecpf(dev))
 		return 0;
 
+	err = mlx5_query_nic_vport_sd_group(dev, &sd_group);
+	if (err)
+		return err;
+
+	if (!sd_group)
+		return 0;
+
 	if (!MLX5_CAP_MCAM_REG(dev, mpir))
 		return 0;
 
-	err = mlx5_query_sd(dev, &sdm, &host_buses, &sd_group);
+	err = mlx5_query_sd(dev, &sdm, &host_buses);
 	if (err)
 		return err;
 
 	if (!sdm)
 		return 0;
 
-	if (!sd_group)
-		return 0;
-
 	group_id = mlx5_sd_group_id(dev, sd_group);
 
 	if (!mlx5_sd_is_supported(dev, host_buses)) {
-- 
2.43.0



