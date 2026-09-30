Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB3A3B47CD;
	Wed, 30 Sep 2026 16:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786459; cv=none; b=MUL+4hZZAKNHTt7VkKxQZ6BypunNSkmrT0uikxOTNct4mpVSIAe2YZ6dxB6eTIv1YI3gvCw6PTPusiITJj1dSDKdQn4VYAJkQDoxpbCt+XTxkwgoKnzgNwXMFK/qslhJI8l/ZmCuRXZ76mkbn+vXUNNoUOk3NtPyXA65WUZ5uH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786459; c=relaxed/simple;
	bh=/TahUO07KyejCrgG3/OhiqqJQ36u1KZMP2IVnlT8S7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJuCzv5G3E2iisdR0mL3GTklVZF9iUk5hR9Gpf1mdoFBBymDkiyrBnmXqeJw1UXM916Qpi428QjFYtc/XCUHA4QwjGxIGiNuKJc+oH0FmDEdBTdNRFwauy37B3xADg+TCOLcVS+rukmsE8FwtSwAgjFSLlox9QJ49tbNGtblomQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffBu3vXy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffBu3vXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84E91F00893;
	Wed, 30 Sep 2026 16:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786458;
	bh=8GKmVyQsCoSAj23Mr4ymuxarPPlBNwXdTGvnSwYI55M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ffBu3vXysn4NWEPLyOZaEyzdm6LOIgK7/4Wy9aDpwtVY5oZ8CkhZ30L1JJxjZVEB+
	 vEgZzq0h10I8WA/UBg4n3ke/b65k4C5DE5UTlDZ3bFJ+4jEf6tr49sveFXt0SGAKoC
	 8CclKvz/35n3dooMpnaFoUCKGP7aGP/1S80bs26U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernardo Soares <bsoares.it@gmail.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 868/982] net/mlx5: Bridge, dont fail unlink of untracked/unsupported peer ports
Date: Wed, 30 Sep 2026 17:26:44 +0200
Message-ID: <20260930152435.393056883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Bernardo Soares <bsoares.it@gmail.com>

[ Upstream commit 2e51097c982b7b22382fda3202ba29f0ea33e8c0 ]

mlx5_esw_bridge_vport_unlink() returns -EINVAL when the port isn't
tracked by this instance's br_offloads. This is reachable on a sibling
instance that registered its notifier after the port was already
enslaved: it never saw the NETDEV_CHANGEUPPER link event, so
peer_link() never created a peer port for it, but it does see the
later unlink event and fails. Return 0 instead, and give
mlx5_esw_bridge_vport_peer_unlink() the same merged_eswitch capability
guard peer_link() already has, since without it peer_link() likewise
never creates a port to unlink.

This also matters beyond the -EINVAL itself:
mlx5_esw_bridge_switchdev_port_event() runs on the per-netns
netdev_chain, and notifier_from_errno(-EINVAL) sets NOTIFY_STOP_MASK,
which call_netdevice_notifiers_info() checks to stop calling further
listeners on that chain - so the old -EINVAL silently dropped the
event for any listener registered later on the same chain, even
though none of it was visible to user space since
__netdev_upper_dev_unlink() discards the return value.

Fixes: c358ea1741bc ("net/mlx5: Bridge, allow merged eswitch connectivity")
Signed-off-by: Bernardo Soares <bsoares.it@gmail.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20260918095931.29792-3-bsoares.it@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 882b87bc45d50..2dd9685867ba9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1584,10 +1584,8 @@ int mlx5_esw_bridge_vport_unlink(struct net_device *br_netdev, u16 vport_num,
 	int err;
 
 	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
-	if (!port) {
-		NL_SET_ERR_MSG_MOD(extack, "Port is not attached to any bridge");
-		return -EINVAL;
-	}
+	if (!port)
+		return 0;
 	if (port->bridge->ifindex != br_netdev->ifindex) {
 		NL_SET_ERR_MSG_MOD(extack, "Port is attached to another bridge");
 		return -EINVAL;
@@ -1617,6 +1615,9 @@ int mlx5_esw_bridge_vport_peer_unlink(struct net_device *br_netdev, u16 vport_nu
 				      struct mlx5_esw_bridge_offloads *br_offloads,
 				      struct netlink_ext_ack *extack)
 {
+	if (!MLX5_CAP_ESW(br_offloads->esw->dev, merged_eswitch))
+		return 0;
+
 	return mlx5_esw_bridge_vport_unlink(br_netdev, vport_num, esw_owner_vhca_id, br_offloads,
 					    extack);
 }
-- 
2.53.0



