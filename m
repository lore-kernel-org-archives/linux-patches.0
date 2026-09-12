Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B72348122C;
	Sat, 12 Sep 2026 13:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218324; cv=none; b=fY8MQVNQ9/xVd38xkOrnXJjoVjV6HV7kYvd+gICec4BvyOXnBM+NEdaqExwkkuI7Isy2j2re6JHqGqZ488qLitxIdVzTyNrUEDE2KTNq+mrz78xifulhJ/YM3OdIFneb1sulmaY3LxeU1nL1utPh1V0EEpD/Y9RfcpvoEEdHllw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218324; c=relaxed/simple;
	bh=qgTsHp51nABvtXhrAmPGa7pS5eXWVanJTpIXxC5cmr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOwbY6vRPNEDIQRFNdBpnKrUkmI+1evKX0cJSFi5rb/JF1y8bhVMQrSzGOQOA0MpO488M2pfIc/bkmS5bS7t4qUqUCJJH4jIvM7VHJJa3V4PruMrJcXQEJvu+Qcm8hh2LdJvMD9LEr2EPj8QKynJflH/TdLybYJWzlZIlih2ycw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VP7Yv9Pf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VP7Yv9Pf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E23C1F000FF;
	Sat, 12 Sep 2026 13:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218322;
	bh=LT419Zq8xQyDnUtqJ+GJbZY1zflJWCDY4lcpt6VyK7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VP7Yv9Pfsy+MFhRjne6NnkiQ61HJceitlPxuoX37MuunHGqLDuc8zMdPUHSUpLM5x
	 9gNq0YDIOBWn/5Db8eejlyBrvvCoBdz076ULwpC2/hEmiJFXwtCoXeJHIhHiE0qUv/
	 i4u8yTDbxgNM1o+jyzCV9CwKN/qVYQ2q7lTl1HDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1122/1376] scsi: ufs: core: Remove redundant host_lock calls around UTMRLDBR
Date: Sat, 12 Sep 2026 08:59:08 +0200
Message-ID: <20260912065632.570858846@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bcbe478bc4032..5575fbc9905c5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1264,11 +1264,13 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
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
@@ -1282,7 +1284,6 @@ static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
 static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 					u64 wait_timeout_us)
 {
-	unsigned long flags;
 	int ret = 0;
 	u32 tm_doorbell;
 	u32 tr_pending;
@@ -1290,7 +1291,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 	ktime_t start;
 
 	ufshcd_hold(hba);
-	spin_lock_irqsave(hba->host->host_lock, flags);
 	/*
 	 * Wait for all the outstanding tasks/transfer requests.
 	 * Verify by checking the doorbell registers are clear.
@@ -1311,7 +1311,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 			break;
 		}
 
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		io_schedule_timeout(msecs_to_jiffies(20));
 		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
 		    wait_timeout_us) {
@@ -1323,7 +1322,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 			 */
 			do_last_check = true;
 		}
-		spin_lock_irqsave(hba->host->host_lock, flags);
 	} while (tm_doorbell || tr_pending);
 
 	if (timeout) {
@@ -1333,7 +1331,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 		ret = -EBUSY;
 	}
 out:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_release(hba);
 	return ret;
 }
@@ -7127,12 +7124,13 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
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



