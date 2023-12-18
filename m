Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4213789F;
	Mon, 18 Dec 2023 13:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdOe8qob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F680C433CC;
	Mon, 18 Dec 2023 13:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907999;
	bh=c6FQpDGncpjkV8elyTkHnWKdjGcMo/dUDmWFKsMLhaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdOe8qobeelN9rCCEJe+HhUPLyDZaFCyl98BuwAnypdANjJ9SuSISEFGRPAF6ZbUw
	 1/c7JT91OrdZEpefH4afEd2S0EmxdsiGFFhTc/qldpyMaynke9Nj9TsrkntrGoP1j7
	 2nikKgB4J5iETOEzG7CnfS23SvaILgPh6v93BuGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/166] net/mlx5: Nack sync reset request when HotPlug is enabled
Date: Mon, 18 Dec 2023 14:49:43 +0100
Message-ID: <20231218135105.711592375@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 3d7a3f2612d75de5f371a681038b089ded6667eb ]

Current sync reset flow is not supported when PCIe bridge connected
directly to mlx5 device has HotPlug interrupt enabled and can be
triggered on link state change event. Return nack on reset request in
such case.

Fixes: 92501fa6e421 ("net/mlx5: Ack on sync_reset_request only if PF can do reset_now")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 29 +++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index b568988e92e3e..c4e19d627da21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -325,6 +325,29 @@ static void mlx5_fw_live_patch_event(struct work_struct *work)
 		mlx5_core_err(dev, "Failed to reload FW tracer\n");
 }
 
+#if IS_ENABLED(CONFIG_HOTPLUG_PCI_PCIE)
+static int mlx5_check_hotplug_interrupt(struct mlx5_core_dev *dev)
+{
+	struct pci_dev *bridge = dev->pdev->bus->self;
+	u16 reg16;
+	int err;
+
+	if (!bridge)
+		return -EOPNOTSUPP;
+
+	err = pcie_capability_read_word(bridge, PCI_EXP_SLTCTL, &reg16);
+	if (err)
+		return err;
+
+	if ((reg16 & PCI_EXP_SLTCTL_HPIE) && (reg16 & PCI_EXP_SLTCTL_DLLSCE)) {
+		mlx5_core_warn(dev, "FW reset is not supported as HotPlug is enabled\n");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+#endif
+
 static int mlx5_check_dev_ids(struct mlx5_core_dev *dev, u16 dev_id)
 {
 	struct pci_bus *bridge_bus = dev->pdev->bus;
@@ -357,6 +380,12 @@ static bool mlx5_is_reset_now_capable(struct mlx5_core_dev *dev)
 		return false;
 	}
 
+#if IS_ENABLED(CONFIG_HOTPLUG_PCI_PCIE)
+	err = mlx5_check_hotplug_interrupt(dev);
+	if (err)
+		return false;
+#endif
+
 	err = pci_read_config_word(dev->pdev, PCI_DEVICE_ID, &dev_id);
 	if (err)
 		return false;
-- 
2.43.0



