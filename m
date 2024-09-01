Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14881181334;
	Sun,  1 Sep 2024 16:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209268; cv=none; b=UApOfs49Nko5RKgkAVXQp+KrzVgrMALBDeUANXTnhL6XoxKUZDm0rLjm2BxuV6weH7ENXlIOaHqKufU+ok+waRdo+ZiR7ETKx6fP6viQMnZtn1XNyNcQp+puVFk84wW7B23DhNrRPgoC12JeE5NtNLP7PaBVP/hOPlcnQ0uyL5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209268; c=relaxed/simple;
	bh=7Ee8CzHniuKhmgcCBAkWkxST774f77IAuL1XbijUipI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYZmj5XtQlkVswIJhp8q2KIus4e3+3rrNRthMwSMcPWCRTJ9tNnlwDeTVRnxPEknNuykyHhOq+8N/WGg4sSTHzfK1bid6+PA7onLXjbu2cW1oIZGe+Tf65sMropLgBLQ4ACHnMOTcNNQLKWNc0K3MZnAJILjsLpS76MLqap7OVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvFsKF+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvFsKF+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C98DC4CEC3;
	Sun,  1 Sep 2024 16:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209268;
	bh=7Ee8CzHniuKhmgcCBAkWkxST774f77IAuL1XbijUipI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvFsKF+VxdBoPTuQ72X1B4sWZWHXZ9k8Iw2poXmtYtwU1qujbr3J0MMUtwh8ofXo5
	 zR8HuCICOdi0R+kyU5/pqUpK1MwnN4r/Wt6OiRYDoOE2LKAK0ubqq0bq76REJU8OIO
	 rFLtqPSp7PBSp09zYT59XsqropggaOz3aIMy9fiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 22/71] mmc: Avoid open coding by using mmc_op_tuning()
Date: Sun,  1 Sep 2024 18:17:27 +0200
Message-ID: <20240901160802.725682051@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChanWoo Lee <cw9316.lee@samsung.com>

[ Upstream commit b98e7e8daf0ebab9dcc36812378a71e1be0b5089 ]

