Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF3EC8EB;
	Wed, 23 Apr 2025 14:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419847; cv=none; b=mqVNEO4g+6jsgGfNA5q7bo3x4oXj1AL2bbWiJz2uoslP89YFTjTnvcTPZri+Ax3ynRAFR909h7Sib087LmiLIdWuqJU0YHj0CqnqKiQHf/AUPFojxxuu3Ur0PIzvgErWHkl4D5jk9kBM+J50/j7joGdZh/wo41p5S6qfhonbHSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419847; c=relaxed/simple;
	bh=pyXNyFGT5klYJceIG7XN6v5KVHPPeDYHzqs3XmqXnzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxnJKsIhBaPtbZYZPMCSkKuxXQ6/97d3kKqTdkWRotDob1cvpU/J7JloSfsc9Vs7UMduShM0rbgV4h+3PN5LthBguDCuTJvmQe2Inm7Rh7XWdVrQmd97KRGFrIBWEPt4CyuLAzvi3f3tWG9Mg6ghIOJZ7ZXRBswAXOpLffNEM1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCIttDzP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCIttDzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDEEC4CEE2;
	Wed, 23 Apr 2025 14:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419847;
	bh=pyXNyFGT5klYJceIG7XN6v5KVHPPeDYHzqs3XmqXnzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCIttDzPpxVA00VftavDFf9qsYWCQJtk6kjWgMUYrUEeVDMCN0mtcfqLjCV7affFh
	 Q6S2pky2PtO8W5Zr18NZ4jXsMTq3EocXrdTMjOl/PqkZh49NaYmk8T2IyiqHdS1iHJ
	 6mzJoIKEvVFGEpjgzM6y894cIjbBPzqoFPsNvUcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Meghana Malladi <m-malladi@ti.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/223] net: ti: icss-iep: Fix possible NULL pointer dereference for perout request
Date: Wed, 23 Apr 2025 16:42:23 +0200
Message-ID: <20250423142620.022949275@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meghana Malladi <m-malladi@ti.com>

[ Upstream commit 7349c9e9979333abfce42da5f9025598083b59c9 ]

The ICSS IEP driver tracks perout and pps enable state with flags.
Currently when disabling pps and perout signals during icss_iep_exit(),
results in NULL pointer dereference for perout.

To fix the null pointer dereference issue, the icss_iep_perout_enable_hw
function can be modified to directly clear the IEP CMP registers when
disabling PPS or PEROUT, without referencing the ptp_perout_request
structure, as its contents are irrelevant in this case.

Fixes: 9b115361248d ("net: ti: icssg-prueth: Fix clearing of IEP_CMP_CFG registers during iep_init")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/7b1c7c36-363a-4085-b26c-4f210bee1df6@stanley.mountain/
Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250415090543.717991-4-m-malladi@ti.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icss_iep.c | 121 +++++++++++------------
 1 file changed, 58 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icss_iep.c b/drivers/net/ethernet/ti/icssg/icss_iep.c
index b4a34c57b7b48..2a1c43316f462 100644
--- a/drivers/net/ethernet/ti/icssg/icss_iep.c
+++ b/drivers/net/ethernet/ti/icssg/icss_iep.c
@@ -412,6 +412,22 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
 	int ret;
 	u64 cmp;
 
+	if (!on) {
+		/* Disable CMP 1 */
+		regmap_update_bits(iep->map, ICSS_IEP_CMP_CFG_REG,
+				   IEP_CMP_CFG_CMP_EN(1), 0);
+
+		/* clear CMP regs */
+		regmap_write(iep->map, ICSS_IEP_CMP1_REG0, 0);
+		if (iep->plat_data->flags & ICSS_IEP_64BIT_COUNTER_SUPPORT)
+			regmap_write(iep->map, ICSS_IEP_CMP1_REG1, 0);
+
+		/* Disable sync */
+		regmap_write(iep->map, ICSS_IEP_SYNC_CTRL_REG, 0);
+
+		return 0;
+	}
+
 	/* Calculate width of the signal for PPS/PEROUT handling */
 	ts.tv_sec = req->on.sec;
 	ts.tv_nsec = req->on.nsec;
@@ -430,64 +446,39 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
 		if (ret)
 			return ret;
 
