Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2752676E0;
	Tue,  8 Apr 2025 11:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110788; cv=none; b=Ks+DucTQZVwrCRP7lX9v6inMbiW7xNi1PlTXmkIbOQ0XRnXxHqSOk/IZdo3kpx+nWDnrvRUuhjSJ+LHQDflUd+/LySeSde+VmgSGiMp3qUKN4nzuZyOaO5MRfRlAQ9myvm0pSY4Na7lfER5UBJca/7o1s/tw4dGxc2n1r58mt0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110788; c=relaxed/simple;
	bh=3Iv1GQ+EtQc55In2DxJ7lDyZN5LW/7hdDCBgGqxpU5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2xJi+UMzrYKYeA4KXsH5QdpS1x9qT4jwjEFCCG5UWPoRLnkFhZYIN7mIjrCW+ywv56FawCbl/7jpUGd6LwyC5QDqwnkgwSAopRef+0D3cG4PoDdQm3dtaeLEVGop5MKwpEjgXB8MQKTnFolD2WomevWw//U/gOTIZYtsAxxZuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1u/8yb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1u/8yb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE33C4CEE5;
	Tue,  8 Apr 2025 11:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110788;
	bh=3Iv1GQ+EtQc55In2DxJ7lDyZN5LW/7hdDCBgGqxpU5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1u/8yb/gdwotMExs55N3vzx3DkFTBlMyLWYF67au55+l3rPUuvFTRfAKFwSEoxM9
	 wyac+TeAllwllqTjM2eYVOoJv6VvjBM+D0q9RrvKgNSc6Oj7OWgbWb7nmnrvui1Bt9
	 r/npIw4fcZizDrGmvNYb8d7dPYGsyJFK9jYs7UvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	Yihang Li <liyihang9@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 194/731] scsi: hisi_sas: Fixed failure to issue vendor specific commands
Date: Tue,  8 Apr 2025 12:41:31 +0200
Message-ID: <20250408104918.794242857@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 750d4fbe2c20e65d764c70afe2c9e6cfa874b044 ]

At present, we determine the protocol through the cmd type, but other cmd
types, such as vendor-specific commands, default to the PIO protocol.  This
strategy often causes the execution of different vendor-specific commands
to fail. In fact, for these commands, a better way is to use the protocol
configured by the command's tf to determine its protocol.

Fixes: 6f2ff1a1311e ("hisi_sas: add v2 path to send ATA command")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Link: https://lore.kernel.org/r/20250220090011.313848-1-liyihang9@huawei.com
Reviewed-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 +--
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 28 ++++++++++++++++++++++++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  4 +---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  4 +---
 4 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 2d438d722d0b4..e17f5d8226bf2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -633,8 +633,7 @@ extern struct dentry *hisi_sas_debugfs_dir;
 extern void hisi_sas_stop_phys(struct hisi_hba *hisi_hba);
 extern int hisi_sas_alloc(struct hisi_hba *hisi_hba);
 extern void hisi_sas_free(struct hisi_hba *hisi_hba);
-extern u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis,
-				int direction);
+extern u8 hisi_sas_get_ata_protocol(struct sas_task *task);
 extern struct hisi_sas_port *to_hisi_sas_port(struct asd_sas_port *sas_port);
 extern void hisi_sas_sata_done(struct sas_task *task,
 			    struct hisi_sas_slot *slot);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index da4a2ed8ee863..3596414d970b2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -21,8 +21,32 @@ struct hisi_sas_internal_abort_data {
 	bool rst_ha_timeout; /* reset the HA for timeout */
 };
 
-u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis, int direction)
+static u8 hisi_sas_get_ata_protocol_from_tf(struct ata_queued_cmd *qc)
 {
+	if (!qc)
+		return HISI_SAS_SATA_PROTOCOL_PIO;
+
+	switch (qc->tf.protocol) {
+	case ATA_PROT_NODATA:
+		return HISI_SAS_SATA_PROTOCOL_NONDATA;
+	case ATA_PROT_PIO:
+		return HISI_SAS_SATA_PROTOCOL_PIO;
+	case ATA_PROT_DMA:
+		return HISI_SAS_SATA_PROTOCOL_DMA;
+	case ATA_PROT_NCQ_NODATA:
+	case ATA_PROT_NCQ:
+		return HISI_SAS_SATA_PROTOCOL_FPDMA;
+	default:
+		return HISI_SAS_SATA_PROTOCOL_PIO;
+	}
+}
+
+u8 hisi_sas_get_ata_protocol(struct sas_task *task)
+{
+	struct host_to_dev_fis *fis = &task->ata_task.fis;
+	struct ata_queued_cmd *qc = task->uldd_task;
+	int direction = task->data_dir;
+
 	switch (fis->command) {
 	case ATA_CMD_FPDMA_WRITE:
 	case ATA_CMD_FPDMA_READ:
@@ -93,7 +117,7 @@ u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis, int direction)
 	{
 		if (direction == DMA_NONE)
 			return HISI_SAS_SATA_PROTOCOL_NONDATA;
-		return HISI_SAS_SATA_PROTOCOL_PIO;
+		return hisi_sas_get_ata_protocol_from_tf(qc);
 	}
 	}
 }
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 71cd5b4450c2b..6e7f99fcc8247 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2538,9 +2538,7 @@ static void prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 			(task->ata_task.fis.control & ATA_SRST))
 		dw1 |= 1 << CMD_HDR_RESET_OFF;
 
-	dw1 |= (hisi_sas_get_ata_protocol(
-		&task->ata_task.fis, task->data_dir))
-		<< CMD_HDR_FRAME_TYPE_OFF;
+	dw1 |= (hisi_sas_get_ata_protocol(task)) << CMD_HDR_FRAME_TYPE_OFF;
 	dw1 |= sas_dev->device_id << CMD_HDR_DEV_ID_OFF;
 	hdr->dw1 = cpu_to_le32(dw1);
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 48b95d9a79275..095bbf80c34ef 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1456,9 +1456,7 @@ static void prep_ata_v3_hw(struct hisi_hba *hisi_hba,
 			(task->ata_task.fis.control & ATA_SRST))
 		dw1 |= 1 << CMD_HDR_RESET_OFF;
 
-	dw1 |= (hisi_sas_get_ata_protocol(
-		&task->ata_task.fis, task->data_dir))
-		<< CMD_HDR_FRAME_TYPE_OFF;
+	dw1 |= (hisi_sas_get_ata_protocol(task)) << CMD_HDR_FRAME_TYPE_OFF;
 	dw1 |= sas_dev->device_id << CMD_HDR_DEV_ID_OFF;
 
 	if (FIS_CMD_IS_UNCONSTRAINED(task->ata_task.fis))
-- 
2.39.5



