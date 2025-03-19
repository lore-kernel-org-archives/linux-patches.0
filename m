Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC441B4F15;
	Wed, 19 Mar 2025 14:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394832; cv=none; b=JfWDZZNkuwietyNZJ2GvfWNl0IxZVo/PYvdO7ugjNMy0xkTPgIAEGjJka8iPqqDmbje1Mp2Q1HdE1opz3A46UkKDIcxjooIV7vPT45okxRJpstpKZ6aPJVfaac33Okw7JRln4hRs2/bHvWr4OuKeR9FypJWOHnjgDhE4lnclluE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394832; c=relaxed/simple;
	bh=bde4CxvkDpakUdJ1+B6h+ifUUv4KHOGP56HffmuhZkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHNT3rGGa/hGZuI33qcs0dPz5FGlh9W862GUvylR9AnANTWOV5CgLdUECgwLC6XyTNr1rqHGj4znm2cUAuFzBeAHqCwaj/Z+E4xf/37bh4MhX64DgK5rMt1vPV0hfapEuVosONn8GAmlW5+sdsNztyHZdorVacPGSxPN9GCKM6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0iud9hlA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0iud9hlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD766C4CEE4;
	Wed, 19 Mar 2025 14:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394831;
	bh=bde4CxvkDpakUdJ1+B6h+ifUUv4KHOGP56HffmuhZkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0iud9hlA9uqKMWp4XcD5ytzI/tKHd0KzyO+YFKuWuRAb7uvo8ad2ceNsx5WCq87/b
	 8vmyPq/cE7Fx3OqH0inuxlxIDxj+hfMRD7exEF2DOwkOrvTWPuPtyIzqRFadzax5HH
	 fVlGpiI5sDQBPRgOfPPxnvsohUAznCrcVLOsyxDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 011/241] ice: Fix switchdev slow-path in LAG
Date: Wed, 19 Mar 2025 07:28:01 -0700
Message-ID: <20250319143027.983161298@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Szycik <marcin.szycik@linux.intel.com>

[ Upstream commit dce97cb0a3e34204c0b99345418a714eac85953f ]

Ever since removing switchdev control VSI and using PF for port
representor Tx/Rx, switchdev slow-path has been working improperly after
failover in SR-IOV LAG. LAG assumes that the first uplink to be added to
the aggregate will own VFs and have switchdev configured. After
failing-over to the other uplink, representors are still configured to
Tx through the uplink they are set up on, which fails because that
uplink is now down.

On failover, update all PRs on primary uplink to use the currently
active uplink for Tx. Call netif_keep_dst(), as the secondary uplink
might not be in switchdev mode. Also make sure to call
ice_eswitch_set_target_vsi() if uplink is in LAG.

On the Rx path, representors are already working properly, because
default Tx from VFs is set to PF owning the eswitch. After failover the
same PF is receiving traffic from VFs, even though link is down.

Fixes: defd52455aee ("ice: do Tx through PF netdev in slow-path")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lag.c  | 27 +++++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_txrx.c |  4 +++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index 1ccb572ce285d..22371011c2492 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -1000,6 +1000,28 @@ static void ice_lag_link(struct ice_lag *lag)
 	netdev_info(lag->netdev, "Shared SR-IOV resources in bond are active\n");
 }
 
+/**
+ * ice_lag_config_eswitch - configure eswitch to work with LAG
+ * @lag: lag info struct
+ * @netdev: active network interface device struct
+ *
+ * Updates all port representors in eswitch to use @netdev for Tx.
+ *
+ * Configures the netdev to keep dst metadata (also used in representor Tx).
+ * This is required for an uplink without switchdev mode configured.
+ */
+static void ice_lag_config_eswitch(struct ice_lag *lag,
+				   struct net_device *netdev)
+{
+	struct ice_repr *repr;
+	unsigned long id;
+
+	xa_for_each(&lag->pf->eswitch.reprs, id, repr)
+		repr->dst->u.port_info.lower_dev = netdev;
+
+	netif_keep_dst(netdev);
+}
+
 /**
  * ice_lag_unlink - handle unlink event
  * @lag: LAG info struct
@@ -1021,6 +1043,9 @@ static void ice_lag_unlink(struct ice_lag *lag)
 			ice_lag_move_vf_nodes(lag, act_port, pri_port);
 		lag->primary = false;
 		lag->active_port = ICE_LAG_INVALID_PORT;
+
+		/* Config primary's eswitch back to normal operation. */
+		ice_lag_config_eswitch(lag, lag->netdev);
 	} else {
 		struct ice_lag *primary_lag;
 
@@ -1419,6 +1444,7 @@ static void ice_lag_monitor_active(struct ice_lag *lag, void *ptr)
 				ice_lag_move_vf_nodes(lag, prim_port,
 						      event_port);
 			lag->active_port = event_port;
+			ice_lag_config_eswitch(lag, event_netdev);
 			return;
 		}
 
@@ -1428,6 +1454,7 @@ static void ice_lag_monitor_active(struct ice_lag *lag, void *ptr)
 		/* new active port */
 		ice_lag_move_vf_nodes(lag, lag->active_port, event_port);
 		lag->active_port = event_port;
+		ice_lag_config_eswitch(lag, event_netdev);
 	} else {
 		/* port not set as currently active (e.g. new active port
 		 * has already claimed the nodes and filters
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 9c9ea4c1b93b7..380ba1e8b3b2c 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2424,7 +2424,9 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 					ICE_TXD_CTX_QW1_CMD_S);
 
 	ice_tstamp(tx_ring, skb, first, &offload);
-	if (ice_is_switchdev_running(vsi->back) && vsi->type != ICE_VSI_SF)
+	if ((ice_is_switchdev_running(vsi->back) ||
+	     ice_lag_is_switchdev_running(vsi->back)) &&
+	    vsi->type != ICE_VSI_SF)
 		ice_eswitch_set_target_vsi(skb, &offload);
 
 	if (offload.cd_qw1 & ICE_TX_DESC_DTYPE_CTX) {
-- 
2.39.5



