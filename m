Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8003ACF03;
	Mon, 23 Mar 2026 13:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274304; cv=none; b=czKfGdTJeoUrgMHrOcS7lXIS8rTatmLznPtd3HyKxS1jVQ4JkVBq8GAlwhYW4N/DB5V7JbKH7EpdIeuqb8y96znw5hPhDz613IuF2anFoZQvyQyfi3Z/Ng+QMfqHQPgXBiEbP/rPST0vzEPvTG7kxOcJFVJ784lR8C92IqwG8I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274304; c=relaxed/simple;
	bh=l16WpTSYHDqz/XJJda6KKmwcOjvsrY7UlSJ0MzTq6to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjEY0acd4NSpA0IQcutpbylY6VtbOvp9iV4jpLPvs+Y9OQ5qMlcjf/yH3n44ka7R3/GEG7a81dS5Ze/mlVV2urZh9Wxt9pJKjRIdmrC54IVFQGtQn7d8yN0xo7oHyNKpcpLBhMPqcL9164J0OpVFNnd9f5D8cvara0AWofxauB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbbzw9un; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbbzw9un"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DAEC4CEF7;
	Mon, 23 Mar 2026 13:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274304;
	bh=l16WpTSYHDqz/XJJda6KKmwcOjvsrY7UlSJ0MzTq6to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbbzw9un+ZcBObuXbYd6J72lzwGTrG/m+0nh1SvbPBbiRbsrns7Aaf0ofOnm789G4
	 9nSrEUu42TmxUWyVB/9BjH6pfT/teZT3Qkqz5ksbmXFEHyVI3AHX5so3gUZgt2UkIm
	 TyX/b72f+hQZZcZAiSFmK6MpKhJrw2cqnvyFJFlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 168/220] net/mlx5: qos: Restrict RTNL area to avoid a lock cycle
Date: Mon, 23 Mar 2026 14:45:45 +0100
Message-ID: <20260323134509.858321480@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit b7e3a5d9c0d66b7fb44f63aef3bd734821afa0c8 ]

A lock dependency cycle exists where:
1. mlx5_ib_roce_init -> mlx5_core_uplink_netdev_event_replay ->
mlx5_blocking_notifier_call_chain (takes notifier_rwsem) ->
mlx5e_mdev_notifier_event -> mlx5_netdev_notifier_register ->
register_netdevice_notifier_dev_net (takes rtnl)
=> notifier_rwsem -> rtnl

2. mlx5e_probe -> _mlx5e_probe ->
mlx5_core_uplink_netdev_set (takes uplink_netdev_lock) ->
mlx5_blocking_notifier_call_chain (takes notifier_rwsem)
=> uplink_netdev_lock -> notifier_rwsem

3: devlink_nl_rate_set_doit -> devlink_nl_rate_set ->
mlx5_esw_devlink_rate_leaf_tx_max_set -> esw_qos_devlink_rate_to_mbps ->
mlx5_esw_qos_max_link_speed_get (takes rtnl) ->
mlx5_esw_qos_lag_link_speed_get_locked ->
mlx5_uplink_netdev_get (takes uplink_netdev_lock)
=> rtnl -> uplink_netdev_lock
=> BOOM! (lock cycle)

Fix that by restricting the rtnl-protected section to just the necessary
part, the call to netdev_master_upper_dev_get and speed querying, so
that the last lock dependency is avoided and the cycle doesn't close.
This is safe because mlx5_uplink_netdev_get uses netdev_hold to keep the
uplink netdev alive while its master device is queried.

Use this opportunity to rename the ambiguously-named "hold_rtnl_lock"
argument to "take_rtnl" and remove the "_locked" suffix from
mlx5_esw_qos_lag_link_speed_get_locked.

Fixes: 6b4be64fd9fe ("net/mlx5e: Harden uplink netdev access against device unbind")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260316094603.6999-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c | 23 ++++++++-----------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 4278bcb04c72e..2e11574b3a81f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -1490,24 +1490,24 @@ static int esw_qos_node_enable_tc_arbitration(struct mlx5_esw_sched_node *node,
 	return err;
 }
 
-static u32 mlx5_esw_qos_lag_link_speed_get_locked(struct mlx5_core_dev *mdev)
+static u32 mlx5_esw_qos_lag_link_speed_get(struct mlx5_core_dev *mdev,
+					   bool take_rtnl)
 {
 	struct ethtool_link_ksettings lksettings;
 	struct net_device *slave, *master;
 	u32 speed = SPEED_UNKNOWN;
 
-	/* Lock ensures a stable reference to master and slave netdevice
-	 * while port speed of master is queried.
-	 */
-	ASSERT_RTNL();
-
 	slave = mlx5_uplink_netdev_get(mdev);
 	if (!slave)
 		goto out;
 
+	if (take_rtnl)
+		rtnl_lock();
 	master = netdev_master_upper_dev_get(slave);
 	if (master && !__ethtool_get_link_ksettings(master, &lksettings))
 		speed = lksettings.base.speed;
+	if (take_rtnl)
+		rtnl_unlock();
 
 out:
 	mlx5_uplink_netdev_put(mdev, slave);
@@ -1515,20 +1515,15 @@ static u32 mlx5_esw_qos_lag_link_speed_get_locked(struct mlx5_core_dev *mdev)
 }
 
 static int mlx5_esw_qos_max_link_speed_get(struct mlx5_core_dev *mdev, u32 *link_speed_max,
-					   bool hold_rtnl_lock, struct netlink_ext_ack *extack)
+					   bool take_rtnl,
+					   struct netlink_ext_ack *extack)
 {
 	int err;
 
 	if (!mlx5_lag_is_active(mdev))
 		goto skip_lag;
 
-	if (hold_rtnl_lock)
-		rtnl_lock();
-
-	*link_speed_max = mlx5_esw_qos_lag_link_speed_get_locked(mdev);
-
-	if (hold_rtnl_lock)
-		rtnl_unlock();
+	*link_speed_max = mlx5_esw_qos_lag_link_speed_get(mdev, take_rtnl);
 
 	if (*link_speed_max != (u32)SPEED_UNKNOWN)
 		return 0;
-- 
2.51.0



