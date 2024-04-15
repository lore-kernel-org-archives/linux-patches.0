Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D5B78C83;
	Mon, 15 Apr 2024 14:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191692; cv=none; b=BrDW9xpTHnJNthGQIKLT2OeGKYyJbn9RnR7U4MSjDFLkiD8vmHQhmJkQo7ORUBOD5LEhpj4hjgJ5iXMvqj83toOtfta4Y1WyrylykoowhydxCbNoKxB221Vu4c5UxQhf6wrCAWsau1MlXetjfBYSZWmEWkb8bnYKG2x1QK6VdeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191692; c=relaxed/simple;
	bh=4nN36JrMLXkvGUmA2X2MrDZyMIpyXxAaj2nZu9x1rJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQHN7q4HvT7ZxzjEAEnR0zqeCp283E8mgZv5b4C0ZU7R/w0GJ6sc4tzu5I8++UuwsFT+Idkct8iLBqrGoq0jqW0UR35NOm9C8AMhMrZLCEW+/8U/WXSFHZjeo0xBGdjXzYYajni+2I3A/aBp5YPCH1FvjYgEiMPSDwiT8aaVNiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+3BHJ4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+3BHJ4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1EDC2BD10;
	Mon, 15 Apr 2024 14:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191692;
	bh=4nN36JrMLXkvGUmA2X2MrDZyMIpyXxAaj2nZu9x1rJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+3BHJ4M+w/bZHrkiCtawjFT9zKyuEAhO0BshPkY4Uw8Byu4xpGjelfJ17Y2trhOy
	 OhhiIK4x/xY0EPDv1T94GYrJCCk/HfwolnKybkSuDwrH9KM4OC97qM4VUvCX3MXEPZ
	 kOa5ErM1mHYiFHwsDIBoFJTqtheO+1vV0TUm5wzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Aya Levin <ayal@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/122] net/mlx5: SF, Stop waiting for FW as teardown was called
Date: Mon, 15 Apr 2024 16:20:20 +0200
Message-ID: <20240415141955.019491128@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

[ Upstream commit 137cef6d55564fb687d12fbc5f85be43ff7b53a7 ]

When PF/VF teardown is called the driver sets the flag
MLX5_BREAK_FW_WAIT to stop waiting for FW loading and initializing. Same
should be applied to SF driver teardown to cut waiting time. On
mlx5_sf_dev_remove() set the flag before draining health WQ as recovery
flow may also wait for FW reloading while it is not relevant anymore.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: c6e77aa9dd82 ("net/mlx5: Register devlink first under devlink lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/sf/dev/driver.c        | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index 8fe82f1191bb9..69e270b5aa82d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -69,24 +69,29 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 static void mlx5_sf_dev_remove(struct auxiliary_device *adev)
 {
 	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
-	struct devlink *devlink = priv_to_devlink(sf_dev->mdev);
+	struct mlx5_core_dev *mdev = sf_dev->mdev;
+	struct devlink *devlink;
 
-	mlx5_drain_health_wq(sf_dev->mdev);
+	devlink = priv_to_devlink(mdev);
+	set_bit(MLX5_BREAK_FW_WAIT, &mdev->intf_state);
+	mlx5_drain_health_wq(mdev);
 	devlink_unregister(devlink);
-	if (mlx5_dev_is_lightweight(sf_dev->mdev))
-		mlx5_uninit_one_light(sf_dev->mdev);
+	if (mlx5_dev_is_lightweight(mdev))
+		mlx5_uninit_one_light(mdev);
 	else
-		mlx5_uninit_one(sf_dev->mdev);
-	iounmap(sf_dev->mdev->iseg);
-	mlx5_mdev_uninit(sf_dev->mdev);
+		mlx5_uninit_one(mdev);
+	iounmap(mdev->iseg);
+	mlx5_mdev_uninit(mdev);
 	mlx5_devlink_free(devlink);
 }
 
 static void mlx5_sf_dev_shutdown(struct auxiliary_device *adev)
 {
 	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
+	struct mlx5_core_dev *mdev = sf_dev->mdev;
 
-	mlx5_unload_one(sf_dev->mdev, false);
+	set_bit(MLX5_BREAK_FW_WAIT, &mdev->intf_state);
+	mlx5_unload_one(mdev, false);
 }
 
 static const struct auxiliary_device_id mlx5_sf_dev_id_table[] = {
-- 
2.43.0