Replace code with the already defined function. No functional changes.

Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20221124080031.14690-1-cw9316.lee@samsung.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 9374ae912dbb ("mmc: mtk-sd: receive cmd8 data when hs400 tuning fail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/core.c              | 3 +--
 drivers/mmc/host/dw_mmc.c            | 3 +--
 drivers/mmc/host/mtk-sd.c            | 8 ++------
 drivers/mmc/host/sdhci-msm.c         | 3 +--
 drivers/mmc/host/sdhci-pci-o2micro.c | 3 +--
 drivers/mmc/host/sdhci-tegra.c       | 8 ++------
 drivers/mmc/host/sdhci.c             | 9 ++-------
 7 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index df85c35a86a3b..fc2fca5325ba5 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -142,8 +142,7 @@ void mmc_request_done(struct mmc_host *host, struct mmc_request *mrq)
 	int err = cmd->error;
 
 	/* Flag re-tuning needed on CRC errors */
-	if (cmd->opcode != MMC_SEND_TUNING_BLOCK &&
-	    cmd->opcode != MMC_SEND_TUNING_BLOCK_HS200 &&
+	if (!mmc_op_tuning(cmd->opcode) &&
 	    !host->retune_crc_disable &&
 	    (err == -EILSEQ || (mrq->sbc && mrq->sbc->error == -EILSEQ) ||
 	    (mrq->data && mrq->data->error == -EILSEQ) ||
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index a0ccf88876f98..d0da4573b38cd 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -334,8 +334,7 @@ static u32 dw_mci_prep_stop_abort(struct dw_mci *host, struct mmc_command *cmd)
 	    cmdr == MMC_READ_MULTIPLE_BLOCK ||
 	    cmdr == MMC_WRITE_BLOCK ||
 	    cmdr == MMC_WRITE_MULTIPLE_BLOCK ||
-	    cmdr == MMC_SEND_TUNING_BLOCK ||
-	    cmdr == MMC_SEND_TUNING_BLOCK_HS200 ||
+	    mmc_op_tuning(cmdr) ||
 	    cmdr == MMC_GEN_CMD) {
 		stop->opcode = MMC_STOP_TRANSMISSION;
 		stop->arg = 0;
diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index 70e414027155d..efd2af2d36862 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -1207,9 +1207,7 @@ static bool msdc_cmd_done(struct msdc_host *host, int events,
 
 	if (!sbc_error && !(events & MSDC_INT_CMDRDY)) {
 		if (events & MSDC_INT_CMDTMO ||
-		    (cmd->opcode != MMC_SEND_TUNING_BLOCK &&
-		     cmd->opcode != MMC_SEND_TUNING_BLOCK_HS200 &&
-		     !host->hs400_tuning))
+		    (!mmc_op_tuning(cmd->opcode) && !host->hs400_tuning))
 			/*
 			 * should not clear fifo/interrupt as the tune data
 			 * may have alreay come when cmd19/cmd21 gets response
@@ -1303,9 +1301,7 @@ static void msdc_cmd_next(struct msdc_host *host,
 {
 	if ((cmd->error &&
 	    !(cmd->error == -EILSEQ &&
-	      (cmd->opcode == MMC_SEND_TUNING_BLOCK ||
-	       cmd->opcode == MMC_SEND_TUNING_BLOCK_HS200 ||
-	       host->hs400_tuning))) ||
+	      (mmc_op_tuning(cmd->opcode) || host->hs400_tuning))) ||
 	    (mrq->sbc && mrq->sbc->error))
 		msdc_request_done(host, mrq);
 	else if (cmd == mrq->sbc)
diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index e37fb25577c0f..28bd562c439ef 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -2218,8 +2218,7 @@ static int __sdhci_msm_check_write(struct sdhci_host *host, u16 val, int reg)
 		if (!msm_host->use_cdr)
 			break;
 		if ((msm_host->transfer_mode & SDHCI_TRNS_READ) &&
-		    SDHCI_GET_CMD(val) != MMC_SEND_TUNING_BLOCK_HS200 &&
-		    SDHCI_GET_CMD(val) != MMC_SEND_TUNING_BLOCK)
+		    !mmc_op_tuning(SDHCI_GET_CMD(val)))
 			sdhci_msm_set_cdr(host, true);
 		else
 			sdhci_msm_set_cdr(host, false);
diff --git a/drivers/mmc/host/sdhci-pci-o2micro.c b/drivers/mmc/host/sdhci-pci-o2micro.c
index 24bb0e9809e76..cfa0956e7d72a 100644
--- a/drivers/mmc/host/sdhci-pci-o2micro.c
+++ b/drivers/mmc/host/sdhci-pci-o2micro.c
@@ -326,8 +326,7 @@ static int sdhci_o2_execute_tuning(struct mmc_host *mmc, u32 opcode)
 		(host->timing != MMC_TIMING_UHS_SDR50))
 		return sdhci_execute_tuning(mmc, opcode);
 
-	if (WARN_ON((opcode != MMC_SEND_TUNING_BLOCK_HS200) &&
-			(opcode != MMC_SEND_TUNING_BLOCK)))
+	if (WARN_ON(!mmc_op_tuning(opcode)))
 		return -EINVAL;
 
 	/* Force power mode enter L0 */
diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 1adaa94c31aca..62d236bfe9377 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -268,13 +268,9 @@ static void tegra210_sdhci_writew(struct sdhci_host *host, u16 val, int reg)
 {
 	bool is_tuning_cmd = 0;
 	bool clk_enabled;
-	u8 cmd;
 
-	if (reg == SDHCI_COMMAND) {
-		cmd = SDHCI_GET_CMD(val);
-		is_tuning_cmd = cmd == MMC_SEND_TUNING_BLOCK ||
-				cmd == MMC_SEND_TUNING_BLOCK_HS200;
-	}
+	if (reg == SDHCI_COMMAND)
+		is_tuning_cmd = mmc_op_tuning(SDHCI_GET_CMD(val));
 
 	if (is_tuning_cmd)
 		clk_enabled = tegra_sdhci_configure_card_clk(host, 0);
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 4237d8ae878c1..536d21028a116 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1712,8 +1712,7 @@ static bool sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 		flags |= SDHCI_CMD_INDEX;
 
 	/* CMD19 is special in that the Data Present Select should be set */
-	if (cmd->data || cmd->opcode == MMC_SEND_TUNING_BLOCK ||
-	    cmd->opcode == MMC_SEND_TUNING_BLOCK_HS200)
+	if (cmd->data || mmc_op_tuning(cmd->opcode))
 		flags |= SDHCI_CMD_DATA;
 
 	timeout = jiffies;
@@ -3396,8 +3395,6 @@ static void sdhci_adma_show_error(struct sdhci_host *host)
 
 static void sdhci_data_irq(struct sdhci_host *host, u32 intmask)
 {
-	u32 command;
-
 	/*
 	 * CMD19 generates _only_ Buffer Read Ready interrupt if
 	 * use sdhci_send_tuning.
@@ -3406,9 +3403,7 @@ static void sdhci_data_irq(struct sdhci_host *host, u32 intmask)
 	 * SDHCI_INT_DATA_AVAIL always there, stuck in irq storm.
 	 */
 	if (intmask & SDHCI_INT_DATA_AVAIL && !host->data) {
-		command = SDHCI_GET_CMD(sdhci_readw(host, SDHCI_COMMAND));
-		if (command == MMC_SEND_TUNING_BLOCK ||
-		    command == MMC_SEND_TUNING_BLOCK_HS200) {
+		if (mmc_op_tuning(SDHCI_GET_CMD(sdhci_readw(host, SDHCI_COMMAND)))) {
 			host->tuning_done = 1;
 			wake_up(&host->buf_ready_int);
 			return;
-- 
2.43.0



