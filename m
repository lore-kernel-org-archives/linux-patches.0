Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B34A2C68F;
	Sat,  3 Feb 2024 04:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933978; cv=none; b=sgCx1YrNwBSrY2o629mt8xUev17pxkG6FXweTPe8MlXYw9p7oGbCZT5B8Jlagetv/4Bp6e7Xt06yVFNUe8jfsdTei+gkpwMGgn8dZfPw6qxWXGz+gNiGTBRzqDYERtNKW6xSzu0fgDqugtDPZPkldUUQdrTu8Qg9I3qqtGDhPmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933978; c=relaxed/simple;
	bh=5u23/lChybvs6Pb/LxkDF18MqFqjKb5830efIvyjj2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EU3ahS0K6b0UcvjUJKtbeJ24J0y1Z03XtuDzUFilDVx5J8MbWc7BDXs0JNt6mbb8NR1FsvHbT0f4sUH5Fdm+0rshoxCtxgIQtRQjpXF/dx2xYy4ferQ5QpaQZtMDz9Zb9oxRGmvkSlE43MeVWBHwu5Vcn1OA341lPHKYd2Uv63Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CP7sovOc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CP7sovOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43561C433F1;
	Sat,  3 Feb 2024 04:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933978;
	bh=5u23/lChybvs6Pb/LxkDF18MqFqjKb5830efIvyjj2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CP7sovOc7DJJW4RByLCXbmHDRD4jPcNBtt4JUMWs2xJNN0t+8lZc5CnHOXnlmOBA7
	 7PixuvbV66DT2IIqtskRtZHeM4vcUtXLUWvHag3VTFZ985Fp/exw9eryLKdJz2lk+1
	 6zbS7MipnAvcSWHNKAqdsBYbXUyQGBqoheW79TSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 335/353] pds_core: Clear BARs on reset
Date: Fri,  2 Feb 2024 20:07:33 -0800
Message-ID: <20240203035414.380122137@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit e96094c1d11cce4deb5da3c0500d49041ab845b8 ]

During reset the BARs might be accessed when they are
unmapped. This can cause unexpected issues, so fix it by
clearing the cached BAR values so they are not accessed
until they are re-mapped.

Also, make sure any places that can access the BARs
when they are NULL are prevented.

Fixes: 49ce92fbee0b ("pds_core: add FW update feature to devlink")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://lore.kernel.org/r/20240129234035.69802-6-brett.creeley@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/adminq.c  | 28 +++++++++++++++------
 drivers/net/ethernet/amd/pds_core/core.c    |  8 +++++-
 drivers/net/ethernet/amd/pds_core/dev.c     |  9 ++++++-
 drivers/net/ethernet/amd/pds_core/devlink.c |  3 ++-
 drivers/net/ethernet/amd/pds_core/fw.c      |  3 +++
 drivers/net/ethernet/amd/pds_core/main.c    |  5 ++++
 6 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
