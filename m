Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815FB143C43;
	Wed, 19 Jun 2024 12:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801998; cv=none; b=sbJ7R98IcG7rS9K8hRHzDFxuI7t/fqgnh9MlcDZ3BRLduclrsjydYANGla1XT0EXUPWeXptRT0lONd2qNg8gIv8H/+ObTdHhqO7s3hhq+Y5zblqbI/CRzLIAK1+s/yAT++nR4S1s288hCwRi33LYztCAPy6ShRjQCjQnDCUdrFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801998; c=relaxed/simple;
	bh=yFT7UNY7pQMhdK+I8YYTgy2y16gD4pwbytdFF372FYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDmsWfg6kWxvZXF25NE58rNp2+gPtROm+dJg3NHAiRAptkB6fNxbTtBEFq5V2cCbCqz4Bv2MiPhwIPKiYZtb2ZA0txM4mzkiz53EuAtuLayt1ifkvEk4cOwmnj5jikTFKcPffxcZ6tYBDbgk2vmc8TcoYt1rLXkIAhRqAoGqt+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9zKZcdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9zKZcdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F324BC2BBFC;
	Wed, 19 Jun 2024 12:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801998;
	bh=yFT7UNY7pQMhdK+I8YYTgy2y16gD4pwbytdFF372FYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9zKZcdxo45cDofTqT2y3OGj2vslMAjNbXTbzNXVXVraKre1Fcc+BBiydCSCCatCj
	 UjDeBwYXcTcWhu69rAEcG/pGQZ4yjRxWGYTG+uBqIyjyzwSV3rlUxKAd1D0KJE0V/v
	 /Mk0WMZwLMGT8FQyshYCg5XB736VE4jOE3+w1Njs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Bagnucki <igor.bagnucki@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Simon Horman <horms@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/267] ice: add flag to distinguish reset from .ndo_bpf in XDP rings config
Date: Wed, 19 Jun 2024 14:53:17 +0200
Message-ID: <20240619125608.133830257@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit 744d197162c2070a6045a71e2666ed93a57cc65d ]

Commit 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
has placed ice_vsi_free_q_vectors() after ice_destroy_xdp_rings() in
the rebuild process. The behaviour of the XDP rings config functions is
context-dependent, so the change of order has led to
ice_destroy_xdp_rings() doing additional work and removing XDP prog, when
it was supposed to be preserved.

Also, dependency on the PF state reset flags creates an additional,
fortunately less common problem:

* PFR is requested e.g. by tx_timeout handler
* .ndo_bpf() is asked to delete the program, calls ice_destroy_xdp_rings(),
  but reset flag is set, so rings are destroyed without deleting the
  program
* ice_vsi_rebuild tries to delete non-existent XDP rings, because the
  program is still on the VSI
* system crashes

With a similar race, when requested to attach a program,
ice_prepare_xdp_rings() can actually skip setting the program in the VSI
and nevertheless report success.

Instead of reverting to the old order of function calls, add an enum
argument to both ice_prepare_xdp_rings() and ice_destroy_xdp_rings() in
order to distinguish between calls from rebuild and .ndo_bpf().

Fixes: efc2214b6047 ("ice: Add support for XDP")
Reviewed-by: Igor Bagnucki <igor.bagnucki@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20240603-net-2024-05-30-intel-net-fixes-v2-4-e3563aa89b0c@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h      | 11 +++++++++--
 drivers/net/ethernet/intel/ice/ice_lib.c  |  5 +++--
 drivers/net/ethernet/intel/ice/ice_main.c | 22 ++++++++++++----------
 3 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index cf00eaa3e9955..c7962f322db2d 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -892,9 +892,16 @@ int ice_down(struct ice_vsi *vsi);
 int ice_down_up(struct ice_vsi *vsi);
 int ice_vsi_cfg_lan(struct ice_vsi *vsi);
 struct ice_vsi *ice_lb_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi);
+
+enum ice_xdp_cfg {
+	ICE_XDP_CFG_FULL,	/* Fully apply new config in .ndo_bpf() */
+	ICE_XDP_CFG_PART,	/* Save/use part of config in VSI rebuild */
+};
+
 int ice_vsi_determine_xdp_res(struct ice_vsi *vsi);
-int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog);
-int ice_destroy_xdp_rings(struct ice_vsi *vsi);
+int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog,
+			  enum ice_xdp_cfg cfg_type);
+int ice_destroy_xdp_rings(struct ice_vsi *vsi, enum ice_xdp_cfg cfg_type);
 int
 ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	     u32 flags);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 5a7ba0355d338..13ca3342a0cea 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2462,7 +2462,8 @@ ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vsi_cfg_params *params)
 			ret = ice_vsi_determine_xdp_res(vsi);
 			if (ret)
 				goto unroll_vector_base;
