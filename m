Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60D560261;
	Tue, 23 Jan 2024 00:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970896; cv=none; b=r1bfHWLp1x6U5OIRRX/Q/Wo0y6nqlyyGAGOjB8gzOMFDBgxEyIUpHV/GOgEF2mH/9CtvmLTLXFkvZPhQVEqBhxaEA+ltT0jQT0vb+9qnkvFuim51jRNS7/Z6PZOc5aInmuJkx3OQVHN4W1HUTH4rqmlzhu+Mk5Ts97qjrgTm7fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970896; c=relaxed/simple;
	bh=SRha3E4JDEaq5CM0UWosQoFBR9YGPKldaoxUf+QAy94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uoNMxamfpUQlHFSbtwCN/X10WlKF/nbBkr2l7vFWU46YlJppq/tAq9/TlI4WZqhpKbB9w48fiuDHTn5axhoP2mx4sdbeuXYBR9RZmfAIR71Mr7JAuL9EfvL1Lhv5XmkDAsRgT1F9DIK10XAbPCNsDq7TpS3HKB1QkXyr7fiNb9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfjJUUzx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfjJUUzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0BDC43390;
	Tue, 23 Jan 2024 00:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970896;
	bh=SRha3E4JDEaq5CM0UWosQoFBR9YGPKldaoxUf+QAy94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfjJUUzxFAWRNuc8VeyjabVRNWYVgcpMyKxV4rkG8ta983GKPs4w0I/eObJOTy3YJ
	 TI6P60yQvbv66Gnb6YMGPbDOTgGUmmulJTXS4Qur3HCNmNeLOAmclBZDOhPDmyLqPq
	 sHSqx0/35EWlUUxx0RNUzSUmHrRKb4PQpOySeyS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/417] scsi: hisi_sas: Rollback some operations if FLR failed
Date: Mon, 22 Jan 2024 15:54:45 -0800
Message-ID: <20240122235755.833011436@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4f816b2cfa49..ee2065e83f9b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4946,6 +4946,7 @@ static void hisi_sas_reset_done_v3_hw(struct pci_dev *pdev)
 {
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
+	struct Scsi_Host *shost = hisi_hba->shost;
 	struct device *dev = hisi_hba->dev;
 	int rc;
 
@@ -4954,6 +4955,10 @@ static void hisi_sas_reset_done_v3_hw(struct pci_dev *pdev)
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



