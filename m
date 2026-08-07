Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A2F305665;
	Fri,  7 Aug 2026 14:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114004; cv=none; b=nfa+2FX4n06HwgStIESKTNSsEb0RQogg0+1TjrqIDkxxnELG3oCbnBDolL9eQclX6T3fSGRAK41EntWDKdqAq9JkRaA4WD/6PlSK2n5Y431oKekPI/JHWEICwdeI+qopnM4pPmh6qEe6fL3ZAtmy5aJpB86bACQfcj0ReA2xULQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114004; c=relaxed/simple;
	bh=Xq3kBw/HWyhuEGnWn7j4IgoTtolitvSwW+2pYY1DqpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWRKbnRghzh/XbkweZEF7nxug5ozHOvgw8t79O/euCj4gRWovnl4lZtUjHeuy0uhv7ulDM7C6nY/UZB5mxFn8i6FdPaeneoiK1FN1gjs77rc7OWNfYEFhwupl960VBzDunnaHrWisvfVEEPSmZlVAoVKyKDaFc8Wsn7LlUmg6Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDOXxVAd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDOXxVAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CD91F000E9;
	Fri,  7 Aug 2026 14:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114002;
	bh=TUCgK4nkY8DzR3k09AJo3Ppq7vKyQ0peyizCBR/r9kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bDOXxVAdi0nHaG6cFEdz7KEgJnVqNDoluTBrK/qGeuIAkpGoDox2Woo3Fzsp5GlFC
	 xRcFOHA2V5VjNQCxS397StQqKkatbKiOu+3xT1dZHjUqQWZofuwjiKKBh5/nGg1hGC
	 2kTMqkCeIrjwXp64QjMNgDL/kqP2Bb0UTSW68ksk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/337] scsi: ufs: core: Cancel RTC work in active-active suspend
Date: Fri,  7 Aug 2026 16:35:12 +0200
Message-ID: <20260807143420.897331081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit f71b4a30983b846b4075bf544e835121e70e6a43 ]

UFS RTC support schedules ufs_rtc_update_work to periodically update the
device RTC. The work can issue query commands and access the UFS host
controller.

A previous change moved the RTC work cancellation before the PRE_CHANGE
vendor suspend callback to close a race in the common suspend path.
However, the active-active path jumps directly to vops_suspend after
flushing exception handling work and therefore bypasses the
cancellation.

If the RTC work runs while the vendor suspend callback is gating or
otherwise changing hardware state, it can access the controller during
suspend and trigger an SError.

Cancel the RTC work before entering the vendor suspend callback in the
active-active path. Since this path now cancels the work, move the RTC
work scheduling outside the device and link state restoration block in
the resume path. This restarts RTC updates after an active-active
suspend and resume cycle.

Fixes: b0bd84c39289 ("scsi: ufs: core: Fix SError in ufshcd_rtc_work() during UFS suspend")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260714172726.1736967-1-lgs201920130244@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 205427f6c4651..98bf5bc6f383e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9761,6 +9761,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			req_link_state == UIC_LINK_ACTIVE_STATE) {
 		ufshcd_disable_auto_bkops(hba);
 		flush_work(&hba->eeh_work);
+		cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
 		goto vops_suspend;
 	}
 
@@ -9970,10 +9971,11 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		if (ret)
 			goto set_old_link_state;
 		ufshcd_set_timestamp_attr(hba);
-		schedule_delayed_work(&hba->ufs_rtc_update_work,
-				      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
 	}
 
+	schedule_delayed_work(&hba->ufs_rtc_update_work,
+			      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
+
 	if (ufshcd_keep_autobkops_enabled_except_suspend(hba))
 		ufshcd_enable_auto_bkops(hba);
 	else
-- 
2.53.0



