Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C34F1422B8;
	Wed, 19 Jun 2024 13:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802807; cv=none; b=OoWNGVDO+34ONWs57vyfhrvMTrmqr2+qAtexbXRvjyfuFWDBrKh6pg87zOi+ANrGg/7pTgzghdOE3FgkqcXirhKy6e/tfG7YEYTSYiAgrKV9cQFdynkqkDjGuW9g4oRWMpfTP8Ms4vkZd9LpJSHuAuTPCwROvUg4jszxHq+KVtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802807; c=relaxed/simple;
	bh=67ypC9o4tAIC0HIf63AhY8FaszqLtfErKSJPAtYEccA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2NA1fFkgUDWEAwaDNy5g5zgROHz6Bgsz7q4F/G9oyxKPP2XK5S/c+6kaxQ+Iw6iQvnIBq+PxmEUSzWGkjFxKWqjZmRB8AirLeXd+5nMiRNAqgFpziWdYAGoQ5SNzvUfIF7es3vEc9RyLb8w6YaQkkEAQ9xIH20z1Xh0emV3+4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpmiR+YV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpmiR+YV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EE0C32786;
	Wed, 19 Jun 2024 13:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802807;
	bh=67ypC9o4tAIC0HIf63AhY8FaszqLtfErKSJPAtYEccA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpmiR+YVYzKoOtaUsV2bG2z90+ZyMl19NCBQha8e9S59m9Nx8QE/nrqwl9PkdbqU9
	 /JCy5M/cCa/zLPWE5B0KeEjmPSwHdXrXn22xrVejtz5IVOoZRDkg+zn84vE4eS63Kc
	 1W7swYJ0jYH9+uAj5FFOEcWEL1IWFg1BSU0C4pj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Simon Horman <horms@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 054/281] ice: map XDP queues to vectors in ice_vsi_map_rings_to_vectors()
Date: Wed, 19 Jun 2024 14:53:33 +0200
Message-ID: <20240619125611.930497968@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit f3df4044254c98128890b512bf19cc05588f1fe5 ]

ice_pf_dcb_recfg() re-maps queues to vectors with
ice_vsi_map_rings_to_vectors(), which does not restore the previous
state for XDP queues. This leads to no AF_XDP traffic after rebuild.

Map XDP queues to vectors in ice_vsi_map_rings_to_vectors().
Also, move the code around, so XDP queues are mapped independently only
through .ndo_bpf().

Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20240603-net-2024-05-30-intel-net-fixes-v2-5-e3563aa89b0c@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h      |  1 +
 drivers/net/ethernet/intel/ice/ice_base.c |  3 +
 drivers/net/ethernet/intel/ice/ice_lib.c  | 14 ++--
 drivers/net/ethernet/intel/ice/ice_main.c | 96 ++++++++++++++---------
 4 files changed, 68 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index a3286964d6c31..8e40f26aa5060 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -942,6 +942,7 @@ int ice_vsi_determine_xdp_res(struct ice_vsi *vsi);
 int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog,
 			  enum ice_xdp_cfg cfg_type);
 int ice_destroy_xdp_rings(struct ice_vsi *vsi, enum ice_xdp_cfg cfg_type);
+void ice_map_xdp_rings(struct ice_vsi *vsi);
 int
 ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	     u32 flags);
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index a545a7917e4fc..9d23a436d2a6a 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -860,6 +860,9 @@ void ice_vsi_map_rings_to_vectors(struct ice_vsi *vsi)
 		}
 		rx_rings_rem -= rx_rings_per_v;
 	}
+
+	if (ice_is_xdp_ena_vsi(vsi))
+		ice_map_xdp_rings(vsi);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 5de7c50b439e1..acf732ce04ed6 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2323,13 +2323,6 @@ ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vsi_cfg_params *params)
 		if (ret)
 			goto unroll_vector_base;
 
-		ice_vsi_map_rings_to_vectors(vsi);
-
-		/* Associate q_vector rings to napi */
-		ice_vsi_set_napi_queues(vsi);
-
-		vsi->stat_offsets_loaded = false;
-
 		if (ice_is_xdp_ena_vsi(vsi)) {
 			ret = ice_vsi_determine_xdp_res(vsi);
 			if (ret)
@@ -2340,6 +2333,13 @@ ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vsi_cfg_params *params)
 				goto unroll_vector_base;
 		}
 
