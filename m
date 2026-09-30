Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D32651B17E;
	Wed, 30 Sep 2026 17:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789208; cv=none; b=Y3j88wNpDn6/jGtkGz8HQvtsWq5DJ2fl33sWsejP93WHQcnAifpv20KzptkGekfAuT7GH6ZpCVq57nHwNIrYg43gprO8A5k+sGv3j+yQGllh1kk4x3OKApLSat3O50BsPg3Q1hMzfSiq1LDYU1TmSxniUjkN64Ot0tlRz81354M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789208; c=relaxed/simple;
	bh=C6XHuOSO076Up9JCUPWE7VywQjDrmEW3szP5Cokvj6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFdC0+E2RfP7NGu78/wFWMKbqTGSxWunDSqxR//LzG1IPDCr+60tQI0XnY6JxahC5qAlompfoByCPhI28D/hnag3hfPPgXBB8eGa4Jsg9LSnLzo1kB0e2ZyOBCr4CTcImFFGjJfg6tOxG2E0Dz71Y5X0T56AvHEEwfeSGH1bJjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4j0TLOr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4j0TLOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F21B1F008AB;
	Wed, 30 Sep 2026 17:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789207;
	bh=QVoQhByl8hCzt6cn86mRkeHgt0zzrNOnygYsNlg2WkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p4j0TLOrm9S0ghWg+ioyAYNJtOXgSKyWXbDALf2p/mBMr5XWAxncM4FhTed+MijNr
	 F6gvrLeTtG/3CG/FZEjMKk7z9arjiqBuQGWWwRIDqEbzD96fDkrK8Dn9rSpOLr0zjF
	 7dqwxlrpjDWnYHFut+vN/0OZoL8dzYYZ1bd1NU64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernardo Soares <bsoares.it@gmail.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 394/877] net/mlx5: Bridge, dont fail unlink of untracked/unsupported peer ports
Date: Wed, 30 Sep 2026 17:21:45 +0200
Message-ID: <20260930152423.185259504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6104ae8e72410..684154914cf83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1646,10 +1646,8 @@ int mlx5_esw_bridge_vport_unlink(struct net_device *br_netdev, u16 vport_num,
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
@@ -1679,6 +1677,9 @@ int mlx5_esw_bridge_vport_peer_unlink(struct net_device *br_netdev, u16 vport_nu
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



