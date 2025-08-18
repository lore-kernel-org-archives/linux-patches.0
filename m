Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE7331B13C;
	Mon, 18 Aug 2025 13:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525319; cv=none; b=ox4+kdJRMKE+WUZpFnk2zSphcpSNgsatliXdPHG3P/RHbGJQVRuGpzK5i5GnNoEsSMYUePk6v05pUPZ9fAig2k9AYSgzMQjc6Rl6WIuSWsShKZnPnDlFHbLqATZRKJqa37vqlPtI57XlH+Cmd5Qc/D1z9WHrzHm2dqqYQD1HFro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525319; c=relaxed/simple;
	bh=wv5Ni6BcvfoLeM1R7gb98nw9OsDXLpV6xgytw4r5/m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhGlVjEpks0ylnJ972ekCtFTtdOOIhJSOzqxFSO6gZs2Hew9Qlu+P4PG5W3ukHByBH624WgcKOdPiueuQp4wNswujLWd6RdBq73ttTei7WVpBkwnYkdHG8mN5Sr0aXFS0l94YAaU1+AFX+pSzRqkhX9rb1Fpt1C/dQltLQDoBiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWDJFGtI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWDJFGtI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4864CC4CEEB;
	Mon, 18 Aug 2025 13:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525319;
	bh=wv5Ni6BcvfoLeM1R7gb98nw9OsDXLpV6xgytw4r5/m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWDJFGtIeWaXUm4E8UdCiTLqEX2vxKu0a4ZTI5ngV1td6Uf4yT/DnCSUjUWC7rELV
	 DCDBXrgU5b2AF1uzp30X8X7FbUT9vvREJ5W2yioshKAqMRWdbsdFg8iEskU1bJabpM
	 DDIqa+bTBLflll4vtkrkMStdhNT8S8zUH9nVNlew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhu Chittim <madhu.chittim@intel.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Simon Horman <horms@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 226/570] idpf: preserve coalescing settings across resets
Date: Mon, 18 Aug 2025 14:43:33 +0200
Message-ID: <20250818124514.525018803@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed Zaki <ahmed.zaki@intel.com>

[ Upstream commit e1e3fec3e34b4934a9d2c98e4ee00a4d87b19179 ]

The IRQ coalescing config currently reside only inside struct
idpf_q_vector. However, all idpf_q_vector structs are de-allocated and
re-allocated during resets. This leads to user-set coalesce configuration
to be lost.

Add new fields to struct idpf_vport_user_config_data to save the user
settings and re-apply them after reset.

Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf.h        | 19 ++++++++++
 .../net/ethernet/intel/idpf/idpf_ethtool.c    | 36 ++++++++++++++-----
 drivers/net/ethernet/intel/idpf/idpf_lib.c    | 18 +++++++++-
 drivers/net/ethernet/intel/idpf/idpf_main.c   |  1 +
 drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 13 ++++---
 5 files changed, 74 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf.h b/drivers/net/ethernet/intel/idpf/idpf.h
index 1e812c3f62f9..0bb9cab2b3c3 100644
--- a/drivers/net/ethernet/intel/idpf/idpf.h
+++ b/drivers/net/ethernet/intel/idpf/idpf.h
@@ -378,10 +378,28 @@ struct idpf_rss_data {
 	u32 *cached_lut;
 };
 
