Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFEA58AD2;
	Tue, 23 Jan 2024 01:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974088; cv=none; b=Ccpc8VOYVwUEnnKv99Ea3NXQiRPeLn4Fsi7LHj3BaaikFuzyslQu3R+bAs+VWlwV/dLngUerfYvD+Fyw3T8pdGTQkS3tds1ta35lI7b6bRWLOrOEKnjcWUq7BX4VPvNCUjy5A3X8bGQOPgk1s6cre9S/9M/C4aCc1+h/zDMXtDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974088; c=relaxed/simple;
	bh=xn7a7C4SC3tT9QLuiNkv92T5npghZuuypjXdYPt/6gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqBuEc3U9PuV5h70pN5TsRF0HGr8DrwfTp2XjKbENlT1RBZEEh6K0Y05H6wmqc1BjLkEkUQ9mEThItXvWDTLyVf9zTuvRUFPFii1aJM1wXP3K822pyRm2soEgeesZhmbbK8VnOdWHFKtKeI7SwUstbhDu7Qg4uM+7jrPw7cVI5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gA72h0Td; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gA72h0Td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463F9C43399;
	Tue, 23 Jan 2024 01:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974087;
	bh=xn7a7C4SC3tT9QLuiNkv92T5npghZuuypjXdYPt/6gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gA72h0TdapklBYiQOPzRVOPoHDrOJf7ES3IHPyPI9nPnY3obibOnIj2pIHPSqz8P6
	 Lpop6TpwyJA3e8585dVg/m38BHTbXXaMOukW0HGvHIRpn3BRPvypfOt/Xec1wI9TQt
	 4VlaYsToI6cOAXdpp/dqAWuh+mxm6dpCrOaY+UfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/374] scsi: hisi_sas: Rollback some operations if FLR failed
Date: Mon, 22 Jan 2024 15:56:41 -0800
Message-ID: <20240122235749.675446256@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 88af529ab100..4505310c0c3c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4948,6 +4948,7 @@ static void hisi_sas_reset_done_v3_hw(struct pci_dev *pdev)
 {
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
+	struct Scsi_Host *shost = hisi_hba->shost;
 	struct device *dev = hisi_hba->dev;
 	int rc;
 
@@ -4956,6 +4957,10 @@ static void hisi_sas_reset_done_v3_hw(struct pci_dev *pdev)
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



