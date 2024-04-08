Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3747BB07;
	Mon,  8 Apr 2024 13:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581539; cv=none; b=Z9DJ1x2iAffGmS2o/uQSMqhYb4FtDy8+pAip2MqnBeTQoXya15ejZihZ3OQ27fzIWlfOAsYmmQoPdWbJAbzrfKKRKFxoVgz4QqqrBLwxR6l9sTTTXN4CO8dsWw8lWffju9ALM6l8JaOjBIAv8w0t+LY5lvOdboxZRikyAG5j/Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581539; c=relaxed/simple;
	bh=EfUnSHYxGHmu8tkqMgBO43Gd08qGJxrMzRlHJX3hkAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUltJ52tCOOe7NlpMjpIGrHbPHU0IOaOTwE8GTqkyIfUjm3EfTiQUZwmOc1qLi/7tgRrD8MrYlwioc31Q4YbVbQP5f7S40P/4JDdliFuVzdOvJFk/ds+Zl2MjdMdWrpuKPG7VqQ23GgT2PbF+5gC7dLpk4mqntw/27qJ5X4E4ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SX9QkxuV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SX9QkxuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88726C433C7;
	Mon,  8 Apr 2024 13:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581538;
	bh=EfUnSHYxGHmu8tkqMgBO43Gd08qGJxrMzRlHJX3hkAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SX9QkxuVYkhbBztwkIyXeU9pVrdInDTWUE6DwFWUi+34cG7ExKG4DA8u3aEcwUrpE
	 04bgXTxlYA24yqitAHB60oT/FKoQt6xsE/EFe4l5QRqMnkFq0qaZs/wHfyKwWVyCUx
	 q2+z7KQXxOPwc7UEXFSYMXeOJma/4x49y1yM6MWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/252] ice: realloc VSI stats arrays
Date: Mon,  8 Apr 2024 14:55:15 +0200
Message-ID: <20240408125307.152787118@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit 5995ef88e3a8c2b014f51256a88be8e336532ce7 ]

Previously only case when queues amount is lower was covered. Implement
realloc for case when queues amount is higher than previous one. Use
krealloc() function and zero new allocated elements.

It has to be done before ice_vsi_def_cfg(), because stats element for
ring is set there.

Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 1cb7fdb1dfde ("ice: fix memory corruption bug with suspend and rebuild")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 58 ++++++++++++++++--------
 1 file changed, 39 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 7f4bc110ead44..47298ab675a55 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3084,27 +3084,26 @@ ice_vsi_rebuild_set_coalesce(struct ice_vsi *vsi,
 }
 
 /**
- * ice_vsi_realloc_stat_arrays - Frees unused stat structures
+ * ice_vsi_realloc_stat_arrays - Frees unused stat structures or alloc new ones
  * @vsi: VSI pointer
- * @prev_txq: Number of Tx rings before ring reallocation
- * @prev_rxq: Number of Rx rings before ring reallocation
  */
-static void
-ice_vsi_realloc_stat_arrays(struct ice_vsi *vsi, int prev_txq, int prev_rxq)
+static int
+ice_vsi_realloc_stat_arrays(struct ice_vsi *vsi)
 {
+	u16 req_txq = vsi->req_txq ? vsi->req_txq : vsi->alloc_txq;
+	u16 req_rxq = vsi->req_rxq ? vsi->req_rxq : vsi->alloc_rxq;
+	struct ice_ring_stats **tx_ring_stats;
+	struct ice_ring_stats **rx_ring_stats;
 	struct ice_vsi_stats *vsi_stat;
 	struct ice_pf *pf = vsi->back;
+	u16 prev_txq = vsi->alloc_txq;
+	u16 prev_rxq = vsi->alloc_rxq;
 	int i;
 
-	if (!prev_txq || !prev_rxq)
-		return;
-	if (vsi->type == ICE_VSI_CHNL)
-		return;
-
 	vsi_stat = pf->vsi_stats[vsi->idx];
 
-	if (vsi->num_txq < prev_txq) {
-		for (i = vsi->num_txq; i < prev_txq; i++) {
+	if (req_txq < prev_txq) {
+		for (i = req_txq; i < prev_txq; i++) {
 			if (vsi_stat->tx_ring_stats[i]) {
 				kfree_rcu(vsi_stat->tx_ring_stats[i], rcu);
 				WRITE_ONCE(vsi_stat->tx_ring_stats[i], NULL);
@@ -3112,14 +3111,36 @@ ice_vsi_realloc_stat_arrays(struct ice_vsi *vsi, int prev_txq, int prev_rxq)
 		}
 	}
 
-	if (vsi->num_rxq < prev_rxq) {
-		for (i = vsi->num_rxq; i < prev_rxq; i++) {
+	tx_ring_stats = vsi_stat->rx_ring_stats;
+	vsi_stat->tx_ring_stats =
+		krealloc_array(vsi_stat->tx_ring_stats, req_txq,
+			       sizeof(*vsi_stat->tx_ring_stats),
+			       GFP_KERNEL | __GFP_ZERO);
+	if (!vsi_stat->tx_ring_stats) {
+		vsi_stat->tx_ring_stats = tx_ring_stats;
+		return -ENOMEM;
+	}
+
+	if (req_rxq < prev_rxq) {
+		for (i = req_rxq; i < prev_rxq; i++) {
 			if (vsi_stat->rx_ring_stats[i]) {
 				kfree_rcu(vsi_stat->rx_ring_stats[i], rcu);
 				WRITE_ONCE(vsi_stat->rx_ring_stats[i], NULL);
 			}
 		}
 	}
+
+	rx_ring_stats = vsi_stat->rx_ring_stats;
+	vsi_stat->rx_ring_stats =
+		krealloc_array(vsi_stat->rx_ring_stats, req_rxq,
+			       sizeof(*vsi_stat->rx_ring_stats),
+			       GFP_KERNEL | __GFP_ZERO);
+	if (!vsi_stat->rx_ring_stats) {
+		vsi_stat->rx_ring_stats = rx_ring_stats;
+		return -ENOMEM;
+	}
+
+	return 0;
 }
 
 /**
@@ -3136,9 +3157,9 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, u32 vsi_flags)
 {
 	struct ice_vsi_cfg_params params = {};
 	struct ice_coalesce_stored *coalesce;
-	int ret, prev_txq, prev_rxq;
 	int prev_num_q_vectors = 0;
 	struct ice_pf *pf;
+	int ret;
 
 	if (!vsi)
 		return -EINVAL;
@@ -3157,8 +3178,9 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, u32 vsi_flags)
 
 	prev_num_q_vectors = ice_vsi_rebuild_get_coalesce(vsi, coalesce);
 
-	prev_txq = vsi->num_txq;
-	prev_rxq = vsi->num_rxq;
+	ret = ice_vsi_realloc_stat_arrays(vsi);
+	if (ret)
+		goto err_vsi_cfg;
 
 	ice_vsi_decfg(vsi);
 	ret = ice_vsi_cfg_def(vsi, &params);
@@ -3176,8 +3198,6 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, u32 vsi_flags)
 		return ice_schedule_reset(pf, ICE_RESET_PFR);
 	}
 
-	ice_vsi_realloc_stat_arrays(vsi, prev_txq, prev_rxq);
-
 	ice_vsi_rebuild_set_coalesce(vsi, coalesce, prev_num_q_vectors);
 	kfree(coalesce);
 
-- 
2.43.0



