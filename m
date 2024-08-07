Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9397E0E9;
	Wed,  7 Aug 2024 15:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043508; cv=none; b=eDUnxqTMtHILF0GuqwKQ+oc5IH58HvypZpIaeZoWlr2nEfAUMhum8L8tQFOol3t1AQwzuiBKoJ6XP/HC3tsNj5hEoLXkY3OPLnP6YQl3mtPFOE4vW/VYgCHZ5udN6R9gd/TJcb1uqbJTYIgDMB4eNJolm6BdnNa+H9Bt1ulHND8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043508; c=relaxed/simple;
	bh=QPz77ffPB0iuXmtgH3RgYTMCYxn4cKEo1aiSC3vYEw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLZE+/qbSiEG6On5nwhHFXlFBvUp64U9yigRjxwNieViKiAD9bDbpTzde4/mxaFYn5B8h/4aBX90/UAzEHYmIZlMEgBOByel4cAx319RkLoDewFNt0vqWMofxCrIDHbW4hViQUIXF+gpXni1XTVewiTuYQRIs2XzyMOcRGytPNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOmXCsrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOmXCsrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F24C32781;
	Wed,  7 Aug 2024 15:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043508;
	bh=QPz77ffPB0iuXmtgH3RgYTMCYxn4cKEo1aiSC3vYEw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOmXCsrrXnkRi0FopjPVbDRzRP811vKulqhZ9fLLQDUK3dz6Yx1PwhMpAP+4Jzp4g
	 xSVtL2LAT0nTHyS4rPLFgayNNAV83a4MVL56McMcPq6Za933edbo21z1hzqS9CXDVd
	 tftGpdmmGGRUToaXI4UxtEL7RbPMt0GohQBMRgb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/121] net/mlx5: Always drain health in shutdown callback
Date: Wed,  7 Aug 2024 17:00:12 +0200
Message-ID: <20240807150022.035927116@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 1b75da22ed1e6171e261bc9265370162553d5393 ]

There is no point in recovery during device shutdown. if health
work started need to wait for it to avoid races and NULL pointer
access.

Hence, drain health WQ on shutdown callback.

Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
Fixes: d2aa060d40fa ("net/mlx5: Cancel health poll before sending panic teardown command")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Link: https://patch.msgid.link/20240730061638.1831002-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c          | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 2237b3d01e0e5..11f11248feb8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -2130,7 +2130,6 @@ static int mlx5_try_fast_unload(struct mlx5_core_dev *dev)
 	/* Panic tear down fw command will stop the PCI bus communication
 	 * with the HCA, so the health poll is no longer needed.
 	 */
-	mlx5_drain_health_wq(dev);
 	mlx5_stop_health_poll(dev, false);
 
 	ret = mlx5_cmd_fast_teardown_hca(dev);
@@ -2165,6 +2164,7 @@ static void shutdown(struct pci_dev *pdev)
 
 	mlx5_core_info(dev, "Shutdown was called\n");
 	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
+	mlx5_drain_health_wq(dev);
 	err = mlx5_try_fast_unload(dev);
 	if (err)
 		mlx5_unload_one(dev, false);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index 30218f37d5285..2028acbe85ca2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -90,6 +90,7 @@ static void mlx5_sf_dev_shutdown(struct auxiliary_device *adev)
 	struct mlx5_core_dev *mdev = sf_dev->mdev;
 
 	set_bit(MLX5_BREAK_FW_WAIT, &mdev->intf_state);
+	mlx5_drain_health_wq(mdev);
 	mlx5_unload_one(mdev, false);
 }
 
-- 
2.43.0