-			ret = ice_prepare_xdp_rings(vsi, vsi->xdp_prog);
+			ret = ice_prepare_xdp_rings(vsi, vsi->xdp_prog,
+						    ICE_XDP_CFG_PART);
 			if (ret)
 				goto unroll_vector_base;
 		}
@@ -2613,7 +2614,7 @@ void ice_vsi_decfg(struct ice_vsi *vsi)
 		/* return value check can be skipped here, it always returns
 		 * 0 if reset is in progress
 		 */
-		ice_destroy_xdp_rings(vsi);
+		ice_destroy_xdp_rings(vsi, ICE_XDP_CFG_PART);
 
 	ice_vsi_clear_rings(vsi);
 	ice_vsi_free_q_vectors(vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8ebb6517f6b96..5d71febdcd4dd 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2657,10 +2657,12 @@ static void ice_vsi_assign_bpf_prog(struct ice_vsi *vsi, struct bpf_prog *prog)
  * ice_prepare_xdp_rings - Allocate, configure and setup Tx rings for XDP
  * @vsi: VSI to bring up Tx rings used by XDP
  * @prog: bpf program that will be assigned to VSI
+ * @cfg_type: create from scratch or restore the existing configuration
  *
  * Return 0 on success and negative value on error
  */
-int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
+int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog,
+			  enum ice_xdp_cfg cfg_type)
 {
 	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
 	int xdp_rings_rem = vsi->num_xdp_txq;
@@ -2736,7 +2738,7 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
 	 * taken into account at the end of ice_vsi_rebuild, where
 	 * ice_cfg_vsi_lan is being called
 	 */
-	if (ice_is_reset_in_progress(pf->state))
+	if (cfg_type == ICE_XDP_CFG_PART)
 		return 0;
 
 	/* tell the Tx scheduler that right now we have
@@ -2788,22 +2790,21 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
 /**
  * ice_destroy_xdp_rings - undo the configuration made by ice_prepare_xdp_rings
  * @vsi: VSI to remove XDP rings
+ * @cfg_type: disable XDP permanently or allow it to be restored later
  *
  * Detach XDP rings from irq vectors, clean up the PF bitmap and free
  * resources
  */
-int ice_destroy_xdp_rings(struct ice_vsi *vsi)
+int ice_destroy_xdp_rings(struct ice_vsi *vsi, enum ice_xdp_cfg cfg_type)
 {
 	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
 	struct ice_pf *pf = vsi->back;
 	int i, v_idx;
 
 	/* q_vectors are freed in reset path so there's no point in detaching
-	 * rings; in case of rebuild being triggered not from reset bits
-	 * in pf->state won't be set, so additionally check first q_vector
-	 * against NULL
+	 * rings
 	 */
-	if (ice_is_reset_in_progress(pf->state) || !vsi->q_vectors[0])
+	if (cfg_type == ICE_XDP_CFG_PART)
 		goto free_qmap;
 
 	ice_for_each_q_vector(vsi, v_idx) {
@@ -2844,7 +2845,7 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi)
 	if (static_key_enabled(&ice_xdp_locking_key))
 		static_branch_dec(&ice_xdp_locking_key);
 
-	if (ice_is_reset_in_progress(pf->state) || !vsi->q_vectors[0])
+	if (cfg_type == ICE_XDP_CFG_PART)
 		return 0;
 
 	ice_vsi_assign_bpf_prog(vsi, NULL);
@@ -2955,7 +2956,8 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 		if (xdp_ring_err) {
 			NL_SET_ERR_MSG_MOD(extack, "Not enough Tx resources for XDP");
 		} else {
-			xdp_ring_err = ice_prepare_xdp_rings(vsi, prog);
+			xdp_ring_err = ice_prepare_xdp_rings(vsi, prog,
+							     ICE_XDP_CFG_FULL);
 			if (xdp_ring_err)
 				NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
 		}
@@ -2966,7 +2968,7 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 			NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Rx resources failed");
 	} else if (ice_is_xdp_ena_vsi(vsi) && !prog) {
 		xdp_features_clear_redirect_target(vsi->netdev);
-		xdp_ring_err = ice_destroy_xdp_rings(vsi);
+		xdp_ring_err = ice_destroy_xdp_rings(vsi, ICE_XDP_CFG_FULL);
 		if (xdp_ring_err)
 			NL_SET_ERR_MSG_MOD(extack, "Freeing XDP Tx resources failed");
 		/* reallocate Rx queues that were used for zero-copy */
-- 
2.43.0



