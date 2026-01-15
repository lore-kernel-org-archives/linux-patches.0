Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74807274B43;
	Thu, 15 Jan 2026 16:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496248; cv=none; b=WGPLkYubegnRKieHz3d3iSchxBljvL3POqGBHiKRYWfV+/5njQA6NmOoUefuOoAjbHvDiH6vNpjIu/o3mUKP7XhsY1p+Nc9fAJduNuGg3im5FgLiWV8rKu1kxacreA6kq4/jpiEJssWb53e/myagLV6Udk2lyj/75f3TNoQ1fGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496248; c=relaxed/simple;
	bh=ZJJAvJnpQJpX4eGFY8kw0jK9de6iNaW4wPITWPz1Jqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLsstKJH/UPGKNPsW6Ae4d4JLgx43KcRk4XVhWNf59my6eZgjZVVbqT1v5N3ViOz+Pq+jSNsRdcTkzNR+JabEUBOdRQlcaHuhHz856e1+vfjm1WsgUZzlEkMSM6RGaodLPwbh2urbwgvJzA4XqVcnkP7lkeF8ICRSmYuzIzqdwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLvCU05T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLvCU05T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B1DC116D0;
	Thu, 15 Jan 2026 16:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496248;
	bh=ZJJAvJnpQJpX4eGFY8kw0jK9de6iNaW4wPITWPz1Jqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLvCU05Ti9unI600xsk+p81vGd8raJIhe2c/lUgjoOmk5fDdeBJW2r+iriGFpdUOB
	 Am7qOiLTngnfyEP/KV1pr3uA3rcQb21Tqn5GGfchQBQ+nRsej2pLp+GXDFs3dQpuLa
	 b51Nrhdz7wGrzzuaxGoRozYaREElZ9xy90nR4TVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Sreedevi Joshi <sreedevi.joshi@intel.com>,
	Simon Horman <horms@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 129/181] idpf: fix memory leak of flow steer list on rmmod
Date: Thu, 15 Jan 2026 17:47:46 +0100
Message-ID: <20260115164206.973187143@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sreedevi Joshi <sreedevi.joshi@intel.com>

[ Upstream commit f9841bd28b600526ca4f6713b0ca49bf7bb98452 ]

The flow steering list maintains entries that are added and removed as
ethtool creates and deletes flow steering rules. Module removal with active
entries causes memory leak as the list is not properly cleaned up.

Prevent this by iterating through the remaining entries in the list and
freeing the associated memory during module removal. Add a spinlock
(flow_steer_list_lock) to protect the list access from multiple threads.

Fixes: ada3e24b84a0 ("idpf: add flow steering support")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Sreedevi Joshi <sreedevi.joshi@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf.h        |  2 ++
 .../net/ethernet/intel/idpf/idpf_ethtool.c    | 15 ++++++++--
 drivers/net/ethernet/intel/idpf/idpf_lib.c    | 28 ++++++++++++++++++-
 3 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf.h b/drivers/net/ethernet/intel/idpf/idpf.h
