Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF3028A3F8;
	Wed, 23 Apr 2025 15:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422180; cv=none; b=C8duzY1/GCwd78IDbazgga8UgCmzPACpTzdRcMztkDiTtm7y7RYqEejLzNIb1LwiMV1cvkNFGjxbQtFJLC8ww3RL8M4Zn9gHdy//437poR08YuG9fJmtY6xrlUgB48jRRm0CoWZSZpPalW02xTh8I+BizLDTY2EvZ8Ge78hYL+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422180; c=relaxed/simple;
	bh=dHjKLAQubEuKUugmg2Gf3/n/7uIdasrwi7BBhM25rnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAtxeeATvWCgWZjMy7439nUN7MkQcg192o2TnGV4XQwZdieXVnyLFNZtXm08Te6hADKEqa8mbLpv4MEV9FGzJRUK7G9uryKnl8t4oEWFZ95ubHd4jJ68WCU/it6Dor5fvN4Wpc5p9tIqHk3+/ex2cSFwtJ1Li8xQJ6Rw6mei/II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsVavvmk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsVavvmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27789C4CEE2;
	Wed, 23 Apr 2025 15:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422180;
	bh=dHjKLAQubEuKUugmg2Gf3/n/7uIdasrwi7BBhM25rnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsVavvmk3d4UaZxRM43aEaM6n+2A1tUGsmNRCcO6FznG3G6ryM54q5c4JK4q4NTjb
	 qUNueZXau3YvFdZwMmaHtGg6Vl1NSFwnTAd6/wWSVIfBRgQbYHzF3K9z8lXrqMWPhX
	 kZNcIm/KstdpItaMLPVcd9SLB1Ov5IB//tDmdK4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Meghana Malladi <m-malladi@ti.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 292/393] net: ti: icss-iep: Fix possible NULL pointer dereference for perout request
Date: Wed, 23 Apr 2025 16:43:08 +0200
Message-ID: <20250423142655.401810933@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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
index 6006276ecce6f..f3315c6515156 100644
--- a/drivers/net/ethernet/ti/icssg/icss_iep.c
+++ b/drivers/net/ethernet/ti/icssg/icss_iep.c
@@ -482,6 +482,22 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
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
@@ -500,64 +516,39 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
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
@@ -568,11 +559,21 @@ static int icss_iep_perout_enable(struct icss_iep *iep,
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
@@ -583,12 +584,6 @@ static int icss_iep_perout_enable(struct icss_iep *iep,
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



