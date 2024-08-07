Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625F012BEBB;
	Wed,  7 Aug 2024 15:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043016; cv=none; b=L1Omi3opaVRNwf0RIcT0ipOkEyCk7qI+fcbusTX9UQqq6DOpNEG332ajjA2YFlbrCGTBWmmRpLbxmtQ9npRYN4qHGhLJO7WoFMeYjXL6mEisyWlSgJpLOI5Phs/exKP8CAf3TYhPiuPKiCU/ONrCA38oukBdRSK/jREsEL4etyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043016; c=relaxed/simple;
	bh=U6RLW8k+X4nUJ7QE04dBt5jto/mnbnkabzHt/IYogio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAsKD3vPv5v6b1BiWBmh50jX9+JfSXbL9+t+XYVak6mNrWqP35BzTVZvXT+WqUu53xKBfdWzZlpF1JuQllKsd47iCl76wO/SzG7ZDszSrtrgOBl6qs6De9srCDvvlV1Gur7BgCjjL55fACD7bVxZDSaY5hiL693YSTiVjsNZjsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxXP7GNR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxXP7GNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A55C4AF0F;
	Wed,  7 Aug 2024 15:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043016;
	bh=U6RLW8k+X4nUJ7QE04dBt5jto/mnbnkabzHt/IYogio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxXP7GNRGbyTQLk3ldkxd4PPd4AnuZXU59t8ZQVZeMKWQYDAltN2ORsGnsqmRgdVG
	 6tgtl3kcN9Cbs+Uc/2pUr5GMmgSFpe1tnAegq84kM6jdhyaCVEEEMKeYrc/idGdtp8
	 CZIpb+dDUJZzs4cstiEQGBC+4QsWRlpJ1t0UiWgE=
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
Subject: [PATCH 6.10 059/123] net/mlx5: Always drain health in shutdown callback
Date: Wed,  7 Aug 2024 16:59:38 +0200
Message-ID: <20240807150022.710787384@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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
index 459a836a5d9c1..3e55a6c6a7c9b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -2140,7 +2140,6 @@ static int mlx5_try_fast_unload(struct mlx5_core_dev *dev)
 	/* Panic tear down fw command will stop the PCI bus communication
 	 * with the HCA, so the health poll is no longer needed.
 	 */
-	mlx5_drain_health_wq(dev);
 	mlx5_stop_health_poll(dev, false);
 
 	ret = mlx5_cmd_fast_teardown_hca(dev);
@@ -2175,6 +2174,7 @@ static void shutdown(struct pci_dev *pdev)
 
 	mlx5_core_info(dev, "Shutdown was called\n");
 	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
+	mlx5_drain_health_wq(dev);
 	err = mlx5_try_fast_unload(dev);
 	if (err)
 		mlx5_unload_one(dev, false);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index b2986175d9afe..b706f1486504a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -112,6 +112,7 @@ static void mlx5_sf_dev_shutdown(struct auxiliary_device *adev)
 	struct mlx5_core_dev *mdev = sf_dev->mdev;
 
 	set_bit(MLX5_BREAK_FW_WAIT, &mdev->intf_state);
+	mlx5_drain_health_wq(mdev);
 	mlx5_unload_one(mdev, false);
 }
 
-- 
2.43.0