+		ice_vsi_map_rings_to_vectors(vsi);
+
+		/* Associate q_vector rings to napi */
+		ice_vsi_set_napi_queues(vsi);
+
+		vsi->stat_offsets_loaded = false;
+
 		/* ICE_VSI_CTRL does not need RSS so skip RSS processing */
 		if (vsi->type != ICE_VSI_CTRL)
 			/* Do not exit if configuring RSS had an issue, at
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b53fe27dbed7d..10fef2e726b39 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2670,6 +2670,60 @@ static void ice_vsi_assign_bpf_prog(struct ice_vsi *vsi, struct bpf_prog *prog)
 		bpf_prog_put(old_prog);
 }
 
+static struct ice_tx_ring *ice_xdp_ring_from_qid(struct ice_vsi *vsi, int qid)
+{
+	struct ice_q_vector *q_vector;
+	struct ice_tx_ring *ring;
+
+	if (static_key_enabled(&ice_xdp_locking_key))
+		return vsi->xdp_rings[qid % vsi->num_xdp_txq];
+
+	q_vector = vsi->rx_rings[qid]->q_vector;
+	ice_for_each_tx_ring(ring, q_vector->tx)
+		if (ice_ring_is_xdp(ring))
+			return ring;
+
+	return NULL;
+}
+
+/**
+ * ice_map_xdp_rings - Map XDP rings to interrupt vectors
+ * @vsi: the VSI with XDP rings being configured
+ *
+ * Map XDP rings to interrupt vectors and perform the configuration steps
+ * dependent on the mapping.
+ */
+void ice_map_xdp_rings(struct ice_vsi *vsi)
+{
+	int xdp_rings_rem = vsi->num_xdp_txq;
+	int v_idx, q_idx;
+
+	/* follow the logic from ice_vsi_map_rings_to_vectors */
+	ice_for_each_q_vector(vsi, v_idx) {
+		struct ice_q_vector *q_vector = vsi->q_vectors[v_idx];
+		int xdp_rings_per_v, q_id, q_base;
+
+		xdp_rings_per_v = DIV_ROUND_UP(xdp_rings_rem,
+					       vsi->num_q_vectors - v_idx);
+		q_base = vsi->num_xdp_txq - xdp_rings_rem;
+
+		for (q_id = q_base; q_id < (q_base + xdp_rings_per_v); q_id++) {
+			struct ice_tx_ring *xdp_ring = vsi->xdp_rings[q_id];
+
+			xdp_ring->q_vector = q_vector;
+			xdp_ring->next = q_vector->tx.tx_ring;
+			q_vector->tx.tx_ring = xdp_ring;
+		}
+		xdp_rings_rem -= xdp_rings_per_v;
+	}
+
+	ice_for_each_rxq(vsi, q_idx) {
+		vsi->rx_rings[q_idx]->xdp_ring = ice_xdp_ring_from_qid(vsi,
+								       q_idx);
+		ice_tx_xsk_pool(vsi, q_idx);
+	}
+}
+
 /**
  * ice_prepare_xdp_rings - Allocate, configure and setup Tx rings for XDP
  * @vsi: VSI to bring up Tx rings used by XDP
@@ -2682,7 +2736,6 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog,
 			  enum ice_xdp_cfg cfg_type)
 {
 	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
-	int xdp_rings_rem = vsi->num_xdp_txq;
 	struct ice_pf *pf = vsi->back;
 	struct ice_qs_cfg xdp_qs_cfg = {
 		.qs_mutex = &pf->avail_q_mutex,
@@ -2695,8 +2748,7 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog,
 		.mapping_mode = ICE_VSI_MAP_CONTIG
 	};
 	struct device *dev;
-	int i, v_idx;
-	int status;
+	int status, i;
 
 	dev = ice_pf_to_dev(pf);
 	vsi->xdp_rings = devm_kcalloc(dev, vsi->num_xdp_txq,
@@ -2715,42 +2767,6 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog,
 	if (ice_xdp_alloc_setup_rings(vsi))
 		goto clear_xdp_rings;
 
-	/* follow the logic from ice_vsi_map_rings_to_vectors */
-	ice_for_each_q_vector(vsi, v_idx) {
-		struct ice_q_vector *q_vector = vsi->q_vectors[v_idx];
-		int xdp_rings_per_v, q_id, q_base;
-
-		xdp_rings_per_v = DIV_ROUND_UP(xdp_rings_rem,
-					       vsi->num_q_vectors - v_idx);
-		q_base = vsi->num_xdp_txq - xdp_rings_rem;
-
-		for (q_id = q_base; q_id < (q_base + xdp_rings_per_v); q_id++) {
-			struct ice_tx_ring *xdp_ring = vsi->xdp_rings[q_id];
-
-			xdp_ring->q_vector = q_vector;
-			xdp_ring->next = q_vector->tx.tx_ring;
-			q_vector->tx.tx_ring = xdp_ring;
-		}
-		xdp_rings_rem -= xdp_rings_per_v;
-	}
-
-	ice_for_each_rxq(vsi, i) {
-		if (static_key_enabled(&ice_xdp_locking_key)) {
-			vsi->rx_rings[i]->xdp_ring = vsi->xdp_rings[i % vsi->num_xdp_txq];
-		} else {
-			struct ice_q_vector *q_vector = vsi->rx_rings[i]->q_vector;
-			struct ice_tx_ring *ring;
-
-			ice_for_each_tx_ring(ring, q_vector->tx) {
-				if (ice_ring_is_xdp(ring)) {
-					vsi->rx_rings[i]->xdp_ring = ring;
-					break;
-				}
-			}
-		}
-		ice_tx_xsk_pool(vsi, i);
-	}
-
 	/* omit the scheduler update if in reset path; XDP queues will be
 	 * taken into account at the end of ice_vsi_rebuild, where
 	 * ice_cfg_vsi_lan is being called
@@ -2758,6 +2774,8 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog,
 	if (cfg_type == ICE_XDP_CFG_PART)
 		return 0;
 
+	ice_map_xdp_rings(vsi);
+
 	/* tell the Tx scheduler that right now we have
 	 * additional queues
 	 */
-- 
2.43.0



