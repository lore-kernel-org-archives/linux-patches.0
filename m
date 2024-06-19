Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4207C13D525;
	Wed, 19 Jun 2024 12:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801975; cv=none; b=itdURUc45vqZis0PUHbu/XPuL4FYbWMxD4bzjnEPrcXzjZv96w74ErIYD2G5DMXdP7l9Sats6bEZ5oGb0bmkS0Yjm94ItcIwcRhJet1LOikgq/QHtqTIovIIk5eD192XcmHBLveMKf227Hny1GqDq4i2RCN+pWuNTXg76egcoew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801975; c=relaxed/simple;
	bh=UMurGYj7qNqDf5HD8IEaOU/eTR1apugsBQjiATOigXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjNYSicm9l2V753/tayoe1CChFTNPbO1L+6bFulxPREuchQPIOrvPm4VZuPZVrm5rfD0k6sQdvmIQec/OMUvkw1MwxOS8agSQM0/aKvD4UOLxtGSlS67l6tz8Qsy0VHoPMHw9i4RUSTVU5aNzFN+JO2hIUCSZSjqr/WPZVy6FIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UjTATfgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UjTATfgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD03C2BBFC;
	Wed, 19 Jun 2024 12:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801974;
	bh=UMurGYj7qNqDf5HD8IEaOU/eTR1apugsBQjiATOigXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjTATfghntfLLw8ZkQ7f4fbb1eiObtWvx4bxiHxgA6d0FLE9Zd01ZbtgbUYvFiFFF
	 31nKcLc2XqFtgWVU8TzqcD+r2/ihNf2PjP1gta7+2MyyfxCZC9XpvEfJjNFRtbahmd
	 Mux0bCDlZrTnjrtaTVFvJ6OJxXmqiqoEBIjoH5vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/267] net/mlx5: Stop waiting for PCI if pci channel is offline
Date: Wed, 19 Jun 2024 14:53:10 +0200
Message-ID: <20240619125607.868681953@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

[ Upstream commit 33afbfcc105a572159750f2ebee834a8a70fdd96 ]

In case pci channel becomes offline the driver should not wait for PCI
reads during health dump and recovery flow. The driver has timeout for
each of these loops trying to read PCI, so it would fail anyway.
However, in case of recovery waiting till timeout may cause the pci
error_detected() callback fail to meet pci_dpc_recovered() wait timeout.

Fixes: b3bd076f7501 ("net/mlx5: Report devlink health on FW fatal issues")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c          | 4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/health.c      | 8 ++++++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/pci_vsc.c | 4 ++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 58f4c0d0fafa2..70898f0a9866c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -373,6 +373,10 @@ int mlx5_cmd_fast_teardown_hca(struct mlx5_core_dev *dev)
 	do {
 		if (mlx5_get_nic_state(dev) == MLX5_NIC_IFC_DISABLED)
 			break;
+		if (pci_channel_offline(dev->pdev)) {
+			mlx5_core_err(dev, "PCI channel offline, stop waiting for NIC IFC\n");
+			return -EACCES;
+		}
 
 		cond_resched();
 	} while (!time_after(jiffies, end));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 2fb2598b775ef..d798834c4e755 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -248,6 +248,10 @@ void mlx5_error_sw_reset(struct mlx5_core_dev *dev)
 	do {
 		if (mlx5_get_nic_state(dev) == MLX5_NIC_IFC_DISABLED)
 			break;
+		if (pci_channel_offline(dev->pdev)) {
+			mlx5_core_err(dev, "PCI channel offline, stop waiting for NIC IFC\n");
+			goto unlock;
+		}
 
 		msleep(20);
 	} while (!time_after(jiffies, end));
@@ -317,6 +321,10 @@ int mlx5_health_wait_pci_up(struct mlx5_core_dev *dev)
 			mlx5_core_warn(dev, "device is being removed, stop waiting for PCI\n");
 			return -ENODEV;
 		}
+		if (pci_channel_offline(dev->pdev)) {
+			mlx5_core_err(dev, "PCI channel offline, stop waiting for PCI\n");
+			return -EACCES;
+		}
 		msleep(100);
 	}
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/pci_vsc.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/pci_vsc.c
index 6b774e0c27665..d0b595ba61101 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/pci_vsc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/pci_vsc.c
@@ -74,6 +74,10 @@ int mlx5_vsc_gw_lock(struct mlx5_core_dev *dev)
 			ret = -EBUSY;
 			goto pci_unlock;
 		}
+		if (pci_channel_offline(dev->pdev)) {
+			ret = -EACCES;
+			goto pci_unlock;
+		}
 
 		/* Check if semaphore is already locked */
 		ret = vsc_read(dev, VSC_SEMAPHORE_OFFSET, &lock_val);
-- 
2.43.0



