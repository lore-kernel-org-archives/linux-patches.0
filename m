Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE1920E307;
	Tue, 12 Nov 2024 10:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408448; cv=none; b=aHMEHnCfScbfEWHwlMLeNKaROxxHvfPNERD10z2rAz88eNmyBP82iNte3T/Okn0q7pG3dncLCVl1CMtxYfGvPTmZstwp6pUNd9dL+BF0dcHPKo0+mPiyct5AxmRSkUHPxg/NySO99tT4woWNcEF6SZ7yE/YiuelUJt4Q0ufXCU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408448; c=relaxed/simple;
	bh=1fQq/uH/YurESwMJPYSH8tbDYSCl2DrFPhuZEbyb+7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvUz2LuPa/EyTjbvHmB8pJT4clD6swQ76F+z3x0rpYXpdXEKmn2Gut4jF/vxr9Y8boR+sHjKbzhW0AD2lFpQHOkHBR8BlrSlDT+axNNYwv9n+KLn6vQFqKIFHszeGBD9kh5PMksrmkKDbTBVAsIlctkMX2/bZHwSesBDtnZAlg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNjpPebp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNjpPebp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D7DC4CECD;
	Tue, 12 Nov 2024 10:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408448;
	bh=1fQq/uH/YurESwMJPYSH8tbDYSCl2DrFPhuZEbyb+7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nNjpPebpzU1WPyKjusOEwYybZUXCNWuVJ+DJkQbtgp9uS/ya6YeMRZuSFndoikYzV
	 Q09fRvF1xtcLAiTtfgXEv0FI4GeHqKAXFOPouxhO4asx50bjA6tBw5QbTEgrY59zRn
	 rpYFRXmqdrfaxY+Ag8CYcWD6Uj6073j3otVYRqi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tarun K Singh <tarun.k.singh@intel.com>,
	Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
	Krishneil Singh <krishneil.k.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.11 134/184] idpf: avoid vport access in idpf_get_link_ksettings
Date: Tue, 12 Nov 2024 11:21:32 +0100
Message-ID: <20241112101906.012383754@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavan Kumar Linga <pavan.kumar.linga@intel.com>

commit 81d2fb4c7c18a3b36ba3e00b9d5b753107472d75 upstream.

When the device control plane is removed or the platform
running device control plane is rebooted, a reset is detected
on the driver. On driver reset, it releases the resources and
waits for the reset to complete. If the reset fails, it takes
the error path and releases the vport lock. At this time if the
monitoring tools tries to access link settings, it call traces
for accessing released vport pointer.

To avoid it, move link_speed_mbps to netdev_priv structure
which removes the dependency on vport pointer and the vport lock
in idpf_get_link_ksettings. Also use netif_carrier_ok()
to check the link status and adjust the offsetof to use link_up
instead of link_speed_mbps.

Fixes: 02cbfba1add5 ("idpf: add ethtool callbacks")
Cc: stable@vger.kernel.org # 6.7+
Reviewed-by: Tarun K Singh <tarun.k.singh@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/idpf/idpf.h          |    4 ++--
 drivers/net/ethernet/intel/idpf/idpf_ethtool.c  |   11 +++--------
 drivers/net/ethernet/intel/idpf/idpf_lib.c      |    4 ++--
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c |    2 +-
 4 files changed, 8 insertions(+), 13 deletions(-)

--- a/drivers/net/ethernet/intel/idpf/idpf.h
+++ b/drivers/net/ethernet/intel/idpf/idpf.h
@@ -141,6 +141,7 @@ enum idpf_vport_state {
  * @adapter: Adapter back pointer
  * @vport: Vport back pointer
  * @vport_id: Vport identifier
+ * @link_speed_mbps: Link speed in mbps
  * @vport_idx: Relative vport index
  * @state: See enum idpf_vport_state
  * @netstats: Packet and byte stats
@@ -150,6 +151,7 @@ struct idpf_netdev_priv {
 	struct idpf_adapter *adapter;
 	struct idpf_vport *vport;
 	u32 vport_id;
+	u32 link_speed_mbps;
 	u16 vport_idx;
 	enum idpf_vport_state state;
 	struct rtnl_link_stats64 netstats;
@@ -287,7 +289,6 @@ struct idpf_port_stats {
  * @tx_itr_profile: TX profiles for Dynamic Interrupt Moderation
  * @port_stats: per port csum, header split, and other offload stats
  * @link_up: True if link is up
- * @link_speed_mbps: Link speed in mbps
  * @sw_marker_wq: workqueue for marker packets
  */
 struct idpf_vport {
@@ -331,7 +332,6 @@ struct idpf_vport {
 	struct idpf_port_stats port_stats;
 
 	bool link_up;
-	u32 link_speed_mbps;
 
 	wait_queue_head_t sw_marker_wq;
 };
--- a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
@@ -1296,24 +1296,19 @@ static void idpf_set_msglevel(struct net
 static int idpf_get_link_ksettings(struct net_device *netdev,
 				   struct ethtool_link_ksettings *cmd)
 {
-	struct idpf_vport *vport;
-
-	idpf_vport_ctrl_lock(netdev);
-	vport = idpf_netdev_to_vport(netdev);
+	struct idpf_netdev_priv *np = netdev_priv(netdev);
 
 	ethtool_link_ksettings_zero_link_mode(cmd, supported);
 	cmd->base.autoneg = AUTONEG_DISABLE;
 	cmd->base.port = PORT_NONE;
-	if (vport->link_up) {
+	if (netif_carrier_ok(netdev)) {
 		cmd->base.duplex = DUPLEX_FULL;
-		cmd->base.speed = vport->link_speed_mbps;
+		cmd->base.speed = np->link_speed_mbps;
 	} else {
 		cmd->base.duplex = DUPLEX_UNKNOWN;
 		cmd->base.speed = SPEED_UNKNOWN;
 	}
 
-	idpf_vport_ctrl_unlock(netdev);
-
 	return 0;
 }
 
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -1873,7 +1873,7 @@ int idpf_initiate_soft_reset(struct idpf
 	 * mess with. Nothing below should use those variables from new_vport
 	 * and should instead always refer to them in vport if they need to.
 	 */
-	memcpy(new_vport, vport, offsetof(struct idpf_vport, link_speed_mbps));
+	memcpy(new_vport, vport, offsetof(struct idpf_vport, link_up));
 
 	/* Adjust resource parameters prior to reallocating resources */
 	switch (reset_cause) {
@@ -1919,7 +1919,7 @@ int idpf_initiate_soft_reset(struct idpf
 	/* Same comment as above regarding avoiding copying the wait_queues and
 	 * mutexes applies here. We do not want to mess with those if possible.
 	 */
-	memcpy(vport, new_vport, offsetof(struct idpf_vport, link_speed_mbps));
+	memcpy(vport, new_vport, offsetof(struct idpf_vport, link_up));
 
 	if (reset_cause == IDPF_SR_Q_CHANGE)
 		idpf_vport_alloc_vec_indexes(vport);
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -141,7 +141,7 @@ static void idpf_handle_event_link(struc
 	}
 	np = netdev_priv(vport->netdev);
 
-	vport->link_speed_mbps = le32_to_cpu(v2e->link_speed);
+	np->link_speed_mbps = le32_to_cpu(v2e->link_speed);
 
 	if (vport->link_up == v2e->link_status)
 		return;


