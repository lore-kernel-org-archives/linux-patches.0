Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB21E6168A;
	Tue, 23 Jan 2024 01:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974945; cv=none; b=ozHUh2AkRYk6O8MrSSLIxLy0iOvl19OC76tHGEniXJMytHFeUUo86SvOvx/ij1jlCk0obnjyO+gjn4yWW5w6pSOPcX+tZQ7FFTIdoULq/oqO7gJ5soiyFy3BgaA4jzQqNYbsoXF1lUnG7Et4lziXPqWO6sBjxKICVrMQG+z8UY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974945; c=relaxed/simple;
	bh=nTzWqHn2STCqN2Td9mHisQPxHUw5dOESestZvFR4lhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLplthHSJ+GCr1g8qZyc0auIZwEPGyWthbUPoLcXlIU3VD2qTmF+u2Sq6xoWlWw/pknx3cMpKk+GiT9/2XOzFV6Uhl4GVHp+J6pipQNCUpb0IJ5gc/iO87KSXWhns23wolbSltwx2aGc3dpZFMANJoQ0uv19nYnG8A4oRzy40U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgd9/+U3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgd9/+U3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2B4C433F1;
	Tue, 23 Jan 2024 01:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974944;
	bh=nTzWqHn2STCqN2Td9mHisQPxHUw5dOESestZvFR4lhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tgd9/+U3rElgNt50pPD19T9YcYv5guO6JKLXyRyMuHUmbgicGeir8lOqWMlMCsNX5
	 OTxz8edQ9S9p3VJCdgRn1G5U7V38quNvFhaiDVEuMir8h/oOXcEOg5pIHa6/5ISD+C
	 fFGbP004EbgdWMb16gQoa07W6hADPC/K+M8dmfx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/583] scsi: hisi_sas: Rollback some operations if FLR failed
Date: Mon, 22 Jan 2024 15:53:33 -0800
Message-ID: <20240122235817.001579156@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit 7ea3e7763c50b20a8bd25cf524ea0c6463de69be ]

We obtain the semaphore and set HISI_SAS_RESETTING_BIT in
hisi_sas_reset_prepare_v3_hw(), block the scsi host and set
HISI_SAS_REJECT_CMD_BIT in hisi_sas_controller_reset_prepare(), released
them in hisi_sas_controller_reset_done(). However, if the HW reset failure
in FLR results in early return, the semaphore and flag bits will not be
release.

Rollback some operations including clearing flags / releasing semaphore
when FLR is failed.

Fixes: e5ea48014adc ("scsi: hisi_sas: Implement handlers of PCIe FLR for v3 hw")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1702525516-51258-5-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 568bd8052639..53c955c4f080 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -5098,6 +5098,7 @@ static void hisi_sas_reset_done_v3_hw(struct pci_dev *pdev)
 {
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
+	struct Scsi_Host *shost = hisi_hba->shost;
 	struct device *dev = hisi_hba->dev;
 	int rc;
 
@@ -5106,6 +5107,10 @@ static void hisi_sas_reset_done_v3_hw(struct pci_dev *pdev)
 	rc = hw_init_v3_hw(hisi_hba);
 	if (rc) {
 		dev_err(dev, "FLR: hw init failed rc=%d\n", rc);
+		clear_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
+		scsi_unblock_requests(shost);
+		clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
+		up(&hisi_hba->sem);
 		return;
 	}
 
-- 
2.43.0



