Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2BC2820C6;
	Thu, 15 Jan 2026 17:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497075; cv=none; b=ik25Lj0dzq3pne4JohxkVcQZvmg5Mc5HJrDFdKauQIRYtKgNOXBB3HMUl6tGtKJq1HkOjU9c8xH8LPhuF4/9zO7ciex/Z4n9VZwUCoseHJcAMrwIiIXHgVBHaZ2GitwzQ02u10pBU95zldYFyYlYv32IJanoZMDTHwjsKxPPndM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497075; c=relaxed/simple;
	bh=ZGJ8/HEDxVZOLvOjg5PS/vRMzCOn2KzAryBPfxYgTqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cx/uno1nmepA0MCBVgGVOtoaq6tQsdP8DL5NR+0cCnBcikDB0N4oNKNunHguWX911QZN9rjaKktVriUhcmDqAN4EwiDvyBg20yT/veejIIeRSUrLWEi91fSxWrbfT2nzQUyvukA6L0wYSQ37ILKxIEBE4knMAX4nqVCheWBxtYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsIBxj19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsIBxj19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFC3C116D0;
	Thu, 15 Jan 2026 17:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497075;
	bh=ZGJ8/HEDxVZOLvOjg5PS/vRMzCOn2KzAryBPfxYgTqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XsIBxj19a2fsrWCE+Yg+jbV/FmiFWwTl1bloIgIwICoM7MP6zw6uOdC/Z1ttcyGId
	 qGTOu7t+Wf0iNgy2NqwqKrdD+FvbISnOdKFZd9V9ffD8TpPUkUBSFUkHn053Yzkymw
	 nZ86vr9qyhvy1TaOJcvm7WTxo+gft8v2GWKDW7h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Kao <powenkao@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 28/72] scsi: ufs: core: Fix EH failure after W-LUN resume error
Date: Thu, 15 Jan 2026 17:48:38 +0100
Message-ID: <20260115164144.515755898@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Brian Kao <powenkao@google.com>

[ Upstream commit b4bb6daf4ac4d4560044ecdd81e93aa2f6acbb06 ]

When a W-LUN resume fails, its parent devices in the SCSI hierarchy,
including the scsi_target, may be runtime suspended. Subsequently, the
error handler in ufshcd_recover_pm_error() fails to set the W-LUN device
back to active because the parent target is not active.  This results in
the following errors:

  google-ufshcd 3c2d0000.ufs: ufshcd_err_handler started; HBA state eh_fatal; ...
  ufs_device_wlun 0:0:0:49488: START_STOP failed for power mode: 1, result 40000
  ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_resume failed: -5
  ...
  ufs_device_wlun 0:0:0:49488: runtime PM trying to activate child device 0:0:0:49488 but parent (target0:0:0) is not active

Address this by:

 1. Ensuring the W-LUN's parent scsi_target is runtime resumed before
    attempting to set the W-LUN to active within
    ufshcd_recover_pm_error().

 2. Explicitly checking for power.runtime_error on the HBA and W-LUN
    devices before calling pm_runtime_set_active() to clear the error
    state.

 3. Adding pm_runtime_get_sync(hba->dev) in
    ufshcd_err_handling_prepare() to ensure the HBA itself is active
    during error recovery, even if a child device resume failed.

These changes ensure the device power states are managed correctly
during error recovery.

Signed-off-by: Brian Kao <powenkao@google.com>
Tested-by: Brian Kao <powenkao@google.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251112063214.1195761-1-powenkao@google.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2435ea7ec089b..d553169b4d9ad 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6154,6 +6154,11 @@ static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
 
 static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 {
+	/*
+	 * A WLUN resume failure could potentially lead to the HBA being
+	 * runtime suspended, so take an extra reference on hba->dev.
+	 */
+	pm_runtime_get_sync(hba->dev);
 	ufshcd_rpm_get_sync(hba);
 	if (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev) ||
 	    hba->is_sys_suspended) {
@@ -6194,6 +6199,7 @@ static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 	if (ufshcd_is_clkscaling_supported(hba))
 		ufshcd_clk_scaling_suspend(hba, false);
 	ufshcd_rpm_put(hba);
+	pm_runtime_put(hba->dev);
 }
 
 static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
@@ -6208,28 +6214,42 @@ static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
 #ifdef CONFIG_PM
 static void ufshcd_recover_pm_error(struct ufs_hba *hba)
 {
+	struct scsi_target *starget = hba->ufs_device_wlun->sdev_target;
 	struct Scsi_Host *shost = hba->host;
 	struct scsi_device *sdev;
 	struct request_queue *q;
-	int ret;
+	bool resume_sdev_queues = false;
 
 	hba->is_sys_suspended = false;
+
 	/*
-	 * Set RPM status of wlun device to RPM_ACTIVE,
-	 * this also clears its runtime error.
+	 * Ensure the parent's error status is cleared before proceeding
+	 * to the child, as the parent must be active to activate the child.
 	 */
-	ret = pm_runtime_set_active(&hba->ufs_device_wlun->sdev_gendev);
+	if (hba->dev->power.runtime_error) {
+		/* hba->dev has no functional parent thus simplily set RPM_ACTIVE */
+		pm_runtime_set_active(hba->dev);
+		resume_sdev_queues = true;
+	}
+
+	if (hba->ufs_device_wlun->sdev_gendev.power.runtime_error) {
+		/*
+		 * starget, parent of wlun, might be suspended if wlun resume failed.
+		 * Make sure parent is resumed before set child (wlun) active.
+		 */
+		pm_runtime_get_sync(&starget->dev);
+		pm_runtime_set_active(&hba->ufs_device_wlun->sdev_gendev);
+		pm_runtime_put_sync(&starget->dev);
+		resume_sdev_queues = true;
+	}
 
-	/* hba device might have a runtime error otherwise */
-	if (ret)
-		ret = pm_runtime_set_active(hba->dev);
 	/*
 	 * If wlun device had runtime error, we also need to resume those
 	 * consumer scsi devices in case any of them has failed to be
 	 * resumed due to supplier runtime resume failure. This is to unblock
 	 * blk_queue_enter in case there are bios waiting inside it.
 	 */
-	if (!ret) {
+	if (resume_sdev_queues) {
 		shost_for_each_device(sdev, shost) {
 			q = sdev->request_queue;
 			if (q->dev && (q->rpm_status == RPM_SUSPENDED ||
-- 
2.51.0



