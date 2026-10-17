Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A772D7D3A;
	Sat, 17 Oct 2026 17:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257982; cv=none; b=BGblqWTCIIl/O07OG6ktKuayr2DQDXXfyhPcEG63RSL9tSiwB3wKqtGYN2Ddnq47fudU93ijZb6GUHHO6ebbcHn1gwBPHGR6liKo5StBSYFI30M49jDzbyixxLEYUsZAS8uwIx/Owpef+Swa1/30n5Azya7uiRMidmnIOOFaYCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257982; c=relaxed/simple;
	bh=bmae4N198YfRuoM/Cbya7PLd2GNIB4Rk5dT2vbJJdsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGbTu6rNg4NjyECDJJCCGCAwzoFx9rHt4jqUPQcB8fBvdCG5X+id7k5qQmK7MONIkCv8p9xZgPwk2PLTuaP60+lqfEpD75wmB6GA071ML4hYHSFVSTUrs6NDJVipqQlEh0S9WayADP1ntKdMgGdvY6pn1RBc/05zDOTk+fVNvI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1MfzuQH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1MfzuQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE1C1F000C4;
	Sat, 17 Oct 2026 17:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257980;
	bh=SedUpIBjEF+4igvlezktoomeDL+xKFwWRbwhTytDAX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1MfzuQHQGxesWMG2P1tau6Rwi0oFe4OtnTo6GzD2FH1ZEgN/ZtpQPw48WY5d0r53
	 mRzSBkYvSBHOlvG8YD22VFK6zknqio4vQNWRx7/fFzbaQD3KzPbB8B+4Fcn7txjdeG
	 pQyyER/G6Mt35ZkfvI2xS7B201tlYdGPo1l7RzqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Austin <alex.austin@amd.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0732/1674] sfc: Implement ndo_hwtstamp_(get|set)
Date: Sat, 17 Oct 2026 17:50:04 +0200
Message-ID: <20261017160449.892389619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Austin <alex.austin@amd.com>

[ Upstream commit 1ac23674a971d8596648695f72168815c3f52e11 ]

Update efx->ptp_data to use kernel_hwtstamp_config and implement
ndo_hwtstamp_(get|set). Remove SIOCGHWTSTAMP and SIOCSHWTSTAMP from
efx_ioctl.

