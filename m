Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C134BEE32;
	Sat, 12 Sep 2026 11:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211968; cv=none; b=MXcfFcNxdfAGMkhOqeMqkwN42swPEcHHT5ZPl3noSiQLBjzsjljhKgL5w7ByB22tP3TFQOSwu0CB1gOGBwRwIsIvUiDwbJhgXXBfflJPh/GlsaK/qiN12raz8QEyauwCQJRFwApKn3a9tzz7uAKwINy6UxBQYTgCyahijY7cAGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211968; c=relaxed/simple;
	bh=UwJA3jXCXHQvHH+KbhgLzPFTXQtkoaabrRlH0oRsWRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRBuyVSa/UPw38wW+xeg/Pw/E8KCq2H/W5Z24gjyu+nk7foo84r1IovvBsmjnBKeINO24NZMd3YJGr9edRFDpm10UgXoPn55RsY8bsUvF90fOJ2ylnBRYkM6pe3pIU7YKykFxEBDQ9BodwPElTeOcp7XsuaaKkqs4ISrQpnCghg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/4U9dJ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/4U9dJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030B91F000FF;
	Sat, 12 Sep 2026 11:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211967;
	bh=1GPgdP/LPigpBXp/r2i/DqGydzRLKFTc3JHH9xbsB8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/4U9dJ4HjPQ3UqXViVakNHtn8sxKgIjJavMnVUbgUqVpk7e+v09P91DiYHdbh5dk
	 VqE+oIjrHnKxEIEULtmwJMRgXQvpzcuQdhtY6GxD8bzl4NbD16TViTY5xRA5Sn8kHB
	 2ictNbB1Mn/XG7BraEJ42JuRPySuh8bPgPSasvWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1341/1518] net/mlx5: Add support for querying bond speed
Date: Sat, 12 Sep 2026 08:58:30 +0200
Message-ID: <20260912065653.863162545@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit f0b2fde98065e49795ce6824837b3f53fdf16e5d ]

Add mlx5_lag_query_bond_speed() to query the aggregated speed of
lag configurations with a bond device.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: ad0ae7aefa7a ("net/mlx5: E-Switch, preserve max tx speed on vport state modification")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 27 +++++++++++++++++++
 include/linux/mlx5/driver.h                   |  2 +-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index c3c9c3462c978..8468e35252fc0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1466,6 +1466,33 @@ static void mlx5_lag_update_tracker_speed(struct lag_tracker *tracker,
 		tracker->bond_speed_mbps = lksettings.base.speed;
 }
 
+/* Returns speed in Mbps. */
+int mlx5_lag_query_bond_speed(struct mlx5_core_dev *mdev, u32 *speed)
+{
+	struct mlx5_lag *ldev;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&lag_lock, flags);
+	ldev = mlx5_lag_dev(mdev);
+	if (!ldev) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+
+	*speed = ldev->tracker.bond_speed_mbps;
+
+	if (*speed == SPEED_UNKNOWN) {
+		mlx5_core_dbg(mdev, "Bond speed is unknown\n");
+		ret = -EINVAL;
+	}
+
+unlock:
+	spin_unlock_irqrestore(&lag_lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mlx5_lag_query_bond_speed);
+
 /* this handler is always registered to netdev events */
 static int mlx5_lag_netdev_event(struct notifier_block *this,
 				 unsigned long event, void *ptr)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index eac1a76c59d73..647dcf144ae90 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1142,7 +1142,7 @@ int mlx5_cmd_destroy_vport_lag(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_roce(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_sriov(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_active(struct mlx5_core_dev *dev);
-int mlx5_lag_query_bond_speed(struct net_device *bond_dev, u32 *speed);
+int mlx5_lag_query_bond_speed(struct mlx5_core_dev *dev, u32 *speed);
 bool mlx5_lag_mode_is_hash(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_master(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_shared_fdb(struct mlx5_core_dev *dev);
-- 
2.53.0



