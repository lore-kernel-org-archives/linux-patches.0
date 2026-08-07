Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1843806B0;
	Fri,  7 Aug 2026 15:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114949; cv=none; b=lFyE+w6TRtJCF2r0crFn4lWJg8/JxJC4u7vBqcG+/WOXmPvyJ/Yfa1Uep6NjWTQMkiUfeIvdkzlGkG3FR7EBQRi5i5E2IpiEmpOpx1nFz5lR8OT6r7CXy2/wFs/e3Br4PFy7y7KKjeWkwdPkBxhvzj5dOPFpFoEMtGwfhJdfcnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114949; c=relaxed/simple;
	bh=La6fovS4iWnlsXFcsEybuDTJpfLdwI7R8X1pBsTbEic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y76TOsalEPfU6wYK3rvqxPT2JSxu/kLg/8MnMyKXp6OI0WQKRSGePtOkb9nrCVQHzmAx3OO1+nHi65/HCM6rv7iGhwbGTHXHfJ++IALMSmtQMzVgSH4RQaSGLUVrhpmA34QPnv5Mb+ngV9qhO/uthw+/YQAZk/M9ma49zx/g1dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sl5FbRD/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sl5FbRD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DD81F000E9;
	Fri,  7 Aug 2026 15:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114948;
	bh=AzhGxd3K8F2Tax+YB1KcosTwnFm/Vi5szyprDFgD8gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sl5FbRD/CXrh82wz3hEaexPnYBCUBPt7opZ298b29P3aTEYHtvaZ9G8/xeaRkuqle
	 hnL9gd5BpH29H0Z5y4qh4BNpb43P+7yQdCVKorw+ItdJTSoM08Le7Kq5e5z3u0JVQU
	 aBuRBCebpTfmGtWX030OKPLhghti75OG954S57ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemyslaw Korba <przemyslaw.korba@intel.com>,
	Simon Horman <horms@kernel.org>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.18 105/396] ice: suppress DPLL errors during reset recovery
Date: Fri,  7 Aug 2026 16:34:25 +0200
Message-ID: <20260807143426.558340340@linuxfoundation.org>
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

From: Przemyslaw Korba <przemyslaw.korba@intel.com>

[ Upstream commit b00be7c6b4bd7da3d510753b27ff6cb7ec647d07 ]

During reset recovery, the admin queue returns EBUSY which is expected
behavior. However, the DPLL subsystem was logging these as errors and
incrementing the error counter, potentially leading to unnecessary
warnings and even disabling the DPLL periodic worker if the threshold
was reached.

Suppress error logging and error counter increments when the admin
queue returns EBUSY, as this is expected during reset recovery and
not a real failure condition.

test case:
- ethtool --reset eth3 irq-shared dma-shared filter-shared offload-shared
mac-shared phy-shared ram-shared
- observe if dmesg EBUSY errors are gone

Fixes: d7999f5ea64b ("ice: implement dpll interface to control cgu")
Signed-off-by: Przemyslaw Korba <przemyslaw.korba@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index 023d0de12670c..2a47d9f3cf7ef 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -703,7 +703,7 @@ ice_dpll_pin_state_update(struct ice_pf *pf, struct ice_dpll_pin *pin,
 				   ret,
 				   libie_aq_str(pf->hw.adminq.sq_last_status),
 				   pin_type_name[pin_type], pin->idx);
-	else
+	else if (pf->hw.adminq.sq_last_status != LIBIE_AQ_RC_EBUSY)
 		dev_err_ratelimited(ice_pf_to_dev(pf),
 				    "err:%d %s failed to update %s pin:%u\n",
 				    ret,
@@ -2669,7 +2669,8 @@ static int ice_dpll_pps_update_phase_offsets(struct ice_pf *pf,
 	*phase_offset_pins_updated = 0;
 	ret = ice_aq_get_cgu_input_pin_measure(&pf->hw, DPLL_TYPE_PPS, meas,
 					       ARRAY_SIZE(meas));
-	if (ret && pf->hw.adminq.sq_last_status == LIBIE_AQ_RC_EAGAIN) {
+	if (ret && (pf->hw.adminq.sq_last_status == LIBIE_AQ_RC_EAGAIN ||
+		    pf->hw.adminq.sq_last_status == LIBIE_AQ_RC_EBUSY)) {
 		return 0;
 	} else if (ret) {
 		dev_err(ice_pf_to_dev(pf),
@@ -2731,10 +2732,12 @@ ice_dpll_update_state(struct ice_pf *pf, struct ice_dpll *d, bool init)
 		d->dpll_idx, d->prev_input_idx, d->input_idx,
 		d->dpll_state, d->prev_dpll_state, d->mode);
 	if (ret) {
-		dev_err(ice_pf_to_dev(pf),
-			"update dpll=%d state failed, ret=%d %s\n",
-			d->dpll_idx, ret,
-			libie_aq_str(pf->hw.adminq.sq_last_status));
+		/* EBUSY is expected during reset recovery, don't log error */
+		if (pf->hw.adminq.sq_last_status != LIBIE_AQ_RC_EBUSY)
+			dev_err(ice_pf_to_dev(pf),
+				"update dpll=%d state failed, ret=%d %s\n",
+				d->dpll_idx, ret,
+				libie_aq_str(pf->hw.adminq.sq_last_status));
 		return ret;
 	}
 	if (init) {
@@ -2803,7 +2806,9 @@ static void ice_dpll_periodic_work(struct kthread_work *work)
 	    d->periodic_counter % dp->phase_offset_monitor_period == 0)
 		ret = ice_dpll_pps_update_phase_offsets(pf, &phase_offset_ntf);
 	if (ret) {
-		d->cgu_state_acq_err_num++;
+		/* EBUSY is expected during reset recovery */
+		if (pf->hw.adminq.sq_last_status != LIBIE_AQ_RC_EBUSY)
+			d->cgu_state_acq_err_num++;
 		/* stop rescheduling this worker */
 		if (d->cgu_state_acq_err_num >
 		    ICE_CGU_STATE_ACQ_ERR_THRESHOLD) {
-- 
2.53.0



