Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FF47F47C;
	Mon,  8 Apr 2024 14:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585075; cv=none; b=BMfFh5mdF1qG9Vml+Y75razmqq6omUzluvB+u6S3o2Erx3MDnQnyWj8GbWpoLEObPyKXhs9RX4Ht3oR7g6HWgJ7+MiCb5IMW4L9Zw0MhRaYe7zSNism8tDbdCgbBgL0F4HhGAuq+ioovPQUo/tXT30LL2Jvm6l3df6EESxYXDrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585075; c=relaxed/simple;
	bh=rCPytSHaON4jfLYCFehFYxBfpHjK7THyRs1cRcl7FTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pdcl56hxEllbi6OQk/RKmFA77ymXwg2Wvz982J34P9MY1j2mIgMQSVOcJSFcJL5Ost9lPYGbETWj+vlMtTfK1Dnzoo2wMqY31juHR71hxoiyUSF9nqM2CUIr+oAhNR7SSjicVKiwxMXdXh2pU04c9BP+dmLqy8JnME0RZQ6lNoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIEuU44z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIEuU44z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2950C433C7;
	Mon,  8 Apr 2024 14:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585075;
	bh=rCPytSHaON4jfLYCFehFYxBfpHjK7THyRs1cRcl7FTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIEuU44zP9JK6WNUYjJh0vXnlCtTr378jV8XIS31TIHrrRYW/hH2sI6x0w00vuot/
	 imOdTchU13UoE3j+CPbE9MQ+KjyAc55yPqTABOgTEWjgfNM3jhgQgL8CGSRvtiEL2e
	 Irt85+rpjAQxf/sVTomI3USi0XYT7n35eTWNCu10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 655/690] i40e: fix vf may be used uninitialized in this function warning
Date: Mon,  8 Apr 2024 14:58:41 +0200
Message-ID: <20240408125423.384369144@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

commit f37c4eac99c258111d414d31b740437e1925b8e8 upstream.

To fix the regression introduced by commit 52424f974bc5, which causes
servers hang in very hard to reproduce conditions with resets races.
Using two sources for the information is the root cause.
In this function before the fix bumping v didn't mean bumping vf
pointer. But the code used this variables interchangeably, so stale vf
could point to different/not intended vf.

Remove redundant "v" variable and iterate via single VF pointer across
whole function instead to guarantee VF pointer validity.

