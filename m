Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1D81A29A;
	Sat,  3 Feb 2024 04:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933703; cv=none; b=j7H85MkdoW+mxTbCUCZaUSfQsKVlkJp3ll1TZVaiceuSSNRMRDep48uoIABiujFR0Lln74krJ09RT/ltXInNGGAdI2WvuIR9IKwjbzVtdT3T3J5Sx3IN3gPWUOGJMwUVHqAG7wkETyUVLqmZUt3rdNuPzfPfHwjJ5PvvW3bIrt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933703; c=relaxed/simple;
	bh=CZMBT5qwykYGVsN8qkK1z+En2TUB1MxXdAWQXxjEpGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNOI7t96G+FcEcoIttVpQQ0hfmFNWVSxfwA5HSr2/xO/HCE3ZPp20iNJnWw3Lz6CGBrmGOhOUC3g3BNBiSgTH79hmeMEpHRYku3pLlkFVExHBavXHcp9yrKFlURZ5BgQ8Qpl53XmKTHUV5bDxAtSjHEUXcPJijvNGjzQ0VVaUEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkVlObPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkVlObPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B3DC433B1;
	Sat,  3 Feb 2024 04:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933703;
	bh=CZMBT5qwykYGVsN8qkK1z+En2TUB1MxXdAWQXxjEpGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkVlObPTQECdWVUoMoNXe2yU/ly6n0jw9y2frWWXEFWCI6lrRpngWJ9g/3RR+XXb8
	 fNygvqruYyGj7/5eIYS0sB0GUf3VwvXz/b5u+GHLA8sePFBrpwqkeuRg90v+0vb+Iv
	 GJC2okXUL8wN/qnZS0dtSYtOm67FUMoRYXjBnZRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 304/322] pds_core: Clear BARs on reset
Date: Fri,  2 Feb 2024 20:06:41 -0800
Message-ID: <20240203035408.876346862@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/ethernet/amd/pds_core/dev.c     |  9 ++++++-
 drivers/net/ethernet/amd/pds_core/devlink.c |  3 ++-
 drivers/net/ethernet/amd/pds_core/fw.c      |  3 +++
 drivers/net/ethernet/amd/pds_core/main.c    |  5 ++++
 5 files changed, 38 insertions(+), 10 deletions(-)

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
diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
index eb178728edba..1d590eb463d0 100644
--- a/drivers/net/ethernet/amd/pds_core/dev.c
+++ b/drivers/net/ethernet/amd/pds_core/dev.c
@@ -55,6 +55,9 @@ int pdsc_err_to_errno(enum pds_core_status_code code)
 
 bool pdsc_is_fw_running(struct pdsc *pdsc)
 {
+	if (!pdsc->info_regs)
+		return false;
+
 	pdsc->fw_status = ioread8(&pdsc->info_regs->fw_status);
 	pdsc->last_fw_time = jiffies;
 	pdsc->last_hb = ioread32(&pdsc->info_regs->fw_heartbeat);
@@ -175,13 +178,17 @@ int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
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
index d2abf32b93fe..d8218bb153d9 100644
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
index 4c7f982c12a1..7471a751e4d8 100644
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



