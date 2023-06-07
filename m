Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DE93925A
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE41C433D2;
	Wed,  7 Jun 2023 20:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169295;
	bh=MMq4zAahs05tHAPfIBlShjCZ47S8hGtCrDDJMiROIOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zp8ezaYsv+m1vFctSZRhw96l4peVOvcA8Rovq5VCbrcYl3Eq2HlmNVZPTx5RyE5gk
	 37ru9/kHS3C8IeRG4fAHX4zm667sa5OXoyLe6QKSneffkesmewr33f3rF1NOVQLKLm
	 w3MQUeQUnbu7P6FhktuusuZCXOhnPN1UcGRSRiWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 026/286] net/mlx5: Drain health before unregistering devlink
Date: Wed,  7 Jun 2023 22:12:05 +0200
Message-ID: <20230607200923.873451909@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 824c8dc4a470040bf0e56ba716543839c2498d49 ]

mlx5 health mechanism is using devlink APIs, which are using devlink
notify APIs. After the cited patch, using devlink notify APIs after
devlink is unregistered triggers a WARN_ON().
Hence, drain health WQ before devlink is unregistered.

Fixes: cf530217408e ("devlink: Notify users when objects are accessible")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 62327b52f1acf..504179dbff9dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1790,14 +1790,15 @@ static void remove_one(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(dev);
 
 	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
-	/* mlx5_drain_fw_reset() is using devlink APIs. Hence, we must drain
-	 * fw_reset before unregistering the devlink.
+	/* mlx5_drain_fw_reset() and mlx5_drain_health_wq() are using
+	 * devlink notify APIs.
+	 * Hence, we must drain them before unregistering the devlink.
 	 */
 	mlx5_drain_fw_reset(dev);
+	mlx5_drain_health_wq(dev);
 	devlink_unregister(devlink);
 	mlx5_sriov_disable(pdev);
 	mlx5_crdump_disable(dev);
-	mlx5_drain_health_wq(dev);
 	mlx5_uninit_one(dev);
 	mlx5_pci_close(dev);
 	mlx5_mdev_uninit(dev);
-- 
2.39.2



