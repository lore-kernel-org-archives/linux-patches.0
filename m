Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670E246D094;
	Tue, 21 Jul 2026 18:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659840; cv=none; b=Y8Zh26QA8Rbcyxr9hjfBOxWSACXxvOmFh4u0za9AY+ssTm9evvmvQW4TwTTQIkYee5HL+qYQbHQZyQpfvRxGGc6YvdsIrYv9bgnLNVJXcYwg1UGpjvqFeXrX72jaXnHctICHnsiIQ31Umr1Oji6SQ4rYNHTgiKLKODsKbR9zGl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659840; c=relaxed/simple;
	bh=hWjECP93ad4aR0YG9r26W33gVSZNwMuj8AJ0eAacfKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbXID1oMr1ac/7EHzt46mE7++r+k8Tt0Wl2Xq99wRX3KBBdYZQSQO3ixNMwMWrlQ2Drt3XwosaQWhBWG1SYIIblkg1aqCWrko0FqZXhUbCJcMFNi1RXiwz6X7wixRQyjm9n8AX05kHnFz7hGiBqCi5Bx1vMIqTQDtx8LhcWSFxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KprkKwDX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KprkKwDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829F91F000E9;
	Tue, 21 Jul 2026 18:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659839;
	bh=rs4c/7uqRHazUe4PhSdPNWf0BGCGxY4gHAMqONK0f4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KprkKwDXh+8n/zbSYfYvfiKAQqwvKb13O8C+DYXTWRZw2NoH2nzsRDeZIeRNa4KKa
	 Ju9S9AWdVr3TxPdVvYmh5eWmCMtQj5Pr2KUFTcP/kblwDTD0IJcS8NuqpjfaiWZV/A
	 ExFYbOYzgrEcraCQoIHSej+U9Xt3VVlCjdy+DMy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Yael Chemla <ychemla@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0753/2077] net/mlx5: Check max_macs devlink param value against max capability
Date: Tue, 21 Jul 2026 17:07:06 +0200
Message-ID: <20260721152610.550076294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit d7b0413b35715d7b32cb12d4d424613eff85ed2b ]

The max_macs devlink param is checked against the FW max value only at
param register time (driver load) and inside the validate callback
(devlink param set). The stored DRIVERINIT value persists across FW
resets and devlink reloads without any further checks against the max.

If the FW link type changes from Ethernet to IB and a FW reset happens,
the MAX cap for log_max_current_uc_list will become zero, but the
previously stored max_macs value remains and is unconditionally
programmed into the HCA caps in handle_hca_cap(). FW will then return a
syndrome during SET_HCA_CAP:

 mlx5_cmd_out_err:839:(pid 3831): SET_HCA_CAP(0x109) op_mod(0x0) failed,
 status bad parameter(0x3), syndrome (0x537801), err(-22)
 set_hca_cap:907:(pid 3831): handle_hca_cap failed

This results in a failure to register the RDMA device.

This patch skips programming log_max_current_uc_list when the MAX
capability is 0 (in case of IB).

Fixes: 8680a60fc1fc ("net/mlx5: Let user configure max_macs generic param")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Link: https://patch.msgid.link/20260611135230.534513-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 74827e8ca12555..37af619e5e0454 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -527,7 +527,6 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 {
 	struct mlx5_profile *prof = &dev->profile;
 	void *set_hca_cap;
-	int max_uc_list;
 	int err;
 
 	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL);
@@ -610,10 +609,13 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 		MLX5_SET(cmd_hca_cap, set_hca_cap, roce,
 			 mlx5_is_roce_on(dev));
 
-	max_uc_list = max_uc_list_get_devlink_param(dev);
-	if (max_uc_list > 0)
-		MLX5_SET(cmd_hca_cap, set_hca_cap, log_max_current_uc_list,
-			 ilog2(max_uc_list));
+	if (MLX5_CAP_GEN_MAX(dev, log_max_current_uc_list)) {
+		int max_uc_list = max_uc_list_get_devlink_param(dev);
+
+		if (max_uc_list > 0)
+			MLX5_SET(cmd_hca_cap, set_hca_cap,
+				 log_max_current_uc_list, ilog2(max_uc_list));
+	}
 
 	/* enable absolute native port num */
 	if (MLX5_CAP_GEN_MAX(dev, abs_native_port_num))
-- 
2.53.0



