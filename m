Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8B02DF3C9;
	Tue, 17 Jun 2025 15:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174602; cv=none; b=T7wXtoOcQu9XW0T8lAoliw1JZ2wTHZJb1MSH67dcp4iFHFy/3DO+YpW4vYMA4xYtMQy9bssjwy67iTr2yNUGXxu1KRzgbnOSCmJNGEeEggdnEv5CwubW+W9NeeS7xbosBUccrzRrehhuJ0bIRAjRpk+AjF1DRY9FWCN+1Rt18Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174602; c=relaxed/simple;
	bh=oDSmw0+4wOpM7Yjdp7RzmlBujW73BVwNDz+DN3C1c6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjaE/kGxzEMtJ+FFClfvJfEAA0zcYbA+x3+1Jz/FPB4xUGpdZieS0qWnZB0i3XC8btgWqYwWwIWpz8NtckXldWKmIESOuA0x5YWLT6bdgyaTc/hEuRyYEqCaPHllKBcPgQoDQuSJIN1QFyZYuLggUkHJTG2p8wl0JYLa/zQZH2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LllZ9c1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LllZ9c1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96CAC4CEE3;
	Tue, 17 Jun 2025 15:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174602;
	bh=oDSmw0+4wOpM7Yjdp7RzmlBujW73BVwNDz+DN3C1c6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LllZ9c1oDhA4CFLizKVr90vyoXCQur3JESRvbaAA+f46CDXBIEkF97LbhjgvUDqiw
	 BlOqKekTR16XoOLXWp8FSrIRPw1UI0V7jXrlLETVIGZ8Su/TMNEva5NdHnwTUIz+n2
	 h1sW1A0UpYtTeVFf8f0d5Ol0JGSaWsITrmHwdsdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Feng Xu <feng.f.xu@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/512] EDAC/{skx_common,i10nm}: Fix the loss of saved RRL for HBM pseudo channel 0
Date: Tue, 17 Jun 2025 17:20:07 +0200
Message-ID: <20250617152421.208999600@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit eeed3e03f4261e5e381a72ae099ff00ccafbb437 ]

When enabling the retry_rd_err_log (RRL) feature during the loading of the
i10nm_edac driver with the module parameter retry_rd_err_log=2 (Linux RRL
control mode), the default values of the control bits of RRL are saved so
that they can be restored during the unloading of the driver.

In the current code, the RRL of pseudo channel 1 of HBM overwrites pseudo
channel 0 during the loading of the driver, resulting in the loss of saved
RRL for pseudo channel 0. This causes the RRL of pseudo channel 0 of HBM to
be wrongly restored with the values from pseudo channel 1 when unloading
the driver.

Fix this issue by creating two separate groups of RRL control registers
per channel to save default RRL settings of two {sub-,pseudo-}channels.

