Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52482820B1;
	Wed, 23 Apr 2025 15:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422167; cv=none; b=mSRK05CrxAKu64KoujCX1qpKXtLvdOnNtYS0SK6LtVW32X+DgroMHZGz6wqtq/gWaHCyMBhkk9/A435CeJM94q7NTyYuMq3yUBfjEpz87HywS0+xTya3BxKULdhoEJdY4wUEf41icnOJupd7jEs41SRXl88rA3w8aV8fyMPL5rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422167; c=relaxed/simple;
	bh=CZMfoO+JEZGu69ewiU2q3ld1oOQ7qGronSUoBvQvlxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a32YO7QbiQTSf0lRJ8lSlnVmitfZBinWlQLY0CIXz7ut8+xw5eASLriHMzcNEBOwOOyhqlfA3AntZtNyAmaOwEvbujaXmB/E2kWe/8csT6XybomI0ViwUYLTE1jVXYQrjTy4vc5RMPgmB+Zlx7KMJb26ZMm/YBgP/owu9rI4jlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPugYwJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPugYwJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369ADC4CEE2;
	Wed, 23 Apr 2025 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422167;
	bh=CZMfoO+JEZGu69ewiU2q3ld1oOQ7qGronSUoBvQvlxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPugYwJysLHjHPh258oTVAArdyZvBXGyVP+8AyFA+qebDzM9/LW0Uk0nfXbP8QPp3
	 wB/KN1ie+R9zN/k0Yn1JPrm89AgN8Tb0YT1hhWKh7xDzTbGby6i3zXOJUwZq89pvco
	 DEK3XKSb+2foM/LiGsvKSEGHt6uyFltGL5fwMmn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 290/393] net: ti: icss-iep: Add pwidth configuration for perout signal
Date: Wed, 23 Apr 2025 16:43:06 +0200
Message-ID: <20250423142655.319919768@linuxfoundation.org>
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
index 3f9a030471fe2..923ac58c9de5b 100644
--- a/drivers/net/ethernet/ti/icssg/icss_iep.c
+++ b/drivers/net/ethernet/ti/icssg/icss_iep.c
@@ -476,9 +476,16 @@ static void icss_iep_update_to_next_boundary(struct icss_iep *iep, u64 start_ns)
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
@@ -489,8 +496,9 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
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
@@ -517,6 +525,8 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
 				   + req->period.nsec;
 			icss_iep_update_to_next_boundary(iep, start_ns);
 
+			regmap_write(iep->map, ICSS_IEP_SYNC_PWIDTH_REG,
+				     div_u64(ns_width, iep->def_inc));
 			/* Enable Sync in single shot mode  */
 			regmap_write(iep->map, ICSS_IEP_SYNC_CTRL_REG,
 				     IEP_SYNC_CTRL_SYNC_N_EN(0) | IEP_SYNC_CTRL_SYNC_EN);
@@ -544,7 +554,36 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
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
 
 static int icss_iep_pps_enable(struct icss_iep *iep, int on)
@@ -572,6 +611,8 @@ static int icss_iep_pps_enable(struct icss_iep *iep, int on)
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



