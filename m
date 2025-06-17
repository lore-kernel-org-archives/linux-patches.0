Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9B22DFF03;
	Tue, 17 Jun 2025 16:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176176; cv=none; b=efEXxujVy0JzJ069ghT5JXoJ0N+ihkgp/wga8uoxKq9wFRp4VhFtzunWZzBLXqUy7bRUt0wVaH66KtrtJqratIcwPB0lVKSNgnSBrzQj+AoaHt8E2Ws2r473NDlrUD4wTgV13Ffzj1aSMKCXlRMRF2ygs8b3qfMvuTTIbns/h9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176176; c=relaxed/simple;
	bh=ZFQyUJsTktW88Za1Qqz6UUhXEremtQ2zeWONIBhiRyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OdBASvyos0jbGKQmE0rTJhMxPv3+eHe+F8DTDI9/ml8m2QGrmvU9OSctubXtJhWSze3f1Li4TIEQ9GLUHOJVEVQHEBW9xPIFF4t/mT3X68gPDSXRuM8K6sqYYdXirbkbjrZeQ1OnMuNJiIZWn1Gb1G9khLzdmPvIc1dxFNwaRUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHQ7JCvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHQ7JCvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130ACC4CEE3;
	Tue, 17 Jun 2025 16:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176176;
	bh=ZFQyUJsTktW88Za1Qqz6UUhXEremtQ2zeWONIBhiRyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHQ7JCvOSFFh3vmsueyfHM5S+lPBEvTeVnTH1sTmcXdWAzFWe/ETv5yfWG6I2sLi5
	 dL8ZYM4rf337k93erpD92hy3HcRTbUrdfV6pkCxRtMuxEChdgBD/xtXmTNaU/X3I2N
	 zZYXNsTmKvN99k8otunB3h2IyMlhL5XfnoUjfeUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jesse Brandeburg <jbrandeburg@cloudflare.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Saritha Sanigani <sarithax.sanigani@intel.com>
Subject: [PATCH 6.6 252/356] ice: fix Tx scheduler error handling in XDP callback
Date: Tue, 17 Jun 2025 17:26:07 +0200
Message-ID: <20250617152348.346172616@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Kubiak <michal.kubiak@intel.com>

[ Upstream commit 0153f36041b8e52019ebfa8629c13bf8f9b0a951 ]

When the XDP program is loaded, the XDP callback adds new Tx queues.
This means that the callback must update the Tx scheduler with the new
queue number. In the event of a Tx scheduler failure, the XDP callback
should also fail and roll back any changes previously made for XDP
preparation.

The previous implementation had a bug that not all changes made by the
XDP callback were rolled back. This caused the crash with the following
call trace:

[  +9.549584] ice 0000:ca:00.0: Failed VSI LAN queue config for XDP, error: -5
[  +0.382335] Oops: general protection fault, probably for non-canonical address 0x50a2250a90495525: 0000 [#1] SMP NOPTI
[  +0.010710] CPU: 103 UID: 0 PID: 0 Comm: swapper/103 Not tainted 6.14.0-net-next-mar-31+ #14 PREEMPT(voluntary)
[  +0.010175] Hardware name: Intel Corporation M50CYP2SBSTD/M50CYP2SBSTD, BIOS SE5C620.86B.01.01.0005.2202160810 02/16/2022
[  +0.010946] RIP: 0010:__ice_update_sample+0x39/0xe0 [ice]

[...]

[  +0.002715] Call Trace:
[  +0.002452]  <IRQ>
[  +0.002021]  ? __die_body.cold+0x19/0x29
[  +0.003922]  ? die_addr+0x3c/0x60
[  +0.003319]  ? exc_general_protection+0x17c/0x400
[  +0.004707]  ? asm_exc_general_protection+0x26/0x30
[  +0.004879]  ? __ice_update_sample+0x39/0xe0 [ice]
[  +0.004835]  ice_napi_poll+0x665/0x680 [ice]
[  +0.004320]  __napi_poll+0x28/0x190
[  +0.003500]  net_rx_action+0x198/0x360
[  +0.003752]  ? update_rq_clock+0x39/0x220
[  +0.004013]  handle_softirqs+0xf1/0x340
[  +0.003840]  ? sched_clock_cpu+0xf/0x1f0
[  +0.003925]  __irq_exit_rcu+0xc2/0xe0
[  +0.003665]  common_interrupt+0x85/0xa0
[  +0.003839]  </IRQ>
[  +0.002098]  <TASK>
[  +0.002106]  asm_common_interrupt+0x26/0x40
[  +0.004184] RIP: 0010:cpuidle_enter_state+0xd3/0x690

Fix this by performing the missing unmapping of XDP queues from
q_vectors and setting the XDP rings pointer back to NULL after all those
queues are released.
Also, add an immediate exit from the XDP callback in case of ring
preparation failure.

Fixes: efc2214b6047 ("ice: Add support for XDP")
Reviewed-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Jesse Brandeburg <jbrandeburg@cloudflare.com>
Tested-by: Saritha Sanigani <sarithax.sanigani@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 47 ++++++++++++++++-------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0ae7bdfff83fb..e1a68fb5e9fff 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2650,6 +2650,27 @@ static void ice_vsi_assign_bpf_prog(struct ice_vsi *vsi, struct bpf_prog *prog)
 		bpf_prog_put(old_prog);
 }
 
