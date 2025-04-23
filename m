Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC65D5674E;
	Wed, 23 Apr 2025 14:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419839; cv=none; b=t9dg/6AdbtedeqUs0z8gGXh/84bm0vnXEr4EIv8zLrgMld+uiuAbs8Y006eY4pz3Qn/tY7E0dTf1Z5ahjuhBsIGdgCyClUnePel47N7rEJmtcmEjhxjVelUIKwcUMxZejIGjDY2pvCRZT99ku5184P6LuFxgsij+HC1gacuQQYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419839; c=relaxed/simple;
	bh=RA+6zisigi7Uaw0h3YC+D5a3JtMtdHPWm5yejnfX6Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuv1b0cgB04rAr3KmAfMSZ9iayZgnIL4Iw47Lvf86eQGrjGyunSmn2Q5yKK+vJ0u0AvPydV4nVPTHDWGA3G4GXcHfO2SLmn09e3QA/t6zuUNokHgUvXLxaOCK6osU1CGiQBl9apBoNPgAsHxlO2JwAsUV5HpvWDcgRFSXjPknSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lm6Q/hWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lm6Q/hWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598DCC4CEE2;
	Wed, 23 Apr 2025 14:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419839;
	bh=RA+6zisigi7Uaw0h3YC+D5a3JtMtdHPWm5yejnfX6Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lm6Q/hWdpapkl8uTLYKrnMcfRWNmpktPu33MVRfvnxwWPBsdtcmfnQVwF1xiygXQs
	 nnpVuVHdEFIme+QIieZUJbBjO1jrmAIUXKJDlM7vYJ2Z/c632dN70/sezJTy7HL9jL
	 aiuUm6C3KQjv/+DQp5LfU9xd40v1x52mD2D9IYac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/223] net: ti: icss-iep: Add phase offset configuration for perout signal
Date: Wed, 23 Apr 2025 16:42:22 +0200
Message-ID: <20250423142619.981476006@linuxfoundation.org>
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
index 2981c19c48b18..b4a34c57b7b48 100644
--- a/drivers/net/ethernet/ti/icssg/icss_iep.c
+++ b/drivers/net/ethernet/ti/icssg/icss_iep.c
@@ -407,6 +407,7 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
 				     struct ptp_perout_request *req, int on)
 {
 	struct timespec64 ts;
+	u64 ns_start;
 	u64 ns_width;
 	int ret;
 	u64 cmp;
@@ -416,6 +417,14 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
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
@@ -430,7 +439,8 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
 			regmap_write(iep->map, ICSS_IEP_SYNC_PWIDTH_REG,
 				     div_u64(ns_width, iep->def_inc));
 			regmap_write(iep->map, ICSS_IEP_SYNC0_PERIOD_REG, 0);
-			regmap_write(iep->map, ICSS_IEP_SYNC_START_REG, 0);
+			regmap_write(iep->map, ICSS_IEP_SYNC_START_REG,
+				     div_u64(ns_start, iep->def_inc));
 			regmap_write(iep->map, ICSS_IEP_SYNC_CTRL_REG, 0); /* one-shot mode */
 			/* Enable CMP 1 */
 			regmap_update_bits(iep->map, ICSS_IEP_CMP_CFG_REG,
@@ -457,6 +467,8 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
 
 			regmap_write(iep->map, ICSS_IEP_SYNC_PWIDTH_REG,
 				     div_u64(ns_width, iep->def_inc));
+			regmap_write(iep->map, ICSS_IEP_SYNC_START_REG,
+				     div_u64(ns_start, iep->def_inc));
 			/* Enable Sync in single shot mode  */
 			regmap_write(iep->map, ICSS_IEP_SYNC_CTRL_REG,
 				     IEP_SYNC_CTRL_SYNC_N_EN(0) | IEP_SYNC_CTRL_SYNC_EN);
@@ -487,7 +499,8 @@ static int icss_iep_perout_enable(struct icss_iep *iep,
 	int ret = 0;
 
 	/* Reject requests with unsupported flags */
-	if (req->flags & ~PTP_PEROUT_DUTY_CYCLE)
+	if (req->flags & ~(PTP_PEROUT_DUTY_CYCLE |
+			  PTP_PEROUT_PHASE))
 		return -EOPNOTSUPP;
 
 	mutex_lock(&iep->ptp_clk_mutex);
@@ -588,6 +601,7 @@ static int icss_iep_pps_enable(struct icss_iep *iep, int on)
 	if (on) {
 		ns = icss_iep_gettime(iep, NULL);
 		ts = ns_to_timespec64(ns);
+		rq.perout.flags = 0;
 		rq.perout.period.sec = 1;
 		rq.perout.period.nsec = 0;
 		rq.perout.start.sec = ts.tv_sec + 2;
-- 
2.39.5



