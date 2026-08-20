Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3A8481A87;
	Thu, 20 Aug 2026 17:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248020; cv=none; b=FLeL/OYkonpL08fYdoXUUZmJ6qjIILpknKMLA24JVTP2FS9LaCIZ3U+nCYLFEY000J6r/molYCwFbjJdVYw4oem8Nb1ESVnVtk0msYpKy+jnr3i6+QSgfCrpQKXPazKg/l64+9BzqdvmdmB1LMkUayK0OHNQkGqL+5VktQ0A9Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248020; c=relaxed/simple;
	bh=UzMZGH0OVpkmxj+y54zSc0DMiQFz2NanHPamDTnjQHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIctT6hzgkOMET/N9V/bpnAuga0XLYng5EPt1IGqLs06ommI/viSu1db8YpSqTfmsXVNeARW8uqWZxp1CcsR4HJD9bghvQqG63bSRlMiJB/iHW5hKxlmYkvPs6PjLT37LViBIxT3EdtvT+CJlpV3LQtPSXwtrrovNhwvEIWpukw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=us2j7GrY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="us2j7GrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432141F000E9;
	Thu, 20 Aug 2026 17:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248018;
	bh=h278gfAzjYwB2ajxCIaoaKZtVEvoBW5XMSPjIIksuu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=us2j7GrYuFzo2KmQQFjH8Z839uaCHuzVJBIshnLk5fV8Lii+ppVisQVUHRtgLpKnx
	 scoHwtp71f/uP+VfsZRTnoMF6lxWZCWuB9tM5Ekj1dSUQ79+0n9xTHOG/L/ccvDJ5U
	 Ciyk2A7BD8rRjkSwc1R2jjz/AG2GCP9R0/Oz4jsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/303] mlxsw: spectrum: On port enslavement to a LAG, join uppers bridges
Date: Thu, 20 Aug 2026 16:53:38 +0200
Message-ID: <20260820145255.624735373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 987c7782f0627e1c87617458806a7e6c1995678a ]

Currently it never happens that a netdevice that is already a bridge slave
would suddenly become mlxsw upper. The only case where this might be
possible as far as mlxsw is concerned, is with LAG netdevices. But if a LAG
already has an upper, enslaving mlxsw port to that LAG is forbidden. Thus
the only way to install a LAG between a bridge and a mlxsw port is by first
enslaving the port to the LAG, and then enslaving that LAG to a bridge.

However in the following patches, the requirement that ports be only
enslaved to masters without uppers, is going to be relaxed. It will
therefore be necessary to join bridges of LAG uppers. Without this replay,
the mlxsw bridge_port objects are not instantiated, which causes issues
later, as a lot of code relies on their presence.

Therefore in this patch, when the first mlxsw physical netdevice is
enslaved to a LAG, consider bridges upper to the LAG (both the direct
master, if any, and any bridge masters of VLAN uppers), and have the
relevant netdevices join their bridges.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 41c8c1d65b32 ("mlxsw: fix refcount leak in mlxsw_sp_port_lag_join()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |   90 +++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4357,6 +4357,88 @@ static int mlxsw_sp_port_lag_index_get(s
 	return -EBUSY;
 }
 
+static int mlxsw_sp_lag_uppers_bridge_join(struct mlxsw_sp_port *mlxsw_sp_port,
+					   struct net_device *lag_dev,
+					   struct netlink_ext_ack *extack)
+{
+	struct net_device *upper_dev;
+	struct net_device *master;
+	struct list_head *iter;
+	int done = 0;
+	int err;
+
+	master = netdev_master_upper_dev_get(lag_dev);
+	if (master && netif_is_bridge_master(master)) {
+		err = mlxsw_sp_port_bridge_join(mlxsw_sp_port, lag_dev, master,
+						extack);
+		if (err)
+			return err;
+	}
+
+	netdev_for_each_upper_dev_rcu(lag_dev, upper_dev, iter) {
+		if (!is_vlan_dev(upper_dev))
+			continue;
+
+		master = netdev_master_upper_dev_get(upper_dev);
+		if (master && netif_is_bridge_master(master)) {
+			err = mlxsw_sp_port_bridge_join(mlxsw_sp_port,
+							upper_dev, master,
+							extack);
+			if (err)
+				goto err_port_bridge_join;
+		}
+
+		++done;
+	}
+
+	return 0;
+
+err_port_bridge_join:
+	netdev_for_each_upper_dev_rcu(lag_dev, upper_dev, iter) {
+		if (!is_vlan_dev(upper_dev))
+			continue;
+
+		master = netdev_master_upper_dev_get(upper_dev);
+		if (!master || !netif_is_bridge_master(master))
+			continue;
+
+		if (!done--)
+			break;
+
+		mlxsw_sp_port_bridge_leave(mlxsw_sp_port, upper_dev, master);
+	}
+
+	master = netdev_master_upper_dev_get(lag_dev);
+	if (master && netif_is_bridge_master(master))
+		mlxsw_sp_port_bridge_leave(mlxsw_sp_port, lag_dev, master);
+
+	return err;
+}
+
+static void
+mlxsw_sp_lag_uppers_bridge_leave(struct mlxsw_sp_port *mlxsw_sp_port,
+				 struct net_device *lag_dev)
+{
+	struct net_device *upper_dev;
+	struct net_device *master;
+	struct list_head *iter;
+
+	netdev_for_each_upper_dev_rcu(lag_dev, upper_dev, iter) {
+		if (!is_vlan_dev(upper_dev))
+			continue;
+
+		master = netdev_master_upper_dev_get(upper_dev);
+		if (!master)
+			continue;
+
+		mlxsw_sp_port_bridge_leave(mlxsw_sp_port, upper_dev, master);
+	}
+
+	master = netdev_master_upper_dev_get(lag_dev);
+	if (master)
+		mlxsw_sp_port_bridge_leave(mlxsw_sp_port, lag_dev, master);
+}
+
 static int mlxsw_sp_port_lag_join(struct mlxsw_sp_port *mlxsw_sp_port,
 				  struct net_device *lag_dev,
 				  struct netlink_ext_ack *extack)
@@ -4381,6 +4463,12 @@ static int mlxsw_sp_port_lag_join(struct
 	err = mlxsw_sp_port_lag_index_get(mlxsw_sp, lag_id, &port_index);
 	if (err)
 		return err;
+
+	err = mlxsw_sp_lag_uppers_bridge_join(mlxsw_sp_port, lag_dev,
+					      extack);
+	if (err)
+		goto err_lag_uppers_bridge_join;
+
 	err = mlxsw_sp_lag_col_port_add(mlxsw_sp_port, lag_id, port_index);
 	if (err)
 		goto err_col_port_add;
@@ -4410,6 +4498,8 @@ err_router_join:
 				     mlxsw_sp_port->local_port);
 	mlxsw_sp_lag_col_port_remove(mlxsw_sp_port, lag_id);
 err_col_port_add:
+	mlxsw_sp_lag_uppers_bridge_leave(mlxsw_sp_port, lag_dev);
+err_lag_uppers_bridge_join:
 	if (!lag->ref_count)
 		mlxsw_sp_lag_destroy(mlxsw_sp, lag_id);
 	return err;


