Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36FA269826;
	Wed, 23 Apr 2025 14:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419989; cv=none; b=rhkWkNMIbrUYqHZaUc0AyVLxrl2V1QIqIW6OHQtuMD4SOzgVc+HAEuoQE95n2TjunKt844sbDC+UwHtu5g3GO3Dl/5+YV/LKpdNlhGv71uogsGD7KI4SMUjUeBgm0QYpBHrUrvNhVtTLx5sjexFaFtCuwya+D8ZA72U9ZG3MnYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419989; c=relaxed/simple;
	bh=CybWSsD8MGFCMrGHK7AWCZkqHzGmJpeiU4uKDg5Jbs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNuQAnMk62e/rqUAihdtTGgZ11nhROJ0J4uWPHyy3dnoeu9EMsjFcjqmgFGlbsMp9wZbUEcf4UlAcPYESBVSzL5cC1sAJXOLHccahp2uIpOVlSa2B0w2l1AvbEBIjdTS4eO3F3pCf2i+uUn3obWGBHijGU9jzP3ITzqbPmoy/rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsOC55TD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsOC55TD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37226C4CEE2;
	Wed, 23 Apr 2025 14:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419989;
	bh=CybWSsD8MGFCMrGHK7AWCZkqHzGmJpeiU4uKDg5Jbs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsOC55TDTNgC+o285YxW4ut//hwLOaoEM4WkdY+67YZhg0M6nVaH3JepyL36Lh/Qy
	 b7x0ba39fEpCXU0f3eBO6nP4vjqW8yjn4igCT/lc6NFEu5sA5O3+pNKCFbn54QAmkk
	 NO+PHkI7VZLMEGoeCCAVzhZZLSPp4qYJ1UJvDT+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/223] net: ti: icss-iep: Add pwidth configuration for perout signal
Date: Wed, 23 Apr 2025 16:42:21 +0200
Message-ID: <20250423142619.941993504@linuxfoundation.org>
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

[ Upstream commit e5b456a14215e3c0e84844c2926861b972e03632 ]

icss_iep_perout_enable_hw() is a common function for generating
both pps and perout signals. When enabling pps, the application needs
to only pass enable/disable argument, whereas for perout it supports
different flags to configure the signal.

But icss_iep_perout_enable_hw() function is missing to hook the
configuration params passed by the app, causing perout to behave
same a pps (except being able to configure the period). As duty cycle
is also one feature which can configured for perout, incorporate this
in the function to get the expected signal.

Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20250304105753.1552159-2-m-malladi@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7349c9e99793 ("net: ti: icss-iep: Fix possible NULL pointer dereference for perout request")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icss_iep.c | 47 ++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icss_iep.c b/drivers/net/ethernet/ti/icssg/icss_iep.c
index d59c1744840af..2981c19c48b18 100644
--- a/drivers/net/ethernet/ti/icssg/icss_iep.c
+++ b/drivers/net/ethernet/ti/icssg/icss_iep.c
@@ -406,9 +406,16 @@ static void icss_iep_update_to_next_boundary(struct icss_iep *iep, u64 start_ns)
 static int icss_iep_perout_enable_hw(struct icss_iep *iep,
 				     struct ptp_perout_request *req, int on)
 {
+	struct timespec64 ts;
+	u64 ns_width;
 	int ret;
 	u64 cmp;
 
+	/* Calculate width of the signal for PPS/PEROUT handling */
+	ts.tv_sec = req->on.sec;
+	ts.tv_nsec = req->on.nsec;
+	ns_width = timespec64_to_ns(&ts);
+
 	if (iep->ops && iep->ops->perout_enable) {
 		ret = iep->ops->perout_enable(iep->clockops_data, req, on, &cmp);
 		if (ret)
@@ -419,8 +426,9 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
 			regmap_write(iep->map, ICSS_IEP_CMP1_REG0, lower_32_bits(cmp));
 			if (iep->plat_data->flags & ICSS_IEP_64BIT_COUNTER_SUPPORT)
 				regmap_write(iep->map, ICSS_IEP_CMP1_REG1, upper_32_bits(cmp));
-			/* Configure SYNC, 1ms pulse width */
-			regmap_write(iep->map, ICSS_IEP_SYNC_PWIDTH_REG, 1000000);
+			/* Configure SYNC, based on req on width */
+			regmap_write(iep->map, ICSS_IEP_SYNC_PWIDTH_REG,
+				     div_u64(ns_width, iep->def_inc));
 			regmap_write(iep->map, ICSS_IEP_SYNC0_PERIOD_REG, 0);
 			regmap_write(iep->map, ICSS_IEP_SYNC_START_REG, 0);
 			regmap_write(iep->map, ICSS_IEP_SYNC_CTRL_REG, 0); /* one-shot mode */
@@ -447,6 +455,8 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
 				   + req->period.nsec;
 			icss_iep_update_to_next_boundary(iep, start_ns);
 
+			regmap_write(iep->map, ICSS_IEP_SYNC_PWIDTH_REG,
+				     div_u64(ns_width, iep->def_inc));
 			/* Enable Sync in single shot mode  */
 			regmap_write(iep->map, ICSS_IEP_SYNC_CTRL_REG,
 				     IEP_SYNC_CTRL_SYNC_N_EN(0) | IEP_SYNC_CTRL_SYNC_EN);
@@ -474,7 +484,36 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
 static int icss_iep_perout_enable(struct icss_iep *iep,
 				  struct ptp_perout_request *req, int on)
 {
-	return -EOPNOTSUPP;
+	int ret = 0;
+
+	/* Reject requests with unsupported flags */
+	if (req->flags & ~PTP_PEROUT_DUTY_CYCLE)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&iep->ptp_clk_mutex);
+
+	if (iep->pps_enabled) {
+		ret = -EBUSY;
+		goto exit;
+	}
+
+	if (iep->perout_enabled == !!on)
+		goto exit;
+
+	/* Set default "on" time (1ms) for the signal if not passed by the app */
+	if (!(req->flags & PTP_PEROUT_DUTY_CYCLE)) {
+		req->on.sec = 0;
+		req->on.nsec = NSEC_PER_MSEC;
+	}
+
+	ret = icss_iep_perout_enable_hw(iep, req, on);
+	if (!ret)
+		iep->perout_enabled = !!on;
+
+exit:
+	mutex_unlock(&iep->ptp_clk_mutex);
+
+	return ret;
 }
 
 static void icss_iep_cap_cmp_work(struct work_struct *work)
@@ -553,6 +592,8 @@ static int icss_iep_pps_enable(struct icss_iep *iep, int on)
 		rq.perout.period.nsec = 0;
 		rq.perout.start.sec = ts.tv_sec + 2;
 		rq.perout.start.nsec = 0;
+		rq.perout.on.sec = 0;
+		rq.perout.on.nsec = NSEC_PER_MSEC;
 		ret = icss_iep_perout_enable_hw(iep, &rq.perout, on);
 	} else {
 		ret = icss_iep_perout_enable_hw(iep, &rq.perout, on);
-- 
2.39.5



