Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768BF253320;
	Wed,  5 Mar 2025 18:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197606; cv=none; b=paQXtG7a2s1tHofHDizzuabn0SEUriylGnQvD7lJIJc4YOUy4HPtS1x/C/rC9H+t08VbH42kAbaL46sevx8IlLTSUTyDtg62jVmv8wYbGhfIQgq6QVfMEtjmL85sJ2UqGWxqWUCDFjYQo7nV4e//04PsvlwyikGRN9wSQSlBEw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197606; c=relaxed/simple;
	bh=4NXEEjnTWuEYfPARI+kA8itXggOV/7Dpi5VwKM9SdKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwuyNi+VuihucAxyw6gd3b/6ofWahF6W0sE27+YXjcVskvXTpJ8s85QL2MSrN0IZpt+rdEiJmvZgvDvR3o70H3Ws2TmAYMoINTvn9M5vmn3SZP4EF2AUZ+8h0tifhxVtI02fvn/D9ieyPj1KMuor+BvNUSZluBSz9Pd+3UtSQxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SokcqLgS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SokcqLgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0D4C4CED1;
	Wed,  5 Mar 2025 18:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197606;
	bh=4NXEEjnTWuEYfPARI+kA8itXggOV/7Dpi5VwKM9SdKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SokcqLgSAuorWvZ4eThp7mSu6neVjioU6e5g4e8KHEjRTH0Qsw7DOIKGf9xAPRzKq
	 SH4VJJ6D93OzDHFkJgeVRCrHG0XxfXXY4eU093gmoZDnKU1E/tQCr1qsUgDG1sRjOi
	 aDcl7SBKu9iDiXAlFuwUZ5x83eK3dA8j+8IkgwtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/142] scsi: ufs: core: Fix ufshcd_is_ufs_dev_busy() and ufshcd_eh_timed_out()
Date: Wed,  5 Mar 2025 18:47:06 +0100
Message-ID: <20250305174500.632850081@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 4fa382be430421e1445f9c95c4dc9b7e0949ae8a ]

ufshcd_is_ufs_dev_busy(), ufshcd_print_host_state() and
ufshcd_eh_timed_out() are used in both modes (legacy mode and MCQ mode).
hba->outstanding_reqs only represents the outstanding requests in legacy
mode. Hence, change hba->outstanding_reqs into scsi_host_busy(hba->host) in
these functions.

Fixes: eacb139b77ff ("scsi: ufs: core: mcq: Enable multi-circular queue")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20250214224352.3025151-1-bvanassche@acm.org
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 24f8b74e166de..3412ac717807d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -245,7 +245,7 @@ static bool ufshcd_has_pending_tasks(struct ufs_hba *hba)
 
 static bool ufshcd_is_ufs_dev_busy(struct ufs_hba *hba)
 {
-	return hba->outstanding_reqs || ufshcd_has_pending_tasks(hba);
+	return scsi_host_busy(hba->host) || ufshcd_has_pending_tasks(hba);
 }
 
 static const struct ufs_dev_quirk ufs_fixups[] = {
@@ -616,8 +616,8 @@ static void ufshcd_print_host_state(struct ufs_hba *hba)
 	const struct scsi_device *sdev_ufs = hba->ufs_device_wlun;
 
 	dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
-	dev_err(hba->dev, "outstanding reqs=0x%lx tasks=0x%lx\n",
-		hba->outstanding_reqs, hba->outstanding_tasks);
+	dev_err(hba->dev, "%d outstanding reqs, tasks=0x%lx\n",
+		scsi_host_busy(hba->host), hba->outstanding_tasks);
 	dev_err(hba->dev, "saved_err=0x%x, saved_uic_err=0x%x\n",
 		hba->saved_err, hba->saved_uic_err);
 	dev_err(hba->dev, "Device power mode=%d, UIC link state=%d\n",
@@ -8973,7 +8973,7 @@ static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 	dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
 		 __func__, hba->outstanding_tasks);
 
-	return hba->outstanding_reqs ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
+	return scsi_host_busy(hba->host) ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
 }
 
 static const struct attribute_group *ufshcd_driver_groups[] = {
-- 
2.39.5



