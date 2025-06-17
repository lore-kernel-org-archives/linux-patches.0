Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7A72ECE84;
	Tue, 17 Jun 2025 15:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174294; cv=none; b=O3pk7qEkfQl9S2DMhD3bOxOJhkZEUR8LuYyrft+dIAsppBTbHdxfea8uQ2OVR3XrEa+WY5GnOkoPMOB4BWw+j4kZo2gXuejU3vyqgFjOq1PcO1WlslXunu62jNxMq1PoR3bCkLlkK2Inhhfz3aO0hXkXOQzqzMNUE+OAdh2PKHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174294; c=relaxed/simple;
	bh=fmg/47RzG2/SpdFzpWz/IF723Tzry17JzB7X0kp1oZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSTFUweSmoYT9N3m/kVukKz8ETjPNzPrhY/iJHbqufLl6KVK6ZONB0hVjhy/h+d80XVQpzvaCRIRqqqT4CAak/bSw4QLPUY9rqevIp6tPLs/+UkEP/ROGa73Gtof76m3xvinpB2ffnBLZYs+Hhhetwdc5j5kyHf9Nw5wMwFsN0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUp0ajDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUp0ajDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5ABC4CEF0;
	Tue, 17 Jun 2025 15:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174294;
	bh=fmg/47RzG2/SpdFzpWz/IF723Tzry17JzB7X0kp1oZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUp0ajDK4Uei81Z09ESw86yqEDGixlgYlHAbXMwYlWvn6ZWml2iuvDOwLXYKqUn/Q
	 Op1Lx82E9Yli5K2d47r8ccpxPZ+qewvmadO6RTkf2nIXMmqCj458xeHO3aUBuXBE4l
	 PbvgCyNvixhUGBzfJXDz9EKSEBLAdQnSfXY62jps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Feng Xu <feng.f.xu@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/356] EDAC/{skx_common,i10nm}: Fix the loss of saved RRL for HBM pseudo channel 0
Date: Tue, 17 Jun 2025 17:22:37 +0200
Message-ID: <20250617152339.923026311@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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
index 67a46abe07da9..068597e8fce95 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -99,7 +99,7 @@ static u32 offsets_demand2_spr[] = {0x22c70, 0x22d80, 0x22f18, 0x22d58, 0x22c64,
 static u32 offsets_demand_spr_hbm0[] = {0x2a54, 0x2a60, 0x2b10, 0x2a58, 0x2a5c, 0x0ee0};
 static u32 offsets_demand_spr_hbm1[] = {0x2e54, 0x2e60, 0x2f10, 0x2e58, 0x2e5c, 0x0fb0};
 
-static void __enable_retry_rd_err_log(struct skx_imc *imc, int chan, bool enable,
+static void __enable_retry_rd_err_log(struct skx_imc *imc, int chan, bool enable, u32 *rrl_ctl,
 				      u32 *offsets_scrub, u32 *offsets_demand,
 				      u32 *offsets_demand2)
 {
@@ -112,10 +112,10 @@ static void __enable_retry_rd_err_log(struct skx_imc *imc, int chan, bool enable
 
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
@@ -129,25 +129,25 @@ static void __enable_retry_rd_err_log(struct skx_imc *imc, int chan, bool enable
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
@@ -161,6 +161,7 @@ static void __enable_retry_rd_err_log(struct skx_imc *imc, int chan, bool enable
 static void enable_retry_rd_err_log(bool enable)
 {
 	int i, j, imc_num, chan_num;
+	struct skx_channel *chan;
 	struct skx_imc *imc;
 	struct skx_dev *d;
 
@@ -175,8 +176,9 @@ static void enable_retry_rd_err_log(bool enable)
 			if (!imc->mbase)
 				continue;
 
+			chan = d->imc[i].chan;
 			for (j = 0; j < chan_num; j++)
-				__enable_retry_rd_err_log(imc, j, enable,
+				__enable_retry_rd_err_log(imc, j, enable, chan[j].rrl_ctl[0],
 							  res_cfg->offsets_scrub,
 							  res_cfg->offsets_demand,
 							  res_cfg->offsets_demand2);
@@ -190,12 +192,13 @@ static void enable_retry_rd_err_log(bool enable)
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
index 5acfef8fd3d36..2ea4d1d1fbef2 100644
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -80,6 +80,9 @@
  */
 #define MCACOD_EXT_MEM_ERR	0x280
 
+/* Max RRL register sets per {,sub-,pseudo-}channel. */
+#define NUM_RRL_SET		3
+
 /*
  * Each cpu socket contains some pci devices that provide global
  * information, and also some that are local to each of the two
@@ -118,9 +121,11 @@ struct skx_dev {
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



