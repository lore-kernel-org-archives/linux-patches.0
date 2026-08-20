Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C2C47F774;
	Thu, 20 Aug 2026 17:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248510; cv=none; b=SQCTCoG09JCCxwxeVZdS666gi7qDZZFvvZL0eaniwCoXV++X91JPnoPKen4auSCOS912Uuvn9o7yv/OTqzMEEDDhpaOJDONhEMSdg+FDALqVKEYZ77yZCOYkGoK2j0NvjtRrHoufjuJ7i8UAFxGhP01XzlQ5CCDVD/Z+8h5cpmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248510; c=relaxed/simple;
	bh=gPg1R6ttg/wH5aEbEQjt7LzYJTbYppsJGgPrhDgp4rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0dBG15Uu9aCwjkAgpOAYsBgVSSIUMVt21XTQBNNZhLmYtdF1IBprMHXyuRG0lE7lftSwRPKzXogR4mctby5aN4zaRRLJJbOSkUwr2W61kEwURHc157OPmk9qqEbPSYNJ2BoEY7+UEGsi1/hBdFDscaSvGypqCNSay7m9NvvuJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzrYOnV4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzrYOnV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABCB1F000E9;
	Thu, 20 Aug 2026 17:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248509;
	bh=3H8zyBnHdlWFDvY/XV54ddeEc9e9LqTPDnPmAZQ7/sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FzrYOnV4Pe+8x0fd2TP3Fm5b2yQ0yPrThUeRQYCiKMOI3u2LQCIuACpChc0z6+6Ok
	 k9o8nsrp/iztECg25RUeIhtjJxtdo5RVhr9EDuC3McaRAlTpTAZ4Fo4ezAVAwr3wKD
	 29g1VaYu7FxjJZgeW6c6rQzfgt2buXnPXv1az470=
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
Subject: [PATCH 6.1 252/303] ice: fix VF interrupts cleanup
Date: Thu, 20 Aug 2026 16:56:28 +0200
Message-ID: <20260820145301.023040435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ changed the file path for the `ice_vf_ena_rxq_interrupt` hunk from `ice/virt/queues.c` to `ice_virtchnl.c`, which predates the upstream directory split ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c         |   27 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_vf_lib_private.h |    1 
 drivers/net/ethernet/intel/ice/ice_virtchnl.c       |   21 +++++++++++++++
 3 files changed, 49 insertions(+)

--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -555,6 +555,30 @@ static void ice_notify_vf_reset(struct i
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
@@ -623,6 +647,9 @@ int ice_reset_vf(struct ice_vf *vf, u32
 
 	ice_dis_vf_qs(vf);
 
+	/* cleanup interrupt registers */
+	ice_reset_interrupts(vsi);
+
 	/* Call Disable LAN Tx queue AQ whether or not queues are
 	 * enabled. This is needed for successful completion of VFR.
 	 */
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
@@ -24,6 +24,7 @@
 #endif
 
 void ice_dis_vf_qs(struct ice_vf *vf);
+void ice_reset_interrupts(struct ice_vsi *vsi);
 int ice_check_vf_init(struct ice_vf *vf);
 struct ice_port_info *ice_vf_get_port_info(struct ice_vf *vf);
 int ice_vsi_apply_spoofchk(struct ice_vsi *vsi, bool enable);
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -1210,6 +1210,24 @@ static void ice_vf_ena_rxq_interrupt(str
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
@@ -1402,6 +1420,8 @@ static int ice_vc_dis_qs_msg(struct ice_
 			goto error_param;
 		}
 
+		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF)
+			ice_vf_dis_rxq_interrupt(vsi, vf_q_id);
 		bitmap_zero(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF);
 	} else if (q_map) {
 		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
@@ -1422,6 +1442,7 @@ static int ice_vc_dis_qs_msg(struct ice_
 				goto error_param;
 			}
 
+			ice_vf_dis_rxq_interrupt(vsi, vf_q_id);
 			/* Clear enabled queues flag */
 			clear_bit(vf_q_id, vf->rxq_ena);
 		}


