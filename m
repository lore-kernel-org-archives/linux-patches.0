Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750B416DEC3;
	Wed,  3 Jul 2024 10:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003752; cv=none; b=ELYJLTekl31SOwGrKvaZNWFi0aq/B2SkMcjXswAdLbdwCi3hIHznndayklodrPX6neDU0itLrJSzTHw/FhVqXbVfqBJAyuhGfiTSlCIL9sDrNQA9SSNagDHc1ZoRoDr+hNFmlo/6SWqCRjAZJZNVj59LFpkf7qS/d5HioliQqJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003752; c=relaxed/simple;
	bh=aVDnMykxhk0mzORnQ6z2Hz0EBWCLRcf2w71Gno41WoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/eLHrAy0jQJX3HlqAx+SHLW3YyyU4AXt/H5+hKQ+PJ3AvZMAEGazleBVJ4TLvt3D/zf13wuvgqHaV/jX6GpeIs47NCEMxiHmsp/9N5l3wliT8hKF+5DAYp9hQ37AaqM2ST7tMKwApS7rhmKcU8cP+eu5KuYiya0i2n5ApRzktE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzPwYflf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzPwYflf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF463C2BD10;
	Wed,  3 Jul 2024 10:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003752;
	bh=aVDnMykxhk0mzORnQ6z2Hz0EBWCLRcf2w71Gno41WoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yzPwYflfdf+RXLTfToFW1iODKlFDL2SfSs8on4ItEK4aEA9CQJO7WwrkU5lqISEnz
	 pUQOQJ1HwwqMrFHfIHpe08CgJMwneZJp51at6Bq/OFmxV1yme/Ttmle37VCtlTJHJH
	 LKAhXCMmipQa6/8XjnNIv9pT4UkdFMGXYWGfQA4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/189] net/mlx5: Stop waiting for PCI if pci channel is offline
Date: Wed,  3 Jul 2024 12:37:52 +0200
Message-ID: <20240703102841.929251927@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 13e86f0b42f54..43e4bc222cfa7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -337,6 +337,10 @@ int mlx5_cmd_fast_teardown_hca(struct mlx5_core_dev *dev)
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
index f628887d8af8c..d4ad0e4192bbe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -250,6 +250,10 @@ void mlx5_error_sw_reset(struct mlx5_core_dev *dev)
 	do {
 		if (mlx5_get_nic_state(dev) == MLX5_NIC_IFC_DISABLED)
 			break;
+		if (pci_channel_offline(dev->pdev)) {
+			mlx5_core_err(dev, "PCI channel offline, stop waiting for NIC IFC\n");
+			goto unlock;
+		}
 
 		msleep(20);
 	} while (!time_after(jiffies, end));
@@ -322,6 +326,10 @@ static int mlx5_health_try_recover(struct mlx5_core_dev *dev)
 				      "health recovery flow aborted, PCI reads still not working\n");
 			return -EIO;
 		}
+		if (pci_channel_offline(dev->pdev)) {
+			mlx5_core_err(dev, "PCI channel offline, stop waiting for PCI\n");
+			return -EACCES;
+		}
 		msleep(100);
 	}
 
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