Fixes: acd4cf68fefe ("EDAC/i10nm: Retrieve and print retry_rd_err_log registers for HBM")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Tested-by: Feng Xu <feng.f.xu@intel.com>
Link: https://lore.kernel.org/r/20250417150724.1170168-3-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i10nm_base.c | 35 +++++++++++++++++++----------------
 drivers/edac/skx_common.h | 11 ++++++++---
 2 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index fbdf005bed3a4..ac4b3d95531c5 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -95,7 +95,7 @@ static u32 offsets_demand2_spr[] = {0x22c70, 0x22d80, 0x22f18, 0x22d58, 0x22c64,
 static u32 offsets_demand_spr_hbm0[] = {0x2a54, 0x2a60, 0x2b10, 0x2a58, 0x2a5c, 0x0ee0};
 static u32 offsets_demand_spr_hbm1[] = {0x2e54, 0x2e60, 0x2f10, 0x2e58, 0x2e5c, 0x0fb0};
 
-static void __enable_retry_rd_err_log(struct skx_imc *imc, int chan, bool enable,
+static void __enable_retry_rd_err_log(struct skx_imc *imc, int chan, bool enable, u32 *rrl_ctl,
 				      u32 *offsets_scrub, u32 *offsets_demand,
 				      u32 *offsets_demand2)
 {
@@ -108,10 +108,10 @@ static void __enable_retry_rd_err_log(struct skx_imc *imc, int chan, bool enable
 
 	if (enable) {
 		/* Save default configurations */
-		imc->chan[chan].retry_rd_err_log_s = s;
-		imc->chan[chan].retry_rd_err_log_d = d;
+		rrl_ctl[0] = s;
+		rrl_ctl[1] = d;
 		if (offsets_demand2)
-			imc->chan[chan].retry_rd_err_log_d2 = d2;
+			rrl_ctl[2] = d2;
 
 		s &= ~RETRY_RD_ERR_LOG_NOOVER_UC;
 		s |=  RETRY_RD_ERR_LOG_EN;
@@ -125,25 +125,25 @@ static void __enable_retry_rd_err_log(struct skx_imc *imc, int chan, bool enable
 		}
 	} else {
 		/* Restore default configurations */
-		if (imc->chan[chan].retry_rd_err_log_s & RETRY_RD_ERR_LOG_UC)
+		if (rrl_ctl[0] & RETRY_RD_ERR_LOG_UC)
 			s |=  RETRY_RD_ERR_LOG_UC;
-		if (imc->chan[chan].retry_rd_err_log_s & RETRY_RD_ERR_LOG_NOOVER)
+		if (rrl_ctl[0] & RETRY_RD_ERR_LOG_NOOVER)
 			s |=  RETRY_RD_ERR_LOG_NOOVER;
-		if (!(imc->chan[chan].retry_rd_err_log_s & RETRY_RD_ERR_LOG_EN))
+		if (!(rrl_ctl[0] & RETRY_RD_ERR_LOG_EN))
 			s &= ~RETRY_RD_ERR_LOG_EN;
-		if (imc->chan[chan].retry_rd_err_log_d & RETRY_RD_ERR_LOG_UC)
+		if (rrl_ctl[1] & RETRY_RD_ERR_LOG_UC)
 			d |=  RETRY_RD_ERR_LOG_UC;
-		if (imc->chan[chan].retry_rd_err_log_d & RETRY_RD_ERR_LOG_NOOVER)
+		if (rrl_ctl[1] & RETRY_RD_ERR_LOG_NOOVER)
 			d |=  RETRY_RD_ERR_LOG_NOOVER;
-		if (!(imc->chan[chan].retry_rd_err_log_d & RETRY_RD_ERR_LOG_EN))
+		if (!(rrl_ctl[1] & RETRY_RD_ERR_LOG_EN))
 			d &= ~RETRY_RD_ERR_LOG_EN;
 
 		if (offsets_demand2) {
-			if (imc->chan[chan].retry_rd_err_log_d2 & RETRY_RD_ERR_LOG_UC)
+			if (rrl_ctl[2] & RETRY_RD_ERR_LOG_UC)
 				d2 |=  RETRY_RD_ERR_LOG_UC;
-			if (!(imc->chan[chan].retry_rd_err_log_d2 & RETRY_RD_ERR_LOG_NOOVER))
+			if (!(rrl_ctl[2] & RETRY_RD_ERR_LOG_NOOVER))
 				d2 &=  ~RETRY_RD_ERR_LOG_NOOVER;
-			if (!(imc->chan[chan].retry_rd_err_log_d2 & RETRY_RD_ERR_LOG_EN))
+			if (!(rrl_ctl[2] & RETRY_RD_ERR_LOG_EN))
 				d2 &= ~RETRY_RD_ERR_LOG_EN;
 		}
 	}
@@ -157,6 +157,7 @@ static void __enable_retry_rd_err_log(struct skx_imc *imc, int chan, bool enable
 static void enable_retry_rd_err_log(bool enable)
 {
 	int i, j, imc_num, chan_num;
+	struct skx_channel *chan;
 	struct skx_imc *imc;
 	struct skx_dev *d;
 
@@ -171,8 +172,9 @@ static void enable_retry_rd_err_log(bool enable)
 			if (!imc->mbase)
 				continue;
 
+			chan = d->imc[i].chan;
 			for (j = 0; j < chan_num; j++)
-				__enable_retry_rd_err_log(imc, j, enable,
+				__enable_retry_rd_err_log(imc, j, enable, chan[j].rrl_ctl[0],
 							  res_cfg->offsets_scrub,
 							  res_cfg->offsets_demand,
 							  res_cfg->offsets_demand2);
@@ -186,12 +188,13 @@ static void enable_retry_rd_err_log(bool enable)
 			if (!imc->mbase || !imc->hbm_mc)
 				continue;
 
+			chan = d->imc[i].chan;
 			for (j = 0; j < chan_num; j++) {
-				__enable_retry_rd_err_log(imc, j, enable,
+				__enable_retry_rd_err_log(imc, j, enable, chan[j].rrl_ctl[0],
 							  res_cfg->offsets_scrub_hbm0,
 							  res_cfg->offsets_demand_hbm0,
 							  NULL);
-				__enable_retry_rd_err_log(imc, j, enable,
+				__enable_retry_rd_err_log(imc, j, enable, chan[j].rrl_ctl[1],
 							  res_cfg->offsets_scrub_hbm1,
 							  res_cfg->offsets_demand_hbm1,
 							  NULL);
diff --git a/drivers/edac/skx_common.h b/drivers/edac/skx_common.h
index 849198fd14da6..f40eb6e4f6319 100644
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -79,6 +79,9 @@
  */
 #define MCACOD_EXT_MEM_ERR	0x280
 
+/* Max RRL register sets per {,sub-,pseudo-}channel. */
+#define NUM_RRL_SET		3
+
 /*
  * Each cpu socket contains some pci devices that provide global
  * information, and also some that are local to each of the two
@@ -117,9 +120,11 @@ struct skx_dev {
 		struct skx_channel {
 			struct pci_dev	*cdev;
 			struct pci_dev	*edev;
-			u32 retry_rd_err_log_s;
-			u32 retry_rd_err_log_d;
-			u32 retry_rd_err_log_d2;
+			/*
+			 * Two groups of RRL control registers per channel to save default RRL
+			 * settings of two {sub-,pseudo-}channels in Linux RRL control mode.
+			 */
+			u32 rrl_ctl[2][NUM_RRL_SET];
 			struct skx_dimm {
 				u8 close_pg;
 				u8 bank_xor_enable;
-- 
2.39.5