Signed-off-by: Alex Austin <alex.austin@amd.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://lore.kernel.org/r/20231130135826.19018-2-alex.austin@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8241ecec1cdc ("sfc: fix NULL dereferences in ef100_process_design_param()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef10.c       |  4 ++--
 drivers/net/ethernet/sfc/efx.c        | 24 ++++++++++++++++-----
 drivers/net/ethernet/sfc/net_driver.h |  2 +-
 drivers/net/ethernet/sfc/ptp.c        | 30 ++++++++++-----------------
 drivers/net/ethernet/sfc/ptp.h        |  7 +++++--
 5 files changed, 38 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 6dfa062feebcb..8fa6c0e9195b0 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3706,13 +3706,13 @@ static int efx_ef10_ptp_set_ts_sync_events(struct efx_nic *efx, bool en,
 }
 
 static int efx_ef10_ptp_set_ts_config_vf(struct efx_nic *efx,
-					 struct hwtstamp_config *init)
+					 struct kernel_hwtstamp_config *init)
 {
 	return -EOPNOTSUPP;
 }
 
 static int efx_ef10_ptp_set_ts_config(struct efx_nic *efx,
-				      struct hwtstamp_config *init)
+				      struct kernel_hwtstamp_config *init)
 {
 	int rc;
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 19f4b4d0b851b..e9d9de8e648ac 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -495,11 +495,6 @@ static int efx_ioctl(struct net_device *net_dev, struct ifreq *ifr, int cmd)
 	struct efx_nic *efx = efx_netdev_priv(net_dev);
 	struct mii_ioctl_data *data = if_mii(ifr);
 
-	if (cmd == SIOCSHWTSTAMP)
-		return efx_ptp_set_ts_config(efx, ifr);
-	if (cmd == SIOCGHWTSTAMP)
-		return efx_ptp_get_ts_config(efx, ifr);
-
 	/* Convert phy_id from older PRTAD/DEVAD format */
 	if ((cmd == SIOCGMIIREG || cmd == SIOCSMIIREG) &&
 	    (data->phy_id & 0xfc00) == 0x0400)
@@ -581,6 +576,23 @@ static int efx_vlan_rx_kill_vid(struct net_device *net_dev, __be16 proto, u16 vi
 		return -EOPNOTSUPP;
 }
 
+static int efx_hwtstamp_set(struct net_device *net_dev,
+			    struct kernel_hwtstamp_config *config,
+			    struct netlink_ext_ack *extack)
+{
+	struct efx_nic *efx = efx_netdev_priv(net_dev);
+
+	return efx_ptp_set_ts_config(efx, config, extack);
+}
+
+static int efx_hwtstamp_get(struct net_device *net_dev,
+			    struct kernel_hwtstamp_config *config)
+{
+	struct efx_nic *efx = efx_netdev_priv(net_dev);
+
+	return efx_ptp_get_ts_config(efx, config);
+}
+
 static const struct net_device_ops efx_netdev_ops = {
 	.ndo_open		= efx_net_open,
 	.ndo_stop		= efx_net_stop,
@@ -596,6 +608,8 @@ static const struct net_device_ops efx_netdev_ops = {
 	.ndo_features_check	= efx_features_check,
 	.ndo_vlan_rx_add_vid	= efx_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= efx_vlan_rx_kill_vid,
+	.ndo_hwtstamp_set	= efx_hwtstamp_set,
+	.ndo_hwtstamp_get	= efx_hwtstamp_get,
 #ifdef CONFIG_SFC_SRIOV
 	.ndo_set_vf_mac		= efx_sriov_set_vf_mac,
 	.ndo_set_vf_vlan	= efx_sriov_set_vf_vlan,
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 27d86e90a3bb5..f2dd7feb0e0cd 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1473,7 +1473,7 @@ struct efx_nic_type {
 	void (*ptp_write_host_time)(struct efx_nic *efx, u32 host_time);
 	int (*ptp_set_ts_sync_events)(struct efx_nic *efx, bool en, bool temp);
 	int (*ptp_set_ts_config)(struct efx_nic *efx,
-				 struct hwtstamp_config *init);
+				 struct kernel_hwtstamp_config *init);
 	int (*sriov_configure)(struct efx_nic *efx, int num_vfs);
 	int (*vlan_rx_add_vid)(struct efx_nic *efx, __be16 proto, u16 vid);
 	int (*vlan_rx_kill_vid)(struct efx_nic *efx, __be16 proto, u16 vid);
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index f54200f03e15e..f5227ae8cc436 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -295,7 +295,7 @@ struct efx_ptp_data {
 	bool reset_required;
 	struct list_head rxfilters_mcast;
 	struct list_head rxfilters_ucast;
-	struct hwtstamp_config config;
+	struct kernel_hwtstamp_config config;
 	bool enabled;
 	unsigned int mode;
 	void (*ns_to_nic_time)(s64 ns, u32 *nic_major, u32 *nic_minor);
@@ -1847,7 +1847,7 @@ int efx_ptp_change_mode(struct efx_nic *efx, bool enable_wanted,
 	return 0;
 }
 
-static int efx_ptp_ts_init(struct efx_nic *efx, struct hwtstamp_config *init)
+static int efx_ptp_ts_init(struct efx_nic *efx, struct kernel_hwtstamp_config *init)
 {
 	int rc;
 
@@ -1894,33 +1894,25 @@ void efx_ptp_get_ts_info(struct efx_nic *efx, struct ethtool_ts_info *ts_info)
 	ts_info->rx_filters = ptp->efx->type->hwtstamp_filters;
 }
 
-int efx_ptp_set_ts_config(struct efx_nic *efx, struct ifreq *ifr)
+int efx_ptp_set_ts_config(struct efx_nic *efx,
+			  struct kernel_hwtstamp_config *config,
+			  struct netlink_ext_ack __always_unused *extack)
 {
-	struct hwtstamp_config config;
-	int rc;
-
 	/* Not a PTP enabled port */
 	if (!efx->ptp_data)
 		return -EOPNOTSUPP;
 
-	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
-		return -EFAULT;
-
-	rc = efx_ptp_ts_init(efx, &config);
-	if (rc != 0)
-		return rc;
-
-	return copy_to_user(ifr->ifr_data, &config, sizeof(config))
-		? -EFAULT : 0;
+	return efx_ptp_ts_init(efx, config);
 }
 
-int efx_ptp_get_ts_config(struct efx_nic *efx, struct ifreq *ifr)
+int efx_ptp_get_ts_config(struct efx_nic *efx,
+			  struct kernel_hwtstamp_config *config)
 {
+	/* Not a PTP enabled port */
 	if (!efx->ptp_data)
 		return -EOPNOTSUPP;
-
-	return copy_to_user(ifr->ifr_data, &efx->ptp_data->config,
-			    sizeof(efx->ptp_data->config)) ? -EFAULT : 0;
+	*config = efx->ptp_data->config;
+	return 0;
 }
 
 static void ptp_event_failure(struct efx_nic *efx, int expected_frag_len)
diff --git a/drivers/net/ethernet/sfc/ptp.h b/drivers/net/ethernet/sfc/ptp.h
index 7b1ef7002b3f0..2f30dbb490d28 100644
--- a/drivers/net/ethernet/sfc/ptp.h
+++ b/drivers/net/ethernet/sfc/ptp.h
@@ -18,8 +18,11 @@ void efx_ptp_defer_probe_with_channel(struct efx_nic *efx);
 struct efx_channel *efx_ptp_channel(struct efx_nic *efx);
 void efx_ptp_update_channel(struct efx_nic *efx, struct efx_channel *channel);
 void efx_ptp_remove(struct efx_nic *efx);
-int efx_ptp_set_ts_config(struct efx_nic *efx, struct ifreq *ifr);
-int efx_ptp_get_ts_config(struct efx_nic *efx, struct ifreq *ifr);
+int efx_ptp_set_ts_config(struct efx_nic *efx,
+			  struct kernel_hwtstamp_config *config,
+			  struct netlink_ext_ack *extack);
+int efx_ptp_get_ts_config(struct efx_nic *efx,
+			  struct kernel_hwtstamp_config *config);
 void efx_ptp_get_ts_info(struct efx_nic *efx, struct ethtool_ts_info *ts_info);
 bool efx_ptp_is_ptp_tx(struct efx_nic *efx, struct sk_buff *skb);
 int efx_ptp_get_mode(struct efx_nic *efx);
-- 
2.53.0



