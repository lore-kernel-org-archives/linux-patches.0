Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90211C6FF6;
	Wed,  5 Mar 2025 18:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198048; cv=none; b=heecRUyRTPCQuhDC5NF7/Mkn0mvkJIIK8Ae20j6nyqoRtfAsH/ddmtyx3/9OOsdQRd9NQsPl31ws4sdk346lRjb1hNPFtVFZpomh70sGzIh+sDzan5qPjFXMKasz/9qheF891om1YWdhqXo3vFsJR4h4UOtdF/bQZeQQAtkY8B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198048; c=relaxed/simple;
	bh=iTPQHxWpB0LbJOJbkvNXvJqU4uVqGXOpIrnXJudZC9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzD9F0GEgpQKrJtpOerLTBvfafc4gnQpRIYxIcQnBeme3kx5nsj1RZPLFXj0fAfdqe2yfDLbgMTRWcgbb27WuC7x9sogRTJKAJ596nLdHW88uafHNc1Vorv2L7O5ovlQfu2ZbTPJzaBY7RhP51RcBHpy7Uby80tZGYBQuXqi5Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mLobO3db; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mLobO3db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2206CC4CEE0;
	Wed,  5 Mar 2025 18:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198047;
	bh=iTPQHxWpB0LbJOJbkvNXvJqU4uVqGXOpIrnXJudZC9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mLobO3dbzqEHeHH5mdJqciJvXGlMW0Wf4Vlz3QzcOQZccjx7j7e/F2/WIzXcB0/xw
	 vjSSI5AIJUKtc///fUBTFJaayFlxPLW+sjwqOwrDlUKiNbkUL9y9u7xh6mZpgWz6sM
	 OqDxD3UXFRHoqDj7MP1jZr+3xdqSOTGIvkdhQn6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/150] scsi: ufs: core: Fix ufshcd_is_ufs_dev_busy() and ufshcd_eh_timed_out()
Date: Wed,  5 Mar 2025 18:47:23 +0100
Message-ID: <20250305174504.378931012@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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
index 67410c4cebee6..ff4878cf882be 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -266,7 +266,7 @@ static bool ufshcd_has_pending_tasks(struct ufs_hba *hba)
 
 static bool ufshcd_is_ufs_dev_busy(struct ufs_hba *hba)
 {
-	return hba->outstanding_reqs || ufshcd_has_pending_tasks(hba);
+	return scsi_host_busy(hba->host) || ufshcd_has_pending_tasks(hba);
 }
 
 static const struct ufs_dev_quirk ufs_fixups[] = {
@@ -639,8 +639,8 @@ static void ufshcd_print_host_state(struct ufs_hba *hba)
 	const struct scsi_device *sdev_ufs = hba->ufs_device_wlun;
 
 	dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
-	dev_err(hba->dev, "outstanding reqs=0x%lx tasks=0x%lx\n",
-		hba->outstanding_reqs, hba->outstanding_tasks);
+	dev_err(hba->dev, "%d outstanding reqs, tasks=0x%lx\n",
+		scsi_host_busy(hba->host), hba->outstanding_tasks);
 	dev_err(hba->dev, "saved_err=0x%x, saved_uic_err=0x%x\n",
 		hba->saved_err, hba->saved_uic_err);
 	dev_err(hba->dev, "Device power mode=%d, UIC link state=%d\n",
@@ -8975,7 +8975,7 @@ static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 	dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
 		 __func__, hba->outstanding_tasks);
 
-	return hba->outstanding_reqs ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
+	return scsi_host_busy(hba->host) ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
 }
 
 static const struct attribute_group *ufshcd_driver_groups[] = {
-- 
2.39.5



