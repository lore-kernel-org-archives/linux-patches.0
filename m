Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2A12857C4;
	Wed, 23 Apr 2025 14:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420340; cv=none; b=gyOSWRC8JrWwSHvURuxy8WgdXsjcTum2LiKnyX3oP2EkxKNoF1BcEf0sB1HzzJobSkRJ4xknuvi6ERM5Hhn3qaTCfY+uV0b6sM2YLtb7clulneKUjg9F0yBSNLMN4ZCySkD30Fy7o9IRhEIqIj0Bh5sslM088O1buGvmXZhQUPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420340; c=relaxed/simple;
	bh=2CIBfoAv/kjCBUefdUsCermQ1/hLpBvp2y+AU6oHP8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HA0UG+/aqlqaJj1K/b5Oq+I1fTu95srxM7L7IVfNSTR9EKXhg6EAT+vjNm0LfN7SvZP6bUujn1LZOkO1uhZ94yvCjjJZA94ApGWgIOBZUME0ZUQ/ICKNEzPKU1WN65kSq2OnOofjtpGzZu3aZ+hpeZDM4HbnpY+fcKlIfgj+9Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QiuR7yu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QiuR7yu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D04AC4CEE8;
	Wed, 23 Apr 2025 14:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420339;
	bh=2CIBfoAv/kjCBUefdUsCermQ1/hLpBvp2y+AU6oHP8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QiuR7yu62TpllbS6/Ln4We6eJpnqOKGayWqbwk0HnLObT7M/jaJvWd292zAktAvPp
	 51sASZ0pF8/aW6NvOZjB0hhyAx9gEe3pVMfA+TyqSno4uHN5ht0sUtuCbdpdAD9yXE
	 z3fYVvha6RDYL/PK0v9okd7Ta13l+ipZOldJZx5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Meghana Malladi <m-malladi@ti.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 083/241] net: ti: icss-iep: Fix possible NULL pointer dereference for perout request
Date: Wed, 23 Apr 2025 16:42:27 +0200
Message-ID: <20250423142623.972358043@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