-		if (on) {
-			/* Configure CMP */
-			regmap_write(iep->map, ICSS_IEP_CMP1_REG0, lower_32_bits(cmp));
-			if (iep->plat_data->flags & ICSS_IEP_64BIT_COUNTER_SUPPORT)
-				regmap_write(iep->map, ICSS_IEP_CMP1_REG1, upper_32_bits(cmp));
-			/* Configure SYNC, based on req on width */
-			regmap_write(iep->map, ICSS_IEP_SYNC_PWIDTH_REG,
-				     div_u64(ns_width, iep->def_inc));
-			regmap_write(iep->map, ICSS_IEP_SYNC0_PERIOD_REG, 0);
-			regmap_write(iep->map, ICSS_IEP_SYNC_START_REG,
-				     div_u64(ns_start, iep->def_inc));
-			regmap_write(iep->map, ICSS_IEP_SYNC_CTRL_REG, 0); /* one-shot mode */
-			/* Enable CMP 1 */
-			regmap_update_bits(iep->map, ICSS_IEP_CMP_CFG_REG,
-					   IEP_CMP_CFG_CMP_EN(1), IEP_CMP_CFG_CMP_EN(1));
-		} else {
-			/* Disable CMP 1 */
-			regmap_update_bits(iep->map, ICSS_IEP_CMP_CFG_REG,
-					   IEP_CMP_CFG_CMP_EN(1), 0);
-
-			/* clear regs */
-			regmap_write(iep->map, ICSS_IEP_CMP1_REG0, 0);
-			if (iep->plat_data->flags & ICSS_IEP_64BIT_COUNTER_SUPPORT)
-				regmap_write(iep->map, ICSS_IEP_CMP1_REG1, 0);
-		}
+		/* Configure CMP */
+		regmap_write(iep->map, ICSS_IEP_CMP1_REG0, lower_32_bits(cmp));
+		if (iep->plat_data->flags & ICSS_IEP_64BIT_COUNTER_SUPPORT)
+			regmap_write(iep->map, ICSS_IEP_CMP1_REG1, upper_32_bits(cmp));
+		/* Configure SYNC, based on req on width */
+		regmap_write(iep->map, ICSS_IEP_SYNC_PWIDTH_REG,
+			     div_u64(ns_width, iep->def_inc));
+		regmap_write(iep->map, ICSS_IEP_SYNC0_PERIOD_REG, 0);
+		regmap_write(iep->map, ICSS_IEP_SYNC_START_REG,
+			     div_u64(ns_start, iep->def_inc));
+		regmap_write(iep->map, ICSS_IEP_SYNC_CTRL_REG, 0); /* one-shot mode */
+		/* Enable CMP 1 */
+		regmap_update_bits(iep->map, ICSS_IEP_CMP_CFG_REG,
+				   IEP_CMP_CFG_CMP_EN(1), IEP_CMP_CFG_CMP_EN(1));
 	} else {
-		if (on) {
-			u64 start_ns;
-
-			iep->period = ((u64)req->period.sec * NSEC_PER_SEC) +
-				      req->period.nsec;
-			start_ns = ((u64)req->period.sec * NSEC_PER_SEC)
-				   + req->period.nsec;
-			icss_iep_update_to_next_boundary(iep, start_ns);
-
-			regmap_write(iep->map, ICSS_IEP_SYNC_PWIDTH_REG,
-				     div_u64(ns_width, iep->def_inc));
-			regmap_write(iep->map, ICSS_IEP_SYNC_START_REG,
-				     div_u64(ns_start, iep->def_inc));
-			/* Enable Sync in single shot mode  */
-			regmap_write(iep->map, ICSS_IEP_SYNC_CTRL_REG,
-				     IEP_SYNC_CTRL_SYNC_N_EN(0) | IEP_SYNC_CTRL_SYNC_EN);
-			/* Enable CMP 1 */
-			regmap_update_bits(iep->map, ICSS_IEP_CMP_CFG_REG,
-					   IEP_CMP_CFG_CMP_EN(1), IEP_CMP_CFG_CMP_EN(1));
-		} else {
-			/* Disable CMP 1 */
-			regmap_update_bits(iep->map, ICSS_IEP_CMP_CFG_REG,
-					   IEP_CMP_CFG_CMP_EN(1), 0);
-
-			/* clear CMP regs */
-			regmap_write(iep->map, ICSS_IEP_CMP1_REG0, 0);
-			if (iep->plat_data->flags & ICSS_IEP_64BIT_COUNTER_SUPPORT)
-				regmap_write(iep->map, ICSS_IEP_CMP1_REG1, 0);
-
-			/* Disable sync */
-			regmap_write(iep->map, ICSS_IEP_SYNC_CTRL_REG, 0);
-		}
+		u64 start_ns;
+
+		iep->period = ((u64)req->period.sec * NSEC_PER_SEC) +
+				req->period.nsec;
+		start_ns = ((u64)req->period.sec * NSEC_PER_SEC)
+				+ req->period.nsec;
+		icss_iep_update_to_next_boundary(iep, start_ns);
+
+		regmap_write(iep->map, ICSS_IEP_SYNC_PWIDTH_REG,
+			     div_u64(ns_width, iep->def_inc));
+		regmap_write(iep->map, ICSS_IEP_SYNC_START_REG,
+			     div_u64(ns_start, iep->def_inc));
+		/* Enable Sync in single shot mode  */
+		regmap_write(iep->map, ICSS_IEP_SYNC_CTRL_REG,
+			     IEP_SYNC_CTRL_SYNC_N_EN(0) | IEP_SYNC_CTRL_SYNC_EN);
+		/* Enable CMP 1 */
+		regmap_update_bits(iep->map, ICSS_IEP_CMP_CFG_REG,
+				   IEP_CMP_CFG_CMP_EN(1), IEP_CMP_CFG_CMP_EN(1));
 	}
 
 	return 0;
@@ -498,11 +489,21 @@ static int icss_iep_perout_enable(struct icss_iep *iep,
 {
 	int ret = 0;
 
+	if (!on)
+		goto disable;
+
 	/* Reject requests with unsupported flags */
 	if (req->flags & ~(PTP_PEROUT_DUTY_CYCLE |
 			  PTP_PEROUT_PHASE))
 		return -EOPNOTSUPP;
 
+	/* Set default "on" time (1ms) for the signal if not passed by the app */
+	if (!(req->flags & PTP_PEROUT_DUTY_CYCLE)) {
+		req->on.sec = 0;
+		req->on.nsec = NSEC_PER_MSEC;
+	}
+
+disable:
 	mutex_lock(&iep->ptp_clk_mutex);
 
 	if (iep->pps_enabled) {
@@ -513,12 +514,6 @@ static int icss_iep_perout_enable(struct icss_iep *iep,
 	if (iep->perout_enabled == !!on)
 		goto exit;
 
-	/* Set default "on" time (1ms) for the signal if not passed by the app */
-	if (!(req->flags & PTP_PEROUT_DUTY_CYCLE)) {
-		req->on.sec = 0;
-		req->on.nsec = NSEC_PER_MSEC;
-	}
-
 	ret = icss_iep_perout_enable_hw(iep, req, on);
 	if (!ret)
 		iep->perout_enabled = !!on;
-- 
2.39.5



