Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F5E2820DC;
	Wed, 23 Apr 2025 15:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422172; cv=none; b=TXogrDsbwP3yWL3GXEsHLbsVcaWrNgUhDh7M3t5K77j53z5MW7iExiowLxR9/96lsgyBkwhOmilWC+53x4AzM0nVNumPaLMM4c73WGofm+JCal8H7rSwZOORefh6PIdP3qdDWgzkEyIp1Tjse+zrNEycrxGgZNLceJzB4FiTmu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422172; c=relaxed/simple;
	bh=Rwr1+ya7mlQxTaZ2QK62OYCWvyzUCCY2yFFbGVN0Ir4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DP+IQ8o4WGrqZzpCFHR35dTzMnVh0LgNLcCvyv/WRXtn+gKUuNXTG0VBUsp0zVd7goC1HHxuh/0fzQikUya+ykXwdWeDEwk2Asb7dXWoqVT5HcwZf8SZ18meWgKgzafP57U+FA2SENjrm2z9/WA4bTPXhKe6wOGYFSd/ls/XA3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNWj3Ldb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNWj3Ldb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6785BC4CEE2;
	Wed, 23 Apr 2025 15:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422172;
	bh=Rwr1+ya7mlQxTaZ2QK62OYCWvyzUCCY2yFFbGVN0Ir4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNWj3LdbqY0ZTaj83NkmVm5Onv2OYWfOi8BqCMMprFsbJQ9eCsmcLMyMp2lauHdk/
	 Bolt9PrmLNg7SkG4EamwBB4p+iTZ3FYXdIz0rURhQMt6QvW4qIyibDIH9c0QIlafK/
	 wTP7jvDV82+WsBwNSpZqWyYJtIusSF2slTXFjB6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 291/393] net: ti: icss-iep: Add phase offset configuration for perout signal
Date: Wed, 23 Apr 2025 16:43:07 +0200
Message-ID: <20250423142655.361510236@linuxfoundation.org>
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

[ Upstream commit 220cb1be647a7ca4e60241405c66f8f612c9b046 ]

icss_iep_perout_enable_hw() is a common function for generating
both pps and perout signals. When enabling pps, the application needs
to only pass enable/disable argument, whereas for perout it supports
different flags to configure the signal.

In case the app passes a valid phase offset value, the signal should
start toggling after that phase offset, else start immediately or
as soon as possible. ICSS_IEP_SYNC_START_REG register take number of
clock cycles to wait before starting the signal after activation time.
Set appropriate value to this register to support phase offset.

Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20250304105753.1552159-3-m-malladi@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7349c9e99793 ("net: ti: icss-iep: Fix possible NULL pointer dereference for perout request")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icss_iep.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icss_iep.c b/drivers/net/ethernet/ti/icssg/icss_iep.c
index 923ac58c9de5b..6006276ecce6f 100644
--- a/drivers/net/ethernet/ti/icssg/icss_iep.c
+++ b/drivers/net/ethernet/ti/icssg/icss_iep.c
@@ -477,6 +477,7 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
 				     struct ptp_perout_request *req, int on)
 {
 	struct timespec64 ts;
+	u64 ns_start;
 	u64 ns_width;
 	int ret;
 	u64 cmp;
@@ -486,6 +487,14 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
 	ts.tv_nsec = req->on.nsec;
 	ns_width = timespec64_to_ns(&ts);
 
+	if (req->flags & PTP_PEROUT_PHASE) {
+		ts.tv_sec = req->phase.sec;
+		ts.tv_nsec = req->phase.nsec;
+		ns_start = timespec64_to_ns(&ts);
+	} else {
+		ns_start = 0;
+	}
+
 	if (iep->ops && iep->ops->perout_enable) {
 		ret = iep->ops->perout_enable(iep->clockops_data, req, on, &cmp);
 		if (ret)
@@ -500,7 +509,8 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
 			regmap_write(iep->map, ICSS_IEP_SYNC_PWIDTH_REG,
 				     div_u64(ns_width, iep->def_inc));
 			regmap_write(iep->map, ICSS_IEP_SYNC0_PERIOD_REG, 0);
-			regmap_write(iep->map, ICSS_IEP_SYNC_START_REG, 0);
+			regmap_write(iep->map, ICSS_IEP_SYNC_START_REG,
+				     div_u64(ns_start, iep->def_inc));
 			regmap_write(iep->map, ICSS_IEP_SYNC_CTRL_REG, 0); /* one-shot mode */
 			/* Enable CMP 1 */
 			regmap_update_bits(iep->map, ICSS_IEP_CMP_CFG_REG,
@@ -527,6 +537,8 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
 
 			regmap_write(iep->map, ICSS_IEP_SYNC_PWIDTH_REG,
 				     div_u64(ns_width, iep->def_inc));
+			regmap_write(iep->map, ICSS_IEP_SYNC_START_REG,
+				     div_u64(ns_start, iep->def_inc));
 			/* Enable Sync in single shot mode  */
 			regmap_write(iep->map, ICSS_IEP_SYNC_CTRL_REG,
 				     IEP_SYNC_CTRL_SYNC_N_EN(0) | IEP_SYNC_CTRL_SYNC_EN);
@@ -557,7 +569,8 @@ static int icss_iep_perout_enable(struct icss_iep *iep,
 	int ret = 0;
 
 	/* Reject requests with unsupported flags */
-	if (req->flags & ~PTP_PEROUT_DUTY_CYCLE)
+	if (req->flags & ~(PTP_PEROUT_DUTY_CYCLE |
+			  PTP_PEROUT_PHASE))
 		return -EOPNOTSUPP;
 
 	mutex_lock(&iep->ptp_clk_mutex);
@@ -607,6 +620,7 @@ static int icss_iep_pps_enable(struct icss_iep *iep, int on)
 	if (on) {
 		ns = icss_iep_gettime(iep, NULL);
 		ts = ns_to_timespec64(ns);
+		rq.perout.flags = 0;
 		rq.perout.period.sec = 1;
 		rq.perout.period.nsec = 0;
 		rq.perout.start.sec = ts.tv_sec + 2;
-- 
2.39.5



