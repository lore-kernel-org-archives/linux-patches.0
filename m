Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5903845C4;
	Tue, 16 Dec 2025 12:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888650; cv=none; b=N+/x12fsw7e3088To5lvgl6y/GUVEzMY+6iqMDX9ukGQuoQ8agZZ+giGFxGo0b6330E9pLi+nRkRjiXAKkF6c1UPZZcG939S6GV9xMslJ0QPRnNqmw4TRVW+5ewGIOvO8O29qd8rqOuVshPNDsjmuHeAyfX+kC+lM5K9WhHxG1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888650; c=relaxed/simple;
	bh=Wwzx13Q+qzm43yl6jA4HDDDmuFMHU8SFzx/an8AJjfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MR9QM29Hm67O2fWW1n0/pR3NW7Ohvzu6L3EPaX3QlI+idvbYEpWYnNYSyxBxrF6EyAcYgbHsa3t+EaqQiFr92E03FKez3/IHOdj+hUWIIoRvv/hM71nfH4Rfvs4wocaLNsP2V41MGb25LH2xLalKV2l2EYxL0W83Eag/AmOOJdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQCdk+0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQCdk+0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50751C4CEF5;
	Tue, 16 Dec 2025 12:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888649;
	bh=Wwzx13Q+qzm43yl6jA4HDDDmuFMHU8SFzx/an8AJjfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQCdk+0R0jQzcm7TmcsAFqVdegZK7SoFhSH91QijkhMUc5vPyi1VmWml00o05CN5d
	 TEG6vZxXPU7L5REv4SFp4Q6ZWrs9u0Fw5RvZw0zSY5xmlRdy5n77bYkuFRzMj4ZvEv
	 y+Eit2V1OazaxBZMyCuO7wNCMaci4rt/Qa7rqTQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Nitin Rawat <nitin.rawat@oss.qualcomm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 595/614] scsi: ufs: core: Fix an error handler crash
Date: Tue, 16 Dec 2025 12:16:02 +0100
Message-ID: <20251216111422.949196879@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 14be351e5cd07349377010e457a58fac99201832 ]

The UFS error handler may be activated before SCSI scanning has started
and hence before hba->ufs_device_wlun has been set. Check the
hba->ufs_device_wlun pointer before using it.

Cc: Peter Wang <peter.wang@mediatek.com>
Cc: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Fixes: e23ef4f22db3 ("scsi: ufs: core: Fix error handler host_sem issue")
Fixes: f966e02ae521 ("scsi: ufs: core: Fix runtime suspend error deadlock")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Tested-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com> #SM8750
Link: https://patch.msgid.link/20251204170457.994851-1-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 12f5a7a973128..a921a9098a291 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6670,19 +6670,22 @@ static void ufshcd_err_handler(struct work_struct *work)
 		 hba->saved_uic_err, hba->force_reset,
 		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
 
-	/*
-	 * Use ufshcd_rpm_get_noresume() here to safely perform link recovery
-	 * even if an error occurs during runtime suspend or runtime resume.
-	 * This avoids potential deadlocks that could happen if we tried to
-	 * resume the device while a PM operation is already in progress.
-	 */
-	ufshcd_rpm_get_noresume(hba);
-	if (hba->pm_op_in_progress) {
-		ufshcd_link_recovery(hba);
+	if (hba->ufs_device_wlun) {
+		/*
+		 * Use ufshcd_rpm_get_noresume() here to safely perform link
+		 * recovery even if an error occurs during runtime suspend or
+		 * runtime resume. This avoids potential deadlocks that could
+		 * happen if we tried to resume the device while a PM operation
+		 * is already in progress.
+		 */
+		ufshcd_rpm_get_noresume(hba);
+		if (hba->pm_op_in_progress) {
+			ufshcd_link_recovery(hba);
+			ufshcd_rpm_put(hba);
+			return;
+		}
 		ufshcd_rpm_put(hba);
-		return;
 	}
-	ufshcd_rpm_put(hba);
 
 	down(&hba->host_sem);
 	spin_lock_irqsave(hba->host->host_lock, flags);
-- 
2.51.0



