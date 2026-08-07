Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E908473C71;
	Fri,  7 Aug 2026 15:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115024; cv=none; b=dmCf0zzK1E9JzliR8W59z/lXngE7ADhgMuGTwr8LBxmEii9xOWwR3d/Cfl0QbguEFDGzow5ZjeaPg+JpGeBEc2aANPJh1jBktDD61f3gBQvQ1sl5VQcuwUj3xP2WwM6Z9zHQI4vV0lKvNi8kVI9fF51Terx1tYvprYIlqm3BH+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115024; c=relaxed/simple;
	bh=8Gzrfd46V7IUEP/6PU67Y+fIihUAH9QaUqPNPgRbDmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMupBrD9BWOnKMUib8im0q5QV12iDYgaHW+oBCmGIaa6l7GMXBpSkebsO4ozzOC4wRceetqyKQ6rh3bvbCRDWDD/8/enEfrYDAASBZhMdtGufeajQ6NSKtWXWvyUx/o/KsNcpp8f4z9UHtcbsHGJe7KoYRLwN1jYZWIERMTh9QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oaqa0M4S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oaqa0M4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97F21F000E9;
	Fri,  7 Aug 2026 15:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115022;
	bh=LKkyaW0KGLZP4Blxypc8awnfAxGkHIZyVhQ895lZ83I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oaqa0M4SfCYdSFKf+OKWGjlkBkIC1v2WIKvGII0BlMDQL0Q6zFwVvM6n7Bs/b4d6L
	 ELwWacPUZexJGj0IBqCKnS9eiwE2RIrRmcznjxKAtmhImJFqyqBrYczX7OZtlc3xiH
	 pJFaaauQ7EFaV7vOyu8RL07lzivqGJonbgSlXxlc=
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
Subject: [PATCH 6.18 129/396] scsi: ufs: core: Cancel RTC work in active-active suspend
Date: Fri,  7 Aug 2026 16:34:49 +0200
Message-ID: <20260807143427.090801028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
index 8de3d0886a121..2545f7a51211b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9873,6 +9873,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			req_link_state == UIC_LINK_ACTIVE_STATE) {
 		ufshcd_disable_auto_bkops(hba);
 		flush_work(&hba->eeh_work);
+		cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
 		goto vops_suspend;
 	}
 
@@ -10082,10 +10083,11 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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



