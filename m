Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6005F2D5950;
	Wed,  4 Feb 2026 15:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217529; cv=none; b=BboSa2Zq+KhHwiQN5pVvX0/csAgfJVjSFw8og4OIs519iO+unmaNRauMUfLDnp8I9Yz3aORuxRMEcznuhNW2prneUXoTWIUlpxv+E+dbeJWIq+D3H2WTPW7XKq20dBbLOov9X3iAN57AwKaulMquLdEmaPNO3USJLNRjVpE6fUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217529; c=relaxed/simple;
	bh=yg/mRHnMsDEXF6DxHRJY/bdJL2bxvyPftKGHhI94oxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/j9eldwAkVkRXXxP0kuGpB4uQA0naRNOJM88GJb8EnR7HZLKxrskAeQgh3RAzWqVnHNf/sbkvmpyPGkkDODIoiopXp9VF6gDdvVRaMT5A+lj94MAglwFl+68V9HZ0RzrlYO9uS7uALEr74HwrfHjEbfTIp4fLM6UI0D2LQyqW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCmMpRHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCmMpRHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE56BC4CEF7;
	Wed,  4 Feb 2026 15:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217529;
	bh=yg/mRHnMsDEXF6DxHRJY/bdJL2bxvyPftKGHhI94oxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCmMpRHAd0jN36k38EbY7OolRYN08ePSKCGeb/4QgVyt+x2TmFEQRZaGrG5FOyZzw
	 wCyWIu5XPTPuCxjlvf7/2JssuiBFymAO5n7cBRiXgylicPCvkoFQpqnHBdkyVb7qlD
	 dRnD+rToaSCo5vODaQA+fATUo64bkNFY0w505rvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/280] net/mlx5e: Restore destroying state bit after profile cleanup
Date: Wed,  4 Feb 2026 15:36:29 +0100
Message-ID: <20260204143910.179404261@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saeed Mahameed <saeedm@nvidia.com>

[ Upstream commit 5629f8859dca7ef74d7314b60de6a957f23166c0 ]

Profile rollback can fail in mlx5e_netdev_change_profile() and we will
end up with invalid mlx5e_priv memset to 0, we must maintain the
'destroying' bit in order to gracefully shutdown even if the
profile/priv are not valid.

This patch maintains the previous state of the 'destroying' state of
mlx5e_priv after priv cleanup, to allow the remove flow to cleanup
common resources from mlx5_core to avoid FW fatal errors as seen below:

$ devlink dev eswitch set pci/0000:00:03.0 mode switchdev
    Error: mlx5_core: Failed setting eswitch to offloads.
dmesg: mlx5_core 0000:00:03.0 enp0s3np0: failed to rollback to orig profile, ...

$ devlink dev reload pci/0000:00:03.0

mlx5_core 0000:00:03.0: E-Switch: Disable: mode(LEGACY), nvfs(0), necvfs(0), active vports(0)
mlx5_core 0000:00:03.0: poll_health:803:(pid 519): Fatal error 3 detected
mlx5_core 0000:00:03.0: firmware version: 28.41.1000
mlx5_core 0000:00:03.0: 0.000 Gb/s available PCIe bandwidth (Unknown x255 link)
mlx5_core 0000:00:03.0: mlx5_function_enable:1200:(pid 519): enable hca failed
mlx5_core 0000:00:03.0: mlx5_function_enable:1200:(pid 519): enable hca failed
mlx5_core 0000:00:03.0: mlx5_health_try_recover:340:(pid 141): handling bad device here
mlx5_core 0000:00:03.0: mlx5_handle_bad_state:285:(pid 141): Expected to see disabled NIC but it is full driver
mlx5_core 0000:00:03.0: mlx5_error_sw_reset:236:(pid 141): start
mlx5_core 0000:00:03.0: NIC IFC still 0 after 4000ms.

Fixes: c4d7eb57687f ("net/mxl5e: Add change profile method")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260108212657.25090-5-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0c1f89196f6c1..73011870e5ff6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5566,6 +5566,7 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 
 void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 {
+	bool destroying = test_bit(MLX5E_STATE_DESTROYING, &priv->state);
 	int i;
 
 	/* bail if change profile failed and also rollback failed */
@@ -5591,6 +5592,8 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 	}
 
 	memset(priv, 0, sizeof(*priv));
+	if (destroying) /* restore destroying bit, to allow unload */
+		set_bit(MLX5E_STATE_DESTROYING, &priv->state);
 }
 
 static unsigned int mlx5e_get_max_num_txqs(struct mlx5_core_dev *mdev,
-- 
2.51.0