index 5edff33d56f3..ea773cfa0af6 100644
--- a/drivers/net/ethernet/amd/pds_core/adminq.c
+++ b/drivers/net/ethernet/amd/pds_core/adminq.c
@@ -191,10 +191,16 @@ static int __pdsc_adminq_post(struct pdsc *pdsc,
 
 	/* Check that the FW is running */
 	if (!pdsc_is_fw_running(pdsc)) {
-		u8 fw_status = ioread8(&pdsc->info_regs->fw_status);
-
-		dev_info(pdsc->dev, "%s: post failed - fw not running %#02x:\n",
-			 __func__, fw_status);
+		if (pdsc->info_regs) {
+			u8 fw_status =
+				ioread8(&pdsc->info_regs->fw_status);
+
+			dev_info(pdsc->dev, "%s: post failed - fw not running %#02x:\n",
+				 __func__, fw_status);
+		} else {
+			dev_info(pdsc->dev, "%s: post failed - BARs not setup\n",
+				 __func__);
+		}
 		ret = -ENXIO;
 
 		goto err_out_unlock;
@@ -266,10 +272,16 @@ int pdsc_adminq_post(struct pdsc *pdsc,
 			break;
 
 		if (!pdsc_is_fw_running(pdsc)) {
-			u8 fw_status = ioread8(&pdsc->info_regs->fw_status);
-
-			dev_dbg(pdsc->dev, "%s: post wait failed - fw not running %#02x:\n",
-				__func__, fw_status);
+			if (pdsc->info_regs) {
+				u8 fw_status =
+					ioread8(&pdsc->info_regs->fw_status);
+
+				dev_dbg(pdsc->dev, "%s: post wait failed - fw not running %#02x:\n",
+					__func__, fw_status);
+			} else {
+				dev_dbg(pdsc->dev, "%s: post wait failed - BARs not setup\n",
+					__func__);
+			}
 			err = -ENXIO;
 			break;
 		}
diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index f44333bd1256..65c8a7072e35 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -600,7 +600,13 @@ void pdsc_fw_up(struct pdsc *pdsc)
 
 static void pdsc_check_pci_health(struct pdsc *pdsc)
 {
-	u8 fw_status = ioread8(&pdsc->info_regs->fw_status);
+	u8 fw_status;
+
+	/* some sort of teardown already in progress */
+	if (!pdsc->info_regs)
+		return;
+
+	fw_status = ioread8(&pdsc->info_regs->fw_status);
 
 	/* is PCI broken? */
 	if (fw_status != PDS_RC_BAD_PCI)
diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
index 31940b857e0e..62a38e0a8454 100644
--- a/drivers/net/ethernet/amd/pds_core/dev.c
+++ b/drivers/net/ethernet/amd/pds_core/dev.c
@@ -57,6 +57,9 @@ int pdsc_err_to_errno(enum pds_core_status_code code)
 
 bool pdsc_is_fw_running(struct pdsc *pdsc)
 {
+	if (!pdsc->info_regs)
+		return false;
+
 	pdsc->fw_status = ioread8(&pdsc->info_regs->fw_status);
 	pdsc->last_fw_time = jiffies;
 	pdsc->last_hb = ioread32(&pdsc->info_regs->fw_heartbeat);
@@ -182,13 +185,17 @@ int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
 {
 	int err;
 
+	if (!pdsc->cmd_regs)
+		return -ENXIO;
+
 	memcpy_toio(&pdsc->cmd_regs->cmd, cmd, sizeof(*cmd));
 	pdsc_devcmd_dbell(pdsc);
 	err = pdsc_devcmd_wait(pdsc, cmd->opcode, max_seconds);
-	memcpy_fromio(comp, &pdsc->cmd_regs->comp, sizeof(*comp));
 
 	if ((err == -ENXIO || err == -ETIMEDOUT) && pdsc->wq)
 		queue_work(pdsc->wq, &pdsc->health_work);
+	else
+		memcpy_fromio(comp, &pdsc->cmd_regs->comp, sizeof(*comp));
 
 	return err;
 }
diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index e9948ea5bbcd..54864f27c87a 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -111,7 +111,8 @@ int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 
 	mutex_lock(&pdsc->devcmd_lock);
 	err = pdsc_devcmd_locked(pdsc, &cmd, &comp, pdsc->devcmd_timeout * 2);
-	memcpy_fromio(&fw_list, pdsc->cmd_regs->data, sizeof(fw_list));
+	if (!err)
+		memcpy_fromio(&fw_list, pdsc->cmd_regs->data, sizeof(fw_list));
 	mutex_unlock(&pdsc->devcmd_lock);
 	if (err && err != -EIO)
 		return err;
diff --git a/drivers/net/ethernet/amd/pds_core/fw.c b/drivers/net/ethernet/amd/pds_core/fw.c
index 90a811f3878a..fa626719e68d 100644
--- a/drivers/net/ethernet/amd/pds_core/fw.c
+++ b/drivers/net/ethernet/amd/pds_core/fw.c
@@ -107,6 +107,9 @@ int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
 
 	dev_info(pdsc->dev, "Installing firmware\n");
 
+	if (!pdsc->cmd_regs)
+		return -ENXIO;
+
 	dl = priv_to_devlink(pdsc);
 	devlink_flash_update_status_notify(dl, "Preparing to flash",
 					   NULL, 0, 0);
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 5172a5ad8ec6..05fdeb235e5f 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -37,6 +37,11 @@ static void pdsc_unmap_bars(struct pdsc *pdsc)
 	struct pdsc_dev_bar *bars = pdsc->bars;
 	unsigned int i;
 
+	pdsc->info_regs = NULL;
+	pdsc->cmd_regs = NULL;
+	pdsc->intr_status = NULL;
+	pdsc->intr_ctrl = NULL;
+
 	for (i = 0; i < PDS_CORE_BARS_MAX; i++) {
 		if (bars[i].vaddr)
 			pci_iounmap(pdsc->pdev, bars[i].vaddr);
-- 
2.43.0



