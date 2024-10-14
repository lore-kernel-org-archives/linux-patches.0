Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AEC1AAC4;
	Mon, 14 Oct 2024 15:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920093; cv=none; b=NFmSw40hb2+QhFQNzOsOyWW22Qdsp3CbYdhvBPeF9lG2XLoXJGph9nFTVXcWMzfWxCTMttwJz5qKldBPBy0Eg85KsYKwQaorLvN3rmS7dAtqATx/8KmWJkA+4Vac6tYGnsWjHeIBwzORLnwG4LqBjZHRvga/kQPct2VvOA8Sr50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920093; c=relaxed/simple;
	bh=Rttkjbapv8X8wOnwnwSxFt7DKOIXUfRcU1afmVpMMik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9yLOqEfa4UQJAVJickE1FY7pKf+pr7IKKyyQZtvRu3tLMnoZCrME8BKZIyPfTSV94Wazfrd8RwAsmqM4GtlkkynxUYTSNX2hLvOYsc5EshLb2031b23Aucs2T9JTsRLwg8EOOmrb7oirzKJouI9cYKCj+0gIyDmZNpWtxYQ4VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lnIkSp2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lnIkSp2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6197AC4CEC3;
	Mon, 14 Oct 2024 15:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920092;
	bh=Rttkjbapv8X8wOnwnwSxFt7DKOIXUfRcU1afmVpMMik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lnIkSp2yv2DzR9GtiuqqtOvZKB7xu8wzTdbPSRHdZB/UfTvcJ16GZIQs9w+RI8RPo
	 tKMs/zRYNwZmbMaAIlXKtwoBW2nSsUke8v/ajCHjETxRCrB14hhjmlkETZKuZkXOwf
	 6XyiV3+peU3QXEWYeIrBw9otG75QvBy+sBcvn7JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 767/798] net/mlx5: Always drain health in shutdown callback
Date: Mon, 14 Oct 2024 16:22:01 +0200
Message-ID: <20241014141248.199970693@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[Xiangyu: Modified to apply on 6.1.y to fix CVE-2024-43866]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c          | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 76af59cfdd0e6..825ad7663fa45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1950,7 +1950,6 @@ static int mlx5_try_fast_unload(struct mlx5_core_dev *dev)
 	/* Panic tear down fw command will stop the PCI bus communication
 	 * with the HCA, so the health poll is no longer needed.
 	 */
-	mlx5_drain_health_wq(dev);
 	mlx5_stop_health_poll(dev, false);
 
 	ret = mlx5_cmd_fast_teardown_hca(dev);
@@ -1985,6 +1984,7 @@ static void shutdown(struct pci_dev *pdev)
 
 	mlx5_core_info(dev, "Shutdown was called\n");
 	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
+	mlx5_drain_health_wq(dev);
 	err = mlx5_try_fast_unload(dev);
 	if (err)
 		mlx5_unload_one(dev, false);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index 2424cdf9cca99..d6850eb0ed7f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -75,6 +75,7 @@ static void mlx5_sf_dev_shutdown(struct auxiliary_device *adev)
 {
 	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
 
+	mlx5_drain_health_wq(sf_dev->mdev);
 	mlx5_unload_one(sf_dev->mdev, false);
 }
 
-- 
2.43.0



