Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFA02D24B7;
	Tue, 10 Mar 2026 11:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141051; cv=none; b=GslQeMalLy0OhG3GBbCpqI2EjMkS7BnujjbggzdHJGltJuHO9eYc1jY1b9MOJ8trWoi1o8zVmuvS6TrsC14iaoUUGE4FFBUy81U16Fcz29p8yucFuTSOHbFsZZGbuCLFDMqNpujDZJ+sUF2EUArOG7ffgvQJjIUNABSMncwsEbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141051; c=relaxed/simple;
	bh=sD+JOQuxEzGTmr/uiBlodTCrgtk6Z6Meyp0h4+D45hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkZBkHc+563OUtqtlPvzdKGomaOLu/j4W8i550KAwgAiwsH3WYMOLGC0wLQUktoQXGxd+lszqAXp51BalstRFazc/mPABV0Bbgm48lt1CFt/xOFrI7sfS6NRkEaAA3NHZx8CBiSSlAcYz3npkEW1WaJFefkebT59ScS/1jiYQVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fadclei6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fadclei6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB56C19423;
	Tue, 10 Mar 2026 11:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141050;
	bh=sD+JOQuxEzGTmr/uiBlodTCrgtk6Z6Meyp0h4+D45hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fadclei6Xf7mNdevwC4nndsdkHc31NjxIEvO9BNVkuTye5PULqljv1U7fDeIWJbIM
	 Hr0FBWykOZLzFtMcgydRYPkDv5ls7tJ3VZmF8iRtZb4Sw2yMZ9S+juae+oq2/ZThBb
	 3kejBSxkZSENmLbAoAJh+u42bksHKO01I3yNr88D8MNXIpYUJLZ5YTJ6v6ppO4hSbm
	 udmtwXDBuvu70tztaM+5uPqjnNehSXZ2P4tTMZyoX/L1WozBV1J2qVkdHR5pU2sf2r
	 m1FtkpGbCf2O9Ij9Vc9MgYcd8UryP1wmgGg/IVp3sZRshDYFTP331BizqP/TLA5GF7
	 UJ6ASg0ds12JA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 049/311] scsi: ufs: core: Move link recovery for hibern8 exit failure to wl_resume
Date: Tue, 10 Mar 2026 07:01:36 -0400
Message-ID: <74ef2e0853a2f2a24bdf5ef3c227883ad7995bc5.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 62c015373e1cdb1cdca824bd2dbce2dac0819467 ]

Move the link recovery trigger from ufshcd_uic_pwr_ctrl() to
__ufshcd_wl_resume(). Ensure link recovery is only attempted when hibern8
exit fails during resume, not during hibern8 enter in suspend. Improve
error handling and prevent unnecessary link recovery attempts.

Fixes: 35dabf4503b9 ("scsi: ufs: core: Use link recovery when h8 exit fails during runtime resume")
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260223103906.2533654-1-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 09f0d77d57f02..d6e4e99a571f1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4385,14 +4385,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	mutex_unlock(&hba->uic_cmd_mutex);
 
-	/*
-	 * If the h8 exit fails during the runtime resume process, it becomes
-	 * stuck and cannot be recovered through the error handler.  To fix
-	 * this, use link recovery instead of the error handler.
-	 */
-	if (ret && hba->pm_op_in_progress)
-		ret = ufshcd_link_recovery(hba);
-
 	return ret;
 }
 
@@ -10174,7 +10166,15 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		} else {
 			dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
 					__func__, ret);
-			goto vendor_suspend;
+			/*
+			 * If the h8 exit fails during the runtime resume
+			 * process, it becomes stuck and cannot be recovered
+			 * through the error handler. To fix this, use link
+			 * recovery instead of the error handler.
+			 */
+			ret = ufshcd_link_recovery(hba);
+			if (ret)
+				goto vendor_suspend;
 		}
 	} else if (ufshcd_is_link_off(hba)) {
 		/*
-- 
2.51.0