Fixes: 52424f974bc5 ("i40e: Fix VF hang when reset is triggered on another VF")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   34 +++++++++------------
 1 file changed, 16 insertions(+), 18 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1626,8 +1626,8 @@ bool i40e_reset_all_vfs(struct i40e_pf *
 {
 	struct i40e_hw *hw = &pf->hw;
 	struct i40e_vf *vf;
-	int i, v;
 	u32 reg;
+	int i;
 
 	/* If we don't have any VFs, then there is nothing to reset */
 	if (!pf->num_alloc_vfs)
@@ -1638,11 +1638,10 @@ bool i40e_reset_all_vfs(struct i40e_pf *
 		return false;
 
 	/* Begin reset on all VFs at once */
-	for (v = 0; v < pf->num_alloc_vfs; v++) {
-		vf = &pf->vf[v];
+	for (vf = &pf->vf[0]; vf < &pf->vf[pf->num_alloc_vfs]; ++vf) {
 		/* If VF is being reset no need to trigger reset again */
 		if (!test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
-			i40e_trigger_vf_reset(&pf->vf[v], flr);
+			i40e_trigger_vf_reset(vf, flr);
 	}
 
 	/* HW requires some time to make sure it can flush the FIFO for a VF
@@ -1651,14 +1650,13 @@ bool i40e_reset_all_vfs(struct i40e_pf *
 	 * the VFs using a simple iterator that increments once that VF has
 	 * finished resetting.
 	 */
-	for (i = 0, v = 0; i < 10 && v < pf->num_alloc_vfs; i++) {
+	for (i = 0, vf = &pf->vf[0]; i < 10 && vf < &pf->vf[pf->num_alloc_vfs]; ++i) {
 		usleep_range(10000, 20000);
 
 		/* Check each VF in sequence, beginning with the VF to fail
 		 * the previous check.
 		 */
-		while (v < pf->num_alloc_vfs) {
-			vf = &pf->vf[v];
+		while (vf < &pf->vf[pf->num_alloc_vfs]) {
 			if (!test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states)) {
 				reg = rd32(hw, I40E_VPGEN_VFRSTAT(vf->vf_id));
 				if (!(reg & I40E_VPGEN_VFRSTAT_VFRD_MASK))
@@ -1668,7 +1666,7 @@ bool i40e_reset_all_vfs(struct i40e_pf *
 			/* If the current VF has finished resetting, move on
 			 * to the next VF in sequence.
 			 */
-			v++;
+			++vf;
 		}
 	}
 
@@ -1678,39 +1676,39 @@ bool i40e_reset_all_vfs(struct i40e_pf *
 	/* Display a warning if at least one VF didn't manage to reset in
 	 * time, but continue on with the operation.
 	 */
-	if (v < pf->num_alloc_vfs)
+	if (vf < &pf->vf[pf->num_alloc_vfs])
 		dev_err(&pf->pdev->dev, "VF reset check timeout on VF %d\n",
-			pf->vf[v].vf_id);
+			vf->vf_id);
 	usleep_range(10000, 20000);
 
 	/* Begin disabling all the rings associated with VFs, but do not wait
 	 * between each VF.
 	 */
-	for (v = 0; v < pf->num_alloc_vfs; v++) {
+	for (vf = &pf->vf[0]; vf < &pf->vf[pf->num_alloc_vfs]; ++vf) {
 		/* On initial reset, we don't have any queues to disable */
-		if (pf->vf[v].lan_vsi_idx == 0)
+		if (vf->lan_vsi_idx == 0)
 			continue;
 
 		/* If VF is reset in another thread just continue */
 		if (test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
 			continue;
 
-		i40e_vsi_stop_rings_no_wait(pf->vsi[pf->vf[v].lan_vsi_idx]);
+		i40e_vsi_stop_rings_no_wait(pf->vsi[vf->lan_vsi_idx]);
 	}
 
 	/* Now that we've notified HW to disable all of the VF rings, wait
 	 * until they finish.
 	 */
-	for (v = 0; v < pf->num_alloc_vfs; v++) {
+	for (vf = &pf->vf[0]; vf < &pf->vf[pf->num_alloc_vfs]; ++vf) {
 		/* On initial reset, we don't have any queues to disable */
-		if (pf->vf[v].lan_vsi_idx == 0)
+		if (vf->lan_vsi_idx == 0)
 			continue;
 
 		/* If VF is reset in another thread just continue */
 		if (test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
 			continue;
 
-		i40e_vsi_wait_queues_disabled(pf->vsi[pf->vf[v].lan_vsi_idx]);
+		i40e_vsi_wait_queues_disabled(pf->vsi[vf->lan_vsi_idx]);
 	}
 
 	/* Hw may need up to 50ms to finish disabling the RX queues. We
@@ -1719,12 +1717,12 @@ bool i40e_reset_all_vfs(struct i40e_pf *
 	mdelay(50);
 
 	/* Finish the reset on each VF */
-	for (v = 0; v < pf->num_alloc_vfs; v++) {
+	for (vf = &pf->vf[0]; vf < &pf->vf[pf->num_alloc_vfs]; ++vf) {
 		/* If VF is reset in another thread just continue */
 		if (test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
 			continue;
 
-		i40e_cleanup_reset_vf(&pf->vf[v]);
+		i40e_cleanup_reset_vf(vf);
 	}
 
 	i40e_flush(hw);


