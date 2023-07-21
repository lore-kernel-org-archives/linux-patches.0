Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C891F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEDAC433C7;
	Fri, 21 Jul 2023 16:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955787;
	bh=Fw+QEn4mY3M4eownX4kBeAFxzSKEz4mMyGIbrdYPZqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uUbcX6UWaSeQew6ykh6fht+lr1b/VAwxJwCURusyV74gT21ma1Pbyq4jzN7H5hkHJ
	 DrntfyQ5nno4U1aLEIWwpOE8lPlNtCLhOq+7SqmoETmSCdV4YlijOQqHHQUHbvhzOu
	 hUU6nqErL1VUcz+bJt/6Ccsw5i3h3ye8nsepMJxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Patra <spatra@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 030/292] net/mlx5: Register a unique thermal zone per device
Date: Fri, 21 Jul 2023 18:02:19 +0200
Message-ID: <20230721160530.093782665@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Saeed Mahameed <saeedm@nvidia.com>

[ Upstream commit 631079e08aa4a20b73e70de4cf457886194f029f ]

Prior to this patch only one "mlx5" thermal zone could have been
registered regardless of the number of individual mlx5 devices in the
system.

To fix this setup a unique name per device to register its own thermal
zone.

In order to not register a thermal zone for a virtual device (VF/SF) add
a check for PF device type.

The new name is a concatenation between "mlx5_" and "<PCI_DEV_BDF>", which
will also help associating a thermal zone with its PCI device.

$ lspci | grep ConnectX
00:04.0 Ethernet controller: Mellanox Technologies MT2892 Family [ConnectX-6 Dx]
00:05.0 Ethernet controller: Mellanox Technologies MT2892 Family [ConnectX-6 Dx]

$ cat /sys/devices/virtual/thermal/thermal_zone0/type
mlx5_0000:00:04.0
$ cat /sys/devices/virtual/thermal/thermal_zone1/type
mlx5_0000:00:05.0

Fixes: c1fef618d611 ("net/mlx5: Implement thermal zone")
CC: Sandipan Patra <spatra@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/thermal.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/thermal.c b/drivers/net/ethernet/mellanox/mlx5/core/thermal.c
index e47fa6fb836f1..89a22ff04cb60 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/thermal.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/thermal.c
@@ -68,14 +68,19 @@ static struct thermal_zone_device_ops mlx5_thermal_ops = {
 
 int mlx5_thermal_init(struct mlx5_core_dev *mdev)
 {
+	char data[THERMAL_NAME_LENGTH];
 	struct mlx5_thermal *thermal;
-	struct thermal_zone_device *tzd;
-	const char *data = "mlx5";
+	int err;
 
-	tzd = thermal_zone_get_zone_by_name(data);
-	if (!IS_ERR(tzd))
+	if (!mlx5_core_is_pf(mdev) && !mlx5_core_is_ecpf(mdev))
 		return 0;
 
+	err = snprintf(data, sizeof(data), "mlx5_%s", dev_name(mdev->device));
+	if (err < 0 || err >= sizeof(data)) {
+		mlx5_core_err(mdev, "Failed to setup thermal zone name, %d\n", err);
+		return -EINVAL;
+	}
+
 	thermal = kzalloc(sizeof(*thermal), GFP_KERNEL);
 	if (!thermal)
 		return -ENOMEM;
@@ -88,10 +93,10 @@ int mlx5_thermal_init(struct mlx5_core_dev *mdev)
 						      &mlx5_thermal_ops,
 						      NULL, 0, MLX5_THERMAL_POLL_INT_MSEC);
 	if (IS_ERR(thermal->tzdev)) {
-		dev_err(mdev->device, "Failed to register thermal zone device (%s) %ld\n",
-			data, PTR_ERR(thermal->tzdev));
+		err = PTR_ERR(thermal->tzdev);
+		mlx5_core_err(mdev, "Failed to register thermal zone device (%s) %d\n", data, err);
 		kfree(thermal);
-		return -EINVAL;
+		return err;
 	}
 
 	mdev->thermal = thermal;
-- 
2.39.2



