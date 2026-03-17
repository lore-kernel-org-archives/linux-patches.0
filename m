Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2732FD69D;
	Tue, 17 Mar 2026 17:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768001; cv=none; b=lsehnPZ+FmHO732vbk3cT8Y/TG8wpdy/Zc+7dxDkGhJhVl/SQP8LTdjK5cQvarUAMfoJEGW/z2Wq/M6LjgUilXJqKDTLPX70oBWrdBfCgUX5yXB737NHnAEiD+UXRrrM17/J4vmoT+O5ZNZG7GVvYWfcBfka7o/ej0vDzO5Rj+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768001; c=relaxed/simple;
	bh=BWSRA0MFaeyH+TzRTj6geyCFaCf28RX7EOUwK1WM59o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDoVPcNJ9tAEp5zuYwqnTPG8Sh6GIHXnMnJsShgjK4VO9tX0dFLCxWM+EE6Bfe2rKFHCXb5Wro6MVrYZFgxEhvab2S82hGG4Rx5hE0HH32f0Zjh7wJypIYOykM65GlHnzwn90+DhS/QV5HcgkVUcJo2QxiBwGwPnboJ88grUtoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMFwnZrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMFwnZrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061F8C19424;
	Tue, 17 Mar 2026 17:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768001;
	bh=BWSRA0MFaeyH+TzRTj6geyCFaCf28RX7EOUwK1WM59o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMFwnZrF7CO+bgrwklTjNAmI71PB5V8b43g2oeuTkUezFhDyq5yL5s+NS7uMnWPJU
	 TsIZqBVrlaHWv5YpCueQazW09VQhmUC126M6XzGcQvUihZeu8xs2xXbLddLt87rojT
	 MEI6wFyQWUg9x/Ro9vpNCR8z4eLIaLVtoOcbuxxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bean Huo <beanhuo@iokpp.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Wang Shuaiwei <wangshuaiwei1@xiaomi.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 177/333] scsi: ufs: core: Fix SError in ufshcd_rtc_work() during UFS suspend
Date: Tue, 17 Mar 2026 17:33:26 +0100
Message-ID: <20260317163005.919746005@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Shuaiwei <wangshuaiwei1@xiaomi.com>

[ Upstream commit b0bd84c39289ef6a6c3827dd52c875659291970a ]

In __ufshcd_wl_suspend(), cancel_delayed_work_sync() is called to cancel
the UFS RTC work, but it is placed after ufshcd_vops_suspend(hba, pm_op,
POST_CHANGE). This creates a race condition where ufshcd_rtc_work() can
still be running while ufshcd_vops_suspend() is executing. When
UFSHCD_CAP_CLK_GATING is not supported, the condition
!hba->clk_gating.active_reqs is always true, causing ufshcd_update_rtc()
to be executed. Since ufshcd_vops_suspend() typically performs clock
gating operations, executing ufshcd_update_rtc() at that moment triggers
an SError. The kernel panic trace is as follows:

Kernel panic - not syncing: Asynchronous SError Interrupt
Call trace:
 dump_backtrace+0xec/0x128
 show_stack+0x18/0x28
 dump_stack_lvl+0x40/0xa0
 dump_stack+0x18/0x24
 panic+0x148/0x374
 nmi_panic+0x3c/0x8c
 arm64_serror_panic+0x64/0x8c
 do_serror+0xc4/0xc8
 el1h_64_error_handler+0x34/0x4c
 el1h_64_error+0x68/0x6c
 el1_interrupt+0x20/0x58
 el1h_64_irq_handler+0x18/0x24
 el1h_64_irq+0x68/0x6c
 ktime_get+0xc4/0x12c
 ufshcd_mcq_sq_stop+0x4c/0xec
 ufshcd_mcq_sq_cleanup+0x64/0x1dc
 ufshcd_clear_cmd+0x38/0x134
 ufshcd_issue_dev_cmd+0x298/0x4d0
 ufshcd_exec_dev_cmd+0x1a4/0x1c4
 ufshcd_query_attr+0xbc/0x19c
 ufshcd_rtc_work+0x10c/0x1c8
 process_scheduled_works+0x1c4/0x45c
 worker_thread+0x32c/0x3e8
 kthread+0x120/0x1d8
 ret_from_fork+0x10/0x20

Fix this by moving cancel_delayed_work_sync() before the call to
ufshcd_vops_suspend(hba, pm_op, PRE_CHANGE), ensuring the UFS RTC work is
fully completed or cancelled at that point.

Cc: Bean Huo <beanhuo@iokpp.de>
Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Wang Shuaiwei <wangshuaiwei1@xiaomi.com>
Link: https://patch.msgid.link/20260307035128.3419687-1-wangshuaiwei1@xiaomi.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fe1425ea6718f..5371f173e28b9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9925,6 +9925,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	}
 
 	flush_work(&hba->eeh_work);
+	cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
 
 	ret = ufshcd_vops_suspend(hba, pm_op, PRE_CHANGE);
 	if (ret)
@@ -9979,7 +9980,6 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (ret)
 		goto set_link_active;
 
-	cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
 	goto out;
 
 set_link_active:
-- 
2.51.0