+/**
+ * struct idpf_q_coalesce - User defined coalescing configuration values for
+ *			   a single queue.
+ * @tx_intr_mode: Dynamic TX ITR or not
+ * @rx_intr_mode: Dynamic RX ITR or not
+ * @tx_coalesce_usecs: TX interrupt throttling rate
+ * @rx_coalesce_usecs: RX interrupt throttling rate
+ *
+ * Used to restore user coalescing configuration after a reset.
+ */
+struct idpf_q_coalesce {
+	u32 tx_intr_mode;
+	u32 rx_intr_mode;
+	u32 tx_coalesce_usecs;
+	u32 rx_coalesce_usecs;
+};
+
 /**
  * struct idpf_vport_user_config_data - User defined configuration values for
  *					each vport.
  * @rss_data: See struct idpf_rss_data
+ * @q_coalesce: Array of per queue coalescing data
  * @num_req_tx_qs: Number of user requested TX queues through ethtool
  * @num_req_rx_qs: Number of user requested RX queues through ethtool
  * @num_req_txq_desc: Number of user requested TX queue descriptors through
@@ -395,6 +413,7 @@ struct idpf_rss_data {
  */
 struct idpf_vport_user_config_data {
 	struct idpf_rss_data rss_data;
+	struct idpf_q_coalesce *q_coalesce;
 	u16 num_req_tx_qs;
 	u16 num_req_rx_qs;
 	u32 num_req_txq_desc;
diff --git a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
index eaf7a2606faa..f7599cd2aabf 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
@@ -1090,12 +1090,14 @@ static int idpf_get_per_q_coalesce(struct net_device *netdev, u32 q_num,
 /**
  * __idpf_set_q_coalesce - set ITR values for specific queue
  * @ec: ethtool structure from user to update ITR settings
+ * @q_coal: per queue coalesce settings
  * @qv: queue vector for which itr values has to be set
  * @is_rxq: is queue type rx
  *
  * Returns 0 on success, negative otherwise.
  */
 static int __idpf_set_q_coalesce(const struct ethtool_coalesce *ec,
+				 struct idpf_q_coalesce *q_coal,
 				 struct idpf_q_vector *qv, bool is_rxq)
 {
 	u32 use_adaptive_coalesce, coalesce_usecs;
@@ -1139,20 +1141,25 @@ static int __idpf_set_q_coalesce(const struct ethtool_coalesce *ec,
 
 	if (is_rxq) {
 		qv->rx_itr_value = coalesce_usecs;
+		q_coal->rx_coalesce_usecs = coalesce_usecs;
 		if (use_adaptive_coalesce) {
 			qv->rx_intr_mode = IDPF_ITR_DYNAMIC;
+			q_coal->rx_intr_mode = IDPF_ITR_DYNAMIC;
 		} else {
 			qv->rx_intr_mode = !IDPF_ITR_DYNAMIC;
-			idpf_vport_intr_write_itr(qv, qv->rx_itr_value,
-						  false);
+			q_coal->rx_intr_mode = !IDPF_ITR_DYNAMIC;
+			idpf_vport_intr_write_itr(qv, coalesce_usecs, false);
 		}
 	} else {
 		qv->tx_itr_value = coalesce_usecs;
+		q_coal->tx_coalesce_usecs = coalesce_usecs;
 		if (use_adaptive_coalesce) {
 			qv->tx_intr_mode = IDPF_ITR_DYNAMIC;
+			q_coal->tx_intr_mode = IDPF_ITR_DYNAMIC;
 		} else {
 			qv->tx_intr_mode = !IDPF_ITR_DYNAMIC;
-			idpf_vport_intr_write_itr(qv, qv->tx_itr_value, true);
+			q_coal->tx_intr_mode = !IDPF_ITR_DYNAMIC;
+			idpf_vport_intr_write_itr(qv, coalesce_usecs, true);
 		}
 	}
 
@@ -1165,6 +1172,7 @@ static int __idpf_set_q_coalesce(const struct ethtool_coalesce *ec,
 /**
  * idpf_set_q_coalesce - set ITR values for specific queue
  * @vport: vport associated to the queue that need updating
+ * @q_coal: per queue coalesce settings
  * @ec: coalesce settings to program the device with
  * @q_num: update ITR/INTRL (coalesce) settings for this queue number/index
  * @is_rxq: is queue type rx
@@ -1172,6 +1180,7 @@ static int __idpf_set_q_coalesce(const struct ethtool_coalesce *ec,
  * Return 0 on success, and negative on failure
  */
 static int idpf_set_q_coalesce(const struct idpf_vport *vport,
+			       struct idpf_q_coalesce *q_coal,
 			       const struct ethtool_coalesce *ec,
 			       int q_num, bool is_rxq)
 {
@@ -1180,7 +1189,7 @@ static int idpf_set_q_coalesce(const struct idpf_vport *vport,
 	qv = is_rxq ? idpf_find_rxq_vec(vport, q_num) :
 		      idpf_find_txq_vec(vport, q_num);
 
-	if (qv && __idpf_set_q_coalesce(ec, qv, is_rxq))
+	if (qv && __idpf_set_q_coalesce(ec, q_coal, qv, is_rxq))
 		return -EINVAL;
 
 	return 0;
@@ -1201,9 +1210,13 @@ static int idpf_set_coalesce(struct net_device *netdev,
 			     struct netlink_ext_ack *extack)
 {
 	struct idpf_netdev_priv *np = netdev_priv(netdev);
+	struct idpf_vport_user_config_data *user_config;
+	struct idpf_q_coalesce *q_coal;
 	struct idpf_vport *vport;
 	int i, err = 0;
 
+	user_config = &np->adapter->vport_config[np->vport_idx]->user_config;
+
 	idpf_vport_ctrl_lock(netdev);
 	vport = idpf_netdev_to_vport(netdev);
 
@@ -1211,13 +1224,15 @@ static int idpf_set_coalesce(struct net_device *netdev,
 		goto unlock_mutex;
 
 	for (i = 0; i < vport->num_txq; i++) {
-		err = idpf_set_q_coalesce(vport, ec, i, false);
+		q_coal = &user_config->q_coalesce[i];
+		err = idpf_set_q_coalesce(vport, q_coal, ec, i, false);
 		if (err)
 			goto unlock_mutex;
 	}
 
 	for (i = 0; i < vport->num_rxq; i++) {
-		err = idpf_set_q_coalesce(vport, ec, i, true);
+		q_coal = &user_config->q_coalesce[i];
+		err = idpf_set_q_coalesce(vport, q_coal, ec, i, true);
 		if (err)
 			goto unlock_mutex;
 	}
@@ -1239,20 +1254,25 @@ static int idpf_set_coalesce(struct net_device *netdev,
 static int idpf_set_per_q_coalesce(struct net_device *netdev, u32 q_num,
 				   struct ethtool_coalesce *ec)
 {
+	struct idpf_netdev_priv *np = netdev_priv(netdev);
+	struct idpf_vport_user_config_data *user_config;
+	struct idpf_q_coalesce *q_coal;
 	struct idpf_vport *vport;
 	int err;
 
 	idpf_vport_ctrl_lock(netdev);
 	vport = idpf_netdev_to_vport(netdev);
+	user_config = &np->adapter->vport_config[np->vport_idx]->user_config;
+	q_coal = &user_config->q_coalesce[q_num];
 
-	err = idpf_set_q_coalesce(vport, ec, q_num, false);
+	err = idpf_set_q_coalesce(vport, q_coal, ec, q_num, false);
 	if (err) {
 		idpf_vport_ctrl_unlock(netdev);
 
 		return err;
 	}
 
-	err = idpf_set_q_coalesce(vport, ec, q_num, true);
+	err = idpf_set_q_coalesce(vport, q_coal, ec, q_num, true);
 
 	idpf_vport_ctrl_unlock(netdev);
 
diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 80382ff4a5fa..e9f8da9f7979 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -1079,8 +1079,10 @@ static struct idpf_vport *idpf_vport_alloc(struct idpf_adapter *adapter,
 	if (!vport)
 		return vport;
 
+	num_max_q = max(max_q->max_txq, max_q->max_rxq);
 	if (!adapter->vport_config[idx]) {
 		struct idpf_vport_config *vport_config;
+		struct idpf_q_coalesce *q_coal;
 
 		vport_config = kzalloc(sizeof(*vport_config), GFP_KERNEL);
 		if (!vport_config) {
@@ -1089,6 +1091,21 @@ static struct idpf_vport *idpf_vport_alloc(struct idpf_adapter *adapter,
 			return NULL;
 		}
 
+		q_coal = kcalloc(num_max_q, sizeof(*q_coal), GFP_KERNEL);
+		if (!q_coal) {
+			kfree(vport_config);
+			kfree(vport);
+
+			return NULL;
+		}
+		for (int i = 0; i < num_max_q; i++) {
+			q_coal[i].tx_intr_mode = IDPF_ITR_DYNAMIC;
+			q_coal[i].tx_coalesce_usecs = IDPF_ITR_TX_DEF;
+			q_coal[i].rx_intr_mode = IDPF_ITR_DYNAMIC;
+			q_coal[i].rx_coalesce_usecs = IDPF_ITR_RX_DEF;
+		}
+		vport_config->user_config.q_coalesce = q_coal;
+
 		adapter->vport_config[idx] = vport_config;
 	}
 
@@ -1098,7 +1115,6 @@ static struct idpf_vport *idpf_vport_alloc(struct idpf_adapter *adapter,
 	vport->default_vport = adapter->num_alloc_vports <
 			       idpf_get_default_vports(adapter);
 
-	num_max_q = max(max_q->max_txq, max_q->max_rxq);
 	vport->q_vector_idxs = kcalloc(num_max_q, sizeof(u16), GFP_KERNEL);
 	if (!vport->q_vector_idxs)
 		goto free_vport;
diff --git a/drivers/net/ethernet/intel/idpf/idpf_main.c b/drivers/net/ethernet/intel/idpf/idpf_main.c
index 0efd9c0c7a90..6e0757ab406e 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_main.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_main.c
@@ -62,6 +62,7 @@ static void idpf_remove(struct pci_dev *pdev)
 	destroy_workqueue(adapter->vc_event_wq);
 
 	for (i = 0; i < adapter->max_vports; i++) {
+		kfree(adapter->vport_config[i]->user_config.q_coalesce);
 		kfree(adapter->vport_config[i]);
 		adapter->vport_config[i] = NULL;
 	}
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index 5cf440e09d0a..89185d1b8485 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -4349,9 +4349,13 @@ static void idpf_vport_intr_napi_add_all(struct idpf_vport *vport)
 int idpf_vport_intr_alloc(struct idpf_vport *vport)
 {
 	u16 txqs_per_vector, rxqs_per_vector, bufqs_per_vector;
+	struct idpf_vport_user_config_data *user_config;
 	struct idpf_q_vector *q_vector;
+	struct idpf_q_coalesce *q_coal;
 	u32 complqs_per_vector, v_idx;
+	u16 idx = vport->idx;
 
+	user_config = &vport->adapter->vport_config[idx]->user_config;
 	vport->q_vectors = kcalloc(vport->num_q_vectors,
 				   sizeof(struct idpf_q_vector), GFP_KERNEL);
 	if (!vport->q_vectors)
@@ -4369,14 +4373,15 @@ int idpf_vport_intr_alloc(struct idpf_vport *vport)
 
 	for (v_idx = 0; v_idx < vport->num_q_vectors; v_idx++) {
 		q_vector = &vport->q_vectors[v_idx];
+		q_coal = &user_config->q_coalesce[v_idx];
 		q_vector->vport = vport;
 
-		q_vector->tx_itr_value = IDPF_ITR_TX_DEF;
-		q_vector->tx_intr_mode = IDPF_ITR_DYNAMIC;
+		q_vector->tx_itr_value = q_coal->tx_coalesce_usecs;
+		q_vector->tx_intr_mode = q_coal->tx_intr_mode;
 		q_vector->tx_itr_idx = VIRTCHNL2_ITR_IDX_1;
 
-		q_vector->rx_itr_value = IDPF_ITR_RX_DEF;
-		q_vector->rx_intr_mode = IDPF_ITR_DYNAMIC;
+		q_vector->rx_itr_value = q_coal->rx_coalesce_usecs;
+		q_vector->rx_intr_mode = q_coal->rx_intr_mode;
 		q_vector->rx_itr_idx = VIRTCHNL2_ITR_IDX_0;
 
 		q_vector->tx = kcalloc(txqs_per_vector, sizeof(*q_vector->tx),
-- 
2.39.5



