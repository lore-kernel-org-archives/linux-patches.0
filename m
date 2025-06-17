Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA9921B908;
	Tue, 17 Jun 2025 16:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178076; cv=none; b=ZHhQNnanJzGRSvqcVBQ+nPFAYNnCwThuGThEUNERo1whmoIE6HRbQYkr+mR0PhYZ36OTfk/08zGl91TtUUwmcsRcH9NvHezaAbbUG+0mvrim/iO9Iji/zg8VhB8gP7+jxv8gqBrL0/oAiXRtKgDZ0jHXY7khyghdifJ++sHKDaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178076; c=relaxed/simple;
	bh=gjGf/tTz1X6io0Ymxx3zvYK3JbvCeLADyvtVAfgbJuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5SbBBVxlQDF96dy+SszcdVjWuITzwAGLblDLvYx8Y/3eRck/YbV050NjE2hH4R749jCgE2xHW/WcrvZ3fpuZ9rmHGB81XqlptBQ1mMvi1EkjWhfcYB1jqH/tlEq2tq0PccMUXdXiK76yIqcSJpj0XbXvOHoCziay+6qJ5TcTl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPkp5eaN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPkp5eaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD3CC4CEE3;
	Tue, 17 Jun 2025 16:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178075;
	bh=gjGf/tTz1X6io0Ymxx3zvYK3JbvCeLADyvtVAfgbJuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPkp5eaNk/iXlAWGG4tqB/wfnEqiD21OPb4ELUopGiNpyNxozEguCSJfC5Rr0D6fQ
	 3t2yb0f5HWaQ1jgmFxZo1aTVwFjxlxPZYCfr2DtxRas8ZhOAbLy3ycF8Z6PWpQ9VK8
	 S+egOSvhIRZM6XCwMtEtrb65Uz7DOf6ftp3STaHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjeev Yadav <sanjeev.y@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 418/512] scsi: core: ufs: Fix a hang in the error handler
Date: Tue, 17 Jun 2025 17:26:24 +0200
Message-ID: <20250617152436.513419780@linuxfoundation.org>
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

From: Sanjeev Yadav <sanjeev.y@mediatek.com>

[ Upstream commit 8a3514d348de87a9d5e2ac00fbac4faae0b97996 ]

ufshcd_err_handling_prepare() calls ufshcd_rpm_get_sync(). The latter
function can only succeed if UFSHCD_EH_IN_PROGRESS is not set because
resuming involves submitting a SCSI command and ufshcd_queuecommand()
returns SCSI_MLQUEUE_HOST_BUSY if UFSHCD_EH_IN_PROGRESS is set. Fix this
hang by setting UFSHCD_EH_IN_PROGRESS after ufshcd_rpm_get_sync() has
been called instead of before.

Backtrace:
__switch_to+0x174/0x338
__schedule+0x600/0x9e4
schedule+0x7c/0xe8
schedule_timeout+0xa4/0x1c8
io_schedule_timeout+0x48/0x70
wait_for_common_io+0xa8/0x160 //waiting on START_STOP
wait_for_completion_io_timeout+0x10/0x20
blk_execute_rq+0xe4/0x1e4
scsi_execute_cmd+0x108/0x244
ufshcd_set_dev_pwr_mode+0xe8/0x250
__ufshcd_wl_resume+0x94/0x354
ufshcd_wl_runtime_resume+0x3c/0x174
scsi_runtime_resume+0x64/0xa4
rpm_resume+0x15c/0xa1c
__pm_runtime_resume+0x4c/0x90 // Runtime resume ongoing
ufshcd_err_handler+0x1a0/0xd08
process_one_work+0x174/0x808
worker_thread+0x15c/0x490
kthread+0xf4/0x1ec
ret_from_fork+0x10/0x20

Signed-off-by: Sanjeev Yadav <sanjeev.y@mediatek.com>
[ bvanassche: rewrote patch description ]
Fixes: 62694735ca95 ("[SCSI] ufs: Add runtime PM support for UFS host controller driver")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20250523201409.1676055-1-bvanassche@acm.org
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 247e425428c88..374f505fec3d1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6577,9 +6577,14 @@ static void ufshcd_err_handler(struct work_struct *work)
 		up(&hba->host_sem);
 		return;
 	}
-	ufshcd_set_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	ufshcd_err_handling_prepare(hba);
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_set_eh_in_progress(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	/* Complete requests that have door-bell cleared by h/w */
 	ufshcd_complete_requests(hba, false);
 	spin_lock_irqsave(hba->host->host_lock, flags);
-- 
2.39.5



