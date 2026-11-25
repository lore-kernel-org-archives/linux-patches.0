Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624797;
	b=oflacrNf21B7vaxYQmxzCbs/curizrTqova9Eb9F4xrbkN7pml17EJoABm5RoReeXE37
	 ZGAiSSFywzsyw7Q8xqfjIi1lVPYk40TJRfS9lsixiulPAAUaT2ZcnaeTzgA/uyEuvJell
	 5dGjuAJcfnKo50k3mCh1QmwqwI5SBnuXdZyOocrfS3HKFBSKw22sIUZIizTH/PQZZatRj
	 /Sm4ARNKeshSmVsuin0+KzRVXuEpuif+ye81lwmbN8ej527nqXYl3e1vrqjq1+EdKyjPB
	 nJMEvlY1X038ZGwG95p4KDP2WQsgbZSJDEsV7CUyziVKh221jTsLbGDt/Hev2Y0YM5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4nf06Rcyr26wEx3gbdf7u666X67P4PyZOJe8VzuHPn4=;
	b=ql0QIIRFZSX0kUzMKlhhoCNrLfdMdMzJQixrVcWG/WEFFvndD3KZkkSgwP/tZQ623mvl
	 1iS7vCpokQxigDHvABuIhMh3uu4Hqsa5bwqTbExg0q+1TkX2Og06yA93fHjyKyax8j+gQ
	 k4IHIDz77p6SjulR52EoS02wBWbliz5vmrWA1EB0fnKfKW0TRMeuSZetrjR0+90VWSB45
	 VGq4notdJzk/8u2tmxQcBlP5CqStmpD7w7miTdx0zVmbALOm/ge+m0cFFU1tKkNqLj5MX
	 8pZnnMOJ/pHlyEM7yi+ZfzNqF7zfkIk4MsJpQ8jugXuWInX6AS6UhUNtgzaWC2p1qfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFg0O3cM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A333C606A68E;
	Wed, 25 Nov 2026 16:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFg0O3cM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC1E1F000EC;
	Wed, 25 Nov 2026 16:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624796;
	bh=4nf06Rcyr26wEx3gbdf7u666X67P4PyZOJe8VzuHPn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XFg0O3cM6ffkm3dym8vD94P+Pf3OEVaEybq/Xtb/T9GHF0oqDR8s62VmQbiUjF426
	 JLY+bJgB4ettqIipxAZ6z+/Lv/cftINJcTg+ysxX0nFcyQJJmS4AURR/l10RH79SHY
	 J6NJEhyNc3Fl2nciFQ0nZV0bRNZWqKpZdVyxxPPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 309/816] net/mlx5: Bridge, fix bogus MDB offload errors
Date: Wed, 25 Nov 2026 15:30:57 +0100
Message-ID: <20261125143856.353431931@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit c714f324eac17b2df03419b5cd5368687efd8e27 ]

MDB add operations are queued on the switchdev deferred queue
(SWITCHDEV_F_DEFER), while vlan object deletions are handled
synchronously.
A 'bridge vlan del' can overtake an MDB add that is still queued, and
the vlan is already gone by the time the driver is called.

The two operations are independent in practice: in my test, the MDB add
is triggered by assigning the VF an IPv6 address (hence joining a
solicited-node multicast group), while another process deletes the vlan
from its representor.

Racing 'bridge mdb add' against concurrent 'bridge vlan del' could
result in:

[ 5390.967651] mlx5_core 0000:08:00.0: E-Switch: Failed to lookup bridge port vlan metadata (vport=1)
[ 5390.969120] mlx5_core 0000:08:00.1: E-Switch: Failed to lookup bridge port vlan metadata to create MDB (MAC=33:33:ff:12:00:05,vid=2204,vport=1)
[ 5390.971676] mlx5_core 0000:08:00.1 eth4: Failed to add Port Multicast Database entry (object id=2) with error: -EINVAL (-22).
               Failure in updating the port's Multicast Database could lead to
               multicast forwarding issues.

The error cannot reach anyone that could do anything with it, switchdev
returned success to the bridge as soon as the MDB object was queued, and
the errno only flags the entry as offload failed.
The end result is correct either way, if the MDB has been offloaded
before the vlan was deleted, mlx5_esw_bridge_port_mdb_vlan_flush() would
have removed it.

The FDB path already treats this as a harmless race,
mlx5_esw_bridge_port_vlan_lookup() reports it on 'info' logging level
and skips the offload. mlxsw did the same in [1].

Skip the MDB offload, report on 'info' logging level and return
-EOPNOTSUPP: switchdev_port_obj_add_deferred() does not log it, and
br_switchdev_mdb_complete() skips the port group flag update.

[1] Commit 17b334a876fe ("mlxsw: spectrum_switchdev: Don't warn about valid situations")

Fixes: 70f0302b3f20 ("net/mlx5: Bridge, implement mdb offload")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261104183715.771390-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 684154914cf83..a89518ed75264 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1864,26 +1864,27 @@ int mlx5_esw_bridge_port_mdb_add(struct net_device *dev, u16 vport_num, u16 esw_
 
 	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
 	if (!port) {
-		esw_warn(br_offloads->esw->dev,
+		/* MDB is added asynchronously from the switchdev deferred
+		 * queue while port might have been deleted concurrently.
+		 */
+		esw_info(br_offloads->esw->dev,
 			 "Failed to lookup bridge port to add MDB (MAC=%pM,vport=%u)\n",
 			 addr, vport_num);
-		NL_SET_ERR_MSG_FMT_MOD(extack,
-				       "Failed to lookup bridge port to add MDB (MAC=%pM,vport=%u)",
-				       addr, vport_num);
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}
 
 	bridge = port->bridge;
 	if (bridge->flags & MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG && vid) {
 		vlan = mlx5_esw_bridge_vlan_lookup(vid, port);
 		if (!vlan) {
-			esw_warn(br_offloads->esw->dev,
+			/* MDB is added asynchronously from the switchdev
+			 * deferred queue while vlan might have been deleted
+			 * concurrently.
+			 */
+			esw_info(br_offloads->esw->dev,
 				 "Failed to lookup bridge port vlan metadata to create MDB (MAC=%pM,vid=%u,vport=%u)\n",
 				 addr, vid, vport_num);
-			NL_SET_ERR_MSG_FMT_MOD(extack,
-					       "Failed to lookup vlan metadata for MDB (MAC=%pM,vid=%u,vport=%u)",
-					       addr, vid, vport_num);
-			return -EINVAL;
+			return -EOPNOTSUPP;
 		}
 	}
 
-- 
2.53.0