index 64142f8163fed..af8deb5fa80f0 100644
--- a/drivers/net/ethernet/intel/idpf/idpf.h
+++ b/drivers/net/ethernet/intel/idpf/idpf.h
@@ -558,6 +558,7 @@ struct idpf_vector_lifo {
  * @max_q: Maximum possible queues
  * @req_qs_chunks: Queue chunk data for requested queues
  * @mac_filter_list_lock: Lock to protect mac filters
+ * @flow_steer_list_lock: Lock to protect fsteer filters
  * @flags: See enum idpf_vport_config_flags
  */
 struct idpf_vport_config {
@@ -565,6 +566,7 @@ struct idpf_vport_config {
 	struct idpf_vport_max_q max_q;
 	struct virtchnl2_add_queues *req_qs_chunks;
 	spinlock_t mac_filter_list_lock;
+	spinlock_t flow_steer_list_lock;
 	DECLARE_BITMAP(flags, IDPF_VPORT_CONFIG_FLAGS_NBITS);
 };
 
diff --git a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
index eed166bc46f38..8477e7ba28706 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
@@ -18,6 +18,7 @@ static int idpf_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
 {
 	struct idpf_netdev_priv *np = netdev_priv(netdev);
 	struct idpf_vport_user_config_data *user_config;
+	struct idpf_vport_config *vport_config;
 	struct idpf_fsteer_fltr *f;
 	struct idpf_vport *vport;
 	unsigned int cnt = 0;
@@ -25,7 +26,8 @@ static int idpf_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
 
 	idpf_vport_ctrl_lock(netdev);
 	vport = idpf_netdev_to_vport(netdev);
-	user_config = &np->adapter->vport_config[np->vport_idx]->user_config;
+	vport_config = np->adapter->vport_config[np->vport_idx];
+	user_config = &vport_config->user_config;
 
 	switch (cmd->cmd) {
 	case ETHTOOL_GRXRINGS:
@@ -37,15 +39,18 @@ static int idpf_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
 		break;
 	case ETHTOOL_GRXCLSRULE:
 		err = -EINVAL;
+		spin_lock_bh(&vport_config->flow_steer_list_lock);
 		list_for_each_entry(f, &user_config->flow_steer_list, list)
 			if (f->loc == cmd->fs.location) {
 				cmd->fs.ring_cookie = f->q_index;
 				err = 0;
 				break;
 			}
+		spin_unlock_bh(&vport_config->flow_steer_list_lock);
 		break;
 	case ETHTOOL_GRXCLSRLALL:
 		cmd->data = idpf_fsteer_max_rules(vport);
+		spin_lock_bh(&vport_config->flow_steer_list_lock);
 		list_for_each_entry(f, &user_config->flow_steer_list, list) {
 			if (cnt == cmd->rule_cnt) {
 				err = -EMSGSIZE;
@@ -56,6 +61,7 @@ static int idpf_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
 		}
 		if (!err)
 			cmd->rule_cnt = user_config->num_fsteer_fltrs;
+		spin_unlock_bh(&vport_config->flow_steer_list_lock);
 		break;
 	default:
 		break;
@@ -224,6 +230,7 @@ static int idpf_add_flow_steer(struct net_device *netdev,
 
 	fltr->loc = fsp->location;
 	fltr->q_index = q_index;
+	spin_lock_bh(&vport_config->flow_steer_list_lock);
 	list_for_each_entry(f, &user_config->flow_steer_list, list) {
 		if (f->loc >= fltr->loc)
 			break;
@@ -234,6 +241,7 @@ static int idpf_add_flow_steer(struct net_device *netdev,
 		 list_add(&fltr->list, &user_config->flow_steer_list);
 
 	user_config->num_fsteer_fltrs++;
+	spin_unlock_bh(&vport_config->flow_steer_list_lock);
 
 out:
 	kfree(rule);
@@ -286,17 +294,20 @@ static int idpf_del_flow_steer(struct net_device *netdev,
 		goto out;
 	}
 
+	spin_lock_bh(&vport_config->flow_steer_list_lock);
 	list_for_each_entry_safe(f, iter,
 				 &user_config->flow_steer_list, list) {
 		if (f->loc == fsp->location) {
 			list_del(&f->list);
 			kfree(f);
 			user_config->num_fsteer_fltrs--;
-			goto out;
+			goto out_unlock;
 		}
 	}
 	err = -EINVAL;
 
+out_unlock:
+	spin_unlock_bh(&vport_config->flow_steer_list_lock);
 out:
 	kfree(rule);
 	return err;
diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index e2ee8b137421f..d56366e676cf7 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -442,6 +442,29 @@ int idpf_intr_req(struct idpf_adapter *adapter)
 	return err;
 }
 
+/**
+ * idpf_del_all_flow_steer_filters - Delete all flow steer filters in list
+ * @vport: main vport struct
+ *
+ * Takes flow_steer_list_lock spinlock.  Deletes all filters
+ */
+static void idpf_del_all_flow_steer_filters(struct idpf_vport *vport)
+{
+	struct idpf_vport_config *vport_config;
+	struct idpf_fsteer_fltr *f, *ftmp;
+
+	vport_config = vport->adapter->vport_config[vport->idx];
+
+	spin_lock_bh(&vport_config->flow_steer_list_lock);
+	list_for_each_entry_safe(f, ftmp, &vport_config->user_config.flow_steer_list,
+				 list) {
+		list_del(&f->list);
+		kfree(f);
+	}
+	vport_config->user_config.num_fsteer_fltrs = 0;
+	spin_unlock_bh(&vport_config->flow_steer_list_lock);
+}
+
 /**
  * idpf_find_mac_filter - Search filter list for specific mac filter
  * @vconfig: Vport config structure
@@ -1107,8 +1130,10 @@ static void idpf_vport_dealloc(struct idpf_vport *vport)
 		idpf_vport_stop(vport, true);
 		idpf_decfg_netdev(vport);
 	}
-	if (test_bit(IDPF_REMOVE_IN_PROG, adapter->flags))
+	if (test_bit(IDPF_REMOVE_IN_PROG, adapter->flags)) {
 		idpf_del_all_mac_filters(vport);
+		idpf_del_all_flow_steer_filters(vport);
+	}
 
 	if (adapter->netdevs[i]) {
 		struct idpf_netdev_priv *np = netdev_priv(adapter->netdevs[i]);
@@ -1648,6 +1673,7 @@ void idpf_init_task(struct work_struct *work)
 	vport_config = adapter->vport_config[index];
 
 	spin_lock_init(&vport_config->mac_filter_list_lock);
+	spin_lock_init(&vport_config->flow_steer_list_lock);
 
 	INIT_LIST_HEAD(&vport_config->user_config.mac_filter_list);
 	INIT_LIST_HEAD(&vport_config->user_config.flow_steer_list);
-- 
2.51.0