+/**
+ * ice_unmap_xdp_rings - Unmap XDP rings from interrupt vectors
+ * @vsi: the VSI with XDP rings being unmapped
+ */
+static void ice_unmap_xdp_rings(struct ice_vsi *vsi)
+{
+	int v_idx;
+
+	ice_for_each_q_vector(vsi, v_idx) {
+		struct ice_q_vector *q_vector = vsi->q_vectors[v_idx];
+		struct ice_tx_ring *ring;
+
+		ice_for_each_tx_ring(ring, q_vector->tx)
+			if (!ring->tx_buf || !ice_ring_is_xdp(ring))
+				break;
+
+		/* restore the value of last node prior to XDP setup */
+		q_vector->tx.tx_ring = ring;
+	}
+}
+
 /**
  * ice_prepare_xdp_rings - Allocate, configure and setup Tx rings for XDP
  * @vsi: VSI to bring up Tx rings used by XDP
@@ -2749,7 +2770,7 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog,
 	if (status) {
 		dev_err(dev, "Failed VSI LAN queue config for XDP, error: %d\n",
 			status);
-		goto clear_xdp_rings;
+		goto unmap_xdp_rings;
 	}
 
 	/* assign the prog only when it's not already present on VSI;
@@ -2765,6 +2786,8 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog,
 		ice_vsi_assign_bpf_prog(vsi, prog);
 
 	return 0;
+unmap_xdp_rings:
+	ice_unmap_xdp_rings(vsi);
 clear_xdp_rings:
 	ice_for_each_xdp_txq(vsi, i)
 		if (vsi->xdp_rings[i]) {
@@ -2781,6 +2804,8 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog,
 	mutex_unlock(&pf->avail_q_mutex);
 
 	devm_kfree(dev, vsi->xdp_rings);
+	vsi->xdp_rings = NULL;
+
 	return -ENOMEM;
 }
 
@@ -2796,7 +2821,7 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi, enum ice_xdp_cfg cfg_type)
 {
 	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
 	struct ice_pf *pf = vsi->back;
-	int i, v_idx;
+	int i;
 
 	/* q_vectors are freed in reset path so there's no point in detaching
 	 * rings
@@ -2804,17 +2829,7 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi, enum ice_xdp_cfg cfg_type)
 	if (cfg_type == ICE_XDP_CFG_PART)
 		goto free_qmap;
 
-	ice_for_each_q_vector(vsi, v_idx) {
-		struct ice_q_vector *q_vector = vsi->q_vectors[v_idx];
-		struct ice_tx_ring *ring;
-
-		ice_for_each_tx_ring(ring, q_vector->tx)
-			if (!ring->tx_buf || !ice_ring_is_xdp(ring))
-				break;
-
-		/* restore the value of last node prior to XDP setup */
-		q_vector->tx.tx_ring = ring;
-	}
+	ice_unmap_xdp_rings(vsi);
 
 free_qmap:
 	mutex_lock(&pf->avail_q_mutex);
@@ -2956,11 +2971,14 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 		xdp_ring_err = ice_vsi_determine_xdp_res(vsi);
 		if (xdp_ring_err) {
 			NL_SET_ERR_MSG_MOD(extack, "Not enough Tx resources for XDP");
+			goto resume_if;
 		} else {
 			xdp_ring_err = ice_prepare_xdp_rings(vsi, prog,
 							     ICE_XDP_CFG_FULL);
-			if (xdp_ring_err)
+			if (xdp_ring_err) {
 				NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
+				goto resume_if;
+			}
 		}
 		xdp_features_set_redirect_target(vsi->netdev, true);
 		/* reallocate Rx queues that are used for zero-copy */
@@ -2978,6 +2996,7 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 			NL_SET_ERR_MSG_MOD(extack, "Freeing XDP Rx resources failed");
 	}
 
+resume_if:
 	if (if_running)
 		ret = ice_up(vsi);
 
-- 
2.39.5



