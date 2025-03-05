Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E1F1946C3;
	Wed,  5 Mar 2025 18:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198387; cv=none; b=fFf0E7lPCHV9D1QPEft9MflkJ0LQ/oCcA9m6YeULouJ5UbW55WktHDej9JPzz8i/u2hGTkYIkkLGPYJiwljBVrRn2YQwsQc7AWT/iDR00kScrCNcVFiRtcSS4ZTkNWC0Xbr49qPMt3oQkkSJALNmgrKYYIh/9w8lnDSIRetFxwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198387; c=relaxed/simple;
	bh=ipQSn0OGg3+65ZQUvFPoi72XTu4yP1RJLLsE8wmuMSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuR51Zoe8v9QUfc3prK//GbfN1A7DZ+rnAekzB8OSM53yvMEoeSL/A+ItcCmKIw02f4C/DQG6aLao1Ri8m24grbsWqA/5F5oXblt+fHm3Wpom6Trtbf83hQvxG9MXE+DTfU96GcMMcMGJbNujxHL4veOfyxtDbds8AWFdGujO/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idv+uUIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idv+uUIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC6FC4CED1;
	Wed,  5 Mar 2025 18:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198387;
	bh=ipQSn0OGg3+65ZQUvFPoi72XTu4yP1RJLLsE8wmuMSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idv+uUIlBL99eUWLdSIAqaNL6Vjjg/q0FIFKOqdU+sFJnUXGN8X0ov1NnFcXWCtFU
	 DO5Ot+kfX8AGUXNQCDIFX2b+XhiiE/6rpVSJFuNF3lEXGVLgv4sspMcc3l215N6Gl3
	 d7bAoW50xJK+rM+9Ysu4QDSZ521n+lPBo5dsFSLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 011/157] scsi: ufs: core: Fix ufshcd_is_ufs_dev_busy() and ufshcd_eh_timed_out()
Date: Wed,  5 Mar 2025 18:47:27 +0100
Message-ID: <20250305174505.735027808@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 56b32d245c2ee..37b626e128f95 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -266,7 +266,7 @@ static bool ufshcd_has_pending_tasks(struct ufs_hba *hba)
 
 static bool ufshcd_is_ufs_dev_busy(struct ufs_hba *hba)
 {
-	return hba->outstanding_reqs || ufshcd_has_pending_tasks(hba);
+	return scsi_host_busy(hba->host) || ufshcd_has_pending_tasks(hba);
 }
 
 static const struct ufs_dev_quirk ufs_fixups[] = {
@@ -628,8 +628,8 @@ static void ufshcd_print_host_state(struct ufs_hba *hba)
 	const struct scsi_device *sdev_ufs = hba->ufs_device_wlun;
 
 	dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
-	dev_err(hba->dev, "outstanding reqs=0x%lx tasks=0x%lx\n",
-		hba->outstanding_reqs, hba->outstanding_tasks);
+	dev_err(hba->dev, "%d outstanding reqs, tasks=0x%lx\n",
+		scsi_host_busy(hba->host), hba->outstanding_tasks);
 	dev_err(hba->dev, "saved_err=0x%x, saved_uic_err=0x%x\n",
 		hba->saved_err, hba->saved_uic_err);
 	dev_err(hba->dev, "Device power mode=%d, UIC link state=%d\n",
@@ -8944,7 +8944,7 @@ static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 	dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
 		 __func__, hba->outstanding_tasks);
 
-	return hba->outstanding_reqs ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
+	return scsi_host_busy(hba->host) ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
 }
 
 static const struct attribute_group *ufshcd_driver_groups[] = {
-- 
2.39.5



