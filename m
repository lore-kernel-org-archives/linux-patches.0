Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B6330507F;
	Tue,  2 Sep 2025 13:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820345; cv=none; b=FKKx3kN3JxwP/ISMkfdEr/Nv49WL5sG/2eUGZj8CVvAz7lsuzoDxPva83bcM44ob0iXsNDC9ilALATh691bTyRqQNIHw4epV6/8qKLX+/n7nv+lK/xBXQa55jVrtUbY4UGfnJK5gaW4Q7gjs3wKSqKnrhMGXQO+uXF1hrUWA1f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820345; c=relaxed/simple;
	bh=UDZrxQrVDMQHT2mdJ2IE8S2/8Of3zojZ5bDenDsIPvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9tEKqlG1lHEbhwkHtd3PJOGAV1xCdAEFYS+PrGWg5rcqFUQdnmKYgs2fPwP5HnX++4063Lxui1aSSYPp4x60pXS6ndILCgUzEOjcGgqOCOyDdbhsBWa5gYSmc+2fjU8TM/aqaI22jZOdSwGZv6UFT9QnE8nvt3JwjPlt4+yWOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eDB2bry3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eDB2bry3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA30C4CEF4;
	Tue,  2 Sep 2025 13:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820344;
	bh=UDZrxQrVDMQHT2mdJ2IE8S2/8Of3zojZ5bDenDsIPvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eDB2bry3HR5CLYSyCQnffEubd3AlBmr3FMz+KgmjmaZhnM2r2zcRlv7/GkI6pncKa
	 Sk/ogo5zuMqXgbqW0tVpN19X5NhEyIRLZggowUsWTWDaDfzLsER84zGIRHoJpRYIdg
	 0nIxhOff3WZpYU9kYwM4+danyu1MZ8R04rq1KiAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 43/75] net/mlx5: Nack sync reset when SFs are present
Date: Tue,  2 Sep 2025 15:20:55 +0200
Message-ID: <20250902131936.812827993@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 26e42ec7712d392d561964514b1f253b1a96f42d ]

If PF (Physical Function) has SFs (Sub-Functions), since the SFs are not
taking part in the synchronization flow, sync reset can lead to fatal
error on the SFs, as the function will be closed unexpectedly from the
SF point of view.

Add a check to prevent sync reset when there are SFs on a PF device
which is not ECPF, as ECPF is teardowned gracefully before reset.

Fixes: 92501fa6e421 ("net/mlx5: Ack on sync_reset_request only if PF can do reset_now")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250825143435.598584-8-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c   |  6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c | 10 ++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h      |  6 ++++++
 3 files changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index b9986a2656083..1547704c89767 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -6,6 +6,7 @@
 #include "fw_reset.h"
 #include "diag/fw_tracer.h"
 #include "lib/tout.h"
+#include "sf/sf.h"
 
 enum {
 	MLX5_FW_RESET_FLAGS_RESET_REQUESTED,
@@ -397,6 +398,11 @@ static bool mlx5_is_reset_now_capable(struct mlx5_core_dev *dev)
 		return false;
 	}
 
+	if (!mlx5_core_is_ecpf(dev) && !mlx5_sf_table_empty(dev)) {
+		mlx5_core_warn(dev, "SFs should be removed before reset\n");
+		return false;
+	}
+
 #if IS_ENABLED(CONFIG_HOTPLUG_PCI_PCIE)
 	err = mlx5_check_hotplug_interrupt(dev);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 3f0ac2d1dde68..c9089f2ec5f25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -541,3 +541,13 @@ void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev)
 	WARN_ON(!xa_empty(&table->function_ids));
 	kfree(table);
 }
+
+bool mlx5_sf_table_empty(const struct mlx5_core_dev *dev)
+{
+	struct mlx5_sf_table *table = dev->priv.sf_table;
+
+	if (!table)
+		return true;
+
+	return xa_empty(&table->function_ids);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
index 860f9ddb7107b..89559a37997ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
@@ -17,6 +17,7 @@ void mlx5_sf_hw_table_destroy(struct mlx5_core_dev *dev);
 
 int mlx5_sf_table_init(struct mlx5_core_dev *dev);
 void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev);
+bool mlx5_sf_table_empty(const struct mlx5_core_dev *dev);
 
 int mlx5_devlink_sf_port_new(struct devlink *devlink,
 			     const struct devlink_port_new_attrs *add_attr,
@@ -61,6 +62,11 @@ static inline void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev)
 {
 }
 
+static inline bool mlx5_sf_table_empty(const struct mlx5_core_dev *dev)
+{
+	return true;
+}
+
 #endif
 
 #endif
-- 
2.50.1



