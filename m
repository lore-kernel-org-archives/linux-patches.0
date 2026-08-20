Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A091272E53;
	Thu, 20 Aug 2026 16:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243847; cv=none; b=mJebvAssKef1e5inFU0XMCvqymxqedqARHhyZTJJIQxSrp1e/7t66dwBBxB/oN0LGZaZr0lcvY78VB6efTWR9b/SpTCqF5QbiU0ks+lVJjUK5iVcvN/oG4K6JkOuzcwRf93jxtr6DjujU1LE58Eah4oIvo7Wb8a+eACmOIMZZeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243847; c=relaxed/simple;
	bh=18dSHsJNazWOWpGENGwPsOdlz8YenfQOtnD6/PDrBC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGCDwG2VeVVwsVp/jxMCX9L4ciyh4Q5plVcjzcd7657R0HiTmErYjUDyIt5PL/kwzwuzrW+HjjhdKPbg5XOcs57YlYWHfMLJR0GKZCYHsCtxSpC7c6Ie4tHhZHBj44H4JT6qgQA6TKsJdeB+1ze8jktNUC9GdKxMQXLbZ7uKyh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ko01G4Vu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ko01G4Vu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B999F1F000E9;
	Thu, 20 Aug 2026 16:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243846;
	bh=84eqVCFFlkoBB8Lv2InvoHHuvfSjhbgODEEafAj6r/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ko01G4Vux337w2ypd1JS+v8uSuGrj2kvdcqBTofA8lFuRuBQA1fuh9Ns5Tl0r4RdK
	 7FxXBY9dSo+Ad1LmhCGwBChBq7qBogJLR5rS5uH3lbSJxXo2CiOWFwbOa07vOUqYQN
	 ykZxMasLQBBopY5py58oDOVBDY1zkONsl44Unsr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Medvedkin <vladimir.medvedkin@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Patryk Holda <patryk.holda@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 235/272] ice: fix VF interrupts cleanup
Date: Thu, 20 Aug 2026 16:56:59 +0200
Message-ID: <20260820145238.665461858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>

[ Upstream commit fb096882095e5a8d6b5159e43793d4a38a0c5b1f ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c |   48 +++++++++++++++++++++++
 1 file changed, 48 insertions(+)

--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1588,6 +1588,30 @@ static bool ice_is_vf_disabled(struct ic
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
+static void ice_reset_interrupts(struct ice_vsi *vsi)
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
  * @is_vflr: true if VFLR was issued, false if not
@@ -1630,6 +1654,9 @@ bool ice_reset_vf(struct ice_vf *vf, boo
 
 	ice_dis_vf_qs(vf);
 
+	/* cleanup interrupt registers */
+	ice_reset_interrupts(vsi);
+
 	/* Call Disable LAN Tx queue AQ whether or not queues are
 	 * enabled. This is needed for successful completion of VFR.
 	 */
@@ -3168,6 +3195,24 @@ static void ice_vf_ena_rxq_interrupt(str
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
@@ -3336,6 +3381,8 @@ static int ice_vc_dis_qs_msg(struct ice_
 			goto error_param;
 		}
 
+		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF)
+			ice_vf_dis_rxq_interrupt(vsi, vf_q_id);
 		bitmap_zero(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF);
 	} else if (q_map) {
 		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
@@ -3356,6 +3403,7 @@ static int ice_vc_dis_qs_msg(struct ice_
 				goto error_param;
 			}
 
+			ice_vf_dis_rxq_interrupt(vsi, vf_q_id);
 			/* Clear enabled queues flag */
 			clear_bit(vf_q_id, vf->rxq_ena);
 		}


