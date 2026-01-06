Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4259D34AB03;
	Tue,  6 Jan 2026 17:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721437; cv=none; b=OZb6LdtWO5EMP2LjX4zVQQeWFSE0UoTUFMby/YquRerXlXOx3lWDZDcuYOvLvr5+HnamMB15tVhYk96HnLKatsVMXHxFpw6j7WMMjulSVgUTIeVFqC91JYZv8PyKTgDKEI7XP4yhe2b+Q1652FgG/gaijNLD2Q3aJsSq1UT0dPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721437; c=relaxed/simple;
	bh=W4cqYthHfpg6NSP7U6zyaUs/NAYa9LGydY4bkHwFyLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAetfhU1d7JgeH141ZoOcdlkUq5/pEi9sf/u0fnD8jbFTD50woy3yUtdGFaFTHvxSwUggzqjqkY/EFcqkBxZIhYSMzzQTyxgOQizGQoHbK1oWIpWAdTQZ568YL4Wnb4RKQRulngSYs98GRoQx7WqVBGCWRngexSAy2+Z0mDhP3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gorxdpen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gorxdpen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7061C16AAE;
	Tue,  6 Jan 2026 17:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721437;
	bh=W4cqYthHfpg6NSP7U6zyaUs/NAYa9LGydY4bkHwFyLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gorxdpenRHV3w/Nt2NBY3Y+cVbN8Ne1FHlUX3kcSUmanSiC0zQt2PmPl8JsgI3Lgq
	 kP//An6kdxt09FTmxSLBY8O1f8mRIkq3PfI8X5xzx80WU1pGD+w/m8ChDT88VpEv3i
	 PXFb88/qX7+9L6tYN0JTWNbYkuSgYJJeIWbYy1PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhu Chittim <madhu.chittim@intel.com>,
	Joshua Hay <joshua.a.hay@intel.com>,
	Krishneil Singh <krishneil.k.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.12 537/567] idpf: add support for SW triggered interrupts
Date: Tue,  6 Jan 2026 18:05:19 +0100
Message-ID: <20260106170511.267328700@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Hay <joshua.a.hay@intel.com>

[ Upstream commit 93433c1d919775f8ac0f7893692f42e6731a5373 ]

SW triggered interrupts are guaranteed to fire after their timer
expires, unlike Tx and Rx interrupts which will only fire after the
timer expires _and_ a descriptor write back is available to be processed
by the driver.

Add the necessary fields, defines, and initializations to enable a SW
triggered interrupt in the vector's dyn_ctl register.

Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/idpf/idpf_dev.c    |    3 +++
 drivers/net/ethernet/intel/idpf/idpf_txrx.h   |    8 +++++++-
 drivers/net/ethernet/intel/idpf/idpf_vf_dev.c |    3 +++
 3 files changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/idpf/idpf_dev.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_dev.c
@@ -101,6 +101,9 @@ static int idpf_intr_reg_init(struct idp
 		intr->dyn_ctl_itridx_s = PF_GLINT_DYN_CTL_ITR_INDX_S;
 		intr->dyn_ctl_intrvl_s = PF_GLINT_DYN_CTL_INTERVAL_S;
 		intr->dyn_ctl_wb_on_itr_m = PF_GLINT_DYN_CTL_WB_ON_ITR_M;
+		intr->dyn_ctl_swint_trig_m = PF_GLINT_DYN_CTL_SWINT_TRIG_M;
+		intr->dyn_ctl_sw_itridx_ena_m =
+			PF_GLINT_DYN_CTL_SW_ITR_INDX_ENA_M;
 
 		spacing = IDPF_ITR_IDX_SPACING(reg_vals[vec_id].itrn_index_spacing,
 					       IDPF_PF_ITR_IDX_SPACING);
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -354,6 +354,8 @@ struct idpf_vec_regs {
  * @dyn_ctl_itridx_m: Mask for ITR index
  * @dyn_ctl_intrvl_s: Register bit offset for ITR interval
  * @dyn_ctl_wb_on_itr_m: Mask for WB on ITR feature
+ * @dyn_ctl_sw_itridx_ena_m: Mask for SW ITR index
+ * @dyn_ctl_swint_trig_m: Mask for dyn_ctl SW triggered interrupt enable
  * @rx_itr: RX ITR register
  * @tx_itr: TX ITR register
  * @icr_ena: Interrupt cause register offset
@@ -367,6 +369,8 @@ struct idpf_intr_reg {
 	u32 dyn_ctl_itridx_m;
 	u32 dyn_ctl_intrvl_s;
 	u32 dyn_ctl_wb_on_itr_m;
+	u32 dyn_ctl_sw_itridx_ena_m;
+	u32 dyn_ctl_swint_trig_m;
 	void __iomem *rx_itr;
 	void __iomem *tx_itr;
 	void __iomem *icr_ena;
@@ -437,7 +441,7 @@ struct idpf_q_vector {
 	cpumask_var_t affinity_mask;
 	__cacheline_group_end_aligned(cold);
 };
-libeth_cacheline_set_assert(struct idpf_q_vector, 112,
+libeth_cacheline_set_assert(struct idpf_q_vector, 120,
 			    24 + sizeof(struct napi_struct) +
 			    2 * sizeof(struct dim),
 			    8 + sizeof(cpumask_var_t));
@@ -471,6 +475,8 @@ struct idpf_tx_queue_stats {
 #define IDPF_ITR_IS_DYNAMIC(itr_mode) (itr_mode)
 #define IDPF_ITR_TX_DEF		IDPF_ITR_20K
 #define IDPF_ITR_RX_DEF		IDPF_ITR_20K
+/* Index used for 'SW ITR' update in DYN_CTL register */
+#define IDPF_SW_ITR_UPDATE_IDX	2
 /* Index used for 'No ITR' update in DYN_CTL register */
 #define IDPF_NO_ITR_UPDATE_IDX	3
 #define IDPF_ITR_IDX_SPACING(spacing, dflt)	(spacing ? spacing : dflt)
--- a/drivers/net/ethernet/intel/idpf/idpf_vf_dev.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_vf_dev.c
@@ -101,6 +101,9 @@ static int idpf_vf_intr_reg_init(struct
 		intr->dyn_ctl_itridx_s = VF_INT_DYN_CTLN_ITR_INDX_S;
 		intr->dyn_ctl_intrvl_s = VF_INT_DYN_CTLN_INTERVAL_S;
 		intr->dyn_ctl_wb_on_itr_m = VF_INT_DYN_CTLN_WB_ON_ITR_M;
+		intr->dyn_ctl_swint_trig_m = VF_INT_DYN_CTLN_SWINT_TRIG_M;
+		intr->dyn_ctl_sw_itridx_ena_m =
+			VF_INT_DYN_CTLN_SW_ITR_INDX_ENA_M;
 
 		spacing = IDPF_ITR_IDX_SPACING(reg_vals[vec_id].itrn_index_spacing,
 					       IDPF_VF_ITR_IDX_SPACING);


