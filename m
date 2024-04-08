Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C55D7FBB0;
	Mon,  8 Apr 2024 13:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582866; cv=none; b=Xj2lKAwcVZTIPjByU5InlL+P5xUb6rYtn5tIjx0ckj3TABG/e1C6K1HhV4/ALh4g50LqVF9R47QTLwYzz6rKq8TqFFUKAPXnf4jNfp/SnVKCGcXCbCDvuOYsKYfGIK62lDdY1XPOAw907q8VROfcjsSHe9FpnsN+he4QUjiELYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582866; c=relaxed/simple;
	bh=bU4Knkmyx1swVDwsO8OzOwSscjaPQO3NXHUzh3iqNu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snonGe+1KMIzoTBJkANmMGMdrAFog1GudmyhlWb4uI6LhU4VZ8n/wWhAcKLC+nEjBfUrEI1LYw0/3Psgc8EW3czSq8ADCeJs3o4DWWjtW0Xirt7cK1hNsC11SMx3/Cx8mF4STYm8Nr5LG3PEuVdxV1FDbtKEW1zcItSbYJVqmro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYe4ixcx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYe4ixcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD29FC433F1;
	Mon,  8 Apr 2024 13:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582866;
	bh=bU4Knkmyx1swVDwsO8OzOwSscjaPQO3NXHUzh3iqNu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iYe4ixcx4LugTY3N3+sVIzws3ZIi5HP76pTv8cUz8QnGA29pDGsKPqFFOOCYcu6Vd
	 CLDVrK4qVMvQ0T1jLrG8/TNaUJkaE1W93Dqen673GA+klWFKzBPtwTUtaAQPttY+D/
	 uW/6JIz8s1asc1HcD0aAfMzmHxHu24fQ3dLpMAQg=
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
Subject: [PATCH 6.6 130/252] i40e: fix vf may be used uninitialized in this function warning
Date: Mon,  8 Apr 2024 14:57:09 +0200
Message-ID: <20240408125310.666048534@linuxfoundation.org>
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
@@ -1628,8 +1628,8 @@ bool i40e_reset_all_vfs(struct i40e_pf *
 {
 	struct i40e_hw *hw = &pf->hw;
 	struct i40e_vf *vf;
-	int i, v;
 	u32 reg;
+	int i;
 
 	/* If we don't have any VFs, then there is nothing to reset */
 	if (!pf->num_alloc_vfs)
@@ -1640,11 +1640,10 @@ bool i40e_reset_all_vfs(struct i40e_pf *
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
@@ -1653,14 +1652,13 @@ bool i40e_reset_all_vfs(struct i40e_pf *
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
@@ -1670,7 +1668,7 @@ bool i40e_reset_all_vfs(struct i40e_pf *
 			/* If the current VF has finished resetting, move on
 			 * to the next VF in sequence.
 			 */
-			v++;
+			++vf;
 		}
 	}
 
@@ -1680,39 +1678,39 @@ bool i40e_reset_all_vfs(struct i40e_pf *
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
@@ -1721,12 +1719,12 @@ bool i40e_reset_all_vfs(struct i40e_pf *
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


