Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BDB8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A640C433EF;
	Fri, 10 Mar 2023 14:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457274;
	bh=UKEoYjS25wgGroJqPbxWtKDzt69mI2UKt5Q+dewr1z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4QJoZ+DxqgjCBNKD64yuDKrxdjy2zeh5LZLVrCMktzd1qaB9N2+XYeywwQ90lFjM
	 LPqZaLio/34E1zKOoDJJAEtFQaSbsI4DtTHEL8FwKS9iramx9dIYd6LuWf2DWh5M3I
	 6V5D2f0SE724JohFs+3pLR/68+iGgF1kidqFtzfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/200] net/mlx5: ECPF, wait for VF pages only after disabling host PFs
Date: Fri, 10 Mar 2023 14:38:08 +0100
Message-Id: <20230310133719.589390329@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit e1ed30c8c09abc85a01c897845bdbd08c0333353 ]

Currently,  during the early stages of their unloading, particularly
during SRIOV disablement, PFs/ECPFs wait on the release of all of
their VFs memory pages. Furthermore, ECPFs are considered the page
supplier for host VFs, hence the host VFs memory pages are freed only
during ECPF cleanup when host interfaces get disabled.

Thus, disabling SRIOV early in unload timeline causes the DPU ECPF
to stall on driver unload while waiting on the release of host VF pages
that won't be freed before host interfaces get disabled later on.

Therefore, for ECPFs, wait on the release of VFs pages only after the
disablement of host PFs during ECPF cleanup flow. Then, host PFs and VFs
are disabled and their memory shall be freed accordingly.

Fixes: 143a41d7623d ("net/mlx5: Disable SRIOV before PF removal")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c  | 4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
index cdc87ecae5d39..d000236ddbac5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
@@ -90,4 +90,8 @@ void mlx5_ec_cleanup(struct mlx5_core_dev *dev)
 	err = mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_HOST_PF]);
 	if (err)
 		mlx5_core_warn(dev, "Timeout reclaiming external host PF pages err(%d)\n", err);
+
+	err = mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_VF]);
+	if (err)
+		mlx5_core_warn(dev, "Timeout reclaiming external host VFs pages err(%d)\n", err);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 3008e9ce2bbff..20d7662c10fb6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -147,6 +147,10 @@ mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool clear_vf)
 
 	mlx5_eswitch_disable_sriov(dev->priv.eswitch, clear_vf);
 
+	/* For ECPFs, skip waiting for host VF pages until ECPF is destroyed */
+	if (mlx5_core_is_ecpf(dev))
+		return;
+
 	if (mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_VF]))
 		mlx5_core_warn(dev, "timeout reclaiming VFs pages\n");
 }
-- 
2.39.2



