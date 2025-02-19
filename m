Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FB81BEF71;
	Wed, 19 Feb 2025 08:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955332; cv=none; b=UGVk3wghh1MAuf6z9glZd19CO/AYoIMZBmn6k3f6P/wSIIbkwLJV345zHdzjNPK4WvRYkzOnpGl9HgF419wghPlGAQwjYU3zdC8MVFnLgyialbK6G/iWTKOQck1QlNLb6rVjyxViXQVqaYey5wRC5ps4MKyZV2cbT2SBaHxDwLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955332; c=relaxed/simple;
	bh=0RjgU5EOVxbv9Qxt4yoTKPM2ZjXrG9D+eKGtocrSk0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eo5BYWV3TTFTq+8BOLamVsvnG/hI6wnr+Ug26JfKcCWlkd1FwEsUJs5IAral310DAhjBDgmHSjurDxZ/6YGn5fD6Df/PzARgtyrN2Jx8doNACTs3NLfO+eMaJm77N0LqsDlO6wjdEgQCkMIeraDvOzTk9MZx4fuwGjuGx5ETJi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7TJK97Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7TJK97Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA05C4CEE8;
	Wed, 19 Feb 2025 08:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955332;
	bh=0RjgU5EOVxbv9Qxt4yoTKPM2ZjXrG9D+eKGtocrSk0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U7TJK97ZaTfQIPU2Nuub9T0GvC3HkY2dQPx8Dyg61IVIU6F1OMPBuWHynVH4UWwX6
	 diAnvHcwFEYZCPnAxAFyBTZlf9w/W5Sn3K9bzw5TdBC6uk4mneXxBfw6fzVy9COhrr
	 CdY1DyuInZaZIUiEah7ua54ugaEl0eRVpI8OJm6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 171/230] scsi: ufs: core: Prepare to introduce a new clock_gating lock
Date: Wed, 19 Feb 2025 09:28:08 +0100
Message-ID: <20250219082608.392696187@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Avri Altman <avri.altman@wdc.com>

[ Upstream commit 7869c6521f5715688b3d1f1c897374a68544eef0 ]

Remove hba->clk_gating.active_reqs check from ufshcd_is_ufs_dev_busy()
function to separate clock gating logic from general device busy checks.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Link: https://lore.kernel.org/r/20241124070808.194860-3-avri.altman@wdc.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 839a74b5649c ("scsi: ufs: Fix toggling of clk_gating.state when clock gating is not allowed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 94d7992457a3b..217619d64940e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -266,8 +266,7 @@ static bool ufshcd_has_pending_tasks(struct ufs_hba *hba)
 
 static bool ufshcd_is_ufs_dev_busy(struct ufs_hba *hba)
 {
-	return hba->clk_gating.active_reqs || hba->outstanding_reqs ||
-	       ufshcd_has_pending_tasks(hba);
+	return hba->outstanding_reqs || ufshcd_has_pending_tasks(hba);
 }
 
 static const struct ufs_dev_quirk ufs_fixups[] = {
@@ -1973,7 +1972,9 @@ static void ufshcd_gate_work(struct work_struct *work)
 		goto rel_lock;
 	}
 
-	if (ufshcd_is_ufs_dev_busy(hba) || hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
+	if (ufshcd_is_ufs_dev_busy(hba) ||
+	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
+	    hba->clk_gating.active_reqs)
 		goto rel_lock;
 
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -8272,7 +8273,9 @@ static void ufshcd_rtc_work(struct work_struct *work)
 	hba = container_of(to_delayed_work(work), struct ufs_hba, ufs_rtc_update_work);
 
 	 /* Update RTC only when there are no requests in progress and UFSHCI is operational */
-	if (!ufshcd_is_ufs_dev_busy(hba) && hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL)
+	if (!ufshcd_is_ufs_dev_busy(hba) &&
+	    hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL &&
+	    !hba->clk_gating.active_reqs)
 		ufshcd_update_rtc(hba);
 
 	if (ufshcd_is_ufs_dev_active(hba) && hba->dev_info.rtc_update_period)
-- 
2.39.5



