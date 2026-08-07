Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DD32D12ED;
	Fri,  7 Aug 2026 15:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115595; cv=none; b=GqNG3qtKPk9CXUc7+2p5K3+4pdC+3BDf5ZeuZVaL1WTvvGObxl4tdrRnFezK+8AQSHXtCGaRVHax/NaxepJqxIOYlbajpyQngzA926e0giX5i0I5ILgja0pEsyPeDBGBicupWV8nxsEDkzz3JdNryVVwvpt1XD1TgQEiz+HcE8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115595; c=relaxed/simple;
	bh=FWYc2QCJghI015M5Lyyqn03nPnny9KzcM+NBIBi/gko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIF+0QGNqZTG/nHe5Xvhywa8+xpcvW5yF5t3QznvaoYHXkXx/IdxYmbPBs5AIjVhFQWdw+5PoUIOv41epHKys470K8YWEWY8Ki7tFnODwZeroteYdFqO0x2IBPozu3hLDsYA+jl5m8j24OTwplhQOlfHYKRy2PJTNLwAanSk65I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiLmVteP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiLmVteP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278AD1F000E9;
	Fri,  7 Aug 2026 15:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115593;
	bh=etg7rcPy5XU4OcOz2YZHTClzgEIfLL04+/6XdTyRFt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IiLmVtePpl8zdv1soygw0pN0JUKhinFrPwh7fyK+Si2mnx+oKjMbnx7Ic5LS4KfHX
	 KHdkeejCbl9eNpjeV+ktr3F0XDdnChiDCDP4AkJduecUKoXwCdrWyGmo0nROj9qwsU
	 JRGTb6bu3e6mnPQMVkZx0h6ecLFiUnqzfHTwtKbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Medvedkin <vladimir.medvedkin@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Patryk Holda <patryk.holda@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.18 286/396] ice: fix VF interrupts cleanup
Date: Fri,  7 Aug 2026 16:37:26 +0200
Message-ID: <20260807143430.438462124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>

commit fb096882095e5a8d6b5159e43793d4a38a0c5b1f upstream.

When a virtual function sends an IRQ map command, the PF will set up
interrupts according to that request. However, because these interrupts are
never reset, the next time Virtual Function initializes, the interrupts are
still enabled for a given VF, which leads to performance degradation in
certain cases due to interrupts being unexpectedly enabled and thus causing
interrupt floods.

Cc: stable@vger.kernel.org
Fixes: 1071a8358a28 ("ice: Implement virtchnl commands for AVF support")
Suggested-by: Vladimir Medvedkin <vladimir.medvedkin@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Patryk Holda <patryk.holda@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c         |   27 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_vf_lib_private.h |    1 
 drivers/net/ethernet/intel/ice/virt/queues.c        |   21 +++++++++++++++
 3 files changed, 49 insertions(+)

--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -849,6 +849,30 @@ static void ice_notify_vf_reset(struct i
 }
 
 /**
+ * ice_reset_interrupts - clear all queue interrupt configuration for a VSI
+ * @vsi: the VSI whose interrupt registers should be cleared
+ *
+ * Zero the QINT_RQCTL and QINT_TQCTL registers for all allocated queues
+ * in the VSI. This clears the entire register including MSIX_INDX, ITR_INDX,
+ * CAUSE_ENA and NEXTQ fields, unlike ice_vf_dis_rxq_interrupt() which only
+ * clears the CAUSE_ENA bit.
+ */
+void ice_reset_interrupts(struct ice_vsi *vsi)
+{
+	struct ice_pf *pf = vsi->back;
+	struct ice_hw *hw = &pf->hw;
+	int i;
+
+	ice_for_each_alloc_rxq(vsi, i)
+		wr32(hw, QINT_RQCTL(vsi->rxq_map[i]), 0);
+
+	ice_for_each_alloc_txq(vsi, i)
+		wr32(hw, QINT_TQCTL(vsi->txq_map[i]), 0);
+
+	ice_flush(hw);
+}
+
+/**
  * ice_reset_vf - Reset a particular VF
  * @vf: pointer to the VF structure
  * @flags: flags controlling behavior of the reset
@@ -919,6 +943,9 @@ int ice_reset_vf(struct ice_vf *vf, u32
 
 	ice_dis_vf_qs(vf);
 
+	/* cleanup interrupt registers */
+	ice_reset_interrupts(vsi);
+
 	/* Call Disable LAN Tx queue AQ whether or not queues are
 	 * enabled. This is needed for successful completion of VFR.
 	 */
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
@@ -26,6 +26,7 @@
 void ice_initialize_vf_entry(struct ice_vf *vf);
 void ice_deinitialize_vf_entry(struct ice_vf *vf);
 void ice_dis_vf_qs(struct ice_vf *vf);
+void ice_reset_interrupts(struct ice_vsi *vsi);
 int ice_check_vf_init(struct ice_vf *vf);
 enum virtchnl_status_code ice_err_to_virt_err(int err);
 struct ice_port_info *ice_vf_get_port_info(struct ice_vf *vf);
--- a/drivers/net/ethernet/intel/ice/virt/queues.c
+++ b/drivers/net/ethernet/intel/ice/virt/queues.c
@@ -225,6 +225,24 @@ void ice_vf_ena_rxq_interrupt(struct ice
 }
 
 /**
+ * ice_vf_dis_rxq_interrupt - disable Rx queue interrupt via QINT_RQCTL
+ * @vsi: VSI of the VF to configure
+ * @q_idx: VF queue index used to determine the queue in the PF's space
+ */
+static void ice_vf_dis_rxq_interrupt(struct ice_vsi *vsi, u32 q_idx)
+{
+	struct ice_hw *hw = &vsi->back->hw;
+	u32 pfq = vsi->rxq_map[q_idx];
+	u32 reg;
+
+	reg = rd32(hw, QINT_RQCTL(pfq));
+	reg &= ~QINT_RQCTL_CAUSE_ENA_M;
+	wr32(hw, QINT_RQCTL(pfq), reg);
+
+	ice_flush(hw);
+}
+
+/**
  * ice_vc_ena_qs_msg
  * @vf: pointer to the VF info
  * @msg: pointer to the msg buffer
@@ -416,6 +434,8 @@ int ice_vc_dis_qs_msg(struct ice_vf *vf,
 			goto error_param;
 		}
 
+		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF)
+			ice_vf_dis_rxq_interrupt(vsi, vf_q_id);
 		bitmap_zero(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF);
 	} else if (q_map) {
 		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
@@ -436,6 +456,7 @@ int ice_vc_dis_qs_msg(struct ice_vf *vf,
 				goto error_param;
 			}
 
+			ice_vf_dis_rxq_interrupt(vsi, vf_q_id);
 			/* Clear enabled queues flag */
 			clear_bit(vf_q_id, vf->rxq_ena);
 		}


