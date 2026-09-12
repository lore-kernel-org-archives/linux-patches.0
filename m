Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2DF20ED;
	Sat, 12 Sep 2026 15:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225522; cv=none; b=pYRrqYopyVbaGQFSo+at59l0f5rJbxGqr5EipkZvFwHwyA6GsRURf+hp3bbsS+zx8D7bOtjwvCP2kmceaLKrdOk1/Cry9BH5VBXqIML1upk5Xcg/7s2KuYy9ujEOQemMZu0OPM+WgQOC/24cH0qyA2YOGNXlX5d9prjJaln5vPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225522; c=relaxed/simple;
	bh=i34NVNHjAj4B/1R3DeIC/BKajfEmRvwgM2X4T5x3mso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDxG3Ih4WFosQbnZ808hctz8+APWtrd+2IZEtvP+qsZpvK6rAbgJVvCpUDSSkp+j3aIwpX87ZOVK9K5Vc5ywPr1jGdwBQiYxQhRqeS8+2Y/RGDr5Jt15bSnbfsJNS5qyTwHzzhAoec17oTSSJWVaQ8MyUycy283Kt696zADQKps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUltfp9i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUltfp9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3561F000FF;
	Sat, 12 Sep 2026 15:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225521;
	bh=1BFXdOEt3OXT2IcG8B0byD+0d9tuAO8cRvlfIfGe+1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUltfp9iYWscDLuGzSogc+H9KoHgKcQSqGM9cU5ZIUCv3DmMPVrZiB7Efusz4sLuM
	 kYdnF4/PmdGzVJqJOqY2Efv1XixhdSRAW/I2iFoA73yA273+ABP6AoDCReyDMRkrPD
	 dyNZ+PuVVh6TXRAUMPdkevBPBWVu+/GzzcnpjprM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1214/1424] scsi: ufs: core: Remove redundant host_lock calls around UTMRLDBR
Date: Sat, 12 Sep 2026 09:00:46 +0200
Message-ID: <20260912065634.473284611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avri Altman <avri.altman@wdc.com>

[ Upstream commit 2b314e182caabd32f656ddba22432a7749572013 ]

There is no need to serialize single read/write calls to the host
controller registers. Remove the redundant host_lock calls that protect
access to the task management doorbell register: UTMRLDBR.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Link: https://lore.kernel.org/r/20241024075033.562562-2-avri.altman@wdc.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 720d8b2f2457 ("scsi: ufs: core: Set task state before io_schedule_timeout()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 82d83a2f1a4e1..a3a8ba38b13b4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1187,11 +1187,13 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
 static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
 {
 	const struct scsi_device *sdev;
+	unsigned long flags;
 	u32 pending = 0;
 
-	lockdep_assert_held(hba->host->host_lock);
+	spin_lock_irqsave(hba->host->host_lock, flags);
 	__shost_for_each_device(sdev, hba->host)
 		pending += sbitmap_weight(&sdev->budget_map);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	return pending;
 }
@@ -1205,7 +1207,6 @@ static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
 static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 					u64 wait_timeout_us)
 {
-	unsigned long flags;
 	int ret = 0;
 	u32 tm_doorbell;
 	u32 tr_pending;
@@ -1213,7 +1214,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 	ktime_t start;
 
 	ufshcd_hold(hba);
-	spin_lock_irqsave(hba->host->host_lock, flags);
 	/*
 	 * Wait for all the outstanding tasks/transfer requests.
 	 * Verify by checking the doorbell registers are clear.
@@ -1234,7 +1234,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 			break;
 		}
 
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		io_schedule_timeout(msecs_to_jiffies(20));
 		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
 		    wait_timeout_us) {
@@ -1246,7 +1245,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 			 */
 			do_last_check = true;
 		}
-		spin_lock_irqsave(hba->host->host_lock, flags);
 	} while (tm_doorbell || tr_pending);
 
 	if (timeout) {
@@ -1256,7 +1254,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 		ret = -EBUSY;
 	}
 out:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_release(hba);
 	return ret;
 }
@@ -7115,12 +7112,13 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	memcpy(hba->utmrdl_base_addr + task_tag, treq, sizeof(*treq));
 	ufshcd_vops_setup_task_mgmt(hba, task_tag, tm_function);
 
-	/* send command to the controller */
 	__set_bit(task_tag, &hba->outstanding_tasks);
-	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
 
 	spin_unlock_irqrestore(host->host_lock, flags);
 
+	/* send command to the controller */
+	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
+
 	ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_SEND);
 
 	/* wait until the task management command is completed */
-- 
2.53.0



