Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D84374E5A;
	Thu, 20 Aug 2026 16:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243364; cv=none; b=roIG4yLdP5lOMjgZCd2xsHx/OenfRbw/3A/n3pn/7az1GvScDxQzTbVTvnyJ03n6dkDD5hX+V1EMhIDVeCfPbFKe/CPBnSqgR+a6DMItjVEaUVBOUZ0GufTaAPIyTU0IEPFvrLk5jI0Z/23Ss7h8EXmtUOl6wM8FEsMSlPxREvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243364; c=relaxed/simple;
	bh=2rhVD6acqQzWCM3xc5GoXUjpByG38EQbeUwZJYgaedM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nd+RIg56rI6YiboTYz0hCWhleNnmj5nlr4zT2SRYUvro6BQL07NYWyIRAjTZn3EehYhjcx00b59xfUAWf2O4fL+OmzzS4QV45LhsUkWQnhjp3f+CJzXg8Np+tbEFlsZkwvBJIDIWWLXj6YwCI+R31pGLSY0U1k7okHQwltn/S18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eodp5c4w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eodp5c4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12DF1F000E9;
	Thu, 20 Aug 2026 16:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243363;
	bh=X/pmp9BIdUWexqQnU+N8xxJ0R4vAAJMhJNJ/O1t8ea4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eodp5c4woUAp0SZcJADU/t8wFJo7ZtMIsJi0Xval1ljuVFwsh3icNEPFONMHs7C3m
	 leRom9n23uOKppQ4VPtvi2oWhp99hGlRb3DMbvPGIfuSCDTg0EYrkh2DpkJnPXqlIe
	 gYB/sMvIqu4NfaO4Hb1W39nZFn9GHOGcbIsZyP4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/272] mlxsw: spectrum: On port enslavement to a LAG, join uppers bridges
Date: Thu, 20 Aug 2026 16:54:12 +0200
Message-ID: <20260820145233.326519140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3837,6 +3837,88 @@ static int mlxsw_sp_port_lag_index_get(s
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
@@ -3861,6 +3943,12 @@ static int mlxsw_sp_port_lag_join(struct
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
@@ -3890,6 +3978,8 @@ err_router_join:
 				     mlxsw_sp_port->local_port);
 	mlxsw_sp_lag_col_port_remove(mlxsw_sp_port, lag_id);
 err_col_port_add:
+	mlxsw_sp_lag_uppers_bridge_leave(mlxsw_sp_port, lag_dev);
+err_lag_uppers_bridge_join:
 	if (!lag->ref_count)
 		mlxsw_sp_lag_destroy(mlxsw_sp, lag_id);
 	return err;


