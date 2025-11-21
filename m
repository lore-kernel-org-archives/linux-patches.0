Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4AB335541;
	Fri, 21 Nov 2025 13:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731815; cv=none; b=qpRJYsTngLLFv36a0btpn7TDJ4noRAPHKCq4MkABSU/ZpaAGP1Ts6xi92ZBmWRLh9HYeu0QeE5Yy8Qy5Fvg8s11bhkYxfnFllC395kjLx9gSX4kW7X+SMq2qHeZlXE+2bSp0ejbs5qz9UdiaKfVoDiMSguBFlR+hC/eCWrRY14w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731815; c=relaxed/simple;
	bh=mw2uhfpNlEU+YIBUu22TZnjD51fzOhmGp5nkXfiju8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiZE7jzxo1BrBS6mmB3iEE1JOOMG2fjP6juMbpBilqyCaRFA8/enkXnj8Y+6Dw1DPO0Mox0auV+u70yAmM4jEhHuBGDRK3GX57UXbFMZCEWjhLW1uRnxRJHVMR1SbcSwnsLnJhtu4ijqGdTA03qsVAew5TvM2C1B8Gu30y12Kik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkzsqw1L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkzsqw1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF58C4CEF1;
	Fri, 21 Nov 2025 13:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731815;
	bh=mw2uhfpNlEU+YIBUu22TZnjD51fzOhmGp5nkXfiju8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkzsqw1L6p8GxhUOItQsvWKhg3Q7K/WR5/LZnxkVzBMJYGSXyHFAs3R5OIzCY+rPQ
	 s2uEGBULiJfFBAShwU0BAG0btmg1iuX0A3STw2bB2CywZYMGAcNK1fJKaitp71gy9U
	 kzYSiYRnVV1ZSjsKePSc/b2JmAmYTlNPqF+cVAd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Nimrod Oren <noren@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/185] net/mlx5e: Fix maxrate wraparound in threshold between units
Date: Fri, 21 Nov 2025 14:11:23 +0100
Message-ID: <20251121130145.899469511@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit a7bf4d5063c7837096aab2853224eb23628514d9 ]

The previous calculation used roundup() which caused an overflow for
rates between 25.5Gbps and 26Gbps.
For example, a rate of 25.6Gbps would result in using 100Mbps units with
value of 256, which would overflow the 8 bits field.

Simplify the upper_limit_mbps calculation by removing the
unnecessary roundup, and adjust the comparison to use <= to correctly
handle the boundary condition.

Fixes: d8880795dabf ("net/mlx5e: Implement DCBNL IEEE max rate")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1762681073-1084058-4-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index b08328fe1aa30..99ee288ed43a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -595,18 +595,19 @@ static int mlx5e_dcbnl_ieee_setmaxrate(struct net_device *netdev,
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u8 max_bw_value[IEEE_8021QAZ_MAX_TCS];
 	u8 max_bw_unit[IEEE_8021QAZ_MAX_TCS];
-	__u64 upper_limit_mbps = roundup(255 * MLX5E_100MB, MLX5E_1GB);
+	__u64 upper_limit_mbps;
 	int i;
 
 	memset(max_bw_value, 0, sizeof(max_bw_value));
 	memset(max_bw_unit, 0, sizeof(max_bw_unit));
+	upper_limit_mbps = 255 * MLX5E_100MB;
 
 	for (i = 0; i <= mlx5_max_tc(mdev); i++) {
 		if (!maxrate->tc_maxrate[i]) {
 			max_bw_unit[i]  = MLX5_BW_NO_LIMIT;
 			continue;
 		}
-		if (maxrate->tc_maxrate[i] < upper_limit_mbps) {
+		if (maxrate->tc_maxrate[i] <= upper_limit_mbps) {
 			max_bw_value[i] = div_u64(maxrate->tc_maxrate[i],
 						  MLX5E_100MB);
 			max_bw_value[i] = max_bw_value[i] ? max_bw_value[i] : 1;
-- 
2.51.0



