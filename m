Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E9E1BE87D;
	Thu,  6 Jun 2024 14:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683549; cv=none; b=r4b6tewmvdwcgp7bjfFfQAgzx+Co2SN3LdKxX6sRjyvvAc1BznH2MnlFNWixrsbOgxxMy1VCGuMkrULAKGfvlQD8iw9HaHuhDXOQ27mN4SRr52TAhYheta1WBecQ95WS53mElHueuPmNJUn+SkTN2GszTPCMYSduV7FvwA1+qZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683549; c=relaxed/simple;
	bh=JMyNnHXN1YDejErouLNJ72cGJuKxbPx4c1m3/iz2uVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iZ5AXaY/aWRsJdpUE6/7Fmcy1md83N8AMiYME+1D06siYmdOcqMX+5Ug7tVuQQEq2rNctIw/5kf06oAWcJSXVYYPnGs1YYTK+Dox4MyDaA4VDPWe3Tl5qJPsy5UslL0k4ONWL3GUL8L0tIo8UMwy/I9AVqE3ahiOPy4Rjc01TLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlR3se2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlR3se2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A7CC32782;
	Thu,  6 Jun 2024 14:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683549;
	bh=JMyNnHXN1YDejErouLNJ72cGJuKxbPx4c1m3/iz2uVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlR3se2ufoU75il1PmFKyYOM4equ2URMIzMdXvO0AJ3Z2K+GjVS7O6kDYI83eTtgP
	 LiLbK6sbebfvGjvkFekD282ADNb42ltUK0GoLrWGh9vz11xprPCc0pOfEFuayBPkou
	 q1z+tLufs0iTvtyabs2Q9fBWmuYKVfw1XHB104rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 438/473] net/mlx5: Lag, do bond only if slaves agree on roce state
Date: Thu,  6 Jun 2024 16:06:07 +0200
Message-ID: <20240606131714.211163271@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit 51ef9305b8f40946d65c40368ffb4c14636d369a ]

Currently, the driver does not enforce that lag bond slaves must have
matching roce capabilities. Yet, in mlx5_do_bond(), the driver attempts
to enable roce on all vports of the bond slaves, causing the following
syndrome when one slave has no roce fw support:

mlx5_cmd_out_err:809:(pid 25427): MODIFY_NIC_VPORT_CONTEXT(0×755) op_mod(0×0)
failed, status bad parameter(0×3), syndrome (0xc1f678), err(-22)

Thus, create HW lag only if bond's slaves agree on roce state,
either all slaves have roce support resulting in a roce lag bond,
or none do, resulting in a raw eth bond.

Fixes: 7907f23adc18 ("net/mlx5: Implement RoCE LAG feature")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 01c0e1ee918d8..a283d8ae466b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -696,6 +696,7 @@ static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 	struct mlx5_core_dev *dev;
 	u8 mode;
 #endif
+	bool roce_support;
 	int i;
 
 	for (i = 0; i < ldev->ports; i++)
@@ -722,6 +723,11 @@ static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 		if (mlx5_sriov_is_enabled(ldev->pf[i].dev))
 			return false;
 #endif
+	roce_support = mlx5_get_roce_state(ldev->pf[MLX5_LAG_P1].dev);
+	for (i = 1; i < ldev->ports; i++)
+		if (mlx5_get_roce_state(ldev->pf[i].dev) != roce_support)
+			return false;
+
 	return true;
 }
 
@@ -884,8 +890,10 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 		} else if (roce_lag) {
 			dev0->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
 			mlx5_rescan_drivers_locked(dev0);
-			for (i = 1; i < ldev->ports; i++)
-				mlx5_nic_vport_enable_roce(ldev->pf[i].dev);
+			for (i = 1; i < ldev->ports; i++) {
+				if (mlx5_get_roce_state(ldev->pf[i].dev))
+					mlx5_nic_vport_enable_roce(ldev->pf[i].dev);
+			}
 		} else if (shared_fdb) {
 			dev0->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
 			mlx5_rescan_drivers_locked(dev0);
-- 
2.43.0



